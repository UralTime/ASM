%include "io.inc"

MOD equ 2011

section .bss
    k resd 1

section .text

FUNC@:
    push    ebp
    mov     ebp, esp
    mov     eax, dword[ebp + 8]
    mul     eax
    mov     ecx, 0              ;c = 0
    push    edi
    mov     edi, dword[ebp + 12]    ;edi = k
    while:
        test    eax, eax        ;while ( a!=0 ) 
        jz      break
        cdq
        div     edi            ;d = a%k   a = a/k
        imul    ecx, edi
        add     ecx, edx        ;c = c*k + d
        jmp     while
    break:
    mov     eax, ecx
    mov     ecx, MOD
    cdq
    div     ecx                 ;mod 2011
    mov     eax, edx
    pop     edi
    leave
    ret
    
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, k
    GET_UDEC 4, edi     ;n
    GET_UDEC 4, eax     ;a
    cdq
    mov     ebx, MOD
    div     ebx
    mov     eax, edx    ;eax=a%2011  
    xor     esi, esi    ;counter
    mov     ebx, dword[k]
    .loop:
        cmp     esi, edi
        je      .ex
        push    ebx      ;push k
        push    eax      ;push a====curres
        call    FUNC@
        add     esp, 8
        inc     esi
        jmp     .loop
    .ex:
    PRINT_UDEC 4, eax
    xor eax, eax
    ret