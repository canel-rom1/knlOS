bits 16
org 0x0

	jmp	start
	%include "libgraph.asm"

start:
	mov	ax, 0x100
	mov	ds, ax
	mov	es, ax
	mov	ax, 0x8000
	mov	ss, ax
	mov	sp, 0xf000

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
