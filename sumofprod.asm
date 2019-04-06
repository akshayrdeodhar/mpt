.8086
.model small
.stack
.data
	msg1 db "a:$"
	msg2 db "b:$"
	msg3 db "c:$"
	msg4 db "d:$"
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
	mov bl, al
	mov si, offset msg2
	push si
	call printstring
	pop si
	call getbyte
	push ax
	call newline
	pop ax
	mul bl ; (a * b)
	mov cx, ax
	mov si, offset msg3
	push si
	call printstring
	pop si
	call getbyte
	push ax
	call newline
	pop ax
	mov bl, al ; c
	mov si, offset msg4
	push si
	call printstring
	pop si
	call getbyte
	push ax
	call newline
	pop ax
	mul bl ; (c * d)
	add ax, cx
	call displayword
	call newline
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
