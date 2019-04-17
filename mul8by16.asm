.8086
.model small
.stack
.data
	msg1 db "8 Bit Number:$"
	msg2 db "16 Bit Number:$"
	msg3 db "Product:$"
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
	push ax
	push si
	call printstring
	pop si
	pop ax
	call getword
	push ax
	call newline
	pop ax
	push ax
	push si
	mov si, offset msg3
	push si
	call printstring
	pop si
	pop si
	pop ax
	mov bh, 0
	mul bx
	call displaydoubleword
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
