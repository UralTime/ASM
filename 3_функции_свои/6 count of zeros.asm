%include "io.inc"

section .bss
    k resd 1
    n resd 1
    a resd 1001

section .text
CHECK:
    push ebp
    mov ebp, esp
    xor     eax, eax        ;eax === ans
    xor     ecx, ecx
    .LOOOP:                      ;ecx = 0 - число разрядов
        mov     edx, dword[ebp + 8]
        and     edx, 1      ;  % 2 
        shr     dword[ebp + 8], 1
        add     eax, edx
        inc     ecx
        cmp     dword[ebp + 8], 0
        jnz     .LOOOP           ;/= 2 while [ebp+8] != 0
    sub     ecx, eax        ; теперь в ecx кол-во нулей (разряды минус единицы)
    xor     eax, eax
    mov     edx, 1
    cmp     ecx, dword[k]
    cmovz   eax, edx
    leave
    ret

    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, n
    mov     esi, 0
    mov     edi, dword[n]
    test    edi, edi
    jz      .ex
    .L:
        GET_UDEC 4, eax
        mov     dword[a + 4 * esi], eax ;считываем
        inc     esi
        cmp     esi, dword[n]
        jb      .L
    .ex: 
    GET_UDEC 4, ebx
    mov     dword[k], ebx
    xor     ebx, ebx    ;ebx == ans
    xor     esi, esi
    .L1:
        cmp    esi, dword[n]     ;for int j=0; j < n; j++
        je     .break 
        push   dword[a + esi * 4] 
        call   CHECK
        add    ebx, eax     ;это число a[i] подходит
        add    esp, 4
        inc    esi
        jmp    .L1 
    .break:
    PRINT_UDEC 4, ebx
    xor     eax, eax
    ret
    