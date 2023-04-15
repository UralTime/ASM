%include "io.inc"

section .bss
    c resb 1
    d resb 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_CHAR c
    GET_UDEC 1, d
    mov     cl, byte[c]
    neg     cl
    add     cl, 72;     72 = 'H', cl = 'H' - c
    mov     bl, byte[d]
    neg     bl
    add     bl, 8;      bl = 8-d
    mov     al, cl
    and     al, 1;      al = cl % 2
    mov     dl, bl;     dl = bl
    shr     cl, 1
    shr     bl, 1
    mul     bl      
    mov     bl, al;   bl = (dl/2) * (cl%2)
    mov     al, dl
    mul     cl
    add     bl, al;     bl += dl * (cl/2) 
    PRINT_UDEC 1, bl
    xor eax, eax
    ret