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
	call getword
	mov bx, ax
	push ax
	call newline
	pop ax
	call getword
	push ax
	call newline
	pop ax
	add ax, bx
	call displayword
	call newline
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
