
.macro PRINTF_COUNT_ARGS_REC reg:req, first:req, rest:vararg
    add     \reg, \reg, #1
.ifnb \rest
    PRINTF_COUNT_ARGS_REC \reg, \rest
.endif
.endmacro

.macro PRINTF_COUNT_ARGS reg:req, args:vararg
    mov     \reg, #0
.ifnb \args
    PRINTF_COUNT_ARGS_REC \reg, \args
.endif
.endmacro


.macro PRINTF_SAVE_ARGS_REC stack:req, first:req, rest:vararg
    mov     x0, #\first
    ldr     x0, [\stack, x0, LSL#3]
    str     x0, [sp, x1, LSL#3]
    add     x1, x1, #1

.ifnb \rest
    PRINTF_SAVE_ARGS_REC \stack, \rest
.endif
.endmacro

.macro PRINTF_SAVE_ARGS stack:req, args:vararg
    mov     x1, #0
.ifnb \args
    PRINTF_SAVE_ARGS_REC \stack, \args
.endif
.endmacro


.macro PRINTF str:req, args:vararg
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


    PRINTF_COUNT_ARGS x1, \args

    // Round x1 up to the nearest even (16 bytes).
    and     x4, x1, #0x1
    cbz     x4, skip_round_1_\@
    add     x1, x1, #0x1
skip_round_1_\@:

    mov     x3, sp
    sub     sp, sp, x1, LSL#3

    PRINTF_SAVE_ARGS x3, \args

    adrp        x0, fmt_\@@PAGE
    add         x0, x0, fmt_\@@PAGEOFF
    bl          _printf

.data
fmt_\@:
    .asciz "\str"
.text

    PRINTF_COUNT_ARGS x1, \args

    // Round x1 up to the nearest even (16 bytes).
    and     x4, x1, #0x1
    cbz     x4, skip_round_2_\@
    add     x1, x1, #0x1
skip_round_2_\@:

    add     sp, sp, x1, LSL#3

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
.endmacro

