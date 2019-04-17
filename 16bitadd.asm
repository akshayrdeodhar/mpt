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
	call getword
	mov bx, ax
	push ax
	call newline
	pop ax
	mov si, offset msgb
	push si
	call printstring
	pop si
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
