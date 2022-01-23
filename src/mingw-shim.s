	.global	memcpy_avx512_no_vzeroupper
memcpy_avx512_no_vzeroupper:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx512_no_vzeroupper
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_avx512_unaligned
memcpy_avx512_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx512_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_avx512_unaligned_erms
memcpy_avx512_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx512_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_avx_unaligned
memcpy_avx_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_avx_unaligned_erms
memcpy_avx_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_avx_unaligned_erms_rtm
memcpy_avx_unaligned_erms_rtm:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx_unaligned_erms_rtm
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_avx_unaligned_rtm
memcpy_avx_unaligned_rtm:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_avx_unaligned_rtm
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_erms
memcpy_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_evex_unaligned
memcpy_evex_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_evex_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_evex_unaligned_erms
memcpy_evex_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_evex_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_sse2_unaligned
memcpy_sse2_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_sse2_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_sse2_unaligned_erms
memcpy_sse2_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_sse2_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_ssse3
memcpy_ssse3:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_ssse3
	popq	%rsi
	popq	%rdi
	ret

	.global	memcpy_ssse3_back
memcpy_ssse3_back:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memcpy_ssse3_back
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx512_no_vzeroupper
memmove_avx512_no_vzeroupper:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx512_no_vzeroupper
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx512_unaligned
memmove_avx512_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx512_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx512_unaligned_erms
memmove_avx512_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx512_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx_unaligned
memmove_avx_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx_unaligned_erms
memmove_avx_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx_unaligned_erms_rtm
memmove_avx_unaligned_erms_rtm:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx_unaligned_erms_rtm
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_avx_unaligned_rtm
memmove_avx_unaligned_rtm:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_avx_unaligned_rtm
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_erms
memmove_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_evex_unaligned
memmove_evex_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_evex_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_evex_unaligned_erms
memmove_evex_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_evex_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_sse2_unaligned
memmove_sse2_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_sse2_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_sse2_unaligned_erms
memmove_sse2_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_sse2_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_ssse3
memmove_ssse3:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_ssse3
	popq	%rsi
	popq	%rdi
	ret

	.global	memmove_ssse3_back
memmove_ssse3_back:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__memmove_ssse3_back
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx512_no_vzeroupper
mempcpy_avx512_no_vzeroupper:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx512_no_vzeroupper
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx512_unaligned
mempcpy_avx512_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx512_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx512_unaligned_erms
mempcpy_avx512_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx512_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx_unaligned
mempcpy_avx_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx_unaligned_erms
mempcpy_avx_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx_unaligned_erms_rtm
mempcpy_avx_unaligned_erms_rtm:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx_unaligned_erms_rtm
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_avx_unaligned_rtm
mempcpy_avx_unaligned_rtm:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_avx_unaligned_rtm
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_erms
mempcpy_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_evex_unaligned
mempcpy_evex_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_evex_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_evex_unaligned_erms
mempcpy_evex_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_evex_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_sse2_unaligned
mempcpy_sse2_unaligned:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_sse2_unaligned
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_sse2_unaligned_erms
mempcpy_sse2_unaligned_erms:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_sse2_unaligned_erms
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_ssse3
mempcpy_ssse3:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_ssse3
	popq	%rsi
	popq	%rdi
	ret

	.global	mempcpy_ssse3_back
mempcpy_ssse3_back:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	call	__mempcpy_ssse3_back
	popq	%rsi
	popq	%rdi
	ret

