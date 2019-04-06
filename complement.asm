.8086
.model small
.stack
.data
	msg1 db "Number:$"
	msg2 db "1C:$"
	msg3 db "2C:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

main proc
	mov ax, @data
	mov ds, ax
	mov si, offset msg1
	push ax
	push si
	call printstring
	pop si
	pop ax
	call getbyte
	push ax
	call newline
	pop ax
	not al
	mov si, offset msg2
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
	mov si, offset msg3
	inc al
	push ax
	push si
	call printstring
	pop si
	pop ax
	call displaybyte
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
