[BITS 16]
org	0x7C00

mov	ax, 0x1000
mov	es, ax

; Charger le premier secteur du noyau
mov	[dap.count], byte 1 ; Nombre de secteur à lire
mov 	[dap.offset], byte 0 ; 
mov	[dap.segment], word es
mov	[dap.lba_l], dword 0x01

mov	ah, 0x42
mov	si, dap
mov	dl, 0x80
int	0x13

add	[hdd_pointer], byte 1

; Lire la taille de l'entête
mov	al, [es:0x1F1]

; Lire l'entête
mov	[dap.count], al
mov 	[dap.offset], word 512
mov	[dap.segment], word es
mov	[dap.lba_l], dword 0x02

mov	ah, 0x42
mov	si, dap
mov	dl, 0x80
int	0x13

add	[hdd_pointer], eax

mov	byte  [es:0x1FA], 0xFFFF
mov	byte  [es:0x210], 0xE1
mov	byte  [es:0x211], 0x81
mov	word  [es:0x224], 0xDE00
mov	byte  [es:0x227], 0x01
mov	dword [es:0x228], 0x1E000

; Charger le noyau
mov	edx, [es:0x1F4]
shl	edx, 4
call	loader

; Charger l'initrd
mov	eax, [highmov_addr]
mov	[es:0x218], eax
mov	edx, [initRdSize]
mov	[es:0x21C], edx
call	loader

; Démarrer le noyau
	cli

	mov	ax, 0x1000
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax
	mov	sp, 0xE000 ; Haut du tas
	jmp	0x1020:0

	jmp	$

; Chargement du noyau
loader:
.loop:
	cmp	edx, 127*512
	jl	loader.part_2
	jz	loader.finish

	mov	ax, 0x7F ; Certain BIOS ne peuvent que lire 127 secteurs à la fois
	xor	bx, bx
	mov	cx, 0x2000 ; Adresse du segment temporaire
	push	edx
	call	hddread
	call	highmove
	pop	edx
	sub	edx, 127*512

	jmp	loader.loop
.part_2:
	shr	edx, 9
	inc	edx
	mov	ax, dx
	xor	bx, bx
	mov	cx, 0x2000
	call	hddread
	call	highmove
.finish:
	ret

; Déplacement du noyau  vers 0x100000
highmov_addr dd 0x100000
highmove:
	mov	esi,0x20000
	mov	edi,[highmov_addr]
	mov	edx, 512*127
	mov	ecx, 0
.loop:
	mov	eax, [esi]
	mov	[edi], eax
	add	esi, 4
	add	edi, 4
	sub	edx, 4
	jnz	highmove.loop
	mov	[highmov_addr], edi
	ret

hddread:
	push	eax
	mov	[dap.count], ax
	mov	[dap.offset], bx
	mov	[dap.segment], cx
	mov	edx, dword [hdd_pointer]
	mov	dword [dap.lba_l], edx
	add	[hdd_pointer], ax
	mov	ah, 0x42
	mov	si, dap
	mov	dl, 0x80
	int	0x13
	pop	eax
	ret

dap:
	db 0x10
	db 0
.count:
	dw 0
.offset:
	dw 0
.segment:
	dw 0
.lba_l:
	dd 0
.lba_h:
	dd 0

cmdLine db "auto", 0
cmdLineLen equ $-cmdLine
initRdSize dd initRdSizeDef
hdd_pointer dd 1

times 510-($-$$) db 0
dw 0xAA55
