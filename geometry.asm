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
    promptRadio DB 0Dh, 0Ah, 'Por favor ingrese el radio del circulo: $'
    promptAlturaTrapecio DB 0Dh, 0Ah, 'Por favor ingrese la altura del trapecio: $'
    promptBaseMayorTrapecio DB 0Dh, 0Ah, 'Por favor ingrese la base mayor del trapecio: $'
    promptBaseMenorTrapecio DB 0Dh, 0Ah, 'Por favor ingrese la base menor del trapecio: $'
    promptLadoMenorTrapecio DB 0Dh, 0Ah, 'Por favor ingrese el lado menor del trapecio: $'
    promptAlturaParalelogramo DB 0Dh, 0Ah, 'Por favor ingrese la altura del paralelogramo: $'
    promptLadoParalelogramo DB 0Dh, 0Ah, 'Por favor ingrese el lado del paralelogramo: $'
    promptBaseParalelogramo DB 0Dh, 0Ah, 'Por favor ingrese la base del paralelogramo: $'
    
    ; Mensajes para mostrar los resultados
    msgArea DB 'El area es: $'
    msgPerimeter DB 'El perimetro es: $'

    ; Variables para almacenar los valores de entrada y los resultados
    intValue DW 0
    floatValue DW 0
    largo DW 0
    largoFloat DW 0

    ancho DW 0
    anchoFloat DW 0

    base DW 0
    baseFloat DW 0 

    altura DW 0
    alturaFloat DW 0

    intMenosSig DW 0
    IntMasSig DW 0

    floatMasSIg DW 0
    floatMenosSig DW 0

    X DW 0
    ladoRombo DW 0
    ladoRomboFloat DW 0 

    diagonalMayor DW 0
    diagonalMayorFloat DW 0

    diagonalMenor DW 0
    diagonalMenorFloat DW 0

    ladoPentagono DW 0
    ladoPentagonoFloat DW 0

    apotema DW 0
    apotemaFloat DW 0

    ladoHexagono DW 0
    ladoHexagonoFloat DW 0

    apotemaHexagono DW 0
    apotemaHexagonoFloat DW 0

    alturaTrapecio DW 0
    alturaTrapecioFloat DW 0

    baseMayorTrapecio DW 0
    baseMayorTrapecioFloat DW 0

    baseMenorTrapecio DW 0
    baseMenorTrapecioFloat DW 0

    ladoMenorTrapecio DW 0
    ladoMenorTrapecioFloat DW 0

    alturaParalelogramo DW 0
    alturaParalelogramoFloat DW 0

    ladoParalelogramo DW 0
    ladoParalelogramoFloat DW 0 

    baseParalelogramo DW 0
    baseParalelogramoFloat DW 0

    intPI DW 3
    floatPI DW 14

    intwoPI DW 6
    floatwoPI DW 28

    area DD 0        ; Área se almacena en un doble palabra para manejar números grandes
    areaFloat DW 0

    perimeter DW 0,0   ; Perímetro en una palabra
    perimeterFloat DW 0

    aux DW 0, 0, 0 ; Variable auxiliar para guardar resultados intermedios

    string1 DB 10 DUP(' '), '$' ; Cadena temporal para mostrar los números

    num_string DB 10 DUP('0'), '.', 2 DUP('0'), '$'
    crlf DB 0Dh, 0Ah, '$'   ; Carriage return & newline

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
    CMP AL, 7
    JE CALC_CIRC_JUMP
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
    
CALC_CIRC_JUMP:
    JMP CALC_CIRC   ; Salta a la rutina para calcular circulo

CALC_TRAPECIO_JUMP:
    JMP CALC_TRAPECIO   ; Salta a la rutina para calcular trapecio
    
CALC_PARALELOGRAMO_JUMP:
    JMP CALC_PARALELOGRAMO ; Salta a la rutina para calcular paralelogramo

INVALID_OPTION:
    LEA DX, msgInvalid
    MOV AH, 09H
    INT 21H       ; Muestra un mensaje de opción inválida
    JMP SELECCIONAR_FIGURA ; Vuelve a pedir la selección de figura





CALC_CIRC:
    LEA DX, promptRadio
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV floatValue,DX
    XOR DX,DX



    ;area******************************

    ;Multiplicación de enteros

    MOV AX, intValue
    MOV CX,intPI
    MUL CX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX 


    ;PI *Flotante del radio

    MOV AX,intPI
    MOV BX,floatValue
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADD areaFloat,AX ;parte decimal se suma


    ; 0.14 * intRadio

    MOV AX,intValue
    MOV BX,floatPI
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 

    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec////////////
    MOV AX,floatPI
    MUL floatValue
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV areaFloat,AX
    MOV perimeterFloat,AX
    MOV AX,WORD PTR [area]
    MOV perimeter,AX

    XOR DX,DX
    MOV WORD PTR [area],DX
    MOV areaFloat,DX

    ;***PI X R terminado ******


    ;***********PI * R^2***************
    ;Int*int
    MOV AX, intValue
    MOV CX,perimeter
    MUL CX
    ADD WORD PTR [area], AX
    ADD WORD PTR [area+2], DX


    ;Se separa flotante
    MOV AX,perimeterFloat
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV floatMenosSig,DX
    MOV floatMasSIg,AX
    
    ;Se separa entero
    MOV AX, intValue
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    MOV intMasSIg, AX
    
    ;Int mas significativo * float mas sig
    MOV BX, floatMasSIg
    XOR DX,DX
    MUL BX
    ADD WORD PTR [area], AX ; Parte entera se suma 


    ; int menos significativo por flotante más signofocativo 
    MOV AX,floatMasSIg
    MUL intMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD areaFloat,AX ;parte decimal se suma

    ;Flotante menos signicativo * int más significativo
    MOV AX,intMasSIg
    MUL floatMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ;Menos significativos
    ;Int menos significativo * float menos sig
    MOV BX,floatMenosSIg
    MOV AX,intMenosSig
    XOR DX,DX
    MUL BX

    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX



    
    ;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,floatValue
    MOV BX,perimeter ;Variable que almacena temporalmente Pi*r
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    ADC WORD PTR [area+2], 0    ; Suma el acarreo 

    MOV AX,DX ;Parte decimal a ax
    MUL BX

    ADD AX,areaFloat    
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ; Calculando dec*dec
    MOV AX,perimeterFloat
    MOV CX,100 ;Para evitar acarreo
    XOR DX,DX
    DIV CX
    MOV x,DX ; Para manejar acarreo
    MOV BX,floatValue
    MUL BX
    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;Para manejar acarreo
    MOV AX,X
    MOV BX, floatValue
    MUL BX
    MOV CX, 100
    XOR DX,DX
    DIV CX ; YA QUE ERA 0.00X
    ADD AX, areaFloat
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    XOR DX,DX 
    MOV WORD PTR [perimeter],DX
    MOV WORD PTR [perimeter+2],DX



    ;Cálculo del perimetro


    ;Int*int
    MOV AX, intValue
    MOV CX,intwoPI ;Variable que vale 2*pi
    MUL CX
    MOV WORD PTR [perimeter], AX
    MOV WORD PTR [perimeter+2], DX


    MOV AX,intwoPI
    MOV BX,floatValue
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [perimeter], BX ; Parte entera se suma 
    ADD perimeterFloat,AX ;parte decimal se suma


    MOV AX,intValue
    MOV BX,floatwoPI
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [perimeter], BX ; Parte entera se suma 

    MOV DX,perimeterFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [perimeter], AX ; Parte entera se suma 
    MOV perimeterFloat,DX


    ; Calculando dec*dec
    MOV AX,floatwoPI
    MUL floatValue
    ADD AX,perimeterFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [perimeter], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV perimeterFloat,AX




    JMP DISPLAY_RESULTS

CALC_CUADRADO:
    LEA DX, promptSize1
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER_NEW
    MOV floatValue,DX
    XOR DX,DX

    CMP intValue, 0
    JLE INVALID_INPUT_CUAD
    CMP intValue, 9999
    JG INVALID_INPUT_CUAD

    JMP CALC_CUAD_AREA

INVALID_INPUT_CUAD:
    JMP INVALID_OPTION

CALC_CUAD_AREA:

    MOV AX, intValue
    MOV BX, AX
    MUL BX
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

 
    ;Calculo entero*dec
    MOV AX,intValue
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    xor dx,dx
    MUL floatValue
    MOV CX,2  ;
    MUL CX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    
    ;Manejando acarreo
    MOV AX,intMenosSig
    MUL floatValue
    MOV BX,50 ; para separar parte entera y decimal 
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,200
    MUL CX
    MOV areaFloat,AX




    ; Calculando dec*dec
    MOV AX,floatValue
    MUL AX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX



    ;Calculo enteros perimetro

    MOV AX, intValue
    ADD AX, AX
    ADD AX, AX
    MOV perimeter, AX
    
    
    ; decimales

    MOV AX ,floatValue
    ADD AX, AX
    ADD AX,AX
    XOR BX,BX
    XOR DX,DX 
    MOV BX,100 ;PARA SEPARAR INT Y FLOAT
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
    MOV largoFloat,DX
    MOV AX, intValue
    MOV largo, AX

    LEA DX, promptAncho
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV anchoFloat,DX
    MOV AX, intValue
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
    ;area******************************
    ;Int*int
    MOV AX, largo
    XOR DX,DX
    MUL ancho
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    MOV AX,largo
    MOV BX,anchoFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADD areaFloat,AX ;parte decimal se suma


    ;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,ancho
    MOV BX,largoFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    ADC WORD PTR [area+2], 0    ; Suma el acarreo 

    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX

    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec////////////
    MOV AX,anchoFloat
    MUL largoFloat
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    
    

    ;perímetro
    MOV AX, largo
    ADD AX, AX
    MOV BX, ancho
    ADD BX, BX
    ADD AX, BX
    MOV perimeter, AX

    ;decimales


    MOV AX ,largoFloat
    ADD AX, AX
    MOV BX,AX
    MOV AX, anchoFloat
    ADD AX,AX 
    ADD AX,BX ;se suman largos y anchos
    XOR DX,DX
    MOV BX,100 
    DIV BX ;separar int y float
    ADD perimeterFloat,DX
    ADD perimeter, AX

    JMP DISPLAY_RESULTS

CALC_TRIANGULO:
    LEA DX, promptBase
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseFloat, DX
    MOV AX, intValue
    MOV base,AX

    LEA DX, promptAltura
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV alturaFloat, DX
    MOV AX, intValue
    MOV altura,AX

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
    ;perimetro*****************

    MOV AX, base
    MOV BX,AX
    ADD AX, AX
    ADD AX,BX
    MOV perimeter, AX
    
    
    ; decimales

    MOV AX ,baseFloat
    MOV BX,AX
    ADD AX, AX
    ADD AX,BX
    XOR DX,DX 
    MOV BX,100 ;PARA SEPARAR INT Y FLOAT
    DIV BX
    ADD perimeterFloat,DX
    ADD perimeter, AX 





    ;area***********************************
    ;Se divide primero la base entre 2
    MOV AX, base
    XOR DX,DX
    MOV BX, 2
    DIV BX
    MOV base, AX ; NUEVA BASE 
    MOV AX,DX ;residuo a AX
    MOV CX,5000
    MUL CX
    MOV DX,baseFloat ; SE PONE  PARTE FLOTANTE EN DX
    MOV baseFloat,AX ; nueva parte flotante
    MOV AX,DX 
    MOV CX,100
    MUL CX
    MOV CX,2 
    XOR DX,DX
    DIV CX 
    ADD baseFloat, AX



    ;Int*int
    MOV AX, altura
    MUL base
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    ;Se separa flotante
    MOV AX,baseFloat
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV floatMenosSig,DX
    MOV floatMasSIg,AX
    
    ;Se separa entero
    MOV AX, altura
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    MOV intMasSIg, AX
    
    ;Int más significativo * float mas sig
    MOV BX, floatMasSIg
    XOR DX,DX
    MUL BX
    ADD WORD PTR [area], AX ; Parte entera se suma 


    ;int-   float+
    MOV AX,floatMasSIg
    MUL intMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD areaFloat,AX ;parte decimal se suma

    ;int+ float-
    MOV AX,intMasSIg
    MUL floatMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 

    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ;int- float-
    ;Int menos significativo * float menos sig
    MOV BX,floatMenosSIg
    MOV AX,intMenosSig
    XOR DX,DX
    MUL BX

    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;        intAncho*FloatLargo
    ;*****************************************
    MOV AX,base
    MOV BX,alturaFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADC WORD PTR [area+2], 0    ; Suma el acarreo a los segundos 16 bits


    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec
    MOV AX,baseFloat
    MOV CX,100 ;Para evitar acarreo
    XOR DX,DX
    DIV CX
    MOV x,DX ; Parte la fracción para evitar acarreo sin causar inexactitud en los cálculos
    MOV BX,alturaFloat
    MUL BX
    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;Para manejar acarreo
    MOV AX,X
    MOV BX, alturaFloat
    MUL BX
    MOV CX, 100
    XOR DX,DX
    DIV CX ; YA QUE ERA 0.00X
    ADD AX, areaFloat
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    



    JMP DISPLAY_RESULTS

CALC_ROMBO:
    LEA DX, promptLadoRombo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoRomboFloat, DX
    MOV AX, intValue
    MOV ladoRombo, AX

    LEA DX, promptDiagonalMayor
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV alturaFloat, DX
    MOV AX, intValue
    MOV altura,AX   

    LEA DX, promptDiagonalMenor
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseFloat, DX
    MOV AX, intValue
    MOV base,AX


    JMP CALC_ROMBO_AREA

INVALID_INPUT_ROMBO:
    JMP INVALID_OPTION

CALC_ROMBO_AREA:

    ;Perímetro************************************



    MOV AX, ladoRombo
    ADD AX, AX
    ADD AX,AX
    MOV perimeter, AX
    
    

    MOV AX ,ladoRomboFloat
    ADD AX, AX
    ADD AX,AX
    XOR DX,DX 
    MOV BX,100 ;PARA SEPARAR INT Y FLOAT
    DIV BX
    ADD perimeterFloat,DX
    ADD perimeter, AX 





   ;area***********************************

   ;Se calcula igual que el triangulo
    ;div/2////////////////
    MOV AX, base
    XOR DX,DX
    MOV BX, 2
    DIV BX
    MOV base, AX ; NUEVA BASE 
    MOV AX,DX ;residuo a AX
    MOV CX,5000
    MUL CX
    MOV DX,baseFloat ; SE PONE  PArTE FLOTANTE EN DX
    MOV baseFloat,AX ; nueva parte flotante
    MOV AX,DX 
    MOV CX,100
    MUL CX
    MOV CX,2 
    XOR DX,DX
    DIV CX 
    ADD baseFloat, AX



    ;Int*int
    MOV AX, altura
    MUL base
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    ;Se separa flotante
    MOV AX,baseFloat
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV floatMenosSig,DX
    MOV floatMasSIg,AX
    
    ;Se separa entero
    MOV AX, altura
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    MOV intMasSIg, AX
    
    ;Int mas significativo * float mas sig
    MOV BX, floatMasSIg
    XOR DX,DX
    MUL BX
    ADD WORD PTR [area], AX ; Parte entera se suma 


    ;menos int sig por mas sig float 
    MOV AX,floatMasSIg
    MUL intMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD areaFloat,AX ;parte decimal se suma

    ;menos f sig por mas sig int
    MOV AX,intMasSIg
    MUL floatMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 

    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ;Menos sig int y f
    ;Int menos significativo * float menos sig
    MOV BX,floatMenosSIg
    MOV AX,intMenosSig
    XOR DX,DX
    MUL BX

    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,base
    MOV BX,alturaFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADC WORD PTR [area+2], 0    ; Suma el acarreo a los segundos 16 bits


    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec
    MOV AX,baseFloat
    MOV CX,100 ;Para evitar acarreo
    XOR DX,DX
    DIV CX
    MOV x,DX ; Para manejar acarreo
    MOV BX,alturaFloat
    MUL BX
    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;Para manejar acarreo
    MOV AX,X
    MOV BX, alturaFloat
    MUL BX
    MOV CX, 100
    XOR DX,DX
    DIV CX ; YA QUE ERA 0.00X
    ADD AX, areaFloat
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    JMP DISPLAY_RESULTS


CALC_PENTAGONO:
    LEA DX, promptLadoPentagono
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoPentagonoFloat,DX
    MOV AX,intValue
    MOV ladoPentagono, AX

    LEA DX, promptApotema
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV apotemaFloat,DX
    MOV AX,intValue
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
    ;perímetro

    MOV AX, ladoPentagono
    MOV BX,5
    MUL BX
    MOV perimeter, AX
    
    
    MOV AX ,ladoPentagonoFloat
    MOV BX,5
    MUL BX
    XOR DX,DX 
    MOV BX,100 ;PARA SEPARAR INT Y FLOAT
    DIV BX
    ADD perimeterFloat,DX
    ADD perimeter, AX 


    ;area***********************************
    ;Se calcula igual a el rombo
    ;div/2////////////////
    MOV AX, apotema
    XOR DX,DX
    MOV BX, 2
    DIV BX
    MOV apotema, AX ; NUEVA BASE 
    MOV AX,DX ;residuo a AX
    MOV CX,5000
    MUL CX
    MOV DX,apotemaFloat ; SE PONE  PArTE FLOTANTE EN DX
    MOV apotemaFloat,AX ; nueva parte flotante
    MOV AX,DX 
    MOV CX,100
    MUL CX
    MOV CX,2 
    XOR DX,DX
    DIV CX 
    ADD apotemaFloat, AX



    ;Int*int
    MOV AX, perimeter
    MUL apotema
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    ;Se separa flotante
    MOV AX,apotemaFloat
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV floatMenosSig,DX
    MOV floatMasSIg,AX
    
    ;Se separa entero
    MOV AX, perimeter
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    MOV intMasSIg, AX
    
    MOV BX, floatMasSIg
    XOR DX,DX
    MUL BX
    ADD WORD PTR [area], AX ; Parte entera se suma 


    MOV AX,floatMasSIg
    MUL intMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD areaFloat,AX ;parte decimal se suma

    MOV AX,intMasSIg
    MUL floatMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 

    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ;Int menos significativo * float menos sig
    MOV BX,floatMenosSIg
    MOV AX,intMenosSig
    XOR DX,DX
    MUL BX

    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,apotema
    MOV BX,perimeterFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 

    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec
    MOV AX,apotemaFloat
    MOV CX,100 ;Para evitar acarreo
    XOR DX,DX
    DIV CX
    MOV x,DX ; Para manejar acarreo
    MOV BX,perimeterFloat
    MUL BX
    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;Para manejar acarreo
    MOV AX,X
    MOV BX, perimeterFloat
    MUL BX
    MOV CX, 100
    XOR DX,DX
    DIV CX ; YA QUE ERA 0.00X
    ADD AX, areaFloat
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    

    JMP DISPLAY_RESULTS
    
CALC_HEXAGONO:
    LEA DX, promptLadoHexagono
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoHexagonoFloat,DX
    MOV AX,intValue
    MOV ladoHexagono,AX


    LEA DX, promptApotemaHexagono
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV apotemaFloat,DX
    MOV AX,intValue
    MOV apotema, AX

    CMP ladoHexagono, 0
    JLE INVALID_INPUT_HEX
    CMP ladoHexagono, 9999
    JG INVALID_INPUT_HEX
    CMP apotema, 0
    JLE INVALID_INPUT_HEX
    CMP apotema, 9999
    JG INVALID_INPUT_HEX
    
    JMP CALC_HEX_AREA

INVALID_INPUT_HEX:
    JMP INVALID_OPTION

CALC_HEX_AREA:
    ;perímetro*****************


    MOV AX, ladoHexagono
    MOV BX,6
    MUL BX
    MOV perimeter, AX
    
    


    MOV AX ,ladoHexagonoFloat
    MOV BX,6
    MUL BX
    XOR DX,DX 
    MOV BX,100 ;PARA SEPARAR INT Y FLOAT
    DIV BX
    ADD perimeterFloat,DX
    ADD perimeter, AX 


    ;area***********************************
    ;Se cálcula igual que triángulo
    ;div/2////////////////
    MOV AX, apotema
    XOR DX,DX
    MOV BX, 2
    DIV BX
    MOV apotema, AX ; NUEVA BASE 
    MOV AX,DX ;residuo a AX
    MOV CX,5000
    MUL CX
    MOV DX,apotemaFloat ; SE PONE  PArTE FLOTANTE EN DX
    MOV apotemaFloat,AX ; nueva parte flotante
    MOV AX,DX 
    MOV CX,100
    MUL CX
    MOV CX,2 
    XOR DX,DX
    DIV CX 
    ADD apotemaFloat, AX



    ;Int*int
    MOV AX, perimeter
    MUL apotema
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    ;Se separa flotante
    MOV AX,apotemaFloat
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV floatMenosSig,DX
    MOV floatMasSIg,AX
    
    ;Se separa entero
    MOV AX, perimeter
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    MOV intMasSIg, AX
    
    ;Int mas significativo * float mas sig
    MOV BX, floatMasSIg
    XOR DX,DX
    MUL BX
    ADD WORD PTR [area], AX ; Parte entera se suma 


    ;menos int sig por mas sig float 
    MOV AX,floatMasSIg
    MUL intMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD areaFloat,AX ;parte decimal se suma

    ;menos f sig por mas sig int
    MOV AX,intMasSIg
    MUL floatMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 

    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ;Menos sig int y f
    ;Int menos significativo * float menos sig
    MOV BX,floatMenosSIg
    MOV AX,intMenosSig
    XOR DX,DX
    MUL BX

    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,apotema
    MOV BX,perimeterFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 

    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec////////////
    MOV AX,apotemaFloat
    MOV CX,100 ;Para evitar acarreo
    XOR DX,DX
    DIV CX
    MOV x,DX ; Para manejar acarreo
    MOV BX,perimeterFloat
    MUL BX
    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;Para manejar acarreo
    MOV AX,X
    MOV BX, perimeterFloat
    MUL BX
    MOV CX, 100
    XOR DX,DX
    DIV CX ; YA QUE ERA 0.00X
    ADD AX, areaFloat
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    
    JMP DISPLAY_RESULTS


CALC_TRAPECIO:
    LEA DX, promptAlturaTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV alturaTrapecioFloat,DX
    MOV AX,intValue
    MOV alturaTrapecio, AX

    LEA DX, promptBaseMayorTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseMayorTrapecioFloat,DX
    MOV AX,intValue
    MOV baseMayorTrapecio, AX

    LEA DX, promptBaseMenorTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV baseMenorTrapecioFloat,DX
    MOV AX,intValue
    MOV baseMenorTrapecio, AX

    LEA DX, promptLadoMenorTrapecio
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoMenorTrapecioFloat,DX
    MOV AX,intValue
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

    ;DECIMALES PERIMETRO

    MOV AX ,ladoMenorTrapecioFloat
    ADD AX, AX
    ADD AX,baseMenorTrapecioFloat
    ADD AX, baseMayorTrapecioFloat
    XOR DX,DX 
    MOV BX,100 ;PARA SEPARAR INT Y FLOAT
    DIV BX
    ADD perimeterFloat,DX
    ADD perimeter, AX 

   ;area***********************************

    MOV AX, baseMayorTrapecio
    ADD AX,baseMenorTrapecio
    MOV baseMayorTrapecio,AX
        

    ;Se suman las dos bases    
    MOV AX,baseMenorTrapecioFloat
    MOV DX,baseMayorTrapecioFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD baseMayorTrapecio, AX ; Parte entera se suma 
    MOV baseMayorTrapecioFloat,DX
    



    ;div/2////////////////
    ;Se divide la base total cálculada anteriormente
    MOV AX, baseMayorTrapecio
    XOR DX,DX
    MOV BX, 2
    DIV BX
    MOV baseMayorTrapecio, AX ; NUEVA BASE 
    MOV AX,DX ;residuo a AX
    MOV CX,5000
    MUL CX
    MOV DX,baseMayorTrapecioFloat ; SE PONE  PArTE FLOTANTE EN DX
    MOV baseMayorTrapecioFloat,AX ; nueva parte flotante
    MOV AX,DX 
    MOV CX,100
    MUL CX
    MOV CX,2 
    XOR DX,DX
    DIV CX 
    ADD baseMayorTrapecioFloat, AX



    ;Int*int
    MOV AX, alturaTrapecio
    MUL baseMayorTrapecio
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    ;Se separa flotante
    MOV AX,baseMayorTrapecioFloat
    MOV BX,100
    XOR DX,DX
    DIV BX
    MOV floatMenosSig,DX
    MOV floatMasSIg,AX
    
    ;Se separa entero
    MOV AX, alturaTrapecio
    XOR DX,DX
    DIV BX
    MOV intMenosSig, DX
    MOV intMasSIg, AX
    
    ;Int mas significativo * float mas sig
    MOV BX, floatMasSIg
    XOR DX,DX
    MUL BX
    ADD WORD PTR [area], AX ; Parte entera se suma 



    ;menos int sig por mas sig float 
    MOV AX,floatMasSIg
    MUL intMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD areaFloat,AX ;parte decimal se suma

    ;menos f sig por mas sig int
    MOV AX,intMasSIg
    MUL floatMenosSig
    MOV BX,100 ; para separar parte entera y decimal
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 

    MOV AX,DX
    MOV CX,100
    MUL CX
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ;Menos sig int y f
    ;Int menos significativo * float menos sig
    MOV BX,floatMenosSIg
    MOV AX,intMenosSig
    XOR DX,DX
    MUL BX

    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,baseMayorTrapecio
    MOV BX,alturaTrapecioFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADC WORD PTR [area+2], 0    ; Suma el acarreo a los segundos 16 bits


    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec
    MOV AX,baseMayorTrapecioFloat
    MOV CX,100 ;Para evitar acarreo
    XOR DX,DX
    DIV CX
    MOV x,DX ; Para manejar acarreo
    MOV BX,alturaTrapecioFloat
    MUL BX
    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX

    ;Para manejar acarreo
    MOV AX,X
    MOV BX, alturaTrapecioFloat
    MUL BX
    MOV CX, 100
    XOR DX,DX
    DIV CX ; YA QUE ERA 0.00X
    ADD AX, areaFloat
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    XOR DX,DX
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    JMP DISPLAY_RESULTS

CALC_PARALELOGRAMO:
    LEA DX, promptAlturaParalelogramo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV largoFloat,DX
    MOV AX,intValue
    MOV largo,AX

    LEA DX, promptLadoParalelogramo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV ladoParalelogramoFloat,DX
    MOV AX, intValue
    MOV ladoParalelogramo, AX

    LEA DX, promptBaseParalelogramo
    MOV AH, 09H
    INT 21H
    CALL READ_NUMBER_NEW
    MOV anchoFloat,DX
    MOV AX,intValue
    MOV ancho, AX

    
    CMP largo, 0
    JLE INVALID_INPUT_PARA
    CMP largo, 9999
    JG INVALID_INPUT_PARA
    CMP ladoParalelogramo, 0
    JLE INVALID_INPUT_PARA
    CMP ladoParalelogramo, 9999
    JG INVALID_INPUT_PARA
    CMP ancho, 0
    JLE INVALID_INPUT_PARA
    CMP ancho, 9999
    JG INVALID_INPUT_PARA

    JMP CALC_PARA_AREA

INVALID_INPUT_PARA:
    JMP INVALID_OPTION

CALC_PARA_AREA:
    ;area*****************************
    ;Se cálcula igual que el rectángulo

    ;Int*int
    MOV AX, largo
    XOR DX,DX
    MUL ancho
    MOV WORD PTR [area], AX
    MOV WORD PTR [area+2], DX

    ;////////////// intLargo*FloatAncho
    ;*****************************************
    MOV AX,largo
    MOV BX,anchoFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    MOV BX,AX ; int a bx
    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX
    ADD WORD PTR [area], BX ; Parte entera se suma 
    ADD areaFloat,AX ;parte decimal se suma


;////////////// intAncho*FloatLargo
    ;*****************************************
    MOV AX,ancho
    MOV BX,largoFloat
    MUL BX
    MOV BX,100 ; para separar parte entera y decimal
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    ADC WORD PTR [area+2], 0    ; Suma el acarreo 

    MOV AX,DX ;Parte decimal a ax
    MOV CX,100  ;
    MUL CX

    MOV DX,areaFloat
    ADD AX,DX
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV areaFloat,DX


    ; Calculando dec*dec////////////
    MOV AX,anchoFloat
    MUL largoFloat
    ADD AX,areaFloat
    XOR DX,DX
    MOV BX,10000 ; PARA VER SI HAY PARTE ENTERA
    DIV BX
    ADD WORD PTR [area], AX ; Parte entera se suma 
    MOV AX,DX
    MOV CX,100
    XOR DX,DX
    DIV CX
    MOV areaFloat,AX
    
    
    ;perimetro************************************

    ;parte entera/////////////////////////
    MOV AX, ladoParalelogramo
    ADD AX, AX
    MOV BX, ancho
    ADD BX, BX
    ADD AX, BX
    MOV perimeter, AX

    ;decimales


    MOV AX ,ladoParalelogramoFloat
    ADD AX, AX
    MOV BX,AX
    MOV AX, anchoFloat
    ADD AX,AX 
    ADD AX,BX ;se suman largos y anchos
    XOR DX,DX
    MOV BX,100 
    DIV BX ;separar int y float
    ADD perimeterFloat,DX
    ADD perimeter, AX

    JMP DISPLAY_RESULTS

DISPLAY_RESULTS:
    LEA dx, crlf
    CALL PRINTOUT   ; Cambio de linea
    ; /////// Valor del area ///////
    LEA dx, msgArea
    CALL PRINTOUT   ; Mostrar "El area es: "

    MOV si, offset num_string+13
    MOV ax, WORD PTR [area]      ; 16-bits de la parte entera baja
    MOV dx, WORD PTR [area+2]    ; 16-bits de la parte entera alta
    MOV bx, areaFloat   ; 16-bits del parte flotante
    CALL PARSE  ; La funcion de parseo, convierte el contenido de DX:AX.BX al string en SI de DERECHA a IZQUIERDA

    MOV si, cx  ; PARSE guarda en CX el indice donde se agrego el ultimo digito convertido
    LEA dx, [num_string+si] ; Empieza a leer el string desde la posicion indicada por CX
    CALL PRINTOUT   ; Muestra el valor del area
    
    XOR cx, cx
    MOV si, offset num_string+13
    CALL CLEAN_32STR    ; Limpiar los digitos usados en la cadena en SI

    LEA dx, crlf
    CALL PRINTOUT   ; Cambio de linea

    MOV WORD PTR [area], 0   ; Limpiar el resultado del area
    MOV WORD PTR [area+2], 0
    MOV areaFloat, 0
    ; /////// Valor del perimetro ///////
    LEA dx, msgPerimeter
    CALL PRINTOUT

    MOV si, offset num_string+13
    MOV ax, perimeter       ; 16-bits de la parte entera baja
    MOV dx, 0               ; 16-bits de la parte entera alta
    MOV bx, perimeterFloat  ; 16-bits de la parte flotante
    CALL PARSE  ; La funcion de parseo, convierte el contenido de DX:AX.BX al string en SI de DERECHA a IZQUIERDA

    MOV si, cx 
    LEA dx, [num_string+si] ; Mover el incio de la cadena al ultimo digito que indica CX
    CALL PRINTOUT

    XOR cx, cx
    MOV si, offset num_string+13
    CALL CLEAN_32STR    ; Limpiar los digitos usados en la cadena en SI

    LEA dx, crlf
    CALL PRINTOUT   ; Cambio de linea

    MOV perimeter, 0    ; Limpiar el resultado del area
    MOV perimeterFloat, 0

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

; Inserta un numero guardado DX:AX.BX en una cadena en SI (que debe tener el punto decimal con 10 ceros adelante y 2 ceros atras)
PARSE proc  ; Inserta un numero guardado DX:AX.BX en una cadena en SI (que debe tener el punto decimal con 10 ceros adelantes y 2 ceros atras)
    CMP dx, 0
        JZ PARSE16 ; Si en la parte alta del numero no hay podemos saltar al otro caso
    MOV cx, 10000
    DIV cx ; Hacemos esta division entre 10 mil para separar nuestro entero de 32 bits en 2 grupos de 4 digitos

    MOV [aux], ax   
    MOV [aux+2], dx ; Movemos los resultados de la div a otro lugar por el momento
    ; (1)
    PARSE32:
        MOV cx, 13
        XOR ax, ax
        XOR dx, dx

        MOV ax, bx  ; Mover parte flotante a AX
        MOV bx, 10  ; Ponemos nuestro divisor en BX
        p32_FLT_loop:   ; Procesar digitos flotantes
            CMP cx, 11
                JE p32_midpoint ; Si ya no quedan digitos salimos del loop
            DEC si  ; Movemos el cabezal de lectura una posicion atras
            DEC cx  ; Decrementamos el contador
            DIV bx  ; Aislamos un digito del numero

            ADD dl, 30h ; Convertimos el digito a ASCII
            MOV [si], dl; Movemos el caracter a la cadena

            XOR dx, dx  ; Limpiamos el residuo de la div (DX)
            JMP p32_FLT_loop

        p32_midpoint:   ; Despues del primer ciclo
        DEC si
        MOV cx, 10
        MOV ax, [aux+2] ; Movemos a AX nuestro primeros 4 digitos de la parte entera
        p32_INT1_loop:   ; Procesar digitos enteros
            CMP cx, 6
                JE p32_endpoint1 ; Si ya no quedan digitos moverse a la siguiente parte
            DEC si  ; Mover el cabezal de lectura una posicion atras
            DEC cx  ; Decrementamos el contador

            DIV bx          ; Aislar un digito
            ADD dl, 30h     ; Convertir digito a ASCII
            MOV [si], dl    ; Mover digito a la cadena
            
            XOR dx, dx      ; Limpiar registro
            JMP p32_INT1_loop

        p32_endpoint1:  ; Despues del segundo ciclo
        MOV ax, [aux]; Movemos a AX el resto de digitos de la parte entera
        CMP ax, 0
        p32_INT2_loop:
            CMP ax, 0
                JE p32_endpoint2 ; Si ya no quedan digitos moverse a la siguiente parte
            DEC cx  ; Decrementamos el contador
            DEC si  ; Mover el cabezal de lectura una posicion atras

            DIV bx          ; Aislar un digito
            ADD dl, 30h     ; Convertir digito a ASCII
            MOV [si], dl    ; Mover digito a la cadena
            
            XOR dx, dx      ; Limpiar registro
            JMP p32_INT2_loop

        p32_endpoint2:  ; Despues del tercer ciclo
    JMP PARSE_RET
    ; (2)
    PARSE16:
        MOV cx, 13
        MOV [aux], ax
        MOV ax, bx ; Mover primero la parte flotante
        MOV bx, 10 ; Mover a BX nuestro divisor
        p16_FLT_loop:   ; Procesar digitos flotantes
            CMP cx, 11
                JE p16_midpoint ; Si ya no quedan digitos salimos del loop
            DEC si  ; Movemos el cabezal de lectura una posicion atras
            DEC cx  ; Decrementamos el contador
            DIV bx  ; Aislamos un digito del numero

            ADD dl, 30h ; Convertimos el digito a ASCII
            MOV [si], dl; Movemos el caracter a la cadena

            XOR dx, dx  ; Limpiamos el residuo de la div (DX)
            JMP p16_FLT_loop
        p16_midpoint:   ; Despues del primer ciclo
        DEC si
        MOV cx, 10
        MOV ax, [aux]   ; Mover nuevamente a AX la parte entera
        CMP ax, 0
            JE p16_endpoint
        p16_INT_loop:   ; Procesar digitos enteros
            CMP ax, 0
                JE PARSE_RET ; Si ya no quedan digitos salimos del loop
            DEC si  ; Movemos el cabezal de lectura una posicion atras
            DEC cx  ; Decrementamos el contador
            DIV bx  ; Aislamos un digito del numero

            ADD dl, 30h ; Convertimos el digito a ASCII
            MOV [si], dl; Movemos el caracter a la cadena

            XOR dx, dx  ; Limpiamos el residuo de la div (DX)
            JMP p16_INT_loop

        p16_endpoint:   ; Despues del segundo ciclo
        DEC cx
    PARSE_RET:
    XOR ax, ax
    XOR bx, bx
    XOR dx, dx

    MOV [aux], ax
    MOV [aux+2], ax
    ret
PARSE endp  ; Al final del proceso se guarda en CX el indice donde esta la ultima cifra significativa

; Limpia la cadena guardada en SI con el formato esperado de '0000000000.00'
CLEAN_32STR proc
    ; RIGHT -> LEFT
    MOV ah, 30h ; Caracter '0'
    MOV cx, 13  ; Contador
    clean_loop:
        CMP cx, 10  ; Posicion donde esta la coma
            JE loop_skip
        CMP cx, 13  ; Final de la cadena
            JE loop_skip
        CMP cx, 0   ; Inicio de la cadena
            JE clean_endpoint
        MOV [si], ah
        loop_skip:
        DEC si
        DEC cx
        JMP clean_loop

    clean_endpoint:
    ret
CLEAN_32STR endp

; Muestra el contenido en DX
PRINTOUT proc
    MOV ah, 09h
    INT 21h ; Redirecciona al output lo que sea que haya en DX

    XOR ax, ax  ; Limpiar registro
    XOR dx, dx  ; Limpiar registro
    ret
PRINTOUT endp

END START ; Fin del programa, punto de entrada es START
