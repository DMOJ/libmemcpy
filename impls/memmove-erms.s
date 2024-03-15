 .text
.globl __mempcpy_erms
__mempcpy_erms:
 mov %rdi, %rax

 test %rdx, %rdx
 jz 2f
 add %rdx, %rax
 jmp .Lstart_movsb

.globl __memmove_erms
__memmove_erms:
 movq %rdi, %rax

 test %rdx, %rdx
 jz 2f
.Lstart_movsb:
 mov %rdx, %rcx
 cmp %rsi, %rdi
 jb 1f

 je 2f
 lea (%rsi,%rcx), %rdx
 cmp %rdx, %rdi
 jb .Lmovsb_backward
1:
 rep movsb
2:
 ret
.Lmovsb_backward:
 leaq -1(%rdi,%rcx), %rdi
 leaq -1(%rsi,%rcx), %rsi
 std
 rep movsb
 cld
 ret
.globl __memcpy_erms
.set __memcpy_erms, __memmove_erms
