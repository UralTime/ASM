%include "io.inc"

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_CHAR al
    GET_UDEC 1, ah
    GET_CHAR bl
    GET_CHAR bl
    GET_UDEC 1, bh
    sub     al, bl
    sub     ah, bh
    mov     cl, al;     cl = al - bl
    mov     ch, ah;     ch = ah - bh
    sar     al, 7
    or      al, 1;      знаковый бит=0 - получили ff, иначе получили 00, нужно сделать 01
    mul     cl
    mov     bl, al;     bl = |cl|
    mov     al, ch  
    sar     al, 7
    or      al, 1
    mul     ch;         al = |ch| 
    add     al, bl
    PRINT_UDEC 1, al
    xor eax, eax
    ret