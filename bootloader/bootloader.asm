bits 16
org 0x7c00


	mov	ah, 0
	int	0x13

	mov bx, 0x8000     ; bx = address to write the kernel to
	mov al, 1 		   ; al = amount of sectors to read
	mov ch, 0          ; cylinder/track = 0
	mov dh, 0          ; head           = 0
	mov cl, 1          ; sector         = 2
	mov ah, 2          ; ah = 2: read from drive
	int 0x13

	jmp 0x8000

times 510 - ($-$$) db 0
dw 0xaa55
