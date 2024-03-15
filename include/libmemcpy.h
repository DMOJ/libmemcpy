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

#ifndef _LIBMEMCPY_H_
#define _LIBMEMCPY_H_

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void *memcpy_t(void *dst, const void *src, size_t len);

// BEGIN GENERATED CODE

#ifndef __MINGW32__
#define memcpy_avx512_no_vzeroupper __memcpy_avx512_no_vzeroupper
#define memcpy_avx512_unaligned __memcpy_avx512_unaligned
#define memcpy_avx512_unaligned_erms __memcpy_avx512_unaligned_erms
#define memcpy_avx_unaligned __memcpy_avx_unaligned
#define memcpy_avx_unaligned_erms __memcpy_avx_unaligned_erms
#define memcpy_avx_unaligned_erms_rtm __memcpy_avx_unaligned_erms_rtm
#define memcpy_avx_unaligned_rtm __memcpy_avx_unaligned_rtm
#define memcpy_erms __memcpy_erms
#define memcpy_evex_unaligned __memcpy_evex_unaligned
#define memcpy_evex_unaligned_erms __memcpy_evex_unaligned_erms
#define memcpy_sse2_unaligned __memcpy_sse2_unaligned
#define memcpy_sse2_unaligned_erms __memcpy_sse2_unaligned_erms
#define memcpy_ssse3 __memcpy_ssse3
#define memmove_avx512_no_vzeroupper __memmove_avx512_no_vzeroupper
#define memmove_avx512_unaligned __memmove_avx512_unaligned
#define memmove_avx512_unaligned_erms __memmove_avx512_unaligned_erms
#define memmove_avx_unaligned __memmove_avx_unaligned
#define memmove_avx_unaligned_erms __memmove_avx_unaligned_erms
#define memmove_avx_unaligned_erms_rtm __memmove_avx_unaligned_erms_rtm
#define memmove_avx_unaligned_rtm __memmove_avx_unaligned_rtm
#define memmove_erms __memmove_erms
#define memmove_evex_unaligned __memmove_evex_unaligned
#define memmove_evex_unaligned_erms __memmove_evex_unaligned_erms
#define memmove_sse2_unaligned __memmove_sse2_unaligned
#define memmove_sse2_unaligned_erms __memmove_sse2_unaligned_erms
#define memmove_ssse3 __memmove_ssse3
#define mempcpy_avx512_no_vzeroupper __mempcpy_avx512_no_vzeroupper
#define mempcpy_avx512_unaligned __mempcpy_avx512_unaligned
#define mempcpy_avx512_unaligned_erms __mempcpy_avx512_unaligned_erms
#define mempcpy_avx_unaligned __mempcpy_avx_unaligned
#define mempcpy_avx_unaligned_erms __mempcpy_avx_unaligned_erms
#define mempcpy_avx_unaligned_erms_rtm __mempcpy_avx_unaligned_erms_rtm
#define mempcpy_avx_unaligned_rtm __mempcpy_avx_unaligned_rtm
#define mempcpy_erms __mempcpy_erms
#define mempcpy_evex_unaligned __mempcpy_evex_unaligned
#define mempcpy_evex_unaligned_erms __mempcpy_evex_unaligned_erms
#define mempcpy_sse2_unaligned __mempcpy_sse2_unaligned
#define mempcpy_sse2_unaligned_erms __mempcpy_sse2_unaligned_erms
#define mempcpy_ssse3 __mempcpy_ssse3
#endif

memcpy_t memcpy_avx512_no_vzeroupper;
memcpy_t memcpy_avx512_unaligned;
memcpy_t memcpy_avx512_unaligned_erms;
memcpy_t memcpy_avx_unaligned;
memcpy_t memcpy_avx_unaligned_erms;
memcpy_t memcpy_avx_unaligned_erms_rtm;
memcpy_t memcpy_avx_unaligned_rtm;
memcpy_t memcpy_erms;
memcpy_t memcpy_evex_unaligned;
memcpy_t memcpy_evex_unaligned_erms;
memcpy_t memcpy_sse2_unaligned;
memcpy_t memcpy_sse2_unaligned_erms;
memcpy_t memcpy_ssse3;
memcpy_t memmove_avx512_no_vzeroupper;
memcpy_t memmove_avx512_unaligned;
memcpy_t memmove_avx512_unaligned_erms;
memcpy_t memmove_avx_unaligned;
memcpy_t memmove_avx_unaligned_erms;
memcpy_t memmove_avx_unaligned_erms_rtm;
memcpy_t memmove_avx_unaligned_rtm;
memcpy_t memmove_erms;
memcpy_t memmove_evex_unaligned;
memcpy_t memmove_evex_unaligned_erms;
memcpy_t memmove_sse2_unaligned;
memcpy_t memmove_sse2_unaligned_erms;
memcpy_t memmove_ssse3;
memcpy_t mempcpy_avx512_no_vzeroupper;
memcpy_t mempcpy_avx512_unaligned;
memcpy_t mempcpy_avx512_unaligned_erms;
memcpy_t mempcpy_avx_unaligned;
memcpy_t mempcpy_avx_unaligned_erms;
memcpy_t mempcpy_avx_unaligned_erms_rtm;
memcpy_t mempcpy_avx_unaligned_rtm;
memcpy_t mempcpy_erms;
memcpy_t mempcpy_evex_unaligned;
memcpy_t mempcpy_evex_unaligned_erms;
memcpy_t mempcpy_sse2_unaligned;
memcpy_t mempcpy_sse2_unaligned_erms;
memcpy_t mempcpy_ssse3;

extern memcpy_t *memcpy_fast;
extern memcpy_t *memmove_fast;
extern memcpy_t *mempcpy_fast;

const char *libmemcpy_memcpy_name(memcpy_t *func);
const char *libmemcpy_memmove_name(memcpy_t *func);
const char *libmemcpy_mempcpy_name(memcpy_t *func);

memcpy_t **libmemcpy_memcpy_available(int *count);
memcpy_t **libmemcpy_memmove_available(int *count);
memcpy_t **libmemcpy_mempcpy_available(int *count);

// END GENERATED CODE

void libmemcpy_report_cpu(void);

#ifdef __cplusplus
}
#endif

#endif /* _LIBMEMCPY_H_ */
