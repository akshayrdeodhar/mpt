.8086
.model small
.stack
.data
	n_line db 0ah, 0dh, "$"
	msg1 db "N1:$"
	msg2 db "N2:$"
	msg3 db "Product:$"
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
	mov ax, @data
	mov ds, ax
	mov si, offset msg1
	push ax
	push si
	call printstring
	pop si
	pop ax
	call getbyte
	push ax
	call newline
	pop ax
	mov dh, al
	mov si, offset msg2
	push ax
	push si
	call printstring
	pop si
	pop ax
	call getbyte
	push ax
	call newline
	pop ax
	mov dl, al
	push dx
	call product
	pop dx
	mov si, offset msg3
	push ax
	push si
	call printstring
	pop si
	pop ax
	call displayword
	ret
endp
	
.startup
call main
mov ah, 4ch
int 21h
end
