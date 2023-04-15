%include "io.inc"

section .bss
    year    resd 1
    day     resd 1

section .text
    global CMAIN
CMAIN:
    GET_UDEC 4, year
    GET_UDEC 4, day
    mov     eax, 0
    mov     eax, dword[year]
    dec     eax
    mov     ebx, 0
    mov     ebx, eax; ; ebx = eax = year - 1
    shr     eax, 1; eax = eax // 2
    and     ebx, 1; ebx = ebx % 2
    imul    eax, eax, 83; 84 = 42 + 41
    imul    ebx, ebx, 41
    mov     ecx, 0
    mov     ecx, dword[day]
    add     ecx, eax
    add     ecx, ebx; ecx = 83eax+41ebx+day
    PRINT_UDEC 4, ecx
    xor eax, eax
    ret