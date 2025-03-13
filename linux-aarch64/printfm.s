
////////////////////////////////////////////////////////////////////////////////
// PRINTFM_COPY_ARGS (
//     src: register, clobber_a: register, clobber_b: register, args...: integer literals
// )
// Copy registers from src (pointer to buffer where all registered have been
// saved in ascending order) to sequential positions on stack. clobber_a and
// clobber_b are registers that will be clobbered. args are integer literals of
// the registers.
////////////////////////////////////////////////////////////////////////////////
.macro PRINTFM_COPY_ARGS dst:req, src:req, clobber:req, args:vararg
.ifnb \args
    PRINTFM_COPY_ARGS_REC \dst, \src, \clobber, \args
.endif
.endm

.macro PRINTFM_COPY_ARGS_REC dst:req, src:req, clobber:req, first:req, rest:vararg
    mov     \clobber, #\first                   // Get the register number as an integer.
    ldr     \clobber, [\src, \clobber, LSL#3]   // Use it to index the saved registers.
    str     \clobber, [\dst], #0x8              // Save it to the next position.

.ifnb \rest
    PRINTFM_COPY_ARGS_REC \dst, \src, \clobber, \rest
.endif
.endm

////////////////////////////////////////////////////////////////////////////////
// PRINTFM_LIMIT_ARGS(a, b, c, d, e, f, g)
// Produces a compile-time error if too many arguments are passed.
////////////////////////////////////////////////////////////////////////////////

.macro PRINTFM_LIMIT_ARGS a, b, c, d, e, f, g
.endm

////////////////////////////////////////////////////////////////////////////////


.equ PRINTFM_MAX_ARGS, 7
.equ PRINTFM_SLOTS, PRINTFM_MAX_ARGS + 1

////////////////////////////////////////////////////////////////////////////////
// PRINTFM(str: format string literal, args...: register int literals)
// args is currently limited to 7 arguments, the maximum number of varargs that
// can be passed in registers.
////////////////////////////////////////////////////////////////////////////////
.macro PRINTFM str:req, args:vararg
    // Save all registers so we can get them programatically.
    stp     x28, x29, [sp, #-0x10]!
    stp     x26, x27, [sp, #-0x10]!
    stp     x24, x25, [sp, #-0x10]!
    stp     x22, x23, [sp, #-0x10]!
    stp     x20, x21, [sp, #-0x10]!
    stp     x18, x19, [sp, #-0x10]!
    stp     x16, x17, [sp, #-0x10]!
    stp     x14, x15, [sp, #-0x10]!
    stp     x12, x13, [sp, #-0x10]!
    stp     x10, x11, [sp, #-0x10]!
    stp     x8, x9, [sp, #-0x10]!
    stp     x6, x7, [sp, #-0x10]!
    stp     x4, x5, [sp, #-0x10]!
    stp     x2, x3, [sp, #-0x10]!
    stp     x0, x1, [sp, #-0x10]!


    PRINTFM_LIMIT_ARGS \args

    mov     x3, sp              // Save old sp so we can copy regs off it.
    mov     x1, #PRINTFM_SLOTS
    sub     sp, sp, x1, LSL#3   // Allocate space on stack for args.
    mov     x2, sp              // Get address of varargs array.
    PRINTFM_COPY_ARGS x2, x3, x1, \args

    // Load varargs in to registers. Its ok to load more than were actually passed,
    // they'll never be read (assuming the format string is correct, which we
    // must assume anyway).
    // x0 is a clobber, just to equal the 8 slots we saved.
    ldp     x1, x2, [sp], #0x10
    ldp     x3, x4, [sp], #0x10
    ldp     x5, x6, [sp], #0x10
    ldp     x7, x0, [sp], #0x10

    adrp    x0, fmt_\@
    add     x0, x0, :lo12:fmt_\@
    bl      printf

.data
fmt_\@:
    .asciz "\str"
.text

    ldp     x0, x1, [sp], #0x10
    ldp     x2, x3, [sp], #0x10
    ldp     x4, x5, [sp], #0x10
    ldp     x6, x7, [sp], #0x10
    ldp     x8, x9, [sp], #0x10
    ldp     x10, x11, [sp], #0x10
    ldp     x12, x13, [sp], #0x10
    ldp     x14, x15, [sp], #0x10
    ldp     x16, x17, [sp], #0x10
    ldp     x18, x19, [sp], #0x10

    // The rest are callee-save, and we didn't clobber them in the macro itself.
    add     sp, sp, 0x50
.endm

