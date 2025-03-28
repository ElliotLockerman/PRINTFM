
.include "../printfm.s"

    .globl main
main:
    push    %rbp
    mov     %rsp, %rbp

    PRINTFM "PRINTFM 0\n"

    mov     $12, %r8d
    PRINTFM "PRINTFM 1: %d\n", %r8

    mov     $-1, %rax
    PRINTFM     "PRINTFM 2: %d, 0x%x, %d\n", %r8, %rax, %r8

    PRINTFM     "PRINTFM 3: %d, 0x%x, %d\n", %r8, %rax, %r8

    mov     $'w', %si
    PRINTFM     "PRINTFM 4: %d, 0x%x, %d, %c\n", %r8, %rax, %r8, %rsi

    lea     msg(%rip), %rdi
    PRINTFM     "PRINTFM 5: %d, 0x%x, %d, %c, %s\n", %r8, %rax, %r8, %rsi, %rdi

    mov     %rbp, %rsp
    pop     %rbp
    mov     $0, %rax
    ret
    

msg:
    .asciz "foo"
