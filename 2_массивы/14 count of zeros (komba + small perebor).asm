%include "io.inc"

section .bss
    N resd 1
    K resd 1
    
section .data
    ans dd 0

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, N
    GET_UDEC 4, K
    mov     ebx, 1
    xor     ecx, ecx
    FIND:
        shl     ebx, 1
        inc     ecx
        cmp     ebx, dword[N]
        jng      FIND
    shr     ebx, 1
    dec     ecx
    cmp     ecx, dword[K]
    jl      EXIT
    jz      break
    mov     edi, dword[K]
    mov     eax, 1
    inc     dword[ans]
    FORIK:
        inc     edi
        cmp     edi, ecx
        jnl     break
        mul     edi
        mov     esi, edi
        sub     esi, dword[K]
        div     esi
        add     dword[ans], eax 
        jmp FORIK
    break:
    mov     edi, ebx    ;edi === i  from 2^M to N
    dec     edi
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
        jz      INC_ANS
        jmp     FOR
        
    INC_ANS:
        inc dword[ans]
        jmp FOR
    EXIT:
        PRINT_DEC 4, ans
        xor eax, eax    
        ret