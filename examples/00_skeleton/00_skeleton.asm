; freemco NES Corelib Example 00: Skeleton Project (NROM)
;==============================================================================;
; The skeleton project targets NROM, as the examples are meant to be small.
; Whether or not that's NROM-128 or NROM-256 is up to the example.
; Other examples may need to use a different mapper.

; This skeleton project makes a few assumptions that you might have to change
; when developing for other mappers.
;==============================================================================;
; iNES header
;.include ""

; defines
.include "nes.inc"			; NES hardware defines

;==============================================================================;
; program code
.org $8000					; starting point for NROM-256
;.org $C000					; starting point for NROM-128

;==============================================================================;
; NMI

NMI:
	; save registers
	pha						; 1) push A
	txa
	pha						; 2) push X
	tya
	pha						; 3) push Y

	; "proper" NMI code belongs here.

NMI_end:
	; restore registers
	pla						; 3) pull Y
	tay
	pla						; 2) pull X
	tax
	pla						; 1) pull A
	rti

;==============================================================================;
; IRQ
; The IRQ is rarely used in simple mapper situations (such as NROM), but IRQs
; can be toggled via the NES's APU. The skeleton example does not use it.

IRQ:
	rti

;==============================================================================;
; Reset
; Handles NES initialization

Reset:
	sei						; disable IRQs
	cld						; clear decimal mode, in case some Famiclone is too smart for its own good
	ldx #$40
	stx APU_FRAMECOUNT		; disable APU frame IRQ
	ldx #$FF
	txs						; set up stack at $01FF
	inx						; (X is now $00)
	stx PPU_CTRL			; disable NMIs
	stx PPU_MASK			; disable rendering
	stx APU_DMC_FREQ		; disable DMC IRQ

	; if you're using a mapper, you should probably initialize it here.

	bit PPU_STATUS

	; wait for 1st vblank
@waitVBL1:
	bit PPU_STATUS
	bpl @waitVBL1

	; clear all RAM (except page $0200, which is used as OAM/Sprite memory)
	txa						; (A is now $00)
@clearRAM:
	sta $000,x
	sta $100,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne @clearRAM

	; clear OAM by hiding all sprites at #$FF
	ldx #0
	lda #$FF
@clearOAM:
	sta OAM_BUF,x
	inx
	inx
	inx
	inx
	bne @clearOAM

	; send sprite data to PPU
	lda #2
	sta OAM_DMA

	; at this point, you can start setting up your program.

	; after setting up your program, wait for the 2nd vblank
@waitVBL2:
	bit $2002
	bpl @waitVBL2

	; perform final commands (setting up PPU)

	; and then run your program's main loop.
MainLoop:
	jmp MainLoop

;==============================================================================;
; Vectors
.org $FFFA
	.dw NMI
	.dw Reset
	.dw IRQ

;==============================================================================;
; CHR-ROM (if needed)
