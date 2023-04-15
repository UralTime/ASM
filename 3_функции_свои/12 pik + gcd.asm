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
    ;по формуле Пика S = В + Г/2 - 1 получаем ответ S+1-Г/2
    ;Площадь я уже считал в 1 констесте, поэтому вот копипаст того кода:
    GET_UDEC 4, x1
    GET_UDEC 4, y1
    GET_UDEC 4, x2
    GET_UDEC 4, y2
    GET_UDEC 4, x3
    GET_UDEC 4, y3
    ; 2S = detA = (x2-x1)(y3-y1) - (x3-x1)(y2-y1) = x1y2+x2y3+x3y1-x2y1-x3y2-x1y3  
    mov     eax, [x1]
    imul    eax, [y2]
    mov     ebx, [x2]
    imul    ebx, [y3]
    mov     ecx, [x3]
    imul    ecx, [y1]
    add     eax, ebx
    add     eax, ecx;   eax = x1y2 + x2y3 + x3y1
    mov     edx, [y1]
    imul    edx, [x2]
    mov     ebx, [y2]
    imul    ebx, [x3]
    mov     ecx, [y3]
    imul    ecx, [x1]
    add     edx, ebx
    add     edx, ecx;   edx = -x2y1 - x3y2 - x1y3
    sub     eax, edx;
    mov     edx, eax;
    sar     edx, 31
    or      edx, 1;      знаковый бит=0 - получили ffff, иначе получили 0000, нужно сделать 0001 и умножить
    mul     edx;        edx:eax = |eax+edx|
    mov     ecx, 2
    cdq
    idiv    ecx;        eax /= 2 
    mov     ebx, eax
    ;в ebx целый ответ
    
    ;количество целых точек на отрезке от (x1;y1) до (x2;y2) равно НОД(x2-x1,y2-y1)+1
    ;поэтому 2Г это сумма 3 (нодов + 1) минус 3 точки (вершины треугольника), которые посчитали дважды
    xor     esi, esi
    
    mov     eax, [x1]
    mov     ecx, [y1]
    sub     eax, [x2]
    sub     ecx, [y2]       ; gcd(x1-x2, y1-y2)
    push    eax
    push    ecx
    call    GCD
    add     esi, eax
    add     esp, 8
    
    mov     eax, [x1]
    mov     ecx, [y1]
    sub     eax, [x3]
    sub     ecx, [y3]        ;gcd(x1-x2,y1-y3)
    push    eax
    push    ecx
    call    GCD
    add     esi, eax
    add     esp, 8
    
    mov     eax, [x2]
    mov     ecx, [y2]
    sub     eax, [x3]
    sub     ecx, [y3]         ;gcd(x2-x3,y2-y3)
    push    eax
    push    ecx
    call    GCD
    add     esi, eax
    add     esp, 8
    
    mov     eax, esi            ;Г = gcd + gcd + gcd
    mov     ecx, 2              ;Г / 2
    mov     edx, 0
    idiv    ecx
    inc     ebx
    sub     ebx, eax            ;В = S+1 - Г/2
    PRINT_UDEC 4, ebx
    xor eax, eax
    ret  
    
GCD:
    push    ebp
    mov     ebp, esp
    mov     eax, dword[ebp + 8]
    mov     ecx, dword[ebp + 12]
    mov     edx, eax
    neg     edx
    cmp     eax, 0
    cmovl   eax, edx        ;eax = |eax|
    mov     edx, ecx
    neg     edx
    cmp     ecx, 0
    cmovl   ecx, edx        ;ecx = |ecx|
    cmp     ecx, 0
    jnz     .recursive
    leave
    ret
    .recursive:         ; if (b>0) return gcd(b, a%b)
        mov     edx, 0
        div     ecx
        push    edx
        push    ecx
        call    GCD
        leave
        ret
    