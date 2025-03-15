
# `PRINTFM`

`PRINTFM` (for "`printf` macro") is a family of AArch64 and x86-64 assembly macro that makes calling `printf` nearly as easy and seamless as in C.


## AArch64

Include `printfm.s` with `.include "<path>/printfm.s"`. You can then use `PRINTFM` by passing a format string as a string literal, and registers as bare integers, e.g.,

```
    // 9 in x3
    // -1 in w21
    // &foo in x8
    PRINTFM "%lld, 0x%x, %s\n", 3, 21, 8

foo:
    .asciz "bar"
```

prints `9, 0xffffffff, bar`. All registers (including caller-save, but not `psw`) are restored at the end of the macro, and the space for format string is allocated in the data section, so `PRINTFM` can be dropped in to random places to debug with minimal fuss.  Note that registers are specified by numbers, without `x`, `w`, or `#`, and that floating point and vector registers are not currently supported.

The Mac OS version supports zero or more variadic arguments (in addition to the required format string). The Linux version currently supports zero to seven (inclusive) variadic arguments.


## x86-64

Include `printfm.s` with `.include "<path>/printfm.s"`. You can then use `PRINTFM` by passing a format string as a string literal, and registers by name, e.g.,

```
    // 9 in %r8d
    // -1 in %rax
    // &foo in %rsi
    PRINTFM "%lld, 0x%x, %s\n", %rdx, %rax, %rsi

foo:
    .asciz "bar"
```

prints `9, 0xffffffff, bar`. All registers (including caller-save, but not `rflags`) are restored at the end of the macro, and the space for format string is allocated in the data section, so `PRINTFM` can be dropped in to random places to debug with minimal fuss. Currently, zero to five (inclusive) variadic arguments are supported.





