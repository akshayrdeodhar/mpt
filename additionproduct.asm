.8086
.model small
.stack
.data
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

;arg1 2 bytes are two terms of the product
product proc
	push bp
	mov bp, sp
	push dx
	push cx
	push bx
	mov ax, [bp + 4]
	mov dl, ah
	mov dh, 0
	mov bx, 0
	mov cl, al
	mov ch, 0
again:	add bx, dx
	loop again
	mov ax, bx
	pop bx
	pop cx
	pop dx
	pop bp
	ret
endp

main proc
	call getbyte
	push ax
	call newline
	pop ax
	mov dh, al
	call getbyte
	push ax
	call newline
	pop ax
	mov dl, al
	push dx
	call product
	pop dx
	call displayword
	ret
endp
	
.startup
call main
mov ah, 4ch
int 21h
end
