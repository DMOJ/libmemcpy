 .section .text.ssse3
.globl __memmove_ssse3_back
__memmove_ssse3_back:
 mov %rdi, %rax
 cmp %rsi, %rdi
 jb .Lcopy_forward
 je .Lbwd_write_0bytes
 cmp $144, %rdx
 jae .Lcopy_backward
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2
.Lcopy_forward:

.Lstart:
 cmp $144, %rdx
 jae .L144bytesormore

.Lfwd_write_less32bytes:

 add %rdx, %rsi
 add %rdx, %rdi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.L144bytesormore:

 movdqu (%rsi), %xmm0
 mov %rdi, %r8
 and $-16, %rdi
 add $16, %rdi
 mov %rdi, %r9
 sub %r8, %r9
 sub %r9, %rdx
 add %r9, %rsi
 mov %rsi, %r9
 and $0xf, %r9
 jz .Lshl_0

 mov __x86_data_cache_size(%rip), %rcx

 cmp %rcx, %rdx
 jae .Lgobble_mem_fwd
 lea .Lshl_table_fwd(%rip), %r11
 sub $0x80, %rdx
 movslq (%r11, %r9, 4), %r9
 add %r11, %r9
 jmp *%r9
 ud2

 .p2align 4
.Lcopy_backward:

 mov __x86_data_cache_size(%rip), %rcx

 shl $1, %rcx
 cmp %rcx, %rdx
 ja .Lgobble_mem_bwd

 add %rdx, %rdi
 add %rdx, %rsi
 movdqu -16(%rsi), %xmm0
 lea -16(%rdi), %r8
 mov %rdi, %r9
 and $0xf, %r9
 xor %r9, %rdi
 sub %r9, %rsi
 sub %r9, %rdx
 mov %rsi, %r9
 and $0xf, %r9
 jz .Lshl_0_bwd
 lea .Lshl_table_bwd(%rip), %r11
 sub $0x80, %rdx
 movslq (%r11, %r9, 4), %r9
 add %r11, %r9
 jmp *%r9
 ud2

 .p2align 4
.Lshl_0:

 mov %rdx, %r9
 shr $8, %r9
 add %rdx, %r9

 cmp __x86_data_cache_size_half(%rip), %r9

 jae .Lgobble_mem_fwd
 sub $0x80, %rdx
 .p2align 4
.Lshl_0_loop:
 movdqa (%rsi), %xmm1
 movdqa %xmm1, (%rdi)
 movaps 0x10(%rsi), %xmm2
 movaps %xmm2, 0x10(%rdi)
 movaps 0x20(%rsi), %xmm3
 movaps %xmm3, 0x20(%rdi)
 movaps 0x30(%rsi), %xmm4
 movaps %xmm4, 0x30(%rdi)
 movaps 0x40(%rsi), %xmm1
 movaps %xmm1, 0x40(%rdi)
 movaps 0x50(%rsi), %xmm2
 movaps %xmm2, 0x50(%rdi)
 movaps 0x60(%rsi), %xmm3
 movaps %xmm3, 0x60(%rdi)
 movaps 0x70(%rsi), %xmm4
 movaps %xmm4, 0x70(%rdi)
 sub $0x80, %rdx
 lea 0x80(%rsi), %rsi
 lea 0x80(%rdi), %rdi
 jae .Lshl_0_loop
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rsi
 add %rdx, %rdi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_0_bwd:
 sub $0x80, %rdx
.Lcopy_backward_loop:
 movaps -0x10(%rsi), %xmm1
 movaps %xmm1, -0x10(%rdi)
 movaps -0x20(%rsi), %xmm2
 movaps %xmm2, -0x20(%rdi)
 movaps -0x30(%rsi), %xmm3
 movaps %xmm3, -0x30(%rdi)
 movaps -0x40(%rsi), %xmm4
 movaps %xmm4, -0x40(%rdi)
 movaps -0x50(%rsi), %xmm5
 movaps %xmm5, -0x50(%rdi)
 movaps -0x60(%rsi), %xmm5
 movaps %xmm5, -0x60(%rdi)
 movaps -0x70(%rsi), %xmm5
 movaps %xmm5, -0x70(%rdi)
 movaps -0x80(%rsi), %xmm5
 movaps %xmm5, -0x80(%rdi)
 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lcopy_backward_loop

 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_1:
 sub $0x80, %rdx
 movaps -0x01(%rsi), %xmm1
 movaps 0x0f(%rsi), %xmm2
 movaps 0x1f(%rsi), %xmm3
 movaps 0x2f(%rsi), %xmm4
 movaps 0x3f(%rsi), %xmm5
 movaps 0x4f(%rsi), %xmm6
 movaps 0x5f(%rsi), %xmm7
 movaps 0x6f(%rsi), %xmm8
 movaps 0x7f(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $1, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $1, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $1, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $1, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $1, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $1, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $1, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $1, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_1
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_1_bwd:
 movaps -0x01(%rsi), %xmm1

 movaps -0x11(%rsi), %xmm2
 palignr $1, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x21(%rsi), %xmm3
 palignr $1, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x31(%rsi), %xmm4
 palignr $1, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x41(%rsi), %xmm5
 palignr $1, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x51(%rsi), %xmm6
 palignr $1, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x61(%rsi), %xmm7
 palignr $1, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x71(%rsi), %xmm8
 palignr $1, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x81(%rsi), %xmm9
 palignr $1, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_1_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_2:
 sub $0x80, %rdx
 movaps -0x02(%rsi), %xmm1
 movaps 0x0e(%rsi), %xmm2
 movaps 0x1e(%rsi), %xmm3
 movaps 0x2e(%rsi), %xmm4
 movaps 0x3e(%rsi), %xmm5
 movaps 0x4e(%rsi), %xmm6
 movaps 0x5e(%rsi), %xmm7
 movaps 0x6e(%rsi), %xmm8
 movaps 0x7e(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $2, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $2, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $2, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $2, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $2, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $2, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $2, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $2, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_2
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_2_bwd:
 movaps -0x02(%rsi), %xmm1

 movaps -0x12(%rsi), %xmm2
 palignr $2, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x22(%rsi), %xmm3
 palignr $2, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x32(%rsi), %xmm4
 palignr $2, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x42(%rsi), %xmm5
 palignr $2, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x52(%rsi), %xmm6
 palignr $2, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x62(%rsi), %xmm7
 palignr $2, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x72(%rsi), %xmm8
 palignr $2, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x82(%rsi), %xmm9
 palignr $2, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_2_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_3:
 sub $0x80, %rdx
 movaps -0x03(%rsi), %xmm1
 movaps 0x0d(%rsi), %xmm2
 movaps 0x1d(%rsi), %xmm3
 movaps 0x2d(%rsi), %xmm4
 movaps 0x3d(%rsi), %xmm5
 movaps 0x4d(%rsi), %xmm6
 movaps 0x5d(%rsi), %xmm7
 movaps 0x6d(%rsi), %xmm8
 movaps 0x7d(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $3, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $3, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $3, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $3, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $3, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $3, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $3, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $3, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_3
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_3_bwd:
 movaps -0x03(%rsi), %xmm1

 movaps -0x13(%rsi), %xmm2
 palignr $3, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x23(%rsi), %xmm3
 palignr $3, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x33(%rsi), %xmm4
 palignr $3, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x43(%rsi), %xmm5
 palignr $3, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x53(%rsi), %xmm6
 palignr $3, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x63(%rsi), %xmm7
 palignr $3, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x73(%rsi), %xmm8
 palignr $3, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x83(%rsi), %xmm9
 palignr $3, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_3_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_4:
 sub $0x80, %rdx
 movaps -0x04(%rsi), %xmm1
 movaps 0x0c(%rsi), %xmm2
 movaps 0x1c(%rsi), %xmm3
 movaps 0x2c(%rsi), %xmm4
 movaps 0x3c(%rsi), %xmm5
 movaps 0x4c(%rsi), %xmm6
 movaps 0x5c(%rsi), %xmm7
 movaps 0x6c(%rsi), %xmm8
 movaps 0x7c(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $4, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $4, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $4, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $4, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $4, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $4, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $4, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $4, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_4
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_4_bwd:
 movaps -0x04(%rsi), %xmm1

 movaps -0x14(%rsi), %xmm2
 palignr $4, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x24(%rsi), %xmm3
 palignr $4, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x34(%rsi), %xmm4
 palignr $4, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x44(%rsi), %xmm5
 palignr $4, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x54(%rsi), %xmm6
 palignr $4, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x64(%rsi), %xmm7
 palignr $4, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x74(%rsi), %xmm8
 palignr $4, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x84(%rsi), %xmm9
 palignr $4, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_4_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_5:
 sub $0x80, %rdx
 movaps -0x05(%rsi), %xmm1
 movaps 0x0b(%rsi), %xmm2
 movaps 0x1b(%rsi), %xmm3
 movaps 0x2b(%rsi), %xmm4
 movaps 0x3b(%rsi), %xmm5
 movaps 0x4b(%rsi), %xmm6
 movaps 0x5b(%rsi), %xmm7
 movaps 0x6b(%rsi), %xmm8
 movaps 0x7b(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $5, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $5, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $5, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $5, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $5, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $5, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $5, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $5, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_5
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_5_bwd:
 movaps -0x05(%rsi), %xmm1

 movaps -0x15(%rsi), %xmm2
 palignr $5, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x25(%rsi), %xmm3
 palignr $5, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x35(%rsi), %xmm4
 palignr $5, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x45(%rsi), %xmm5
 palignr $5, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x55(%rsi), %xmm6
 palignr $5, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x65(%rsi), %xmm7
 palignr $5, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x75(%rsi), %xmm8
 palignr $5, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x85(%rsi), %xmm9
 palignr $5, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_5_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_6:
 sub $0x80, %rdx
 movaps -0x06(%rsi), %xmm1
 movaps 0x0a(%rsi), %xmm2
 movaps 0x1a(%rsi), %xmm3
 movaps 0x2a(%rsi), %xmm4
 movaps 0x3a(%rsi), %xmm5
 movaps 0x4a(%rsi), %xmm6
 movaps 0x5a(%rsi), %xmm7
 movaps 0x6a(%rsi), %xmm8
 movaps 0x7a(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $6, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $6, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $6, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $6, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $6, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $6, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $6, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $6, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_6
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_6_bwd:
 movaps -0x06(%rsi), %xmm1

 movaps -0x16(%rsi), %xmm2
 palignr $6, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x26(%rsi), %xmm3
 palignr $6, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x36(%rsi), %xmm4
 palignr $6, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x46(%rsi), %xmm5
 palignr $6, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x56(%rsi), %xmm6
 palignr $6, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x66(%rsi), %xmm7
 palignr $6, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x76(%rsi), %xmm8
 palignr $6, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x86(%rsi), %xmm9
 palignr $6, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_6_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_7:
 sub $0x80, %rdx
 movaps -0x07(%rsi), %xmm1
 movaps 0x09(%rsi), %xmm2
 movaps 0x19(%rsi), %xmm3
 movaps 0x29(%rsi), %xmm4
 movaps 0x39(%rsi), %xmm5
 movaps 0x49(%rsi), %xmm6
 movaps 0x59(%rsi), %xmm7
 movaps 0x69(%rsi), %xmm8
 movaps 0x79(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $7, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $7, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $7, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $7, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $7, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $7, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $7, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $7, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_7
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_7_bwd:
 movaps -0x07(%rsi), %xmm1

 movaps -0x17(%rsi), %xmm2
 palignr $7, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x27(%rsi), %xmm3
 palignr $7, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x37(%rsi), %xmm4
 palignr $7, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x47(%rsi), %xmm5
 palignr $7, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x57(%rsi), %xmm6
 palignr $7, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x67(%rsi), %xmm7
 palignr $7, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x77(%rsi), %xmm8
 palignr $7, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x87(%rsi), %xmm9
 palignr $7, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_7_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_8:
 sub $0x80, %rdx
 movaps -0x08(%rsi), %xmm1
 movaps 0x08(%rsi), %xmm2
 movaps 0x18(%rsi), %xmm3
 movaps 0x28(%rsi), %xmm4
 movaps 0x38(%rsi), %xmm5
 movaps 0x48(%rsi), %xmm6
 movaps 0x58(%rsi), %xmm7
 movaps 0x68(%rsi), %xmm8
 movaps 0x78(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $8, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $8, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $8, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $8, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $8, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $8, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $8, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $8, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_8
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_8_bwd:
 movaps -0x08(%rsi), %xmm1

 movaps -0x18(%rsi), %xmm2
 palignr $8, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x28(%rsi), %xmm3
 palignr $8, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x38(%rsi), %xmm4
 palignr $8, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x48(%rsi), %xmm5
 palignr $8, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x58(%rsi), %xmm6
 palignr $8, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x68(%rsi), %xmm7
 palignr $8, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x78(%rsi), %xmm8
 palignr $8, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x88(%rsi), %xmm9
 palignr $8, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_8_bwd
.Lshl_8_end_bwd:
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_9:
 sub $0x80, %rdx
 movaps -0x09(%rsi), %xmm1
 movaps 0x07(%rsi), %xmm2
 movaps 0x17(%rsi), %xmm3
 movaps 0x27(%rsi), %xmm4
 movaps 0x37(%rsi), %xmm5
 movaps 0x47(%rsi), %xmm6
 movaps 0x57(%rsi), %xmm7
 movaps 0x67(%rsi), %xmm8
 movaps 0x77(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $9, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $9, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $9, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $9, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $9, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $9, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $9, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $9, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_9
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_9_bwd:
 movaps -0x09(%rsi), %xmm1

 movaps -0x19(%rsi), %xmm2
 palignr $9, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x29(%rsi), %xmm3
 palignr $9, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x39(%rsi), %xmm4
 palignr $9, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x49(%rsi), %xmm5
 palignr $9, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x59(%rsi), %xmm6
 palignr $9, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x69(%rsi), %xmm7
 palignr $9, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x79(%rsi), %xmm8
 palignr $9, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x89(%rsi), %xmm9
 palignr $9, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_9_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_10:
 sub $0x80, %rdx
 movaps -0x0a(%rsi), %xmm1
 movaps 0x06(%rsi), %xmm2
 movaps 0x16(%rsi), %xmm3
 movaps 0x26(%rsi), %xmm4
 movaps 0x36(%rsi), %xmm5
 movaps 0x46(%rsi), %xmm6
 movaps 0x56(%rsi), %xmm7
 movaps 0x66(%rsi), %xmm8
 movaps 0x76(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $10, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $10, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $10, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $10, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $10, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $10, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $10, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $10, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_10
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_10_bwd:
 movaps -0x0a(%rsi), %xmm1

 movaps -0x1a(%rsi), %xmm2
 palignr $10, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x2a(%rsi), %xmm3
 palignr $10, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x3a(%rsi), %xmm4
 palignr $10, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x4a(%rsi), %xmm5
 palignr $10, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x5a(%rsi), %xmm6
 palignr $10, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x6a(%rsi), %xmm7
 palignr $10, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x7a(%rsi), %xmm8
 palignr $10, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x8a(%rsi), %xmm9
 palignr $10, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_10_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_11:
 sub $0x80, %rdx
 movaps -0x0b(%rsi), %xmm1
 movaps 0x05(%rsi), %xmm2
 movaps 0x15(%rsi), %xmm3
 movaps 0x25(%rsi), %xmm4
 movaps 0x35(%rsi), %xmm5
 movaps 0x45(%rsi), %xmm6
 movaps 0x55(%rsi), %xmm7
 movaps 0x65(%rsi), %xmm8
 movaps 0x75(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $11, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $11, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $11, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $11, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $11, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $11, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $11, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $11, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_11
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_11_bwd:
 movaps -0x0b(%rsi), %xmm1

 movaps -0x1b(%rsi), %xmm2
 palignr $11, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x2b(%rsi), %xmm3
 palignr $11, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x3b(%rsi), %xmm4
 palignr $11, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x4b(%rsi), %xmm5
 palignr $11, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x5b(%rsi), %xmm6
 palignr $11, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x6b(%rsi), %xmm7
 palignr $11, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x7b(%rsi), %xmm8
 palignr $11, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x8b(%rsi), %xmm9
 palignr $11, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_11_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_12:
 sub $0x80, %rdx
 movdqa -0x0c(%rsi), %xmm1
 movaps 0x04(%rsi), %xmm2
 movaps 0x14(%rsi), %xmm3
 movaps 0x24(%rsi), %xmm4
 movaps 0x34(%rsi), %xmm5
 movaps 0x44(%rsi), %xmm6
 movaps 0x54(%rsi), %xmm7
 movaps 0x64(%rsi), %xmm8
 movaps 0x74(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $12, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $12, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $12, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $12, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $12, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $12, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $12, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $12, %xmm1, %xmm2
 movaps %xmm2, (%rdi)

 lea 0x80(%rdi), %rdi
 jae .Lshl_12
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_12_bwd:
 movaps -0x0c(%rsi), %xmm1

 movaps -0x1c(%rsi), %xmm2
 palignr $12, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x2c(%rsi), %xmm3
 palignr $12, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x3c(%rsi), %xmm4
 palignr $12, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x4c(%rsi), %xmm5
 palignr $12, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x5c(%rsi), %xmm6
 palignr $12, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x6c(%rsi), %xmm7
 palignr $12, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x7c(%rsi), %xmm8
 palignr $12, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x8c(%rsi), %xmm9
 palignr $12, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_12_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_13:
 sub $0x80, %rdx
 movaps -0x0d(%rsi), %xmm1
 movaps 0x03(%rsi), %xmm2
 movaps 0x13(%rsi), %xmm3
 movaps 0x23(%rsi), %xmm4
 movaps 0x33(%rsi), %xmm5
 movaps 0x43(%rsi), %xmm6
 movaps 0x53(%rsi), %xmm7
 movaps 0x63(%rsi), %xmm8
 movaps 0x73(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $13, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $13, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $13, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $13, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $13, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $13, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $13, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $13, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_13
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_13_bwd:
 movaps -0x0d(%rsi), %xmm1

 movaps -0x1d(%rsi), %xmm2
 palignr $13, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x2d(%rsi), %xmm3
 palignr $13, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x3d(%rsi), %xmm4
 palignr $13, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x4d(%rsi), %xmm5
 palignr $13, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x5d(%rsi), %xmm6
 palignr $13, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x6d(%rsi), %xmm7
 palignr $13, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x7d(%rsi), %xmm8
 palignr $13, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x8d(%rsi), %xmm9
 palignr $13, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_13_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_14:
 sub $0x80, %rdx
 movaps -0x0e(%rsi), %xmm1
 movaps 0x02(%rsi), %xmm2
 movaps 0x12(%rsi), %xmm3
 movaps 0x22(%rsi), %xmm4
 movaps 0x32(%rsi), %xmm5
 movaps 0x42(%rsi), %xmm6
 movaps 0x52(%rsi), %xmm7
 movaps 0x62(%rsi), %xmm8
 movaps 0x72(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $14, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $14, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $14, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $14, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $14, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $14, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $14, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $14, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_14
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_14_bwd:
 movaps -0x0e(%rsi), %xmm1

 movaps -0x1e(%rsi), %xmm2
 palignr $14, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x2e(%rsi), %xmm3
 palignr $14, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x3e(%rsi), %xmm4
 palignr $14, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x4e(%rsi), %xmm5
 palignr $14, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x5e(%rsi), %xmm6
 palignr $14, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x6e(%rsi), %xmm7
 palignr $14, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x7e(%rsi), %xmm8
 palignr $14, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x8e(%rsi), %xmm9
 palignr $14, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_14_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_15:
 sub $0x80, %rdx
 movaps -0x0f(%rsi), %xmm1
 movaps 0x01(%rsi), %xmm2
 movaps 0x11(%rsi), %xmm3
 movaps 0x21(%rsi), %xmm4
 movaps 0x31(%rsi), %xmm5
 movaps 0x41(%rsi), %xmm6
 movaps 0x51(%rsi), %xmm7
 movaps 0x61(%rsi), %xmm8
 movaps 0x71(%rsi), %xmm9
 lea 0x80(%rsi), %rsi
 palignr $15, %xmm8, %xmm9
 movaps %xmm9, 0x70(%rdi)
 palignr $15, %xmm7, %xmm8
 movaps %xmm8, 0x60(%rdi)
 palignr $15, %xmm6, %xmm7
 movaps %xmm7, 0x50(%rdi)
 palignr $15, %xmm5, %xmm6
 movaps %xmm6, 0x40(%rdi)
 palignr $15, %xmm4, %xmm5
 movaps %xmm5, 0x30(%rdi)
 palignr $15, %xmm3, %xmm4
 movaps %xmm4, 0x20(%rdi)
 palignr $15, %xmm2, %xmm3
 movaps %xmm3, 0x10(%rdi)
 palignr $15, %xmm1, %xmm2
 movaps %xmm2, (%rdi)
 lea 0x80(%rdi), %rdi
 jae .Lshl_15
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 add %rdx, %rdi
 add %rdx, %rsi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lshl_15_bwd:
 movaps -0x0f(%rsi), %xmm1

 movaps -0x1f(%rsi), %xmm2
 palignr $15, %xmm2, %xmm1
 movaps %xmm1, -0x10(%rdi)

 movaps -0x2f(%rsi), %xmm3
 palignr $15, %xmm3, %xmm2
 movaps %xmm2, -0x20(%rdi)

 movaps -0x3f(%rsi), %xmm4
 palignr $15, %xmm4, %xmm3
 movaps %xmm3, -0x30(%rdi)

 movaps -0x4f(%rsi), %xmm5
 palignr $15, %xmm5, %xmm4
 movaps %xmm4, -0x40(%rdi)

 movaps -0x5f(%rsi), %xmm6
 palignr $15, %xmm6, %xmm5
 movaps %xmm5, -0x50(%rdi)

 movaps -0x6f(%rsi), %xmm7
 palignr $15, %xmm7, %xmm6
 movaps %xmm6, -0x60(%rdi)

 movaps -0x7f(%rsi), %xmm8
 palignr $15, %xmm8, %xmm7
 movaps %xmm7, -0x70(%rdi)

 movaps -0x8f(%rsi), %xmm9
 palignr $15, %xmm9, %xmm8
 movaps %xmm8, -0x80(%rdi)

 sub $0x80, %rdx
 lea -0x80(%rdi), %rdi
 lea -0x80(%rsi), %rsi
 jae .Lshl_15_bwd
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rdi
 sub %rdx, %rsi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lgobble_mem_fwd:
 movdqu (%rsi), %xmm1
 movdqu %xmm0, (%r8)
 movdqa %xmm1, (%rdi)
 sub $16, %rdx
 add $16, %rsi
 add $16, %rdi

 mov __x86_shared_cache_size_half(%rip), %rcx

 mov %rsi, %r9
 sub %rdi, %r9
 cmp %rdx, %r9
 jae .Lmemmove_is_memcpy_fwd
 cmp %rcx, %r9
 jbe .Lll_cache_copy_fwd_start
.Lmemmove_is_memcpy_fwd:

 cmp %rcx, %rdx
 ja .Lbigger_in_fwd
 mov %rdx, %rcx
.Lbigger_in_fwd:
 sub %rcx, %rdx
 cmp $0x1000, %rdx
 jbe .Lll_cache_copy_fwd

 mov %rcx, %r9
 shl $3, %r9
 cmp %r9, %rdx
 jbe .L2steps_copy_fwd
 add %rcx, %rdx
 xor %rcx, %rcx
.L2steps_copy_fwd:
 sub $0x80, %rdx
.Lgobble_mem_fwd_loop:
 sub $0x80, %rdx
 prefetcht0 0x200(%rsi)
 prefetcht0 0x300(%rsi)
 movdqu (%rsi), %xmm0
 movdqu 0x10(%rsi), %xmm1
 movdqu 0x20(%rsi), %xmm2
 movdqu 0x30(%rsi), %xmm3
 movdqu 0x40(%rsi), %xmm4
 movdqu 0x50(%rsi), %xmm5
 movdqu 0x60(%rsi), %xmm6
 movdqu 0x70(%rsi), %xmm7
 lfence
 movntdq %xmm0, (%rdi)
 movntdq %xmm1, 0x10(%rdi)
 movntdq %xmm2, 0x20(%rdi)
 movntdq %xmm3, 0x30(%rdi)
 movntdq %xmm4, 0x40(%rdi)
 movntdq %xmm5, 0x50(%rdi)
 movntdq %xmm6, 0x60(%rdi)
 movntdq %xmm7, 0x70(%rdi)
 lea 0x80(%rsi), %rsi
 lea 0x80(%rdi), %rdi
 jae .Lgobble_mem_fwd_loop
 sfence
 cmp $0x80, %rcx
 jb .Lgobble_mem_fwd_end
 add $0x80, %rdx
.Lll_cache_copy_fwd:
 add %rcx, %rdx
.Lll_cache_copy_fwd_start:
 sub $0x80, %rdx
.Lgobble_ll_loop_fwd:
 prefetchnta 0x1c0(%rsi)
 prefetchnta 0x280(%rsi)
 prefetchnta 0x1c0(%rdi)
 prefetchnta 0x280(%rdi)
 sub $0x80, %rdx
 movdqu (%rsi), %xmm0
 movdqu 0x10(%rsi), %xmm1
 movdqu 0x20(%rsi), %xmm2
 movdqu 0x30(%rsi), %xmm3
 movdqu 0x40(%rsi), %xmm4
 movdqu 0x50(%rsi), %xmm5
 movdqu 0x60(%rsi), %xmm6
 movdqu 0x70(%rsi), %xmm7
 movdqa %xmm0, (%rdi)
 movdqa %xmm1, 0x10(%rdi)
 movdqa %xmm2, 0x20(%rdi)
 movdqa %xmm3, 0x30(%rdi)
 movdqa %xmm4, 0x40(%rdi)
 movdqa %xmm5, 0x50(%rdi)
 movdqa %xmm6, 0x60(%rdi)
 movdqa %xmm7, 0x70(%rdi)
 lea 0x80(%rsi), %rsi
 lea 0x80(%rdi), %rdi
 jae .Lgobble_ll_loop_fwd
.Lgobble_mem_fwd_end:
 add $0x80, %rdx
 add %rdx, %rsi
 add %rdx, %rdi
 lea .Ltable_144_bytes_fwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lgobble_mem_bwd:
 add %rdx, %rsi
 add %rdx, %rdi

 movdqu -16(%rsi), %xmm0
 lea -16(%rdi), %r8
 mov %rdi, %r9
 and $-16, %rdi
 sub %rdi, %r9
 sub %r9, %rsi
 sub %r9, %rdx

 mov __x86_shared_cache_size_half(%rip), %rcx

 mov %rdi, %r9
 sub %rsi, %r9
 cmp %rdx, %r9
 jae .Lmemmove_is_memcpy_bwd
 cmp %rcx, %r9
 jbe .Lll_cache_copy_bwd_start
.Lmemmove_is_memcpy_bwd:

 cmp %rcx, %rdx
 ja .Lbigger
 mov %rdx, %rcx
.Lbigger:
 sub %rcx, %rdx
 cmp $0x1000, %rdx
 jbe .Lll_cache_copy

 mov %rcx, %r9
 shl $3, %r9
 cmp %r9, %rdx
 jbe .L2steps_copy
 add %rcx, %rdx
 xor %rcx, %rcx
.L2steps_copy:
 sub $0x80, %rdx
.Lgobble_mem_bwd_loop:
 sub $0x80, %rdx
 prefetcht0 -0x200(%rsi)
 prefetcht0 -0x300(%rsi)
 movdqu -0x10(%rsi), %xmm1
 movdqu -0x20(%rsi), %xmm2
 movdqu -0x30(%rsi), %xmm3
 movdqu -0x40(%rsi), %xmm4
 movdqu -0x50(%rsi), %xmm5
 movdqu -0x60(%rsi), %xmm6
 movdqu -0x70(%rsi), %xmm7
 movdqu -0x80(%rsi), %xmm8
 lfence
 movntdq %xmm1, -0x10(%rdi)
 movntdq %xmm2, -0x20(%rdi)
 movntdq %xmm3, -0x30(%rdi)
 movntdq %xmm4, -0x40(%rdi)
 movntdq %xmm5, -0x50(%rdi)
 movntdq %xmm6, -0x60(%rdi)
 movntdq %xmm7, -0x70(%rdi)
 movntdq %xmm8, -0x80(%rdi)
 lea -0x80(%rsi), %rsi
 lea -0x80(%rdi), %rdi
 jae .Lgobble_mem_bwd_loop
 sfence
 cmp $0x80, %rcx
 jb .Lgobble_mem_bwd_end
 add $0x80, %rdx
.Lll_cache_copy:
 add %rcx, %rdx
.Lll_cache_copy_bwd_start:
 sub $0x80, %rdx
.Lgobble_ll_loop:
 prefetchnta -0x1c0(%rsi)
 prefetchnta -0x280(%rsi)
 prefetchnta -0x1c0(%rdi)
 prefetchnta -0x280(%rdi)
 sub $0x80, %rdx
 movdqu -0x10(%rsi), %xmm1
 movdqu -0x20(%rsi), %xmm2
 movdqu -0x30(%rsi), %xmm3
 movdqu -0x40(%rsi), %xmm4
 movdqu -0x50(%rsi), %xmm5
 movdqu -0x60(%rsi), %xmm6
 movdqu -0x70(%rsi), %xmm7
 movdqu -0x80(%rsi), %xmm8
 movdqa %xmm1, -0x10(%rdi)
 movdqa %xmm2, -0x20(%rdi)
 movdqa %xmm3, -0x30(%rdi)
 movdqa %xmm4, -0x40(%rdi)
 movdqa %xmm5, -0x50(%rdi)
 movdqa %xmm6, -0x60(%rdi)
 movdqa %xmm7, -0x70(%rdi)
 movdqa %xmm8, -0x80(%rdi)
 lea -0x80(%rsi), %rsi
 lea -0x80(%rdi), %rdi
 jae .Lgobble_ll_loop
.Lgobble_mem_bwd_end:
 movdqu %xmm0, (%r8)
 add $0x80, %rdx
 sub %rdx, %rsi
 sub %rdx, %rdi
 lea .Ltable_144_bytes_bwd(%rip), %r11; movslq (%r11, %rdx, 4), %rdx; lea (%r11, %rdx), %rdx; jmp *%rdx; ud2

 .p2align 4
.Lfwd_write_128bytes:
 lddqu -128(%rsi), %xmm0
 movdqu %xmm0, -128(%rdi)
.Lfwd_write_112bytes:
 lddqu -112(%rsi), %xmm0
 movdqu %xmm0, -112(%rdi)
.Lfwd_write_96bytes:
 lddqu -96(%rsi), %xmm0
 movdqu %xmm0, -96(%rdi)
.Lfwd_write_80bytes:
 lddqu -80(%rsi), %xmm0
 movdqu %xmm0, -80(%rdi)
.Lfwd_write_64bytes:
 lddqu -64(%rsi), %xmm0
 movdqu %xmm0, -64(%rdi)
.Lfwd_write_48bytes:
 lddqu -48(%rsi), %xmm0
 movdqu %xmm0, -48(%rdi)
.Lfwd_write_32bytes:
 lddqu -32(%rsi), %xmm0
 movdqu %xmm0, -32(%rdi)
.Lfwd_write_16bytes:
 lddqu -16(%rsi), %xmm0
 movdqu %xmm0, -16(%rdi)
.Lfwd_write_0bytes:
 ret

 .p2align 4
.Lfwd_write_143bytes:
 lddqu -143(%rsi), %xmm0
 movdqu %xmm0, -143(%rdi)
.Lfwd_write_127bytes:
 lddqu -127(%rsi), %xmm0
 movdqu %xmm0, -127(%rdi)
.Lfwd_write_111bytes:
 lddqu -111(%rsi), %xmm0
 movdqu %xmm0, -111(%rdi)
.Lfwd_write_95bytes:
 lddqu -95(%rsi), %xmm0
 movdqu %xmm0, -95(%rdi)
.Lfwd_write_79bytes:
 lddqu -79(%rsi), %xmm0
 movdqu %xmm0, -79(%rdi)
.Lfwd_write_63bytes:
 lddqu -63(%rsi), %xmm0
 movdqu %xmm0, -63(%rdi)
.Lfwd_write_47bytes:
 lddqu -47(%rsi), %xmm0
 movdqu %xmm0, -47(%rdi)
.Lfwd_write_31bytes:
 lddqu -31(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -31(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_15bytes:
 mov -15(%rsi), %rdx
 mov -8(%rsi), %rcx
 mov %rdx, -15(%rdi)
 mov %rcx, -8(%rdi)
 ret

 .p2align 4
.Lfwd_write_142bytes:
 lddqu -142(%rsi), %xmm0
 movdqu %xmm0, -142(%rdi)
.Lfwd_write_126bytes:
 lddqu -126(%rsi), %xmm0
 movdqu %xmm0, -126(%rdi)
.Lfwd_write_110bytes:
 lddqu -110(%rsi), %xmm0
 movdqu %xmm0, -110(%rdi)
.Lfwd_write_94bytes:
 lddqu -94(%rsi), %xmm0
 movdqu %xmm0, -94(%rdi)
.Lfwd_write_78bytes:
 lddqu -78(%rsi), %xmm0
 movdqu %xmm0, -78(%rdi)
.Lfwd_write_62bytes:
 lddqu -62(%rsi), %xmm0
 movdqu %xmm0, -62(%rdi)
.Lfwd_write_46bytes:
 lddqu -46(%rsi), %xmm0
 movdqu %xmm0, -46(%rdi)
.Lfwd_write_30bytes:
 lddqu -30(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -30(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_14bytes:
 mov -14(%rsi), %rdx
 mov -8(%rsi), %rcx
 mov %rdx, -14(%rdi)
 mov %rcx, -8(%rdi)
 ret

 .p2align 4
.Lfwd_write_141bytes:
 lddqu -141(%rsi), %xmm0
 movdqu %xmm0, -141(%rdi)
.Lfwd_write_125bytes:
 lddqu -125(%rsi), %xmm0
 movdqu %xmm0, -125(%rdi)
.Lfwd_write_109bytes:
 lddqu -109(%rsi), %xmm0
 movdqu %xmm0, -109(%rdi)
.Lfwd_write_93bytes:
 lddqu -93(%rsi), %xmm0
 movdqu %xmm0, -93(%rdi)
.Lfwd_write_77bytes:
 lddqu -77(%rsi), %xmm0
 movdqu %xmm0, -77(%rdi)
.Lfwd_write_61bytes:
 lddqu -61(%rsi), %xmm0
 movdqu %xmm0, -61(%rdi)
.Lfwd_write_45bytes:
 lddqu -45(%rsi), %xmm0
 movdqu %xmm0, -45(%rdi)
.Lfwd_write_29bytes:
 lddqu -29(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -29(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_13bytes:
 mov -13(%rsi), %rdx
 mov -8(%rsi), %rcx
 mov %rdx, -13(%rdi)
 mov %rcx, -8(%rdi)
 ret

 .p2align 4
.Lfwd_write_140bytes:
 lddqu -140(%rsi), %xmm0
 movdqu %xmm0, -140(%rdi)
.Lfwd_write_124bytes:
 lddqu -124(%rsi), %xmm0
 movdqu %xmm0, -124(%rdi)
.Lfwd_write_108bytes:
 lddqu -108(%rsi), %xmm0
 movdqu %xmm0, -108(%rdi)
.Lfwd_write_92bytes:
 lddqu -92(%rsi), %xmm0
 movdqu %xmm0, -92(%rdi)
.Lfwd_write_76bytes:
 lddqu -76(%rsi), %xmm0
 movdqu %xmm0, -76(%rdi)
.Lfwd_write_60bytes:
 lddqu -60(%rsi), %xmm0
 movdqu %xmm0, -60(%rdi)
.Lfwd_write_44bytes:
 lddqu -44(%rsi), %xmm0
 movdqu %xmm0, -44(%rdi)
.Lfwd_write_28bytes:
 lddqu -28(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -28(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_12bytes:
 mov -12(%rsi), %rdx
 mov -4(%rsi), %ecx
 mov %rdx, -12(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_139bytes:
 lddqu -139(%rsi), %xmm0
 movdqu %xmm0, -139(%rdi)
.Lfwd_write_123bytes:
 lddqu -123(%rsi), %xmm0
 movdqu %xmm0, -123(%rdi)
.Lfwd_write_107bytes:
 lddqu -107(%rsi), %xmm0
 movdqu %xmm0, -107(%rdi)
.Lfwd_write_91bytes:
 lddqu -91(%rsi), %xmm0
 movdqu %xmm0, -91(%rdi)
.Lfwd_write_75bytes:
 lddqu -75(%rsi), %xmm0
 movdqu %xmm0, -75(%rdi)
.Lfwd_write_59bytes:
 lddqu -59(%rsi), %xmm0
 movdqu %xmm0, -59(%rdi)
.Lfwd_write_43bytes:
 lddqu -43(%rsi), %xmm0
 movdqu %xmm0, -43(%rdi)
.Lfwd_write_27bytes:
 lddqu -27(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -27(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_11bytes:
 mov -11(%rsi), %rdx
 mov -4(%rsi), %ecx
 mov %rdx, -11(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_138bytes:
 lddqu -138(%rsi), %xmm0
 movdqu %xmm0, -138(%rdi)
.Lfwd_write_122bytes:
 lddqu -122(%rsi), %xmm0
 movdqu %xmm0, -122(%rdi)
.Lfwd_write_106bytes:
 lddqu -106(%rsi), %xmm0
 movdqu %xmm0, -106(%rdi)
.Lfwd_write_90bytes:
 lddqu -90(%rsi), %xmm0
 movdqu %xmm0, -90(%rdi)
.Lfwd_write_74bytes:
 lddqu -74(%rsi), %xmm0
 movdqu %xmm0, -74(%rdi)
.Lfwd_write_58bytes:
 lddqu -58(%rsi), %xmm0
 movdqu %xmm0, -58(%rdi)
.Lfwd_write_42bytes:
 lddqu -42(%rsi), %xmm0
 movdqu %xmm0, -42(%rdi)
.Lfwd_write_26bytes:
 lddqu -26(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -26(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_10bytes:
 mov -10(%rsi), %rdx
 mov -4(%rsi), %ecx
 mov %rdx, -10(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_137bytes:
 lddqu -137(%rsi), %xmm0
 movdqu %xmm0, -137(%rdi)
.Lfwd_write_121bytes:
 lddqu -121(%rsi), %xmm0
 movdqu %xmm0, -121(%rdi)
.Lfwd_write_105bytes:
 lddqu -105(%rsi), %xmm0
 movdqu %xmm0, -105(%rdi)
.Lfwd_write_89bytes:
 lddqu -89(%rsi), %xmm0
 movdqu %xmm0, -89(%rdi)
.Lfwd_write_73bytes:
 lddqu -73(%rsi), %xmm0
 movdqu %xmm0, -73(%rdi)
.Lfwd_write_57bytes:
 lddqu -57(%rsi), %xmm0
 movdqu %xmm0, -57(%rdi)
.Lfwd_write_41bytes:
 lddqu -41(%rsi), %xmm0
 movdqu %xmm0, -41(%rdi)
.Lfwd_write_25bytes:
 lddqu -25(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -25(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_9bytes:
 mov -9(%rsi), %rdx
 mov -4(%rsi), %ecx
 mov %rdx, -9(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_136bytes:
 lddqu -136(%rsi), %xmm0
 movdqu %xmm0, -136(%rdi)
.Lfwd_write_120bytes:
 lddqu -120(%rsi), %xmm0
 movdqu %xmm0, -120(%rdi)
.Lfwd_write_104bytes:
 lddqu -104(%rsi), %xmm0
 movdqu %xmm0, -104(%rdi)
.Lfwd_write_88bytes:
 lddqu -88(%rsi), %xmm0
 movdqu %xmm0, -88(%rdi)
.Lfwd_write_72bytes:
 lddqu -72(%rsi), %xmm0
 movdqu %xmm0, -72(%rdi)
.Lfwd_write_56bytes:
 lddqu -56(%rsi), %xmm0
 movdqu %xmm0, -56(%rdi)
.Lfwd_write_40bytes:
 lddqu -40(%rsi), %xmm0
 movdqu %xmm0, -40(%rdi)
.Lfwd_write_24bytes:
 lddqu -24(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -24(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_8bytes:
 mov -8(%rsi), %rdx
 mov %rdx, -8(%rdi)
 ret

 .p2align 4
.Lfwd_write_135bytes:
 lddqu -135(%rsi), %xmm0
 movdqu %xmm0, -135(%rdi)
.Lfwd_write_119bytes:
 lddqu -119(%rsi), %xmm0
 movdqu %xmm0, -119(%rdi)
.Lfwd_write_103bytes:
 lddqu -103(%rsi), %xmm0
 movdqu %xmm0, -103(%rdi)
.Lfwd_write_87bytes:
 lddqu -87(%rsi), %xmm0
 movdqu %xmm0, -87(%rdi)
.Lfwd_write_71bytes:
 lddqu -71(%rsi), %xmm0
 movdqu %xmm0, -71(%rdi)
.Lfwd_write_55bytes:
 lddqu -55(%rsi), %xmm0
 movdqu %xmm0, -55(%rdi)
.Lfwd_write_39bytes:
 lddqu -39(%rsi), %xmm0
 movdqu %xmm0, -39(%rdi)
.Lfwd_write_23bytes:
 lddqu -23(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -23(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_7bytes:
 mov -7(%rsi), %edx
 mov -4(%rsi), %ecx
 mov %edx, -7(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_134bytes:
 lddqu -134(%rsi), %xmm0
 movdqu %xmm0, -134(%rdi)
.Lfwd_write_118bytes:
 lddqu -118(%rsi), %xmm0
 movdqu %xmm0, -118(%rdi)
.Lfwd_write_102bytes:
 lddqu -102(%rsi), %xmm0
 movdqu %xmm0, -102(%rdi)
.Lfwd_write_86bytes:
 lddqu -86(%rsi), %xmm0
 movdqu %xmm0, -86(%rdi)
.Lfwd_write_70bytes:
 lddqu -70(%rsi), %xmm0
 movdqu %xmm0, -70(%rdi)
.Lfwd_write_54bytes:
 lddqu -54(%rsi), %xmm0
 movdqu %xmm0, -54(%rdi)
.Lfwd_write_38bytes:
 lddqu -38(%rsi), %xmm0
 movdqu %xmm0, -38(%rdi)
.Lfwd_write_22bytes:
 lddqu -22(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -22(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_6bytes:
 mov -6(%rsi), %edx
 mov -4(%rsi), %ecx
 mov %edx, -6(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_133bytes:
 lddqu -133(%rsi), %xmm0
 movdqu %xmm0, -133(%rdi)
.Lfwd_write_117bytes:
 lddqu -117(%rsi), %xmm0
 movdqu %xmm0, -117(%rdi)
.Lfwd_write_101bytes:
 lddqu -101(%rsi), %xmm0
 movdqu %xmm0, -101(%rdi)
.Lfwd_write_85bytes:
 lddqu -85(%rsi), %xmm0
 movdqu %xmm0, -85(%rdi)
.Lfwd_write_69bytes:
 lddqu -69(%rsi), %xmm0
 movdqu %xmm0, -69(%rdi)
.Lfwd_write_53bytes:
 lddqu -53(%rsi), %xmm0
 movdqu %xmm0, -53(%rdi)
.Lfwd_write_37bytes:
 lddqu -37(%rsi), %xmm0
 movdqu %xmm0, -37(%rdi)
.Lfwd_write_21bytes:
 lddqu -21(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -21(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_5bytes:
 mov -5(%rsi), %edx
 mov -4(%rsi), %ecx
 mov %edx, -5(%rdi)
 mov %ecx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_132bytes:
 lddqu -132(%rsi), %xmm0
 movdqu %xmm0, -132(%rdi)
.Lfwd_write_116bytes:
 lddqu -116(%rsi), %xmm0
 movdqu %xmm0, -116(%rdi)
.Lfwd_write_100bytes:
 lddqu -100(%rsi), %xmm0
 movdqu %xmm0, -100(%rdi)
.Lfwd_write_84bytes:
 lddqu -84(%rsi), %xmm0
 movdqu %xmm0, -84(%rdi)
.Lfwd_write_68bytes:
 lddqu -68(%rsi), %xmm0
 movdqu %xmm0, -68(%rdi)
.Lfwd_write_52bytes:
 lddqu -52(%rsi), %xmm0
 movdqu %xmm0, -52(%rdi)
.Lfwd_write_36bytes:
 lddqu -36(%rsi), %xmm0
 movdqu %xmm0, -36(%rdi)
.Lfwd_write_20bytes:
 lddqu -20(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -20(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_4bytes:
 mov -4(%rsi), %edx
 mov %edx, -4(%rdi)
 ret

 .p2align 4
.Lfwd_write_131bytes:
 lddqu -131(%rsi), %xmm0
 movdqu %xmm0, -131(%rdi)
.Lfwd_write_115bytes:
 lddqu -115(%rsi), %xmm0
 movdqu %xmm0, -115(%rdi)
.Lfwd_write_99bytes:
 lddqu -99(%rsi), %xmm0
 movdqu %xmm0, -99(%rdi)
.Lfwd_write_83bytes:
 lddqu -83(%rsi), %xmm0
 movdqu %xmm0, -83(%rdi)
.Lfwd_write_67bytes:
 lddqu -67(%rsi), %xmm0
 movdqu %xmm0, -67(%rdi)
.Lfwd_write_51bytes:
 lddqu -51(%rsi), %xmm0
 movdqu %xmm0, -51(%rdi)
.Lfwd_write_35bytes:
 lddqu -35(%rsi), %xmm0
 movdqu %xmm0, -35(%rdi)
.Lfwd_write_19bytes:
 lddqu -19(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -19(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_3bytes:
 mov -3(%rsi), %dx
 mov -2(%rsi), %cx
 mov %dx, -3(%rdi)
 mov %cx, -2(%rdi)
 ret

 .p2align 4
.Lfwd_write_130bytes:
 lddqu -130(%rsi), %xmm0
 movdqu %xmm0, -130(%rdi)
.Lfwd_write_114bytes:
 lddqu -114(%rsi), %xmm0
 movdqu %xmm0, -114(%rdi)
.Lfwd_write_98bytes:
 lddqu -98(%rsi), %xmm0
 movdqu %xmm0, -98(%rdi)
.Lfwd_write_82bytes:
 lddqu -82(%rsi), %xmm0
 movdqu %xmm0, -82(%rdi)
.Lfwd_write_66bytes:
 lddqu -66(%rsi), %xmm0
 movdqu %xmm0, -66(%rdi)
.Lfwd_write_50bytes:
 lddqu -50(%rsi), %xmm0
 movdqu %xmm0, -50(%rdi)
.Lfwd_write_34bytes:
 lddqu -34(%rsi), %xmm0
 movdqu %xmm0, -34(%rdi)
.Lfwd_write_18bytes:
 lddqu -18(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -18(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_2bytes:
 movzwl -2(%rsi), %edx
 mov %dx, -2(%rdi)
 ret

 .p2align 4
.Lfwd_write_129bytes:
 lddqu -129(%rsi), %xmm0
 movdqu %xmm0, -129(%rdi)
.Lfwd_write_113bytes:
 lddqu -113(%rsi), %xmm0
 movdqu %xmm0, -113(%rdi)
.Lfwd_write_97bytes:
 lddqu -97(%rsi), %xmm0
 movdqu %xmm0, -97(%rdi)
.Lfwd_write_81bytes:
 lddqu -81(%rsi), %xmm0
 movdqu %xmm0, -81(%rdi)
.Lfwd_write_65bytes:
 lddqu -65(%rsi), %xmm0
 movdqu %xmm0, -65(%rdi)
.Lfwd_write_49bytes:
 lddqu -49(%rsi), %xmm0
 movdqu %xmm0, -49(%rdi)
.Lfwd_write_33bytes:
 lddqu -33(%rsi), %xmm0
 movdqu %xmm0, -33(%rdi)
.Lfwd_write_17bytes:
 lddqu -17(%rsi), %xmm0
 lddqu -16(%rsi), %xmm1
 movdqu %xmm0, -17(%rdi)
 movdqu %xmm1, -16(%rdi)
 ret

 .p2align 4
.Lfwd_write_1bytes:
 movzbl -1(%rsi), %edx
 mov %dl, -1(%rdi)
 ret

 .p2align 4
.Lbwd_write_128bytes:
 lddqu 112(%rsi), %xmm0
 movdqu %xmm0, 112(%rdi)
.Lbwd_write_112bytes:
 lddqu 96(%rsi), %xmm0
 movdqu %xmm0, 96(%rdi)
.Lbwd_write_96bytes:
 lddqu 80(%rsi), %xmm0
 movdqu %xmm0, 80(%rdi)
.Lbwd_write_80bytes:
 lddqu 64(%rsi), %xmm0
 movdqu %xmm0, 64(%rdi)
.Lbwd_write_64bytes:
 lddqu 48(%rsi), %xmm0
 movdqu %xmm0, 48(%rdi)
.Lbwd_write_48bytes:
 lddqu 32(%rsi), %xmm0
 movdqu %xmm0, 32(%rdi)
.Lbwd_write_32bytes:
 lddqu 16(%rsi), %xmm0
 movdqu %xmm0, 16(%rdi)
.Lbwd_write_16bytes:
 lddqu (%rsi), %xmm0
 movdqu %xmm0, (%rdi)
.Lbwd_write_0bytes:
 ret

 .p2align 4
.Lbwd_write_143bytes:
 lddqu 127(%rsi), %xmm0
 movdqu %xmm0, 127(%rdi)
.Lbwd_write_127bytes:
 lddqu 111(%rsi), %xmm0
 movdqu %xmm0, 111(%rdi)
.Lbwd_write_111bytes:
 lddqu 95(%rsi), %xmm0
 movdqu %xmm0, 95(%rdi)
.Lbwd_write_95bytes:
 lddqu 79(%rsi), %xmm0
 movdqu %xmm0, 79(%rdi)
.Lbwd_write_79bytes:
 lddqu 63(%rsi), %xmm0
 movdqu %xmm0, 63(%rdi)
.Lbwd_write_63bytes:
 lddqu 47(%rsi), %xmm0
 movdqu %xmm0, 47(%rdi)
.Lbwd_write_47bytes:
 lddqu 31(%rsi), %xmm0
 movdqu %xmm0, 31(%rdi)
.Lbwd_write_31bytes:
 lddqu 15(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 15(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_15bytes:
 mov 7(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 7(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_142bytes:
 lddqu 126(%rsi), %xmm0
 movdqu %xmm0, 126(%rdi)
.Lbwd_write_126bytes:
 lddqu 110(%rsi), %xmm0
 movdqu %xmm0, 110(%rdi)
.Lbwd_write_110bytes:
 lddqu 94(%rsi), %xmm0
 movdqu %xmm0, 94(%rdi)
.Lbwd_write_94bytes:
 lddqu 78(%rsi), %xmm0
 movdqu %xmm0, 78(%rdi)
.Lbwd_write_78bytes:
 lddqu 62(%rsi), %xmm0
 movdqu %xmm0, 62(%rdi)
.Lbwd_write_62bytes:
 lddqu 46(%rsi), %xmm0
 movdqu %xmm0, 46(%rdi)
.Lbwd_write_46bytes:
 lddqu 30(%rsi), %xmm0
 movdqu %xmm0, 30(%rdi)
.Lbwd_write_30bytes:
 lddqu 14(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 14(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_14bytes:
 mov 6(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 6(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_141bytes:
 lddqu 125(%rsi), %xmm0
 movdqu %xmm0, 125(%rdi)
.Lbwd_write_125bytes:
 lddqu 109(%rsi), %xmm0
 movdqu %xmm0, 109(%rdi)
.Lbwd_write_109bytes:
 lddqu 93(%rsi), %xmm0
 movdqu %xmm0, 93(%rdi)
.Lbwd_write_93bytes:
 lddqu 77(%rsi), %xmm0
 movdqu %xmm0, 77(%rdi)
.Lbwd_write_77bytes:
 lddqu 61(%rsi), %xmm0
 movdqu %xmm0, 61(%rdi)
.Lbwd_write_61bytes:
 lddqu 45(%rsi), %xmm0
 movdqu %xmm0, 45(%rdi)
.Lbwd_write_45bytes:
 lddqu 29(%rsi), %xmm0
 movdqu %xmm0, 29(%rdi)
.Lbwd_write_29bytes:
 lddqu 13(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 13(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_13bytes:
 mov 5(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 5(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_140bytes:
 lddqu 124(%rsi), %xmm0
 movdqu %xmm0, 124(%rdi)
.Lbwd_write_124bytes:
 lddqu 108(%rsi), %xmm0
 movdqu %xmm0, 108(%rdi)
.Lbwd_write_108bytes:
 lddqu 92(%rsi), %xmm0
 movdqu %xmm0, 92(%rdi)
.Lbwd_write_92bytes:
 lddqu 76(%rsi), %xmm0
 movdqu %xmm0, 76(%rdi)
.Lbwd_write_76bytes:
 lddqu 60(%rsi), %xmm0
 movdqu %xmm0, 60(%rdi)
.Lbwd_write_60bytes:
 lddqu 44(%rsi), %xmm0
 movdqu %xmm0, 44(%rdi)
.Lbwd_write_44bytes:
 lddqu 28(%rsi), %xmm0
 movdqu %xmm0, 28(%rdi)
.Lbwd_write_28bytes:
 lddqu 12(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 12(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_12bytes:
 mov 4(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 4(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_139bytes:
 lddqu 123(%rsi), %xmm0
 movdqu %xmm0, 123(%rdi)
.Lbwd_write_123bytes:
 lddqu 107(%rsi), %xmm0
 movdqu %xmm0, 107(%rdi)
.Lbwd_write_107bytes:
 lddqu 91(%rsi), %xmm0
 movdqu %xmm0, 91(%rdi)
.Lbwd_write_91bytes:
 lddqu 75(%rsi), %xmm0
 movdqu %xmm0, 75(%rdi)
.Lbwd_write_75bytes:
 lddqu 59(%rsi), %xmm0
 movdqu %xmm0, 59(%rdi)
.Lbwd_write_59bytes:
 lddqu 43(%rsi), %xmm0
 movdqu %xmm0, 43(%rdi)
.Lbwd_write_43bytes:
 lddqu 27(%rsi), %xmm0
 movdqu %xmm0, 27(%rdi)
.Lbwd_write_27bytes:
 lddqu 11(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 11(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_11bytes:
 mov 3(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 3(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_138bytes:
 lddqu 122(%rsi), %xmm0
 movdqu %xmm0, 122(%rdi)
.Lbwd_write_122bytes:
 lddqu 106(%rsi), %xmm0
 movdqu %xmm0, 106(%rdi)
.Lbwd_write_106bytes:
 lddqu 90(%rsi), %xmm0
 movdqu %xmm0, 90(%rdi)
.Lbwd_write_90bytes:
 lddqu 74(%rsi), %xmm0
 movdqu %xmm0, 74(%rdi)
.Lbwd_write_74bytes:
 lddqu 58(%rsi), %xmm0
 movdqu %xmm0, 58(%rdi)
.Lbwd_write_58bytes:
 lddqu 42(%rsi), %xmm0
 movdqu %xmm0, 42(%rdi)
.Lbwd_write_42bytes:
 lddqu 26(%rsi), %xmm0
 movdqu %xmm0, 26(%rdi)
.Lbwd_write_26bytes:
 lddqu 10(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 10(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_10bytes:
 mov 2(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 2(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_137bytes:
 lddqu 121(%rsi), %xmm0
 movdqu %xmm0, 121(%rdi)
.Lbwd_write_121bytes:
 lddqu 105(%rsi), %xmm0
 movdqu %xmm0, 105(%rdi)
.Lbwd_write_105bytes:
 lddqu 89(%rsi), %xmm0
 movdqu %xmm0, 89(%rdi)
.Lbwd_write_89bytes:
 lddqu 73(%rsi), %xmm0
 movdqu %xmm0, 73(%rdi)
.Lbwd_write_73bytes:
 lddqu 57(%rsi), %xmm0
 movdqu %xmm0, 57(%rdi)
.Lbwd_write_57bytes:
 lddqu 41(%rsi), %xmm0
 movdqu %xmm0, 41(%rdi)
.Lbwd_write_41bytes:
 lddqu 25(%rsi), %xmm0
 movdqu %xmm0, 25(%rdi)
.Lbwd_write_25bytes:
 lddqu 9(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 9(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_9bytes:
 mov 1(%rsi), %rdx
 mov (%rsi), %rcx
 mov %rdx, 1(%rdi)
 mov %rcx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_136bytes:
 lddqu 120(%rsi), %xmm0
 movdqu %xmm0, 120(%rdi)
.Lbwd_write_120bytes:
 lddqu 104(%rsi), %xmm0
 movdqu %xmm0, 104(%rdi)
.Lbwd_write_104bytes:
 lddqu 88(%rsi), %xmm0
 movdqu %xmm0, 88(%rdi)
.Lbwd_write_88bytes:
 lddqu 72(%rsi), %xmm0
 movdqu %xmm0, 72(%rdi)
.Lbwd_write_72bytes:
 lddqu 56(%rsi), %xmm0
 movdqu %xmm0, 56(%rdi)
.Lbwd_write_56bytes:
 lddqu 40(%rsi), %xmm0
 movdqu %xmm0, 40(%rdi)
.Lbwd_write_40bytes:
 lddqu 24(%rsi), %xmm0
 movdqu %xmm0, 24(%rdi)
.Lbwd_write_24bytes:
 lddqu 8(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 8(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_8bytes:
 mov (%rsi), %rdx
 mov %rdx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_135bytes:
 lddqu 119(%rsi), %xmm0
 movdqu %xmm0, 119(%rdi)
.Lbwd_write_119bytes:
 lddqu 103(%rsi), %xmm0
 movdqu %xmm0, 103(%rdi)
.Lbwd_write_103bytes:
 lddqu 87(%rsi), %xmm0
 movdqu %xmm0, 87(%rdi)
.Lbwd_write_87bytes:
 lddqu 71(%rsi), %xmm0
 movdqu %xmm0, 71(%rdi)
.Lbwd_write_71bytes:
 lddqu 55(%rsi), %xmm0
 movdqu %xmm0, 55(%rdi)
.Lbwd_write_55bytes:
 lddqu 39(%rsi), %xmm0
 movdqu %xmm0, 39(%rdi)
.Lbwd_write_39bytes:
 lddqu 23(%rsi), %xmm0
 movdqu %xmm0, 23(%rdi)
.Lbwd_write_23bytes:
 lddqu 7(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 7(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_7bytes:
 mov 3(%rsi), %edx
 mov (%rsi), %ecx
 mov %edx, 3(%rdi)
 mov %ecx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_134bytes:
 lddqu 118(%rsi), %xmm0
 movdqu %xmm0, 118(%rdi)
.Lbwd_write_118bytes:
 lddqu 102(%rsi), %xmm0
 movdqu %xmm0, 102(%rdi)
.Lbwd_write_102bytes:
 lddqu 86(%rsi), %xmm0
 movdqu %xmm0, 86(%rdi)
.Lbwd_write_86bytes:
 lddqu 70(%rsi), %xmm0
 movdqu %xmm0, 70(%rdi)
.Lbwd_write_70bytes:
 lddqu 54(%rsi), %xmm0
 movdqu %xmm0, 54(%rdi)
.Lbwd_write_54bytes:
 lddqu 38(%rsi), %xmm0
 movdqu %xmm0, 38(%rdi)
.Lbwd_write_38bytes:
 lddqu 22(%rsi), %xmm0
 movdqu %xmm0, 22(%rdi)
.Lbwd_write_22bytes:
 lddqu 6(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 6(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_6bytes:
 mov 2(%rsi), %edx
 mov (%rsi), %ecx
 mov %edx, 2(%rdi)
 mov %ecx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_133bytes:
 lddqu 117(%rsi), %xmm0
 movdqu %xmm0, 117(%rdi)
.Lbwd_write_117bytes:
 lddqu 101(%rsi), %xmm0
 movdqu %xmm0, 101(%rdi)
.Lbwd_write_101bytes:
 lddqu 85(%rsi), %xmm0
 movdqu %xmm0, 85(%rdi)
.Lbwd_write_85bytes:
 lddqu 69(%rsi), %xmm0
 movdqu %xmm0, 69(%rdi)
.Lbwd_write_69bytes:
 lddqu 53(%rsi), %xmm0
 movdqu %xmm0, 53(%rdi)
.Lbwd_write_53bytes:
 lddqu 37(%rsi), %xmm0
 movdqu %xmm0, 37(%rdi)
.Lbwd_write_37bytes:
 lddqu 21(%rsi), %xmm0
 movdqu %xmm0, 21(%rdi)
.Lbwd_write_21bytes:
 lddqu 5(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 5(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_5bytes:
 mov 1(%rsi), %edx
 mov (%rsi), %ecx
 mov %edx, 1(%rdi)
 mov %ecx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_132bytes:
 lddqu 116(%rsi), %xmm0
 movdqu %xmm0, 116(%rdi)
.Lbwd_write_116bytes:
 lddqu 100(%rsi), %xmm0
 movdqu %xmm0, 100(%rdi)
.Lbwd_write_100bytes:
 lddqu 84(%rsi), %xmm0
 movdqu %xmm0, 84(%rdi)
.Lbwd_write_84bytes:
 lddqu 68(%rsi), %xmm0
 movdqu %xmm0, 68(%rdi)
.Lbwd_write_68bytes:
 lddqu 52(%rsi), %xmm0
 movdqu %xmm0, 52(%rdi)
.Lbwd_write_52bytes:
 lddqu 36(%rsi), %xmm0
 movdqu %xmm0, 36(%rdi)
.Lbwd_write_36bytes:
 lddqu 20(%rsi), %xmm0
 movdqu %xmm0, 20(%rdi)
.Lbwd_write_20bytes:
 lddqu 4(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 4(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_4bytes:
 mov (%rsi), %edx
 mov %edx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_131bytes:
 lddqu 115(%rsi), %xmm0
 movdqu %xmm0, 115(%rdi)
.Lbwd_write_115bytes:
 lddqu 99(%rsi), %xmm0
 movdqu %xmm0, 99(%rdi)
.Lbwd_write_99bytes:
 lddqu 83(%rsi), %xmm0
 movdqu %xmm0, 83(%rdi)
.Lbwd_write_83bytes:
 lddqu 67(%rsi), %xmm0
 movdqu %xmm0, 67(%rdi)
.Lbwd_write_67bytes:
 lddqu 51(%rsi), %xmm0
 movdqu %xmm0, 51(%rdi)
.Lbwd_write_51bytes:
 lddqu 35(%rsi), %xmm0
 movdqu %xmm0, 35(%rdi)
.Lbwd_write_35bytes:
 lddqu 19(%rsi), %xmm0
 movdqu %xmm0, 19(%rdi)
.Lbwd_write_19bytes:
 lddqu 3(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 3(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_3bytes:
 mov 1(%rsi), %dx
 mov (%rsi), %cx
 mov %dx, 1(%rdi)
 mov %cx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_130bytes:
 lddqu 114(%rsi), %xmm0
 movdqu %xmm0, 114(%rdi)
.Lbwd_write_114bytes:
 lddqu 98(%rsi), %xmm0
 movdqu %xmm0, 98(%rdi)
.Lbwd_write_98bytes:
 lddqu 82(%rsi), %xmm0
 movdqu %xmm0, 82(%rdi)
.Lbwd_write_82bytes:
 lddqu 66(%rsi), %xmm0
 movdqu %xmm0, 66(%rdi)
.Lbwd_write_66bytes:
 lddqu 50(%rsi), %xmm0
 movdqu %xmm0, 50(%rdi)
.Lbwd_write_50bytes:
 lddqu 34(%rsi), %xmm0
 movdqu %xmm0, 34(%rdi)
.Lbwd_write_34bytes:
 lddqu 18(%rsi), %xmm0
 movdqu %xmm0, 18(%rdi)
.Lbwd_write_18bytes:
 lddqu 2(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 2(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_2bytes:
 movzwl (%rsi), %edx
 mov %dx, (%rdi)
 ret

 .p2align 4
.Lbwd_write_129bytes:
 lddqu 113(%rsi), %xmm0
 movdqu %xmm0, 113(%rdi)
.Lbwd_write_113bytes:
 lddqu 97(%rsi), %xmm0
 movdqu %xmm0, 97(%rdi)
.Lbwd_write_97bytes:
 lddqu 81(%rsi), %xmm0
 movdqu %xmm0, 81(%rdi)
.Lbwd_write_81bytes:
 lddqu 65(%rsi), %xmm0
 movdqu %xmm0, 65(%rdi)
.Lbwd_write_65bytes:
 lddqu 49(%rsi), %xmm0
 movdqu %xmm0, 49(%rdi)
.Lbwd_write_49bytes:
 lddqu 33(%rsi), %xmm0
 movdqu %xmm0, 33(%rdi)
.Lbwd_write_33bytes:
 lddqu 17(%rsi), %xmm0
 movdqu %xmm0, 17(%rdi)
.Lbwd_write_17bytes:
 lddqu 1(%rsi), %xmm0
 lddqu (%rsi), %xmm1
 movdqu %xmm0, 1(%rdi)
 movdqu %xmm1, (%rdi)
 ret

 .p2align 4
.Lbwd_write_1bytes:
 movzbl (%rsi), %edx
 mov %dl, (%rdi)
 ret

 .section .rodata.ssse3
 .p2align 3
.Ltable_144_bytes_bwd:
 .int .Lbwd_write_0bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_1bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_2bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_3bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_4bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_5bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_6bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_7bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_8bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_9bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_10bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_11bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_12bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_13bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_14bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_15bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_16bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_17bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_18bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_19bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_20bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_21bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_22bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_23bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_24bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_25bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_26bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_27bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_28bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_29bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_30bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_31bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_32bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_33bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_34bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_35bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_36bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_37bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_38bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_39bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_40bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_41bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_42bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_43bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_44bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_45bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_46bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_47bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_48bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_49bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_50bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_51bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_52bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_53bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_54bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_55bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_56bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_57bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_58bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_59bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_60bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_61bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_62bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_63bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_64bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_65bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_66bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_67bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_68bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_69bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_70bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_71bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_72bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_73bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_74bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_75bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_76bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_77bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_78bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_79bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_80bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_81bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_82bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_83bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_84bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_85bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_86bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_87bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_88bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_89bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_90bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_91bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_92bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_93bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_94bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_95bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_96bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_97bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_98bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_99bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_100bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_101bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_102bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_103bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_104bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_105bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_106bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_107bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_108bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_109bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_110bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_111bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_112bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_113bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_114bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_115bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_116bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_117bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_118bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_119bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_120bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_121bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_122bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_123bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_124bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_125bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_126bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_127bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_128bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_129bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_130bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_131bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_132bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_133bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_134bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_135bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_136bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_137bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_138bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_139bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_140bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_141bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_142bytes - .Ltable_144_bytes_bwd
 .int .Lbwd_write_143bytes - .Ltable_144_bytes_bwd

 .p2align 3
.Ltable_144_bytes_fwd:
 .int .Lfwd_write_0bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_1bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_2bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_3bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_4bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_5bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_6bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_7bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_8bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_9bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_10bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_11bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_12bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_13bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_14bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_15bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_16bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_17bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_18bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_19bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_20bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_21bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_22bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_23bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_24bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_25bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_26bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_27bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_28bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_29bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_30bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_31bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_32bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_33bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_34bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_35bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_36bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_37bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_38bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_39bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_40bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_41bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_42bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_43bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_44bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_45bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_46bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_47bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_48bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_49bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_50bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_51bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_52bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_53bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_54bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_55bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_56bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_57bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_58bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_59bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_60bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_61bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_62bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_63bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_64bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_65bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_66bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_67bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_68bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_69bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_70bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_71bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_72bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_73bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_74bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_75bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_76bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_77bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_78bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_79bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_80bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_81bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_82bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_83bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_84bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_85bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_86bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_87bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_88bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_89bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_90bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_91bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_92bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_93bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_94bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_95bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_96bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_97bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_98bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_99bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_100bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_101bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_102bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_103bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_104bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_105bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_106bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_107bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_108bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_109bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_110bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_111bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_112bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_113bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_114bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_115bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_116bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_117bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_118bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_119bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_120bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_121bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_122bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_123bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_124bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_125bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_126bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_127bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_128bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_129bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_130bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_131bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_132bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_133bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_134bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_135bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_136bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_137bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_138bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_139bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_140bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_141bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_142bytes - .Ltable_144_bytes_fwd
 .int .Lfwd_write_143bytes - .Ltable_144_bytes_fwd

 .p2align 3
.Lshl_table_fwd:
 .int .Lshl_0 - .Lshl_table_fwd
 .int .Lshl_1 - .Lshl_table_fwd
 .int .Lshl_2 - .Lshl_table_fwd
 .int .Lshl_3 - .Lshl_table_fwd
 .int .Lshl_4 - .Lshl_table_fwd
 .int .Lshl_5 - .Lshl_table_fwd
 .int .Lshl_6 - .Lshl_table_fwd
 .int .Lshl_7 - .Lshl_table_fwd
 .int .Lshl_8 - .Lshl_table_fwd
 .int .Lshl_9 - .Lshl_table_fwd
 .int .Lshl_10 - .Lshl_table_fwd
 .int .Lshl_11 - .Lshl_table_fwd
 .int .Lshl_12 - .Lshl_table_fwd
 .int .Lshl_13 - .Lshl_table_fwd
 .int .Lshl_14 - .Lshl_table_fwd
 .int .Lshl_15 - .Lshl_table_fwd

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
