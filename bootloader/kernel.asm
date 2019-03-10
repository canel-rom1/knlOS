bits 16
org 0x8000

	jmp	start

display_enable:
	push	bp
	mov	bp,sp

	mov	ah,0x0
	mov	al,0x7
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

	mov	ah,0x0e
	mov	bx,0
	int	0x10

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

start:
	
	call	display_enable

	push	hello_world
	call	println
	add	sp,2

	push	glmf
	call	println
	add	sp,2

halt:
	jmp	$
	hlt
	ret

hello_world: db 'Hello CANEL',0
glmf: db 'Bienvenu dans le noyau',0

times 510 - ($-$$) db 0
dw 0xaa55