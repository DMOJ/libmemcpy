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

#include <cpuid.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

/* Data cache size for use in memory and string routines, typically
   L1 size, rounded to multiple of 256 bytes.  */
long int __x86_data_cache_size_half = 32 * 1024 / 2;
long int __x86_data_cache_size = 32 * 1024;

/* Shared cache size for use in memory and string routines, typically
   L2 or L3 size, rounded to multiple of 256 bytes.  */
long int __x86_shared_cache_size_half = 1024 * 1024 / 2;
long int __x86_shared_cache_size = 1024 * 1024;

/* Threshold to use non temporal store.  */
// Defaults to using 3/4 of shared cache size.
long int __x86_shared_non_temporal_threshold = 1024 * 1024 * 3 / 4;

/* Threshold to use Enhanced REP MOVSB.  */
long int __x86_rep_movsb_threshold = 2048;

/* Threshold to use Enhanced REP STOSB.  */
long int __x86_rep_stosb_threshold = 2048;

/* Threshold to stop using Enhanced REP MOVSB.  */
// Defaults to non-temporal threshold.
long int __x86_rep_movsb_stop_threshold = 1024 * 1024 * 3 / 4;

/* A bit-wise OR of string/memory requirements for optimal performance
   e.g. X86_STRING_CONTROL_AVOID_SHORT_DISTANCE_REP_MOVSB.  These bits
   are used at runtime to tune implementation behavior.  */
int __x86_string_control;

union manufacturer {
    char id[12];
    struct {
        uint32_t ebx, edx, ecx;
    };
};

enum vendor {
    VENDOR_INTEL,
    VENDOR_AMD,
    VENDOR_UNKNOWN,
};

static enum vendor vendor;
static uint32_t family;
static uint32_t model;
static uint32_t stepping;

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
    uint32_t max_ext;

    uint32_t eax;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    __cpuid(0x80000000, max_ext, ebx, ecx, edx);

    if (max_ext < 0x80000005)
        return;

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

__attribute__((constructor))
static void init_cpu_flags(void) {
    uint32_t max_cpuid;
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
    if (max_cpuid >= 1) {
        __cpuid(1, eax, ebx, ecx, edx);
        family = (eax >> 8) & 0xf;
        model = (eax >> 4) & 0xf;
        stepping = eax & 0xf;

        if (family == 0xf) {
            family += (eax >> 20) & 0xf;
            model += (eax >> 12) & 0xf0;
        }
    }

    switch (vendor) {
        case VENDOR_AMD:
            populate_amd_cache();
            break;
        default:
            break;
    }

    // TODO: implement cache size detection.
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
    printf("L1 data: %" PRId64 " bytes total, %" PRId64 " bytes per line\n",
           l1i_size, l1i_line);
    printf("L1 data: %" PRId64 " bytes total, %" PRId64 " bytes per line, %"
           PRId64 "-way associative\n", l1d_size, l1d_line, l1d_assoc);
    printf("L2 data: %" PRId64 " bytes total, %" PRId64 " bytes per line, %"
           PRId64 "-way associative\n", l2_size, l2_line, l2_assoc);
    printf("L3 data: %" PRId64 " bytes total, %" PRId64 " bytes per line, %"
           PRId64 "-way associative\n", l3_size, l3_line, l3_assoc);
    printf("By usage: %" PRId64 " bytes data, %" PRId64 " bytes core, %" PRId64
           " bytes shared\n", data, core, shared);
}