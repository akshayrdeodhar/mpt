.8086
.model small
.stack
.data
	msg1 db "Length:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

main proc
	call getdoubleword
	mov cx, dx
	mov bx, ax
	push ax
	call newline
	pop ax
	call getdoubleword
	push ax
	call newline
	pop ax
	clc
	adc ax, bx
	adc dx, cx
	call displaydoubleword
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
