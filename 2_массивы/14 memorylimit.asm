%include "io.inc"

SIZE equ 4194304	

section .bss
    a resw SIZE
    
section .text
    global CMAIN
    
CMAIN:
    GET_UDEC 4, eax
    GET_UDEC 4, ebx
    mov     eax, 1
    PRINT_DEC 4, eax
    xor eax, eax
    ret