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
    CALL READ_NUMBER_NEW

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

    CALL READ_NUMBER_NEW
    MOV AX, intValue  ; AX = base
    MOV BX, AX        ; BX = base

    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV CX, intValue  ; CX = altura

    ; Calcular área y perímetro
    MUL CX             ; AX = base * altura
    MOV area, AX       ; Almacena el área
    ADD BX, CX         ; BX = base + altura
    ADD BX, BX         ; BX = 2 * (base + altura)
    MOV perimeter, BX  ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Rutinas para las otras figuras geométricas:
; Se implementan de forma similar a las anteriores,
; con la lógica específica para cada figura.

; Cálculo para Triángulo Equilátero
CALC_TRIANGULO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV AX, intValue  ; AX = lado
    MOV BX, AX        ; BX = lado
    MUL BX            ; AX = lado * lado
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    MOV CX, 3
    MUL CX              ; AX = lado * 3
    MOV perimeter, AX ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Rombo
CALC_ROMBO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV AX, intValue  ; AX = lado
    MOV BX, AX        ; BX = lado
    MUL BX            ; AX = lado * lado
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    MOV CX, 4
    MUL CX              ; AX = lado * 4
    MOV perimeter, AX ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Pentágono
CALC_PENTAGONO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
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

    CALL READ_NUMBER_NEW
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

    CALL READ_NUMBER_NEW
    MOV AX, intValue  ; AX = radio
    MOV BX, AX        ; BX = radio
    MUL BX            ; AX = radio * radio
    MOV area, AX      ; Almacena el área
    MOV AX, intValue
    MOV CX, 2
    MUL CX            ; AX = 2 * radio
    ADD AX, AX        ; AX = 4 * radio (Simplificando la multiplicación por π ≈ 3.14)
    MOV perimeter, AX ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Trapecio
CALC_TRAPECIO:
    LEA DX, promptBaseMajor
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV AX, intValue  ; AX = base mayor
    MOV BX, AX        ; BX = base mayor

    LEA DX, promptBaseMinor
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV CX, intValue  ; CX = base menor

    ADD BX, CX        ; BX = base mayor + base menor

    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV CX, intValue  ; CX = altura

    ; Calcular área
    MUL CX            ; AX = (base mayor + base menor) * altura
    MOV area, AX      ; Almacena el área
    ADD BX, BX        ; Doble la suma de las bases
    MOV perimeter, BX ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Paralelogramo
CALC_PARALELOGRAMO:
    LEA DX, promptSize2
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV AX, intValue  ; AX = base
    MOV BX, AX        ; BX = base

    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
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

; Nueva Rutina para leer un número entero del usuario
READ_NUMBER_NEW PROC
    XOR AX, AX         ; Limpia el registro AX
    XOR BX, BX         ; Limpia el registro BX

READ_LOOP_NEW:
    MOV AH, 01H        ; Llama a INT 21H para leer un carácter
    INT 21H
    CMP AL, 0Dh        ; Verifica si se presionó Enter
    JE END_READ_LOOP_NEW
    SUB AL, '0'        ; Convierte el carácter leído a un número
    MUL BX             ; AX = AX * BX (AX se mantiene en 0)
    ADD AX, BX         ; Acumula el valor del dígito en AX
    ADD BX, AX         ; Multiplica el valor en BX por 10 para la siguiente iteración
    JMP READ_LOOP_NEW

END_READ_LOOP_NEW:
    MOV intValue, AX   ; Almacena el valor final en intValue
    RET
READ_NUMBER_NEW ENDP

; Rutina para imprimir un número en formato decimal desde AX
PRINT_NUMBER PROC
    MOV CX, 0           ; Contador de dígitos
    MOV BX, 10          ; Divisor

    ; Recorre el número
PRINT_LOOP:
    XOR DX, DX          ; Limpia DX
    DIV BX              ; Divide AX por 10, DX tiene el resto
    ADD DL, '0'         ; Convierte el dígito a ASCII
    PUSH DX             ; Almacena el dígito en la pila
    INC CX              ; Incrementa el contador de dígitos
    CMP AX, 0
    JNZ PRINT_LOOP      ; Repite si no hemos procesado todos los dígitos

    ; Imprime los dígitos en orden
PRINT_DIGITS:
    POP DX              ; Recupera los dígitos
    MOV AH, 02H         ; Función para mostrar un carácter
    INT 21H
    LOOP PRINT_DIGITS

    RET
PRINT_NUMBER ENDP

END START
