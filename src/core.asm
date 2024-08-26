.MODEL SMALL
.STACK 100H
.DATA   ; Seccion para declarar variables necesarias del programa
; >>> Variables para 'strings' y mensajes
    ; ||| Prompts del programa |||
    ; {Mensajes de la interfaz}
    msgWelcome DB '******************************************', 0Dh, 0Ah, '$'
               DB 'Bienvenido a GeometryTec', 0Dh, 0Ah, '$'
    msgPrompt DB 0Dh, 0Ah, 'Por favor indique a que figura desea calcular su area y perimetro:', 0Dh, 0Ah, '$'
    msgOptions  DB 0Dh, 0Ah, 'Presione:', 0Dh, 0Ah
                DB '1. Para Cuadrado.', 0Dh, 0Ah
                DB '2. Para Rectangulo.', 0Dh, 0Ah
                DB '3. Para Triangulo Equilatero.', 0Dh, 0Ah
                DB '4. Para Rombo.', 0Dh, 0Ah
                DB '5. Para Pentagono.', 0Dh, 0Ah
                DB '6. Para Hexagono.', 0Dh, 0Ah
                DB '7. Para Circulo.', 0Dh, 0Ah
                DB '8. Para Trapecio.', 0Dh, 0Ah
                DB '9. Para Paralelogramo.', 0Dh, 0Ah, '$'
    msgInvalid DB 0Dh, 0Ah, 'Opcion invalida. Intente de nuevo.', 0Dh, 0Ah, '$'
    msgContinue DB 0Dh, 0Ah, 'Por favor presione:', 0Dh, 0Ah
                 DB '1. Para Continuar.', 0Dh, 0Ah
                 DB '2. Para Salir.', 0Dh, 0Ah, '$'
    ; {Solicitud de inputs}
    promptSize1 DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado: $'
    promptLargo DB 0Dh, 0Ah, 'Por favor ingrese el largo del rectangulo: $'
    promptAncho DB 0Dh, 0Ah, 'Por favor ingrese el ancho del rectangulo: $'
    promptBase DB 0Dh, 0Ah, 'Por favor ingrese la base del triangulo: $'
    promptAltura DB 0Dh, 0Ah, 'Por favor ingrese la altura del triangulo: $'
    promptLadoRombo DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado del rombo: $'
    promptDiagonalMayor DB 0Dh, 0Ah, 'Por favor ingrese la diagonal mayor del rombo: $'
    promptDiagonalMenor DB 0Dh, 0Ah, 'Por favo r ingrese la diagonal menor del rombo: $'
    promptLadoPentagono DB 0Dh, 0Ah, 'Por favor ingrese la medida del lado del pentagono: $'
    promptApotema DB 0Dh, 0Ah, 'Por favor ingrese la medida de la apotema del pentagono: $'
    promptLadoHexagono DB 0Dh, 0Ah, 'Por favor ingrese la medida del lado del hexagono: $'
    promptApotemaHexagono DB 0Dh, 0Ah, 'Por favor ingrese la medida de la apotema del hexagono: $'
    promptAlturaTrapecio DB 0Dh, 0Ah, 'Por favor ingrese la altura del trapecio: $'
    promptBaseMayorTrapecio DB 0Dh, 0Ah, 'Por favor ingrese la base mayor del trapecio: $'
    promptBaseMenorTrapecio DB 0Dh, 0Ah, 'Por favor ingrese la base menor del trapecio: $'
    promptLadoMenorTrapecio DB 0Dh, 0Ah, 'Por favor ingrese el lado menor del trapecio: $'
    promptAlturaParalelogramo DB 0Dh, 0Ah, 'Por favor ingrese la altura del paralelogramo: $'
    promptLadoParalelogramo DB 0Dh, 0Ah, 'Por favor ingrese el lado del paralelogramo: $'
    promptBaseParalelogramo DB 0Dh, 0Ah, 'Por favor ingrese la base del paralelogramo: $'

    ; ||| Ouputs de resultados |||
    msgArea DB 0Dh, 0Ah, 'El area es: ', 0Dh, 0Ah, '$'
    msgPerimeter DB 0Dh, 0Ah, 'El perimetro es: ', 0Dh, 0Ah, '$'

    num_str1 DB 0Dh, 0Ah, 5 dup(30h) , '.', 2 dup('0'), 0Dh, 0Ah ,'$'   ; arreglo de caracteres(8-bits c/a) para representar un flotante como string
        ; ^ '00000.00' este el string por default
    num_str2 DB 5 dup(30h) , '.', 2 dup('0'), '$'   ; arreglo secundario para manejar acarreo

; >>> Buffer de lectura y variables de almacenamiento
    rd_buffer DB 8  ; [1er byte]Tamaño del buffer/cadena
              DB 0  ; [2do byte]Caracteres leidos(inicialmente 0)
              DB 8 dup(0) ; [3er byte++]8 caracteres
    
    rd_num DW 0, 0  ; Aqui se guarda el numero leido por el buffer

; >>> Variables para parametros de operaciones aritmeticas basicas con flotantes
    param1 DW 0 , 0 ; arreglo de enteros (16-bits c/a) para partes de un flotante
    ;       ^INT1,^FLT1 => para indexar se multiplica el indice por 2 (bytes)
    param2 DW 0 , 0 ; arreglo de enteros (16-bits c/a) para partes de un flotante
    ;       ^INT2,^FLT2
    result DW 0 , 0 ; arreglo de enteros (16-bits c/a) para resultado de operacion entre flotantes
    ;       ^INT,^FLT
    aux DW 0, 0     ; arreglo de enteros (16-bits c/a) para guardar datos de manera temporal en operaciones

; >>> Variables para medidas de figuras y constantes
    ; [Constantes]
    pi DW 3, 14

    ; [Medidas de figuras]
    ; [1](Cuadrado)
        cuad_side DW 0, 0 
    ; [2](Rectangulo)
        rect_length DW 0, 0
        rect_width DW 0, 0
    ; [3](Triangulo)
        tri_base DW 0, 0
        tri_height DW 0, 0
    ; [4](Rombo)
        romb_side DW 0, 0
        romb_diag_m DW 0, 0 ; diagonal menor
        romb_diag_G DW 0, 0 ; diagonal Mayor
    ; [5](Pentagono)
        pent_side DW 0, 0
        pent_apot DW 0, 0   ; apotema
    ; [6](Hexagono)
        hex_side DW 0, 0
        hex_apot DW 0, 0    ; apotema
    ; [7](Circulo)
        circ_radius DW 0, 0
    ; [8](Trapecio)
        trap_height DW 0, 0
        trap_base_m DW 0, 0 ; base menor
        trap_base_G DW 0, 0 ; base Mayor
        trap_side_m DW 0, 0 ; lado menor
    ; [9](Paralelogramo)
        para_height DW 0, 0
        para_side DW 0, 0
        para_base DW 0, 0

    ; [Resultados]
    area DW 0, 0
    perimeter DW 0, 0
.CODE   ; Seccion del codigo ejecutable
; -----------------------[Codigo principal]-----------------------
START:
    MOV ax, @DATA
    MOV ds, ax    ; Inicializa el segmento de datos

    LEA dx, msgWelcome
    MOV ah, 09H
    INT 21H      ; Muestra el mensaje de bienvenida
SELECCIONAR_FIGURA:
    LEA dx, msgPrompt
    MOV ah, 09H
    INT 21H      ; Muestra el prompt para seleccionar la figura

    LEA dx, msgOptions
    MOV ah, 09H
    INT 21H      ; Muestra las opciones de figuras

    MOV ah, 01H
    INT 21H      ; Lee la opción seleccionada por el usuario
    SUB al, '0'  ; Convierte el carácter a un número

    ; Comparación de la opción seleccionada y saltos a la rutina correspondiente
    CMP al, 1
        JE CALC_CUADRADO_JUMP
    CMP al, 2
        JE CALC_RECTANGULO_JUMP
    CMP al, 3
        JE CALC_TRIANGULO_JUMP
    CMP al, 4
        JE CALC_ROMBO_JUMP
    CMP al, 5
        JE CALC_PENTAGONO_JUMP
    CMP al, 6
        JE CALC_HEXAGONO_JUMP
    CMP al, 8
        JE CALC_TRAPECIO_JUMP
    CMP al, 9
        JE CALC_PARALELOGRAMO_JUMP
    JMP INVALID_OPTION  ; Si no es ninguna opción válida, muestra error

    ; Llamadas a calculos
    CALC_CUADRADO_JUMP:
        JMP CALC_CUADRADO   ; Salta a la rutina para calcular cuadrado

    CALC_RECTANGULO_JUMP:
        ;JMP CALC_RECTANGULO ; Salta a la rutina para calcular rectángulo

    CALC_TRIANGULO_JUMP:
        ;JMP CALC_TRIANGULO  ; Salta a la rutina para calcular triángulo

    CALC_ROMBO_JUMP:
        ;JMP CALC_ROMBO      ; Salta a la rutina para calcular rombo
        
    CALC_PENTAGONO_JUMP:
        ;JMP CALC_PENTAGONO  ; Salta a la rutina para calcular pentágono

    CALC_HEXAGONO_JUMP:
        ;JMP CALC_HEXAGONO   ; Salta a la rutina para calcular hexágono

    CALC_TRAPECIO_JUMP:
        ;JMP CALC_TRAPECIO   ; Salta a la rutina para calcular trapecio
        
    CALC_PARALELOGRAMO_JUMP:
        ;JMP CALC_PARALELOGRAMO ; Salta a la rutina para calcular paralelogramo

    INVALID_OPTION:
        LEA dx, msgInvalid
        MOV ah, 09H
        INT 21H       ; Muestra un mensaje de opción inválida
        JMP SELECCIONAR_FIGURA ; Vuelve a pedir la selección de figura
; -----------------------[Codigo principal]-----------------------

; ________________________________________________________________
; Operaciones aritmeticas con flotantes: [AX,BX,DX]+[Valores en params]
addition: ; (INT1+INT2)+[(FLT1+FLT2)/100]
    ; 1. (Efectuar suma de las partes enteras)
        MOV ax, [param1]  ; AX = INT1
        ADD ax, [param2]  ; AX = INT1+INT2
        MOV [result], ax
            ; (Limpieza de registros)
            xor ax, ax
    ; 2. (Efectuar suma de las partes flotantes) 
        MOV ax, [param1+2]    ; AX = FLT1
        ADD ax, [param2+2]    ; AX = FLT1+FLT2
        ; (a)[Verificar digitos del flotante]
        MOV bx, 100
        XOR dx, dx
        DIV bx  ; AX = (FLT+FLT2)/100

        ADD [result], ax  ; Suma exceso del flotante a la parte entera
        MOV [result+2], dx  ; Mover el residuo a la parte decimal
        ; (b)[Limpieza de registros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
        ret
    ; -----------------------------|'subs()'|-----------------------------
    substract:  ; [100(INT1-INT2)+(FLT1-FLT2)]/100
    ; 1. (Efectuar resta de las partes enteras)
        MOV ax, [param1]; AX = INT1
        MOV bx, 100
        SUB ax, [param2]; AX = INT1-INT2
        MUL bx          ; AX = 100(INT1-INT2)
    ; 2. (Efectuar resta de las partes flotantes)
        XOR bx, bx
        MOV bx, [param1+2]  ; BX = FLT1
        SUB bx, [param2+2]  ; BX = FLT1-FLT2
    ; 3. (Sumar ambas partes y dividir entre 100)
        ADD ax, bx  ; AX = 100(INT1-INT2)+(FLT1-FLT2)
        XOR bx, bx  ; Limpiar registro

        MOV bx, 100
        XOR dx ,dx
        DIV bx      ; [100(INT1-INT2)+(FLT1-FLT2)]/100
        ; (a)[Identifcar donde se guardo el residuo de la division(la nueva parte flotante)]
        MOV [result], ax  ; Mover cociente(parte entera)
        MOV [result+2], dx ; Mover residuo(parte flotante)

        ; (b)[Limpiar registros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
        ret
    ; -----------------------------|'mult()'|-----------------------------
    multiply: ; [INT1*INT2]+[(INT1*FLT2)/100]+[(INT2*FLT1)/100]+[(FLT1*FLT2)/100^2]
    ; 1. (Efectuar multiplicacion de partes enteras)
        MOV ax, [param1]
        MOV bx, [param2]
        MUL bx          ; AX = INT1*INT2
        MOV [result], ax; Acumular las partes enteras
        ; (a)[limpiar registros]
            XOR ax, ax
            XOR bx, bx
    ; 2. (Efectuar multiplicacion entero1-flotante2 dividido entre 100)
        MOV ax, [param1]
        MOV bx, [param2+2]
        MUL bx      ; AX = INT1*FLT2

        XOR bx, bx  ; Limpiar registro completo
        MOV bx, 100
        XOR dx, dx 
        DIV bx      ; A? = (INT1*FLT2)/100
        ; (a)[Manipular residuo y cociente de la division]
        ADD [result], ax  ; Acumular las partes enteras
        ADD [result+2], dx ; Acumular las partes flotantes
        ; (b)[Limipiar registros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
    ; 3. (Efectuar multiplicacion entero2-flotante1 dividido entre 100)
        MOV ax, [param2]
        MOV bx, [param1+2]
        MUL bx      ; AX = INT2*FLT1

        XOR bx, bx  ; Limpiar registro completo
        MOV bx, 100 
        XOR dx, dx
        DIV bx      ; A? = (INT2*FLT1)/100
        ; (a)[Manipular residuo y cociente de la division]
        ADD [result], ax  ; Acumular las partes enteras
        ADD [result+2], dx ; Acumular las partes flotantes
        ; (b)[Limipiar registros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
    ; 4. (Efectuar multiplicacion flotante-flotante dividido entre 100*100)
        MOV ax, [param1+2]
        MOV bx, [param2+2]
        MUL bx  ; AX = FLT1*FLT2

        XOR bx, bx  ; Limpiar registro completo
        MOV bx, 100

        XOR dx, dx  ; Limpiar registro completo
        DIV bx  ; A? = (FLT1*FLT2)/100
        XOR dx, dx  ; Descartar residuo de division
        ; (b)[Volver a dividir y ,en este, caso acumular la parte entera y flotante]
        DIV bx

        ADD [result], ax  ; Acumular las partes enteras
        ADD [result+2], dx ; Acumular las partes flotantes
        ; (c)[Limpiar registros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
    ; 5. (Ajuste de parte flotante y agregado a parte entera)
        MOV ax, [result+2]  ; Dado que el flotante pudo haber terminado siendo de mas de dos digitos
        MOV bx, 100

        XOR dx, dx
        DIV bx  ; La division permite dejar dos digitos en la parte flotante total(residuo), el cociente seria el agregado a la parte entera
        ; (a)[Manipular el residuo y cociente adecuadamente]
        ADD [result], ax ; Sumar cociente(agregado) a la parte entera
        MOV [result+2], dx; Mover residuo a la parte flotante
        ; (b)[Limpiar registros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
        ret
    ; -----------------------------|'div()'|-----------------------------
    divide: ; [100(INT1)+FLT1]/[100(INT2)+FLT2]
    ; 1. (Calculo de dividendo)
        MOV ax, [param1]
        MOV bx, 100
        MUL bx  ; AX = INT1*100

        ADD ax, [param1+2]   ; AX = 100(INT1)+FLT1
        MOV [result], ax     ; Guardar dividendo
        ; (a)[Limpiar registros]
            XOR ax, ax
            XOR bx, bx
    ; 2. (Calculo del divisor)
        MOV ax, [param2]
        MOV bx, 100
        MUL bx  ; AX = INT2*100

        ADD ax, [param2+2] ; AX = 100(INT2)+FLT2
    ; 3. (Ejecutar divison)
        XOR bx, bx  ; Limpiar registro
        MOV bx, ax  ; Mover divisor: BX = AX
        XOR ax, ax  ; Limpiar registro
        MOV ax, [result]  ; Mover dividendo a AX

        XOR dx, dx
        DIV bx
        MOV [aux], bx ; Guardar el valor del divisor

        ; (a)[Ajuste de parte entera y flotante]
        XOR bx, bx ; Limpiar el registro completo
        MOV [result], ax    ; Mover cociente a la parte entera
        MOV ax, dx  ; Mover residuo a AX para obtener parte flotante
        XOR dx, dx  ; Limpiar registro

        MOV [aux+2], ax ; Guardar una referencia al valor original del residuo
        MOV bx, 10
        div_loop: ; Este ciclo permite dividir el residuo entre el divisor recursivamente hasta que el cociente sea de dos digitos
            MUL bx      ; Multiplicar residuo por multiplo de 10

            XOR dx, dx
            DIV [aux]   ; Dividir entre dividendo
            XOR dx, dx  ; Eliminar residuo

            MOV cx , ax ; Mover cociente a otro registro para evaluar total de digitos
            SUB cx, 10  ; Restar 10 al cociente
                jns div_loopend ; Si el numero es positivo ( 2 digitos) entonces se termina el ciclo
            
            XOR ax, ax  ; Limpiar registros
            XOR cx, cx

            MOV ax , bx 
            MUL bx ; AX = BX * BX
            MOV bx , ax

            MOV ax, [aux+2] ; Volver a traer el valor original del residuo
            jmp div_loop

        div_loopend:
        MOV [result+2], ax ; Movemos el nuevo flotante
        ; (b)[Limpiar registros]
            XOR ax, ax
            XOR bx, bx
            XOR cx, cx
        ret
; _______________________________________________________________________________________
;                     Calculos del Cuadrado
    CALC_CUADRADO:
        ; Mostrar mensaje en pantalla
        LEA dx, promptSize1
        MOV ah, 09H
        INT 21H
    ; PARTE NUEVA
        MOV ah, 0Ah
        LEA dx, rd_buffer
        INT 21H ; Solicita la entrada del usuario para la medida del lado

        MOV si, offset rd_buffer+2    ; Direccionar el buffer de entrada (omitimos los primeros dos bytes del buffer)
        MOV dl, [rd_buffer+1]         ; Guarda el tamano del input ingresado
        CALL READ_BUFFER_NUM      ; Interpreta el input como un numero

        MOV ax, [rd_num]
        MOV [cuad_side], ax     ; Mover parte entera
        XOR ax, ax

        MOV ax, [rd_num+2]
        MOV [cuad_side+2], ax   ; Mover parte flotante
        XOR ax, ax
        ; Limpiar numero interpretado del buffer
        MOV [rd_num], ax
        MOV [rd_num+2], ax

        ; Calcular perimtreo
            MOV ax, [cuad_side]
            MOV [param1], ax    ; Mover parte entera a un parametro
            MOV ax, [cuad_side+2]
            MOV [param1+2], ax  ; Mover parte flotante a un parametro

            MOV ax, 4
            MOV [param2], 4
            XOR ax, ax
            MOV [param2+2], ax

            CALL multiply   ; Ejecutamos la multiplicacion
            ; Mover resultado
            MOV ax, [result]
            MOV [perimeter], ax

            MOV ax, [result+2]
            MOV [perimeter+2], ax

            XOR ax, ax
            MOV [result], ax
            MOV [result+2], ax
        ; Calcular area
            MOV ax, [cuad_side]
            MOV [param1], ax
            MOV [param2], ax

            MOV ax, [cuad_side+2]
            MOV [param1+2], ax
            MOV [param2+2], ax

            XOR ax, ax
            CALL multiply
            ; Mover resultado
            MOV ax, [result]
            MOV [area], ax

            MOV ax, [result+2]
            MOV [area+2], ax
        ; Mostrar resultados
            ; LEA dx, msgPerimeter ; Perimeter
            ; MOV ah, 09h
            ; INT 21h

            MOV si, 0
            MOV bx, [perimeter]
            MOV ax, [perimeter+2]
            CALL PARSE

            LEA dx, [num_str1]
            CALL PRINTOUT
            CALL CLEAN_OUT_STR

            ; LEA dx, msgArea ; Area
            ; MOV ah, 09h
            ; INT 21h

            MOV si, 0
            MOV bx, [area]
            MOV ax, [area+2]
            CALL PARSE

            LEA dx, [num_str1]
            CALL PRINTOUT
            CALL CLEAN_OUT_STR
        JMP EXIT

    ; PARTE VIEJA
        ; ; Leer medida: lado
        ; CALL READ_NUMBER_NEW
        ; MOV intValue, AX

        ; ; Validar entrada
        ; CMP intValue, 0
        ; JLE INVALID_OPTION
        ; CMP intValue, 9999
        ; JG INVALID_OPTION

        ; MOV AX, intValue
        ; MOV BX, AX
        ; MUL BX
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], DX

        ; MOV AX, intValue
        ; ADD AX, AX
        ; ADD AX, AX
        ; MOV perimeter, AX

        ; JMP DISPLAY_RESULTS
; _______________________________________________________________________________________
;                     Calculos del Rectangulo
    CALC_RECTANGULO:
        ; LEA DX, promptLargo
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV largo, AX

        ; LEA DX, promptAncho
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV ancho, AX

        ; CMP largo, 0
        ; JLE INVALID_INPUT_RECT
        ; CMP largo, 9999
        ; JG INVALID_INPUT_RECT
        ; CMP ancho, 0
        ; JLE INVALID_INPUT_RECT
        ; CMP ancho, 9999
        ; JG INVALID_INPUT_RECT
        JMP CALC_RECT_AREA

    INVALID_INPUT_RECT:
        JMP INVALID_OPTION

    CALC_RECT_AREA:
        JMP SELECCIONAR_FIGURA
        ; MOV AX, largo
        ; MUL ancho
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], DX

        ; MOV AX, largo
        ; ADD AX, AX
        ; MOV BX, ancho
        ; ADD BX, BX
        ; ADD AX, BX
        ; MOV perimeter, AX

        ; JMP DISPLAY_RESULTS
; _______________________________________________________________________________________
;                     Calculos del Triangulo
    CALC_TRIANGULO:
        ; LEA DX, promptBase
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV base, AX

        ; LEA DX, promptAltura
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV altura, AX

        ; CMP base, 0
        ; JLE INVALID_INPUT_TRI
        ; CMP base, 9999
        ; JG INVALID_INPUT_TRI
        ; CMP altura, 0
        ; JLE INVALID_INPUT_TRI
        ; CMP altura, 9999
        ; JG INVALID_INPUT_TRI
        JMP CALC_TRI_AREA

    INVALID_INPUT_TRI:
        JMP INVALID_OPTION

    CALC_TRI_AREA:
        ; MOV AX, base
        ; MUL altura
        ; MOV BX, 2
        ; DIV BX
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], 0

        ; MOV AX, base
        ; MOV BX, 3
        ; MUL BX
        ; MOV perimeter, AX

        ; JMP DISPLAY_RESULTS
        JMP SELECCIONAR_FIGURA
; _______________________________________________________________________________________
;                     Calculos del Rombo
    CALC_ROMBO:
        ; LEA DX, promptLadoRombo
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV ladoRombo, AX

        ; LEA DX, promptDiagonalMayor
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV diagonalMayor, AX

        ; LEA DX, promptDiagonalMenor
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV diagonalMenor, AX

        ; CMP ladoRombo, 0
        ; JLE INVALID_INPUT_ROMBO
        ; CMP ladoRombo, 9999
        ; JG INVALID_INPUT_ROMBO
        ; CMP diagonalMayor, 0
        ; JLE INVALID_INPUT_ROMBO
        ; CMP diagonalMayor, 9999
        ; JG INVALID_INPUT_ROMBO
        ; CMP diagonalMenor, 0
        ; JLE INVALID_INPUT_ROMBO
        ; CMP diagonalMenor, 9999
        ; JG INVALID_INPUT_ROMBO
        JMP CALC_ROMBO_AREA

    INVALID_INPUT_ROMBO:
        JMP INVALID_OPTION

    CALC_ROMBO_AREA:
        ; MOV AX, diagonalMayor
        ; MUL diagonalMenor
        ; MOV BX, 2
        ; DIV BX
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], 0

        ; MOV AX, ladoRombo
        ; MOV BX, 4
        ; MUL BX
        ; MOV perimeter, AX

        ; JMP DISPLAY_RESULTS
        JMP SELECCIONAR_FIGURA
; _______________________________________________________________________________________
;                     Calculos del Pentagono
    CALC_PENTAGONO:
        ; LEA DX, promptLadoPentagono
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV ladoPentagono, AX

        ; LEA DX, promptApotema
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV apotema, AX

        ; CMP ladoPentagono, 0
        ; JLE INVALID_INPUT_PENT
        ; CMP ladoPentagono, 9999
        ; JG INVALID_INPUT_PENT
        ; CMP apotema, 0
        ; JLE INVALID_INPUT_PENT
        ; CMP apotema, 9999
        ; JG INVALID_INPUT_PENT
        JMP CALC_PENT_AREA

    INVALID_INPUT_PENT:
        JMP INVALID_OPTION

    CALC_PENT_AREA:
        ; ; Cálculo del perímetro: 5 * lado
        ; MOV AX, ladoPentagono
        ; MOV BX, 5
        ; MUL BX
        ; MOV perimeter, AX

        ; ; Cálculo del área: (Perímetro * Apotema) / 2
        ; MOV AX, perimeter
        ; MUL apotema
        ; MOV BX, 2
        ; DIV BX
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], DX

        ; JMP DISPLAY_RESULTS
        JMP SELECCIONAR_FIGURA
; _______________________________________________________________________________________
;                     Calculos del Hexagono
    CALC_HEXAGONO:
        ; LEA DX, promptLadoHexagono
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV ladoHexagono, AX

        ; LEA DX, promptApotemaHexagono
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV apotemaHexagono, AX

        ; CMP ladoHexagono, 0
        ; JLE INVALID_INPUT_HEX
        ; CMP ladoHexagono, 9999
        ; JG INVALID_INPUT_HEX
        ; CMP apotemaHexagono, 0
        ; JLE INVALID_INPUT_HEX
        ; CMP apotemaHexagono, 9999
        ; JG INVALID_INPUT_HEX
        JMP CALC_HEX_AREA

    INVALID_INPUT_HEX:
        JMP INVALID_OPTION

    CALC_HEX_AREA:
        ; ; Cálculo del perímetro: 6 * lado
        ; MOV AX, ladoHexagono
        ; MOV BX, 6
        ; MUL BX
        ; MOV perimeter, AX

        ; ; Cálculo del área: (Perímetro * Apotema) / 2
        ; MOV AX, perimeter
        ; MUL apotemaHexagono
        ; MOV BX, 2
        ; DIV BX
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], DX

        ; JMP DISPLAY_RESULTS
        JMP SELECCIONAR_FIGURA
; _______________________________________________________________________________________
;                     Calculos del Circulo
    CALC_CIRCULO:

; _______________________________________________________________________________________
;                     Calculos del Trapecio
    CALC_TRAPECIO:
        ; LEA DX, promptAlturaTrapecio
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV alturaTrapecio, AX

        ; LEA DX, promptBaseMayorTrapecio
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV baseMayorTrapecio, AX

        ; LEA DX, promptBaseMenorTrapecio
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV baseMenorTrapecio, AX

        ; LEA DX, promptLadoMenorTrapecio
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV ladoMenorTrapecio, AX

        ; CMP alturaTrapecio, 0
        ; JLE INVALID_INPUT_TRAP
        ; CMP alturaTrapecio, 9999
        ; JG INVALID_INPUT_TRAP
        ; CMP baseMayorTrapecio, 0
        ; JLE INVALID_INPUT_TRAP
        ; CMP baseMayorTrapecio, 9999
        ; JG INVALID_INPUT_TRAP
        ; CMP baseMenorTrapecio, 0
        ; JLE INVALID_INPUT_TRAP
        ; CMP baseMenorTrapecio, 9999
        ; JG INVALID_INPUT_TRAP
        ; CMP ladoMenorTrapecio, 0
        ; JLE INVALID_INPUT_TRAP
        ; CMP ladoMenorTrapecio, 9999
        ; JG INVALID_INPUT_TRAP
        JMP CALC_TRAP_AREA

    INVALID_INPUT_TRAP:
        JMP INVALID_OPTION

    CALC_TRAP_AREA:
        ; ; Cálculo del perímetro: (2*LADO MENOR)+BASE MAYOR+BASE MENOR
        ; MOV AX, ladoMenorTrapecio
        ; ADD AX, AX
        ; ADD AX, baseMayorTrapecio
        ; ADD AX, baseMenorTrapecio
        ; MOV perimeter, AX

        ; ; Cálculo del área: ((BASE MAYOR + BASE MENOR) * ALTURA) / 2
        
        ; ; Primero, sumamos BASE MAYOR + BASE MENOR
        ; MOV AX, baseMayorTrapecio
        ; ADD AX, baseMenorTrapecio
        
        ; ; Multiplicamos por ALTURA
        ; MUL alturaTrapecio  ; DX:AX = (BASE MAYOR + BASE MENOR) * ALTURA
        
        ; ; Dividimos por 2
        ; MOV BX, 2
        ; DIV BX  ; AX = ((BASE MAYOR + BASE MENOR) * ALTURA) / 2, DX = remainder

        ; ; Guardamos el resultado
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], DX  ; Guardamos el residuo en la parte alta por si acaso

        ; JMP DISPLAY_RESULTS
        JMP SELECCIONAR_FIGURA
; _______________________________________________________________________________________
;                     Calculos del Paralelogramo
    CALC_PARALELOGRAMO:
        ; LEA DX, promptAlturaParalelogramo
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV alturaParalelogramo, AX

        ; LEA DX, promptLadoParalelogramo
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV ladoParalelogramo, AX

        ; LEA DX, promptBaseParalelogramo
        ; MOV AH, 09H
        ; INT 21H
        ; CALL READ_NUMBER_NEW
        ; MOV baseParalelogramo, AX

        ; CMP alturaParalelogramo, 0
        ; JLE INVALID_INPUT_PARA
        ; CMP alturaParalelogramo, 9999
        ; JG INVALID_INPUT_PARA
        ; CMP ladoParalelogramo, 0
        ; JLE INVALID_INPUT_PARA
        ; CMP ladoParalelogramo, 9999
        ; JG INVALID_INPUT_PARA
        ; CMP baseParalelogramo, 0
        ; JLE INVALID_INPUT_PARA
        ; CMP baseParalelogramo, 9999
        ; JG INVALID_INPUT_PARA
        JMP CALC_PARA_AREA

    INVALID_INPUT_PARA:
        JMP INVALID_OPTION

    CALC_PARA_AREA:
        ; ; Cálculo del perímetro: (2*LADO)+(2*BASE)
        ; MOV AX, ladoParalelogramo
        ; ADD AX, AX
        ; MOV BX, baseParalelogramo
        ; ADD BX, BX
        ; ADD AX, BX
        ; MOV perimeter, AX

        ; ; Cálculo del área: BASE * ALTURA
        ; MOV AX, baseParalelogramo
        ; MUL alturaParalelogramo
        ; MOV WORD PTR [area], AX
        ; MOV WORD PTR [area+2], DX

        ; JMP DISPLAY_RESULTS
        JMP SELECCIONAR_FIGURA
; ________________________________________________________________
;                       Lecturas y escrituras
    READ_BUFFER_NUM PROC
        ; Inicializar registros
        XOR ax, ax
        XOR bx, bx 
        XOR cx, cx

        CMP dl, 0
            JZ buffer_end
        XOR dx, dx

        MOV ax, 0   ; Valor inicial de la parte entera
        MOV bl, 10
        buffer_integer_loop: ; Ciclo para procesar la parte entera del buffer
            MOV cl, [si]
            CMP cl, '.'
                JE buffer_integer_end  ; Si encontramos un punto decimal, procesar la parte decimal
            CMP cl, 0Dh        ; Fin de línea
                JE buffer_end
            CMP cl, 0Ah        ; Fin de línea
                JE buffer_end
            SUB cl, 30h        ; Convertir el carácter a un número
            XOR ch, ch

            MUL bl             ; Multiplicar por 10 los digitos convertidos, los mueve una posicion a la derecha
            ADD ax, cx         ; Añadir el nuevo digito
            MOV dx, ax         ; Guardar la lectura del entero
            INC si   ; Mover el puntero lectura
            JMP buffer_integer_loop

        buffer_integer_end: ; Ciclo para procesar la parte decimal del buffer
            MOV ax, 0   ; Valor incial de la parte decimal(flotante)
            MOV bh, 0   ; Contador de digitos para ajuste de decimal
            INC si  ; Mover el puntero de lectura despues del punto
        buffer_float_loop:
            MOV cl, [si]
            CMP cl, 0Dh
                JE buffer_float_end
            CMP cl, 0Ah
                JE buffer_float_end
            INC bh
            SUB cl, '0'
            XOR ch, ch
            
            MUL bl
            ADD ax, cx
            INC si
            JMP buffer_float_loop

        buffer_float_end:
            ; Ajuste para partes flotantes donde solo lee un digito
            CMP bh, 1
                JNZ buffer_no_fix
            MUL bl
            buffer_no_fix:
            MOV [rd_num+2], ax  ; Mover numero a la parte decimal
        buffer_end:
            MOV [rd_num], dx    ; Mover numero a la parte entera
            ; Limpieza de registros
            XOR ax, ax
            XOR bx, bx
            XOR cx, cx
            XOR dx, dx
        ret
    READ_BUFFER_NUM ENDP

    CLEAN_OUT_STR PROC
    ; Limpia el string de salida estandar para PARSE => num_str1
        ; RIGHT -> LEFT
        MOV ah, 30h ; Caracter '0'
        MOV si, 10
        clean_floats_loop:
            DEC si
            CMP si, 7  ; Posicion de la coma
                JZ clean_ints_loop

            MOV [num_str1+si], ah
            JMP clean_floats_loop

        clean_ints_loop:
            DEC si
            CMP si, 2   ; Posicion de caracter especial
                JZ clean_out

            MOV [num_str1+si], ah
            JMP clean_ints_loop

        clean_out:
        XOR ax, ax
        XOR si, si

        ret
    CLEAN_OUT_STR ENDP

    DISPLAY_RESULTS:
        ; LEA DX, msgArea
        ; MOV AH, 09H
        ; INT 21H        ; Muestra el mensaje "El área es:"

        ; MOV AX, WORD PTR [area]
        ; MOV DX, WORD PTR [area+2]
        ; CALL PARSE32   ; Convierte el valor del área a cadena para mostrarlo
        ; LEA DX, string1
        ; CALL PRINTOUT  ; Muestra el valor del área

        ; LEA DX, msgPerimeter
        ; MOV AH, 09H
        ; INT 21H        ; Muestra el mensaje "El perímetro es:"

        ; MOV AX, perimeter
        ; XOR DX, DX
        ; CALL PARSE32   ; Convierte el valor del perímetro a cadena para mostrarlo
        ; LEA DX, string1
        ; CALL PRINTOUT  ; Muestra el valor del perímetro

    PREGUNTAR_CONTINUAR:
        LEA DX, msgContinue
        MOV AH, 09H
        INT 21H        ; Pregunta si el usuario quiere continuar o salir

    LEER_OPCION:
        MOV AH, 01H
        INT 21H        ; Lee la opción del usuario
        SUB AL, '0'    ; Convierte el carácter a número

        CMP AL, 1
        JE CONTINUAR_PROGRAMA ; Si elige continuar, vuelve a la selección de figura
        CMP AL, 2
        JE EXIT     ; Si elige salir, termina el programa
        
        LEA DX, msgInvalid
        MOV AH, 09H
        INT 21H       ; Si no es ninguna opción válida, muestra error
        JMP PREGUNTAR_CONTINUAR ; Vuelve a preguntar

    CONTINUAR_PROGRAMA:
        JMP SELECCIONAR_FIGURA ; Vuelve a la selección de figura

    PRINTOUT PROC
        MOV ah, 09H
        INT 21H

        XOR ax, ax
        XOR dx, dx
        RET
    PRINTOUT ENDP
; ________________________________________________________________
;                       Parseo NUM > STR 
    PARSE32 PROC
    ;     PUSH BX
    ;     PUSH CX
    ;     PUSH SI
    ;     MOV SI, 9
    ;     MOV BX, 10
    ;     MOV CX, 0

    ; PARSE32_LOOP:
    ;     PUSH AX
    ;     MOV AX, DX
    ;     XOR DX, DX
    ;     DIV BX         ; Divide DX:AX por 10
    ;     MOV DI, AX
    ;     POP AX
    ;     DIV BX         ; Divide AX por 10
    ;     ADD DL, '0'    ; Convierte el residuo a carácter
    ;     MOV [string1+SI], DL
    ;     DEC SI
    ;     INC CX
    ;     MOV DX, DI     ; Pasa la parte alta de la división a DX
    ;     CMP AX, 0
    ;     JNZ PARSE32_LOOP ; Continua hasta que AX sea 0
    ;     CMP DX, 0
    ;     JNZ PARSE32_LOOP ; Continua hasta que DX sea 0

    ;     MOV AL, ' '
    ; FILL_SPACES:
    ;     CMP SI, -1
    ;     JE DONE_PARSING ; Si ya llenamos la cadena, terminamos
    ;     MOV [string1+SI], AL
    ;     DEC SI
    ;     JMP FILL_SPACES

    ; DONE_PARSING:
    ;     POP SI
    ;     POP CX
    ;     POP BX
    ;     RET
    PARSE32 ENDP

    PARSE PROC ; esta 'funcion' permite convertir el resultado de la operacion al 'string'
        MOV si, 10 ; Indice de 'numstr' donde se debe comenzar a escribir los flotantes
        MOV cx, 10  ; El valor de 10, permitir aislar uno los digitos de un numero, este aislamiento es el residuo de la division

        parse_float: ; Funcion recursiva
            ; (Caso base)
            CMP ax, 0; Verificar que ya no queden digitos distintos de cero por escribir
                JZ parse_midpoint
            ; (Operaciones)
            DEC si  ; decremento en indice para colocarse en la posicion adecuada
            DIV cx ; Division entre 10, para aislar el ultimo digito
            ADD dl, 30h ; convertir el digito aislado(residuo de div en DX) a ASCII
            MOV [num_str1+si], dl  ; mover a la posicion indexada el numero ASCII
            ; (Limpieza de registros)
            XOR dx, dx
            ; (Llamada recursiva)
            JMP parse_float

        parse_midpoint: ; Punto intermedio entre conversion de partes
            MOV si, 7   ; Mover el indice al inicio de los digitos de la parte entera
            MOV ax, bx  ; Mover la parte entera al registro AX para poder aislar los digitos 
            XOR bx, bx  ; Limpiar el registro que ya no se esta usado
            XOR dx, dx

        parse_integer: ; Funcion recursiva
            ; (Caso base)
            CMP ax, 0; Verificar que ya no queden digitos distintos de cero por escribir
                JZ parse_endpoint
            ; (Operaciones)
            DEC si  ; decremento en indice para colocarse en la posicion adecuada
            DIV cx  ; Division entre 10, para aislar el ultimo digito
            ADD dl, 30h ; convertir el digito aislado(residuo de div en DX) a ASCII
            MOV [num_str1+si], dl   ; mover a la posicion indexada el numero ASCII
            ; (Limpieza de registros)
            XOR dx, dx
            ; (Llamada recursiva)
            JMP parse_integer
        
        parse_endpoint: ; Punto final de conversion (Limpia los registros usados)
            XOR ax, ax
            XOR bx, bx
            XOR cx, cx
            XOR dx, dx
        ret
    PARSE ENDP

; ------------------------------[Fin del programa]------------------------------
EXIT:
    MOV ah, 4CH
    INT 21H       ; Termina el programa
END     ; Fin del codigo