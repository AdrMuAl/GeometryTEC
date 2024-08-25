.MODEL SMALL
.STACK 100H
.DATA
    msgWelcome DB '******************************************', 0Dh, 0Ah, '$'
               DB 'Bienvenido a GeometryTec', 0Dh, 0Ah, '$'
    msgPrompt DB 0Dh, 0Ah, 'Por favor indique a que figura desea calcular su area y perimetro:', 0Dh, 0Ah, '$'
    msgOptions DB 0Dh, 0Ah, 'Presione:', 0Dh, 0Ah
                DB '1. Para Cuadrado.', 0Dh, 0Ah, '$'
    msgInvalid DB 0Dh, 0Ah, 'Opcion invalida. Intente de nuevo.', 0Dh, 0Ah, '$'
    msgContinue DB 0Dh, 0Ah, 'Por favor presione:', 0Dh, 0Ah
                 DB '1. Para Continuar.', 0Dh, 0Ah
                 DB '2. Para Salir.', 0Dh, 0Ah, '$'
    promptSize1 DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado: $'
    msgArea DB 0Dh, 0Ah, 'El area es: $'
    msgPerimeter DB 0Dh, 0Ah, 'El perimetro es: $'
    intValue DW 0              ; Para almacenar el valor convertido a entero (16 bits)
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

    ; Llamada a la nueva rutina para leer el número
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

DISPLAY_RESULTS:
    ; Mostrar el área
    LEA DX, msgArea
    MOV AH, 09H
    INT 21H

    MOV AX, WORD PTR [area]
    MOV DX, WORD PTR [area+2]
    CALL PARSE32              ; Nueva rutina para convertir números de 32 bits
    LEA DX, string1
    CALL PRINTOUT

    ; Mostrar el perímetro
    LEA DX, msgPerimeter
    MOV AH, 09H
    INT 21H

    MOV AX, perimeter
    XOR DX, DX              ; Limpia DX para el perímetro (16 bits)
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
    SUB AL, '0'        ; Convierte el carácter leído a un número

    CMP AL, 1
    JNE CHECK_EXIT
    JMP SELECCIONAR_FIGURA

CHECK_EXIT:
    CMP AL, 2
    JNE PREGUNTAR_CONTINUAR  ; Si no es 1 ni 2, volver a preguntar
    JMP EXIT

EXIT:
    ; Termina el programa
    MOV AH, 4CH
    INT 21H

; Rutina para leer un número entero del usuario
READ_NUMBER_NEW PROC
    XOR BX, BX         ; Usa BX para acumular el resultado (16 bits)
    MOV CX, 10         ; Factor de multiplicación

READ_LOOP_NEW:
    MOV AH, 01H        ; Llama a INT 21H para leer un carácter
    INT 21H
    CMP AL, 0Dh        ; Verifica si se presionó Enter
    JE END_READ_LOOP_NEW
    CMP AL, '0'        ; Verifica si el carácter es menor que '0'
    JL INVALID_INPUT
    CMP AL, '9'        ; Verifica si el carácter es mayor que '9'
    JG INVALID_INPUT
    SUB AL, '0'        ; Convierte el carácter leído a un número
    MOV AH, 0          ; Limpia AH
    PUSH AX            ; Guarda el dígito
    MOV AX, BX         ; Mueve el valor acumulado a AX
    MUL CX             ; Multiplica por 10
    JC OVERFLOW        ; Salta si hay overflow
    MOV BX, AX         ; Guarda el resultado en BX
    POP AX             ; Recupera el dígito
    ADD BX, AX         ; Suma el dígito al valor acumulado
    JC OVERFLOW        ; Salta si hay overflow
    JMP READ_LOOP_NEW

INVALID_INPUT:
    ; Manejar entrada inválida
    JMP READ_LOOP_NEW

OVERFLOW:
    ; Manejar overflow
    MOV BX, 9999       ; Establecer el valor máximo permitido
    JMP END_READ_LOOP_NEW

END_READ_LOOP_NEW:
    MOV intValue, BX   ; Almacena el valor final en intValue
    RET
READ_NUMBER_NEW ENDP

; Nueva rutina para parsear un número de 32 bits en una cadena
PARSE32 PROC
    PUSH BX
    PUSH CX
    PUSH SI
    MOV SI, 9          ; Empezar desde el final de string1
    MOV BX, 10         ; Divisor
    MOV CX, 0          ; Contador de dígitos

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
    OR AX, DX          ; Verificar si quedan dígitos
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

; Rutina para imprimir una cadena en pantalla
PRINTOUT PROC
    MOV AH, 09H
    INT 21H
    RET
PRINTOUT ENDP

END START
