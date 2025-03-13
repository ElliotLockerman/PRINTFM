
////////////////////////////////////////////////////////////////////////////////
// PRINTF_COUNT_ARGS(dst: register, args...: register)
// Count number of args to dst.
////////////////////////////////////////////////////////////////////////////////

.macro PRINTFM_COUNT_ARGS dst:req, args:vararg
    mov     \dst, #0
.ifnb \args
    PRINTFM_COUNT_ARGS_REC \dst, \args
.endif
.endmacro

.macro PRINTFM_COUNT_ARGS_REC dst:req, first:req, rest:vararg
    add     \dst, \dst, #1
.ifnb \rest
    PRINTFM_COUNT_ARGS_REC \dst, \rest
.endif
.endm


////////////////////////////////////////////////////////////////////////////////
// PRINTFM_COPY_ARGS (
//     dst: register, src: register, clobber: register req, regs...: integer literals
// )
// Copy registers specified in regs from src array (pointer to buffer where all
// registered have been saved in numeric order) to sequential addresses in dst
// array. clobber is a registers that will be clobbered. args are integer literals
// of the registers.
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
// PRINTF(str: string literal, args...: register number literals)
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


    // Count variadic arguments, and round up to the nearest even (16 bytes).
    PRINTFM_COUNT_ARGS x19, \args
    and     x4, x19, #0x1   // Get lowest bit (one iff odd).
    add     x19, x19, x4    // Add it back (now its even).

    // Allocate an array on the stack for variadic arguments to printf(), and
    // copy the specified registers to it.
    mov     x3, sp              // Get address of saved registers.
    sub     sp, sp, x19, LSL#3  // Allocate space on stack for printf varargs.
    mov     x2, sp              // Get address of varargs array.
    PRINTFM_COPY_ARGS x2, x3, x1, \args

    // Get format string and call printf().
    adrp    x0, fmt_\@@PAGE
    add     x0, x0, fmt_\@@PAGEOFF
    bl      _printf

.data
fmt_\@:
    .asciz "\str"
.text

    add     sp, sp, x19, LSL#3   // Deallocate space for printf varargs.

    // Restore registers.
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

