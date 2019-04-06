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
	call getbyte
	push ax
	call newline
	pop ax
	mov bl, al
	call getword
	push ax
	call newline
	pop ax
	mul bl
	call displayword
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
