%include "io.inc"
CEXTERN malloc
CEXTERN realloc
CEXTERN fopen
CEXTERN fclose
CEXTERN fread
CEXTERN fwrite
CEXTERN free

section .data
    LC0 dd "rb", 0
    LC1 dd "input.bin", 0
    LC2 dd "wb", 0
    LC3 dd "output.bin", 0

section .text
cmp:
        push    ebp
        mov     ebp, esp
        mov     eax, [ebp+16]
        mov     eax, [eax]
        test    eax, eax
        jne     .L2
        mov     eax, 0
        jmp     .L3
.L2:
        mov     eax, [ebp+16]
        mov     eax, [eax]
        cmp     eax, 1
        jne     .L4
        mov     eax, [ebp+8]
        cmp     eax, [ebp+12]
        setle   al
        movzx   eax, al
        jmp     .L3
.L4:
        mov     eax, [ebp+16]
        mov     eax, [eax]
        cmp     eax, -1
        jne     .L5
        mov     eax, [ebp+8]
        cmp     eax, [ebp+12]
        setge   al
        movzx   eax, al
        jmp     .L3
.L5:
        mov     eax, [ebp+8]
        cmp     eax, [ebp+12]
        jge     .L6
        mov     eax, [ebp+16]
        mov     dword[eax], 1
.L6:
        mov     eax, [ebp+8]
        cmp     eax, [ebp+12]
        jle     .L7
        mov     eax, [ebp+16]
        mov     dword[eax], -1
.L7:
        mov     eax, 1
.L3:
        pop     ebp
        ret
        
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
        lea     ecx, [esp+4]
        and     esp, -16
        push    DWORD[ecx-4]
        push    ebp
        mov     ebp, esp
        push    ecx
        sub     esp, 36
        sub     esp, 8
        push    LC0
        push    LC1
        call    fopen
        add     esp, 16
        mov     DWORD[ebp-28], eax
        sub     esp, 8
        push    LC2
        push    LC3
        call    fopen
        add     esp, 16
        mov     DWORD[ebp-32], eax
        mov     DWORD[ebp-36], 2
        mov     DWORD[ebp-12], 128
        mov     DWORD[ebp-16], 0
        mov     eax, DWORD[ebp-12]
        sal     eax, 2
        sub     esp, 12
        push    eax
        call    malloc
        add     esp, 16
        mov     DWORD[ebp-20], eax
        jmp     .L9
.L10:
        add     DWORD[ebp-16], 1
        mov     eax, [ebp-16]
        add     eax, 1
        cmp     DWORD[ebp-12], eax
        jne     .L9
        mov     edi, [ebp-12]
        sal     edi, 1
        mov     dword[ebp-12], edi
        mov     eax, DWORD[ebp-12]
        sal     eax, 2
        sub     esp, 8
        push    eax
        push    DWORD[ebp-20]
        call    realloc
        add     esp, 16
        mov     DWORD[ebp-20], eax
.L9:
        mov     eax, [ebp-16]
        add     eax, 1
        lea     edx, [0+eax*4]
        mov     eax, [ebp-20]
        add     eax, edx
        push    DWORD[ebp-28]
        push    1
        push    4
        push    eax
        call    fread
        add     esp, 16
        cmp     eax, 1
        je      .L10
        mov     DWORD[ebp-24], 1
        jmp     .L11
.L16:
        mov     eax, [ebp-36]
        test    eax, eax
        je      .L19
        mov     eax, [ebp-24]
        lea     edx, [0+eax*8]
        mov     eax, [ebp-20]
        add     eax, edx
        mov     edx, [eax]
        mov     eax, [ebp-24]
        lea     ecx, [0+eax*4]
        mov     eax, [ebp-20]
        add     eax, ecx
        mov     eax, [eax]
        sub     esp, 4
        lea     ecx, [ebp-36]
        push    ecx
        push    edx
        push    eax
        call    cmp
        add     esp, 16
        test    eax, eax
        jne     .L14
        mov     DWORD[ebp-36], 0
.L14:
        mov     eax, [ebp-24]
        add     eax, eax
        add     eax, 1
        cmp     DWORD[ebp-16], eax
        jb      .L15
        mov     eax, [ebp-24]
        sal     eax, 3
        lea     edx, [eax+4]
        mov     eax, [ebp-20]
        add     eax, edx
        mov     edx, [eax]
        mov     eax, [ebp-24]
        lea     ecx, [0+eax*4]
        mov     eax, [ebp-20]
        add     eax, ecx
        mov     eax, [eax]
        sub     esp, 4
        lea     ecx, [ebp-36]
        push    ecx
        push    edx
        push    eax
        call    cmp
        add     esp, 16
        test    eax, eax
        jne     .L15
        mov     DWORD[ebp-36], 0
.L15:
        add     DWORD[ebp-24], 1
.L11:
        mov     eax, DWORD[ebp-24]
        add     eax, eax
        cmp     DWORD[ebp-16], eax
        jnb     .L16
        jmp     .L13
.L19:
        nop
.L13:
        mov     eax, DWORD[ebp-36]
        cmp     eax, 2
        jne     .L17
        mov     DWORD[ebp-36], 1
.L17:
        push    DWORD[ebp-32]
        push    1
        push    4
        lea     eax, [ebp-36]
        push    eax
        call    fwrite
        add     esp, 16
        sub     esp, 12
        push    DWORD[ebp-20]
        call    free
        add     esp, 16
        sub     esp, 12
        push    DWORD[ebp-28]
        call    fclose
        add     esp, 16
        sub     esp, 12
        push    DWORD[ebp-32]
        call    fclose
        add     esp, 16
        mov     eax, 0
        mov     ecx, DWORD[ebp-4]
        leave
        lea     esp, [ecx-4]
        ret