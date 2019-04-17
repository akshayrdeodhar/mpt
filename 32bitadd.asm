.8086
.model small
.stack
.data
	msg1 db "Length:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
	msga db "Number 1:$"
	msgb db "Number 2:$"
.code

include helper.asm

main proc
	mov ax, @data
	mov ds, ax
	mov si, offset msga
	push si
	call printstring
	pop si
	call getdoubleword
	mov cx, dx
	mov bx, ax
	push ax
	call newline
	pop ax
	mov si, offset msgb
	push si
	call printstring
	pop si
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
