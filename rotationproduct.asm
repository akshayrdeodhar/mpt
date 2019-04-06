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
	mov ax, [bp + 4]
	mov dl, ah
	mov dh, 0
	mov cx, 0
	mov ah, 0
again:  shr al, 1
	jnc skip
	add cx, dx
skip:	shl dx, 1
	cmp al, 1
	jnc again
	mov ax, cx
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
