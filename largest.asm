.8086
.model small
.stack
.data
	msg1 db "Length:$"
	msg2 db "Elements:$"
	msg3 db "Largest:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

; arg1: address of source
; arg2: size of array
; assumes address of data segment in ds
largest proc
	push bp
	mov bp, sp
	push si
	push cx
	mov si, [bp + 04h]
	mov cx, [bp + 06h]
	mov al, [si]
	inc si
	dec cx
	jc largest_end ; cx is negative
largest_nextbyte:
	mov ah, [si]
	cmp al, ah
	jnc largest_still
	mov al, ah
largest_still:
	inc si
	loop largest_nextbyte
largest_end:
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
	mov si, offset msg2
	push si
	call printstring
	pop si
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
	call largest
	push ax
	push si
	mov si, offset msg3
	push si
	call printstring
	pop si
	pop si
	pop ax
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
