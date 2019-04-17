.8086
.model small
.stack
.data
	msga db "Number:$"
	msgb db "Factorial:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

; arg1: lower byte is 'n'
; tolerates one product result outside ax
factorial proc
	push bp
	mov bp, sp
	push cx
	mov cx, [bp + 4]
	mov ch, 0
	mov ax, 1
	mov dx, 0
factorial_lower:
	mul cx
	loop factorial_lower
	pop cx
	pop bp
	ret
endp

main proc
	mov ax, @data
	mov ds, ax
	push si
	mov si, offset msga
	push si
	call printstring
	pop si
	pop si
	call getbyte
	push ax
	call newline
	pop ax
	push ax
	call factorial
	push ax
	push si
	mov si, offset msgb
	push si
	call printstring
	pop si
	pop si
	pop ax
	call displaydoubleword
	pop ax
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
