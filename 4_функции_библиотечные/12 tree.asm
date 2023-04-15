%include "io.inc"
CEXTERN calloc
CEXTERN free
CEXTERN fread
CEXTERN fclose
CEXTERN fopen
section .data
LC1 dd  "rb", 0
LC2 dd "input.bin", 0
LC0 dd "%d", 0

section .text
visit:
        push    ebp
        mov     ebp, esp
        sub     esp, 8
        cmp     DWORD  [ebp+8], 0
        je      .L3
        mov     eax, DWORD  [ebp+8]
        mov     eax, DWORD  [eax+4]
        sub     esp, 12
        push    eax
        call    visit
        add     esp, 16
        mov     eax, DWORD  [ebp+8]
        mov     eax, DWORD  [eax]
        sub     esp, 8
        push    eax
        push    LC0
        call    printf
        add     esp, 16
        mov     eax, DWORD  [ebp+8]
        mov     eax, DWORD  [eax+8]
        sub     esp, 12
        push    eax
        call    visit
        add     esp, 16
.L3:
        nop
        leave
        ret
free_tree:
        push    ebp
        mov     ebp, esp
        sub     esp, 8
        cmp     DWORD  [ebp+8], 0
        je      .L6
        mov     eax, DWORD  [ebp+8]
        mov     eax, DWORD  [eax+4]
        sub     esp, 12
        push    eax
        call    free_tree
        add     esp, 16
        mov     eax, DWORD  [ebp+8]
        mov     eax, DWORD  [eax+8]
        sub     esp, 12
        push    eax
        call    free_tree
        add     esp, 16
        sub     esp, 12
        push    DWORD  [ebp+8]
        call    free
        add     esp, 16
.L6:
        nop
        leave
        ret

GLOBAL CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
  
        lea     ecx, [esp+4]
        and     esp, -16
        push    DWORD  [ecx-4]
        push    ebp
        mov     ebp, esp
        push    ebx
        push    ecx
        sub     esp, 48
        sub     esp, 8
        push    LC1
        push    LC2
        call    fopen
        add     esp, 16
        mov     DWORD  [ebp-40], eax
        sub     esp, 8
        push    4
        push    10000
        call    calloc
        add     esp, 16
        mov     DWORD  [ebp-44], eax
        sub     esp, 8
        push    4
        push    10000
        call    calloc
        add     esp, 16
        mov     DWORD  [ebp-48], eax
        mov     DWORD  [ebp-12], 0
        jmp     .L8
.L9:
        mov     eax, DWORD  [ebp-12]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        lea     ebx, [edx+eax]
        sub     esp, 8
        push    12
        push    1
        call    calloc
        add     esp, 16
        mov     DWORD  [ebx], eax
        add     DWORD  [ebp-12], 1
.L8:
        cmp     DWORD  [ebp-12], 9999
        jle     .L9
        mov     DWORD  [ebp-16], 0
        jmp     .L10
.L13:        
        mov     eax, DWORD  [ebp-16]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     eax, edx
        mov     eax, DWORD  [eax]
        mov     edx, DWORD  [ebp-52]
        mov     DWORD  [eax], edx
        lea     eax, [ebp - 20]
        push    DWORD  [ebp-40]
        push    1
        push    4
        push    eax
        call    fread
        add     esp, 16
        lea     eax, [ebp - 24]
        push    DWORD  [ebp-40]
        push    1
        push    4
        push    eax
        call    fread
        add     esp, 16
        cmp     DWORD [ebp-20], -1
        je      .L11
        mov     ecx, DWORD  [ebp-20]
        mov     edx, 715827883
        mov     eax, ecx
        imul    edx
        mov     eax, edx
        sar     eax, 1
        sar     ecx, 31
        mov     edx, ecx
        sub     eax, edx
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     edx, eax
        mov     eax, DWORD  [ebp-16]
        lea     ecx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     eax, ecx
        mov     eax, DWORD  [eax]
        mov     edx, DWORD  [edx]
        mov     DWORD  [eax+4], edx
        mov     eax, DWORD  [ebp-20]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-48]
        add     eax, edx
        mov     DWORD  [eax], 1
.L11:
        cmp     DWORD  [ebp-24], -1
        je      .L12
        mov     ecx, DWORD  [ebp-24]
        mov     edx, 715827883
        mov     eax, ecx
        imul    edx
        mov     eax, edx
        sar     eax, 1
        sar     ecx, 31
        mov     edx, ecx
        sub     eax, edx
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     edx, eax
        mov     eax, DWORD  [ebp-16]
        lea     ecx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     eax, ecx
        mov     eax, DWORD  [eax]
        mov     edx, DWORD  [edx]
        mov     DWORD  [eax+8], edx
        mov     eax, DWORD  [ebp-24]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-48]
        add     eax, edx
        mov     DWORD  [eax], 1
.L12:
        add     DWORD  [ebp-16], 1
.L10:
        push    DWORD  [ebp-40]
        push    1
        push    4
        lea     eax, [ebp - 52]
        push    eax
        call    fread
        add     esp, 16
        cmp     eax, 0
        jne     .L13
        mov     eax, DWORD  [ebp-44]
        mov     eax, DWORD  [eax]
        mov     DWORD  [ebp-28], eax
        mov     DWORD  [ebp-32], 0
        jmp     .L14
.L16:
        mov     eax, DWORD  [ebp-32]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-48]
        add     eax, edx
        mov     eax, DWORD  [eax]
        test    eax, eax
        jne     .L15
        mov     eax, DWORD  [ebp-32]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     eax, edx
        mov     eax, DWORD  [eax]
        mov     DWORD [ebp-28], eax
.L15:
        add     DWORD  [ebp-32], 1
.L14:
        mov     eax, DWORD  [ebp-32]
        cmp     eax, DWORD  [ebp-16]
        jl      .L16
        sub     esp, 12
        push    DWORD  [ebp-28]
        call    visit
        add     esp, 16
        sub     esp, 12
        push    DWORD  [ebp-28]
        call    free_tree
        add     esp, 16
        sub     esp, 12
        push    DWORD  [ebp-48]
        call    free
        add     esp, 16
        mov     DWORD  [ebp-36], 0
        jmp     .L17
.L18:
        mov     eax, DWORD  [ebp-36]
        lea     edx, [0+eax*4]
        mov     eax, DWORD  [ebp-44]
        add     eax, edx
        mov     eax, DWORD  [eax]
        sub     esp, 12
        push    eax
        call    free
        add     esp, 16
        add     DWORD  [ebp-36], 1
.L17:
        cmp     DWORD [ebp-36], 9999
        jle     .L18
        sub     esp, 12
        push    DWORD [ebp-44]
        call    free
        add     esp, 16
        sub     esp, 12
        push    DWORD  [ebp-40]
        call    fclose
        add     esp, 16
        mov     eax, 0
        lea     esp, [ebp-8]
        pop     ecx
        pop     ebx
        pop     ebp
        lea     esp, [ecx-4]
        ret

