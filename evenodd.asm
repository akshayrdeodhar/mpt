.8086
.model small
.stack
.data
	msg1 db "Number:$"
	msg2 db "Even$"
	msg3 db "Odd$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

main proc
	mov ax, @data
	mov ds, ax
	mov si, offset msg1
	push si
	call printstring
	pop si
	call getbyte
	push ax
	call newline
	pop ax
	test al, 1
	jnz odd
	mov si, offset msg2
	jmp end
odd:	mov si, offset msg3
end:	push si
	call printstring
	pop si
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
