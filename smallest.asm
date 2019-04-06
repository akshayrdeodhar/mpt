.8086
.model small
.stack
.data
	msg1 db "Length:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

; arg1: address of source
; arg2: size of array
; assumes address of data segment in ds
smallest proc
	push bp
	mov bp, sp
	push si
	push cx
	mov si, [bp + 04h]
	mov cx, [bp + 06h]
	mov al, [si]
	inc si
	dec cx
	jc smallest_end ; cx is negative
smallest_nextbyte:
	mov ah, [si]
	cmp ah, al
	jnc smallest_still
	mov al, ah
smallest_still:
	inc si
	loop smallest_nextbyte
smallest_end:
	pop si
	pop cx
	pop bp
	ret
endp
	

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
	mov ah, 0
	mov si, offset block
	push ax
	push si
	call getarray
	pop si
	pop ax
	push ax
	call newline
	pop ax
	push ax
	push si
	call smallest
	call displaybyte
	pop si
	pop ax
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
