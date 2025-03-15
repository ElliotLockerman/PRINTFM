
////////////////////////////////////////////////////////////////////////////////
// PRINTFM_COUNT_ARGS(dst: register, args...: register)
// Count number of args to dst.
////////////////////////////////////////////////////////////////////////////////

.macro PRINTFM_COUNT_ARGS dst:req, args:vararg
    xor     %rax, %rax
.ifnb \args
    PRINTFM_COUNT_ARGS_REC \dst, \args
.endif
.endm

.macro PRINTFM_COUNT_ARGS_REC dst:req, first:req, rest:vararg
    inc     %rax
.ifnb \rest
    PRINTFM_COUNT_ARGS_REC \dst, \rest
.endif
.endm


////////////////////////////////////////////////////////////////////////////////
// PRINTFM_PUSH_ARGS(args...: register)
// Push args in registers on to the stack from right to left.
////////////////////////////////////////////////////////////////////////////////

.macro PRINTFM_PUSH_ARGS args:vararg
.ifnb \args
    PRINTFM_PUSH_ARGS_REC \args
.endif
.endm

.macro PRINTFM_PUSH_ARGS_REC first:req, rest:vararg
.ifnb \rest
    PRINTFM_PUSH_ARGS_REC \rest
.endif
    push    \first
.endm

////////////////////////////////////////////////////////////////////////////////
// PRINTFM_POP_ARGS(a, b, c, d, e)
// Transfer quadwords from the stack to registers in argument order starting
// with %rsi. Each argument to PRINTFM_POP_ARGS indicates an argument to be
// transfered from the stack, but the arguments to PRINTFM_POP_ARGS are not
// otherwise used.
////////////////////////////////////////////////////////////////////////////////
.macro PRINTFM_POP_ARGS a, b, c, d, e

.ifnb \a
    pop     %rsi
.endif

.ifnb \b
    pop     %rdx
.endif

.ifnb \c
    pop     %rcx
.endif

.ifnb \d
    pop     %r8
.endif

.ifnb \e
    pop     %r9
.endif

.endm


////////////////////////////////////////////////////////////////////////////////
// PRINTFM(str: format string literal, args...: register int literals)
// args is currently limited to 5 arguments, the maximum number of varargs that
// can be passed in registers. Printing rsp and rip will give (at best) approximal
// values, as both are used in evaluating the macro.
////////////////////////////////////////////////////////////////////////////////
.macro PRINTFM str:req, args:vararg
    sub     $8, %rsp   # For alignment
    pushq   %rdi
    pushq   %rsi
    pushq   %rdx
    pushq   %rcx
    pushq   %r8
    pushq   %r9
    pushq   %r10
    pushq   %r11
    pushq   %rax

    PRINTFM_PUSH_ARGS \args
    PRINTFM_POP_ARGS \args

    PRINTFM_COUNT_ARGS %rax, \args

    lea     printfm_msg_\@(%rip), %rdi
    call    _printf

    popq    %rax
    popq    %r11
    popq    %r10
    popq    %r9
    popq    %r8
    popq    %rcx
    popq    %rdx
    popq    %rsi
    popq    %rdi
    add     $8, %rsp

    .data

printfm_msg_\@:
    .asciz "\str"

    .text

.endm

