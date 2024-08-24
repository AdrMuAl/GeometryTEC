; Codigo de ejemplo y pruebas para manejo de flotantes y acarreo
; por Frederick Obando Solano

.MODEL SMALL
.STACK 100H
.data   ; Seccion de inicializacion de datos (variables)
    sit db 2    ; Esta 'variable' en memoria almacena la operacion a evaluar

    arg1 dw 13 ; variable (16 bits) word para la parte entera de un valor
    darg1 dw 20   ; variable (16 bits) 2 bytes de la parte flotante de 'num'

    arg2 dw 1   ; variable (16 bits) word para la parte entera del argumento de la operacion
    darg2 dw 26   ; variable (16 bits) 2 bytes para la parte flotante de 'arg'

    solv dw 0   ; variable (16 bits) word para la parte entera del resultado de la operacion
    dsolv dw 0  ; variable (16 bits) 2 bytes para la parte flotante de 'solv'

    aux dw 0
    daux dw 0

    string1 db 5 dup(30h) , '.', 2 dup('0'), '$'   ; arreglo de 9 caracteres(1 byte cada uno) para guardar el flotante
    string2 db 5 dup(30h) , '.', 2 dup('0'), '$'   ; arreglo secundario para manejar acarreo

.code   ; Seccion de codigo ejecutble
    START:  ; Inicio del codigo y operaciones
        mov ax, @data ; Inicializa la seccion de datos completa
        mov ds, ax   ; Mueve los datos inicializados al registro de segmento 'DS'
        mov ax, 0
        ; (Seleccion de operacion)
        jmp selection
        ; (1)
        case1:
            call addition
            jmp postOP
        case2:
            call substract
            jmp postOP
        case3:
            call multiply
            jmp postOP
        case4:
            call divide
            jmp postOP
        ; (2)
        selection:
            cmp sit, 1
            jz case1

            cmp sit, 2
            jz case2

            cmp sit, 3
            jz case3

            cmp sit, 4
            jz case4
        ; (Conversion a string)
        postOP:
            mov si, 0   ; Indice donde se comienza a escribir el numero
            mov bx, solv ; (parse) requiere que la parte entera este en BX
            mov ax, dsolv    ; (parse) requiere que la parte flotante este en AX
            call parse  ; Despues de parsear el registro 'SI' queda en el ultimo digito significativo

            lea dx, [string1+si]  ; Mueve al registro DX nuestro string, dado que el output redirecciona lo que haya en DX
            call printout   ; Esto hace 'print' en display del valor indicado
        jmp EXIT
    ; -----------------------------|'add()'|-----------------------------
    addition:
        ; 1. (Efectuar suma de las partes enteras)
        mov ax, arg1
        add ax, arg2
        mov solv, ax
            ; (Limpieza de registros)
            mov ax, 0
        ; 2. (Efectuar suma de las partes flotantes) 
        mov ax, darg1    ; AX = flotante1
        add ax, darg2    ; flotante1(AX) = flotante1 + flotante2
        ; (a)[Verificar digitos del flotante]
        mov bl, 100
        div bl

        mov cx, 0
        mov cl, al  ; CX = [CH=0], [CL=AL](cociente)

        mov dx, 0
        mov dl, ah  ; DX = [DH=0], [DL=AH](residuo)

        cmp cx, 0
            jz skipfix
        add solv, cx    ; solv = solv(pt entera) + residuo(digitos extra)

        skipfix:
        mov dsolv, dx
        ; (b)[Limpieza de registros]
            mov ax, 0
            mov bx, 0
            mov cx, 0
            mov dx, 0
        ret
    ; -----------------------------|'subs()'|-----------------------------
    substract:  ; [100(INT1-INT2)+(FLT1-FLT2)]/100
        ; 1. (Efectuar resta de las partes enteras)
        mov ax, arg1
        mov bx, 100
        sub ax, arg2
        mul bx
        ; 2. (Efectuar resta de las partes flotantes)
        xor bx, bx
        mov bx, darg1
        sub bx, darg2
        ; 3. (Sumar ambas partes y dividir entre 100)
        add ax, bx
        xor bx, bx
        mov bx, 100
        div bx
        ; (a)[Identifcar donde se guardo el residuo de la division(la nueva parte flotante)]
        cmp dx, 0
            jz sub_case2
        ; Caso 1: Residuo en DX > DL
        mov solv, ax
        mov dsolv, dx

        jmp sub_case1

        sub_case2:   ; Caso 2: Residuo en AH
        xor cx, cx
        mov cl, al 

        xor bx, bx
        mov bl, ah

        xor ax, ax
        mov solv, cx
        mov dsolv, bx
        
        sub_case1:
        ; (b)[Limpiar registros]
            mov ax, 0
            mov bx, 0
            mov cx, 0
            mov dx, 0
        ret
    ; -----------------------------|'div()'|-----------------------------
    divide:
        ; 1. (Efectuar division de las partes enteras)
          ; 1.1 [Dividir: entero entre entero]
        
          ; 1.2 [Multplicar: entero entre flotante]

        ; 2. (Efectuar divison de las partes flotantes) 
          ; 2.1 [Dividir: flotante entre entero]
        
          ; 2.2 [Multplicar: flotante entre flotante]
        ret
    ; -----------------------------|'mult()'|-----------------------------
    multiply:
        ; 1. (Efectuar multiplicacion de las partes enteras)
          ; 1.1 [Multiplicar: entero entre entero]
        
          ; 1.2 [Dividir: entero entre flotante]
          
        ; 2. (Efectuar multiplicacion de las partes flotantes) 
          ; 2.1 [Dividir: flotante entre entero]
                  ; 2.2 [Multplicar: flotante entre flotante]

        ret
    ; --------------------------------|carryhandler()|--------------------------------
    carryHandler:
        ret
    ; ---------------------------|'parse(int[BX],flt[AX])'|---------------------------
    parse: ; esta 'funcion' permite convertir el resultado de la operacion al 'string'
        mov si, 8 ; Indice de 'numstr' donde se debe comenzar a escribir los flotantes
        mov cl, 10  ; El valor de 10, permitir aislar de uno los digitos de un numero, es este aislamiento es el residuo de la division

        float: ; Funcion recursiva
            ; (Caso base)
            cmp al, 0; Verificar que ya no queden digitos distintos de cero por escribir
            jz midpoint
            ; (Operaciones)
            dec si  ; decremento en indice para colocarse en la posicion adecuada
            div cl ; Division entre 10, para aislar el ultimo digito
            add ah, 30h ; convertir el digito aislado(residuo de div en DX) a ASCII
            mov [string1+si], ah  ; mover a la posicion indexada el numero ASCII
            ; (Limpieza de registros)
            mov ah, 0
            ; (Llamada recursiva)
            jmp float

        midpoint: ; Punto intermedio entre conversion de partes
            mov si, 5   ; Mover el indice al inicio de los digitos de la parte entera
            mov ax, bx  ; Mover la parte entera al registro AX para poder aislar los digitos 
            mov bx, 0   ; Limpiar el registro que ya no se esta usado
            mov dx, 0

        integer: ; Funcion recursiva
            ; (Caso base)
            cmp al, 0; Verificar que ya no queden digitos distintos de cero por escribir
            jz endpoint
            ; (Operaciones)
            dec si  ; decremento en indice para colocarse en la posicion adecuada
            div cl  ; Division entre 10, para aislar el ultimo digito
            add ah, 30h ; convertir el digito aislado(residuo de div en DX) a ASCII
            mov [string1+si], ah   ; mover a la posicion indexada el numero ASCII
            ; (Limpieza de registros)
            mov ah, 0
            ; (Llamada recursiva)
            jmp integer
        
        endpoint: ; Punto final de conversion (Limpia los registros usados)
            mov ax, 0
            mov bx, 0
            mov cx, 0
            mov dx, 0

        ret
    ; -----------------------------|'printout(num[&DX])'|-----------------------------
    printout:
        mov ah, 09h     ; mueve al AH la instruccion para mostrar en pantalla(09H) el contenido en DX
        int 21h
        
        mov ax, 0
        mov dx, 0
        mov si, 0
        ret
    ;------------------------------------------------------------------------------------------
    EXIT:   ; Fin del programa
        mov ah,4ch  ; Finaliza el programa
        int 21h     ; Llama el kernel (interrumpe)
end     ; Indica el final del codigo para el ensamblador