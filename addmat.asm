.8086
.model small
.stack
.data
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
	block2 db 100 dup(?)
	answer db 100 dup(?)
.code

include helper.asm

; arg1: result location
; arg2: locationa
; arg3: locationb
; arg4: rows
; arg5: columns
addmat proc
	push bp
	mov bp, sp
	push dx
	push cx
	push bx
	mov dl, [bp + 12] ; columns
	mov dh, 0
	mov al, [bp + 10] ; rows
	mov ah, 0
	mul dl ; contiguous storage!
	mov cx, ax
	mov si, [bp + 8]
	mov di, [bp + 6]
	mov bx, [bp + 4]
addmat_again:
	mov al, [di]
	add al, [si]
	mov [bx], al
	inc bx
	inc si
	inc di
	loop addmat_again
	pop bx
	pop cx
	pop dx
	pop bp
	ret
endp



main proc
	mov ax, @data
	mov ds, ax
	mov si, offset block
	call getbyte
	push ax
	call newline
	pop ax
	mov dl, al
	call getbyte
	push ax
	call newline
	pop ax
	mov bx, ax
	push bx
	push dx
	push si
	call getmat
	pop si
	pop dx
	pop bx
	push bx
	push dx
	push si
	call displaymat
	pop si
	pop dx
	pop bx
	push ax
	call newline
	pop ax
	mov si, offset block2
	push bx
	push dx
	push si
	call getmat
	pop si
	pop dx
	pop bx
	push bx
	push dx
	push si
	call displaymat
	pop si
	pop dx
	pop bx
	mov cx, bx
	mov bx, offset answer
	mov si, offset block
	mov di, offset block2
	push cx
	push dx
	push di
	push si
	push bx
	call addmat
	pop bx
	pop si
	pop di
	pop dx
	pop cx
	push ax
	call newline
	pop ax
	push cx
	push dx
	push bx
	call displaymat
	pop bx
	pop dx
	pop cx
	ret
endp
	
.startup
call main
mov ah, 4ch
int 21h
end
