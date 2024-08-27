.MODEL SMALL
.STACK 100H
.DATA
    ; Mensajes de texto para la interfaz del usuario
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
    
    ; Prompts para solicitar medidas de las figuras
    promptSize1 DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado: $'
    promptLargo DB 0Dh, 0Ah, 'Por favor ingrese el largo del rectangulo: $'
    promptAncho DB 0Dh, 0Ah, 'Por favor ingrese el ancho del rectangulo: $'
    promptBase DB 0Dh, 0Ah, 'Por favor ingrese la base del triangulo: $'
    promptAltura DB 0Dh, 0Ah, 'Por favor ingrese la altura del triangulo: $'
    promptLadoRombo DB 0Dh, 0Ah, 'Por favor ingrese el tamano del lado del rombo: $'
    promptDiagonalMayor DB 0Dh, 0Ah, 'Por favor ingrese la diagonal mayor del rombo: $'
    promptDiagonalMenor DB 0Dh, 0Ah, 'Por favor ingrese la diagonal menor del rombo: $'
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
    
    ; Mensajes para mostrar los resultados
    msgArea DB 0Dh, 0Ah, 'El area es: $'
    msgPerimeter DB 0Dh, 0Ah, 'El perimetro es: $'

    ; Variables para almacenar los valores de entrada y los resultados
    intValue DW 0
    floatValue DW 0
    largo DW 0
    ancho DW 0
    base DW 0
    altura DW 0
    ladoRombo DW 0
    diagonalMayor DW 0
    diagonalMenor DW 0
    ladoPentagono DW 0
    apotema DW 0
    ladoHexagono DW 0
    apotemaHexagono DW 0
    alturaTrapecio DW 0
    baseMayorTrapecio DW 0
    baseMenorTrapecio DW 0
    ladoMenorTrapecio DW 0
    alturaParalelogramo DW 0
    ladoParalelogramo DW 0
    baseParalelogramo DW 0
    area DD 0        ; Área se almacena en un doble palabra para manejar números grandes
    areaFloat DW 0
    perimeter DW 0   ; Perímetro en una palabra
    perimeterFloat DW 0
    string1 DB 10 DUP(' '), '$' ; Cadena temporal para mostrar los números

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX    ; Inicializa el segmento de datos

    LEA DX, msgWelcome
    MOV AH, 09H
    INT 21H      ; Muestra el mensaje de bienvenida

SELECCIONAR_FIGURA:
    LEA DX, msgPrompt
    MOV AH, 09H
    INT 21H      ; Muestra el prompt para seleccionar la figura

    LEA DX, msgOptions
    MOV AH, 09H
    INT 21H      ; Muestra las opciones de figuras

    MOV AH, 01H
    INT 21H      ; Lee la opción seleccionada por el usuario
    SUB AL, '0'  ; Convierte el carácter a un número

    ; Comparación de la opción seleccionada y saltos a la rutina correspondiente
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
    CMP AL, 8
    JE CALC_TRAPECIO_JUMP
    CMP AL, 9
    JE CALC_PARALELOGRAMO_JUMP
    JMP INVALID_OPTION  ; Si no es ninguna opción válida, muestra error

CALC_CUADRADO_JUMP:
    JMP CALC_CUADRADO   ; Salta a la rutina para calcular cuadrado

CALC_RECTANGULO_JUMP:
    JMP CALC_RECTANGULO ; Salta a la rutina para calcular rectángulo

CALC_TRIANGULO_JUMP:
    JMP CALC_TRIANGULO  ; Salta a la rutina para calcular triángulo

CALC_ROMBO_JUMP:
    JMP CALC_ROMBO      ; Salta a la rutina para calcular rombo
    
CALC_PENTAGONO_JUMP:
    JMP CALC_PENTAGONO  ; Salta a la rutina para calcular pentágono

CALC_HEXAGONO_JUMP:
    JMP CALC_HEXAGONO   ; Salta a la rutina para calcular hexágono

CALC_TRAPECIO_JUMP:
    JMP CALC_TRAPECIO   ; Salta a la rutina para calcular trapecio
    
CALC_PARALELOGRAMO_JUMP:
    JMP CALC_PARALELOGRAMO ; Salta a la rutina para calcular paralelogramo

INVALID_OPTION:
    LEA DX, msgInvalid
    MOV AH, 09H
    INT 21H       ; Muestra un mensaje de opción inválida
    JMP SELECCIONAR_FIGURA ; Vuelve a pedir la selección de figura


CALC_CUADRADO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV floatValue,DX
    XOR DX,DX

    CMP intValue, 0
    JLE INVALID_OPTION
    CMP intValue, 9999
    JG INVALID_OPTION
    ;area si hay dec *****************************
    ;Calculo entero*entero/////////////////

    MOV AX, intValue
    MOV BX, AX
    MUL BX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX
    ;//////////////////////////
 
    ;Calculo entero*dec /////////////
    
    MOV AX,intValue
    MOV BX,floatValue
    MUL BX
    MOV BX,50 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,200  
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADD areaFloat,AX ;parte decimal se suma
    ;/////////////////////////////////  

    ; Calculando dec*dec////////////
    MOV AX,floatValue 
    MUL AX
    ADD areaFloat,AX
    ;***************************************************
    ;perimetro si hay dec  
    ;Calculo enteros/////////////////

    MOV AX, intValue
    ADD AX, AX
    ADD AX, AX
    MOV perimeter, AX
    
    
    ; decimales//////////////////

    MOV AX ,floatValue
    ADD AX, AX
    ADD AX,AX
    MOV BX,100
    DIV BX
    ADD perimeterFloat,DX
    ADD perimeter, AX 


    ;*************************************************************
    JMP DISPLAY_RESULTS

CALC_RECTANGULO:
    LEA DX, promptLargo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV largo, AX

    LEA DX, promptAncho
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ancho, AX

    CMP largo, 0
    JLE INVALID_INPUT_RECT
    CMP largo, 9999
    JG INVALID_INPUT_RECT
    CMP ancho, 0
    JLE INVALID_INPUT_RECT
    CMP ancho, 9999
    JG INVALID_INPUT_RECT
    JMP CALC_RECT_AREA

INVALID_INPUT_RECT:
    JMP INVALID_OPTION

CALC_RECT_AREA:
    MOV AX, largo
    MUL ancho
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    MOV AX, largo
    ADD AX, AX
    MOV BX, ancho
    ADD BX, BX
    ADD AX, BX
    MOV perimeter, AX

    JMP DISPLAY_RESULTS

CALC_TRIANGULO:
    LEA DX, promptBase
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV base, AX

    LEA DX, promptAltura
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV altura, AX

    CMP base, 0
    JLE INVALID_INPUT_TRI
    CMP base, 9999
    JG INVALID_INPUT_TRI
    CMP altura, 0
    JLE INVALID_INPUT_TRI
    CMP altura, 9999
    JG INVALID_INPUT_TRI
    JMP CALC_TRI_AREA

INVALID_INPUT_TRI:
    JMP INVALID_OPTION

CALC_TRI_AREA:
    MOV AX, base
    MUL altura
    MOV BX, 2
    DIV BX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], 0

    MOV AX, base
    MOV BX, 3
    MUL BX
    MOV perimeter, AX

    JMP DISPLAY_RESULTS

CALC_ROMBO:
    LEA DX, promptLadoRombo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoRombo, AX

    LEA DX, promptDiagonalMayor
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV diagonalMayor, AX

    LEA DX, promptDiagonalMenor
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV diagonalMenor, AX

    CMP ladoRombo, 0
    JLE INVALID_INPUT_ROMBO
    CMP ladoRombo, 9999
    JG INVALID_INPUT_ROMBO
    CMP diagonalMayor, 0
    JLE INVALID_INPUT_ROMBO
    CMP diagonalMayor, 9999
    JG INVALID_INPUT_ROMBO
    CMP diagonalMenor, 0
    JLE INVALID_INPUT_ROMBO
    CMP diagonalMenor, 9999
    JG INVALID_INPUT_ROMBO
    JMP CALC_ROMBO_AREA

INVALID_INPUT_ROMBO:
    JMP INVALID_OPTION

CALC_ROMBO_AREA:
    MOV AX, diagonalMayor
    MUL diagonalMenor
    MOV BX, 2
    DIV BX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], 0

    MOV AX, ladoRombo
    MOV BX, 4
    MUL BX
    MOV perimeter, AX

    JMP DISPLAY_RESULTS

CALC_PENTAGONO:
    LEA DX, promptLadoPentagono
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoPentagono, AX

    LEA DX, promptApotema
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV apotema, AX

    CMP ladoPentagono, 0
    JLE INVALID_INPUT_PENT
    CMP ladoPentagono, 9999
    JG INVALID_INPUT_PENT
    CMP apotema, 0
    JLE INVALID_INPUT_PENT
    CMP apotema, 9999
    JG INVALID_INPUT_PENT
    JMP CALC_PENT_AREA

INVALID_INPUT_PENT:
    JMP INVALID_OPTION

CALC_PENT_AREA:
    ; Cálculo del perímetro: 5 * lado
    MOV AX, ladoPentagono
    MOV BX, 5
    MUL BX
    MOV perimeter, AX

    ; Cálculo del área: (Perímetro * Apotema) / 2
    MOV AX, perimeter
    MUL apotema
    MOV BX, 2
    DIV BX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    JMP DISPLAY_RESULTS
    
CALC_HEXAGONO:
    LEA DX, promptLadoHexagono
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoHexagono, AX

    LEA DX, promptApotemaHexagono
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV apotemaHexagono, AX

    CMP ladoHexagono, 0
    JLE INVALID_INPUT_HEX
    CMP ladoHexagono, 9999
    JG INVALID_INPUT_HEX
    CMP apotemaHexagono, 0
    JLE INVALID_INPUT_HEX
    CMP apotemaHexagono, 9999
    JG INVALID_INPUT_HEX
    JMP CALC_HEX_AREA

INVALID_INPUT_HEX:
    JMP INVALID_OPTION

CALC_HEX_AREA:
    ; Cálculo del perímetro: 6 * lado
    MOV AX, ladoHexagono
    MOV BX, 6
    MUL BX
    MOV perimeter, AX

    ; Cálculo del área: (Perímetro * Apotema) / 2
    MOV AX, perimeter
    MUL apotemaHexagono
    MOV BX, 2
    DIV BX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    JMP DISPLAY_RESULTS

CALC_TRAPECIO:
    LEA DX, promptAlturaTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV alturaTrapecio, AX

    LEA DX, promptBaseMayorTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseMayorTrapecio, AX

    LEA DX, promptBaseMenorTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseMenorTrapecio, AX

    LEA DX, promptLadoMenorTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoMenorTrapecio, AX

    CMP alturaTrapecio, 0
    JLE INVALID_INPUT_TRAP
    CMP alturaTrapecio, 9999
    JG INVALID_INPUT_TRAP
    CMP baseMayorTrapecio, 0
    JLE INVALID_INPUT_TRAP
    CMP baseMayorTrapecio, 9999
    JG INVALID_INPUT_TRAP
    CMP baseMenorTrapecio, 0
    JLE INVALID_INPUT_TRAP
    CMP baseMenorTrapecio, 9999
    JG INVALID_INPUT_TRAP
    CMP ladoMenorTrapecio, 0
    JLE INVALID_INPUT_TRAP
    CMP ladoMenorTrapecio, 9999
    JG INVALID_INPUT_TRAP
    JMP CALC_TRAP_AREA

INVALID_INPUT_TRAP:
    JMP INVALID_OPTION

CALC_TRAP_AREA:
    ; Cálculo del perímetro: (2*LADO MENOR)+BASE MAYOR+BASE MENOR
    MOV AX, ladoMenorTrapecio
    ADD AX, AX
    ADD AX, baseMayorTrapecio
    ADD AX, baseMenorTrapecio
    MOV perimeter, AX

    ; Cálculo del área: ((BASE MAYOR + BASE MENOR) * ALTURA) / 2
    
    ; Primero, sumamos BASE MAYOR + BASE MENOR
    MOV AX, baseMayorTrapecio
    ADD AX, baseMenorTrapecio
    
    ; Multiplicamos por ALTURA
    MUL alturaTrapecio  ; DX:AX = (BASE MAYOR + BASE MENOR) * ALTURA
    
    ; Dividimos por 2
    MOV BX, 2
    DIV BX  ; AX = ((BASE MAYOR + BASE MENOR) * ALTURA) / 2, DX = remainder

    ; Guardamos el resultado
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX  ; Guardamos el residuo en la parte alta por si acaso

    JMP DISPLAY_RESULTS

CALC_PARALELOGRAMO:
    LEA DX, promptAlturaParalelogramo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV alturaParalelogramo, AX

    LEA DX, promptLadoParalelogramo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoParalelogramo, AX

    LEA DX, promptBaseParalelogramo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseParalelogramo, AX

    CMP alturaParalelogramo, 0
    JLE INVALID_INPUT_PARA
    CMP alturaParalelogramo, 9999
    JG INVALID_INPUT_PARA
    CMP ladoParalelogramo, 0
    JLE INVALID_INPUT_PARA
    CMP ladoParalelogramo, 9999
    JG INVALID_INPUT_PARA
    CMP baseParalelogramo, 0
    JLE INVALID_INPUT_PARA
    CMP baseParalelogramo, 9999
    JG INVALID_INPUT_PARA
    JMP CALC_PARA_AREA

INVALID_INPUT_PARA:
    JMP INVALID_OPTION

CALC_PARA_AREA:
    ; Cálculo del perímetro: (2*LADO)+(2*BASE)
    MOV AX, ladoParalelogramo
    ADD AX, AX
    MOV BX, baseParalelogramo
    ADD BX, BX
    ADD AX, BX
    MOV perimeter, AX

    ; Cálculo del área: BASE * ALTURA
    MOV AX, baseParalelogramo
    MUL alturaParalelogramo
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    JMP DISPLAY_RESULTS

DISPLAY_RESULTS:
    LEA DX, msgArea
    MOV AH, 09H
    INT 21H        ; Muestra el mensaje "El área es:"

    MOV AX, WORD PTR [area]
    MOV DX, WORD PTR [area+2]
    CALL PARSE32   ; Convierte el valor del área a cadena para mostrarlo
    LEA DX, string1
    CALL PRINTOUT  ; Muestra el valor del área

    LEA DX, msgPerimeter
    MOV AH, 09H
    INT 21H        ; Muestra el mensaje "El perímetro es:"

    MOV AX, perimeter
    XOR DX, DX
    CALL PARSE32   ; Convierte el valor del perímetro a cadena para mostrarlo
    LEA DX, string1
    CALL PRINTOUT  ; Muestra el valor del perímetro

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
    JE SALIR_PROGRAMA     ; Si elige salir, termina el programa
    
    LEA DX, msgInvalid
    MOV AH, 09H
    INT 21H       ; Si no es ninguna opción válida, muestra error
    JMP PREGUNTAR_CONTINUAR ; Vuelve a preguntar

CONTINUAR_PROGRAMA:
    JMP SELECCIONAR_FIGURA ; Vuelve a la selección de figura

SALIR_PROGRAMA:
    MOV AH, 4CH
    INT 21H       ; Termina el programa

; Rutina para leer un número de la entrada
READ_NUMBER_NEW PROC
    XOR BX, BX        ; Inicializa BX en 0 para acumular la parte entera
    MOV CX, 10        ; Inicializa el multiplicador en 10
    XOR DX, DX        ; Inicializa DX en 0 para acumular la parte decimal
    XOR SI, SI        ; Inicializa SI para contar los decimales

READ_LOOP_NEW:
    MOV AH, 01H
    INT 21H            ; Lee un carácter
    CMP AL, 0Dh
    JE END_READ_LOOP_NEW ; Si es Enter, termina la lectura
    CMP AL, '.'        ;Verifica si es un punto 
    JE HANDLE_DECIMAL  
    CMP AL, '0'
    JL INVALID_INPUT_NUM ; Si no es un dígito, es entrada inválida
    CMP AL, '9'
    JG INVALID_INPUT_NUM ; Si no es un dígito, es entrada inválida
    SUB AL, '0'        ; Convierte el carácter a número
    MOV AH, 0
    PUSH AX
    MOV AX, BX
    MUL CX             ; Multiplica BX por 10 (shifting)
    JC OVERFLOW_NUM    ; Verifica overflow
    MOV BX, AX
    POP AX
    ADD BX, AX         ; Agrega el dígito a BX
    JC OVERFLOW_NUM    ; Verifica overflow
    JMP READ_LOOP_NEW  ; Continúa leyendo dígitos
HANDLE_DECIMAL:
    ; Comienza a manejar la parte decimal
    MOV AH, 01H
    INT 21H            ; Lee el siguiente carácter (primer decimal)
    CMP AL, 0Dh
    JE HANDLE_SINGLE_DECIMAL ; Si es Enter, maneja un solo decimal
    CMP AL, '0'
    JL INVALID_INPUT_NUM ; Si no es un dígito, es entrada inválida
    CMP AL, '9'
    JG INVALID_INPUT_NUM ; Si no es un dígito, es entrada inválida
    SUB AL, '0'        
    MOV AH, 0
    MOV CX, 10         
    MUL CX             
    ADD DX, AX        
    INC SI    ; Incrementa el contador 

    ; Lee el segundo 
    MOV AH, 01H
    INT 21H            
    CMP AL, 0Dh
    JE END_READ_LOOP_NEW ; Si es Enter, termina la lectura
    CMP AL, '0'
    JL INVALID_INPUT_NUM ; Si no es un dígito, es entrada inválida
    CMP AL, '9'
    JG INVALID_INPUT_NUM ; Si no es un dígito, es entrada inválida
    SUB AL, '0'        
    MOV AH, 0
    ADD DX, AX         ; Agrega el segundo decimal a DX
    JMP END_READ_LOOP_NEW

HANDLE_SINGLE_DECIMAL:
    ; Agrega 0
    MOV CX, 10         
    MUL CX             
    ADD DX, AX         ; Agrega el 0 adicional
INVALID_INPUT_NUM:
    JMP READ_LOOP_NEW ; Ignora entrada inválida y continúa


OVERFLOW_NUM:
    MOV BX, 9999  ; Si hay overflow, limita a 9999

END_READ_LOOP_NEW:
    MOV AX, BX    ; Retorna el número leído en AX
    MOV intValue,AX

    RET
READ_NUMBER_NEW ENDP

; Rutina para convertir un número de 32 bits a cadena para mostrar
PARSE32 PROC
    PUSH BX
    PUSH CX
    PUSH SI
    MOV SI, 9
    MOV BX, 10
    MOV CX, 0

PARSE32_LOOP:
    PUSH AX
    MOV AX, DX
    XOR DX, DX
    DIV BX         ; Divide DX:AX por 10
    MOV DI, AX
    POP AX
    DIV BX         ; Divide AX por 10
    ADD DL, '0'    ; Convierte el residuo a carácter
    MOV [string1+SI], DL
    DEC SI
    INC CX
    MOV DX, DI     ; Pasa la parte alta de la división a DX
    CMP AX, 0
    JNZ PARSE32_LOOP ; Continua hasta que AX sea 0
    CMP DX, 0
    JNZ PARSE32_LOOP ; Continua hasta que DX sea 0

    MOV AL, ' '
FILL_SPACES:
    CMP SI, -1
    JE DONE_PARSING ; Si ya llenamos la cadena, terminamos
    MOV [string1+SI], AL
    DEC SI
    JMP FILL_SPACES

DONE_PARSING:
    POP SI
    POP CX
    POP BX
    RET
PARSE32 ENDP

; Rutina para mostrar la cadena generada
PRINTOUT PROC
    MOV AH, 09H
    INT 21H
    RET
PRINTOUT ENDP

END START ; Fin del programa, punto de entrada es START
