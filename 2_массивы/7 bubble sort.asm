%include "io.inc"

section .bss
    n resd 1
    a resd 10000

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_DEC 4, n
    xor     esi, esi    ; esi = i
    xor     ecx, ecx    ; ecx Для print
    READ:         
        GET_DEC 4, edx
        mov     dword[a + esi * 4], edx
        inc     esi
        cmp     esi, dword[n]  ; ecx < n => считываем ещё
        jl     READ
    xor     esi, esi    
    FORI:
        inc     esi     ; for int i = 1
        cmp     esi, dword[n]  ; i < n
        jz      PRINT 
    mov     edi, dword[n]   ; edi = j
    FORJ:
        dec     edi     ; for j = n - 1
        cmp     edi, esi    ; j >= i
        jl      FORI
        mov     ebx, dword[a + edi * 4]
        cmp     dword[a + edi * 4 - 4], ebx
        jg      SWAP
        jmp     FORJ
    SWAP:
        mov     eax, dword[a + edi * 4 - 4]     ; t = a[j-1]
        mov     ebx, dword[a + edi * 4]
        mov     dword[a + edi * 4 - 4], ebx     ; a[j-1] = a[j]
        mov     dword[a + edi * 4], eax         ;a[j] = a[j-1]
        jmp     FORJ
    PRINT:
        PRINT_DEC 4, a + ecx * 4
        PRINT_CHAR ' '
        inc     ecx
        cmp     ecx, dword[n]
        jl      PRINT
    xor eax, eax
    ret