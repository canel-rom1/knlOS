bits 16
org 0x7c00

	jmp	boot

read_hd:
	push	bp
	mov	bp,sp

	mov	ah, 0x02
	mov	al, 0x01
	mov	dl, 0x00
	mov	ch, 0x00
	mov	dh, 0x00
	mov	cl, 0x01
	mov	bx, 0x7e00

	int	0x13

	mov	sp,bp
	pop	bp
	ret

boot:
	sti

	call	read_hd
	

times 510 - ($-$$) db 0
dw 0xaa55
