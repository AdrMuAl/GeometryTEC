.MODEL SMALL
.STACK 100H
.DATA
    msgWelcome DB '******************************************', 0Dh, 0Ah, '$'
               DB 'Bienvenido a GeometryTec', 0Dh, 0Ah, '$'
    msgPrompt DB 0Dh, 0Ah, 'Por favor indique a que figura desea calcular su area y perimetro:', 0Dh, 0Ah, '$'
    msgOptions DB 0Dh, 0Ah, 'Presione:', 0Dh, 0Ah
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
    promptSize1 DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado: $'
    promptSize2 DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la base: $'
    promptSize3 DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la altura: $'
    promptRadius DB 0Dh, 0Ah, 'Por favor ingrese el tamano del radio: $'
    promptBaseMinor DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la base menor: $'
    promptBaseMajor DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la base mayor: $'
    msgArea DB 0Dh, 0Ah, 'El area es: $'
    msgPerimeter DB 0Dh, 0Ah, 'El perimetro es: $'
    inputBuffer DB 6 DUP('$')   ; Buffer para almacenar la entrada del usuario (máx 5 dígitos + null)
    intValue DW 0              ; Para almacenar el valor convertido a entero
    area DW 0                  ; Variable para el área
    perimeter DW 0             ; Variable para el perímetro

.CODE
START:
    ; Inicializa el segmento de datos
    MOV AX, @DATA
    MOV DS, AX

    ; Imprime el mensaje de bienvenida
    LEA DX, msgWelcome
    MOV AH, 09H
    INT 21H

SELECCIONAR_FIGURA:
    ; Imprime el mensaje solicitando la figura
    LEA DX, msgPrompt
    MOV AH, 09H
    INT 21H

    ; Imprime las opciones
    LEA DX, msgOptions
    MOV AH, 09H
    INT 21H

    ; Lee la opción seleccionada por el usuario
    MOV AH, 01H
    INT 21H
    SUB AL, '0'        ; Convierte el carácter leído a un número

    ; Verificación de la opción seleccionada
    CMP AL, 1
    JL INVALID_OPTION_JUMP  ; Si es menor que 1, es inválido
    CMP AL, 9
    JG INVALID_OPTION_JUMP  ; Si es mayor que 9, es inválido

    ; Si es válido, continúa con la lectura del tamaño del lado
    CMP AL, 1
    JE CALC_CUADRADO_JUMP
    CMP AL, 2
    JE CALC_RECTANGULO_JUMP
    CMP AL, 3
    JE CALC_TRIANGULO_JUMP
    CMP AL, 4
    JE CALC_ROMBO_JUMP
    CMP AL, 5
    JE CALC_PENTAGONO_JUMP
    CMP AL, 6
    JE CALC_HEXAGONO_JUMP
    CMP AL, 7
    JE CALC_CIRCULO_JUMP
    CMP AL, 8
    JE CALC_TRAPECIO_JUMP
    CMP AL, 9
    JE CALC_PARALELOGRAMO_JUMP

INVALID_OPTION_JUMP:
    JMP INVALID_OPTION

CALC_CUADRADO_JUMP:
    JMP CALC_CUADRADO

CALC_RECTANGULO_JUMP:
    JMP CALC_RECTANGULO

CALC_TRIANGULO_JUMP:
    JMP CALC_TRIANGULO

CALC_ROMBO_JUMP:
    JMP CALC_ROMBO

CALC_PENTAGONO_JUMP:
    JMP CALC_PENTAGONO

CALC_HEXAGONO_JUMP:
    JMP CALC_HEXAGONO

CALC_CIRCULO_JUMP:
    JMP CALC_CIRCULO

CALC_TRAPECIO_JUMP:
    JMP CALC_TRAPECIO

CALC_PARALELOGRAMO_JUMP:
    JMP CALC_PARALELOGRAMO

INVALID_OPTION:
    ; Imprime mensaje de opción inválida
    LEA DX, msgInvalid
    MOV AH, 09H
    INT 21H
    JMP SELECCIONAR_FIGURA

; Cálculo para Cuadrado
CALC_CUADRADO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    ; Espera el ingreso del usuario
    CALL WAIT_FOR_ENTER

    ; Convertir la entrada a número entero
    CALL CONVERT_INT_INPUT
    MOV AX, intValue        ; AX = lado
    MUL AX                  ; AX = lado * lado
    MOV area, AX            ; Almacena el área
    MOV AX, intValue        ; Recupera el valor original
    ADD AX, AX              ; AX = 2 * lado
    ADD AX, AX              ; AX = 4 * lado
    MOV perimeter, AX       ; Almacena el perímetro
    JMP DISPLAY_RESULTS     ; Muestra los resultados

; Cálculo para Rectángulo
CALC_RECTANGULO:
    LEA DX, promptSize2
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = base
    MOV BX, AX        ; BX = base

    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV CX, intValue  ; CX = altura

    ; Calcular área y perímetro
    MUL CX             ; AX = base * altura
    MOV area, AX       ; Almacena el área
    ADD BX, CX         ; BX = base + altura
    ADD BX, BX         ; BX = 2 * (base + altura)
    MOV perimeter, BX  ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Triángulo Equilátero
CALC_TRIANGULO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = lado
    MOV BX, AX        ; BX = lado
    MUL BX            ; AX = lado * lado
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    ADD AX, AX        ; AX = 2 * lado
    ADD AX, BX        ; AX = 3 * lado
    MOV perimeter, AX ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Rombo
CALC_ROMBO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = lado
    MOV BX, AX        ; BX = lado
    MUL BX            ; AX = lado * lado
    MOV area, AX      ; Almacena el área
    ADD AX, BX        ; AX = 2 * lado
    ADD AX, BX        ; AX = 4 * lado
    MOV perimeter, AX ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Pentágono
CALC_PENTAGONO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = lado
    MOV BX, AX        ; BX = lado
    MUL BX            ; AX = lado * lado
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    MOV CX, 5
    MUL CX              ; AX = AX * 5 (5 * lado)
    MOV perimeter, AX   ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Hexágono
CALC_HEXAGONO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = lado
    MOV BX, AX        ; BX = lado
    MUL BX            ; AX = lado * lado
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    MOV CX, 6
    MUL CX              ; AX = AX * 6 (6 * lado)
    MOV perimeter, AX   ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Círculo
CALC_CIRCULO:
    LEA DX, promptRadius
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = radio
    MOV BX, AX        ; BX = radio
    MUL BX            ; AX = radio * radio
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    ADD AX, AX        ; Simplificando la multiplicación por 2 * PI (usando PI ≈ 3.14)
    ADD AX, AX
    MOV perimeter, AX   ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Trapecio
CALC_TRAPECIO:
    LEA DX, promptBaseMajor
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = base mayor
    MOV BX, AX          ; BX = base mayor

    LEA DX, promptBaseMinor
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV CX, intValue  ; CX = base menor

    ADD BX, CX          ; BX = base mayor + base menor

    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV CX, intValue  ; CX = altura

    ; Calcular área y perímetro
    MUL CX             ; AX = (base mayor + base menor) * altura
    MOV area, AX       ; Almacena el área
    ADD BX, BX         ; Doble la suma de las bases
    MOV perimeter, BX  ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Paralelogramo
CALC_PARALELOGRAMO:
    LEA DX, promptSize2
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV AX, intValue  ; AX = base
    MOV BX, AX          ; BX = base

    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER
    CALL CONVERT_INT_INPUT
    MOV CX, intValue  ; CX = altura

    ; Calcular área y perímetro
    MUL CX             ; AX = base * altura
    MOV area, AX       ; Almacena el área
    ADD BX, CX         ; BX = base + altura
    ADD BX, BX         ; BX = 2 * (base + altura)
    MOV perimeter, BX  ; Almacena el perímetro
    JMP DISPLAY_RESULTS

DISPLAY_RESULTS:
    ; Mostrar el área
    LEA DX, msgArea
    MOV AH, 09H
    INT 21H

    MOV AX, area           ; AX contiene el área
    CALL PRINT_NUMBER      ; Imprime AX directamente

    ; Mostrar el perímetro
    LEA DX, msgPerimeter
    MOV AH, 09H
    INT 21H

    MOV AX, perimeter      ; AX contiene el perímetro
    CALL PRINT_NUMBER      ; Imprime AX directamente

    JMP PREGUNTAR_CONTINUAR

PREGUNTAR_CONTINUAR:
    ; Pregunta al usuario si desea continuar o salir
    LEA DX, msgContinue
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, '0'        ; Convierte el carácter leído a un número

    CMP AL, 1
    JNE NOT_CONTINUE
    JMP SELECCIONAR_FIGURA

NOT_CONTINUE:
    CMP AL, 2
    JNE PREGUNTAR_CONTINUAR

EXIT:
    ; Termina el programa
    MOV AH, 4CH
    INT 21H

; Rutina para esperar la tecla Enter
WAIT_FOR_ENTER PROC
    MOV AH, 0AH
    LEA DX, inputBuffer
    INT 21H
    RET
WAIT_FOR_ENTER ENDP

;  para convertir la entrada a número entero en intValue
CONVERT_INT_INPUT PROC
    XOR AX, AX
    XOR BX, BX
    MOV SI, OFFSET inputBuffer

    ; Procesa los dígitos
    INT_CONVERT_LOOP:
        MOV AL, [SI]
        CMP AL, '$'
        JE CONVERT_DONE
        SUB AL, '0'
        MOV AH, 0       ; Asegrar que AH esté limpio antes de multiplicar
        MOV CX, 10
        MUL CX
        ADD BX, AX
        INC SI
        JMP INT_CONVERT_LOOP

    CONVERT_DONE:
        MOV intValue, BX
        RET
CONVERT_INT_INPUT ENDP

; Rutina para imprimir un número en formato decimal desde AX
PRINT_NUMBER PROC
    MOV CX, 0           ; Contador de dígitos
    MOV BX, 10          ; Divisor
    MOV DX, 0           ; Inicializa el resto en 0
    MOV DI, OFFSET inputBuffer + 5 ; Apunta al final del buffer

    ; Recorre el número
    PRINT_LOOP:
        XOR DX, DX      ; Limpia DX
        DIV BX          ; Divide AX por 10, DX tiene el resto
        ADD DL, '0'     ; Convierte el dígito a ASCII
        DEC DI          ; Mueve el índice en el buffer
        MOV [DI], DL    ; Guarda el carácter en el buffer
        INC CX          ; Incrementa el contador de dígitos
        CMP AX, 0
        JNZ PRINT_LOOP  ; Repite si no hemos procesado todos los dígitos

    ; Imprime el número resultante
    MOV DX, DI
    MOV AH, 09H
    INT 21H
    RET
PRINT_NUMBER ENDP

END START
