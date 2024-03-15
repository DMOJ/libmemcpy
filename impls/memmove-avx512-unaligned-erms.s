 .section .text.evex512

.globl __mempcpy_avx512_unaligned
__mempcpy_avx512_unaligned:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart

.globl __memmove_avx512_unaligned
__memmove_avx512_unaligned:
 movq %rdi, %rax
.Lstart:

 cmp $64, %rdx
 jb .Lless_vec

 vmovdqu64 (%rsi), %zmm16
 cmp $(64 * 2), %rdx
 ja .Lmore_2x_vec

 vmovdqu64 -64(%rsi,%rdx), %zmm17
 vmovdqu64 %zmm16, (%rdi)
 vmovdqu64 %zmm17, -64(%rdi,%rdx)

 ; ret

.globl __mempcpy_avx512_unaligned_erms
__mempcpy_avx512_unaligned_erms:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart_erms

.globl __memmove_avx512_unaligned_erms
__memmove_avx512_unaligned_erms:
 movq %rdi, %rax
.Lstart_erms:

 cmp $64, %rdx
 jb .Lless_vec

 vmovdqu64 (%rsi), %zmm16
 cmp $(64 * 2), %rdx
 ja .Lmovsb_more_2x_vec

 vmovdqu64 -64(%rsi, %rdx), %zmm17
 vmovdqu64 %zmm16, (%rdi)
 vmovdqu64 %zmm17, -64(%rdi, %rdx)
.Lreturn_vzeroupper:

 ; ret
 .p2align 4,, 8
.Lbetween_4_7:

 movl (%rsi), %ecx
 movl (%rsi, %rdx), %esi
 movl %ecx, (%rdi)
 movl %esi, (%rdi, %rdx)
 ret

 .p2align 4
.Lless_vec:

 cmpl $32, %edx
 jae .Lbetween_32_63

 cmpl $16, %edx
 jae .Lbetween_16_31

 cmpl $8, %edx
 jae .Lbetween_8_15

 subq $4, %rdx

 jae .Lbetween_4_7
 cmpl $(1 - (4)), %edx
 jl .Lcopy_0
 movb (%rsi), %cl
 je .Lcopy_1
 movzwl (-2 + (4))(%rsi, %rdx), %esi
 movw %si, (-2 + (4))(%rdi, %rdx)
.Lcopy_1:
 movb %cl, (%rdi)
.Lcopy_0:
 ret
 .p2align 4,, 8
.Lbetween_16_31:
 vmovdqu (%rsi), %xmm0
 vmovdqu -16(%rsi, %rdx), %xmm1
 vmovdqu %xmm0, (%rdi)
 vmovdqu %xmm1, -16(%rdi, %rdx)

 ret

 .p2align 4,, 10
.Lbetween_32_63:

 vmovdqu64 (%rsi), %ymm16
 vmovdqu64 -32(%rsi, %rdx), %ymm17
 vmovdqu64 %ymm16, (%rdi)
 vmovdqu64 %ymm17, -32(%rdi, %rdx)
 ; ret

 .p2align 4,, 10
.Lbetween_8_15:

 movq -8(%rsi, %rdx), %rcx
 movq (%rsi), %rsi
 movq %rsi, (%rdi)
 movq %rcx, -8(%rdi, %rdx)
 ret

 .p2align 4,, 10
.Llast_4x_vec:

 vmovdqu64 -64(%rsi, %rdx), %zmm18
 vmovdqu64 -(64 * 2)(%rsi, %rdx), %zmm19
 vmovdqu64 %zmm16, (%rdi)
 vmovdqu64 %zmm17, 64(%rdi)
 vmovdqu64 %zmm18, -64(%rdi, %rdx)
 vmovdqu64 %zmm19, -(64 * 2)(%rdi, %rdx)
 ; ret

 .p2align 4

.Lmovsb_more_2x_vec:
 cmp __x86_rep_movsb_threshold(%rip), %rdx
 ja .Lmovsb

.Lmore_2x_vec:

 cmpq $(64 * 8), %rdx
 ja .Lmore_8x_vec

 vmovdqu64 64(%rsi), %zmm17
 cmpq $(64 * 4), %rdx
 jbe .Llast_4x_vec

 vmovdqu64 (64 * 2)(%rsi), %zmm18
 vmovdqu64 (64 * 3)(%rsi), %zmm19
 vmovdqu64 -64(%rsi, %rdx), %zmm20
 vmovdqu64 -(64 * 2)(%rsi, %rdx), %zmm21
 vmovdqu64 -(64 * 3)(%rsi, %rdx), %zmm22
 vmovdqu64 -(64 * 4)(%rsi, %rdx), %zmm23
 vmovdqu64 %zmm16, (%rdi)
 vmovdqu64 %zmm17, 64(%rdi)
 vmovdqu64 %zmm18, (64 * 2)(%rdi)
 vmovdqu64 %zmm19, (64 * 3)(%rdi)
 vmovdqu64 %zmm20, -64(%rdi, %rdx)
 vmovdqu64 %zmm21, -(64 * 2)(%rdi, %rdx)
 vmovdqu64 %zmm22, -(64 * 3)(%rdi, %rdx)
 vmovdqu64 %zmm23, -(64 * 4)(%rdi, %rdx)
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

 vmovdqu64 -64(%rsi, %rdx), %zmm21
 vmovdqu64 -(64 * 2)(%rsi, %rdx), %zmm22

 movq %rdi, %rcx

 orq $(64 - 1), %rdi
 vmovdqu64 -(64 * 3)(%rsi, %rdx), %zmm23
 vmovdqu64 -(64 * 4)(%rsi, %rdx), %zmm24

 subq %rcx, %rsi

 incq %rdi

 addq %rdi, %rsi

 leaq (64 * -4)(%rcx, %rdx), %rdx

 .p2align 4,, 11
.Lloop_4x_vec_forward:

 vmovdqu64 (%rsi), %zmm17
 vmovdqu64 64(%rsi), %zmm18
 vmovdqu64 (64 * 2)(%rsi), %zmm19
 vmovdqu64 (64 * 3)(%rsi), %zmm20
 subq $-(64 * 4), %rsi
 vmovdqa64 %zmm17, (%rdi)
 vmovdqa64 %zmm18, 64(%rdi)
 vmovdqa64 %zmm19, (64 * 2)(%rdi)
 vmovdqa64 %zmm20, (64 * 3)(%rdi)
 subq $-(64 * 4), %rdi
 cmpq %rdi, %rdx
 ja .Lloop_4x_vec_forward

 vmovdqu64 %zmm21, (64 * 3)(%rdx)
 vmovdqu64 %zmm22, (64 * 2)(%rdx)
 vmovdqu64 %zmm23, 64(%rdx)
 vmovdqu64 %zmm24, (%rdx)

 vmovdqu64 %zmm16, (%rcx)

.Lnop_backward:
 ; ret

 .p2align 4,, 8
.Lmore_8x_vec_backward_check_nop:

 testq %rcx, %rcx
 jz .Lnop_backward
.Lmore_8x_vec_backward:

 vmovdqu64 64(%rsi), %zmm21
 vmovdqu64 (64 * 2)(%rsi), %zmm22

 leaq (64 * -4 + -1)(%rdi, %rdx), %rcx
 vmovdqu64 (64 * 3)(%rsi), %zmm23
 vmovdqu64 -64(%rsi, %rdx), %zmm24

 subq %rdi, %rsi

 andq $-(64), %rcx

 addq %rcx, %rsi

 .p2align 4,, 11
.Lloop_4x_vec_backward:

 vmovdqu64 (64 * 3)(%rsi), %zmm17
 vmovdqu64 (64 * 2)(%rsi), %zmm18
 vmovdqu64 (64 * 1)(%rsi), %zmm19
 vmovdqu64 (64 * 0)(%rsi), %zmm20
 addq $(64 * -4), %rsi
 vmovdqa64 %zmm17, (64 * 3)(%rcx)
 vmovdqa64 %zmm18, (64 * 2)(%rcx)
 vmovdqa64 %zmm19, (64 * 1)(%rcx)
 vmovdqa64 %zmm20, (64 * 0)(%rcx)
 addq $(64 * -4), %rcx
 cmpq %rcx, %rdi
 jb .Lloop_4x_vec_backward

 vmovdqu64 %zmm16, (%rdi)
 vmovdqu64 %zmm21, 64(%rdi)
 vmovdqu64 %zmm22, (64 * 2)(%rdi)
 vmovdqu64 %zmm23, (64 * 3)(%rdi)

 vmovdqu64 %zmm24, -64(%rdx, %rdi)
 ; ret

 .p2align 5,, 16

.Lskip_short_movsb_check:
 testl $(4096 - 512), %ecx
 jnz .Lmovsb_align_dst

 movq %rcx, %r9

 leaq -1(%rsi, %rdx), %rcx

 orq $(64 - 1), %rsi

 leaq 1(%rsi, %r9), %rdi
 subq %rsi, %rcx

 incq %rsi

 rep movsb

 vmovdqu64 %zmm16, (%r8)

 ; ret

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
.Lmovsb_align_dst:

 subq %rdi, %rsi

 addq $(64 - 1), %rdi

 leaq (%r8, %rdx), %rcx

 andq $-(64), %rdi

 addq %rdi, %rsi
 subq %rdi, %rcx

 rep movsb

 vmovdqu64 %zmm16, (%r8)

 ; ret
 .p2align 4,, 10

.Llarge_memcpy_2x_check:

.Llarge_memcpy_2x:
 mov __x86_shared_non_temporal_threshold(%rip), %r11
 cmp %r11, %rdx
 jb .Lmore_8x_vec_check

 negq %rcx
 cmpq %rcx, %rdx
 ja .Lmore_8x_vec_forward
 vmovdqu64 %zmm16, (%rdi)
 movq %rdi, %r8
 andq $63, %r8

 subq $64, %r8

 subq %r8, %rsi

 subq %r8, %rdi

 addq %r8, %rdx

 notl %ecx
 movq %rdx, %r10
 testl $(4096 - 64 * 8), %ecx
 jz .Llarge_memcpy_4x

 shlq $4, %r11
 cmp %r11, %rdx
 jae .Llarge_memcpy_4x

 andl $(4096 * 2 - 1), %edx

 shrq $(12 + 1), %r10

 .p2align 4
.Lloop_large_memcpy_2x_outer:

 movl $(4096 / (64 * 2)), %ecx
.Lloop_large_memcpy_2x_inner:
 prefetcht0 ((64 * 4))(%rsi); prefetcht0 ((64 * 4) + 1 * 64)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 ((64 * 4) * 2)(%rsi); prefetcht0 ((64 * 4) * 2 + 1 * 64)(%rsi); prefetcht0 ((64 * 4) * 2 + 1 * 64 * 2)(%rsi); prefetcht0 ((64 * 4) * 2 + 1 * 64 * 3)(%rsi)
 prefetcht0 (4096 + (64 * 4))(%rsi); prefetcht0 (4096 + (64 * 4) + 1 * 64)(%rsi); prefetcht0 (4096 + (64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 (4096 + (64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 (4096 + (64 * 4) * 2)(%rsi); prefetcht0 (4096 + (64 * 4) * 2 + 1 * 64)(%rsi); prefetcht0 (4096 + (64 * 4) * 2 + 1 * 64 * 2)(%rsi); prefetcht0 (4096 + (64 * 4) * 2 + 1 * 64 * 3)(%rsi)

 vmovdqu64 (0)(%rsi), %zmm16; vmovdqu64 ((0) + 64)(%rsi), %zmm17;
 vmovdqu64 (4096)(%rsi), %zmm20; vmovdqu64 ((4096) + 64)(%rsi), %zmm21;
 subq $-(64 * 2), %rsi

 vmovntdq %zmm16, (0)(%rdi); vmovntdq %zmm17, ((0) + 64)(%rdi);
 vmovntdq %zmm20, (4096)(%rdi); vmovntdq %zmm21, ((4096) + 64)(%rdi);
 subq $-(64 * 2), %rdi
 decl %ecx
 jnz .Lloop_large_memcpy_2x_inner
 addq $4096, %rdi
 addq $4096, %rsi
 decq %r10
 jne .Lloop_large_memcpy_2x_outer
 sfence

 cmpl $(64 * 4), %edx
 jbe .Llarge_memcpy_2x_end

.Lloop_large_memcpy_2x_tail:

 prefetcht0 ((64 * 4))(%rsi); prefetcht0 ((64 * 4) + 1 * 64)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 ((64 * 4))(%rdi); prefetcht0 ((64 * 4) + 1 * 64)(%rdi); prefetcht0 ((64 * 4) + 1 * 64 * 2)(%rdi); prefetcht0 ((64 * 4) + 1 * 64 * 3)(%rdi)
 vmovdqu64 (%rsi), %zmm16
 vmovdqu64 64(%rsi), %zmm17
 vmovdqu64 (64 * 2)(%rsi), %zmm18
 vmovdqu64 (64 * 3)(%rsi), %zmm19
 subq $-(64 * 4), %rsi
 addl $-(64 * 4), %edx
 vmovdqa64 %zmm16, (%rdi)
 vmovdqa64 %zmm17, 64(%rdi)
 vmovdqa64 %zmm18, (64 * 2)(%rdi)
 vmovdqa64 %zmm19, (64 * 3)(%rdi)
 subq $-(64 * 4), %rdi
 cmpl $(64 * 4), %edx
 ja .Lloop_large_memcpy_2x_tail

.Llarge_memcpy_2x_end:

 vmovdqu64 -(64 * 4)(%rsi, %rdx), %zmm16
 vmovdqu64 -(64 * 3)(%rsi, %rdx), %zmm17
 vmovdqu64 -(64 * 2)(%rsi, %rdx), %zmm18
 vmovdqu64 -64(%rsi, %rdx), %zmm19

 vmovdqu64 %zmm16, -(64 * 4)(%rdi, %rdx)
 vmovdqu64 %zmm17, -(64 * 3)(%rdi, %rdx)
 vmovdqu64 %zmm18, -(64 * 2)(%rdi, %rdx)
 vmovdqu64 %zmm19, -64(%rdi, %rdx)
 ; ret

 .p2align 4
.Llarge_memcpy_4x:

 andl $(4096 * 4 - 1), %edx

 shrq $(12 + 2), %r10

 .p2align 4
.Lloop_large_memcpy_4x_outer:

 movl $(4096 / (64 * 2)), %ecx
.Lloop_large_memcpy_4x_inner:

 prefetcht0 ((64 * 4))(%rsi); prefetcht0 ((64 * 4) + 1 * 64)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 (4096 + (64 * 4))(%rsi); prefetcht0 (4096 + (64 * 4) + 1 * 64)(%rsi); prefetcht0 (4096 + (64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 (4096 + (64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 (4096 * 2 + (64 * 4))(%rsi); prefetcht0 (4096 * 2 + (64 * 4) + 1 * 64)(%rsi); prefetcht0 (4096 * 2 + (64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 (4096 * 2 + (64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 (4096 * 3 + (64 * 4))(%rsi); prefetcht0 (4096 * 3 + (64 * 4) + 1 * 64)(%rsi); prefetcht0 (4096 * 3 + (64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 (4096 * 3 + (64 * 4) + 1 * 64 * 3)(%rsi)

 vmovdqu64 (0)(%rsi), %zmm16; vmovdqu64 ((0) + 64)(%rsi), %zmm17;
 vmovdqu64 (4096)(%rsi), %zmm20; vmovdqu64 ((4096) + 64)(%rsi), %zmm21;
 vmovdqu64 (4096 * 2)(%rsi), %zmm24; vmovdqu64 ((4096 * 2) + 64)(%rsi), %zmm25;
 vmovdqu64 (4096 * 3)(%rsi), %zmm28; vmovdqu64 ((4096 * 3) + 64)(%rsi), %zmm29;
 subq $-(64 * 2), %rsi

 vmovntdq %zmm16, (0)(%rdi); vmovntdq %zmm17, ((0) + 64)(%rdi);
 vmovntdq %zmm20, (4096)(%rdi); vmovntdq %zmm21, ((4096) + 64)(%rdi);
 vmovntdq %zmm24, (4096 * 2)(%rdi); vmovntdq %zmm25, ((4096 * 2) + 64)(%rdi);
 vmovntdq %zmm28, (4096 * 3)(%rdi); vmovntdq %zmm29, ((4096 * 3) + 64)(%rdi);
 subq $-(64 * 2), %rdi
 decl %ecx
 jnz .Lloop_large_memcpy_4x_inner
 addq $(4096 * 3), %rdi
 addq $(4096 * 3), %rsi
 decq %r10
 jne .Lloop_large_memcpy_4x_outer
 sfence

 cmpl $(64 * 4), %edx
 jbe .Llarge_memcpy_4x_end

.Lloop_large_memcpy_4x_tail:

 prefetcht0 ((64 * 4))(%rsi); prefetcht0 ((64 * 4) + 1 * 64)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 2)(%rsi); prefetcht0 ((64 * 4) + 1 * 64 * 3)(%rsi)
 prefetcht0 ((64 * 4))(%rdi); prefetcht0 ((64 * 4) + 1 * 64)(%rdi); prefetcht0 ((64 * 4) + 1 * 64 * 2)(%rdi); prefetcht0 ((64 * 4) + 1 * 64 * 3)(%rdi)
 vmovdqu64 (%rsi), %zmm16
 vmovdqu64 64(%rsi), %zmm17
 vmovdqu64 (64 * 2)(%rsi), %zmm18
 vmovdqu64 (64 * 3)(%rsi), %zmm19
 subq $-(64 * 4), %rsi
 addl $-(64 * 4), %edx
 vmovdqa64 %zmm16, (%rdi)
 vmovdqa64 %zmm17, 64(%rdi)
 vmovdqa64 %zmm18, (64 * 2)(%rdi)
 vmovdqa64 %zmm19, (64 * 3)(%rdi)
 subq $-(64 * 4), %rdi
 cmpl $(64 * 4), %edx
 ja .Lloop_large_memcpy_4x_tail

.Llarge_memcpy_4x_end:

 vmovdqu64 -(64 * 4)(%rsi, %rdx), %zmm16
 vmovdqu64 -(64 * 3)(%rsi, %rdx), %zmm17
 vmovdqu64 -(64 * 2)(%rsi, %rdx), %zmm18
 vmovdqu64 -64(%rsi, %rdx), %zmm19

 vmovdqu64 %zmm16, -(64 * 4)(%rdi, %rdx)
 vmovdqu64 %zmm17, -(64 * 3)(%rdi, %rdx)
 vmovdqu64 %zmm18, -(64 * 2)(%rdi, %rdx)
 vmovdqu64 %zmm19, -64(%rdi, %rdx)
 ; ret

.globl __memcpy_avx512_unaligned_erms
.set __memcpy_avx512_unaligned_erms, __memmove_avx512_unaligned_erms

.globl __memcpy_avx512_unaligned
.set __memcpy_avx512_unaligned, __memmove_avx512_unaligned
