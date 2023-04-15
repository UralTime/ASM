%include "io.inc"

section .text
    global CMAIN
CMAIN:
    GET_UDEC 4, edx         ;edx === input
    xor eax, eax            ;eax === ans
    xor     ecx, ecx
    L:                      ;ecx = 0
        mov     ebx, edx
        and     ebx, 1      ; ebx = edx % 2 
        shr     edx, 1
        add     eax, ebx
        inc     ecx
        cmp     ecx, 32
        jne      L           ;while (ecx != 32)
    PRINT_UDEC  4, eax
    xor eax, eax
    ret