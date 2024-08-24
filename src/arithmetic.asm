; Codigo de ejemplo y pruebas para manejo de flotantes y acarreo
; por Frederick Obando Solano

.MODEL SMALL
.STACK 100H
.data   ; Seccion de inicializacion de datos (variables)
    sit db 4    ; Esta 'variable' en memoria almacena la operacion a evaluar

    arg1 dw 4 ; variable (16 bits) word para la parte entera de un valor
    darg1 dw 26   ; variable (16 bits) 2 bytes de la parte flotante de 'num'

    arg2 dw 2   ; variable (16 bits) word para la parte entera del argumento de la operacion
    darg2 dw 15   ; variable (16 bits) 2 bytes para la parte flotante de 'arg'

    result dw 0   ; variable (16 bits) word para la parte entera del resultado de la operacion
    dresult dw 0  ; variable (16 bits) 2 bytes para la parte flotante de 'solv'

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
            mov bx, result ; (parse) requiere que la parte entera este en BX
            mov ax, dresult    ; (parse) requiere que la parte flotante este en AX
            call parse  ; Despues de parsear el registro 'SI' queda en el ultimo digito significativo

            lea dx, [string1+si]  ; Mueve al registro DX nuestro string, dado que el output redirecciona lo que haya en DX
            call printout   ; Esto hace 'print' en display del valor indicado
        jmp EXIT
    ; -----------------------------|'add()'|-----------------------------
    addition: ; (INT1+INT2)+[(FLT1+FLT2)/100]
    ; 1. (Efectuar suma de las partes enteras)
        mov ax, arg1
        add ax, arg2
        mov result, ax
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
        add result, cx    ; solv = solv(pt entera) + residuo(digitos extra)

        skipfix:
        mov dresult, dx
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
        mov result, ax
        mov dresult, dx

        jmp sub_case1

        sub_case2:   ; Caso 2: Residuo en AH
        xor cx, cx
        mov cl, al 

        xor bx, bx
        mov bl, ah

        xor ax, ax
        mov result, cx
        mov dresult, bx
        
        sub_case1:
        ; (b)[Limpiar registros]
            mov ax, 0
            mov bx, 0
            mov cx, 0
            mov dx, 0
        ret
    ; -----------------------------|'mult()'|-----------------------------
    multiply: ; [INT1*INT2]+[(INT1*FLT2)/100]+[(INT2*FLT1)/100]+[(FLT1*FLT2)/100^2]
    ; 1. (Efectuar multiplicacion de partes enteras)
        mov ax, arg1
        mov bx, arg2
        mul bx
        mov result, ax
        ; (a)[limpiar registros]
            xor ax,ax
            xor bx, bx
    ; 2. (Efectuar multiplicacion entero1-flotante2 dividido entre 100)
        mov ax, arg1
        mov bx, darg2
        mul bx      ; AX = INT1*FLT2
        xor bx, bx  ; Limpiar registro completo
        mov bx, 100 
        div bx      ; A? = (INT1*FLT2)/100
        ; (a)[Manipular residuo y cociente de la division]
        xor bx, bx
        cmp dx, 0
            jnz mult_case2
        mult_case1: ; Residuo en AH y cociente en AL
            mov bl, ah ; Mover residuo
            mov cl, al ; Mover cociente

            add result, cx  ; Acumular las partes enteras
            add dresult, bx ; Acumular las partes flotantes

            jmp mult_postproc1
        mult_case2: ; Residuo en DX y cociente en AX
            add result, ax  ; Acumular las partes enteras
            add dresult, dx ; Acumular las partes flotantes
        mult_postproc1:
        ; (b)[Limipiar registros]
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
    ; 3. (Efectuar multiplicacion entero2-flotante1 dividido entre 100)
        mov ax, arg2
        mov bx, darg1
        mul bx      ; AX = INT2*FLT1
        xor bx, bx  ; Limpiar registro completo
        mov bx, 100 
        div bx      ; A? = (INT2*FLT1)/100
        ; (a)[Manipular residuo y cociente de la division]
        xor bx, bx
        cmp dx, 0
            jnz mult_case4
        mult_case3: ; Residuo en AH y cociente en AL
            mov bl, ah ; Mover residuo
            mov cl, al ; Mover cociente

            add result, cx ; Acumular las partes enteras
            add dresult, bx ; Acumular las partes flotantes
            jmp mult_postproc2
        mult_case4: ; Residuo en DX y cociente en AX
            add result, ax  ; Acumular las partes enteras
            add dresult, dx ; Acumular las partes flotantes
        mult_postproc2:
        ; (b)[Limipiar registros]
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
    ; 4. (Efectuar multiplicacion flotante-flotante dividido entre 100*100)
        mov ax, darg1
        mov bx, darg2
        mul bx  ; AX = FLT1*FLT2

        xor bx, bx  ; Limpiar registro completo
        mov bx, 100
        div bx  ; A? = (FLT1*FLT2)/100

        ; (a)[Descartar el primer residuo]
        cmp dx, 0
            jnz mult_case6
        mult_case5: ; Residuo en AH y cociente en AL
            xor ah, ah
            jmp mult_postproc3
        mult_case6: ; Residuo en DX y cociente en AX
            xor dx, dx
        ; (b)[Volver a dividir y ,en este, caso acumular la parte entera y flotante]
        mult_postproc3:
        div bx

        xor bx, bx  ; Limpiar registro completo
        cmp dx, 0
            jnz mult_case8
        mult_case7: ; Residuo en AH y cociente en AL
            mov bl, ah  ; Mover residuo
            mov cl, al  ; Mover cociente

            add result, cx  ; Acumular las partes enteras
            add dresult, bx ; Acumular las partes flotantes
        mult_case8: ; Residuo en DX y cociente en AX
            add result, ax  ; Acumular las partes enteras
            add dresult, dx ; Acumular las partes flotantes
        ; (c)[Limpiar registros]
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
    ; 5. (Ajuste de parte flotante y agregado a parte entera)
        mov ax, dresult
        mov bx, 100
        div bx  ; La division permite dejar dos digitos en la parte flotante total(residuo), el cociente seria el agregado a la parte entera
        ; (a)[Manipular el residuo y cociente adecuadamente]
        xor bx, bx ; Limpiar registro
        cmp dx, 0
            jnz mult_fix
        mult_nofix: ; Residuo en AH y cociente en AL
            mov bl, ah ; Mover residuo: BX=AH
            xor ah, ah ; Limpiar AH: AX = AL (cociente)

            add result, ax ; Sumar cociente(agregado) a la parte entera
            add dresult, bx; Sumar residuo a la parte flotante

            jmp mult_postfix
        mult_fix:   ; Residuo en DX y cociente en AX
            add result, ax ; Sumar cociente(agregado) a la parte entera
            mov dresult, dx; Sumar residuo a la parte flotante
        mult_postfix:
        ; (b)[Limpiar registros]
            xor ax, ax
            xor bx, bx
            xor cx, cx
            xor dx, dx
        ret
    ; -----------------------------|'div()'|-----------------------------
    divide: ; [100(INT1)+FLT1]/[100(INT2)+FLT2]
    ; 1. (Calculo de dividendo)
        mov ax, arg1
        mov bx, 100
        mul bx

        add ax, darg1
        mov result, ax
        ; (a)[Limpiar registros]
            xor ax, ax
            xor bx, bx
    ; 2. (Calculo del divisor)
        mov ax, arg2
        mov bx, 100
        mul bx

        add ax, darg2
    ; 3. (Ejecutar divison)
        xor bx, bx
        mov bx, ax
        xor ax, ax
        mov ax, result

        div bx
        mov aux, bx ; Guardar el valor del divisor
        ; (a)[Ajuste de parte entera y flotante]
        xor bx, bx ; Limpiar el registro completo
        cmp dx, 0
            jnz div_case2
        div_case1: ; Residuo en AH y cociente en AL
            mov bl, ah ; Mover el residuo tal que BX=AH
            xor ah, ah ; Limpiar AH para que AX = AL

            mov result, ax
            mov ax, bx
            xor bx, bx

            jmp div_FLT
        div_case2: ; Residuo en DX y cociente en AX
            mov result, ax
            mov ax, dx
            xor dx, dx
        div_FLT: ; Este ciclo permite reducir el residuo hasta que solo tenga dos digitos
            mov daux, ax ; Guardar un referencia al valor original del residuo
            mov bx, 10

            div_loop:
                mul bx
                div aux

                cmp dx, 0
                    jnz div_loopcase2
                div_loopcase1:  ; Residuo en AH y cociente en AL
                    xor ah , ah ; AX = AL
                    jmp div_loopeval
                div_loopcase2:  ; Residuo en DX y cociente en AX
                    xor dx, dx  
                div_loopeval:
                mov cx , ax
                sub cx, 10
                    jns div_postproc ; Si el numero es positivo ( 2 digitos) entonces se termina el ciclo
                
                xor ax, ax
                xor cx, cx

                mov ax , bx
                mul bx ; AX = BX * BX
                mov bx , ax

                mov ax, daux
                jmp div_loop

        div_postproc:
        mov dresult, ax ; Movemos el nuevo flotante
        ; (b)[Limpiar registros]
            xor ax, ax
            xor bx, bx
            xor cx, cx
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