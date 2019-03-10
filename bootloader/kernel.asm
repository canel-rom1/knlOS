bits 16
org 0x8000

	jmp	start
	%include "libgraph.asm"

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
