
.include "../printfm.s"

.text
.globl _main

.align 2

_main:
    stp     fp, lr, [sp, #-0x10]!
    mov     fp, sp

    PRINTFM     "PRINTFM 0\n"

    mov     x8, #12
    PRINTFM     "PRINTFM 1: %d\n", 8

    mov     x0, #-423
    PRINTFM     "PRINTFM 2: %d, %d\n", 8, 0
    
    mov     x16, #-1
    PRINTFM     "PRINTFM 3: %d, %d, 0x%x\n", 8, 0, 16

    mov     x3, #72
    PRINTFM     "PRINTFM 4: %d, %d, 0x%x, %d\n", 8, 0, 16, 3

    mov     w22, 'w'
    PRINTFM     "PRINTFM 5: %d, %d, 0x%x, %d, %c\n", 8, 0, 16, 3, 22

    adr     x1, msg
    PRINTFM     "PRINTFM 6: %d, %d, 0x%x, %d, %c, %s\n", 8, 0, 16, 3, 22, 1

    mov     x13, #-423
    PRINTFM     "PRINTFM 7: %d, %d, 0x%x, %d, %c, %s, %llu\n", 8, 0, 16, 3, 22, 1, 13

    PRINTFM     "PRINTFM 8: %d, %d, 0x%x, %d, %c, %s, %llu, %d\n", 8, 0, 16, 3, 22, 1, 13, 8

    mov     sp, fp  
    ldp     fp, lr, [sp], #0x10
    mov     x0, #0
    ret

msg:
    .asciz "foo"


