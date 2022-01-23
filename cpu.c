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


__attribute__((constructor))
static void init_cpu_flags(void) {
    // TODO: implement this.
}
