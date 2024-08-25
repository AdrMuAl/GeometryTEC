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
    perimeter DW 0   ; Perímetro en una palabra
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
