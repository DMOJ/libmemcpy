 .section .text

.globl __mempcpy_sse2_unaligned
__mempcpy_sse2_unaligned:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart

.globl __memmove_sse2_unaligned
__memmove_sse2_unaligned:
 movq %rdi, %rax
.Lstart:

 cmp $16, %rdx
 jb .Lless_vec

 movups (%rsi), %xmm0
 cmp $(16 * 2), %rdx
 ja .Lmore_2x_vec

 movups -16(%rsi,%rdx), %xmm1
 movups %xmm0, (%rdi)
 movups %xmm1, -16(%rdi,%rdx)

 ; ret

.globl __mempcpy_sse2_unaligned_erms
__mempcpy_sse2_unaligned_erms:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart_erms

.globl __memmove_sse2_unaligned_erms
__memmove_sse2_unaligned_erms:
 movq %rdi, %rax
.Lstart_erms:

 cmp $16, %rdx
 jb .Lless_vec

 movups (%rsi), %xmm0
 cmp $(16 * 2), %rdx
 ja .Lmovsb_more_2x_vec

 movups -16(%rsi, %rdx), %xmm1
 movups %xmm0, (%rdi)
 movups %xmm1, -16(%rdi, %rdx)
.Lreturn_vzeroupper:

 ret
 .p2align 4
.Lless_vec:
 cmpl $8, %edx
 jae .Lbetween_8_15

 cmpl $4, %edx

 jae .Lbetween_4_7
 cmpl $(1 - (0)), %edx
 jl .Lcopy_0
 movb (%rsi), %cl
 je .Lcopy_1
 movzwl (-2 + (0))(%rsi, %rdx), %esi
 movw %si, (-2 + (0))(%rdi, %rdx)
.Lcopy_1:
 movb %cl, (%rdi)
.Lcopy_0:
 ret

 .p2align 4,, 8
.Lbetween_4_7:

 movl -4(%rsi, %rdx), %ecx
 movl (%rsi), %esi
 movl %ecx, -4(%rdi, %rdx)
 movl %esi, (%rdi)
 ret
 .p2align 4,, 10
.Lbetween_8_15:

 movq -8(%rsi, %rdx), %rcx
 movq (%rsi), %rsi
 movq %rsi, (%rdi)
 movq %rcx, -8(%rdi, %rdx)
 ret

 .p2align 4,, 10
.Llast_4x_vec:

 movups -16(%rsi, %rdx), %xmm2
 movups -(16 * 2)(%rsi, %rdx), %xmm3
 movups %xmm0, (%rdi)
 movups %xmm1, 16(%rdi)
 movups %xmm2, -16(%rdi, %rdx)
 movups %xmm3, -(16 * 2)(%rdi, %rdx)
 ; ret

 .p2align 4

.Lmovsb_more_2x_vec:
 cmp __x86_rep_movsb_threshold(%rip), %rdx
 ja .Lmovsb

.Lmore_2x_vec:

 cmpq $(16 * 8), %rdx
 ja .Lmore_8x_vec

 movups 16(%rsi), %xmm1
 cmpq $(16 * 4), %rdx
 jbe .Llast_4x_vec

 movups (16 * 2)(%rsi), %xmm2
 movups (16 * 3)(%rsi), %xmm3
 movups -16(%rsi, %rdx), %xmm4
 movups -(16 * 2)(%rsi, %rdx), %xmm5
 movups -(16 * 3)(%rsi, %rdx), %xmm6
 movups -(16 * 4)(%rsi, %rdx), %xmm7
 movups %xmm0, (%rdi)
 movups %xmm1, 16(%rdi)
 movups %xmm2, (16 * 2)(%rdi)
 movups %xmm3, (16 * 3)(%rdi)
 movups %xmm4, -16(%rdi, %rdx)
 movups %xmm5, -(16 * 2)(%rdi, %rdx)
 movups %xmm6, -(16 * 3)(%rdi, %rdx)
 movups %xmm7, -(16 * 4)(%rdi, %rdx)
 ; ret

 .p2align 4,, 4
.Lmore_8x_vec:
 movq %rdi, %rcx
 subq %rsi, %rcx

 cmpq %rdx, %rcx

 jb .Lmore_8x_vec_backward_check_nop

 cmp __x86_shared_non_temporal_threshold(%rip), %rdx
 ja .Llarge_memcpy_2x
.Lmore_8x_vec_check:

 leaq (%rcx, %rdx), %r8

 xorq %rcx, %r8

 shrq $63, %r8

 andl $(4096 - 256), %ecx

 addl %r8d, %ecx
 jz .Lmore_8x_vec_backward

.Lmore_8x_vec_forward:

 movups -16(%rsi, %rdx), %xmm5
 movups -(16 * 2)(%rsi, %rdx), %xmm6

 movq %rdi, %rcx

 orq $(16 - 1), %rdi
 movups -(16 * 3)(%rsi, %rdx), %xmm7
 movups -(16 * 4)(%rsi, %rdx), %xmm8

 subq %rcx, %rsi

 incq %rdi

 addq %rdi, %rsi

 leaq (16 * -4)(%rcx, %rdx), %rdx

 .p2align 4,, 11
.Lloop_4x_vec_forward:

 movups (%rsi), %xmm1
 movups 16(%rsi), %xmm2
 movups (16 * 2)(%rsi), %xmm3
 movups (16 * 3)(%rsi), %xmm4
 subq $-(16 * 4), %rsi
 movaps %xmm1, (%rdi)
 movaps %xmm2, 16(%rdi)
 movaps %xmm3, (16 * 2)(%rdi)
 movaps %xmm4, (16 * 3)(%rdi)
 subq $-(16 * 4), %rdi
 cmpq %rdi, %rdx
 ja .Lloop_4x_vec_forward

 movups %xmm5, (16 * 3)(%rdx)
 movups %xmm6, (16 * 2)(%rdx)
 movups %xmm7, 16(%rdx)
 movups %xmm8, (%rdx)

 movups %xmm0, (%rcx)

.Lnop_backward:
 ; ret

 .p2align 4,, 8
.Lmore_8x_vec_backward_check_nop:

 testq %rcx, %rcx
 jz .Lnop_backward
.Lmore_8x_vec_backward:

 movups 16(%rsi), %xmm5
 movups (16 * 2)(%rsi), %xmm6

 leaq (16 * -4 + -1)(%rdi, %rdx), %rcx
 movups (16 * 3)(%rsi), %xmm7
 movups -16(%rsi, %rdx), %xmm8

 subq %rdi, %rsi

 andq $-(16), %rcx

 addq %rcx, %rsi

 .p2align 4,, 11
.Lloop_4x_vec_backward:

 movups (16 * 3)(%rsi), %xmm1
 movups (16 * 2)(%rsi), %xmm2
 movups (16 * 1)(%rsi), %xmm3
 movups (16 * 0)(%rsi), %xmm4
 addq $(16 * -4), %rsi
 movaps %xmm1, (16 * 3)(%rcx)
 movaps %xmm2, (16 * 2)(%rcx)
 movaps %xmm3, (16 * 1)(%rcx)
 movaps %xmm4, (16 * 0)(%rcx)
 addq $(16 * -4), %rcx
 cmpq %rcx, %rdi
 jb .Lloop_4x_vec_backward

 movups %xmm0, (%rdi)
 movups %xmm5, 16(%rdi)
 movups %xmm6, (16 * 2)(%rdi)
 movups %xmm7, (16 * 3)(%rdi)

 movups %xmm8, -16(%rdx, %rdi)
 ; ret

 .p2align 5,, 16
 .p2align 4,, 12
.Lmovsb:
 movq %rdi, %rcx
 subq %rsi, %rcx

 cmpq %rdx, %rcx

 jb .Lmore_8x_vec_backward_check_nop

 cmp __x86_rep_movsb_stop_threshold(%rip), %rdx
 jae .Llarge_memcpy_2x_check
.Lskip_short_movsb_check:
 mov %rdx, %rcx
 rep movsb
 ret

 .p2align 4,, 10

.Llarge_memcpy_2x_check:

.Llarge_memcpy_2x:
 mov __x86_shared_non_temporal_threshold(%rip), %r11
 cmp %r11, %rdx
 jb .Lmore_8x_vec_check

 negq %rcx
 cmpq %rcx, %rdx
 ja .Lmore_8x_vec_forward

 movups 16(%rsi), %xmm1

 movups (16 * 2)(%rsi), %xmm2
 movups (16 * 3)(%rsi), %xmm3

 movups %xmm0, (%rdi)

 movups %xmm1, 16(%rdi)

 movups %xmm2, (16 * 2)(%rdi)
 movups %xmm3, (16 * 3)(%rdi)

 movq %rdi, %r8
 andq $63, %r8

 subq $64, %r8

 subq %r8, %rsi

 subq %r8, %rdi

 addq %r8, %rdx

 notl %ecx
 movq %rdx, %r10
 testl $(4096 - 16 * 8), %ecx
 jz .Llarge_memcpy_4x

 shlq $4, %r11
 cmp %r11, %rdx
 jae .Llarge_memcpy_4x

 andl $(4096 * 2 - 1), %edx

 shrq $(12 + 1), %r10

 .p2align 4
.Lloop_large_memcpy_2x_outer:

 movl $(4096 / (16 * 4)), %ecx
.Lloop_large_memcpy_2x_inner:
 prefetcht0 ((16 * 4))(%rsi)
 prefetcht0 ((16 * 4) * 2)(%rsi)
 prefetcht0 (4096 + (16 * 4))(%rsi)
 prefetcht0 (4096 + (16 * 4) * 2)(%rsi)

 movups (0)(%rsi), %xmm0; movups ((0) + 16)(%rsi), %xmm1; movups ((0) + 16 * 2)(%rsi), %xmm2; movups ((0) + 16 * 3)(%rsi), %xmm3;
 movups (4096)(%rsi), %xmm4; movups ((4096) + 16)(%rsi), %xmm5; movups ((4096) + 16 * 2)(%rsi), %xmm6; movups ((4096) + 16 * 3)(%rsi), %xmm7;
 subq $-(16 * 4), %rsi

 movntdq %xmm0, (0)(%rdi); movntdq %xmm1, ((0) + 16)(%rdi); movntdq %xmm2, ((0) + 16 * 2)(%rdi); movntdq %xmm3, ((0) + 16 * 3)(%rdi);
 movntdq %xmm4, (4096)(%rdi); movntdq %xmm5, ((4096) + 16)(%rdi); movntdq %xmm6, ((4096) + 16 * 2)(%rdi); movntdq %xmm7, ((4096) + 16 * 3)(%rdi);
 subq $-(16 * 4), %rdi
 decl %ecx
 jnz .Lloop_large_memcpy_2x_inner
 addq $4096, %rdi
 addq $4096, %rsi
 decq %r10
 jne .Lloop_large_memcpy_2x_outer
 sfence

 cmpl $(16 * 4), %edx
 jbe .Llarge_memcpy_2x_end

.Lloop_large_memcpy_2x_tail:

 prefetcht0 ((16 * 4))(%rsi)
 prefetcht0 ((16 * 4))(%rdi)
 movups (%rsi), %xmm0
 movups 16(%rsi), %xmm1
 movups (16 * 2)(%rsi), %xmm2
 movups (16 * 3)(%rsi), %xmm3
 subq $-(16 * 4), %rsi
 addl $-(16 * 4), %edx
 movaps %xmm0, (%rdi)
 movaps %xmm1, 16(%rdi)
 movaps %xmm2, (16 * 2)(%rdi)
 movaps %xmm3, (16 * 3)(%rdi)
 subq $-(16 * 4), %rdi
 cmpl $(16 * 4), %edx
 ja .Lloop_large_memcpy_2x_tail

.Llarge_memcpy_2x_end:

 movups -(16 * 4)(%rsi, %rdx), %xmm0
 movups -(16 * 3)(%rsi, %rdx), %xmm1
 movups -(16 * 2)(%rsi, %rdx), %xmm2
 movups -16(%rsi, %rdx), %xmm3

 movups %xmm0, -(16 * 4)(%rdi, %rdx)
 movups %xmm1, -(16 * 3)(%rdi, %rdx)
 movups %xmm2, -(16 * 2)(%rdi, %rdx)
 movups %xmm3, -16(%rdi, %rdx)
 ; ret

 .p2align 4
.Llarge_memcpy_4x:

 andl $(4096 * 4 - 1), %edx

 shrq $(12 + 2), %r10

 .p2align 4
.Lloop_large_memcpy_4x_outer:

 movl $(4096 / (16 * 4)), %ecx
.Lloop_large_memcpy_4x_inner:

 prefetcht0 ((16 * 4))(%rsi)
 prefetcht0 (4096 + (16 * 4))(%rsi)
 prefetcht0 (4096 * 2 + (16 * 4))(%rsi)
 prefetcht0 (4096 * 3 + (16 * 4))(%rsi)

 movups (0)(%rsi), %xmm0; movups ((0) + 16)(%rsi), %xmm1; movups ((0) + 16 * 2)(%rsi), %xmm2; movups ((0) + 16 * 3)(%rsi), %xmm3;
 movups (4096)(%rsi), %xmm4; movups ((4096) + 16)(%rsi), %xmm5; movups ((4096) + 16 * 2)(%rsi), %xmm6; movups ((4096) + 16 * 3)(%rsi), %xmm7;
 movups (4096 * 2)(%rsi), %xmm8; movups ((4096 * 2) + 16)(%rsi), %xmm9; movups ((4096 * 2) + 16 * 2)(%rsi), %xmm10; movups ((4096 * 2) + 16 * 3)(%rsi), %xmm11;
 movups (4096 * 3)(%rsi), %xmm12; movups ((4096 * 3) + 16)(%rsi), %xmm13; movups ((4096 * 3) + 16 * 2)(%rsi), %xmm14; movups ((4096 * 3) + 16 * 3)(%rsi), %xmm15;
 subq $-(16 * 4), %rsi

 movntdq %xmm0, (0)(%rdi); movntdq %xmm1, ((0) + 16)(%rdi); movntdq %xmm2, ((0) + 16 * 2)(%rdi); movntdq %xmm3, ((0) + 16 * 3)(%rdi);
 movntdq %xmm4, (4096)(%rdi); movntdq %xmm5, ((4096) + 16)(%rdi); movntdq %xmm6, ((4096) + 16 * 2)(%rdi); movntdq %xmm7, ((4096) + 16 * 3)(%rdi);
 movntdq %xmm8, (4096 * 2)(%rdi); movntdq %xmm9, ((4096 * 2) + 16)(%rdi); movntdq %xmm10, ((4096 * 2) + 16 * 2)(%rdi); movntdq %xmm11, ((4096 * 2) + 16 * 3)(%rdi);
 movntdq %xmm12, (4096 * 3)(%rdi); movntdq %xmm13, ((4096 * 3) + 16)(%rdi); movntdq %xmm14, ((4096 * 3) + 16 * 2)(%rdi); movntdq %xmm15, ((4096 * 3) + 16 * 3)(%rdi);
 subq $-(16 * 4), %rdi
 decl %ecx
 jnz .Lloop_large_memcpy_4x_inner
 addq $(4096 * 3), %rdi
 addq $(4096 * 3), %rsi
 decq %r10
 jne .Lloop_large_memcpy_4x_outer
 sfence

 cmpl $(16 * 4), %edx
 jbe .Llarge_memcpy_4x_end

.Lloop_large_memcpy_4x_tail:

 prefetcht0 ((16 * 4))(%rsi)
 prefetcht0 ((16 * 4))(%rdi)
 movups (%rsi), %xmm0
 movups 16(%rsi), %xmm1
 movups (16 * 2)(%rsi), %xmm2
 movups (16 * 3)(%rsi), %xmm3
 subq $-(16 * 4), %rsi
 addl $-(16 * 4), %edx
 movaps %xmm0, (%rdi)
 movaps %xmm1, 16(%rdi)
 movaps %xmm2, (16 * 2)(%rdi)
 movaps %xmm3, (16 * 3)(%rdi)
 subq $-(16 * 4), %rdi
 cmpl $(16 * 4), %edx
 ja .Lloop_large_memcpy_4x_tail

.Llarge_memcpy_4x_end:

 movups -(16 * 4)(%rsi, %rdx), %xmm0
 movups -(16 * 3)(%rsi, %rdx), %xmm1
 movups -(16 * 2)(%rsi, %rdx), %xmm2
 movups -16(%rsi, %rdx), %xmm3

 movups %xmm0, -(16 * 4)(%rdi, %rdx)
 movups %xmm1, -(16 * 3)(%rdi, %rdx)
 movups %xmm2, -(16 * 2)(%rdi, %rdx)
 movups %xmm3, -16(%rdi, %rdx)
 ; ret

.globl __memcpy_sse2_unaligned_erms
.set __memcpy_sse2_unaligned_erms, __memmove_sse2_unaligned_erms

.globl __memcpy_sse2_unaligned
.set __memcpy_sse2_unaligned, __memmove_sse2_unaligned
