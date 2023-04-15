%include "io.inc"
CEXTERN malloc
CEXTERN free
CEXTERN fscanf
CEXTERN fclose
CEXTERN fopen
CEXTERN fprintf

section .rodata
    printfnumber dd "%d ", 0
    formatread dd "r", 0
    nameinput dd "input.txt", 0
    formatwrite dd "w", 0
    nameoutput dd "output.txt", 0
    twonumbers dd "%d %d", 0
    
section .bss
    inn     resd 1  
    outt    resd 1
    M       resd 1
    N       resd 1
    p       resd 1
    head    resd 1
    
section .text
create_list:
        push    ebp
        mov     ebp, esp
        sub     esp, 20
        push    12
        call  malloc    ;по 16
        add     esp, 16
        mov     DWORD  [head], eax      ;List *head = malloc(sizeof(List))
        mov     DWORD  [p], eax    ;list *p = head
        mov     DWORD [ebp - 16], 1
        jmp     .L
    .fori:
        mov     eax,  [p]
        mov     edx,  [ebp-16]
        mov     DWORD [eax], edx    ;p->data = i
        mov     eax,  [ebp-16]
        cmp     eax,  [ebp+8]       ;if i==n
        jne     .else
        mov     eax, [p]           
        mov     edx,  [head]
        mov     DWORD [eax+4], edx  ;p->next = head
        mov     eax, [head]
        mov     edx, [p]
        mov     DWORD [eax+8], edx  ;head->prev = p
        jmp     .i
    .else:
        sub     esp, 12
        push    12
        call    malloc
        add     esp, 16
        mov     edx, eax
        mov     eax, DWORD [p]
        mov     DWORD [eax+4], edx      
        mov     eax,  [p]
        mov     eax, [eax+4]
        mov     edx,  [p]
        mov     DWORD [eax+8], edx      ;p->next->prev = p
        mov     eax, [p]
        mov     eax,  [eax+4]
        mov     DWORD [p], eax          ;p = p->next
    .i:
        inc     DWORD [ebp - 16]
    .L:
        mov     eax,  [ebp-16]
        cmp     eax,  [ebp+8]
        jle     .fori
        mov     eax, [head]
        leave
        ret
        
print_list:
        push    ebp
        mov     ebp, esp
        sub     esp, 8
        mov     eax, DWORD [ebp+8]      ;в ebp+8 лежит указатель на голову
        mov     DWORD [p], eax     ;DO ... 
    .GO:
        mov     eax, DWORD [p]
        mov     eax, DWORD [eax]
        sub     esp, 4
        push    eax         ; p->data
        push    printfnumber
        push    DWORD[ebp+12]       ;вторым аргументом у ptint_list идёт выходной файл
        call  fprintf       ;по 16
        add     esp, 16
        mov     eax, [p]
        mov     eax,  [eax+4]   ;p=p->nest
        mov     DWORD [p], eax
        mov     eax,  [p]
        cmp     eax,  [ebp+8]   ;WHILE(P != голова), то есть пока не пройдём весь список
        jne     .GO
    add     esp, 8
    leave
    ret

free_list:
        push    ebp
        mov     ebp, esp
        sub     esp, 24
        mov     eax, DWORD [ebp+8]  ;первый аргумент голова
        mov     DWORD  [p], eax
        mov     DWORD [ebp-16], 1
        jmp     .ex
    .FORIK:
        mov     eax, DWORD  [p]
        mov     DWORD  [ebp-20], eax        ;List *tmp = p
        mov     eax, DWORD [p]
        mov     eax, DWORD  [eax+4]
        mov     DWORD [p], eax          ;p = p->next
        sub     esp, 12
        push    DWORD [ebp-20]          ;free(tmp)
        call  free
        add     esp, 16
        inc     DWORD [ebp-16]
    .ex:
        mov     eax, DWORD  [ebp-16]
        cmp     eax, DWORD [ebp+12];второй аргумент длина списка n
        jl      .FORIK
        sub     esp, 12
        push    DWORD  [p]
        call  free      ;по 16
        add     esp, 16
        leave
        ret
        
    GLOBAL CMAIN
CMAIN:
        push    ebp
        mov     ebp, esp;for correct debugging
        sub     esp, 28
        push    formatread
        push    nameinput
        call  fopen         ;по 16
        mov     DWORD [inn], eax
        add     esp, 8
        push    formatwrite
        push    nameoutput
        call  fopen         ;по 16
        mov     DWORD [outt], eax
        push    M
        push    N
        push    twonumbers
        push    DWORD [inn]
        call  fscanf        ;по 16
        add     esp, 4
        push    DWORD[N]
        call    create_list ;по 16
        add     esp, 12
        mov     DWORD [ebp-12], eax
        mov     eax, DWORD  [ebp-12]
        mov     DWORD [ebp-16], eax
        mov     eax, DWORD[N]
        inc     eax
        sal     eax, 2
        sub     esp, 12
        push    eax
        call    malloc
        add     esp, 16
        mov     DWORD[ebp-36], eax
        mov     DWORD [ebp-20], 1
        jmp     .L13
.L14:
        mov     eax, DWORD[ebp-20]
        lea     edx, [0+eax*4]
        mov     eax, DWORD [ebp-36]
        add     edx, eax
        mov     eax, DWORD[ebp-16]
        mov     DWORD [edx], eax
        mov     eax, DWORD [ebp-16]
        mov     eax, DWORD [eax+4]
        mov     DWORD [ebp-16], eax
        add     DWORD [ebp-20], 1
.L13:
        mov     eax, DWORD [N]
        cmp     DWORD  [ebp-20], eax
        jle     .L14
        mov     DWORD [ebp-24], 0
        jmp     .L15
.L18:
        lea     eax, [ebp-52]
        push    eax
        lea     eax, [ebp-48]
        push    eax
        push    twonumbers
        push    DWORD [inn]
        call  fscanf
        add     esp, 16
        mov     eax, DWORD [ebp-48]
        lea     edx, [0+eax*4]
        mov     eax, DWORD [ebp-36]
        add     eax, edx
        mov     eax, DWORD [eax]
        cmp     DWORD[ebp-12], eax
        je      .L17
        mov     eax, DWORD  [ebp-52]
        lea     edx, [eax*4]
        mov     eax, DWORD  [ebp-36]
        add     eax, edx
        mov     edx, DWORD  [eax]
        mov     eax, DWORD  [ebp-48]
        lea     ecx, [eax*4]
        mov     eax, DWORD  [ebp-36]
        add     eax, ecx
        mov     eax, DWORD [eax]
        mov     eax, DWORD [eax+8]
        mov     edx, DWORD  [edx+4]
        mov     DWORD [eax+4], edx
        mov     eax, DWORD  [ebp-48]
        lea     edx, [eax*4]
        mov     eax, DWORD  [ebp-36]
        add     eax, edx
        mov     edx, DWORD [eax]
        mov     eax, DWORD [ebp-52]
        lea     ecx, [eax*4]
        mov     eax, DWORD [ebp-36]
        add     eax, ecx
        mov     eax, DWORD [eax]
        mov     eax, DWORD [eax+4]
        mov     edx, DWORD [edx+8]
        mov     DWORD [eax+8], edx
        mov     eax, DWORD [ebp-48]
        lea     edx, [eax*4]
        mov     eax, DWORD [ebp-36]
        add     edx, eax
        mov     eax, DWORD [ebp-12]
        mov     eax, DWORD [eax+8]
        mov     edx, DWORD [edx]
        mov     DWORD [eax+4], edx
        mov     eax, DWORD [ebp-48]
        lea     edx, [eax*4]
        mov     eax, DWORD [ebp-36]
        add     eax, edx
        mov     eax, DWORD [eax]
        mov     edx, DWORD [ebp-12]
        mov     edx, DWORD [edx+8]
        mov     DWORD [eax+8], edx
        mov     eax, DWORD [ebp-52]
        lea     edx, [eax*4]
        mov     eax, DWORD [ebp-36]
        add     eax, edx
        mov     edx, DWORD [eax]
        mov     eax, DWORD [ebp-12]
        mov     DWORD [eax+8], edx
        mov     eax, DWORD [ebp-52]
        lea     edx, [eax*4]
        mov     eax, DWORD [ebp-36]
        add     eax, edx
        mov     eax, DWORD [eax]
        mov     edx, DWORD [ebp-12]
        mov     DWORD [eax+4], edx
        mov     eax, DWORD [ebp-48]
        lea     edx, [eax*4]
        mov     eax, DWORD [ebp-36]
        add     eax, edx
        mov     eax, DWORD [eax]
        mov     DWORD [ebp-12], eax
.L17:
        add     DWORD [ebp-24], 1
.L15:
        mov     eax, DWORD [M]
        cmp     DWORD [ebp-24], eax
        jl      .L18
        sub     esp, 8
        push    DWORD [outt]
        push    DWORD [ebp-12]
        call  print_list
        add     esp, 8
        push    DWORD  [N]
        push    DWORD  [ebp-12]
        call    free_list
        add     esp, 4
        push    DWORD[ebp-36]
        call  free
        add     esp, 4
        push    DWORD[outt]
        call  fclose
        add     esp, 4
        push    DWORD[inn]
        call  fclose
        add     esp, 16
        xor     eax, eax
        leave
        ret