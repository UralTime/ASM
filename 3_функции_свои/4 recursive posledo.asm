%include "io.inc"

section .text
foo:
    push    ebp
    mov     ebp, esp        ; читаем по два нечёт-чёт
    GET_DEC 4, eax
    test    eax, eax
    jz      .R      ; ноль, то есть конец последовательности
    PRINT_DEC 4, eax
    PRINT_CHAR ' '      ; нечётные печатаем сразу
    GET_DEC 4, eax
    test    eax, eax
    jz      .R      ; ноль, то есть конец последовательности
    push    eax     ;сохраняем чётное, сделаем разворот
    call    foo
    .R: 
        add     esp, 8
        pop     eax
        test    eax, eax
        jz      .OFF    ; до метки выхода
        PRINT_DEC 4, eax ; печатаем чётные в обратном порядке
        PRINT_CHAR ' '
        jmp     .R
        leave
        .OFF: 
                ret

    global CMAIN
CMAIN:
    push    0       ; метка выхода из печати чётных
    call    foo
    xor     eax, eax
    ret