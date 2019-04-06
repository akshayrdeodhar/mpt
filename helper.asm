; gets ascii in al
getchar proc
	mov ah, 01h
	int 21h
	ret
endp

; convert nibble to ascii in al
nibble2ascii proc
	and al, 15
	cmp al, 0ah	
	jc nibble2ascii_smaller
	add al, 07h
nibble2ascii_smaller:
	add al, 30h
	ret
endp

; converts ascii in al to lower nibble in al
ascii2nibble proc
	cmp al, 3ah
	jc ascii2nibble_smaller
	sub al, 07h
ascii2nibble_smaller:
	sub al, 30h
	and al, 15
	ret
endp

newline proc
	push dx
	mov dl, 0ah
	mov ah, 02h
	int 21h
	mov dl, 0dh
	mov ah, 02h
	int 21h
	pop dx
	ret
endp

; gets byte in al
getbyte proc
	push cx
	push bx
	mov cl, 04h
	call getchar
	call ascii2nibble
	rol al, cl
	mov bl, al
	call getchar
	call ascii2nibble
	or al, bl
	pop bx
	pop cx
	ret
endp

; displays byte in al
displaybyte proc
	push dx
	push cx
	push bx
	mov bl, al
	mov cl, 04h
	ror al, cl
	call nibble2ascii
	mov dl, al
	mov ah, 02h
	int 21h
	mov al, bl
	and al, 15
	call nibble2ascii
	mov dl, al
	mov ah, 02h
	int 21h
	pop bx
	pop cx
	pop dx
	ret
endp

; arg1: address of string
printstring proc
	push bp
	mov bp, sp
	push dx
	mov dx, [bp + 4]
	mov ah, 09h
	int 21h
	pop dx
	pop bp
	ret
endp

; arg1 address of array (assuming ds)
; arg2 length of array
getarray proc
	push bp
	mov bp, sp
	push di
	push cx
	mov si, [bp + 4]
	mov cx, [bp + 6]
	cld
getarray_next:
	call getbyte	
	mov [si], al
	inc si
	call newline
	loop getarray_next
	pop cx
	pop di
	pop bp
	ret
endp


; arg1 address of array (assuming ds)
; arg2 length of array
displayarray proc
	push bp
	mov bp, sp
	push si
	push cx
	mov si, [bp + 4]
	mov cx, [bp + 6]
displayarray_next:
	mov al, [si]
	call displaybyte
	inc si
	call newline
	loop displayarray_next
	pop cx
	pop si
	pop bp
	ret
endp

