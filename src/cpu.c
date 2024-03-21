/**
 * libmemcpy
 * Copyright © 2022 Guanzhong Chen
 * Copyright © 2022 Tudor Brindus
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
 * USA
 */

#include "libmemcpy.h"

#include <cpuid.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#ifdef __MINGW64__
    #define HIDDEN
#else
    #define HIDDEN __attribute__((__visibility__("hidden")))
#endif

/* Data cache size for use in memory and string routines, typically
   L1 size, rounded to multiple of 256 bytes.  */
long int __x86_data_cache_size_half HIDDEN = 32 * 1024 / 2;
long int __x86_data_cache_size HIDDEN = 32 * 1024;

/* Shared cache size for use in memory and string routines, typically
   L2 or L3 size, rounded to multiple of 256 bytes.  */
long int __x86_shared_cache_size_half HIDDEN = 1024 * 1024 / 2;
long int __x86_shared_cache_size HIDDEN = 1024 * 1024;

/* Threshold to use non temporal store.  */
// Defaults to using 3/4 of shared cache size.
long int __x86_shared_non_temporal_threshold HIDDEN = 1024 * 1024 * 3 / 4;

/* Threshold to use Enhanced REP MOVSB.  */
long int __x86_rep_movsb_threshold HIDDEN = 2048;

/* Threshold to stop using Enhanced REP MOVSB.  */
// Defaults to non-temporal threshold.
long int __x86_rep_movsb_stop_threshold HIDDEN = 1024 * 1024 * 3 / 4;

/* A bit-wise OR of string/memory requirements for optimal performance
   e.g. X86_STRING_CONTROL_AVOID_SHORT_DISTANCE_REP_MOVSB.  These bits
   are used at runtime to tune implementation behavior.  */
int __x86_string_control HIDDEN;

union {
    uint32_t words[12];
    char name[48];
} brand;

enum vendor {
    VENDOR_INTEL,
    VENDOR_AMD,
    VENDOR_UNKNOWN,
};

static uint32_t max_cpuid;
static uint32_t max_ext;
static enum vendor vendor;
static uint32_t family;
static uint32_t model;
static uint32_t stepping;

static bool osxsave;
static bool ssse3;
static bool avx;
static bool avx2;
static bool avx512f;
static bool avx512er;
static bool avx512vl;
static bool avx512vnni;
static bool erms;
static bool fsrm;
static bool rtm;
static bool xmm;
static bool ymm;
static bool zmm;
static bool avx_fast_unaligned_load;
static bool prefer_no_avx512;
static bool prefer_no_vzeroupper;
static bool fast_unaligned_copy;
static bool fast_copy_backward;

#define BIT_XMM_STATE (1 << 1)
#define BIT_YMM_STATE (2 << 1)
#define BIT_OPMASK_STATE (1 << 5)
#define BIT_ZMM0_15_STATE (1 << 6)
#define BIT_ZMM16_31_STATE (1 << 7)

#define BITS_ALL_YMM_STATE (BIT_XMM_STATE | BIT_YMM_STATE)
#define BITS_ALL_ZMM_STATE \
    (BIT_OPMASK_STATE | BIT_ZMM0_15_STATE | BIT_ZMM16_31_STATE)

static void populate_features(uint32_t ecx, uint32_t edx) {
    osxsave = ecx & (1 << 27);
    ssse3 = ecx & (1 << 9);
    avx = ecx & (1 << 28);

    if (max_cpuid >= 7) {
        uint32_t eax, ebx;
        __cpuid_count(7, 0, eax, ebx, ecx, edx);

        avx2 = ebx & (1 << 5);
        avx512f = ebx & (1 << 16);
        avx512er = ebx & (1 << 27);
        avx512vl = ebx & (1 << 31);
        avx512vnni = ecx & (1 << 11);
        erms = ebx & (1 << 9);
        fsrm = edx & (1 << 4);
        rtm = (ebx & (1 << 11)) && !(edx & (1 << 11));
    }

    if (osxsave) {
        uint32_t xcrlow, xcrhigh;
        __asm__("xgetbv" : "=a"(xcrlow), "=d"(xcrhigh) : "c"(0));
        xmm = xcrlow & BIT_XMM_STATE;
        ymm = (xcrlow & BITS_ALL_YMM_STATE) == BITS_ALL_YMM_STATE;
        zmm = (xcrlow & BITS_ALL_ZMM_STATE) == BITS_ALL_ZMM_STATE;
    }

    prefer_no_avx512 = !avx512er && !avx512vnni;
    prefer_no_vzeroupper = avx512er || rtm;
    avx_fast_unaligned_load = avx && avx2 && ymm;

    // Based off of sysdeps/x86/cpu-features.c:init_cpu_features
    if (vendor == VENDOR_INTEL && family == 0x06) {
        switch (model) {
            case 0x1c:
            case 0x26:
                // Atom
                break;
            case 0x57:
                // Knights Landing. Enable Silvermont optimizations.
            case 0x7a:
                // Unaligned load versions are faster than SSSE3 on Goldmont Plus.
            case 0x5c:
            case 0x5f:
                // Unaligned load versions are faster than SSSE3 on Goldmont.
            case 0x4c:
            case 0x5a:
            case 0x75:
                // Airmont is a die shrink of Silvermont.
            case 0x37:
            case 0x4a:
            case 0x4d:
            case 0x5d:
                // Silvermont
                // Also: fast unaligned load, slow SSE 4.2
                fast_unaligned_copy = true;
                break;
            case 0x86:
            case 0x96:
            case 0x9c:
                // Tremont
                // Also: fast rep string, fast unaligned load
                fast_unaligned_copy = true;
                break;
            default:
                // Unknown family 0x06 processors. Assuming this is a Core
                // i3/i5/i7 processor if AVX is available.
                if (!avx)
                  break;
                // Fall through
            case 0x1a:
            case 0x1e:
            case 0x1f:
            case 0x25:
            case 0x2c:
            case 0x2e:
            case 0x2f:
                // Nehalem and Sandy Bridge
                fast_unaligned_copy = true;
                break;
        }
    }

    if (vendor == VENDOR_AMD && family == 0x15) {
        // Excavator
        if (model >= 0x60 && model <= 0x7f) {
            fast_copy_backward = true;
            avx_fast_unaligned_load = false;
        }
    }
}

static int64_t l1i_size = -1;
static int64_t l1i_line = -1;
static int64_t l1d_size = -1;
static int64_t l1d_assoc = -1;
static int64_t l1d_line = -1;
static int64_t l2_size = -1;
static int64_t l2_assoc = -1;
static int64_t l2_line = -1;
static int64_t l3_size = -1;
static int64_t l3_assoc = -1;
static int64_t l3_line = -1;

static int64_t data = -1;
static int64_t shared = -1;
static int64_t core = -1;

inline static int64_t decode_amd_assoc(uint64_t size, uint32_t reg) {
    switch ((reg >> 12) & 0xf) {
        case 0:
        case 1:
        case 2:
        case 4:
            return (reg >> 12) & 0xf;

        case 6: return 8;
        case 8: return 16;
        case 10: return 32;
        case 11: return 48;
        case 12: return 64;
        case 13: return 96;
        case 14: return 128;

        case 15:
            return size / (reg & 0xff);

        default:
            return 0;
    }
}

static void populate_amd_cache(void) {
    if (max_ext < 0x80000005)
        return;

    uint32_t eax;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    __cpuid(0x80000005, eax, ebx, ecx, edx);
    l1i_size = (edx >> 14) & 0x3fc00;
    l1i_line = edx & 0xff;

    l1d_size = (ecx >> 14) & 0x3fc00;
    l1d_assoc = (ecx & 0xff0000) == 0xff0000 ?
        (ecx >> 14) & 0x3fc00 :
        (ecx >> 16) & 0xff;
    l1d_line = ecx & 0xff;

    if (max_ext < 0x80000006)
        return;

    __cpuid(0x80000006, eax, ebx, ecx, edx);
    l2_size = (ecx & 0xf000) == 0 ? 0 : (ecx >> 6) & 0x3fffc00;
    l2_line = (ecx & 0xf000) == 0 ? 0 : ecx & 0xff;
    l2_assoc = decode_amd_assoc(l2_size, ecx);

    l3_size = (edx & 0xf000) == 0 ? 0 : (edx & 0x3ffc0000) << 1;
    l3_line = (edx & 0xf000) == 0 ? 0 : edx & 0xff;
    l3_assoc = decode_amd_assoc(l3_size, edx);

    data = l1d_size;
    core = l2_size;
    shared = l3_size;

    if (shared <= 0) {
        shared = core;
    } else {
        uint32_t threads = 0;

        if (max_ext >= 0x80000008) {
            // use APIC ID to find threads sharing L3
            __cpuid(0x80000008, eax, ebx, ecx, edx);
            threads = 1 << ((ecx >> 12) & 0x0f);
        }

        if (threads == 0 || family >= 0x17) {
            // use logical processor count if thread not available or Zen.
            __cpuid(0x1, eax, ebx, ecx, edx);

            if ((edx & (1 << 28)) != 0)
                threads = (ebx >> 16) & 0xff;
        }

        if (threads > 0)
            shared /= threads;

        if (family >= 0x17) {
            // For some reason, glibc uses the whole CCX's L3 cache.
            // I will not question this logic (see 59803e81).
            __cpuid_count(0x8000001D, 0x3, eax, ebx, ecx, edx);

            uint32_t threads_per_ccx = ((eax >> 14) & 0xfff) + 1;
            shared *= threads_per_ccx;
        } else {
            shared += core;
        }
    }
}

// BEGIN GENERATED CODE
memcpy_t *memcpy_fast;
memcpy_t *memmove_fast;
memcpy_t *mempcpy_fast;

static memcpy_t *memcpy_available[14];
static memcpy_t *memmove_available[14];
static memcpy_t *mempcpy_available[14];

static int memcpy_available_count;
static int memmove_available_count;
static int mempcpy_available_count;

memcpy_t **libmemcpy_memcpy_available(int *count) {
    if (count)
        *count = memcpy_available_count;
    return memcpy_available;
}

memcpy_t **libmemcpy_memmove_available(int *count) {
    if (count)
        *count = memmove_available_count;
    return memmove_available;
}

memcpy_t **libmemcpy_mempcpy_available(int *count) {
    if (count)
        *count = mempcpy_available_count;
    return mempcpy_available;
}
// END GENERATED CODE

#define CONCAT2(a, b) a ## b
#define CONCAT(a, b) CONCAT2(a, b)

#define FUNCTION memcpy
#include "select.h"
#undef FUNCTION

#define FUNCTION memmove
#include "select.h"
#undef FUNCTION

#define FUNCTION mempcpy
#include "select.h"
#undef FUNCTION

// From sysdeps/x86/sysdep.h
/* Avoid short distance REP MOVSB */
#define X86_STRING_CONTROL_AVOID_SHORT_DISTANCE_REP_MOVSB  (1 << 0)

__attribute__((constructor))
static void init_cpu_flags(void) {
    union {
        char id[12];
        struct {
            uint32_t ebx, edx, ecx;
        };
    } manufacturer;

    __cpuid(0, max_cpuid, manufacturer.ebx, manufacturer.ecx, manufacturer.edx);
    if (memcmp(manufacturer.id, "AuthenticAMD", 12) == 0)
        vendor = VENDOR_AMD;
    else if (memcmp(manufacturer.id, "GenuineIntel", 12) == 0)
        vendor = VENDOR_INTEL;
    else
        vendor = VENDOR_UNKNOWN;

    uint32_t eax, ebx, ecx, edx;
    __cpuid(0x80000000, max_ext, ebx, ecx, edx);

    if (max_cpuid >= 1) {
        __cpuid(1, eax, ebx, ecx, edx);
        family = (eax >> 8) & 0xf;
        model = (eax >> 4) & 0xf;
        model += (eax >> 12) & 0xf0;
        stepping = eax & 0xf;

        if (family == 0xf)
            family += (eax >> 20) & 0xf;

        populate_features(ecx, edx);
    }

    switch (vendor) {
        case VENDOR_AMD:
            populate_amd_cache();
            break;
        default:
            break;
    }

    if (max_ext >= 0x80000004) {
        __cpuid(0x80000002, brand.words[0], brand.words[1],
                brand.words[2], brand.words[3]);
        __cpuid(0x80000003, brand.words[4], brand.words[5],
                brand.words[6], brand.words[7]);
        __cpuid(0x80000004, brand.words[8], brand.words[9],
                brand.words[10], brand.words[11]);
    }

    if (data > 0xFF) {
        __x86_data_cache_size = data & ~0xFF;
        __x86_data_cache_size_half = __x86_data_cache_size / 2;
    }

    if (shared > 0xFF) {
        __x86_shared_cache_size = shared & ~0xFF;
        __x86_shared_cache_size_half = __x86_shared_cache_size / 2;
    }

    if (shared >= 0)
        __x86_shared_non_temporal_threshold = shared * 3 / 4;

    if (fsrm)
        __x86_rep_movsb_threshold = 2112;
    else if (avx_fast_unaligned_load)
        __x86_rep_movsb_threshold = 8192;

    if (vendor == VENDOR_AMD)
        __x86_rep_movsb_stop_threshold = core;
    else {
        __x86_rep_movsb_stop_threshold = __x86_shared_non_temporal_threshold;

        // avoid short distance rep movsb on processors with fsrm
        if (fsrm)
            __x86_string_control |=
                X86_STRING_CONTROL_AVOID_SHORT_DISTANCE_REP_MOVSB;
    }

    memcpy_fast = select_memcpy();
    memmove_fast = select_memmove();
    mempcpy_fast = select_mempcpy();

    memcpy_available_count = available_memcpy(memcpy_available);
    memmove_available_count = available_memmove(memmove_available);
    mempcpy_available_count = available_mempcpy(mempcpy_available);
}

void libmemcpy_report_cpu(void) {
    const char *vendor_name;

    switch (vendor) {
        case VENDOR_AMD:
            vendor_name = "AMD";
            break;
        case VENDOR_INTEL:
            vendor_name = "Intel";
            break;
        default:
            vendor_name = "Unknown";
    }

    printf("CPU: %s family %" PRIx32 "h, model %" PRIx32 "h, stepping %"
           PRIx32 "h\n", vendor_name, family, model, stepping);
    printf("Brand: %s\n", brand.name);
    printf("L1 instruction: %" PRId64 " bytes total, %" PRId64
            " bytes per line\n", l1i_size, l1i_line);
    printf("L1 data: %" PRId64 " bytes total, %" PRId64 " bytes per line, %"
           PRId64 "-way associative\n", l1d_size, l1d_line, l1d_assoc);
    printf("L2 data: %" PRId64 " bytes total, %" PRId64 " bytes per line, %"
           PRId64 "-way associative\n", l2_size, l2_line, l2_assoc);
    printf("L3 data: %" PRId64 " bytes total, %" PRId64 " bytes per line, %"
           PRId64 "-way associative\n", l3_size, l3_line, l3_assoc);
    printf("By usage: %" PRId64 " bytes data, %" PRId64 " bytes core, %" PRId64
           " bytes shared\n", data, core, shared);
    printf("AVX: %d, AVX2: %d, AVX512F: %d, AVX512VL: %d, ERMS: %d, FSRM: %d\n",
           avx, avx2, avx512f, avx512vl, erms, fsrm);
    printf("RTM: %d, XMM: %d, YMM: %d\n", rtm, xmm, ymm);
    printf("memcpy selected: %s\n", libmemcpy_memcpy_name(memcpy_fast));
    puts("memcpy available:");
    for (memcpy_t **func = memcpy_available; *func; ++func) {
        printf("  - %s\n", libmemcpy_memcpy_name(*func));
    }
}
