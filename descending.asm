.8086
.model small
.stack
.data
	msg1 db "Length:$"
	n_line db 0ah, 0dh, "$"
	block db 100 dup(?)
.code

include helper.asm

; arg1 address of array
; arg2 sizeof array
sort proc
	push bp
	mov bp, sp
sort_again:  
	mov bx, [bp + 04h]
	mov cx, [bp + 06h]
	dec cx
sort_next:   
	mov al, [bx]
	mov ah, [bx + 01h]
	cmp al, ah
	jc sort_smaller
	inc bx
	dec cx
	jnz sort_next
	pop bp
	ret
sort_smaller:
	mov [bx], ah
	mov [bx + 01], al
	jmp sort_again
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
	call sort
	pop si
	pop ax
	push ax
	call newline
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
