%include "io.inc"
CEXTERN malloc
CEXTERN free
CEXTERN fscanf
CEXTERN fclose
CEXTERN fopen
CEXTERN fprintf

section .rodata
    scanfnumber dd "%d ", 0
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
        sub     esp, 36
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
        push    scanfnumber
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
        mov     DWORD ecx, 1
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
        inc     ecx
    .ex:
        cmp     ecx, DWORD [ebp+12] ;второй аргумент длина списка n
        jl      .FORIK
        sub     esp, 12
        push    DWORD  [p]
        call  free      ;по 16
        add     esp, 16
        leave
        ret
        
    GLOBAL CMAIN
CMAIN:
       