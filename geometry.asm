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
    perimeter DD 0             ; Variable para el perímetro (32 bits)

    string1 DB 10 DUP(30h), '$'   ; Arreglo para guardar el número convertido en cadena (ampliado a 10 dígitos)

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

    ; Cálculo del área y perímetro usando operaciones de 16 bits
    MOV AX, intValue
    MUL AX                  ; DX:AX = lado * lado (área)
    MOV word ptr [area], AX
    MOV word ptr [area+2], DX  ; Guarda el resultado de 32 bits

    MOV AX, intValue
    MOV BX, 4
    MUL BX                  ; DX:AX = lado * 4 (Perímetro)
    MOV word ptr [perimeter], AX
    MOV word ptr [perimeter+2], DX

    ; Muestra los resultados
    JMP DISPLAY_RESULTS

DISPLAY_RESULTS:
    ; Mostrar el área
    LEA DX, msgArea
    MOV AH, 09H
    INT 21H

    MOV AX, word ptr [area]
    MOV DX, word ptr [area+2]
    CALL PARSE              ; Convierte el número en cadena
    LEA DX, string1
    CALL PRINTOUT           ; Imprime la cadena resultante

    ; Mostrar el perímetro
    LEA DX, msgPerimeter
    MOV AH, 09H
    INT 21H

    MOV AX, word ptr [perimeter]
    MOV DX, word ptr [perimeter+2]
    CALL PARSE              ; Convierte el número en cadena
    LEA DX, string1
    CALL PRINTOUT           ; Imprime la cadena resultante

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
    JMP SELECCIONAR_FIGURA

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
    SUB AL, '0'        ; Convierte el carácter leído a un número
    MOV AH, 0          ; Limpia AH
    PUSH AX            ; Guarda el dígito
    MOV AX, BX         ; Mueve el valor acumulado a AX
    MUL CX             ; Multiplica por 10
    MOV BX, AX         ; Guarda el resultado en BX
    POP AX             ; Recupera el dígito
    ADD BX, AX         ; Suma el dígito al valor acumulado
    JMP READ_LOOP_NEW

END_READ_LOOP_NEW:
    MOV intValue, BX   ; Almacena el valor final en intValue
    RET
READ_NUMBER_NEW ENDP

; Rutina para parsear un número en una cadena
PARSE PROC
    PUSH BX
    MOV BX, 10         ; Divisor
    MOV SI, OFFSET string1 + 9  ; Comienza desde el final de la cadena
    XOR DI, DI         ; Para contar cuántos caracteres han sido añadidos

PARSE_LOOP:
    XOR DX, DX         ; Limpia DX
    DIV BX             ; Divide DX:AX por 10, DX tiene el resto
    ADD DL, '0'        ; Convierte el dígito a ASCII
    MOV [SI], DL       ; Almacena el dígito en la cadena
    DEC SI             ; Decrementa el índice de la cadena
    INC DI             ; Incrementa el contador de caracteres
    OR AX, AX
    JNZ PARSE_LOOP     ; Repite si no hemos procesado todos los dígitos

    ; Elimina ceros no significativos
    MOV SI, OFFSET string1  ; Apunta al comienzo de la cadena
    MOV CX, 10              ; Longitud máxima de la cadena
REMOVE_LEADING_ZEROS:
    CMP BYTE PTR [SI], '0'  ; Compara con '0'
    JNE DONE_REMOVING       ; Si no es '0', ya terminamos
    MOV BYTE PTR [SI], ' '  ; Reemplaza el cero por espacio
    INC SI                  ; Pasa al siguiente carácter
    LOOP REMOVE_LEADING_ZEROS

DONE_REMOVING:
    POP BX
    RET
PARSE ENDP

; Rutina para imprimir una cadena en pantalla
PRINTOUT PROC
    MOV AH, 09H
    INT 21H
    RET
PRINTOUT ENDP

END START

