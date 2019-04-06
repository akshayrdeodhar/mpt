.8086
.model small
.stack
.data
	msg1 db "Length:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
	copy db 100 dup(?)
.code

include helper.asm

; arg1: address of source
; arg2: address of destination
; arg3: size of array
; assumes address of data segment in ds
arraycopy proc
	push bp
	mov bp, sp
	push di
	push si
	push cx
	mov ax, @data ; cheating, but necessary
	mov es, ax
	mov si, [bp + 04h]
	mov di, [bp + 06h]
	mov cx, [bp + 08h]
	cld
	rep
	movsb
	pop cx
	pop si
	pop di
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
	mov di, offset copy
	push ax
	push di
	push si
	call arraycopy
	pop si
	pop di
	pop ax
	push ax
	push si
	call displayarray
	pop si
	pop ax
	ret
endp

.startup
call main
mov ah, 4ch
int 21h
end
