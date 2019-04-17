.8086
.model small
.stack
.data
	msg1 db "Length:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
	msga db "Number 1:$"
	msgb db "Number 2:$"
	msgc db "Sum:$"
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
	mov bl, al
	push ax
	call newline
	pop ax
	mov si, offset msgb
	push si
	call printstring
	pop si
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
