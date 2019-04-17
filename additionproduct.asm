.8086
.model small
.stack
.data
	msga db "Number 1:$"
	msgb db "Number 2:$"
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
	mov ax, @data
	mov ds, ax
	mov si, offset msga
	push si
	call printstring
	pop si
	call getbyte
	push ax
	call newline
	pop ax
	mov dh, al
	mov si, offset msgb
	push si
	call printstring
	pop si
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
