.model small
.stack 100h
.data
    input db 20   ; Buffer para la entrada del usuario
          db 0
          db 20 dup(0)

    msg db 0Dh, 0Ah, 'Enter a number: ', 0Dh, 0Ah, '$'
    result db 0Dh, 0Ah, 'Number processed successfully', 0Dh, 0Ah, '$'
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
    mov si, offset input+2    ; Direccionar el buffer de entrada (omitimos el primer byte de longitud)
    mov dl, [input+1]
    call ConvertToFloat

    mov ax, parte_entera
    sub ax, parte_decimal
    cmp ax, 10  ; Comparacion de prueba
        jnz skip

    xor ax, ax
    ; Mostrar el resultado
    mov ah, 09h
    lea dx, result
    int 21h

    skip: 
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

    cmp dl, 0
        jz buffer_end

    mov ax, 0
    mov bl, 10
    jmp buffer_integer_loop

buffer_integer_loop:
    mov cl, [si]
    cmp cl, '.'
        je buffer_integer_end  ; Si encontramos un punto decimal, procesar la parte decimal
    cmp cl, 0Dh        ; Fin de línea
        je buffer_end
    cmp cl, 0Ah        ; Fin de línea
        je buffer_end
    sub cl, 30h        ; Convertir el carácter a un número
    xor ch, ch

    mul bl             ; Multiplicar por 10 los digitos convertidos, los mueve una posicion a la derecha
    add ax, cx         ; Añadir el nuevo digito
    inc si   ; Mover el puntero lectura
    jmp buffer_integer_loop

buffer_integer_end:
    ; Procesar la parte decimal
    mov parte_entera, ax
    mov ax, 0
    inc si
buffer_float_loop:
    mov cl, [si]
    cmp cl, 0Dh
        je buffer_end
    cmp cl, 0Ah
        je buffer_end
    sub cl, '0'
    xor ch, ch
    
    mul bl
    add ax, cx
    inc si
    jmp buffer_float_loop

buffer_end:
    mov parte_decimal, ax
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    ret
ConvertToFloat endp

end main