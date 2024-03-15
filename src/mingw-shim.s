	.global	memcpy_avx512_no_vzeroupper
memcpy_avx512_no_vzeroupper:
	pushq	%rdi
	pushq	%rsi
	movq	%rcx, %rdi
	movq	%rdx, %rsi
	movq	%r8,  %rdx
	subq	$168, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm9, 48(%rsp)
	movdqa	%xmm10, 64(%rsp)
	movdqa	%xmm11, 80(%rsp)
	movdqa	%xmm12, 96(%rsp)
	movdqa	%xmm13, 112(%rsp)
	movdqa	%xmm14, 128(%rsp)
	movdqa	%xmm15, 144(%rsp)
	call	__memcpy_avx512_no_vzeroupper
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm9
	movdqa	64(%rsp), %xmm10
	movdqa	80(%rsp), %xmm11
	movdqa	96(%rsp), %xmm12
	movdqa	112(%rsp), %xmm13
	movdqa	128(%rsp), %xmm14
	movdqa	144(%rsp), %xmm15
	addq	$168, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memcpy_avx_unaligned
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memcpy_avx_unaligned_erms
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memcpy_avx_unaligned_erms_rtm
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memcpy_avx_unaligned_rtm
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memcpy_sse2_unaligned
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memcpy_sse2_unaligned_erms
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$104, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm9, 48(%rsp)
	movdqa	%xmm10, 64(%rsp)
	movdqa	%xmm11, 80(%rsp)
	call	__memcpy_ssse3
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm9
	movdqa	64(%rsp), %xmm10
	movdqa	80(%rsp), %xmm11
	addq	$104, %rsp
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
	subq	$168, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm9, 48(%rsp)
	movdqa	%xmm10, 64(%rsp)
	movdqa	%xmm11, 80(%rsp)
	movdqa	%xmm12, 96(%rsp)
	movdqa	%xmm13, 112(%rsp)
	movdqa	%xmm14, 128(%rsp)
	movdqa	%xmm15, 144(%rsp)
	call	__memmove_avx512_no_vzeroupper
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm9
	movdqa	64(%rsp), %xmm10
	movdqa	80(%rsp), %xmm11
	movdqa	96(%rsp), %xmm12
	movdqa	112(%rsp), %xmm13
	movdqa	128(%rsp), %xmm14
	movdqa	144(%rsp), %xmm15
	addq	$168, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memmove_avx_unaligned
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memmove_avx_unaligned_erms
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memmove_avx_unaligned_erms_rtm
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memmove_avx_unaligned_rtm
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memmove_sse2_unaligned
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__memmove_sse2_unaligned_erms
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$104, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm9, 48(%rsp)
	movdqa	%xmm10, 64(%rsp)
	movdqa	%xmm11, 80(%rsp)
	call	__memmove_ssse3
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm9
	movdqa	64(%rsp), %xmm10
	movdqa	80(%rsp), %xmm11
	addq	$104, %rsp
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
	subq	$168, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm9, 48(%rsp)
	movdqa	%xmm10, 64(%rsp)
	movdqa	%xmm11, 80(%rsp)
	movdqa	%xmm12, 96(%rsp)
	movdqa	%xmm13, 112(%rsp)
	movdqa	%xmm14, 128(%rsp)
	movdqa	%xmm15, 144(%rsp)
	call	__mempcpy_avx512_no_vzeroupper
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm9
	movdqa	64(%rsp), %xmm10
	movdqa	80(%rsp), %xmm11
	movdqa	96(%rsp), %xmm12
	movdqa	112(%rsp), %xmm13
	movdqa	128(%rsp), %xmm14
	movdqa	144(%rsp), %xmm15
	addq	$168, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__mempcpy_avx_unaligned
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__mempcpy_avx_unaligned_erms
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__mempcpy_avx_unaligned_erms_rtm
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__mempcpy_avx_unaligned_rtm
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__mempcpy_sse2_unaligned
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$72, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm12, 48(%rsp)
	call	__mempcpy_sse2_unaligned_erms
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm12
	addq	$72, %rsp
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
	subq	$104, %rsp
	movdqa	%xmm6, 0(%rsp)
	movdqa	%xmm7, 16(%rsp)
	movdqa	%xmm8, 32(%rsp)
	movdqa	%xmm9, 48(%rsp)
	movdqa	%xmm10, 64(%rsp)
	movdqa	%xmm11, 80(%rsp)
	call	__mempcpy_ssse3
	movdqa	0(%rsp), %xmm6
	movdqa	16(%rsp), %xmm7
	movdqa	32(%rsp), %xmm8
	movdqa	48(%rsp), %xmm9
	movdqa	64(%rsp), %xmm10
	movdqa	80(%rsp), %xmm11
	addq	$104, %rsp
	popq	%rsi
	popq	%rdi
	ret

