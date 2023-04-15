%include "io.inc"

section .bss
    a resd 4
    b resd 4

section .text
    global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    xor     ecx, ecx
    L:                 ;это считывание координат вершин прямоугольника
        GET_DEC 4, edx
        mov     dword[a + ecx * 4], edx
        GET_DEC 4, edx
        mov     dword[b + ecx * 4], edx
        add     ecx, 1
        cmp     ecx, 4
        jnz      L
    GET_DEC 4, esi ;координаты точки строго(она не на границе) в прямоугольнике, если 
    GET_DEC 4, edi ;и при этом две вершины < точки < 2 вершины
    xor     eax, eax 
    xor     ebx, ebx 
    xor     ecx, ecx
    TESTX:      ;в eax будем хранить "баланс": +1 прибавляем, если точка правее, -1, если левее
        mov     edx, dword[a + ecx * 4]
        sub     edx, esi
        test    edx, edx
        jz      NO      ;точка на границе
        sets    bl  ; bl = (edx < x)
        add     al, bl
        add     ecx, 1
        cmp     ecx, 4
        jnz     TESTX
    cmp     al, 2
    jnz     NO
    xor     eax, eax 
    xor     ebx, ebx 
    xor     ecx, ecx
    TESTY:              ;аналогично с ebx, но по координате y
        mov     edx, dword[b + ecx * 4]
        cmp     edx, edi
        jz      NO
        setl    al  ; bl = (edx < x)
        add     bl, al
        add     ecx, 1
        cmp     ecx, 4
        jnz     TESTY
    cmp     bl, 2
    jnz NO
    jmp YES
    NO:
        PRINT_STRING "NO"
        jmp RETURN
    YES:
        PRINT_STRING "YES"
    RETURN:
        xor eax, eax
        ret