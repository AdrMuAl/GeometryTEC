; Codigo de ejemplo y pruebas para manejo de flotantes y acarreo
; por Frederick Obando Solano

.MODEL SMALL
.STACK 100H
.data   ; Seccion de inicializacion de datos (variables)
    sit db 3    ; Esta 'variable' en memoria almacena la operacion a evaluar

    ; >> Variables para operaciones aritmeticas con flotantes <<
    param1 dw 3 , 70 ; arreglo de enteros (16-bits c/a) para partes de un flotante
    ;       ^INT1,^FLT1 => para indexar se multiplica el indice por 2 (bytes)
    param2 dw 2 , 17 ; arreglo de enteros (16-bits c/a) para partes de un flotante
    ;       ^INT2,^FLT2
    result dw 0 , 0 ; arreglo de enteros (16-bits c/a) para resultado de operacion entre flotantes
    ;       ^INT,^FLT
    aux dw 0, 0     ; arreglo de enteros (16-bits c/a) para guardar datos de manera temporal en operaciones

    ; >> Variables para almacenar numeros como strings
    num_str1 db 5 dup(30h) , '.', 2 dup('0'), '$'   ; arreglo de caracteres(8-bits c/a) para representar un flotante como string
    num_str2 db 5 dup(30h) , '.', 2 dup('0'), '$'   ; arreglo secundario para manejar acarreo

.code   ; Seccion de codigo ejecutble
    START:  ; Inicio del codigo y operaciones
        mov ax, @data ; Inicializa la seccion de datos completa
        mov ds, ax    ; Mueve los datos inicializados al registro de segmento 'DS'
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
        ; (1)[Hacer un 'parseo' de nuestro resultado aritmetico]
            mov si, 0       ; Indice en donde se comienza a escribir sobre el 'string'
            mov bx, [result]  ; (parse) requiere que la parte entera este en BX
            mov ax, [result+2]; (parse) requiere que la parte flotante este en AX
            call parse      ; Despues de parsear el registro 'SI' queda en el ultimo digito significativo
        ; (2)[Hacer 'printout' del resultado]
            lea dx, [num_str1+si]   ; Mueve al registro DX nuestro string, dado que el output redirecciona lo que haya en DX
            call printout           ; Esto hace 'print' en display del valor indicado
        jmp EXIT    ; Terminar programa
    ; -----------------------------|'add()'|-----------------------------
    addition: ; (INT1+INT2)+[(FLT1+FLT2)/100]
    ; 1. (Efectuar suma de las partes enteras)
        mov ax, [param1]  ; AX = INT1
        add ax, [param2]  ; AX = INT1+INT2
        mov [result], ax
            ; (Limpieza de registros)
            xor ax, ax
    ; 2. (Efectuar suma de las partes flotantes) 
        mov ax, [param1+2]    ; AX = FLT1
        add ax, [param2+2]    ; AX = FLT1+FLT2
        ; (a)[Verificar digitos del flotante]
        mov bx, 100
        xor dx, dx
        div bx  ; AX = (FLT+FLT2)/100

        add [result], ax  ; Suma exceso del flotante a la parte entera
        mov [result+2], dx  ; Mover el residuo a la parte decimal
        ; (b)[Limpieza de registros]
            xor ax, ax
            xor bx, bx
            xor dx, dx
        ret
    ; -----------------------------|'subs()'|-----------------------------
    substract:  ; [100(INT1-INT2)+(FLT1-FLT2)]/100
    ; 1. (Efectuar resta de las partes enteras)
        mov ax, [param1]; AX = INT1
        mov bx, 100
        sub ax, [param2]; AX = INT1-INT2
        mul bx          ; AX = 100(INT1-INT2)
    ; 2. (Efectuar resta de las partes flotantes)
        xor bx, bx
        mov bx, [param1+2]  ; BX = FLT1
        sub bx, [param2+2]  ; BX = FLT1-FLT2
    ; 3. (Sumar ambas partes y dividir entre 100)
        add ax, bx  ; AX = 100(INT1-INT2)+(FLT1-FLT2)
        xor bx, bx  ; Limpiar registro

        mov bx, 100
        xor dx ,dx
        div bx      ; [100(INT1-INT2)+(FLT1-FLT2)]/100
        ; (a)[Identifcar donde se guardo el residuo de la division(la nueva parte flotante)]
        mov [result], ax  ; Mover cociente(parte entera)
        mov [result+2], dx ; Mover residuo(parte flotante)

        ; (b)[Limpiar registros]
            xor ax, ax
            xor bx, bx
            mov dx, dx
        ret
    ; -----------------------------|'mult()'|-----------------------------
    multiply: ; [INT1*INT2]+[(INT1*FLT2)/100]+[(INT2*FLT1)/100]+[(FLT1*FLT2)/100^2]
    ; 1. (Efectuar multiplicacion de partes enteras)
        mov ax, [param1]
        mov bx, [param2]
        mul bx          ; AX = INT1*INT2
        mov [result], ax; Acumular las partes enteras
        ; (a)[limpiar registros]
            xor ax,ax
            xor bx, bx
    ; 2. (Efectuar multiplicacion entero1-flotante2 dividido entre 100)
        mov ax, [param1]
        mov bx, [param2+2]
        mul bx      ; AX = INT1*FLT2

        xor bx, bx  ; Limpiar registro completo
        mov bx, 100
        xor dx, dx 
        div bx      ; A? = (INT1*FLT2)/100
        ; (a)[Manipular residuo y cociente de la division]
        add [result], ax  ; Acumular las partes enteras
        add [result+2], dx ; Acumular las partes flotantes
        ; (b)[Limipiar registros]
            xor ax, ax
            xor bx, bx
            xor dx, dx
    ; 3. (Efectuar multiplicacion entero2-flotante1 dividido entre 100)
        mov ax, [param2]
        mov bx, [param1+2]
        mul bx      ; AX = INT2*FLT1

        xor bx, bx  ; Limpiar registro completo
        mov bx, 100 
        xor dx, dx
        div bx      ; A? = (INT2*FLT1)/100
        ; (a)[Manipular residuo y cociente de la division]
        add [result], ax  ; Acumular las partes enteras
        add [result+2], dx ; Acumular las partes flotantes
        ; (b)[Limipiar registros]
            xor ax, ax
            xor bx, bx
            xor dx, dx
    ; 4. (Efectuar multiplicacion flotante-flotante dividido entre 100*100)
        mov ax, [param1+2]
        mov bx, [param2+2]
        mul bx  ; AX = FLT1*FLT2

        xor bx, bx  ; Limpiar registro completo
        mov bx, 100

        xor dx, dx  ; Limpiar registro completo
        div bx  ; A? = (FLT1*FLT2)/100
        xor dx, dx  ; Descartar residuo de division
        ; (b)[Volver a dividir y ,en este, caso acumular la parte entera y flotante]
        div bx

        add [result], ax  ; Acumular las partes enteras
        add [result+2], dx ; Acumular las partes flotantes
        ; (c)[Limpiar registros]
            xor ax, ax
            xor bx, bx
            xor dx, dx
    ; 5. (Ajuste de parte flotante y agregado a parte entera)
        mov ax, [result+2]  ; Dado que el flotante pudo haber terminado siendo de mas de dos digitos
        mov bx, 100

        xor dx, dx
        div bx  ; La division permite dejar dos digitos en la parte flotante total(residuo), el cociente seria el agregado a la parte entera
        ; (a)[Manipular el residuo y cociente adecuadamente]
        add [result], ax ; Sumar cociente(agregado) a la parte entera
        mov [result+2], dx; Mover residuo a la parte flotante
        ; (b)[Limpiar registros]
            xor ax, ax
            xor bx, bx
            xor dx, dx
        ret
    ; -----------------------------|'div()'|-----------------------------
    divide: ; [100(INT1)+FLT1]/[100(INT2)+FLT2]
    ; 1. (Calculo de dividendo)
        mov ax, [param1]
        mov bx, 100
        mul bx  ; AX = INT1*100

        add ax, [param1+2]   ; AX = 100(INT1)+FLT1
        mov [result], ax       ; Guardar dividendo
        ; (a)[Limpiar registros]
            xor ax, ax
            xor bx, bx
    ; 2. (Calculo del divisor)
        mov ax, [param2]
        mov bx, 100
        mul bx  ; AX = INT2*100

        add ax, [param2+2] ; AX = 100(INT2)+FLT2
    ; 3. (Ejecutar divison)
        xor bx, bx  ; Limpiar registro
        mov bx, ax  ; Mover divisor: BX = AX
        xor ax, ax  ; Limpiar registro
        mov ax, [result]  ; Mover dividendo a AX

        xor dx, dx
        div bx
        mov [aux], bx ; Guardar el valor del divisor

        ; (a)[Ajuste de parte entera y flotante]
        xor bx, bx ; Limpiar el registro completo
        mov [result], ax    ; Mover cociente a la parte entera
        mov ax, dx  ; Mover residuo a AX para obtener parte flotante
        xor dx, dx  ; Limpiar registro

        mov [aux+2], ax ; Guardar una referencia al valor original del residuo
        mov bx, 10
        div_loop: ; Este ciclo permite dividir el residuo entre el divisor recursivamente hasta que el cociente sea de dos digitos
            mul bx      ; Multiplicar residuo por multiplo de 10

            xor dx, dx
            div [aux]   ; Dividir entre dividendo
            xor dx, dx  ; Eliminar residuo

            mov cx , ax ; Mover cociente a otro registro para evaluar total de digitos
            sub cx, 10  ; Restar 10 al cociente
                jns div_loopend ; Si el numero es positivo ( 2 digitos) entonces se termina el ciclo
            
            xor ax, ax  ; Limpiar registros
            xor cx, cx

            mov ax , bx 
            mul bx ; AX = BX * BX
            mov bx , ax

            mov ax, [aux+2] ; Volver a traer el valor original del residuo
            jmp div_loop

        div_loopend:
        mov [result+2], ax ; Movemos el nuevo flotante
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
        mov cl, 10  ; El valor de 10, permitir aislar uno los digitos de un numero, este aislamiento es el residuo de la division

        parse_float: ; Funcion recursiva
            ; (Caso base)
            cmp al, 0; Verificar que ya no queden digitos distintos de cero por escribir
            jz parse_midpoint
            ; (Operaciones)
            dec si  ; decremento en indice para colocarse en la posicion adecuada
            div cl ; Division entre 10, para aislar el ultimo digito
            add ah, 30h ; convertir el digito aislado(residuo de div en DX) a ASCII
            mov [num_str1+si], ah  ; mover a la posicion indexada el numero ASCII
            ; (Limpieza de registros)
            mov ah, 0
            ; (Llamada recursiva)
            jmp parse_float

        parse_midpoint: ; Punto intermedio entre conversion de partes
            mov si, 5   ; Mover el indice al inicio de los digitos de la parte entera
            mov ax, bx  ; Mover la parte entera al registro AX para poder aislar los digitos 
            mov bx, 0   ; Limpiar el registro que ya no se esta usado
            mov dx, 0

        parse_integer: ; Funcion recursiva
            ; (Caso base)
            cmp al, 0; Verificar que ya no queden digitos distintos de cero por escribir
            jz parse_endpoint
            ; (Operaciones)
            dec si  ; decremento en indice para colocarse en la posicion adecuada
            div cl  ; Division entre 10, para aislar el ultimo digito
            add ah, 30h ; convertir el digito aislado(residuo de div en DX) a ASCII
            mov [num_str1+si], ah   ; mover a la posicion indexada el numero ASCII
            ; (Limpieza de registros)
            mov ah, 0
            ; (Llamada recursiva)
            jmp parse_integer
        
        parse_endpoint: ; Punto final de conversion (Limpia los registros usados)
            mov ax, 0
            mov bx, 0
            mov cx, 0
            mov dx, 0

        ret
    ; -----------------------------|'printout(num[&DX])'|-----------------------------
    printout:
        mov ah, 09h     ; mueve al AH la instruccion para mostrar en pantalla(09H) el contenido en DX
        int 21h

        ret
    ;------------------------------------------------------------------------------------------
    EXIT:   ; Fin del programa
        mov ah,4ch  ; Finaliza el programa
        int 21h     ; Llama el kernel (interrumpe)
end     ; Indica el final del codigo para el ensamblador