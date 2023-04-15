%include "io.inc"

MOD equ 2011

section .text

FUNC#:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, dword[ebp + 8]     ;edx#ecx
    mov     ecx, dword[ebp + 12]
    push    edi
    mov     edi, dword[ebp + 16]    ;edi = k
    mov     eax, edi              ;в eax будем накапливать степень k, пока не станет больше ecx
    while:
        cmp    eax, ecx        
        ja      break
        mul     edi        
        jmp     while
    break:
    mul     ebx
    add     eax, ecx            ;func# return ebx#ecx = ebx*степень(хранится в eax)+ecx
    mov     ecx, MOD
    cdq
    div     ecx                 ;mod 2011
    mov     eax, edx
    pop     edi
    pop     ebx
    leave
    ret
    
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, ebx     ;k
    GET_UDEC 4, edi     ;n
    GET_UDEC 4, eax     ;a
    xor     edx, edx
    mov     esi, MOD
    div     esi
    mov     ecx, edx    ;ecx = edx = a0 % 2011
    xor     esi, esi    ;counter
    .loop:
        cmp     esi, edi
        je      .ex
        push    ebx      ;push k
        push    ecx      ;push то, что приписываем
        push    edx      ;push то, к чему приписываем
        call    FUNC#
        pop     ecx     ;теперь будем приписывать ... то, к чему приписывали раньше
        mov     edx, eax ;...к результату
        add     esp, 8
        inc     esi
        jmp     .loop
    .ex:
    PRINT_UDEC 4, eax
    xor eax, eax
    ret