
.include "../printfm.s"

    .globl _main
_main:
    push    %rbp
    push    %r15

    mov     $12, %r8
    mov     $-423, %rax
    mov     $-1, %r15
    mov     $'w', %si
    lea     msg(%rip), %rbp
    mov     $-1, %rdi
    PRINTFM     "PRINTFM 5: %d, %d, 0x%x, %c, %s, %llx\n", %r8, %rax, %r15, %rsi, %rbp, %rdi

    pop     %r15
    pop     %rbp
    mov     $0, %rax
    ret
    

msg:
    .asciz "foo"
