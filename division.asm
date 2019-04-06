.8086
.model small
.stack
.data
	msg1 db "Quotient:$"
	msg2 db "Remainder:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

main proc
	mov ax, @data
	mov ds, ax
	call getword
	push ax
	call newline
	pop ax
	mov dx, ax
	call getbyte
	push ax
	call newline
	pop ax
	mov bl, al
	mov ax, dx
	div bl
	mov si, offset msg1
	push ax
	push si
	call printstring
	pop si
	pop ax
	push ax
	call displaybyte
	pop ax
	push ax
	call newline
	pop ax
	mov al, ah
	mov si, offset msg2
	push ax
	push si
	call printstring
	pop si
	pop ax
	call displaybyte
	push ax
	call newline
	pop ax
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
