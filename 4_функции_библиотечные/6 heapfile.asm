%include "io.inc"
CEXTERN malloc
CEXTERN realloc
CEXTERN fopen
CEXTERN fclose
CEXTERN fread
CEXTERN fwrite
CEXTERN free

section .rodata
    RB dd "rb", 0
    NAMEIN dd "input.bin", 0
    WB dd "wb", 0
    NAMEOUT dd "output.bin", 0
    
 section .bss
    iin resd 1
    oout resd 1
    ans resd 1
    size resd 1
    maxsize resd 1
    a resd 1

section .text
comp:            ;cmp(int a, int b, int*predict)
    push    ebp ;проверка а - родитель, b - сын
    mov     ebp, esp
    mov     ecx, [ebp + 8]  ;ecx - a
    mov     edx, [ebp + 12] ;edx - b
    mov     eax, [ebp + 16] 
    mov     eax, [eax]  ;eax - *predict
    test    eax, eax
    jne     .if1
    mov     eax, 0      ;if *predict==0 return 0
    jmp     .return     ;уже точно не пирамида
.if1:
    cmp     eax, 1      ;должна быть неубывающей
    jne     .if2        ;if *predict == 1 
    cmp     ecx, edx
    setle   al
    movzx   eax, al
    jmp     .return     ;return (a<=b)
.if2:
    cmp     eax, -1     ;должны быть невозрастающей
    jne     .if3        ;if *predict == -1
    cmp     ecx, edx
    setge   al
    movzx   eax, al
    jmp     .return     ;return (a>=b)
.if3:                   ;пока неясно, какая
    cmp     ecx, edx
    jge     .if4
    mov     eax, [ebp + 16]
    mov     dword[eax], 1   ;*predict = 1 должна быть неубывающей
.if4:
    cmp     ecx, edx
    jle     .return1
    mov     eax, [ebp+16]
    mov     dword[eax], -1  ;должны быть невозрастающей
.return1:       ;пока всё ок, проверим на следующем шаге
    mov     eax, 1
.return:
    leave
    ret
        
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    sub     esp, 4
    push    RB
    push    NAMEIN  ;выравняли и вызвали
    call  fopen
    add     esp, 8
    mov     dword[iin], eax
    push    WB
    push    NAMEOUT     ;выравняли и вызвали
    call  fopen
    mov     dword[oout], eax
    mov     dword[ans], 2
    mov     dword[maxsize], 128
    mov     dword[size], 0
    mov     eax, [maxsize]
    sal     eax, 2          ;*sizeof(int)
    add     esp, 4
    push    eax             ;всё выравняли
    call  malloc
    add     esp, 16
    mov     DWORD[a], eax
    jmp     .while
.real:
    add     dword[size], 1
    mov     eax, [size]
    add     eax, 1
    cmp     dword[maxsize], eax     ;if size+1==maxsize
    jne     .while
    mov     edi, [maxsize]
    sal     edi, 1                  ;расширемся в 2 раза
    mov     dword[maxsize], edi
    mov     eax, [maxsize]
    sal     eax, 2
    sub     esp, 8
    push    eax
    push    DWORD[a]           ;всё выровнено
    call  realloc
    add     esp, 16
    mov     dword[a], eax       ;a = malloc(...)
.while:               ;// читаем массив, индексация с 1 (sorry)
    mov     eax, [size]
    add     eax, 1
    lea     edx, [eax * 4]
    mov     eax, [a]
    add     eax, edx
    push    dword[iin]
    push    1
    push    4
    push    eax         ;всё выравняли
    call  fread
    add     esp, 16
    cmp     eax, 1
    je      .real      ;while fread т.е. while input
    mov     esi, 1       ;esi === i - counter
    jmp     .testi
.loop:
    mov     eax, [ans]
    test    eax, eax
    je      .exit           ;if ans==0 это не пирамида
    mov     eax, esi
    lea     edx, [eax * 8]
    mov     eax, [a]
    add     eax, edx
    mov     edx, [eax]
    mov     eax, esi
    lea     ecx, [eax*4]
    mov     eax, [a]
    add     eax, ecx            
    mov     eax, [eax]
    sub     esp, 4              ;выравняли
    lea     ecx, [ans]
    push    ecx
    push    edx
    push    eax
    call  comp        ;cmp(a[i], a[2i], &ans)
    add     esp, 16
    test    eax, eax
    jne     .L14
    mov     dword[ans], 0       ;левый сын не прошёл проверку, это не пирамида
.L14:
    mov     eax, esi
    add     eax, eax
    add     eax, 1
    cmp     dword[size], eax        ;if 2i+1 <= size
    jb      .inci
    mov     eax, esi
    sal     eax, 3
    lea     edx, [eax+4]
    mov     eax, [a]
    add     eax, edx
    mov     edx, [eax]
    mov     eax, esi
    lea     ecx, [0+eax*4]
    mov     eax, [a]
    add     eax, ecx
    mov     eax, [eax]
    sub     esp, 4
    lea     ecx, [ans]
    push    ecx
    push    edx
    push    eax             ;всё выравняли
    call  comp
    add     esp, 16
    test    eax, eax
    jne     .inci           ;if cmp(a[i],a[2i+1],&ans) ans=0
    mov     dword[ans], 0   ;правый сын не прошёл проверку, этл не пирамида
.inci:
    inc     esi
.testi:
    mov     eax, esi
    add     eax, eax
    cmp     dword[size], eax
    jnb     .loop            ;while 2*i <= size
    
    mov     eax, [ans]
    cmp     eax, 2          ;все элементы равны друг другу
    jne     .exit
    mov     dword[ans], 1   ;нужно вывести 1
.exit:
    push    dword[oout]
    push    1
    push    4       ;sizeof int
    push    ans
    call  fwrite    
    add     esp, 4    ;всё выравняли
    push    dword[a]
    call  free        ;всё почистили
    add     esp, 4
    push    dword[iin]
    call  fclose        ;всё закрыли
    add     esp, 4    ;всё выравняли
    push    dword[oout]
    call  fclose      ;всё закрыли
    add     esp, 12
    xor     eax, eax
    ret