 .section .text.evex

.globl __mempcpy_evex_unaligned
__mempcpy_evex_unaligned:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart

.globl __memmove_evex_unaligned
__memmove_evex_unaligned:
 movq %rdi, %rax
.Lstart:

 cmp $32, %rdx
 jb .Lless_vec

 vmovdqu64 (%rsi), %ymm16
 cmp $(32 * 2), %rdx
 ja .Lmore_2x_vec

 vmovdqu64 -32(%rsi,%rdx), %ymm17
 vmovdqu64 %ymm16, (%rdi)
 vmovdqu64 %ymm17, -32(%rdi,%rdx)

 ; ret

.globl __mempcpy_evex_unaligned_erms
__mempcpy_evex_unaligned_erms:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart_erms

.globl __memmove_evex_unaligned_erms
__memmove_evex_unaligned_erms:
 movq %rdi, %rax
.Lstart_erms:

 cmp $32, %rdx
 jb .Lless_vec

 vmovdqu64 (%rsi), %ymm16
 cmp $(32 * 2), %rdx
 ja .Lmovsb_more_2x_vec

 vmovdqu64 -32(%rsi, %rdx), %ymm17
 vmovdqu64 %ymm16, (%rdi)
 vmovdqu64 %ymm17, -32(%rdi, %rdx)
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
.Lbetween_8_15:

 movq -8(%rsi, %rdx), %rcx
 movq (%rsi), %rsi
 movq %rsi, (%rdi)
 movq %rcx, -8(%rdi, %rdx)
 ret

 .p2align 4,, 10
.Llast_4x_vec:

 vmovdqu64 -32(%rsi, %rdx), %ymm18
 vmovdqu64 -(32 * 2)(%rsi, %rdx), %ymm19
 vmovdqu64 %ymm16, (%rdi)
 vmovdqu64 %ymm17, 32(%rdi)
 vmovdqu64 %ymm18, -32(%rdi, %rdx)
 vmovdqu64 %ymm19, -(32 * 2)(%rdi, %rdx)
 ; ret

 .p2align 4

.Lmovsb_more_2x_vec:
 cmp __x86_rep_movsb_threshold(%rip), %rdx
 ja .Lmovsb

.Lmore_2x_vec:

 cmpq $(32 * 8), %rdx
 ja .Lmore_8x_vec

 vmovdqu64 32(%rsi), %ymm17
 cmpq $(32 * 4), %rdx
 jbe .Llast_4x_vec

 vmovdqu64 (32 * 2)(%rsi), %ymm18
 vmovdqu64 (32 * 3)(%rsi), %ymm19
 vmovdqu64 -32(%rsi, %rdx), %ymm20
 vmovdqu64 -(32 * 2)(%rsi, %rdx), %ymm21
 vmovdqu64 -(32 * 3)(%rsi, %rdx), %ymm22
 vmovdqu64 -(32 * 4)(%rsi, %rdx), %ymm23
 vmovdqu64 %ymm16, (%rdi)
 vmovdqu64 %ymm17, 32(%rdi)
 vmovdqu64 %ymm18, (32 * 2)(%rdi)
 vmovdqu64 %ymm19, (32 * 3)(%rdi)
 vmovdqu64 %ymm20, -32(%rdi, %rdx)
 vmovdqu64 %ymm21, -(32 * 2)(%rdi, %rdx)
 vmovdqu64 %ymm22, -(32 * 3)(%rdi, %rdx)
 vmovdqu64 %ymm23, -(32 * 4)(%rdi, %rdx)
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

 vmovdqu64 -32(%rsi, %rdx), %ymm21
 vmovdqu64 -(32 * 2)(%rsi, %rdx), %ymm22

 movq %rdi, %rcx

 orq $(32 - 1), %rdi
 vmovdqu64 -(32 * 3)(%rsi, %rdx), %ymm23
 vmovdqu64 -(32 * 4)(%rsi, %rdx), %ymm24

 subq %rcx, %rsi

 incq %rdi

 addq %rdi, %rsi

 leaq (32 * -4)(%rcx, %rdx), %rdx

 .p2align 4,, 11
.Lloop_4x_vec_forward:

 vmovdqu64 (%rsi), %ymm17
 vmovdqu64 32(%rsi), %ymm18
 vmovdqu64 (32 * 2)(%rsi), %ymm19
 vmovdqu64 (32 * 3)(%rsi), %ymm20
 subq $-(32 * 4), %rsi
 vmovdqa64 %ymm17, (%rdi)
 vmovdqa64 %ymm18, 32(%rdi)
 vmovdqa64 %ymm19, (32 * 2)(%rdi)
 vmovdqa64 %ymm20, (32 * 3)(%rdi)
 subq $-(32 * 4), %rdi
 cmpq %rdi, %rdx
 ja .Lloop_4x_vec_forward

 vmovdqu64 %ymm21, (32 * 3)(%rdx)
 vmovdqu64 %ymm22, (32 * 2)(%rdx)
 vmovdqu64 %ymm23, 32(%rdx)
 vmovdqu64 %ymm24, (%rdx)

 vmovdqu64 %ymm16, (%rcx)

.Lnop_backward:
 ; ret

 .p2align 4,, 8
.Lmore_8x_vec_backward_check_nop:

 testq %rcx, %rcx
 jz .Lnop_backward
.Lmore_8x_vec_backward:

 vmovdqu64 32(%rsi), %ymm21
 vmovdqu64 (32 * 2)(%rsi), %ymm22

 leaq (32 * -4 + -1)(%rdi, %rdx), %rcx
 vmovdqu64 (32 * 3)(%rsi), %ymm23
 vmovdqu64 -32(%rsi, %rdx), %ymm24

 subq %rdi, %rsi

 andq $-(32), %rcx

 addq %rcx, %rsi

 .p2align 4,, 11
.Lloop_4x_vec_backward:

 vmovdqu64 (32 * 3)(%rsi), %ymm17
 vmovdqu64 (32 * 2)(%rsi), %ymm18
 vmovdqu64 (32 * 1)(%rsi), %ymm19
 vmovdqu64 (32 * 0)(%rsi), %ymm20
 addq $(32 * -4), %rsi
 vmovdqa64 %ymm17, (32 * 3)(%rcx)
 vmovdqa64 %ymm18, (32 * 2)(%rcx)
 vmovdqa64 %ymm19, (32 * 1)(%rcx)
 vmovdqa64 %ymm20, (32 * 0)(%rcx)
 addq $(32 * -4), %rcx
 cmpq %rcx, %rdi
 jb .Lloop_4x_vec_backward

 vmovdqu64 %ymm16, (%rdi)
 vmovdqu64 %ymm21, 32(%rdi)
 vmovdqu64 %ymm22, (32 * 2)(%rdi)
 vmovdqu64 %ymm23, (32 * 3)(%rdi)

 vmovdqu64 %ymm24, -32(%rdx, %rdi)
 ; ret

 .p2align 5,, 16

.Lskip_short_movsb_check:

 vmovdqu64 32(%rsi), %ymm17

 testl $(4096 - 512), %ecx
 jnz .Lmovsb_align_dst

 movq %rcx, %r9

 leaq -1(%rsi, %rdx), %rcx

 orq $(64 - 1), %rsi

 leaq 1(%rsi, %r9), %rdi
 subq %rsi, %rcx

 incq %rsi

 rep movsb

 vmovdqu64 %ymm16, (%r8)

 vmovdqu64 %ymm17, 32(%r8)

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

 vmovdqu64 32(%rsi), %ymm17

.Lmovsb_align_dst:

 subq %rdi, %rsi

 addq $(64 - 1), %rdi

 leaq (%r8, %rdx), %rcx

 andq $-(64), %rdi

 addq %rdi, %rsi
 subq %rdi, %rcx

 rep movsb

 vmovdqu64 %ymm16, (%r8)

 vmovdqu64 %ymm17, 32(%r8)

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

 vmovdqu64 32(%rsi), %ymm17

 vmovdqu64 %ymm16, (%rdi)

 vmovdqu64 %ymm17, 32(%rdi)

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

 vmovdqu64 (0)(%rsi), %ymm16; vmovdqu64 ((0) + 32)(%rsi), %ymm17; vmovdqu64 ((0) + 32 * 2)(%rsi), %ymm18; vmovdqu64 ((0) + 32 * 3)(%rsi), %ymm19;
 vmovdqu64 (4096)(%rsi), %ymm20; vmovdqu64 ((4096) + 32)(%rsi), %ymm21; vmovdqu64 ((4096) + 32 * 2)(%rsi), %ymm22; vmovdqu64 ((4096) + 32 * 3)(%rsi), %ymm23;
 subq $-(32 * 4), %rsi

 vmovntdq %ymm16, (0)(%rdi); vmovntdq %ymm17, ((0) + 32)(%rdi); vmovntdq %ymm18, ((0) + 32 * 2)(%rdi); vmovntdq %ymm19, ((0) + 32 * 3)(%rdi);
 vmovntdq %ymm20, (4096)(%rdi); vmovntdq %ymm21, ((4096) + 32)(%rdi); vmovntdq %ymm22, ((4096) + 32 * 2)(%rdi); vmovntdq %ymm23, ((4096) + 32 * 3)(%rdi);
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
 vmovdqu64 (%rsi), %ymm16
 vmovdqu64 32(%rsi), %ymm17
 vmovdqu64 (32 * 2)(%rsi), %ymm18
 vmovdqu64 (32 * 3)(%rsi), %ymm19
 subq $-(32 * 4), %rsi
 addl $-(32 * 4), %edx
 vmovdqa64 %ymm16, (%rdi)
 vmovdqa64 %ymm17, 32(%rdi)
 vmovdqa64 %ymm18, (32 * 2)(%rdi)
 vmovdqa64 %ymm19, (32 * 3)(%rdi)
 subq $-(32 * 4), %rdi
 cmpl $(32 * 4), %edx
 ja .Lloop_large_memcpy_2x_tail

.Llarge_memcpy_2x_end:

 vmovdqu64 -(32 * 4)(%rsi, %rdx), %ymm16
 vmovdqu64 -(32 * 3)(%rsi, %rdx), %ymm17
 vmovdqu64 -(32 * 2)(%rsi, %rdx), %ymm18
 vmovdqu64 -32(%rsi, %rdx), %ymm19

 vmovdqu64 %ymm16, -(32 * 4)(%rdi, %rdx)
 vmovdqu64 %ymm17, -(32 * 3)(%rdi, %rdx)
 vmovdqu64 %ymm18, -(32 * 2)(%rdi, %rdx)
 vmovdqu64 %ymm19, -32(%rdi, %rdx)
 ; ret

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

 vmovdqu64 (0)(%rsi), %ymm16; vmovdqu64 ((0) + 32)(%rsi), %ymm17; vmovdqu64 ((0) + 32 * 2)(%rsi), %ymm18; vmovdqu64 ((0) + 32 * 3)(%rsi), %ymm19;
 vmovdqu64 (4096)(%rsi), %ymm20; vmovdqu64 ((4096) + 32)(%rsi), %ymm21; vmovdqu64 ((4096) + 32 * 2)(%rsi), %ymm22; vmovdqu64 ((4096) + 32 * 3)(%rsi), %ymm23;
 vmovdqu64 (4096 * 2)(%rsi), %ymm24; vmovdqu64 ((4096 * 2) + 32)(%rsi), %ymm25; vmovdqu64 ((4096 * 2) + 32 * 2)(%rsi), %ymm26; vmovdqu64 ((4096 * 2) + 32 * 3)(%rsi), %ymm27;
 vmovdqu64 (4096 * 3)(%rsi), %ymm28; vmovdqu64 ((4096 * 3) + 32)(%rsi), %ymm29; vmovdqu64 ((4096 * 3) + 32 * 2)(%rsi), %ymm30; vmovdqu64 ((4096 * 3) + 32 * 3)(%rsi), %ymm31;
 subq $-(32 * 4), %rsi

 vmovntdq %ymm16, (0)(%rdi); vmovntdq %ymm17, ((0) + 32)(%rdi); vmovntdq %ymm18, ((0) + 32 * 2)(%rdi); vmovntdq %ymm19, ((0) + 32 * 3)(%rdi);
 vmovntdq %ymm20, (4096)(%rdi); vmovntdq %ymm21, ((4096) + 32)(%rdi); vmovntdq %ymm22, ((4096) + 32 * 2)(%rdi); vmovntdq %ymm23, ((4096) + 32 * 3)(%rdi);
 vmovntdq %ymm24, (4096 * 2)(%rdi); vmovntdq %ymm25, ((4096 * 2) + 32)(%rdi); vmovntdq %ymm26, ((4096 * 2) + 32 * 2)(%rdi); vmovntdq %ymm27, ((4096 * 2) + 32 * 3)(%rdi);
 vmovntdq %ymm28, (4096 * 3)(%rdi); vmovntdq %ymm29, ((4096 * 3) + 32)(%rdi); vmovntdq %ymm30, ((4096 * 3) + 32 * 2)(%rdi); vmovntdq %ymm31, ((4096 * 3) + 32 * 3)(%rdi);
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
 vmovdqu64 (%rsi), %ymm16
 vmovdqu64 32(%rsi), %ymm17
 vmovdqu64 (32 * 2)(%rsi), %ymm18
 vmovdqu64 (32 * 3)(%rsi), %ymm19
 subq $-(32 * 4), %rsi
 addl $-(32 * 4), %edx
 vmovdqa64 %ymm16, (%rdi)
 vmovdqa64 %ymm17, 32(%rdi)
 vmovdqa64 %ymm18, (32 * 2)(%rdi)
 vmovdqa64 %ymm19, (32 * 3)(%rdi)
 subq $-(32 * 4), %rdi
 cmpl $(32 * 4), %edx
 ja .Lloop_large_memcpy_4x_tail

.Llarge_memcpy_4x_end:

 vmovdqu64 -(32 * 4)(%rsi, %rdx), %ymm16
 vmovdqu64 -(32 * 3)(%rsi, %rdx), %ymm17
 vmovdqu64 -(32 * 2)(%rsi, %rdx), %ymm18
 vmovdqu64 -32(%rsi, %rdx), %ymm19

 vmovdqu64 %ymm16, -(32 * 4)(%rdi, %rdx)
 vmovdqu64 %ymm17, -(32 * 3)(%rdi, %rdx)
 vmovdqu64 %ymm18, -(32 * 2)(%rdi, %rdx)
 vmovdqu64 %ymm19, -32(%rdi, %rdx)
 ; ret

.globl __memcpy_evex_unaligned_erms
.set __memcpy_evex_unaligned_erms, __memmove_evex_unaligned_erms

.globl __memcpy_evex_unaligned
.set __memcpy_evex_unaligned, __memmove_evex_unaligned
