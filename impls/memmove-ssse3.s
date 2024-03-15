 .section .text.ssse3

.globl __mempcpy_ssse3
__mempcpy_ssse3:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart

.globl __memmove_ssse3
__memmove_ssse3:

 movq %rdi, %rax
.Lstart:
 cmpq $16, %rdx
 jb .Lcopy_0_15

 movups 0(%rsi), %xmm0
 movups -16(%rsi, %rdx), %xmm7
 cmpq $32, %rdx
 ja .Lmore_2x_vec

 movups %xmm0, 0(%rdi)
 movups %xmm7, -16(%rdi, %rdx)
 ret

 .p2align 4,, 4
.Lcopy_0_15:
 cmpl $4, %edx
 jb .Lcopy_0_3
 cmpl $8, %edx
 jb .Lcopy_4_7
 movq 0(%rsi), %rcx
 movq -8(%rsi, %rdx), %rsi
 movq %rcx, 0(%rdi)
 movq %rsi, -8(%rdi, %rdx)
 ret

 .p2align 4,, 4
.Lcopy_4_7:
 movl 0(%rsi), %ecx
 movl -4(%rsi, %rdx), %esi
 movl %ecx, 0(%rdi)
 movl %esi, -4(%rdi, %rdx)
 ret

 .p2align 4,, 4
.Lcopy_0_3:
 decl %edx
 jl .Lcopy_0_0
 movb (%rsi), %cl
 je .Lcopy_1_1

 movzwl -1(%rsi, %rdx), %esi
 movw %si, -1(%rdi, %rdx)
.Lcopy_1_1:
 movb %cl, (%rdi)
.Lcopy_0_0:
 ret

 .p2align 4,, 4
.Lcopy_4x_vec:
 movups 16(%rsi), %xmm1
 movups -32(%rsi, %rdx), %xmm2

 movups %xmm0, 0(%rdi)
 movups %xmm1, 16(%rdi)
 movups %xmm2, -32(%rdi, %rdx)
 movups %xmm7, -16(%rdi, %rdx)
.Lnop:
 ret

 .p2align 4
.Lmore_2x_vec:
 cmpq $64, %rdx
 jbe .Lcopy_4x_vec

 movq %rdi, %rcx

 subq %rsi, %rcx
 cmpq %rdx, %rcx
 jb .Lcopy_backward

 movups -32(%rsi, %rdx), %xmm8
 movups -48(%rsi, %rdx), %xmm9

 andl $0xf, %ecx

 movq %rsi, %r9
 addq %rcx, %rsi
 andq $-16, %rsi

 movaps (%rsi), %xmm1

 movups %xmm0, (%rdi)

 cmp __x86_shared_cache_size_half(%rip), %rdx

 ja .Llarge_memcpy

 leaq -64(%rdi, %rdx), %r8
 andq $-16, %rdi
 movl $48, %edx

 leaq .Lloop_fwd_start(%rip), %r9
 sall $6, %ecx
 addq %r9, %rcx
 jmp * %rcx

 .p2align 4,, 8
.Lcopy_backward:
 testq %rcx, %rcx
 jz .Lnop

 movups 16(%rsi), %xmm4
 movups 32(%rsi), %xmm5

 movq %rdi, %r8
 subq %rdi, %rsi
 leaq -49(%rdi, %rdx), %rdi
 andq $-16, %rdi
 addq %rdi, %rsi
 andq $-16, %rsi

 movaps 48(%rsi), %xmm6

 leaq .Lloop_bkwd_start(%rip), %r9
 andl $0xf, %ecx
 sall $6, %ecx
 addq %r9, %rcx
 jmp * %rcx

 .p2align 4,, 8
.Llarge_memcpy:
 movups -64(%r9, %rdx), %xmm10
 movups -80(%r9, %rdx), %xmm11

 sall $5, %ecx
 leal (%rcx, %rcx, 2), %r8d
 leaq -96(%rdi, %rdx), %rcx
 andq $-16, %rdi
 leaq .Llarge_loop_fwd_start(%rip), %rdx
 addq %r8, %rdx
 jmp * %rdx

 .p2align 6
.Lloop_fwd_start:
.Lloop_fwd_0x0:
 movaps 16(%rsi), %xmm1
 movaps 32(%rsi), %xmm2
 movaps 48(%rsi), %xmm3
 movaps %xmm1, 16(%rdi)
 movaps %xmm2, 32(%rdi)
 movaps %xmm3, 48(%rdi)
 addq %rdx, %rdi
 addq %rdx, %rsi
 cmpq %rdi, %r8
 ja .Lloop_fwd_0x0
.Lend_loop_fwd:
 movups %xmm9, 16(%r8)
 movups %xmm8, 32(%r8)
 movups %xmm7, 48(%r8)
 ret
 ; .p2align 6; .Lloop_fwd_0xf: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0xf, %xmm2, %xmm3; palignr $0xf, %xmm0, %xmm2; palignr $0xf, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0xf; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0xe: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0xe, %xmm2, %xmm3; palignr $0xe, %xmm0, %xmm2; palignr $0xe, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0xe; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0xd: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0xd, %xmm2, %xmm3; palignr $0xd, %xmm0, %xmm2; palignr $0xd, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0xd; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0xc: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0xc, %xmm2, %xmm3; palignr $0xc, %xmm0, %xmm2; palignr $0xc, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0xc; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0xb: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0xb, %xmm2, %xmm3; palignr $0xb, %xmm0, %xmm2; palignr $0xb, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0xb; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0xa: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0xa, %xmm2, %xmm3; palignr $0xa, %xmm0, %xmm2; palignr $0xa, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0xa; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x9: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x9, %xmm2, %xmm3; palignr $0x9, %xmm0, %xmm2; palignr $0x9, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x9; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x8: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x8, %xmm2, %xmm3; palignr $0x8, %xmm0, %xmm2; palignr $0x8, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x8; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x7: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x7, %xmm2, %xmm3; palignr $0x7, %xmm0, %xmm2; palignr $0x7, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x7; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x6: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x6, %xmm2, %xmm3; palignr $0x6, %xmm0, %xmm2; palignr $0x6, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x6; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x5: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x5, %xmm2, %xmm3; palignr $0x5, %xmm0, %xmm2; palignr $0x5, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x5; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x4: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x4, %xmm2, %xmm3; palignr $0x4, %xmm0, %xmm2; palignr $0x4, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x4; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x3: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x3, %xmm2, %xmm3; palignr $0x3, %xmm0, %xmm2; palignr $0x3, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x3; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x2: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x2, %xmm2, %xmm3; palignr $0x2, %xmm0, %xmm2; palignr $0x2, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x2; jmp .Lend_loop_fwd;
 ; .p2align 6; .Lloop_fwd_0x1: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps %xmm3, %xmm4; palignr $0x1, %xmm2, %xmm3; palignr $0x1, %xmm0, %xmm2; palignr $0x1, %xmm1, %xmm0; movaps %xmm4, %xmm1; movaps %xmm0, 16(%rdi); movaps %xmm2, 32(%rdi); movaps %xmm3, 48(%rdi); addq %rdx, %rdi; addq %rdx, %rsi; cmpq %rdi, %r8; ja .Lloop_fwd_0x1; jmp .Lend_loop_fwd;

 .p2align 6
.Llarge_loop_fwd_start:
.Llarge_loop_fwd_0x0:
 movaps 16(%rsi), %xmm1
 movaps 32(%rsi), %xmm2
 movaps 48(%rsi), %xmm3
 movaps 64(%rsi), %xmm4
 movaps 80(%rsi), %xmm5
 movntps %xmm1, 16(%rdi)
 movntps %xmm2, 32(%rdi)
 movntps %xmm3, 48(%rdi)
 movntps %xmm4, 64(%rdi)
 movntps %xmm5, 80(%rdi)
 addq $80, %rdi
 addq $80, %rsi
 cmpq %rdi, %rcx
 ja .Llarge_loop_fwd_0x0

 .p2align 4
.Lend_large_loop_fwd:
 sfence
 movups %xmm11, 16(%rcx)
 movups %xmm10, 32(%rcx)
 movups %xmm9, 48(%rcx)
 movups %xmm8, 64(%rcx)
 movups %xmm7, 80(%rcx)
 ret
 ; .p2align 5; .Llarge_loop_fwd_0xf: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0xf, %xmm4, %xmm5; palignr $0xf, %xmm3, %xmm4; palignr $0xf, %xmm2, %xmm3; palignr $0xf, %xmm0, %xmm2; palignr $0xf, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0xf; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0xe: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0xe, %xmm4, %xmm5; palignr $0xe, %xmm3, %xmm4; palignr $0xe, %xmm2, %xmm3; palignr $0xe, %xmm0, %xmm2; palignr $0xe, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0xe; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0xd: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0xd, %xmm4, %xmm5; palignr $0xd, %xmm3, %xmm4; palignr $0xd, %xmm2, %xmm3; palignr $0xd, %xmm0, %xmm2; palignr $0xd, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0xd; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0xc: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0xc, %xmm4, %xmm5; palignr $0xc, %xmm3, %xmm4; palignr $0xc, %xmm2, %xmm3; palignr $0xc, %xmm0, %xmm2; palignr $0xc, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0xc; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0xb: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0xb, %xmm4, %xmm5; palignr $0xb, %xmm3, %xmm4; palignr $0xb, %xmm2, %xmm3; palignr $0xb, %xmm0, %xmm2; palignr $0xb, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0xb; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0xa: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0xa, %xmm4, %xmm5; palignr $0xa, %xmm3, %xmm4; palignr $0xa, %xmm2, %xmm3; palignr $0xa, %xmm0, %xmm2; palignr $0xa, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0xa; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x9: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x9, %xmm4, %xmm5; palignr $0x9, %xmm3, %xmm4; palignr $0x9, %xmm2, %xmm3; palignr $0x9, %xmm0, %xmm2; palignr $0x9, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x9; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x8: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x8, %xmm4, %xmm5; palignr $0x8, %xmm3, %xmm4; palignr $0x8, %xmm2, %xmm3; palignr $0x8, %xmm0, %xmm2; palignr $0x8, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x8; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x7: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x7, %xmm4, %xmm5; palignr $0x7, %xmm3, %xmm4; palignr $0x7, %xmm2, %xmm3; palignr $0x7, %xmm0, %xmm2; palignr $0x7, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x7; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x6: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x6, %xmm4, %xmm5; palignr $0x6, %xmm3, %xmm4; palignr $0x6, %xmm2, %xmm3; palignr $0x6, %xmm0, %xmm2; palignr $0x6, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x6; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x5: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x5, %xmm4, %xmm5; palignr $0x5, %xmm3, %xmm4; palignr $0x5, %xmm2, %xmm3; palignr $0x5, %xmm0, %xmm2; palignr $0x5, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x5; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x4: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x4, %xmm4, %xmm5; palignr $0x4, %xmm3, %xmm4; palignr $0x4, %xmm2, %xmm3; palignr $0x4, %xmm0, %xmm2; palignr $0x4, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x4; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x3: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x3, %xmm4, %xmm5; palignr $0x3, %xmm3, %xmm4; palignr $0x3, %xmm2, %xmm3; palignr $0x3, %xmm0, %xmm2; palignr $0x3, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x3; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x2: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x2, %xmm4, %xmm5; palignr $0x2, %xmm3, %xmm4; palignr $0x2, %xmm2, %xmm3; palignr $0x2, %xmm0, %xmm2; palignr $0x2, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x2; jmp .Lend_large_loop_fwd;
 ; .p2align 5; .Llarge_loop_fwd_0x1: movaps 16(%rsi), %xmm0; movaps 32(%rsi), %xmm2; movaps 48(%rsi), %xmm3; movaps 64(%rsi), %xmm4; movaps 80(%rsi), %xmm5; movaps %xmm5, %xmm6; palignr $0x1, %xmm4, %xmm5; palignr $0x1, %xmm3, %xmm4; palignr $0x1, %xmm2, %xmm3; palignr $0x1, %xmm0, %xmm2; palignr $0x1, %xmm1, %xmm0; movaps %xmm6, %xmm1; movntps %xmm0, 16(%rdi); movntps %xmm2, 32(%rdi); movntps %xmm3, 48(%rdi); movntps %xmm4, 64(%rdi); movntps %xmm5, 80(%rdi); addq $80, %rdi; addq $80, %rsi; cmpq %rdi, %rcx; ja .Llarge_loop_fwd_0x1; jmp .Lend_large_loop_fwd;

 .p2align 6
.Lloop_bkwd_start:
.Lloop_bkwd_0x0:
 movaps 32(%rsi), %xmm1
 movaps 16(%rsi), %xmm2
 movaps 0(%rsi), %xmm3
 movaps %xmm1, 32(%rdi)
 movaps %xmm2, 16(%rdi)
 movaps %xmm3, 0(%rdi)
 subq $48, %rdi
 subq $48, %rsi
 cmpq %rdi, %r8
 jb .Lloop_bkwd_0x0
.Lend_loop_bkwd:
 movups %xmm7, -16(%r8, %rdx)
 movups %xmm0, 0(%r8)
 movups %xmm4, 16(%r8)
 movups %xmm5, 32(%r8)

 ret
 ; .p2align 6; .Lloop_bkwd_0xf: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0xf, %xmm1, %xmm6; palignr $0xf, %xmm2, %xmm1; palignr $0xf, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0xf; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0xe: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0xe, %xmm1, %xmm6; palignr $0xe, %xmm2, %xmm1; palignr $0xe, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0xe; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0xd: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0xd, %xmm1, %xmm6; palignr $0xd, %xmm2, %xmm1; palignr $0xd, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0xd; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0xc: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0xc, %xmm1, %xmm6; palignr $0xc, %xmm2, %xmm1; palignr $0xc, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0xc; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0xb: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0xb, %xmm1, %xmm6; palignr $0xb, %xmm2, %xmm1; palignr $0xb, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0xb; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0xa: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0xa, %xmm1, %xmm6; palignr $0xa, %xmm2, %xmm1; palignr $0xa, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0xa; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x9: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x9, %xmm1, %xmm6; palignr $0x9, %xmm2, %xmm1; palignr $0x9, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x9; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x8: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x8, %xmm1, %xmm6; palignr $0x8, %xmm2, %xmm1; palignr $0x8, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x8; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x7: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x7, %xmm1, %xmm6; palignr $0x7, %xmm2, %xmm1; palignr $0x7, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x7; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x6: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x6, %xmm1, %xmm6; palignr $0x6, %xmm2, %xmm1; palignr $0x6, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x6; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x5: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x5, %xmm1, %xmm6; palignr $0x5, %xmm2, %xmm1; palignr $0x5, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x5; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x4: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x4, %xmm1, %xmm6; palignr $0x4, %xmm2, %xmm1; palignr $0x4, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x4; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x3: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x3, %xmm1, %xmm6; palignr $0x3, %xmm2, %xmm1; palignr $0x3, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x3; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x2: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x2, %xmm1, %xmm6; palignr $0x2, %xmm2, %xmm1; palignr $0x2, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x2; jmp .Lend_loop_bkwd;
 ; .p2align 6; .Lloop_bkwd_0x1: movaps 32(%rsi), %xmm1; movaps 16(%rsi), %xmm2; movaps 0(%rsi), %xmm3; palignr $0x1, %xmm1, %xmm6; palignr $0x1, %xmm2, %xmm1; palignr $0x1, %xmm3, %xmm2; movaps %xmm6, 32(%rdi); movaps %xmm1, 16(%rdi); movaps %xmm2, 0(%rdi); subq $48, %rdi; subq $48, %rsi; movaps %xmm3, %xmm6; cmpq %rdi, %r8; jb .Lloop_bkwd_0x1; jmp .Lend_loop_bkwd;

.globl __memcpy_ssse3
.set __memcpy_ssse3, __memmove_ssse3
