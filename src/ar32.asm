; Codigo trasladado de operaciones aritmeticas para manipular datos de 32 cuando hay numeros muy grandes
; Por Frederick Obando
.model SMALL
.stack 100H
.DATA ; Seccion de inicializacion de datos
    param1 DW 1, 1, 0 ; High:Low.Float
        ; bytes 1 a 4 el numero entero, mientras que los ultimos dos son la parte flotante
    param2 DW 0, 2, 0  ; High:Low.Float
        ; de manera algebraica un numero de 32 bits se tal que [High](65535)+[Low]
        ; entonces los primeros 16 bits son un multiplicador y los otros 16 son el exceso
    result DW 0, 0, 0

    aux DW 0, 0, 0 ; Variable auxiliar para guardar resultados intermedios

    prompt db 'El resultado final: $'

    num_string DB 10 DUP('0'), '.', 2 DUP('0'), '$'

    crlf DB 0Dh, 0Ah, '$'   ; Carriage return & newline

; NOTA: en param1 y param2 si el numero es de 16 bits se debe meter en [param+2], 
; si es de 32 bits los 16 bits inferiores van en [param+2] y los superiores en [param]
; la parte flotante siempre va en [param+4]
.CODE ; Seccion de codigo ejecutable
START:
    MOV ax, @DATA 
    MOV ds, ax  ; Inicializar la seccion de DATA
    XOR ax, ax
    ; Operaciones que queramos a hacer
    CALL multiply ; operacion 1

    LEA dx, [prompt]
    CALL PRINTOUT

    MOV si, offset num_string+13
    MOV ax, [result+2] ; 16 bits bajos del entero
    MOV dx, [result]   ; 16 bits altos del entero
    MOV bx, [result+4] ; Parte flotante 
    CALL PARSE

    MOV si, cx
    LEA dx, [num_string+si]
    CALL PRINTOUT

    LEA dx, crlf
    CALL PRINTOUT
    ; Operaciones que queramos a hacer
    JMP EXIT
; Seccion de metodos para operaciones aritmeticas con datos con parte flotante
; (1)
    addition proc ; (INT1+INT2)+[(FLT1+FLT2)/100]
        ; 1. (Sumar partes enteras)
            ; (a)[Sumar las partes bajas]
            MOV ax, [param1+2]
            MOV bx, [param2+2]

            MOV dx, [param1]
            MOV cx, [param2]
            ; (b)[Sumar las partes altas CON accarreo resultante de partes bajas]
            ADD ax, bx
            ADC dx, cx

            MOV [result+2], ax ; Mover resultado en parte baja
            MOV [result], dx ; Mover resultado en parte alta
            ; Limpieza de registros
            XOR ax ,ax
            XOR bx, bx
            XOR cx, cx
            XOR dx, dx
        ; 2. (Sumar partes flotantes)
            ; (a)[Sumar las partes flotantes]
            MOV ax, [param1+4]
            MOV bx, [param2+4]
            ADD ax, bx
            ; (b)[Hacer ajuste para parte decimal]
            MOV bx, 100
            DIV bx  ; El cociente resultante se añade a la parte entera, y el residuo a la parte decimal

            MOV [result+4], dx  ; Guardar parte flotante
            ADD [result+2], ax  ; Añadir a la parte entera
                JNC add_skipcarry 
            MOV cx, [result]
            INC cx
            MOV [result], cx
            ; Limpieza de registros
        add_skipcarry:
            XOR ax, ax
            XOR bx, bx
            XOR cx, cx
            XOR dx, dx
        ret
    addition endp 
; (2)
    substract proc ; (INT1-INT2)+(FLT1-FLT2)/100
        ; 1. (Restar partes enteras)
            ; (a)[Resta]
            MOV ax, [param1+2]  ; 16-bits bajos
            MOV dx, [param1]    ; 16-bits altos

            MOV bx, [param2+2]  ; 16-bits bajos
            MOV cx, [param2]    ; 16-bits altos

            SUB ax, bx  ; Restar ambos 16 bits bajos 
            SBB dx, cx  ; Restar ambos 16 bits altos, pidiendo 'prestado' a la parte alta de lo que necesita la parte baja
                    ; DX:AX = INT1-INT2
            XOR bx, bx 
            XOR cx, cx
            ; MOV bx, 100
            ; MUL bx
            ; (b)[Mover resultados]
            MOV [result+2], ax
            MOV [result], dx
            ; (c)[Limpiar resgitros]
            XOR ax, ax
            XOR bx, bx
            XOR dx, dx
        ; 2. (Restar partes flotantes)
            MOV ax, [param1+4]
            MOV cx, [param1+4]
            MOV bx, [param2+4]
            
            SUB ax, bx
            CMP cx, bx
                JG sub_nofix
            MOV bx, -1
            IMUL bx

            MOV bx, 100
            SUB bx, ax
            MOV ax, bx
            
            DEC [result+2]

            sub_nofix:
            MOV [result+4], ax

            XOR ax, ax
            XOR bx, bx
            XOR cx, cx
        ret
    substract endp
; (3)
    multiply proc  ; [INT1*INT2]+[(INT1*FLT2)/100]+[(INT2*FLT1)/100]+[(FLT1*FLT2)/100^2]
        ; (1)
        ; partes altas
        MOV ax, [param1]
        MOV bx, [param2]
        MUL bx

        ADD [aux], dx
        ADD [aux+2], ax

        XOR ax, ax
        XOR bx, bx

        ; alto 1 y bajo 2
        MOV ax, [param1]
        MOV bx, [param2+2]
        MUL bx

        ADD [aux+2], ax
        ADC [aux], dx

        XOR ax, ax
        XOR bx, bx

        ; bajo 1 y alto 2
        MOV ax, [param1+2]
        MOV bx, [param2]
        MUL bx

        ADD [aux+2], ax
        ADC [aux], dx

        XOR ax, ax
        XOR bx, bx

        ; bajo 1 y bajo 2
        MOV ax, [param1+2]
        MOV bx, [param2+2]
        MUL bx

        ADD [aux+2], ax
        ADC [aux], dx

        XOR ax, ax
        XOR bx, bx

        MOV ax, [aux+2]
        MOV [result+2], ax
        MOV ax, [aux]
        MOV [result], ax

        XOR ax, ax
        ; MOV ax, [param1+2]  ; 0
        ; MOV dx, [param1]    ; DX:AX = INT1 1
        
        ; MOV bx, [param2+2]  ; 2
        ; MOV cx, [param2]    ; CX:BX = INT2 0

        ; MUL bx

        ; MOV bx, ax
        ; MOV ax, dx
        ; MUL cx

        ; ADD dx, bx

        ; MOV ax, cx
        ; MUL dx
        ; ADD bx, dx

        ; MOV [result+2], ax
        ; MOV [result], dx
        ; (2)
        ; (3)
        ; (4)
        ret
    multiply endp 
; (4)
    divide proc    ; [100(INT1)+FLT1]/[100(INT2)+FLT2]
        ret
    divide endp
; Seccion para metodos de conversion y escritura
; (a)
    PRINTOUT proc ; Hace 'print' de una cadena en DX
        mov ah, 09h
        int 21h ; Redirecciona al output lo que sea que haya en DX
        ret
    PRINTOUT endp
; (b)
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
                CMP ax, 0
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
; (c)
    CLEAN_STR proc
        ret
    CLEAN_STR endp
EXIT: 
    MOV ah, 4ch
    INT 21h    ; Finaliza nuestro programa
END   ; Fin del codigo