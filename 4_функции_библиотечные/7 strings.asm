%include "io.inc"
CEXTERN strcmp

section .bss
    n resd 1
    s resd 5000

section .rodata
    d dd "%d", 0
    format dd "%s", 0
    
section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    sub     esp, 4
    push    n
    push    d          ;стэк выровнен по 16
    call  scanf
    add     esp, 12
    mov     esi, 0 
    mov     ebx, 0      ;ebx   число строчек, которые повторятся
    FORI:
        sub     esp, 4
        imul    ecx, esi, 10
        lea     ecx, [s + ecx * 4]
        push    ecx
        push    format          ;стэк выровнен по 16
        call  scanf
        add     esp, 12
        mov     edi, 0 
        FORJ:
            cmp     edi, esi
            jnl     break
            sub     esp, 4
            imul    ecx, esi, 10
            lea     ecx, [s + ecx * 4]
            push    ecx
            imul    ecx, edi, 10
            lea     ecx, [s + ecx * 4]
            push    ecx
            call    strcmp          ;сравниваем строку со всеми предыдущими
            add     esp, 12
            mov     ecx, 0
            mov     edx, 1
            cmp     eax, 0
            cmove   ecx, edx          ; если совпали +1 (строчка неуникальная)
            add     ebx, ecx
            cmp     eax, 0
            je      break
            inc     edi
            jmp     FORJ
        break:
        inc     esi
        cmp     esi, dword[n]
        jl      FORI
    mov     eax, dword[n]
    sub     eax, ebx
    sub     esp, 4
    push    eax
    push    d      ;стэк выровнен по 16
    call  printf 
    add     esp, 12
    xor eax, eax
    ret