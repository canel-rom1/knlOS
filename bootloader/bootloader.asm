bits 16
org 0x0

%define BASE  0x100
%define KSIZE 1

	jmp	start
	%include "libgraph.asm"
start:
; Initialiser les segments
	mov	ax, 0x07C0 ; Adresse de départ
	mov	ds, ax ; Data segment
	mov	es, ax ; Extra segment
	;Pile
	mov	ax, 0x8000
	mov	ss, ax
	mov	sp, 0xf000
	jmp	.bla

	call display_enable

.clean:
	call	cleanscreen
.bla:
	push	accueil
	call	println
	push	sel1
	call	println
	push	sel2
	call	println
	push	sel3
	call	println
.loop
	call readchar
	jz .loop

	cmp	al,'1'
	je	.sel1
	cmp	al,'2'
	je	.sel2
	cmp	al,'3'
	je	.sel3
	jmp	.clean

.sel1:
	push	sel1
	call	println
	jmp	end
.sel2:
	push	sel2
	call	println
	jmp	end
.sel3:
	push	sel3
	call	println

end:
	jmp $
	hlt
	ret


; Lire un carcatère
readchar:
	mov	ah, 1
	int	0x16
	jz	.end
	mov	ah, 0
	int	0x16
	ret
.end:
	mov	ax, 0
	ret

; Lire une chaîne
%define BUFSIZE 8
read:
	mov	di,.buffer
.loop:
	call	readchar
	jz	.loop
	cmp	ah,0x1C
	je	.end
	cmp	ah,0x0E
	je	.remove
	stosb
	cmp	di,(.buffer+BUFSIZE)
.remove:
	cmp	di,.buffer
	jle	.loop
	dec	di
	jmp	.loop
.end:
	xor	al,al
	stosb
	mov	di,.buffer
	ret

.buffer	resb (BUFSIZE+1)

; Initialiser le disque
	mov 	ah, 0
	int 	0x13

; Charger le noyau
	push	es
	mov	ax, BASE
	mov	es, ax
	mov	bx, 0x0

	mov 	al, KSIZE
	mov 	ch, 0x0
	mov 	dh, 0x0
	mov 	cl, 0x02
	mov 	ah, 0x02
	int 	0x13
	pop	es

; Démarre le noyau
	jmp 	BASE:0

accueil: db "Bienvenu dans le bootloader de knlOS",0
sel1:    db "1) Programme Hello CANEL",0
sel2:    db "2) knlKernel",0
sel3:    db "3) Linux + Busybox",0

; Remplissage jusqu'à la signature du MBR
times 510 - ($-$$) db 0
dw 0xaa55
