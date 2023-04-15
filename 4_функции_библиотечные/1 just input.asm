%include "io.inc"
 
section .bss
    x resd 1
 
section .data
    u dd "%u", 0
    format dd `0x%08X\n`, 0

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    .while:
        sub     esp, 4
        push    x
        push    u          ;стэк выровнен по 16: возвратCMAIN | ___  | &x  | u
        call  scanf
        cmp     eax, -1     ;end of input, scanf вернул -1
        je   .break
        add     esp, 8
        push    dword[x]
        push    format      ;стэк выровнен по 16: возвратCMAIN | ___  | x  | u
        call  printf 
        add     esp, 12
        jmp     .while
    .break:
    add esp, 12
    xor eax, eax
    ret