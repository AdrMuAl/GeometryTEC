; Codigo de ejemplo y pruebas para manejo de flotantes y acarreo
; por Frederick Obando Solano

.data   ; Seccion de inicializacion de datos (variables)
    sit db 1    ; Esta 'variable' en memoria almacena la situacion a evaluar

    fap db 147  ; variable (8 bits) de un byte para un valor
    dfap db 10  ; varibale (8 bits) de un byte de la parte decimal de 'fap'

    tap dw 1304 ; variable (16 bits) de un word para un valor
    dtap db 7   ; variable (8 bits) de un byte de la parte decimal de dtap

.code   ; Seccion de codigo ejecutble
    START:  ; Etiqueta (label) al inicip del programa
        test sit, 1
            jz addition

        test sit, 2
            jz substraction

        test sit, 3
            jz multiply

        test sit, 4
            jz divide
        
        jmp EXIT
    ;         funciones aritmeticas basicas
    ; ----------------------------------------------
    addition:   ; Ejecuta una suma basica
        mov ah, fap
        mov bl, dfap

        ret
    substraction:   ; Ejecuta una resta basica

        ret
    multiply:   ; Ejecuta una multiplacion basica

        ret
    divide:     ; Ejecuta una division basica

        ret
    ; ----------------------------------------------
    EXIT:   ; Etiqueta (label) al final del programa
end     ; Indica el final del codigo para el ensamblador