%include "io.inc"

SIZE equ 2000000000

section .bss
    N resd 1
    K resd 1
    a resw SIZE
    
section .data
    ans dd 0

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov     esi, 0
    GET_UDEC 4, N
    GET_UDEC 4, K
    cmp     dword[K], 32
    ja      PRINT
    xor     ebx, ebx
    mov     word[a + 2], bx
    mov     word[a + 4 ], 1
    inc     esi
    FORI:
        imul    esi, esi, 2     ; for int i = 1 i*=2 
        cmp     esi, dword[N]  ; esi===i < N
        ja      EXIT
        mov     eax, esi
        imul    eax, eax, 2
        mov     edi, 0   ; edi === j
        cmp     eax, dword[N]
        ja      EXIT
    FORJ:
        mov     ecx, edi
        add     ecx, esi
        mov     bx, word[a + ecx * 2]   ; a[2i+j]=a[i+j]+1
        inc     bx
        sub     ecx, esi
        add     ecx, eax
        cmp     ecx, SIZE
        jnb      EXCEPTION1
        mov     word[a + ecx * 2], bx
        inc     edi     
        cmp     edi, esi
        jl      FORJ
    L:
    mov     edi, 0
    mov     eax, esi
    imul    eax, eax, 3
    cmp     eax, dword[N]
    ja      EXIT
    FORJ2:
        mov     ecx, edi
        add     ecx, esi
        mov     bx, word[a + ecx * 2]    ; a[3i+j]=a[i+j]
        sub     ecx, esi
        add     ecx, eax
        cmp     ecx, SIZE
        jnb      EXCEPTION2
        mov     word[a + ecx * 2], bx
        inc     edi     
        cmp     edi, esi
        jl      FORJ2
    jmp     FORI
    EXIT:
    mov     esi, 0
    for:
        inc     esi
        cmp     esi, dword[N]
        jg      PRINT
        mov     edi, dword[K]
        xor     ebx, ebx
        mov     eax, 1
        cmp     esi, SIZE
        jnb      PRINT
        cmp     word[a + esi * 2], di   ; if (a[i]==k)
        cmovz   ebx, eax
        add     dword[ans], ebx     ; then ans++
        jmp     for
    PRINT:
        mov     eax, dword[ans]
        PRINT_DEC 4, eax
        jmp RET0
    EXCEPTION1:
        xor     ecx, ecx
        add     cx, bx
        mov     ebx, 0
        mov     edx, 1
        cmp     ecx, dword[K];  if ecx(a[indexarray]) == k
        cmovz   ebx, edx
        add     dword[ans], ebx     ; then ans++
        inc     edi     
        cmp     edi, esi
        jl      FORJ
        jmp     L
    EXCEPTION2:
        xor     ecx, ecx
        add     cx, bx
        mov     ebx, 0
        mov     edx, 1
        cmp     ecx, dword[K];  if ecx(a[indexarray]) == k
        cmovz   ebx, edx
        add     dword[ans], ebx     ; then ans++
        inc     edi     
        cmp     edi, esi
        jl      FORJ2
        jmp     FORI
    RET0:
    xor eax, eax
    ret