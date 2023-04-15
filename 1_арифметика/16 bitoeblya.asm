%include "io.inc"

section .bss
    a1, a2, a3, a4, b1, b2, detA, x1, y1, x2, y2 resd 11

section .text
    global CMAIN
CMAIN:    
    mov     ebp, esp; for correct debugging
    GET_UDEC 4, a1
    GET_UDEC 4, a2
    GET_UDEC 4, a3
    GET_UDEC 4, a4
    GET_UDEC 4, b1
    GET_UDEC 4, b2; считали данные
    mov     ecx, DWORD[a4]
    mov     eax, DWORD[a1]
    and     ecx, eax
    mov     ebx, DWORD[a2]
    mov     eax, DWORD[a3]
    and     eax, ebx
    xor     eax, ecx
    mov     DWORD[detA], eax; detA = a1&a4 ^ a2&a3
    mov     ecx, DWORD[b1]
    mov     eax, DWORD[a4]
    and     ecx, eax
    mov     edx, DWORD[b2]
    mov     eax, DWORD[a2]
    and     eax, edx
    xor     eax, ecx
    mov     DWORD[x1], eax; x1 = b1&a4 ^ b2&a2
    mov     ecx, DWORD[b2]
    mov     eax, DWORD[a1]
    and     ecx, eax
    mov     edx, DWORD[b1]
    mov     eax, DWORD[a3]
    and     eax, edx
    xor     eax, ecx
    mov     DWORD[y1], eax; y1 = b2&a1 ^ b1&a3
    mov     ecx, DWORD[a1]
    mov     eax, DWORD[b1]
    and     ecx, eax
    mov     edx, DWORD[a3]
    mov     eax, DWORD[b2]
    and     eax, edx
    xor     ecx, eax
    mov     edx, DWORD[a1]
    mov     eax, DWORD[a2]
    and     edx, eax
    mov     eax, DWORD[b1]
    and     eax, edx
    xor     ecx, eax
    mov     edx, DWORD[a1]
    mov     eax, DWORD[a3]
    and     edx, eax
    mov     eax, DWORD[b2]
    and     eax, edx
    xor     eax, ecx
    mov     DWORD[x2], eax; x2 = a1&b1 ^ a3&b2 ^ a1&a2&b1 ^ a1&a3&b2
    mov     ecx, DWORD[a2]
    mov     eax, DWORD[b1]
    and     ecx, eax
    mov     edx, DWORD[a4]
    mov     eax, DWORD[b2]
    and     eax, edx
    xor     ecx, eax
    mov     edx, DWORD[a3]
    mov     eax, DWORD[a4]
    and     edx, eax
    mov     eax, DWORD[b2]
    and     eax, edx
    xor     ecx, eax
    mov     edx, DWORD[a2]
    mov     eax, DWORD[a4]
    and     edx, eax
    mov     eax, DWORD[b1]
    and     eax, edx
    xor     ecx, eax
    mov     edx, DWORD[a1]
    mov     eax, DWORD[a2]
    and     edx, eax
    mov     eax, DWORD[a3]
    and     edx, eax
    mov     eax, DWORD[a4]
    and     edx, eax
    mov     eax, DWORD[b1]
    and     eax, edx
    xor     eax, ecx
    mov     DWORD[y2], eax; y2 = a2&b1 ^ a4&b2 ^ a3&a4&b2 ^ a2&a4&b1 ^  a1&a2&a3&a4&b1
    mov     eax, DWORD[x1]
    mov     ebx, DWORD[y1]
    mov     ecx, DWORD[detA]
    and     eax, ecx; x1&detA
    and     ebx, ecx; y1&detA
    not     ecx
    mov     edx, DWORD[x2]
    and     edx, ecx
    xor     eax, edx; x1&detA ^ x2&(~detA)
    mov     edx, DWORD[y2]
    and     edx, ecx
    xor     ebx, edx; y1&detA ^ y2&(~detA)
    PRINT_UDEC 4, eax
    PRINT_CHAR ' '
    PRINT_UDEC 4, ebx
    xor eax, eax
    ret