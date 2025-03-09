
.include "../printfm.s"

.text
.globl _main

.align 2

_main:
    stp     fp, lr, [sp, #-0x10]!
    mov     fp, sp
    sub     sp, sp, #0x10

    PRINTFM     "PRINTFM 0\n"

    mov     x21, #12
    PRINTFM     "PRINTFM 1: %d\n", 21

    mov     x17, #423
    mov     x1, #12
    PRINTFM     "PRINTFM 2: %d, %d\n", 1, 17
    
    mov     x16, #98
    mov     x0, #423
    mov     x8, #12
    PRINTFM     "PRINTFM 3: %d, %d, %d\n", 8, 0, 16

    mov     x3, #72
    mov     x16, #98
    mov     x0, #423
    mov     x8, #12
    PRINTFM     "PRINTFM 4: %d, %d, %d, %d\n", 8, 0, 16, 3

    // Don't set 29, its fp.
    mov     x3, #72
    mov     x16, #98
    mov     x0, #423
    mov     x8, #12
    PRINTFM     "PRINTFM 5: %d, %d, %d, %d, 0x%llx\n", 8, 0, 16, 3, 29

    // Don't set 30, its lr.
    // Don't set 29, its fp.
    mov     x3, #72
    mov     x16, #98
    mov     x0, #423
    mov     x8, #12
    PRINTFM     "PRINTFM 5: %d, %d, %d, %d, 0x%llx, 0x%llx\n", 8, 0, 16, 3, 29, 30

    mov     sp, fp  
    ldp     fp, lr, [sp], #0x10
    mov     x0, #0
    ret


