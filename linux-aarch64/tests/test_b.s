
.include "../printfm.S"

.text
.globl main

.align 2

main:
    stp     fp, lr, [sp, #-0x10]!
    mov     fp, sp
    sub     sp, sp, #0x10

    mov     x13, #-423
    adr     x1, msg
    mov     w22, 'w'
    mov     x3, #72
    mov     x16, #-1
    mov     x0, #-423
    mov     x8, #12
    PRINTFM     "PRINTFM 8: %d, %d, 0x%x, %d, %c, %s, %llu, %d\n", 8, 0, 16, 3, 22, 1, 13, 8

    mov     sp, fp  
    ldp     fp, lr, [sp], #0x10
    mov     x0, #0
    ret


