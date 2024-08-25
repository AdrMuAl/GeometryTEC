.MODEL SMALL
.STACK 100H
.DATA
    msgWelcome DB '******************************************', 0Dh, 0Ah, '$'
               DB 'Bienvenido a GeometryTec', 0Dh, 0Ah, '$'
    msgPrompt DB 0Dh, 0Ah, 'Por favor indique a que figura desea calcular su area y perimetro:', 0Dh, 0Ah, '$'
    msgOptions DB 0Dh, 0Ah, 'Presione:', 0Dh, 0Ah
                DB '1. Para Cuadrado.', 0Dh, 0Ah
                DB '2. Para Rectangulo.', 0Dh, 0Ah, '$'
    msgInvalid DB 0Dh, 0Ah, 'Opcion invalida. Intente de nuevo.', 0Dh, 0Ah, '$'
    msgContinue DB 0Dh, 0Ah, 'Por favor presione:', 0Dh, 0Ah
                 DB '1. Para Continuar.', 0Dh, 0Ah
                 DB '2. Para Salir.', 0Dh, 0Ah, '$'
    promptSize1 DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado: $'
    promptLargo DB 0Dh, 0Ah, 'Por favor ingrese el largo del rectangulo: $'
    promptAncho DB 0Dh, 0Ah, 'Por favor ingrese el ancho del rectangulo: $'
    msgArea DB 0Dh, 0Ah, 'El area es: $'
    msgPerimeter DB 0Dh, 0Ah, 'El perimetro es: $'
    intValue DW 0              ; Para almacenar el valor convertido a entero (16 bits)
    largo DW 0                 ; Para almacenar el largo del rectángulo
    ancho DW 0                 ; Para almacenar el ancho del rectángulo
    area DD 0                  ; Variable para el área (32 bits)
    perimeter DW 0             ; Variable para el perímetro (16 bits)
    string1 DB 10 DUP(' '), '$' ; 10 espacios para la parte entera y terminador

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
    JE CALC_CUADRADO_JUMP
    CMP AL, 2
    JE CALC_RECTANGULO_JUMP

INVALID_OPTION:
    ; Imprime mensaje de opción inválida y regresa al menú
    LEA DX, msgInvalid
    MOV AH, 09H
    INT 21H
    JMP SELECCIONAR_FIGURA

CALC_CUADRADO_JUMP:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    ; Llamada a la rutina para leer el número
    CALL READ_NUMBER_NEW

    ; Validación de la entrada para asegurarse de que está en el rango 0-9999
    CMP intValue, 0
    JL INVALID_OPTION
    CMP intValue, 9999
    JG INVALID_OPTION

    ; Cálculo del área y perímetro
    MOV AX, intValue
    MOV BX, AX
    MUL BX            ; DX:AX = intValue * intValue (área)
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    MOV AX, intValue
    ADD AX, AX
    ADD AX, AX
    MOV perimeter, AX  ; perimeter = 4 * intValue

    ; Muestra los resultados
    JMP DISPLAY_RESULTS

CALC_RECTANGULO_JUMP:
    ; Leer el largo
    LEA DX, promptLargo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV largo, AX

    ; Leer el ancho
    LEA DX, promptAncho
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ancho, AX

    ; Validación de las entradas
    CMP largo, 0
    JLE INVALID_OPTION
    CMP largo, 9999
    JG INVALID_OPTION
    CMP ancho, 0
    JLE INVALID_OPTION
    CMP ancho, 9999
    JG INVALID_OPTION

    ; Cálculo del área del rectángulo
    MOV AX, largo
    MUL ancho          ; DX:AX = largo * ancho (área)
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ; Cálculo del perímetro del rectángulo
    MOV AX, largo
    ADD AX, AX         ; 2 * largo
    MOV BX, ancho
    ADD BX, BX         ; 2 * ancho
    ADD AX, BX         ; 2*largo + 2*ancho
    MOV perimeter, AX

    ; Muestra los resultados
    JMP DISPLAY_RESULTS

DISPLAY_RESULTS:
    ; Mostrar el área
    LEA DX, msgArea
    MOV AH, 09H
    INT 21H

    MOV AX, WORD PTR [area]
    MOV DX, WORD PTR [area+2]
    CALL PARSE32
    LEA DX, string1
    CALL PRINTOUT

    ; Mostrar el perímetro
    LEA DX, msgPerimeter
    MOV AH, 09H
    INT 21H

    MOV AX, perimeter
    XOR DX, DX
    CALL PARSE32
    LEA DX, string1
    CALL PRINTOUT

    JMP PREGUNTAR_CONTINUAR

PREGUNTAR_CONTINUAR:
    ; Pregunta al usuario si desea continuar o salir
    LEA DX, msgContinue
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, '0'

    CMP AL, 1
    JNE CHECK_EXIT
    JMP SELECCIONAR_FIGURA

CHECK_EXIT:
    CMP AL, 2
    JNE PREGUNTAR_CONTINUAR
    JMP EXIT

EXIT:
    ; Termina el programa
    MOV AH, 4CH
    INT 21H

READ_NUMBER_NEW PROC
    XOR BX, BX
    MOV CX, 10

READ_LOOP_NEW:
    MOV AH, 01H
    INT 21H
    CMP AL, 0Dh
    JE END_READ_LOOP_NEW
    CMP AL, '0'
    JL INVALID_INPUT
    CMP AL, '9'
    JG INVALID_INPUT
    SUB AL, '0'
    MOV AH, 0
    PUSH AX
    MOV AX, BX
    MUL CX
    JC OVERFLOW
    MOV BX, AX
    POP AX
    ADD BX, AX
    JC OVERFLOW
    JMP READ_LOOP_NEW

INVALID_INPUT:
    JMP READ_LOOP_NEW

OVERFLOW:
    MOV BX, 9999
    JMP END_READ_LOOP_NEW

END_READ_LOOP_NEW:
    MOV AX, BX  ; Devolver el valor en AX
    RET
READ_NUMBER_NEW ENDP

PARSE32 PROC
    PUSH BX
    PUSH CX
    PUSH SI
    MOV SI, 9
    MOV BX, 10
    MOV CX, 0

PARSE32_LOOP:
    PUSH AX            ; Guardar AX
    MOV AX, DX         ; Preparar para división de 32 bits
    XOR DX, DX
    DIV BX
    MOV DI, AX         ; Guardar cociente alto
    POP AX             ; Recuperar parte baja
    DIV BX             ; AX = cociente bajo, DX = residuo
    ADD DL, '0'        ; Convertir residuo a ASCII
    MOV [string1+SI], DL
    DEC SI
    INC CX
    MOV DX, DI         ; Preparar para siguiente iteración
    CMP AX, 0          ; Comparar AX con 0
    JNZ PARSE32_LOOP   
    CMP DX, 0          ; Comparar DX con 0
    JNZ PARSE32_LOOP   

    ; Ajustar la cadena
    MOV AL, ' '
FILL_SPACES:
    CMP SI, -1
    JE DONE_PARSING
    MOV [string1+SI], AL
    DEC SI
    JMP FILL_SPACES

DONE_PARSING:
    POP SI
    POP CX
    POP BX
    RET
PARSE32 ENDP

PRINTOUT PROC
    MOV AH, 09H
    INT 21H
    RET
PRINTOUT ENDP

END START
