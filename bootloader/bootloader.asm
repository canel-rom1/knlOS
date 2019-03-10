bits 16
org 0x0

; Initialiser les segments
	mov	ax, 0x07C0 ; Adresse de départ
	mov	ds, ax ; Data segment
	mov	es, ax ; Extra segment
	;Pile
	mov	ax, 0x9000
	mov	ss, ax
	mov	sp, 0xf000

; Initialiser le disque
	mov ah, 0
	int 0x13

; Charger le noyau
start:
	mov bx, 0x8000
	mov al, 0x01
	mov ch, 0x0
	mov dh, 0x0
	mov cl, 0x02
	mov ah, 0x02
	int 0x13

; Démarre le noyau
	jmp 0x8000

	times 510 - ($-$$) db 0
	dw 0xaa55
