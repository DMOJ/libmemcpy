 .section .text.ssse3
.globl __memmove_ssse3
__memmove_ssse3:
 mov %rdi, %rax
 cmp %rsi, %rdi
 jb .Lcopy_forward
 je .Lwrite_0bytes
 cmp $79, %rdx
 jbe .Lcopy_forward
 jmp .Lcopy_backward
.Lcopy_forward:

.Lstart:
 cmp $79, %rdx
 lea .Ltable_less_80bytes(%rip), %r11
 ja .L80bytesormore
 movslq (%r11, %rdx, 4), %r9
 add %rdx, %rsi
 add %rdx, %rdi
 add %r11, %r9
 jmp *%r9
 ud2

 .p2align 4
.L80bytesormore:

 movdqu (%rsi), %xmm0
 mov %rdi, %rcx
 and $-16, %rdi
 add $16, %rdi
 mov %rcx, %r8
 sub %rdi, %rcx
 add %rcx, %rdx
 sub %rcx, %rsi

 mov __x86_shared_cache_size_half(%rip), %rcx

 cmp %rcx, %rdx
 mov %rsi, %r9
 ja .Llarge_page_fwd
 and $0xf, %r9
 jz .Lshl_0

 mov __x86_data_cache_size_half(%rip), %rcx

 lea .Lshl_table(%rip), %r11; movslq (%r11, %r9, 4), %r9; lea (%r11, %r9), %r9; jmp *%r9; ud2

 .p2align 4
.Lcopy_backward:
 movdqu -16(%rsi, %rdx), %xmm0
 add %rdx, %rsi
 lea -16(%rdi, %rdx), %r8
 add %rdx, %rdi

 mov %rdi, %rcx
 and $0xf, %rcx
 xor %rcx, %rdi
 sub %rcx, %rdx
 sub %rcx, %rsi

 mov __x86_shared_cache_size_half(%rip), %rcx

 cmp %rcx, %rdx
 mov %rsi, %r9
 ja .Llarge_page_bwd
 and $0xf, %r9
 jz .Lshl_0_bwd

 mov __x86_data_cache_size_half(%rip), %rcx

 lea .Lshl_table_bwd(%rip), %r11; movslq (%r11, %r9, 4), %r9; lea (%r11, %r9), %r9; jmp *%r9; ud2

 .p2align 4
.Lshl_0:
 sub $16, %rdx
 movdqa (%rsi), %xmm1
 add $16, %rsi
 movdqa %xmm1, (%rdi)
 add $16, %rdi
 cmp $128, %rdx
 movdqu %xmm0, (%r8)
 ja .Lshl_0_gobble
 cmp $64, %rdx
 jb .Lshl_0_less_64bytes
 movaps (%rsi), %xmm4
 movaps 16(%rsi), %xmm1
 movaps 32(%rsi), %xmm2
 movaps 48(%rsi), %xmm3
 movaps %xmm4, (%rdi)
 movaps %xmm1, 16(%rdi)
 movaps %xmm2, 32(%rdi)
 movaps %xmm3, 48(%rdi)
 sub $64, %rdx
 add $64, %rsi
 add $64, %rdi
.Lshl_0_less_64bytes:
 add %rdx, %rsi
 add %rdx, %rdi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_0_gobble:

 cmp __x86_data_cache_size_half(%rip), %rdx

 lea -128(%rdx), %rdx
 jae .Lshl_0_gobble_mem_loop
.Lshl_0_gobble_cache_loop:
 movdqa (%rsi), %xmm4
 movaps 0x10(%rsi), %xmm1
 movaps 0x20(%rsi), %xmm2
 movaps 0x30(%rsi), %xmm3

 movdqa %xmm4, (%rdi)
 movaps %xmm1, 0x10(%rdi)
 movaps %xmm2, 0x20(%rdi)
 movaps %xmm3, 0x30(%rdi)

 sub $128, %rdx
 movaps 0x40(%rsi), %xmm4
 movaps 0x50(%rsi), %xmm5
 movaps 0x60(%rsi), %xmm6
 movaps 0x70(%rsi), %xmm7
 lea 0x80(%rsi), %rsi
 movaps %xmm4, 0x40(%rdi)
 movaps %xmm5, 0x50(%rdi)
 movaps %xmm6, 0x60(%rdi)
 movaps %xmm7, 0x70(%rdi)
 lea 0x80(%rdi), %rdi

 jae .Lshl_0_gobble_cache_loop
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Lshl_0_cache_less_64bytes

 movdqa (%rsi), %xmm4
 sub $0x40, %rdx
 movdqa 0x10(%rsi), %xmm1

 movdqa %xmm4, (%rdi)
 movdqa %xmm1, 0x10(%rdi)

 movdqa 0x20(%rsi), %xmm4
 movdqa 0x30(%rsi), %xmm1
 add $0x40, %rsi

 movdqa %xmm4, 0x20(%rdi)
 movdqa %xmm1, 0x30(%rdi)
 add $0x40, %rdi
.Lshl_0_cache_less_64bytes:
 add %rdx, %rsi
 add %rdx, %rdi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_0_gobble_mem_loop:
 prefetcht0 0x1c0(%rsi)
 prefetcht0 0x280(%rsi)

 movdqa (%rsi), %xmm0
 movdqa 0x10(%rsi), %xmm1
 movdqa 0x20(%rsi), %xmm2
 movdqa 0x30(%rsi), %xmm3
 movdqa 0x40(%rsi), %xmm4
 movdqa 0x50(%rsi), %xmm5
 movdqa 0x60(%rsi), %xmm6
 movdqa 0x70(%rsi), %xmm7
 lea 0x80(%rsi), %rsi
 sub $0x80, %rdx
 movdqa %xmm0, (%rdi)
 movdqa %xmm1, 0x10(%rdi)
 movdqa %xmm2, 0x20(%rdi)
 movdqa %xmm3, 0x30(%rdi)
 movdqa %xmm4, 0x40(%rdi)
 movdqa %xmm5, 0x50(%rdi)
 movdqa %xmm6, 0x60(%rdi)
 movdqa %xmm7, 0x70(%rdi)
 lea 0x80(%rdi), %rdi

 jae .Lshl_0_gobble_mem_loop
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Lshl_0_mem_less_64bytes

 movdqa (%rsi), %xmm0
 sub $0x40, %rdx
 movdqa 0x10(%rsi), %xmm1

 movdqa %xmm0, (%rdi)
 movdqa %xmm1, 0x10(%rdi)

 movdqa 0x20(%rsi), %xmm0
 movdqa 0x30(%rsi), %xmm1
 add $0x40, %rsi

 movdqa %xmm0, 0x20(%rdi)
 movdqa %xmm1, 0x30(%rdi)
 add $0x40, %rdi
.Lshl_0_mem_less_64bytes:
 cmp $0x20, %rdx
 jb .Lshl_0_mem_less_32bytes
 movdqa (%rsi), %xmm0
 sub $0x20, %rdx
 movdqa 0x10(%rsi), %xmm1
 add $0x20, %rsi
 movdqa %xmm0, (%rdi)
 movdqa %xmm1, 0x10(%rdi)
 add $0x20, %rdi
.Lshl_0_mem_less_32bytes:
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_0_bwd:
 sub $16, %rdx
 movdqa -0x10(%rsi), %xmm1
 sub $16, %rsi
 movdqa %xmm1, -0x10(%rdi)
 sub $16, %rdi
 cmp $0x80, %rdx
 movdqu %xmm0, (%r8)
 ja .Lshl_0_gobble_bwd
 cmp $64, %rdx
 jb .Lshl_0_less_64bytes_bwd
 movaps -0x10(%rsi), %xmm0
 movaps -0x20(%rsi), %xmm1
 movaps -0x30(%rsi), %xmm2
 movaps -0x40(%rsi), %xmm3
 movaps %xmm0, -0x10(%rdi)
 movaps %xmm1, -0x20(%rdi)
 movaps %xmm2, -0x30(%rdi)
 movaps %xmm3, -0x40(%rdi)
 sub $64, %rdx
 sub $0x40, %rsi
 sub $0x40, %rdi
.Lshl_0_less_64bytes_bwd:
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_0_gobble_bwd:

 cmp __x86_data_cache_size_half(%rip), %rdx

 lea -128(%rdx), %rdx
 jae .Lshl_0_gobble_mem_bwd_loop
.Lshl_0_gobble_bwd_loop:
 movdqa -0x10(%rsi), %xmm0
 movaps -0x20(%rsi), %xmm1
 movaps -0x30(%rsi), %xmm2
 movaps -0x40(%rsi), %xmm3

 movdqa %xmm0, -0x10(%rdi)
 movaps %xmm1, -0x20(%rdi)
 movaps %xmm2, -0x30(%rdi)
 movaps %xmm3, -0x40(%rdi)

 sub $0x80, %rdx
 movaps -0x50(%rsi), %xmm4
 movaps -0x60(%rsi), %xmm5
 movaps -0x70(%rsi), %xmm6
 movaps -0x80(%rsi), %xmm7
 lea -0x80(%rsi), %rsi
 movaps %xmm4, -0x50(%rdi)
 movaps %xmm5, -0x60(%rdi)
 movaps %xmm6, -0x70(%rdi)
 movaps %xmm7, -0x80(%rdi)
 lea -0x80(%rdi), %rdi

 jae .Lshl_0_gobble_bwd_loop
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Lshl_0_gobble_bwd_less_64bytes

 movdqa -0x10(%rsi), %xmm0
 sub $0x40, %rdx
 movdqa -0x20(%rsi), %xmm1

 movdqa %xmm0, -0x10(%rdi)
 movdqa %xmm1, -0x20(%rdi)

 movdqa -0x30(%rsi), %xmm0
 movdqa -0x40(%rsi), %xmm1
 sub $0x40, %rsi

 movdqa %xmm0, -0x30(%rdi)
 movdqa %xmm1, -0x40(%rdi)
 sub $0x40, %rdi
.Lshl_0_gobble_bwd_less_64bytes:
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_0_gobble_mem_bwd_loop:
 prefetcht0 -0x1c0(%rsi)
 prefetcht0 -0x280(%rsi)
 movdqa -0x10(%rsi), %xmm0
 movdqa -0x20(%rsi), %xmm1
 movdqa -0x30(%rsi), %xmm2
 movdqa -0x40(%rsi), %xmm3
 movdqa -0x50(%rsi), %xmm4
 movdqa -0x60(%rsi), %xmm5
 movdqa -0x70(%rsi), %xmm6
 movdqa -0x80(%rsi), %xmm7
 lea -0x80(%rsi), %rsi
 sub $0x80, %rdx
 movdqa %xmm0, -0x10(%rdi)
 movdqa %xmm1, -0x20(%rdi)
 movdqa %xmm2, -0x30(%rdi)
 movdqa %xmm3, -0x40(%rdi)
 movdqa %xmm4, -0x50(%rdi)
 movdqa %xmm5, -0x60(%rdi)
 movdqa %xmm6, -0x70(%rdi)
 movdqa %xmm7, -0x80(%rdi)
 lea -0x80(%rdi), %rdi

 jae .Lshl_0_gobble_mem_bwd_loop
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Lshl_0_mem_bwd_less_64bytes

 movdqa -0x10(%rsi), %xmm0
 sub $0x40, %rdx
 movdqa -0x20(%rsi), %xmm1

 movdqa %xmm0, -0x10(%rdi)
 movdqa %xmm1, -0x20(%rdi)

 movdqa -0x30(%rsi), %xmm0
 movdqa -0x40(%rsi), %xmm1
 sub $0x40, %rsi

 movdqa %xmm0, -0x30(%rdi)
 movdqa %xmm1, -0x40(%rdi)
 sub $0x40, %rdi
.Lshl_0_mem_bwd_less_64bytes:
 cmp $0x20, %rdx
 jb .Lshl_0_mem_bwd_less_32bytes
 movdqa -0x10(%rsi), %xmm0
 sub $0x20, %rdx
 movdqa -0x20(%rsi), %xmm1
 sub $0x20, %rsi
 movdqa %xmm0, -0x10(%rdi)
 movdqa %xmm1, -0x20(%rdi)
 sub $0x20, %rdi
.Lshl_0_mem_bwd_less_32bytes:
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_1:
 lea (.Lshl_1_loop_L1-.Lshl_1)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x01(%rsi), %xmm1
 jb .LL1_fwd
 lea (.Lshl_1_loop_L2-.Lshl_1_loop_L1)(%r9), %r9
.LL1_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_1_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_1_loop_L1:
 sub $64, %rdx
 movaps 0x0f(%rsi), %xmm2
 movaps 0x1f(%rsi), %xmm3
 movaps 0x2f(%rsi), %xmm4
 movaps 0x3f(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $1, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $1, %xmm3, %xmm4
 palignr $1, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $1, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_1_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_1_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_1_bwd:
 lea (.Lshl_1_bwd_loop_L1-.Lshl_1_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x01(%rsi), %xmm1
 jb .LL1_bwd
 lea (.Lshl_1_bwd_loop_L2-.Lshl_1_bwd_loop_L1)(%r9), %r9
.LL1_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_1_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_1_bwd_loop_L1:
 movaps -0x11(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x21(%rsi), %xmm3
 movaps -0x31(%rsi), %xmm4
 movaps -0x41(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $1, %xmm2, %xmm1
 palignr $1, %xmm3, %xmm2
 palignr $1, %xmm4, %xmm3
 palignr $1, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_1_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_1_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_2:
 lea (.Lshl_2_loop_L1-.Lshl_2)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x02(%rsi), %xmm1
 jb .LL2_fwd
 lea (.Lshl_2_loop_L2-.Lshl_2_loop_L1)(%r9), %r9
.LL2_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_2_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_2_loop_L1:
 sub $64, %rdx
 movaps 0x0e(%rsi), %xmm2
 movaps 0x1e(%rsi), %xmm3
 movaps 0x2e(%rsi), %xmm4
 movaps 0x3e(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $2, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $2, %xmm3, %xmm4
 palignr $2, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $2, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_2_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_2_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_2_bwd:
 lea (.Lshl_2_bwd_loop_L1-.Lshl_2_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x02(%rsi), %xmm1
 jb .LL2_bwd
 lea (.Lshl_2_bwd_loop_L2-.Lshl_2_bwd_loop_L1)(%r9), %r9
.LL2_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_2_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_2_bwd_loop_L1:
 movaps -0x12(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x22(%rsi), %xmm3
 movaps -0x32(%rsi), %xmm4
 movaps -0x42(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $2, %xmm2, %xmm1
 palignr $2, %xmm3, %xmm2
 palignr $2, %xmm4, %xmm3
 palignr $2, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_2_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_2_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_3:
 lea (.Lshl_3_loop_L1-.Lshl_3)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x03(%rsi), %xmm1
 jb .LL3_fwd
 lea (.Lshl_3_loop_L2-.Lshl_3_loop_L1)(%r9), %r9
.LL3_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_3_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_3_loop_L1:
 sub $64, %rdx
 movaps 0x0d(%rsi), %xmm2
 movaps 0x1d(%rsi), %xmm3
 movaps 0x2d(%rsi), %xmm4
 movaps 0x3d(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $3, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $3, %xmm3, %xmm4
 palignr $3, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $3, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_3_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_3_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_3_bwd:
 lea (.Lshl_3_bwd_loop_L1-.Lshl_3_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x03(%rsi), %xmm1
 jb .LL3_bwd
 lea (.Lshl_3_bwd_loop_L2-.Lshl_3_bwd_loop_L1)(%r9), %r9
.LL3_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_3_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_3_bwd_loop_L1:
 movaps -0x13(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x23(%rsi), %xmm3
 movaps -0x33(%rsi), %xmm4
 movaps -0x43(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $3, %xmm2, %xmm1
 palignr $3, %xmm3, %xmm2
 palignr $3, %xmm4, %xmm3
 palignr $3, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_3_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_3_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_4:
 lea (.Lshl_4_loop_L1-.Lshl_4)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x04(%rsi), %xmm1
 jb .LL4_fwd
 lea (.Lshl_4_loop_L2-.Lshl_4_loop_L1)(%r9), %r9
.LL4_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_4_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_4_loop_L1:
 sub $64, %rdx
 movaps 0x0c(%rsi), %xmm2
 movaps 0x1c(%rsi), %xmm3
 movaps 0x2c(%rsi), %xmm4
 movaps 0x3c(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $4, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $4, %xmm3, %xmm4
 palignr $4, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $4, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_4_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_4_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_4_bwd:
 lea (.Lshl_4_bwd_loop_L1-.Lshl_4_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x04(%rsi), %xmm1
 jb .LL4_bwd
 lea (.Lshl_4_bwd_loop_L2-.Lshl_4_bwd_loop_L1)(%r9), %r9
.LL4_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_4_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_4_bwd_loop_L1:
 movaps -0x14(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x24(%rsi), %xmm3
 movaps -0x34(%rsi), %xmm4
 movaps -0x44(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $4, %xmm2, %xmm1
 palignr $4, %xmm3, %xmm2
 palignr $4, %xmm4, %xmm3
 palignr $4, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_4_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_4_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_5:
 lea (.Lshl_5_loop_L1-.Lshl_5)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x05(%rsi), %xmm1
 jb .LL5_fwd
 lea (.Lshl_5_loop_L2-.Lshl_5_loop_L1)(%r9), %r9
.LL5_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_5_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_5_loop_L1:
 sub $64, %rdx
 movaps 0x0b(%rsi), %xmm2
 movaps 0x1b(%rsi), %xmm3
 movaps 0x2b(%rsi), %xmm4
 movaps 0x3b(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $5, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $5, %xmm3, %xmm4
 palignr $5, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $5, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_5_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_5_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_5_bwd:
 lea (.Lshl_5_bwd_loop_L1-.Lshl_5_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x05(%rsi), %xmm1
 jb .LL5_bwd
 lea (.Lshl_5_bwd_loop_L2-.Lshl_5_bwd_loop_L1)(%r9), %r9
.LL5_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_5_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_5_bwd_loop_L1:
 movaps -0x15(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x25(%rsi), %xmm3
 movaps -0x35(%rsi), %xmm4
 movaps -0x45(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $5, %xmm2, %xmm1
 palignr $5, %xmm3, %xmm2
 palignr $5, %xmm4, %xmm3
 palignr $5, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_5_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_5_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_6:
 lea (.Lshl_6_loop_L1-.Lshl_6)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x06(%rsi), %xmm1
 jb .LL6_fwd
 lea (.Lshl_6_loop_L2-.Lshl_6_loop_L1)(%r9), %r9
.LL6_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_6_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_6_loop_L1:
 sub $64, %rdx
 movaps 0x0a(%rsi), %xmm2
 movaps 0x1a(%rsi), %xmm3
 movaps 0x2a(%rsi), %xmm4
 movaps 0x3a(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $6, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $6, %xmm3, %xmm4
 palignr $6, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $6, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_6_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_6_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_6_bwd:
 lea (.Lshl_6_bwd_loop_L1-.Lshl_6_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x06(%rsi), %xmm1
 jb .LL6_bwd
 lea (.Lshl_6_bwd_loop_L2-.Lshl_6_bwd_loop_L1)(%r9), %r9
.LL6_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_6_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_6_bwd_loop_L1:
 movaps -0x16(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x26(%rsi), %xmm3
 movaps -0x36(%rsi), %xmm4
 movaps -0x46(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $6, %xmm2, %xmm1
 palignr $6, %xmm3, %xmm2
 palignr $6, %xmm4, %xmm3
 palignr $6, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_6_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_6_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_7:
 lea (.Lshl_7_loop_L1-.Lshl_7)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x07(%rsi), %xmm1
 jb .LL7_fwd
 lea (.Lshl_7_loop_L2-.Lshl_7_loop_L1)(%r9), %r9
.LL7_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_7_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_7_loop_L1:
 sub $64, %rdx
 movaps 0x09(%rsi), %xmm2
 movaps 0x19(%rsi), %xmm3
 movaps 0x29(%rsi), %xmm4
 movaps 0x39(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $7, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $7, %xmm3, %xmm4
 palignr $7, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $7, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_7_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_7_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_7_bwd:
 lea (.Lshl_7_bwd_loop_L1-.Lshl_7_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x07(%rsi), %xmm1
 jb .LL7_bwd
 lea (.Lshl_7_bwd_loop_L2-.Lshl_7_bwd_loop_L1)(%r9), %r9
.LL7_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_7_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_7_bwd_loop_L1:
 movaps -0x17(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x27(%rsi), %xmm3
 movaps -0x37(%rsi), %xmm4
 movaps -0x47(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $7, %xmm2, %xmm1
 palignr $7, %xmm3, %xmm2
 palignr $7, %xmm4, %xmm3
 palignr $7, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_7_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_7_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_8:
 lea (.Lshl_8_loop_L1-.Lshl_8)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x08(%rsi), %xmm1
 jb .LL8_fwd
 lea (.Lshl_8_loop_L2-.Lshl_8_loop_L1)(%r9), %r9
.LL8_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
.Lshl_8_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_8_loop_L1:
 sub $64, %rdx
 movaps 0x08(%rsi), %xmm2
 movaps 0x18(%rsi), %xmm3
 movaps 0x28(%rsi), %xmm4
 movaps 0x38(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $8, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $8, %xmm3, %xmm4
 palignr $8, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $8, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_8_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
 .p2align 4
.Lshl_8_end:
 lea 64(%rdx), %rdx
 movaps %xmm4, -0x20(%rdi)
 add %rdx, %rsi
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_8_bwd:
 lea (.Lshl_8_bwd_loop_L1-.Lshl_8_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x08(%rsi), %xmm1
 jb .LL8_bwd
 lea (.Lshl_8_bwd_loop_L2-.Lshl_8_bwd_loop_L1)(%r9), %r9
.LL8_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_8_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_8_bwd_loop_L1:
 movaps -0x18(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x28(%rsi), %xmm3
 movaps -0x38(%rsi), %xmm4
 movaps -0x48(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $8, %xmm2, %xmm1
 palignr $8, %xmm3, %xmm2
 palignr $8, %xmm4, %xmm3
 palignr $8, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_8_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_8_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_9:
 lea (.Lshl_9_loop_L1-.Lshl_9)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x09(%rsi), %xmm1
 jb .LL9_fwd
 lea (.Lshl_9_loop_L2-.Lshl_9_loop_L1)(%r9), %r9
.LL9_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_9_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_9_loop_L1:
 sub $64, %rdx
 movaps 0x07(%rsi), %xmm2
 movaps 0x17(%rsi), %xmm3
 movaps 0x27(%rsi), %xmm4
 movaps 0x37(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $9, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $9, %xmm3, %xmm4
 palignr $9, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $9, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_9_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_9_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_9_bwd:
 lea (.Lshl_9_bwd_loop_L1-.Lshl_9_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x09(%rsi), %xmm1
 jb .LL9_bwd
 lea (.Lshl_9_bwd_loop_L2-.Lshl_9_bwd_loop_L1)(%r9), %r9
.LL9_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_9_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_9_bwd_loop_L1:
 movaps -0x19(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x29(%rsi), %xmm3
 movaps -0x39(%rsi), %xmm4
 movaps -0x49(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $9, %xmm2, %xmm1
 palignr $9, %xmm3, %xmm2
 palignr $9, %xmm4, %xmm3
 palignr $9, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_9_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_9_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_10:
 lea (.Lshl_10_loop_L1-.Lshl_10)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0a(%rsi), %xmm1
 jb .LL10_fwd
 lea (.Lshl_10_loop_L2-.Lshl_10_loop_L1)(%r9), %r9
.LL10_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_10_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_10_loop_L1:
 sub $64, %rdx
 movaps 0x06(%rsi), %xmm2
 movaps 0x16(%rsi), %xmm3
 movaps 0x26(%rsi), %xmm4
 movaps 0x36(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $10, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $10, %xmm3, %xmm4
 palignr $10, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $10, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_10_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_10_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_10_bwd:
 lea (.Lshl_10_bwd_loop_L1-.Lshl_10_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0a(%rsi), %xmm1
 jb .LL10_bwd
 lea (.Lshl_10_bwd_loop_L2-.Lshl_10_bwd_loop_L1)(%r9), %r9
.LL10_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_10_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_10_bwd_loop_L1:
 movaps -0x1a(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x2a(%rsi), %xmm3
 movaps -0x3a(%rsi), %xmm4
 movaps -0x4a(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $10, %xmm2, %xmm1
 palignr $10, %xmm3, %xmm2
 palignr $10, %xmm4, %xmm3
 palignr $10, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_10_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_10_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_11:
 lea (.Lshl_11_loop_L1-.Lshl_11)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0b(%rsi), %xmm1
 jb .LL11_fwd
 lea (.Lshl_11_loop_L2-.Lshl_11_loop_L1)(%r9), %r9
.LL11_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_11_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_11_loop_L1:
 sub $64, %rdx
 movaps 0x05(%rsi), %xmm2
 movaps 0x15(%rsi), %xmm3
 movaps 0x25(%rsi), %xmm4
 movaps 0x35(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $11, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $11, %xmm3, %xmm4
 palignr $11, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $11, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_11_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_11_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_11_bwd:
 lea (.Lshl_11_bwd_loop_L1-.Lshl_11_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0b(%rsi), %xmm1
 jb .LL11_bwd
 lea (.Lshl_11_bwd_loop_L2-.Lshl_11_bwd_loop_L1)(%r9), %r9
.LL11_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_11_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_11_bwd_loop_L1:
 movaps -0x1b(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x2b(%rsi), %xmm3
 movaps -0x3b(%rsi), %xmm4
 movaps -0x4b(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $11, %xmm2, %xmm1
 palignr $11, %xmm3, %xmm2
 palignr $11, %xmm4, %xmm3
 palignr $11, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_11_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_11_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_12:
 lea (.Lshl_12_loop_L1-.Lshl_12)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0c(%rsi), %xmm1
 jb .LL12_fwd
 lea (.Lshl_12_loop_L2-.Lshl_12_loop_L1)(%r9), %r9
.LL12_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_12_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_12_loop_L1:
 sub $64, %rdx
 movaps 0x04(%rsi), %xmm2
 movaps 0x14(%rsi), %xmm3
 movaps 0x24(%rsi), %xmm4
 movaps 0x34(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $12, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $12, %xmm3, %xmm4
 palignr $12, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $12, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_12_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_12_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_12_bwd:
 lea (.Lshl_12_bwd_loop_L1-.Lshl_12_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0c(%rsi), %xmm1
 jb .LL12_bwd
 lea (.Lshl_12_bwd_loop_L2-.Lshl_12_bwd_loop_L1)(%r9), %r9
.LL12_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_12_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_12_bwd_loop_L1:
 movaps -0x1c(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x2c(%rsi), %xmm3
 movaps -0x3c(%rsi), %xmm4
 movaps -0x4c(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $12, %xmm2, %xmm1
 palignr $12, %xmm3, %xmm2
 palignr $12, %xmm4, %xmm3
 palignr $12, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_12_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_12_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_13:
 lea (.Lshl_13_loop_L1-.Lshl_13)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0d(%rsi), %xmm1
 jb .LL13_fwd
 lea (.Lshl_13_loop_L2-.Lshl_13_loop_L1)(%r9), %r9
.LL13_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_13_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_13_loop_L1:
 sub $64, %rdx
 movaps 0x03(%rsi), %xmm2
 movaps 0x13(%rsi), %xmm3
 movaps 0x23(%rsi), %xmm4
 movaps 0x33(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $13, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $13, %xmm3, %xmm4
 palignr $13, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $13, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_13_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_13_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_13_bwd:
 lea (.Lshl_13_bwd_loop_L1-.Lshl_13_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0d(%rsi), %xmm1
 jb .LL13_bwd
 lea (.Lshl_13_bwd_loop_L2-.Lshl_13_bwd_loop_L1)(%r9), %r9
.LL13_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_13_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_13_bwd_loop_L1:
 movaps -0x1d(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x2d(%rsi), %xmm3
 movaps -0x3d(%rsi), %xmm4
 movaps -0x4d(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $13, %xmm2, %xmm1
 palignr $13, %xmm3, %xmm2
 palignr $13, %xmm4, %xmm3
 palignr $13, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_13_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_13_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_14:
 lea (.Lshl_14_loop_L1-.Lshl_14)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0e(%rsi), %xmm1
 jb .LL14_fwd
 lea (.Lshl_14_loop_L2-.Lshl_14_loop_L1)(%r9), %r9
.LL14_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_14_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_14_loop_L1:
 sub $64, %rdx
 movaps 0x02(%rsi), %xmm2
 movaps 0x12(%rsi), %xmm3
 movaps 0x22(%rsi), %xmm4
 movaps 0x32(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $14, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $14, %xmm3, %xmm4
 palignr $14, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $14, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_14_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_14_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_14_bwd:
 lea (.Lshl_14_bwd_loop_L1-.Lshl_14_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0e(%rsi), %xmm1
 jb .LL14_bwd
 lea (.Lshl_14_bwd_loop_L2-.Lshl_14_bwd_loop_L1)(%r9), %r9
.LL14_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_14_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_14_bwd_loop_L1:
 movaps -0x1e(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x2e(%rsi), %xmm3
 movaps -0x3e(%rsi), %xmm4
 movaps -0x4e(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $14, %xmm2, %xmm1
 palignr $14, %xmm3, %xmm2
 palignr $14, %xmm4, %xmm3
 palignr $14, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_14_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_14_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_15:
 lea (.Lshl_15_loop_L1-.Lshl_15)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0f(%rsi), %xmm1
 jb .LL15_fwd
 lea (.Lshl_15_loop_L2-.Lshl_15_loop_L1)(%r9), %r9
.LL15_fwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_15_loop_L2:
 prefetchnta 0x1c0(%rsi)
.Lshl_15_loop_L1:
 sub $64, %rdx
 movaps 0x01(%rsi), %xmm2
 movaps 0x11(%rsi), %xmm3
 movaps 0x21(%rsi), %xmm4
 movaps 0x31(%rsi), %xmm5
 movdqa %xmm5, %xmm6
 palignr $15, %xmm4, %xmm5
 lea 64(%rsi), %rsi
 palignr $15, %xmm3, %xmm4
 palignr $15, %xmm2, %xmm3
 lea 64(%rdi), %rdi
 palignr $15, %xmm1, %xmm2
 movdqa %xmm6, %xmm1
 movdqa %xmm2, -0x40(%rdi)
 movaps %xmm3, -0x30(%rdi)
 jb .Lshl_15_end
 movaps %xmm4, -0x20(%rdi)
 movaps %xmm5, -0x10(%rdi)
 jmp *%r9
 ud2
.Lshl_15_end:
 movaps %xmm4, -0x20(%rdi)
 lea 64(%rdx), %rdx
 movaps %xmm5, -0x10(%rdi)
 add %rdx, %rdi
 movdqu %xmm0, (%r8)
 add %rdx, %rsi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_15_bwd:
 lea (.Lshl_15_bwd_loop_L1-.Lshl_15_bwd)(%r9), %r9
 cmp %rcx, %rdx
 movaps -0x0f(%rsi), %xmm1
 jb .LL15_bwd
 lea (.Lshl_15_bwd_loop_L2-.Lshl_15_bwd_loop_L1)(%r9), %r9
.LL15_bwd:
 lea -64(%rdx), %rdx
 jmp *%r9
 ud2
.Lshl_15_bwd_loop_L2:
 prefetchnta -0x1c0(%rsi)
.Lshl_15_bwd_loop_L1:
 movaps -0x1f(%rsi), %xmm2
 sub $0x40, %rdx
 movaps -0x2f(%rsi), %xmm3
 movaps -0x3f(%rsi), %xmm4
 movaps -0x4f(%rsi), %xmm5
 lea -0x40(%rsi), %rsi
 palignr $15, %xmm2, %xmm1
 palignr $15, %xmm3, %xmm2
 palignr $15, %xmm4, %xmm3
 palignr $15, %xmm5, %xmm4

 movaps %xmm1, -0x10(%rdi)
 movaps %xmm5, %xmm1

 movaps %xmm2, -0x20(%rdi)
 lea -0x40(%rdi), %rdi

 movaps %xmm3, 0x10(%rdi)
 jb .Lshl_15_bwd_end
 movaps %xmm4, (%rdi)
 jmp *%r9
 ud2
.Lshl_15_bwd_end:
 movaps %xmm4, (%rdi)
 lea 64(%rdx), %rdx
 movdqu %xmm0, (%r8)
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lwrite_72bytes:
 movdqu -72(%rsi), %xmm0
 movdqu -56(%rsi), %xmm1
 mov -40(%rsi), %r8
 mov -32(%rsi), %r9
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rcx
 movdqu %xmm0, -72(%rdi)
 movdqu %xmm1, -56(%rdi)
 mov %r8, -40(%rdi)
 mov %r9, -32(%rdi)
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rcx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_64bytes:
 movdqu -64(%rsi), %xmm0
 mov -48(%rsi), %rcx
 mov -40(%rsi), %r8
 mov -32(%rsi), %r9
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rdx
 movdqu %xmm0, -64(%rdi)
 mov %rcx, -48(%rdi)
 mov %r8, -40(%rdi)
 mov %r9, -32(%rdi)
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_56bytes:
 movdqu -56(%rsi), %xmm0
 mov -40(%rsi), %r8
 mov -32(%rsi), %r9
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rcx
 movdqu %xmm0, -56(%rdi)
 mov %r8, -40(%rdi)
 mov %r9, -32(%rdi)
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rcx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_48bytes:
 mov -48(%rsi), %rcx
 mov -40(%rsi), %r8
 mov -32(%rsi), %r9
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rdx
 mov %rcx, -48(%rdi)
 mov %r8, -40(%rdi)
 mov %r9, -32(%rdi)
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_40bytes:
 mov -40(%rsi), %r8
 mov -32(%rsi), %r9
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rdx
 mov %r8, -40(%rdi)
 mov %r9, -32(%rdi)
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_32bytes:
 mov -32(%rsi), %r9
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rdx
 mov %r9, -32(%rdi)
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_24bytes:
 mov -24(%rsi), %r10
 mov -16(%rsi), %r11
 mov -8(%rsi), %rdx
 mov %r10, -24(%rdi)
 mov %r11, -16(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_16bytes:
 mov -16(%rsi), %r11
 mov -8(%rsi), %rdx
 mov %r11, -16(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_8bytes:
 mov -8(%rsi), %rdx
 mov %rdx, -8(%rdi)
.Lwrite_0bytes:
 ret

 .p2align 4
.Lwrite_73bytes:
 movdqu -73(%rsi), %xmm0
 movdqu -57(%rsi), %xmm1
 mov -41(%rsi), %rcx
 mov -33(%rsi), %r9
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %r8
 mov -4(%rsi), %edx
 movdqu %xmm0, -73(%rdi)
 movdqu %xmm1, -57(%rdi)
 mov %rcx, -41(%rdi)
 mov %r9, -33(%rdi)
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %r8, -9(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_65bytes:
 movdqu -65(%rsi), %xmm0
 movdqu -49(%rsi), %xmm1
 mov -33(%rsi), %r9
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -65(%rdi)
 movdqu %xmm1, -49(%rdi)
 mov %r9, -33(%rdi)
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_57bytes:
 movdqu -57(%rsi), %xmm0
 mov -41(%rsi), %r8
 mov -33(%rsi), %r9
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -57(%rdi)
 mov %r8, -41(%rdi)
 mov %r9, -33(%rdi)
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_49bytes:
 movdqu -49(%rsi), %xmm0
 mov -33(%rsi), %r9
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -49(%rdi)
 mov %r9, -33(%rdi)
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_41bytes:
 mov -41(%rsi), %r8
 mov -33(%rsi), %r9
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -1(%rsi), %dl
 mov %r8, -41(%rdi)
 mov %r9, -33(%rdi)
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %dl, -1(%rdi)
 ret

 .p2align 4
.Lwrite_33bytes:
 mov -33(%rsi), %r9
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -1(%rsi), %dl
 mov %r9, -33(%rdi)
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %dl, -1(%rdi)
 ret

 .p2align 4
.Lwrite_25bytes:
 mov -25(%rsi), %r10
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -1(%rsi), %dl
 mov %r10, -25(%rdi)
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %dl, -1(%rdi)
 ret

 .p2align 4
.Lwrite_17bytes:
 mov -17(%rsi), %r11
 mov -9(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r11, -17(%rdi)
 mov %rcx, -9(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_9bytes:
 mov -9(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %rcx, -9(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_1bytes:
 mov -1(%rsi), %dl
 mov %dl, -1(%rdi)
 ret

 .p2align 4
.Lwrite_74bytes:
 movdqu -74(%rsi), %xmm0
 movdqu -58(%rsi), %xmm1
 mov -42(%rsi), %r8
 mov -34(%rsi), %r9
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -74(%rdi)
 movdqu %xmm1, -58(%rdi)
 mov %r8, -42(%rdi)
 mov %r9, -34(%rdi)
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_66bytes:
 movdqu -66(%rsi), %xmm0
 movdqu -50(%rsi), %xmm1
 mov -42(%rsi), %r8
 mov -34(%rsi), %r9
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -66(%rdi)
 movdqu %xmm1, -50(%rdi)
 mov %r8, -42(%rdi)
 mov %r9, -34(%rdi)
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_58bytes:
 movdqu -58(%rsi), %xmm1
 mov -42(%rsi), %r8
 mov -34(%rsi), %r9
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm1, -58(%rdi)
 mov %r8, -42(%rdi)
 mov %r9, -34(%rdi)
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_50bytes:
 movdqu -50(%rsi), %xmm0
 mov -34(%rsi), %r9
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -50(%rdi)
 mov %r9, -34(%rdi)
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_42bytes:
 mov -42(%rsi), %r8
 mov -34(%rsi), %r9
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r8, -42(%rdi)
 mov %r9, -34(%rdi)
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_34bytes:
 mov -34(%rsi), %r9
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r9, -34(%rdi)
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_26bytes:
 mov -26(%rsi), %r10
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r10, -26(%rdi)
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_18bytes:
 mov -18(%rsi), %r11
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r11, -18(%rdi)
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_10bytes:
 mov -10(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %rcx, -10(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_2bytes:
 mov -2(%rsi), %dx
 mov %dx, -2(%rdi)
 ret

 .p2align 4
.Lwrite_75bytes:
 movdqu -75(%rsi), %xmm0
 movdqu -59(%rsi), %xmm1
 mov -43(%rsi), %r8
 mov -35(%rsi), %r9
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -75(%rdi)
 movdqu %xmm1, -59(%rdi)
 mov %r8, -43(%rdi)
 mov %r9, -35(%rdi)
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_67bytes:
 movdqu -67(%rsi), %xmm0
 movdqu -59(%rsi), %xmm1
 mov -43(%rsi), %r8
 mov -35(%rsi), %r9
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -67(%rdi)
 movdqu %xmm1, -59(%rdi)
 mov %r8, -43(%rdi)
 mov %r9, -35(%rdi)
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_59bytes:
 movdqu -59(%rsi), %xmm0
 mov -43(%rsi), %r8
 mov -35(%rsi), %r9
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -59(%rdi)
 mov %r8, -43(%rdi)
 mov %r9, -35(%rdi)
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_51bytes:
 movdqu -51(%rsi), %xmm0
 mov -35(%rsi), %r9
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -51(%rdi)
 mov %r9, -35(%rdi)
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_43bytes:
 mov -43(%rsi), %r8
 mov -35(%rsi), %r9
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r8, -43(%rdi)
 mov %r9, -35(%rdi)
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_35bytes:
 mov -35(%rsi), %r9
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r9, -35(%rdi)
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_27bytes:
 mov -27(%rsi), %r10
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r10, -27(%rdi)
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_19bytes:
 mov -19(%rsi), %r11
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r11, -19(%rdi)
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_11bytes:
 mov -11(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %rcx, -11(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_3bytes:
 mov -3(%rsi), %dx
 mov -2(%rsi), %cx
 mov %dx, -3(%rdi)
 mov %cx, -2(%rdi)
 ret

 .p2align 4
.Lwrite_76bytes:
 movdqu -76(%rsi), %xmm0
 movdqu -60(%rsi), %xmm1
 mov -44(%rsi), %r8
 mov -36(%rsi), %r9
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -76(%rdi)
 movdqu %xmm1, -60(%rdi)
 mov %r8, -44(%rdi)
 mov %r9, -36(%rdi)
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_68bytes:
 movdqu -68(%rsi), %xmm0
 movdqu -52(%rsi), %xmm1
 mov -36(%rsi), %r9
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -68(%rdi)
 movdqu %xmm1, -52(%rdi)
 mov %r9, -36(%rdi)
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_60bytes:
 movdqu -60(%rsi), %xmm0
 mov -44(%rsi), %r8
 mov -36(%rsi), %r9
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -60(%rdi)
 mov %r8, -44(%rdi)
 mov %r9, -36(%rdi)
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_52bytes:
 movdqu -52(%rsi), %xmm0
 mov -36(%rsi), %r9
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 movdqu %xmm0, -52(%rdi)
 mov %r9, -36(%rdi)
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_44bytes:
 mov -44(%rsi), %r8
 mov -36(%rsi), %r9
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r8, -44(%rdi)
 mov %r9, -36(%rdi)
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_36bytes:
 mov -36(%rsi), %r9
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r9, -36(%rdi)
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_28bytes:
 mov -28(%rsi), %r10
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r10, -28(%rdi)
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_20bytes:
 mov -20(%rsi), %r11
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %r11, -20(%rdi)
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_12bytes:
 mov -12(%rsi), %rcx
 mov -4(%rsi), %edx
 mov %rcx, -12(%rdi)
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_4bytes:
 mov -4(%rsi), %edx
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_77bytes:
 movdqu -77(%rsi), %xmm0
 movdqu -61(%rsi), %xmm1
 mov -45(%rsi), %r8
 mov -37(%rsi), %r9
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -77(%rdi)
 movdqu %xmm1, -61(%rdi)
 mov %r8, -45(%rdi)
 mov %r9, -37(%rdi)
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_69bytes:
 movdqu -69(%rsi), %xmm0
 movdqu -53(%rsi), %xmm1
 mov -37(%rsi), %r9
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -69(%rdi)
 movdqu %xmm1, -53(%rdi)
 mov %r9, -37(%rdi)
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_61bytes:
 movdqu -61(%rsi), %xmm0
 mov -45(%rsi), %r8
 mov -37(%rsi), %r9
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -61(%rdi)
 mov %r8, -45(%rdi)
 mov %r9, -37(%rdi)
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_53bytes:
 movdqu -53(%rsi), %xmm0
 mov -45(%rsi), %r8
 mov -37(%rsi), %r9
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -53(%rdi)
 mov %r9, -37(%rdi)
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_45bytes:
 mov -45(%rsi), %r8
 mov -37(%rsi), %r9
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r8, -45(%rdi)
 mov %r9, -37(%rdi)
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_37bytes:
 mov -37(%rsi), %r9
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r9, -37(%rdi)
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_29bytes:
 mov -29(%rsi), %r10
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r10, -29(%rdi)
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_21bytes:
 mov -21(%rsi), %r11
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r11, -21(%rdi)
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_13bytes:
 mov -13(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %rcx, -13(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_5bytes:
 mov -5(%rsi), %edx
 mov -4(%rsi), %ecx
 mov %edx, -5(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_78bytes:
 movdqu -78(%rsi), %xmm0
 movdqu -62(%rsi), %xmm1
 mov -46(%rsi), %r8
 mov -38(%rsi), %r9
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -78(%rdi)
 movdqu %xmm1, -62(%rdi)
 mov %r8, -46(%rdi)
 mov %r9, -38(%rdi)
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_70bytes:
 movdqu -70(%rsi), %xmm0
 movdqu -54(%rsi), %xmm1
 mov -38(%rsi), %r9
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -70(%rdi)
 movdqu %xmm1, -54(%rdi)
 mov %r9, -38(%rdi)
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_62bytes:
 movdqu -62(%rsi), %xmm0
 mov -46(%rsi), %r8
 mov -38(%rsi), %r9
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -62(%rdi)
 mov %r8, -46(%rdi)
 mov %r9, -38(%rdi)
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_54bytes:
 movdqu -54(%rsi), %xmm0
 mov -38(%rsi), %r9
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -54(%rdi)
 mov %r9, -38(%rdi)
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_46bytes:
 mov -46(%rsi), %r8
 mov -38(%rsi), %r9
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r8, -46(%rdi)
 mov %r9, -38(%rdi)
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_38bytes:
 mov -38(%rsi), %r9
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r9, -38(%rdi)
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_30bytes:
 mov -30(%rsi), %r10
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r10, -30(%rdi)
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_22bytes:
 mov -22(%rsi), %r11
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r11, -22(%rdi)
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_14bytes:
 mov -14(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %rcx, -14(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_6bytes:
 mov -6(%rsi), %edx
 mov -4(%rsi), %ecx
 mov %edx, -6(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lwrite_79bytes:
 movdqu -79(%rsi), %xmm0
 movdqu -63(%rsi), %xmm1
 mov -47(%rsi), %r8
 mov -39(%rsi), %r9
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -79(%rdi)
 movdqu %xmm1, -63(%rdi)
 mov %r8, -47(%rdi)
 mov %r9, -39(%rdi)
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_71bytes:
 movdqu -71(%rsi), %xmm0
 movdqu -55(%rsi), %xmm1
 mov -39(%rsi), %r9
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -71(%rdi)
 movdqu %xmm1, -55(%rdi)
 mov %r9, -39(%rdi)
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_63bytes:
 movdqu -63(%rsi), %xmm0
 mov -47(%rsi), %r8
 mov -39(%rsi), %r9
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -63(%rdi)
 mov %r8, -47(%rdi)
 mov %r9, -39(%rdi)
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_55bytes:
 movdqu -55(%rsi), %xmm0
 mov -39(%rsi), %r9
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 movdqu %xmm0, -55(%rdi)
 mov %r9, -39(%rdi)
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_47bytes:
 mov -47(%rsi), %r8
 mov -39(%rsi), %r9
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r8, -47(%rdi)
 mov %r9, -39(%rdi)
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_39bytes:
 mov -39(%rsi), %r9
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r9, -39(%rdi)
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_31bytes:
 mov -31(%rsi), %r10
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r10, -31(%rdi)
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_23bytes:
 mov -23(%rsi), %r11
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %r11, -23(%rdi)
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_15bytes:
 mov -15(%rsi), %rcx
 mov -8(%rsi), %rdx
 mov %rcx, -15(%rdi)
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lwrite_7bytes:
 mov -7(%rsi), %edx
 mov -4(%rsi), %ecx
 mov %edx, -7(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Llarge_page_fwd:
 movdqu (%rsi), %xmm1
 lea 16(%rsi), %rsi
 movdqu %xmm0, (%r8)
 movntdq %xmm1, (%rdi)
 lea 16(%rdi), %rdi
 lea -0x90(%rdx), %rdx

 mov %rsi, %r9
 sub %rdi, %r9
 cmp %rdx, %r9
 jae .Lmemmove_is_memcpy_fwd
 shl $2, %rcx
 cmp %rcx, %rdx
 jb .Lll_cache_copy_fwd_start
.Lmemmove_is_memcpy_fwd:

.Llarge_page_loop:
 movdqu (%rsi), %xmm0
 movdqu 0x10(%rsi), %xmm1
 movdqu 0x20(%rsi), %xmm2
 movdqu 0x30(%rsi), %xmm3
 movdqu 0x40(%rsi), %xmm4
 movdqu 0x50(%rsi), %xmm5
 movdqu 0x60(%rsi), %xmm6
 movdqu 0x70(%rsi), %xmm7
 lea 0x80(%rsi), %rsi

 sub $0x80, %rdx
 movntdq %xmm0, (%rdi)
 movntdq %xmm1, 0x10(%rdi)
 movntdq %xmm2, 0x20(%rdi)
 movntdq %xmm3, 0x30(%rdi)
 movntdq %xmm4, 0x40(%rdi)
 movntdq %xmm5, 0x50(%rdi)
 movntdq %xmm6, 0x60(%rdi)
 movntdq %xmm7, 0x70(%rdi)
 lea 0x80(%rdi), %rdi
 jae .Llarge_page_loop
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Llarge_page_less_64bytes

 movdqu (%rsi), %xmm0
 movdqu 0x10(%rsi), %xmm1
 movdqu 0x20(%rsi), %xmm2
 movdqu 0x30(%rsi), %xmm3
 lea 0x40(%rsi), %rsi

 movntdq %xmm0, (%rdi)
 movntdq %xmm1, 0x10(%rdi)
 movntdq %xmm2, 0x20(%rdi)
 movntdq %xmm3, 0x30(%rdi)
 lea 0x40(%rdi), %rdi
 sub $0x40, %rdx
.Llarge_page_less_64bytes:
 add %rdx, %rsi
 add %rdx, %rdi
 sfence
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lll_cache_copy_fwd_start:
 prefetcht0 0x1c0(%rsi)
 prefetcht0 0x200(%rsi)
 movdqu (%rsi), %xmm0
 movdqu 0x10(%rsi), %xmm1
 movdqu 0x20(%rsi), %xmm2
 movdqu 0x30(%rsi), %xmm3
 movdqu 0x40(%rsi), %xmm4
 movdqu 0x50(%rsi), %xmm5
 movdqu 0x60(%rsi), %xmm6
 movdqu 0x70(%rsi), %xmm7
 lea 0x80(%rsi), %rsi

 sub $0x80, %rdx
 movaps %xmm0, (%rdi)
 movaps %xmm1, 0x10(%rdi)
 movaps %xmm2, 0x20(%rdi)
 movaps %xmm3, 0x30(%rdi)
 movaps %xmm4, 0x40(%rdi)
 movaps %xmm5, 0x50(%rdi)
 movaps %xmm6, 0x60(%rdi)
 movaps %xmm7, 0x70(%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lll_cache_copy_fwd_start
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Llarge_page_ll_less_fwd_64bytes

 movdqu (%rsi), %xmm0
 movdqu 0x10(%rsi), %xmm1
 movdqu 0x20(%rsi), %xmm2
 movdqu 0x30(%rsi), %xmm3
 lea 0x40(%rsi), %rsi

 movaps %xmm0, (%rdi)
 movaps %xmm1, 0x10(%rdi)
 movaps %xmm2, 0x20(%rdi)
 movaps %xmm3, 0x30(%rdi)
 lea 0x40(%rdi), %rdi
 sub $0x40, %rdx
.Llarge_page_ll_less_fwd_64bytes:
 add %rdx, %rsi
 add %rdx, %rdi
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Llarge_page_bwd:
 movdqu -0x10(%rsi), %xmm1
 lea -16(%rsi), %rsi
 movdqu %xmm0, (%r8)
 movdqa %xmm1, -0x10(%rdi)
 lea -16(%rdi), %rdi
 lea -0x90(%rdx), %rdx

 mov %rdi, %r9
 sub %rsi, %r9
 cmp %rdx, %r9
 jae .Lmemmove_is_memcpy_bwd
 cmp %rcx, %r9
 jb .Lll_cache_copy_bwd_start
.Lmemmove_is_memcpy_bwd:

.Llarge_page_bwd_loop:
 movdqu -0x10(%rsi), %xmm0
 movdqu -0x20(%rsi), %xmm1
 movdqu -0x30(%rsi), %xmm2
 movdqu -0x40(%rsi), %xmm3
 movdqu -0x50(%rsi), %xmm4
 movdqu -0x60(%rsi), %xmm5
 movdqu -0x70(%rsi), %xmm6
 movdqu -0x80(%rsi), %xmm7
 lea -0x80(%rsi), %rsi

 sub $0x80, %rdx
 movntdq %xmm0, -0x10(%rdi)
 movntdq %xmm1, -0x20(%rdi)
 movntdq %xmm2, -0x30(%rdi)
 movntdq %xmm3, -0x40(%rdi)
 movntdq %xmm4, -0x50(%rdi)
 movntdq %xmm5, -0x60(%rdi)
 movntdq %xmm6, -0x70(%rdi)
 movntdq %xmm7, -0x80(%rdi)
 lea -0x80(%rdi), %rdi
 jae .Llarge_page_bwd_loop
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Llarge_page_less_bwd_64bytes

 movdqu -0x10(%rsi), %xmm0
 movdqu -0x20(%rsi), %xmm1
 movdqu -0x30(%rsi), %xmm2
 movdqu -0x40(%rsi), %xmm3
 lea -0x40(%rsi), %rsi

 movntdq %xmm0, -0x10(%rdi)
 movntdq %xmm1, -0x20(%rdi)
 movntdq %xmm2, -0x30(%rdi)
 movntdq %xmm3, -0x40(%rdi)
 lea -0x40(%rdi), %rdi
 sub $0x40, %rdx
.Llarge_page_less_bwd_64bytes:
 sfence
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lll_cache_copy_bwd_start:
 prefetcht0 -0x1c0(%rsi)
 prefetcht0 -0x200(%rsi)
 movdqu -0x10(%rsi), %xmm0
 movdqu -0x20(%rsi), %xmm1
 movdqu -0x30(%rsi), %xmm2
 movdqu -0x40(%rsi), %xmm3
 movdqu -0x50(%rsi), %xmm4
 movdqu -0x60(%rsi), %xmm5
 movdqu -0x70(%rsi), %xmm6
 movdqu -0x80(%rsi), %xmm7
 lea -0x80(%rsi), %rsi

 sub $0x80, %rdx
 movaps %xmm0, -0x10(%rdi)
 movaps %xmm1, -0x20(%rdi)
 movaps %xmm2, -0x30(%rdi)
 movaps %xmm3, -0x40(%rdi)
 movaps %xmm4, -0x50(%rdi)
 movaps %xmm5, -0x60(%rdi)
 movaps %xmm6, -0x70(%rdi)
 movaps %xmm7, -0x80(%rdi)
 lea -0x80(%rdi), %rdi
 jae .Lll_cache_copy_bwd_start
 cmp $-0x40, %rdx
 lea 0x80(%rdx), %rdx
 jl .Llarge_page_ll_less_bwd_64bytes

 movdqu -0x10(%rsi), %xmm0
 movdqu -0x20(%rsi), %xmm1
 movdqu -0x30(%rsi), %xmm2
 movdqu -0x40(%rsi), %xmm3
 lea -0x40(%rsi), %rsi

 movaps %xmm0, -0x10(%rdi)
 movaps %xmm1, -0x20(%rdi)
 movaps %xmm2, -0x30(%rdi)
 movaps %xmm3, -0x40(%rdi)
 lea -0x40(%rdi), %rdi
 sub $0x40, %rdx
.Llarge_page_ll_less_bwd_64bytes:
 lea .Ltable_less_80bytes(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .section .rodata.ssse3
 .p2align 3
.Ltable_less_80bytes:
 .int .Lwrite_0bytes - .Ltable_less_80bytes
 .int .Lwrite_1bytes - .Ltable_less_80bytes
 .int .Lwrite_2bytes - .Ltable_less_80bytes
 .int .Lwrite_3bytes - .Ltable_less_80bytes
 .int .Lwrite_4bytes - .Ltable_less_80bytes
 .int .Lwrite_5bytes - .Ltable_less_80bytes
 .int .Lwrite_6bytes - .Ltable_less_80bytes
 .int .Lwrite_7bytes - .Ltable_less_80bytes
 .int .Lwrite_8bytes - .Ltable_less_80bytes
 .int .Lwrite_9bytes - .Ltable_less_80bytes
 .int .Lwrite_10bytes - .Ltable_less_80bytes
 .int .Lwrite_11bytes - .Ltable_less_80bytes
 .int .Lwrite_12bytes - .Ltable_less_80bytes
 .int .Lwrite_13bytes - .Ltable_less_80bytes
 .int .Lwrite_14bytes - .Ltable_less_80bytes
 .int .Lwrite_15bytes - .Ltable_less_80bytes
 .int .Lwrite_16bytes - .Ltable_less_80bytes
 .int .Lwrite_17bytes - .Ltable_less_80bytes
 .int .Lwrite_18bytes - .Ltable_less_80bytes
 .int .Lwrite_19bytes - .Ltable_less_80bytes
 .int .Lwrite_20bytes - .Ltable_less_80bytes
 .int .Lwrite_21bytes - .Ltable_less_80bytes
 .int .Lwrite_22bytes - .Ltable_less_80bytes
 .int .Lwrite_23bytes - .Ltable_less_80bytes
 .int .Lwrite_24bytes - .Ltable_less_80bytes
 .int .Lwrite_25bytes - .Ltable_less_80bytes
 .int .Lwrite_26bytes - .Ltable_less_80bytes
 .int .Lwrite_27bytes - .Ltable_less_80bytes
 .int .Lwrite_28bytes - .Ltable_less_80bytes
 .int .Lwrite_29bytes - .Ltable_less_80bytes
 .int .Lwrite_30bytes - .Ltable_less_80bytes
 .int .Lwrite_31bytes - .Ltable_less_80bytes
 .int .Lwrite_32bytes - .Ltable_less_80bytes
 .int .Lwrite_33bytes - .Ltable_less_80bytes
 .int .Lwrite_34bytes - .Ltable_less_80bytes
 .int .Lwrite_35bytes - .Ltable_less_80bytes
 .int .Lwrite_36bytes - .Ltable_less_80bytes
 .int .Lwrite_37bytes - .Ltable_less_80bytes
 .int .Lwrite_38bytes - .Ltable_less_80bytes
 .int .Lwrite_39bytes - .Ltable_less_80bytes
 .int .Lwrite_40bytes - .Ltable_less_80bytes
 .int .Lwrite_41bytes - .Ltable_less_80bytes
 .int .Lwrite_42bytes - .Ltable_less_80bytes
 .int .Lwrite_43bytes - .Ltable_less_80bytes
 .int .Lwrite_44bytes - .Ltable_less_80bytes
 .int .Lwrite_45bytes - .Ltable_less_80bytes
 .int .Lwrite_46bytes - .Ltable_less_80bytes
 .int .Lwrite_47bytes - .Ltable_less_80bytes
 .int .Lwrite_48bytes - .Ltable_less_80bytes
 .int .Lwrite_49bytes - .Ltable_less_80bytes
 .int .Lwrite_50bytes - .Ltable_less_80bytes
 .int .Lwrite_51bytes - .Ltable_less_80bytes
 .int .Lwrite_52bytes - .Ltable_less_80bytes
 .int .Lwrite_53bytes - .Ltable_less_80bytes
 .int .Lwrite_54bytes - .Ltable_less_80bytes
 .int .Lwrite_55bytes - .Ltable_less_80bytes
 .int .Lwrite_56bytes - .Ltable_less_80bytes
 .int .Lwrite_57bytes - .Ltable_less_80bytes
 .int .Lwrite_58bytes - .Ltable_less_80bytes
 .int .Lwrite_59bytes - .Ltable_less_80bytes
 .int .Lwrite_60bytes - .Ltable_less_80bytes
 .int .Lwrite_61bytes - .Ltable_less_80bytes
 .int .Lwrite_62bytes - .Ltable_less_80bytes
 .int .Lwrite_63bytes - .Ltable_less_80bytes
 .int .Lwrite_64bytes - .Ltable_less_80bytes
 .int .Lwrite_65bytes - .Ltable_less_80bytes
 .int .Lwrite_66bytes - .Ltable_less_80bytes
 .int .Lwrite_67bytes - .Ltable_less_80bytes
 .int .Lwrite_68bytes - .Ltable_less_80bytes
 .int .Lwrite_69bytes - .Ltable_less_80bytes
 .int .Lwrite_70bytes - .Ltable_less_80bytes
 .int .Lwrite_71bytes - .Ltable_less_80bytes
 .int .Lwrite_72bytes - .Ltable_less_80bytes
 .int .Lwrite_73bytes - .Ltable_less_80bytes
 .int .Lwrite_74bytes - .Ltable_less_80bytes
 .int .Lwrite_75bytes - .Ltable_less_80bytes
 .int .Lwrite_76bytes - .Ltable_less_80bytes
 .int .Lwrite_77bytes - .Ltable_less_80bytes
 .int .Lwrite_78bytes - .Ltable_less_80bytes
 .int .Lwrite_79bytes - .Ltable_less_80bytes

 .p2align 3
.Lshl_table:
 .int .Lshl_0 - .Lshl_table
 .int .Lshl_1 - .Lshl_table
 .int .Lshl_2 - .Lshl_table
 .int .Lshl_3 - .Lshl_table
 .int .Lshl_4 - .Lshl_table
 .int .Lshl_5 - .Lshl_table
 .int .Lshl_6 - .Lshl_table
 .int .Lshl_7 - .Lshl_table
 .int .Lshl_8 - .Lshl_table
 .int .Lshl_9 - .Lshl_table
 .int .Lshl_10 - .Lshl_table
 .int .Lshl_11 - .Lshl_table
 .int .Lshl_12 - .Lshl_table
 .int .Lshl_13 - .Lshl_table
 .int .Lshl_14 - .Lshl_table
 .int .Lshl_15 - .Lshl_table

 .p2align 3
.Lshl_table_bwd:
 .int .Lshl_0_bwd - .Lshl_table_bwd
 .int .Lshl_1_bwd - .Lshl_table_bwd
 .int .Lshl_2_bwd - .Lshl_table_bwd
 .int .Lshl_3_bwd - .Lshl_table_bwd
 .int .Lshl_4_bwd - .Lshl_table_bwd
 .int .Lshl_5_bwd - .Lshl_table_bwd
 .int .Lshl_6_bwd - .Lshl_table_bwd
 .int .Lshl_7_bwd - .Lshl_table_bwd
 .int .Lshl_8_bwd - .Lshl_table_bwd
 .int .Lshl_9_bwd - .Lshl_table_bwd
 .int .Lshl_10_bwd - .Lshl_table_bwd
 .int .Lshl_11_bwd - .Lshl_table_bwd
 .int .Lshl_12_bwd - .Lshl_table_bwd
 .int .Lshl_13_bwd - .Lshl_table_bwd
 .int .Lshl_14_bwd - .Lshl_table_bwd
 .int .Lshl_15_bwd - .Lshl_table_bwd
