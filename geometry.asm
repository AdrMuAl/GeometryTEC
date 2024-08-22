.MODEL SMALL
.STACK 100H
.DATA
    ; Definición de los mensajes que se mostrarán
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
    promptSize1 DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado: $'
    promptSize2 DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la base: $'
    promptSize3 DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la altura: $'
    promptRadius DB 0Dh, 0Ah, 'Por favor ingrese el tamano del radio: $'
    promptBaseMinor DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la base menor: $'
    promptBaseMajor DB 0Dh, 0Ah, 'Por favor ingrese el tamano de la base mayor: $'
    msgArea DB 0Dh, 0Ah, 'El area es: $'
    msgPerimeter DB 0Dh, 0Ah, 'El perimetro es: $'
    inputBuffer DB 20 DUP('$')   ; Buffer para almacenar la entrada del usuario
    resultBuffer DB 6 DUP(0)     ; Buffer para almacenar el resultado como cadena (5 dígitos + null)
    floatValue DW 0              ; Para almacenar el valor convertido a punto flotante
    area DW 0                    ; Variable para el área
    perimeter DW 0               ; Variable para el perímetro

.CODE
START:
    ; Inicializa el segmento de datos
    MOV AX, @DATA
    MOV DS, AX

    ; Imprime el mensaje de bienvenida
    LEA DX, msgWelcome
    MOV AH, 09H
    INT 21H

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
    JMP START           ; Regresa al inicio para intentar de nuevo

; Cálculo para Cuadrado
CALC_CUADRADO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    ; Espera el ingreso del usuario
    CALL WAIT_FOR_ENTER

    ; Convertir la entrada a número (vamos a simplificar aquí)
    ; Asumiendo que el valor se ingresa correctamente como un número de 1 a 5 dígitos
    LEA DI, inputBuffer + 2   ; +2 para omitir la longitud de la cadena en inputBuffer
    XOR CX, CX                ; Reinicia el contador de dígitos
    XOR AX, AX                ; Limpia AX

CONVERT_INPUT:
    MOV AL, [DI]              ; Toma el siguiente carácter
    CMP AL, '$'               ; Verifica si es el final de la cadena
    JE CONVERT_DONE           ; Salta si es el final
    SUB AL, '0'               ; Convierte el carácter en un número
    JMP CONVERT_DONE         ; Repite

CONVERT_DONE:
    MOV floatValue, AX        ; Almacena el valor del lado

    ; Ahora, realiza el cálculo del área y perímetro
    MOV AX, floatValue        ; AX = lado
    IMUL AX                   ; AX = lado * lado
    MOV area, AX              ; Almacena el área
    MOV AX, floatValue        ; Recupera el valor original
    ADD AX, AX                ; AX = 2 * lado
    ADD AX, AX                ; AX = 4 * lado
    MOV perimeter, AX         ; Almacena el perímetro
    JMP DISPLAY_RESULTS       ; Muestra los resultados


; Cálculo para Rectángulo
CALC_RECTANGULO:
    LEA DX, promptSize2
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    ; Conversión de base a número
    MOV AX, floatValue  ; AX = base
    MOV BX, AX          ; BX = base
    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H
    CALL WAIT_FOR_ENTER

    ; Leer altura
    MOV CX, floatValue  ; CX = altura
    IMUL CX             ; AX = AX * CX (base * altura)
    MOV area, AX        ; Almacena el área
    ADD BX, CX
    ADD BX, BX          ; BX = 2 * (base + altura)
    MOV perimeter, BX   ; Almacena el perímetro
    JMP DISPLAY_RESULTS

; Cálculo para Triángulo Equilátero
CALC_TRIANGULO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    ; Conversión y cálculo del área y perímetro para triángulo
    MOV AX, floatValue  ; AX = lado
    IMUL AX             ; AX = AX * AX (lado * lado)
    MOV area, AX
    MOV AX, floatValue
    ADD AX, AX          ; AX = 2 * lado
    ADD AX, floatValue  ; AX = 3 * lado
    MOV perimeter, AX
    JMP DISPLAY_RESULTS

; Cálculo para Rombo
CALC_ROMBO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    ; Conversión y cálculo del área y perímetro para rombo
    MOV AX, floatValue  ; AX = lado
    IMUL AX             ; AX = AX * AX (lado * lado)
    MOV area, AX
    ADD AX, AX          ; AX = 2 * lado
    ADD AX, AX          ; AX = 4 * lado
    MOV perimeter, AX
    JMP DISPLAY_RESULTS

; Cálculo para Pentágono
CALC_PENTAGONO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    ; Conversión y cálculo del área y perímetro para pentágono
    MOV AX, floatValue  ; AX = lado
    IMUL AX             ; AX = AX * AX (lado * lado)
    MOV area, AX
    MOV AX, floatValue
    MOV CX, 5
    IMUL CX             ; AX = AX * 5 (5 * lado)
    MOV perimeter, AX
    JMP DISPLAY_RESULTS

; Cálculo para Hexágono
CALC_HEXAGONO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    ; Conversión y cálculo del área y perímetro para hexágono
    MOV AX, floatValue  ; AX = lado
    IMUL AX             ; AX = AX * AX (lado * lado)
    MOV area, AX
    MOV AX, floatValue
    MOV CX, 6
    IMUL CX             ; AX = AX * 6 (6 * lado)
    MOV perimeter, AX
    JMP DISPLAY_RESULTS

; Cálculo para Círculo
CALC_CIRCULO:
    LEA DX, promptRadius
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    ; Conversión y cálculo del área y perímetro para círculo
    MOV AX, floatValue  ; AX = radio
    IMUL AX             ; AX = AX * AX (radio * radio)
    MOV area, AX
    ; Asumimos PI = 3 para simplificar cálculos
    MOV CX, 3
    IMUL CX             ; AX = AX * 3 (3 * radio)
    MOV perimeter, AX
    JMP DISPLAY_RESULTS

; Cálculo para Trapecio
CALC_TRAPECIO:
    LEA DX, promptBaseMajor
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    MOV AX, floatValue  ; AX = base mayor
    MOV BX, AX          ; BX = base mayor
    LEA DX, promptBaseMinor
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    MOV CX, floatValue  ; CX = base menor
    ADD BX, CX          ; BX = base mayor + base menor
    MOV AX, BX          ; AX = base mayor + base menor
    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    MOV CX, floatValue  ; CX = altura
    IMUL CX             ; AX = AX * CX ((base mayor + base menor) * altura)
    MOV area, AX        ; Almacena el área
    ADD BX, BX          ; Doble la suma de las bases
    MOV perimeter, BX
    JMP DISPLAY_RESULTS

; Cálculo para Paralelogramo
CALC_PARALELOGRAMO:
    LEA DX, promptSize2
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    MOV AX, floatValue  ; AX = base
    MOV BX, AX          ; BX = base
    LEA DX, promptSize3
    MOV AH, 09H
    INT 21H

    CALL WAIT_FOR_ENTER

    MOV CX, floatValue  ; CX = altura
    IMUL CX             ; AX = AX * CX (base * altura)
    MOV area, AX        ; Almacena el área
    ADD BX, CX
    ADD BX, BX          ; BX = 2 * (base + altura)
    MOV perimeter, BX   ; Almacena el perímetro
    JMP DISPLAY_RESULTS

DISPLAY_RESULTS:
    ; Mostrar el área
    LEA DX, msgArea
    MOV AH, 09H
    INT 21H

    MOV AX, area           ; AX contiene el área
    CALL NUM_TO_STRING     ; Convierte AX en una cadena de texto en resultBuffer
    LEA DX, resultBuffer   ; Apunta DX al buffer de resultado
    MOV AH, 09H
    INT 21H

    ; Mostrar el perímetro
    LEA DX, msgPerimeter
    MOV AH, 09H
    INT 21H

    MOV AX, perimeter      ; AX contiene el perímetro
    CALL NUM_TO_STRING     ; Convierte AX en una cadena de texto en resultBuffer
    LEA DX, resultBuffer   ; Apunta DX al buffer de resultado
    MOV AH, 09H
    INT 21H

    JMP START  ; Regresa al inicio para otra operación o salida

; Rutina para esperar la tecla Enter
WAIT_FOR_ENTER PROC
    MOV AH, 0AH
    LEA DX, inputBuffer
    INT 21H
    RET
WAIT_FOR_ENTER ENDP

; Rutina para convertir número en AX a cadena de texto en resultBuffer
NUM_TO_STRING PROC
    MOV BX, 10             ; Divisor para extraer cada dígito
    XOR CX, CX             ; Reinicia el contador de dígitos
    MOV DI, OFFSET resultBuffer + 5 ; Apunta al final del buffer

    ; Rutina para extraer cada dígito
CONVERT_LOOP:
    XOR DX, DX             ; Limpia DX
    DIV BX                 ; Divide AX por 10, DX contiene el resto (dígito actual)
    ADD DL, '0'            ; Convierte el dígito a su representación ASCII
    DEC DI                 ; Retrocede una posición en el buffer
    MOV [DI], DL           ; Almacena el dígito en el buffer
    INC CX                 ; Incrementa el contador de dígitos
    CMP AX, 0
    JNZ CONVERT_LOOP       ; Repite mientras AX no sea 0

    ; Ajusta el puntero DI para apuntar al primer dígito en el buffer
    LEA SI, resultBuffer + 5
    SUB SI, CX
    MOV DI, OFFSET resultBuffer
    MOV CX, 5

    ; Llena con espacios si es necesario
    MOV AL, ' '
    REP STOSB

    ; Copia los dígitos reales al principio del buffer
    MOV CX, 5
    REP MOVSB

    ; Termina con null (opcional)
    MOV BYTE PTR [DI], '$' ; Finaliza la cadena
    RET
NUM_TO_STRING ENDP

END START

