%include "io.inc"

section .bss
    a   resb 1
    b   resb 1
    c   resb 1
    d   resb 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 1, a
    GET_UDEC 1, b
    GET_UDEC 1, c
    GET_UDEC 1, d
    mov     al, byte[c]
    mov     ah, byte[d]; eax [00dc]
    shl     eax, 16; eax [dc00]
    mov     al, byte[a]
    mov     ah, byte[b]; eax [dcba]
    PRINT_UDEC 4, eax; в little endian это abcd
    xor eax, eax
    ret