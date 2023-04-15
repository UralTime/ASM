%include "io.inc"

section .text
    global CMAIN
CMAIN:
    GET_UDEC 4, eax
    GET_UDEC 4, ebx
    GCD:
        test    ebx, ebx
        jz      EXIT
        xor     edx, edx
        div     ebx         ; edx = eax % ebx
        mov     eax, ebx
        mov     ebx, edx
        jmp     GCD         ; GCD = GCD (b, a%b)
    EXIT:
        PRINT_UDEC 4, eax
    xor eax, eax
    ret