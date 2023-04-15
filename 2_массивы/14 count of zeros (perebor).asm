%include "io.inc"

section .bss
    N resd 1
    K resd 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, N
    GET_UDEC 4, K
    xor     edx, edx    ;edx === ans
    xor     edi, edi    ;edi === i  from 1 to n
    FOR:
        inc     edi
        cmp     edi, dword[N]
        jg      EXIT
    mov     esi, edi
    xor     eax, eax        ;eax === ans
    xor     ecx, ecx
    LOOOP:                      ;ecx = 0
        mov     ebx, esi
        and     ebx, 1      ; ebx = edx % 2 
        shr     esi, 1
        add     eax, ebx
        inc     ecx
        test    esi, esi
        jnz     LOOOP           ;while (ecx != 32)
    sub     ecx, eax
    cmp     ecx, dword[K]
    jz      ANS
    jmp     FOR

    ANS:
        inc edx
        jmp FOR
    EXIT:
        PRINT_DEC 4, edx
        xor eax, eax    
    ret