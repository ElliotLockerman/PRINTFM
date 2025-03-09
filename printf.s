
.macro PRINTF_COUNT_ARGS_REC dst:req, first:req, rest:vararg
    add     \dst, \dst, #1
.ifnb \rest
    PRINTF_COUNT_ARGS_REC \dst, \rest
.endif
.endmacro

// Count number of args to register dst.
.macro PRINTF_COUNT_ARGS dst:req, args:vararg
    mov     \dst, #0
.ifnb \args
    PRINTF_COUNT_ARGS_REC \dst, \args
.endif
.endmacro


.macro PRINTF_SAVE_ARGS_REC src:req, clobber_a:req, clobber_b:req, first:req, rest:vararg
    mov     \clobber_b, #\first
    ldr     \clobber_b, [\src, \clobber_b, LSL#3]
    str     \clobber_b, [sp, \clobber_a, LSL#3]
    add     \clobber_a, \clobber_a, #1

.ifnb \rest
    PRINTF_SAVE_ARGS_REC \src, \clobber_a, \clobber_b, \rest
.endif
.endmacro

// Copy registers from src (pointer to buffer where all registered have been
// saved in ascending order) to sequential positions on stack. clobber_a and
// clobber_b are registers that will be clobbered. args are integer literals of
// the registers.
.macro PRINTF_SAVE_ARGS src:req, clobber_a:req, clobber_b:req, args:vararg
    mov     \clobber_a, #0
.ifnb \args
    PRINTF_SAVE_ARGS_REC \src, \clobber_a, \clobber_b, \args
.endif
.endmacro


.macro PRINTF str:req, args:vararg
    // Save all registers so we can get them programatically.
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
    and     x4, x1, #0x1 // Get lowest bit (one iff odd).
    add     x1, x1, x4   // Add it back (now its even).

    mov     x3, sp              // Save old sp so we can copy regs off it.
    sub     sp, sp, x1, LSL#3   // Allocate space on stack for printf varargs.

    PRINTF_SAVE_ARGS x3, x0, x1, \args

    adrp        x0, fmt_\@@PAGE
    add         x0, x0, fmt_\@@PAGEOFF
    bl          _printf

.data
fmt_\@:
    .asciz "\str"
.text

    PRINTF_COUNT_ARGS x1, \args

    // Round x1 up to the nearest even (16 bytes).
    and     x4, x1, #0x1 // Get lowest bit (one iff odd).
    add     x1, x1, x4   // Add it back (now we're even).

    add     sp, sp, x1, LSL#3   // Deallocate space for printf varargs.

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

