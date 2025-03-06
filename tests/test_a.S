
.include "../printf.S"

.text
.globl _main

.align 2

_main:
    stp     fp, lr, [sp, #-0x10]!
    mov     fp, sp
    sub     sp, sp, #0x10

    PRINTF     "PRINTF 0\n"

    mov     x21, #12
    PRINTF     "PRINTF 1: %d\n", 21

    mov     x17, #423
    mov     x1, #12
    PRINTF     "PRINTF 2: %d, %d\n", 1, 17

    mov     x16, #98
    mov     x0, #423
    mov     x8, #12
    PRINTF     "PRINTF 3: %d, %d, %d\n", 8, 0, 16

    mov     x3, #72
    mov     x16, #98
    mov     x0, #423
    mov     x8, #12
    PRINTF     "PRINTF 4: %d, %d, %d, %d\n", 8, 0, 16, 3
tmp:



    mov     sp, fp  
    ldp     fp, lr, [sp], #0x10
    mov     x0, #0
    ret


