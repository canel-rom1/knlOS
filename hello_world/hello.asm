section .text
global	_start

_start:
	mov	eax, message
	mov	ebx, length
	call	print_str

	mov	ebx, 0
	mov	eax, 1
	int	0x80

print_str:
	pusha
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,4
	mov	ebx,1
	int	0x80
	popa
	ret

section	.data
	message db 'Hello CANEL',10
	length	equ $-message
