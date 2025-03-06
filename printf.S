
.macro PRINTF str:req, a, b, c, d
    stp		x30, x31, [sp, #-0x10]!
    stp		x28, x29, [sp, #-0x10]!
    stp		x26, x27, [sp, #-0x10]!
    stp		x24, x25, [sp, #-0x10]!
    stp		x22, x23, [sp, #-0x10]!
    stp		x20, x21, [sp, #-0x10]!
    stp		x18, x19, [sp, #-0x10]!
    stp		x16, x17, [sp, #-0x10]!
    stp		x14, x15, [sp, #-0x10]!
    stp		x12, x13, [sp, #-0x10]!
    stp		x10, x11, [sp, #-0x10]!
    stp		x8, x9, [sp, #-0x10]!
    stp		x6, x7, [sp, #-0x10]!
    stp		x4, x5, [sp, #-0x10]!
    stp		x2, x3, [sp, #-0x10]!
    stp		x0, x1, [sp, #-0x10]!

    mov     x3, sp
    sub     sp, sp, #0x100

    mov     x1, #0

.ifnb \a
    add     x1, x1, #1
.endif

.ifnb \b
    add     x1, x1, #1
.endif

.ifnb \c
    add     x1, x1, #1
.endif

.ifnb \d
    add     x1, x1, #1
.endif

    // Number of args in x1. Subtract 1 to make it an index.

.ifnb \d
    sub     x1, x1, #1
    mov     x0, #\d
    ldr     x0, [x3, x0, LSL#3]
    str     x0, [sp, x1, LSL#3]
.endif

.ifnb \c
    sub     x1, x1, #1
    mov     x0, #\c
    ldr     x0, [x3, x0, LSL#3]
    str     x0, [sp, x1, LSL#3]
.endif

.ifnb \b
    sub     x1, x1, #1
    mov     x0, #\b
    ldr     x0, [x3, x0, LSL#3]
    str     x0, [sp, x1, LSL#3]
.endif

.ifnb \a
    sub     x1, x1, #1
    mov     x0, #\a
    ldr     x0, [x3, x0, LSL#3]
    str     x0, [sp, x1, LSL#3]
.endif

    adrp        x0, fmt_\@@PAGE
    add         x0, x0, fmt_\@@PAGEOFF
    bl          _printf

.data
fmt_\@:
    .asciz "\str"
.text

    add     sp, sp, #0x100

    ldp		x0, x1, [sp], #0x10
    ldp		x2, x3, [sp], #0x10
    ldp		x4, x5, [sp], #0x10
    ldp		x6, x7, [sp], #0x10
    ldp		x8, x9, [sp], #0x10
    ldp		x10, x11, [sp], #0x10
    ldp		x12, x13, [sp], #0x10
    ldp		x14, x15, [sp], #0x10
    ldp		x16, x17, [sp], #0x10
    ldp		x18, x19, [sp], #0x10
    ldp		x20, x21, [sp], #0x10
    ldp		x22, x23, [sp], #0x10
    ldp		x24, x25, [sp], #0x10
    ldp		x26, x27, [sp], #0x10
    ldp		x28, x29, [sp], #0x10
    ldp		x30, x31, [sp], #0x10
.endmacro

