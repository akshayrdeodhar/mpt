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
	call getbyte
	mov bl, al
	push ax
	call newline
	pop ax
	call getbyte
	push ax
	call newline
	pop ax
	sub bl, al
	mov al, bl
	call displaybyte
	call newline
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
