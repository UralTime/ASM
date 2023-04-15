%include "io.inc"

section .bss
    N resd 1
    K resd 1
    ans resd 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, N
    GET_UDEC 4, K
    mov     edi, dword[K]
    mov     esi, dword[N]
    mov     eax, 0
    mov     edx, 1      ;edx===2^m
    xor     ecx, ecx    ; ecx===m   !
    FINDDD:
        shl     edx, 1
        inc     ecx
        cmp     edx, esi
        jng      FINDDD
    shr     edx, 1
    dec     ecx
    sub     esi, edx    ;esi = l = 2^q+w   !
    mov     edx, 1      ;edx===2^q
    xor     ebx, ebx    ; ebx===q
    test    esi, esi
    jz      XX
    FINDlll:
        shl     edx, 1
        inc     ebx
        cmp     edx, esi
        jng      FINDlll
    XX:
    shr     edx, 1
    neg     ebx
    add     ebx, ecx        ;ebx = r   !
    inc     edi
    cmp     ecx, edi
    jl      .LL      ;m<k => C_m_k = 0
    inc     eax
    mov     edx, edi    ; edx === i from k to m
    .COMBAA:
        inc     edx
        cmp     edx, ecx
        jnl     .LL
        imul    eax, edx     ; * i
        mov     ebp, edx  
        sub     ebp, edi
        div     ebp     ; / (i-k)
        jmp     .COMBAA
    .LL:
    sub     edi, ebx
    dec     edi
    jmp     foo
    EXIT:
        mov dword[ans], eax
        PRINT_DEC 4, ans
    xor eax, eax    
    ret
    
foo:
    ;g(2^m+l, k) = C_m_k + / 1 при k=m, 0 при k<m или k<r, g(l,k-r) иначе/
    ;esi ==== n = 2^m+l
   ; edi === k   !
    test    esi, esi
    jz      EXIT
    mov     edx, 1      ;edx===2^m
    xor     ecx, ecx    ; ecx===m   !
    FIND:
        shl     edx, 1
        inc     ecx
        cmp     edx, esi
        jng      FIND
    shr     edx, 1
    dec     ecx
    sub     esi, edx    ;esi = l = 2^q+w   !
    mov     edx, 1      ;edx===2^q
    xor     ebx, ebx    ; ebx===q
    test    esi, esi
    jz      X
    FINDl:
        shl     edx, 1
        inc     ebx
        cmp     edx, esi
        jng      FINDl
    X:
    shr     edx, 1
    neg     ebx
    add     ebx, ecx        ;ebx = r   !
    mov     dword[ans], 1
    mov     edx, 0
    cmp     edi, ecx
    cmovz   edx, dword[ans]  ; if k==m ans = C_m_k +  1
    add     eax, edx
    cmp     ecx, edi
    jl      .L      ;m<k => C_m_k = 0
    mov     dword[ans], eax
    mov     eax, 1
    mov     edx, edi    ; edx === i from k to m
    test    edx, edx
    jz      .L
    .COMBA:
        inc     edx
        cmp     edx, ecx
        jnl     .L
        imul    eax, edx     ; * i
        mov     ebp, edx            ;ebp warning
        sub     ebp, edi
        div     ebp     ; / (i-k)
        jmp     .COMBA
    .L:
        add     eax, dword[ans]
        cmp     edi, ecx        ;if k<m or k<r then +0
        jl      EXIT 
        cmp     edi, ebx
        jl      EXIT
        sub     edi, ebx
        jmp     foo