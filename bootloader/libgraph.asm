display_enable:
	push	bp
	mov	bp,sp

	mov	ah,0x0
	mov	al,0x7
	int	0x10

	mov	sp,bp
	pop	bp
	ret

printchar:
	push	bp
	mov	bp, sp

	mov	ah,0x0E
	mov	bx,0
	int	0x10

	mov	sp,bp
	pop	bp
	ret

print:
	push	bp
	mov	bp,sp

	mov	si,[bp+4]

.loop:
	lodsb
	cmp	al,0
	je	.end

	call	printchar

	jmp	.loop

.end:
	mov	sp,bp
	pop	bp
	ret

println:
	push	bp
	mov	bp,sp

	push	word [bp+4]
	call	print
	add	sp,2

	mov	ah,0x03
	int	0x10

	inc	dh
	mov	dl,0
	
	mov	ah,0x2
	int	0x10

	mov	sp,bp
	pop	bp
	ret
