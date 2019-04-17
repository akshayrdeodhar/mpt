.8086
.model small
.stack
.data
	msga db "Number:$"
	msgb db "Series:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

main proc
	mov ax, @data
	mov ds, ax
	mov si, offset msga
	push si
	call printstring
	pop si
	call getbyte
	mov ah, 0
	push ax
	call newline
	pop ax
	push ax
	push si
	mov si, offset msgb
	push si
	call printstring
	pop si
	pop si
	pop ax
	push ax
	call newline
	pop ax
	mov cx, ax
	cmp cx, 1
	jc stop ; 0 terms?
	mov ax, 0 ; f0
	mov bx, 1 ; f1
nextterm:
	push ax
	call displayword
	call newline
	pop ax
	add ax, bx
	xchg ax, bx
	loop nextterm
stop:
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
