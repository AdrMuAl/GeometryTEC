.model small
.stack 100h
.data
    input db 20 dup('$')   ; Buffer para la entrada del usuario
    msg db 'Enter a number: $'
    result db 'Result: $'
    crlf db 13, 10, '$'   ; Carriage return y newline
    parte_entera dw 0      ; Variable para guardar la parte entera
    parte_decimal dw 0     ; Variable para guardar la parte decimal

.code
main proc
    ; Inicializar el segmento de datos
    mov ax, @data
    mov ds, ax

    ; Solicitar la entrada del usuario
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Leer la entrada del usuario
    mov ah, 0Ah
    lea dx, input
    int 21h

    ; Convertir el número ASCII a flotante
    lea si, input+2    ; Direccionar el buffer de entrada (omitimos el primer byte de longitud)
    call ConvertToFloat

    ; Mostrar el resultado
    mov ah, 09h
    lea dx, result
    int 21h

    ; Terminar el programa
    mov ah, 4Ch
    int 21h
main endp

; Convertir la cadena ASCII en un número flotante
ConvertToFloat proc
    ; Inicializar registros
    xor ax, ax         ; AX para la parte entera
    xor bx, bx         ; BX para la parte decimal
    xor cx, cx         ; CX para el factor de la parte decimal (10^n)
    mov dx, 0          ; DX para el signo del número

    ; Leer la parte entera
    mov cl, [si]       ; Cargar el primer carácter
    cmp cl, '-'        ; Verificar si el número es negativo
    je NegativeNumber
    cmp cl, '+'
    je PositiveNumber
    jmp ConvertLoop

NegativeNumber:
    mov dx, 1          ; Indicar que el número es negativo
    inc si
    jmp ConvertLoop

PositiveNumber:
    inc si
    jmp ConvertLoop

ConvertLoop:
    mov al, [si]
    cmp al, '.'
    je ConvertDecimal  ; Si encontramos un punto decimal, procesar la parte decimal
    cmp al, 0Dh        ; Fin de línea
    je EndConversion
    cmp al, 0Ah        ; Fin de línea
    je EndConversion
    sub al, '0'        ; Convertir el carácter a un número
    mov ah, 0
    mov bx, ax
    mov ax, 10
    mul bx             ; Multiplicar por 10
    add ax, bx         ; Añadir el nuevo dígito
    mov bx, ax         ; Guardar la nueva parte entera
    inc si
    jmp ConvertLoop

ConvertDecimal:
    ; Procesar la parte decimal
    mov cx, 1          ; Iniciar el factor de la parte decimal
    inc si
DecimalLoop:
    mov al, [si]
    cmp al, 0Dh
    je EndConversion
    cmp al, 0Ah
    je EndConversion
    sub al, '0'
    mov ah, 0
    mov bx, ax
    mov ax, 10
    mul bx             ; Multiplicar la parte decimal por 10
    add ax, bx         ; Añadir el nuevo dígito
    mov bx, ax         ; Guardar la nueva parte decimal
    inc si
    jmp DecimalLoop

EndConversion:
    ; Aplicar signo
    cmp dx, 1
    jne StoreResult
    neg ax             ; Negar el resultado si el número es negativo

StoreResult:
    ; Guardar la parte entera y la parte decimal en variables separadas
    mov parte_entera, bx
    mov parte_decimal, ax

    ret
ConvertToFloat endp

end main
