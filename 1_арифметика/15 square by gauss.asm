%include "io.inc"

section .bss
    x1 resd 1
    x2 resd 1
    x3 resd 1
    y1 resd 1
    y2 resd 1
    y3 resd 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, x1
    GET_UDEC 4, y1
    GET_UDEC 4, x2
    GET_UDEC 4, y2
    GET_UDEC 4, x3
    GET_UDEC 4, y3
    ; 2S = detA = (x2-x1)(y3-y1) - (x3-x1)(y2-y1) = x1y2+x2y3+x3y1-x2y1-x3y2-x1y3  
    mov     eax, dword[x1]
    imul    eax, dword[y2]
    mov     ebx, dword[x2]
    imul    ebx, dword[y3]
    mov     ecx, dword[x3]
    imul    ecx, dword[y1]
    add     eax, ebx
    add     eax, ecx;   eax = x1y2 + x2y3 + x3y1
    mov     edx, dword[y1]
    imul    edx, dword[x2]
    mov     ebx, dword[y2]
    imul    ebx, dword[x3]
    mov     ecx, dword[y3]
    imul    ecx, dword[x1]
    add     edx, ebx
    add     edx, ecx;   edx = -x2y1 - x3y2 - x1y3
    sub     eax, edx;
    mov     edx, eax;
    sar     edx, 31
    or      edx, 1;      знаковый бит=0 - получили ffff, иначе получили 0000, нужно сделать 0001 и умножить
    mul     edx;        edx:eax = |eax+edx|
    mov     ecx, 2
    cdq
    idiv     ecx;        eax /= 2 
    PRINT_UDEC 4, eax
    PRINT_CHAR '.'
    imul    dx, dx, 5;      мб остаток 0.5 или 0.0
    PRINT_UDEC 1, dl
    xor eax, eax
    ret