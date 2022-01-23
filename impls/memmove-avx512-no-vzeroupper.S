 .section .text.avx512
.globl __mempcpy_avx512_no_vzeroupper
__mempcpy_avx512_no_vzeroupper:
 mov %rdi, %rax
 add %rdx, %rax
 jmp .Lstart

.globl __memmove_avx512_no_vzeroupper
__memmove_avx512_no_vzeroupper:
 mov %rdi, %rax

.Lstart:

 lea (%rsi, %rdx), %rcx
 lea (%rdi, %rdx), %r9
 cmp $512, %rdx
 ja .L512bytesormore

.Lcheck:
 cmp $16, %rdx
 jbe .Lless_16bytes
 cmp $256, %rdx
 jb .Lless_256bytes
 vmovups (%rsi), %zmm0
 vmovups 0x40(%rsi), %zmm1
 vmovups 0x80(%rsi), %zmm2
 vmovups 0xC0(%rsi), %zmm3
 vmovups -0x100(%rcx), %zmm4
 vmovups -0xC0(%rcx), %zmm5
 vmovups -0x80(%rcx), %zmm6
 vmovups -0x40(%rcx), %zmm7
 vmovups %zmm0, (%rdi)
 vmovups %zmm1, 0x40(%rdi)
 vmovups %zmm2, 0x80(%rdi)
 vmovups %zmm3, 0xC0(%rdi)
 vmovups %zmm4, -0x100(%r9)
 vmovups %zmm5, -0xC0(%r9)
 vmovups %zmm6, -0x80(%r9)
 vmovups %zmm7, -0x40(%r9)
 ret

.Lless_256bytes:
 cmp $128, %dl
 jb .Lless_128bytes
 vmovups (%rsi), %zmm0
 vmovups 0x40(%rsi), %zmm1
 vmovups -0x80(%rcx), %zmm2
 vmovups -0x40(%rcx), %zmm3
 vmovups %zmm0, (%rdi)
 vmovups %zmm1, 0x40(%rdi)
 vmovups %zmm2, -0x80(%r9)
 vmovups %zmm3, -0x40(%r9)
 ret

.Lless_128bytes:
 cmp $64, %dl
 jb .Lless_64bytes
 vmovdqu (%rsi), %ymm0
 vmovdqu 0x20(%rsi), %ymm1
 vmovdqu -0x40(%rcx), %ymm2
 vmovdqu -0x20(%rcx), %ymm3
 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm1, 0x20(%rdi)
 vmovdqu %ymm2, -0x40(%r9)
 vmovdqu %ymm3, -0x20(%r9)
 ret

.Lless_64bytes:
 cmp $32, %dl
 jb .Lless_32bytes
 vmovdqu (%rsi), %ymm0
 vmovdqu -0x20(%rcx), %ymm1
 vmovdqu %ymm0, (%rdi)
 vmovdqu %ymm1, -0x20(%r9)
 ret

.Lless_32bytes:
 vmovdqu (%rsi), %xmm0
 vmovdqu -0x10(%rcx), %xmm1
 vmovdqu %xmm0, (%rdi)
 vmovdqu %xmm1, -0x10(%r9)
 ret

.Lless_16bytes:
 cmp $8, %dl
 jb .Lless_8bytes
 movq (%rsi), %rsi
 movq -0x8(%rcx), %rcx
 movq %rsi, (%rdi)
 movq %rcx, -0x8(%r9)
 ret

.Lless_8bytes:
 cmp $4, %dl
 jb .Lless_4bytes
 mov (%rsi), %esi
 mov -0x4(%rcx), %ecx
 mov %esi, (%rdi)
 mov %ecx, -0x4(%r9)
 ret

.Lless_4bytes:
 cmp $2, %dl
 jb .Lless_2bytes
 mov (%rsi), %si
 mov -0x2(%rcx), %cx
 mov %si, (%rdi)
 mov %cx, -0x2(%r9)
 ret

.Lless_2bytes:
 cmp $1, %dl
 jb .Lless_1bytes
 mov (%rsi), %cl
 mov %cl, (%rdi)
.Lless_1bytes:
 ret

.L512bytesormore:

 mov __x86_shared_cache_size_half(%rip), %r8

 cmp %r8, %rdx
 jae .Lpreloop_large
 cmp $1024, %rdx
 ja .L1024bytesormore
 prefetcht1 (%rsi)
 prefetcht1 0x40(%rsi)
 prefetcht1 0x80(%rsi)
 prefetcht1 0xC0(%rsi)
 prefetcht1 0x100(%rsi)
 prefetcht1 0x140(%rsi)
 prefetcht1 0x180(%rsi)
 prefetcht1 0x1C0(%rsi)
 prefetcht1 -0x200(%rcx)
 prefetcht1 -0x1C0(%rcx)
 prefetcht1 -0x180(%rcx)
 prefetcht1 -0x140(%rcx)
 prefetcht1 -0x100(%rcx)
 prefetcht1 -0xC0(%rcx)
 prefetcht1 -0x80(%rcx)
 prefetcht1 -0x40(%rcx)
 vmovups (%rsi), %zmm0
 vmovups 0x40(%rsi), %zmm1
 vmovups 0x80(%rsi), %zmm2
 vmovups 0xC0(%rsi), %zmm3
 vmovups 0x100(%rsi), %zmm4
 vmovups 0x140(%rsi), %zmm5
 vmovups 0x180(%rsi), %zmm6
 vmovups 0x1C0(%rsi), %zmm7
 vmovups -0x200(%rcx), %zmm8
 vmovups -0x1C0(%rcx), %zmm9
 vmovups -0x180(%rcx), %zmm10
 vmovups -0x140(%rcx), %zmm11
 vmovups -0x100(%rcx), %zmm12
 vmovups -0xC0(%rcx), %zmm13
 vmovups -0x80(%rcx), %zmm14
 vmovups -0x40(%rcx), %zmm15
 vmovups %zmm0, (%rdi)
 vmovups %zmm1, 0x40(%rdi)
 vmovups %zmm2, 0x80(%rdi)
 vmovups %zmm3, 0xC0(%rdi)
 vmovups %zmm4, 0x100(%rdi)
 vmovups %zmm5, 0x140(%rdi)
 vmovups %zmm6, 0x180(%rdi)
 vmovups %zmm7, 0x1C0(%rdi)
 vmovups %zmm8, -0x200(%r9)
 vmovups %zmm9, -0x1C0(%r9)
 vmovups %zmm10, -0x180(%r9)
 vmovups %zmm11, -0x140(%r9)
 vmovups %zmm12, -0x100(%r9)
 vmovups %zmm13, -0xC0(%r9)
 vmovups %zmm14, -0x80(%r9)
 vmovups %zmm15, -0x40(%r9)
 ret

.L1024bytesormore:
 cmp %rsi, %rdi
 ja .L1024bytesormore_bkw
 sub $512, %r9
 vmovups -0x200(%rcx), %zmm8
 vmovups -0x1C0(%rcx), %zmm9
 vmovups -0x180(%rcx), %zmm10
 vmovups -0x140(%rcx), %zmm11
 vmovups -0x100(%rcx), %zmm12
 vmovups -0xC0(%rcx), %zmm13
 vmovups -0x80(%rcx), %zmm14
 vmovups -0x40(%rcx), %zmm15
 prefetcht1 (%rsi)
 prefetcht1 0x40(%rsi)
 prefetcht1 0x80(%rsi)
 prefetcht1 0xC0(%rsi)
 prefetcht1 0x100(%rsi)
 prefetcht1 0x140(%rsi)
 prefetcht1 0x180(%rsi)
 prefetcht1 0x1C0(%rsi)

.Lgobble_512bytes_loop:
 vmovups (%rsi), %zmm0
 vmovups 0x40(%rsi), %zmm1
 vmovups 0x80(%rsi), %zmm2
 vmovups 0xC0(%rsi), %zmm3
 vmovups 0x100(%rsi), %zmm4
 vmovups 0x140(%rsi), %zmm5
 vmovups 0x180(%rsi), %zmm6
 vmovups 0x1C0(%rsi), %zmm7
 add $512, %rsi
 prefetcht1 (%rsi)
 prefetcht1 0x40(%rsi)
 prefetcht1 0x80(%rsi)
 prefetcht1 0xC0(%rsi)
 prefetcht1 0x100(%rsi)
 prefetcht1 0x140(%rsi)
 prefetcht1 0x180(%rsi)
 prefetcht1 0x1C0(%rsi)
 vmovups %zmm0, (%rdi)
 vmovups %zmm1, 0x40(%rdi)
 vmovups %zmm2, 0x80(%rdi)
 vmovups %zmm3, 0xC0(%rdi)
 vmovups %zmm4, 0x100(%rdi)
 vmovups %zmm5, 0x140(%rdi)
 vmovups %zmm6, 0x180(%rdi)
 vmovups %zmm7, 0x1C0(%rdi)
 add $512, %rdi
 cmp %r9, %rdi
 jb .Lgobble_512bytes_loop
 vmovups %zmm8, (%r9)
 vmovups %zmm9, 0x40(%r9)
 vmovups %zmm10, 0x80(%r9)
 vmovups %zmm11, 0xC0(%r9)
 vmovups %zmm12, 0x100(%r9)
 vmovups %zmm13, 0x140(%r9)
 vmovups %zmm14, 0x180(%r9)
 vmovups %zmm15, 0x1C0(%r9)
 ret

.L1024bytesormore_bkw:
 add $512, %rdi
 vmovups 0x1C0(%rsi), %zmm8
 vmovups 0x180(%rsi), %zmm9
 vmovups 0x140(%rsi), %zmm10
 vmovups 0x100(%rsi), %zmm11
 vmovups 0xC0(%rsi), %zmm12
 vmovups 0x80(%rsi), %zmm13
 vmovups 0x40(%rsi), %zmm14
 vmovups (%rsi), %zmm15
 prefetcht1 -0x40(%rcx)
 prefetcht1 -0x80(%rcx)
 prefetcht1 -0xC0(%rcx)
 prefetcht1 -0x100(%rcx)
 prefetcht1 -0x140(%rcx)
 prefetcht1 -0x180(%rcx)
 prefetcht1 -0x1C0(%rcx)
 prefetcht1 -0x200(%rcx)

.Lgobble_512bytes_loop_bkw:
 vmovups -0x40(%rcx), %zmm0
 vmovups -0x80(%rcx), %zmm1
 vmovups -0xC0(%rcx), %zmm2
 vmovups -0x100(%rcx), %zmm3
 vmovups -0x140(%rcx), %zmm4
 vmovups -0x180(%rcx), %zmm5
 vmovups -0x1C0(%rcx), %zmm6
 vmovups -0x200(%rcx), %zmm7
 sub $512, %rcx
 prefetcht1 -0x40(%rcx)
 prefetcht1 -0x80(%rcx)
 prefetcht1 -0xC0(%rcx)
 prefetcht1 -0x100(%rcx)
 prefetcht1 -0x140(%rcx)
 prefetcht1 -0x180(%rcx)
 prefetcht1 -0x1C0(%rcx)
 prefetcht1 -0x200(%rcx)
 vmovups %zmm0, -0x40(%r9)
 vmovups %zmm1, -0x80(%r9)
 vmovups %zmm2, -0xC0(%r9)
 vmovups %zmm3, -0x100(%r9)
 vmovups %zmm4, -0x140(%r9)
 vmovups %zmm5, -0x180(%r9)
 vmovups %zmm6, -0x1C0(%r9)
 vmovups %zmm7, -0x200(%r9)
 sub $512, %r9
 cmp %rdi, %r9
 ja .Lgobble_512bytes_loop_bkw
 vmovups %zmm8, -0x40(%rdi)
 vmovups %zmm9, -0x80(%rdi)
 vmovups %zmm10, -0xC0(%rdi)
 vmovups %zmm11, -0x100(%rdi)
 vmovups %zmm12, -0x140(%rdi)
 vmovups %zmm13, -0x180(%rdi)
 vmovups %zmm14, -0x1C0(%rdi)
 vmovups %zmm15, -0x200(%rdi)
 ret

.Lpreloop_large:
 cmp %rsi, %rdi
 ja .Lpreloop_large_bkw
 vmovups (%rsi), %zmm4
 vmovups 0x40(%rsi), %zmm5

 mov %rdi, %r11

 mov %rdi, %r8
 and $-0x80, %rdi
 add $0x80, %rdi
 sub %rdi, %r8
 sub %r8, %rsi
 add %r8, %rdx
.Lgobble_256bytes_nt_loop:
 prefetcht1 0x200(%rsi)
 prefetcht1 0x240(%rsi)
 prefetcht1 0x280(%rsi)
 prefetcht1 0x2C0(%rsi)
 prefetcht1 0x300(%rsi)
 prefetcht1 0x340(%rsi)
 prefetcht1 0x380(%rsi)
 prefetcht1 0x3C0(%rsi)
 vmovdqu64 (%rsi), %zmm0
 vmovdqu64 0x40(%rsi), %zmm1
 vmovdqu64 0x80(%rsi), %zmm2
 vmovdqu64 0xC0(%rsi), %zmm3
 vmovntdq %zmm0, (%rdi)
 vmovntdq %zmm1, 0x40(%rdi)
 vmovntdq %zmm2, 0x80(%rdi)
 vmovntdq %zmm3, 0xC0(%rdi)
 sub $256, %rdx
 add $256, %rsi
 add $256, %rdi
 cmp $256, %rdx
 ja .Lgobble_256bytes_nt_loop
 sfence
 vmovups %zmm4, (%r11)
 vmovups %zmm5, 0x40(%r11)
 jmp .Lcheck

.Lpreloop_large_bkw:
 vmovups -0x80(%rcx), %zmm4
 vmovups -0x40(%rcx), %zmm5

 mov %r9, %r8
 and $-0x80, %r9
 sub %r9, %r8
 sub %r8, %rcx
 sub %r8, %rdx
 add %r9, %r8
.Lgobble_256bytes_nt_loop_bkw:
 prefetcht1 -0x400(%rcx)
 prefetcht1 -0x3C0(%rcx)
 prefetcht1 -0x380(%rcx)
 prefetcht1 -0x340(%rcx)
 prefetcht1 -0x300(%rcx)
 prefetcht1 -0x2C0(%rcx)
 prefetcht1 -0x280(%rcx)
 prefetcht1 -0x240(%rcx)
 vmovdqu64 -0x100(%rcx), %zmm0
 vmovdqu64 -0xC0(%rcx), %zmm1
 vmovdqu64 -0x80(%rcx), %zmm2
 vmovdqu64 -0x40(%rcx), %zmm3
 vmovntdq %zmm0, -0x100(%r9)
 vmovntdq %zmm1, -0xC0(%r9)
 vmovntdq %zmm2, -0x80(%r9)
 vmovntdq %zmm3, -0x40(%r9)
 sub $256, %rdx
 sub $256, %rcx
 sub $256, %r9
 cmp $256, %rdx
 ja .Lgobble_256bytes_nt_loop_bkw
 sfence
 vmovups %zmm4, -0x80(%r8)
 vmovups %zmm5, -0x40(%r8)
 jmp .Lcheck

.globl __memcpy_avx512_no_vzeroupper
.set __memcpy_avx512_no_vzeroupper, __memmove_avx512_no_vzeroupper
