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

space proc
	push dx
	mov dl, ' '
	mov ah, 02
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

; get 2 byte word in ax
getword proc
	push bx
	call getbyte
	mov bh, al
	call getbyte
	mov bl, al
	mov ax, bx
	pop bx
	ret
endp

; display content of ax, (destroys)
displayword proc
	push bx
	mov bl, al
	mov al, ah
	call displaybyte
	mov al, bl
	call displaybyte
	pop bx
	ret
endp
	
; gets double word in dx-ax	
getdoubleword proc
	call getword
	mov dx, ax
	call getword
	ret
endp

; displays dx-ax
displaydoubleword proc
	push ax
	mov ax, dx
	call displayword
	pop ax
	call displayword
	ret
endp	
	

; JUST AN IDEA: Write a general n-byte add procedure

; arg1: location
; arg2: rows
; arg3: columns
getmat proc
	push bp
	mov bp, sp
	push dx
	push cx
	push bx
	mov dl, [bp + 8] ; columns
	mov dh, 0
	mov cl, [bp + 6] ; rows
	mov ch, 0
	mov bx, [bp + 4] ; base address
getmat_again:	
	push dx
	push bx
	call getarray
	pop bx
	pop dx
	add bx, dx
	loop getmat_again
	pop bx
	pop cx
	pop dx
	pop bp
	ret
endp


; arg1: location
; arg2: rows
; arg3: columns
displaymat proc
	push bp
	mov bp, sp
	push dx
	push cx
	push bx
	mov dl, [bp + 8] ; columns
	mov dh, 0
	mov cl, [bp + 6] ; rows
	mov ch, 0
	mov bx, [bp + 4] ; base address
displaymat_again:	
	push dx
	push bx
	call displayrow
	pop bx
	pop dx
	add bx, dx
	loop displaymat_again
	pop bx
	pop cx
	pop dx
	pop bp
	ret
endp


; arg1 address of row (assuming ds)
; arg2 length of row
displayrow proc
	push bp
	mov bp, sp
	push si
	push cx
	mov si, [bp + 4]
	mov cx, [bp + 6]
displayrow_next:
	mov al, [si]
	call displaybyte
	inc si
	call space
	loop displayrow_next
	call newline
	pop cx
	pop si
	pop bp
	ret
endp


