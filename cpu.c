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
}
