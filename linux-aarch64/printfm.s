

////////////////////////////////////////////////////////////////////////////////
// PRINTF_COUNT_ARGS(dst: register req, args...: register)
// Count number of args to register dst.
////////////////////////////////////////////////////////////////////////////////

.macro PRINTFM_COUNT_ARGS dst:req, args:vararg
    mov     \dst, #0
.ifnb \args
    PRINTFM_COUNT_ARGS_REC \dst, \args
.endif
.endm

.macro PRINTFM_COUNT_ARGS_REC dst:req, first:req, rest:vararg
    add     \dst, \dst, #1
.ifnb \rest
    PRINTFM_COUNT_ARGS_REC \dst, \rest
.endif
.endm




////////////////////////////////////////////////////////////////////////////////
// PRINTFM_COPY_ARGS (
//     src: register req, clobber_a: register req, clobber_b: register req,
//     args...: register int literals
// )
// Copy registers from src (pointer to buffer where all registered have been
// saved in ascending order) to sequential positions on stack. clobber_a and
// clobber_b are registers that will be clobbered. args are integer literals of
// the registers.
////////////////////////////////////////////////////////////////////////////////
.macro PRINTFM_COPY_ARGS src:req, clobber_a:req, clobber_b:req, args:vararg
    mov     \clobber_a, #0
.ifnb \args
    PRINTFM_COPY_ARGS_REC \src, \clobber_a, \clobber_b, \args
.endif
.endm

.macro PRINTFM_COPY_ARGS_REC src:req, clobber_a:req, clobber_b:req, first:req, rest:vararg
    mov     \clobber_b, #\first
    ldr     \clobber_b, [\src, \clobber_b, LSL#3]
    str     \clobber_b, [sp, \clobber_a, LSL#3]
    add     \clobber_a, \clobber_a, #1

.ifnb \rest
    PRINTFM_COPY_ARGS_REC \src, \clobber_a, \clobber_b, \rest
.endif
.endm

////////////////////////////////////////////////////////////////////////////////

// Produces an error if too many arguments are passed.
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


    // PRINTFM_COUNT_ARGS x1, \args
    PRINTFM_LIMIT_ARGS \args

    mov     x1, #PRINTFM_SLOTS
    mov     x3, sp              // Save old sp so we can copy regs off it.
    sub     sp, sp, x1, LSL#3   // Allocate space on stack for args.

    PRINTFM_COPY_ARGS x3, x0, x1, \args

    // Load varargs in to registers. Its ok to load more than were actually passed,
    // they'll never be read (assuming the format string is correct, which we
    // must assume anyway).
    // x0 is a clobber, just to equal the 8 slots we saved.
    ldp     x1, x2, [sp], #0x10
    ldp     x3, x4, [sp], #0x10
    ldp     x5, x6, [sp], #0x10
    ldp     x7, x0, [sp], #0x10

    adrp        x0, fmt_\@
    add         x0, x0, :lo12:fmt_\@
    bl          printf

.data
fmt_\@:
    .asciz "\str"
.text

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

    // The rest are callee-save, and we didn't clobber them in the macro itself.
    add     sp, sp, 0x50
.endm

