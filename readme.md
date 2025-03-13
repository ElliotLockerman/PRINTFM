
# `PRINTFM`

`PRINTFM` (for "`printf` macro") is an AArch64 assembly macro that makes calling `printf` nearly as easy and seamless as in C.


## Usage

Include `printfm.s` with `.include "<path>/printfm.s"`. You can then use `PRINTFM` by passing a format string as a string literal, and registers as bare integers, e.g.,

```
    mov     x3, #9
    mov     w21, #-1
    adr     x8, foo
    PRINTFM "%lld, 0x%x, %s\n", 3, 21, 8

foo:
    .asciz "bar"
```

prints `9, 0xffffffff, bar`. All registers (even caller-save) are restored at the end of the macro, and the space for format string is (statically) allocated, so it can be dropped in to monitor register values with minimal fuss.  Note that registers are specified by numbers, without `x`, `w`, or `#`, and that floating point and vector registers are not currently supported.

The Mac OS version supports zero or more variadic arguments (in addition to the required format string). The Linux version currently supports zero to seven (inclusive) variadic arguments.

