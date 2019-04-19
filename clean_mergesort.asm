.8086
.model small
.stack
.data
	msga db "Enter Array:$"
	block2 db 0ch, 22h, 5, 8, 9, 11, 13
	block1 db 09h, 22h, 6, 7, 10, 12, 14, 16, 18, 19, 20
	block3 db 20 dup(?)
	block4 db 20 dup(?)
	block5 db 100 dup(?)
	block6 db 100 dup(?)
.code

; arg1: address of string
printstring proc
	push bp
	mov bp, sp
	push dx
	mov dx, [bp + 4]
	mov ah, 09h
	int 21h
	pop dx
	pop bp
	ret
endp

getchar proc
	mov ah, 1 ; get character in al
	int 21h
	ret
endp

putchar proc
	push dx
	mov dl, al
	mov ah, 2
	int 21h
	pop dx
	ret
endp

newline proc
	mov al, 0dh
	call putchar
	mov al, 0ah
	call putchar
	ret
endp

; converts lower nibble of al to ascii in al
nibble2ascii proc
	and al, 15 ; mask off upper nibble
	cmp al, 10
	jc nibble2ascii_next
	add al, 7
nibble2ascii_next:
	add al, 30h
	ret
endp

ascii2nibble proc
	cmp al, 3ah
	jc ascii2nibble_next
	sub al, 7
ascii2nibble_next:
	sub al, 30h	
	and al, 15
	ret
endp

getbyte proc
	push cx
	push bx
	mov cl, 4
	call getchar
	call ascii2nibble ; upper nibble of byte in al
	rol al, cl
	mov bl, al
	call getchar
	call ascii2nibble	
	or al, bl
	pop bx
	pop cx
	ret
endp

putbyte proc
	push cx
	push bx
	mov cl, 4
	mov bl, al
	and bl, 15 ; lower nibble in bl
	ror al, cl
	call nibble2ascii
	call putchar
	mov al, bl
	call nibble2ascii
	call putchar
	pop bx
	pop cx
	ret
endp

; arg1: address of array
; arg2: size of array
getarray proc	
	push bp
	mov bp, sp
	push si
	push cx
	mov si, [bp + 4]
	mov cx, [bp + 6]
getarray_next:
	call getbyte
	mov [si], al
	call newline
	inc si
	loop getarray_next
	pop cx
	pop si
	pop bp
	ret
endp

; arg1: address of array
; arg2: size of array
putarray proc	
	push bp
	mov bp, sp
	push si
	push cx
	mov si, [bp + 4]
	mov cx, [bp + 6]
putarray_next:
	mov al, [si]
	call putbyte
	mov al, ' '
	call putchar
	inc si
	loop putarray_next
	call newline
	pop cx
	pop si
	pop bp
	ret
endp


; merges two arrays sorted in ascending order
; arg1 destination
; arg2 array1
; arg3 array2
; arg4 size1 (lower byte is size, higher ignored)
; arg5 size2 ('')
merge proc
	push bp
	mov bp, sp
	push si
	push di
	push dx
	push cx
	push bx
	mov dx, [bp + 12]
	mov cx, [bp + 10] ; count of elements copied from array1 in cl
	mov ch, dl ; '' array2 in ch
	mov di, [bp + 8] ; array2
	mov si, [bp + 6] ; array1
	mov bx, [bp + 4] ; destination
merge_nextcomparison:
	mov al, [si]
	mov ah, [di]
	cmp al, ah
	jc merge_array2_bigger
	mov [bx], ah
	inc di
	inc bx
	dec ch
	jnz merge_nextcomparison
	jmp merge_onefinished
merge_array2_bigger:
	mov [bx], al
	inc si
	inc bx
	dec cl
	jnz merge_nextcomparison
	jmp merge_onefinished
merge_onefinished:
	cmp cl, 0
	jnz merge_array1_notfinished	
	cmp ch, 0
	jz merge_bothfinished
	mov cl, ch
	mov si, di
merge_array1_notfinished:
	mov al, [si]
	mov [bx], al
	inc si
	inc bx
	dec cl
	jnz merge_array1_notfinished
merge_bothfinished:
	pop bx
	pop cx
	pop dx
	pop di
	pop si
	pop bp
	ret
endp

; arg3 size
; arg2: dest
; arg1: src
arraycopy proc
	push bp
	mov bp, sp
	push di
	push si
	push cx
	mov cx, [bp + 8]
	mov di, [bp + 6]
	mov si, [bp + 4]
	cld
arraycopy_nextbyte:
	movsb
	loop arraycopy_nextbyte
	pop cx
	pop si
	pop di
	pop bp
	ret
endp

; arg3 auxillary space having size
; arg2 sizeof array
; arg1 address of array
mergesort proc
	push bp
	mov bp, sp
	push di
	push si
	push dx
	push cx
	push bx
	push ax
	mov dl, 2
	mov di, [bp + 8]
	mov cx, [bp + 6]
	mov si, [bp + 4]
	mov bx, si
	mov ch, 0
	cmp cl, 1
	jz mergesort_sorted
	mov ax, cx
	div dl
	mov ah, 0 ; ax has almost half
	add bx, ax ; bx at si + almost half
	sub cx, ax ; cx has remaining half

	; mergesort lower half of array
	push di
	push ax
	push si
	call mergesort
	pop si
	pop ax
	pop di
	
	; mergesort upper half of array
	push di
	push cx
	push bx
	call mergesort
	pop bx
	pop cx
	pop di

	; merge the two arrays
	push cx
	push ax
	push bx
	push si
	push di
	call merge
	pop di
	pop si
	pop bx
	pop cx
	pop ax

	; copy array from support to original size
	mov cx, [bp + 6]
	mov di, [bp + 8]
	mov si, [bp + 4]
	push cx
	push si
	push di
	call arraycopy
	pop di
	pop si
	pop cx

	; push cx
	; push si
	; call putarray
	; pop si
	; pop cx
	
	jmp mergesort_end
	
mergesort_sorted:
	; mov al, [si]
	; call putbyte
	; call newline
	

mergesort_end:
	; pop all
	pop ax
	pop bx
	pop cx
	pop dx
	pop si
	pop di
	pop bp
	ret
endp
	


main proc
	mov ax, @data
	mov ds, ax
	mov es, ax
	mov si, offset block5
	mov di, offset block6
	mov cx, 100

	push cx
	push si
	call putarray
	pop si
	pop cx

	push di
	push cx
	push si
	call mergesort
	pop si
	pop cx
	pop di

	call newline
	call newline

	push cx
	push si
	call putarray
	pop si
	pop cx
	
	ret
endp
	

.startup
	call main
	mov ax, 4c00h
	int 21h
end
