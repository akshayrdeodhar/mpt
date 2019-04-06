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
arrayexchange proc
	push bp
	mov bp, sp
	push di
	push si
	push cx
	mov si, [bp + 04h]
	mov di, [bp + 06h]
	mov cx, [bp + 08h]
arrayexchange_nextbyte:
	mov al, [si]
	mov ah, [di]
	mov [si], ah
	mov [di], al
	inc si
	inc di
	loop arrayexchange_nextbyte
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
	mov si, offset copy
	push ax
	call newline
	pop ax
	push ax
	push si
	call getarray
	pop si
	pop ax
	mov si, offset block
	mov di, offset copy
	push ax
	call newline
	pop ax
	push ax
	push di
	push si
	call arrayexchange
	pop si
	pop di
	pop ax
	push ax
	call newline
	pop ax
	push ax
	push si
	call displayarray
	pop si
	pop ax
	push ax
	call newline
	pop ax
	push ax
	push di
	call displayarray
	pop di
	pop ax

endp

.startup
call main
mov ah, 4ch
int 21h
end
