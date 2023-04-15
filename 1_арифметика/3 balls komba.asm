%include "io.inc"

section .bss
    a resd 1
    b resd 1
    c resd 1
    d resd 1
    e resd 1
    f resd 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, a
    GET_UDEC 4, b
    GET_UDEC 4, c
    GET_UDEC 4, d
    GET_UDEC 4, e
    GET_UDEC 4, f
    mov     eax, dword[e]
    add     eax, dword[f]
    imul    eax, dword[a];     eax = (e+f)*a
    mov     ebx, dword[d]
    add     ebx, dword[f]
    imul    ebx, dword[b];     ebx = (d+f)*b
    mov     ecx, dword[d]
    add     ecx, dword[e]
    imul    ecx, dword[c];     ecx = (d+e)*c
    add     eax, ebx
    add     eax, ecx;        eax += (ebx + ecx)
    PRINT_UDEC 4, eax
    xor eax, eax
    ret