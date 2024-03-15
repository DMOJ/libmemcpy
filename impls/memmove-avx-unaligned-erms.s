 .section .text.avx

.globl __mempcpy_avx_unaligned
__mempcpy_avx_unaligned:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart

.globl __memmove_avx_unaligned
__memmove_avx_unaligned:
 movq %rdi, %rax
.Lstart:

 cmp $32, %rdx
 jb .Lless_vec

 vmovdqu (%rsi), %ymm0
 cmp $(32 * 2), %rdx
 ja .Lmore_2x_vec

 vmovdqu -32(%rsi,%rdx), %ymm1
 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm1, -32(%rdi,%rdx)

 vzeroupper; ret

.globl __mempcpy_avx_unaligned_erms
__mempcpy_avx_unaligned_erms:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart_erms

.globl __memmove_avx_unaligned_erms
__memmove_avx_unaligned_erms:
 movq %rdi, %rax
.Lstart_erms:

 cmp $32, %rdx
 jb .Lless_vec

 vmovdqu (%rsi), %ymm0
 cmp $(32 * 2), %rdx
 ja .Lmovsb_more_2x_vec

 vmovdqu -32(%rsi, %rdx), %ymm1
 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm1, -32(%rdi, %rdx)
.Lreturn_vzeroupper:

 vzeroupper; ret
 .p2align 4
.Lless_vec:
 cmpl $16, %edx
 jae .Lbetween_16_31

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

 .p2align 4,, 8
.Lbetween_16_31:
 vmovdqu (%rsi), %xmm0
 vmovdqu -16(%rsi, %rdx), %xmm1
 vmovdqu %xmm0, (%rdi)
 vmovdqu %xmm1, -16(%rdi, %rdx)

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

 vmovdqu -32(%rsi, %rdx), %ymm2
 vmovdqu -(32 * 2)(%rsi, %rdx), %ymm3
 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm1, 32(%rdi)
 vmovdqu %ymm2, -32(%rdi, %rdx)
 vmovdqu %ymm3, -(32 * 2)(%rdi, %rdx)
 vzeroupper; ret

 .p2align 4

.Lmovsb_more_2x_vec:
 cmp __x86_rep_movsb_threshold(%rip), %rdx
 ja .Lmovsb

.Lmore_2x_vec:

 cmpq $(32 * 8), %rdx
 ja .Lmore_8x_vec

 vmovdqu 32(%rsi), %ymm1
 cmpq $(32 * 4), %rdx
 jbe .Llast_4x_vec

 vmovdqu (32 * 2)(%rsi), %ymm2
 vmovdqu (32 * 3)(%rsi), %ymm3
 vmovdqu -32(%rsi, %rdx), %ymm4
 vmovdqu -(32 * 2)(%rsi, %rdx), %ymm5
 vmovdqu -(32 * 3)(%rsi, %rdx), %ymm6
 vmovdqu -(32 * 4)(%rsi, %rdx), %ymm7
 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm1, 32(%rdi)
 vmovdqu %ymm2, (32 * 2)(%rdi)
 vmovdqu %ymm3, (32 * 3)(%rdi)
 vmovdqu %ymm4, -32(%rdi, %rdx)
 vmovdqu %ymm5, -(32 * 2)(%rdi, %rdx)
 vmovdqu %ymm6, -(32 * 3)(%rdi, %rdx)
 vmovdqu %ymm7, -(32 * 4)(%rdi, %rdx)
 vzeroupper; ret

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

 vmovdqu -32(%rsi, %rdx), %ymm5
 vmovdqu -(32 * 2)(%rsi, %rdx), %ymm6

 movq %rdi, %rcx

 orq $(32 - 1), %rdi
 vmovdqu -(32 * 3)(%rsi, %rdx), %ymm7
 vmovdqu -(32 * 4)(%rsi, %rdx), %ymm8

 subq %rcx, %rsi

 incq %rdi

 addq %rdi, %rsi

 leaq (32 * -4)(%rcx, %rdx), %rdx

 .p2align 4,, 11
.Lloop_4x_vec_forward:

 vmovdqu (%rsi), %ymm1
 vmovdqu 32(%rsi), %ymm2
 vmovdqu (32 * 2)(%rsi), %ymm3
 vmovdqu (32 * 3)(%rsi), %ymm4
 subq $-(32 * 4), %rsi
 vmovdqa %ymm1, (%rdi)
 vmovdqa %ymm2, 32(%rdi)
 vmovdqa %ymm3, (32 * 2)(%rdi)
 vmovdqa %ymm4, (32 * 3)(%rdi)
 subq $-(32 * 4), %rdi
 cmpq %rdi, %rdx
 ja .Lloop_4x_vec_forward

 vmovdqu %ymm5, (32 * 3)(%rdx)
 vmovdqu %ymm6, (32 * 2)(%rdx)
 vmovdqu %ymm7, 32(%rdx)
 vmovdqu %ymm8, (%rdx)

 vmovdqu %ymm0, (%rcx)

.Lnop_backward:
 vzeroupper; ret

 .p2align 4,, 8
.Lmore_8x_vec_backward_check_nop:

 testq %rcx, %rcx
 jz .Lnop_backward
.Lmore_8x_vec_backward:

 vmovdqu 32(%rsi), %ymm5
 vmovdqu (32 * 2)(%rsi), %ymm6

 leaq (32 * -4 + -1)(%rdi, %rdx), %rcx
 vmovdqu (32 * 3)(%rsi), %ymm7
 vmovdqu -32(%rsi, %rdx), %ymm8

 subq %rdi, %rsi

 andq $-(32), %rcx

 addq %rcx, %rsi

 .p2align 4,, 11
.Lloop_4x_vec_backward:

 vmovdqu (32 * 3)(%rsi), %ymm1
 vmovdqu (32 * 2)(%rsi), %ymm2
 vmovdqu (32 * 1)(%rsi), %ymm3
 vmovdqu (32 * 0)(%rsi), %ymm4
 addq $(32 * -4), %rsi
 vmovdqa %ymm1, (32 * 3)(%rcx)
 vmovdqa %ymm2, (32 * 2)(%rcx)
 vmovdqa %ymm3, (32 * 1)(%rcx)
 vmovdqa %ymm4, (32 * 0)(%rcx)
 addq $(32 * -4), %rcx
 cmpq %rcx, %rdi
 jb .Lloop_4x_vec_backward

 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm5, 32(%rdi)
 vmovdqu %ymm6, (32 * 2)(%rdi)
 vmovdqu %ymm7, (32 * 3)(%rdi)

 vmovdqu %ymm8, -32(%rdx, %rdi)
 vzeroupper; ret

 .p2align 5,, 16

.Lskip_short_movsb_check:

 vmovdqu 32(%rsi), %ymm1

 testl $(4096 - 512), %ecx
 jnz .Lmovsb_align_dst

 movq %rcx, %r9

 leaq -1(%rsi, %rdx), %rcx

 orq $(64 - 1), %rsi

 leaq 1(%rsi, %r9), %rdi
 subq %rsi, %rcx

 incq %rsi

 rep movsb

 vmovdqu %ymm0, (%r8)

 vmovdqu %ymm1, 32(%r8)

 vzeroupper; ret

 .p2align 4,, 12
.Lmovsb:
 movq %rdi, %rcx
 subq %rsi, %rcx

 cmpq %rdx, %rcx

 jb .Lmore_8x_vec_backward_check_nop

 movq %rdi, %r8

 cmp __x86_rep_movsb_stop_threshold(%rip), %rdx
 jae .Llarge_memcpy_2x_check

 testb $(1 << 0), __x86_string_control(%rip)

 jz .Lskip_short_movsb_check
 cmpl $-64, %ecx
 ja .Lmore_8x_vec_forward

 vmovdqu 32(%rsi), %ymm1

.Lmovsb_align_dst:

 subq %rdi, %rsi

 addq $(64 - 1), %rdi

 leaq (%r8, %rdx), %rcx

 andq $-(64), %rdi

 addq %rdi, %rsi
 subq %rdi, %rcx

 rep movsb

 vmovdqu %ymm0, (%r8)

 vmovdqu %ymm1, 32(%r8)

 vzeroupper; ret
 .p2align 4,, 10

.Llarge_memcpy_2x_check:

.Llarge_memcpy_2x:
 mov __x86_shared_non_temporal_threshold(%rip), %r11
 cmp %r11, %rdx
 jb .Lmore_8x_vec_check

 negq %rcx
 cmpq %rcx, %rdx
 ja .Lmore_8x_vec_forward

 vmovdqu 32(%rsi), %ymm1

 vmovdqu %ymm0, (%rdi)

 vmovdqu %ymm1, 32(%rdi)

 movq %rdi, %r8
 andq $63, %r8

 subq $64, %r8

 subq %r8, %rsi

 subq %r8, %rdi

 addq %r8, %rdx

 notl %ecx
 movq %rdx, %r10
 testl $(4096 - 32 * 8), %ecx
 jz .Llarge_memcpy_4x

 shlq $4, %r11
 cmp %r11, %rdx
 jae .Llarge_memcpy_4x

 andl $(4096 * 2 - 1), %edx

 shrq $(12 + 1), %r10

 .p2align 4
.Lloop_large_memcpy_2x_outer:

 movl $(4096 / (32 * 4)), %ecx
.Lloop_large_memcpy_2x_inner:
 prefetcht0 ((32 * 4))(%rsi); prefetcht0 ((32 * 4) + 1 * 64)(%rsi)
 prefetcht0 ((32 * 4) * 2)(%rsi); prefetcht0 ((32 * 4) * 2 + 1 * 64)(%rsi)
 prefetcht0 (4096 + (32 * 4))(%rsi); prefetcht0 (4096 + (32 * 4) + 1 * 64)(%rsi)
 prefetcht0 (4096 + (32 * 4) * 2)(%rsi); prefetcht0 (4096 + (32 * 4) * 2 + 1 * 64)(%rsi)

 vmovdqu (0)(%rsi), %ymm0; vmovdqu ((0) + 32)(%rsi), %ymm1; vmovdqu ((0) + 32 * 2)(%rsi), %ymm2; vmovdqu ((0) + 32 * 3)(%rsi), %ymm3;
 vmovdqu (4096)(%rsi), %ymm4; vmovdqu ((4096) + 32)(%rsi), %ymm5; vmovdqu ((4096) + 32 * 2)(%rsi), %ymm6; vmovdqu ((4096) + 32 * 3)(%rsi), %ymm7;
 subq $-(32 * 4), %rsi

 vmovntdq %ymm0, (0)(%rdi); vmovntdq %ymm1, ((0) + 32)(%rdi); vmovntdq %ymm2, ((0) + 32 * 2)(%rdi); vmovntdq %ymm3, ((0) + 32 * 3)(%rdi);
 vmovntdq %ymm4, (4096)(%rdi); vmovntdq %ymm5, ((4096) + 32)(%rdi); vmovntdq %ymm6, ((4096) + 32 * 2)(%rdi); vmovntdq %ymm7, ((4096) + 32 * 3)(%rdi);
 subq $-(32 * 4), %rdi
 decl %ecx
 jnz .Lloop_large_memcpy_2x_inner
 addq $4096, %rdi
 addq $4096, %rsi
 decq %r10
 jne .Lloop_large_memcpy_2x_outer
 sfence

 cmpl $(32 * 4), %edx
 jbe .Llarge_memcpy_2x_end

.Lloop_large_memcpy_2x_tail:

 prefetcht0 ((32 * 4))(%rsi); prefetcht0 ((32 * 4) + 1 * 64)(%rsi)
 prefetcht0 ((32 * 4))(%rdi); prefetcht0 ((32 * 4) + 1 * 64)(%rdi)
 vmovdqu (%rsi), %ymm0
 vmovdqu 32(%rsi), %ymm1
 vmovdqu (32 * 2)(%rsi), %ymm2
 vmovdqu (32 * 3)(%rsi), %ymm3
 subq $-(32 * 4), %rsi
 addl $-(32 * 4), %edx
 vmovdqa %ymm0, (%rdi)
 vmovdqa %ymm1, 32(%rdi)
 vmovdqa %ymm2, (32 * 2)(%rdi)
 vmovdqa %ymm3, (32 * 3)(%rdi)
 subq $-(32 * 4), %rdi
 cmpl $(32 * 4), %edx
 ja .Lloop_large_memcpy_2x_tail

.Llarge_memcpy_2x_end:

 vmovdqu -(32 * 4)(%rsi, %rdx), %ymm0
 vmovdqu -(32 * 3)(%rsi, %rdx), %ymm1
 vmovdqu -(32 * 2)(%rsi, %rdx), %ymm2
 vmovdqu -32(%rsi, %rdx), %ymm3

 vmovdqu %ymm0, -(32 * 4)(%rdi, %rdx)
 vmovdqu %ymm1, -(32 * 3)(%rdi, %rdx)
 vmovdqu %ymm2, -(32 * 2)(%rdi, %rdx)
 vmovdqu %ymm3, -32(%rdi, %rdx)
 vzeroupper; ret

 .p2align 4
.Llarge_memcpy_4x:

 andl $(4096 * 4 - 1), %edx

 shrq $(12 + 2), %r10

 .p2align 4
.Lloop_large_memcpy_4x_outer:

 movl $(4096 / (32 * 4)), %ecx
.Lloop_large_memcpy_4x_inner:

 prefetcht0 ((32 * 4))(%rsi); prefetcht0 ((32 * 4) + 1 * 64)(%rsi)
 prefetcht0 (4096 + (32 * 4))(%rsi); prefetcht0 (4096 + (32 * 4) + 1 * 64)(%rsi)
 prefetcht0 (4096 * 2 + (32 * 4))(%rsi); prefetcht0 (4096 * 2 + (32 * 4) + 1 * 64)(%rsi)
 prefetcht0 (4096 * 3 + (32 * 4))(%rsi); prefetcht0 (4096 * 3 + (32 * 4) + 1 * 64)(%rsi)

 vmovdqu (0)(%rsi), %ymm0; vmovdqu ((0) + 32)(%rsi), %ymm1; vmovdqu ((0) + 32 * 2)(%rsi), %ymm2; vmovdqu ((0) + 32 * 3)(%rsi), %ymm3;
 vmovdqu (4096)(%rsi), %ymm4; vmovdqu ((4096) + 32)(%rsi), %ymm5; vmovdqu ((4096) + 32 * 2)(%rsi), %ymm6; vmovdqu ((4096) + 32 * 3)(%rsi), %ymm7;
 vmovdqu (4096 * 2)(%rsi), %ymm8; vmovdqu ((4096 * 2) + 32)(%rsi), %ymm9; vmovdqu ((4096 * 2) + 32 * 2)(%rsi), %ymm10; vmovdqu ((4096 * 2) + 32 * 3)(%rsi), %ymm11;
 vmovdqu (4096 * 3)(%rsi), %ymm12; vmovdqu ((4096 * 3) + 32)(%rsi), %ymm13; vmovdqu ((4096 * 3) + 32 * 2)(%rsi), %ymm14; vmovdqu ((4096 * 3) + 32 * 3)(%rsi), %ymm15;
 subq $-(32 * 4), %rsi

 vmovntdq %ymm0, (0)(%rdi); vmovntdq %ymm1, ((0) + 32)(%rdi); vmovntdq %ymm2, ((0) + 32 * 2)(%rdi); vmovntdq %ymm3, ((0) + 32 * 3)(%rdi);
 vmovntdq %ymm4, (4096)(%rdi); vmovntdq %ymm5, ((4096) + 32)(%rdi); vmovntdq %ymm6, ((4096) + 32 * 2)(%rdi); vmovntdq %ymm7, ((4096) + 32 * 3)(%rdi);
 vmovntdq %ymm8, (4096 * 2)(%rdi); vmovntdq %ymm9, ((4096 * 2) + 32)(%rdi); vmovntdq %ymm10, ((4096 * 2) + 32 * 2)(%rdi); vmovntdq %ymm11, ((4096 * 2) + 32 * 3)(%rdi);
 vmovntdq %ymm12, (4096 * 3)(%rdi); vmovntdq %ymm13, ((4096 * 3) + 32)(%rdi); vmovntdq %ymm14, ((4096 * 3) + 32 * 2)(%rdi); vmovntdq %ymm15, ((4096 * 3) + 32 * 3)(%rdi);
 subq $-(32 * 4), %rdi
 decl %ecx
 jnz .Lloop_large_memcpy_4x_inner
 addq $(4096 * 3), %rdi
 addq $(4096 * 3), %rsi
 decq %r10
 jne .Lloop_large_memcpy_4x_outer
 sfence

 cmpl $(32 * 4), %edx
 jbe .Llarge_memcpy_4x_end

.Lloop_large_memcpy_4x_tail:

 prefetcht0 ((32 * 4))(%rsi); prefetcht0 ((32 * 4) + 1 * 64)(%rsi)
 prefetcht0 ((32 * 4))(%rdi); prefetcht0 ((32 * 4) + 1 * 64)(%rdi)
 vmovdqu (%rsi), %ymm0
 vmovdqu 32(%rsi), %ymm1
 vmovdqu (32 * 2)(%rsi), %ymm2
 vmovdqu (32 * 3)(%rsi), %ymm3
 subq $-(32 * 4), %rsi
 addl $-(32 * 4), %edx
 vmovdqa %ymm0, (%rdi)
 vmovdqa %ymm1, 32(%rdi)
 vmovdqa %ymm2, (32 * 2)(%rdi)
 vmovdqa %ymm3, (32 * 3)(%rdi)
 subq $-(32 * 4), %rdi
 cmpl $(32 * 4), %edx
 ja .Lloop_large_memcpy_4x_tail

.Llarge_memcpy_4x_end:

 vmovdqu -(32 * 4)(%rsi, %rdx), %ymm0
 vmovdqu -(32 * 3)(%rsi, %rdx), %ymm1
 vmovdqu -(32 * 2)(%rsi, %rdx), %ymm2
 vmovdqu -32(%rsi, %rdx), %ymm3

 vmovdqu %ymm0, -(32 * 4)(%rdi, %rdx)
 vmovdqu %ymm1, -(32 * 3)(%rdi, %rdx)
 vmovdqu %ymm2, -(32 * 2)(%rdi, %rdx)
 vmovdqu %ymm3, -32(%rdi, %rdx)
 vzeroupper; ret

.globl __memcpy_avx_unaligned_erms
.set __memcpy_avx_unaligned_erms, __memmove_avx_unaligned_erms

.globl __memcpy_avx_unaligned
.set __memcpy_avx_unaligned, __memmove_avx_unaligned
