%include "io.inc"

section .text
foo:
    push    ebp
    mov     ebp, esp
    GET_UDEC 4, eax
    test    eax, eax
    jz      .R
    PRINT_UDEC 4, eax
    PRINT_CHAR ' '
    GET_UDEC 4, eax
    test    eax, eax
    jz      .R
    push    eax
    call    foo
    .R: 
        add     esp, 8
        pop     eax
        test    eax, eax
        jz      .OFF
        PRINT_UDEC 4, eax
        PRINT_CHAR ' '
        jmp     .R
        leave
        .OFF: 
                ret

    global CMAIN
CMAIN:
    mov     ebp, esp; for correct debugging
    push    0
    call    foo
    xor     eax, eax
    ret