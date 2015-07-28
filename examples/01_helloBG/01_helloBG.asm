; freemco NES Corelib Example 01: "Hello World" on the Background Layer
;==============================================================================;
; This example doesn't actually use the freemco NES Corelib, since initial
; background drawing (e.g. when rendering is off) is pretty simple.
;==============================================================================;
; iNES header (NROM-128)
.include "NROM-128.asm"

; defines
.include "nes.inc"				; NES hardware defines
.include "ram.inc"				; program RAM defines

;==============================================================================;
; program code
.org $C000					; starting point for NROM-128

; "Hello World!" string
str_HelloWorld:		.db "Hello World!"

;==============================================================================;
; NMI

NMI:
	; save registers
	pha						; 1) push A
	txa
	pha						; 2) push X
	tya
	pha						; 3) push Y

	; increment framecount
	inc <frameCount
	bne @afterFrameCount
	inc <frameCount+1
@afterFrameCount:

	; "proper" NMI code belongs here.

NMI_end:
	lda #0
	sta vblanked			; clear vblanked flag

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
; Handles NES initialization.

Reset:
	sei						; disable IRQs
	cld						; clear decimal mode, in case some Famiclone is too smart for its own good
	ldx #$40
	stx APU_FRAMECOUNT		; disable APU frame IRQ
	ldx #$FF
	txs						; set up stack
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
	sta $200,x
	inx
	inx
	inx
	inx
	bne @clearOAM

	; wait for the 2nd vblank
@waitVBL2:
	bit PPU_STATUS
	bpl @waitVBL2

	; at this point, you can start setting up your program.

	; make sure the PPU is on +1 increments
	lda int_ppuCtrl
	and #%11111011
	sta int_ppuCtrl
	sta PPU_CTRL

	; set up a simple palette
	ldx #$3F					; the Palette begins at PPU address $3F00.
	ldy #$00
	stx PPU_ADDR				; write new PPU address 1/2
	sty PPU_ADDR				; write new PPU address 2/2

	lda #$0F					; Color $0F is a safe black.
	sta PPU_DATA				; write black palette value to PPU data
	lda #$30					; Color $30 is white.
	sta PPU_DATA				; write white palette value to PPU data
	lda #$10					; Color $10 is a light gray.
	sta PPU_DATA				; write white palette value to PPU data
	; write to the PPU using the value in Y; Color $00 is a dark gray.
	sty PPU_DATA				; write white palette value to PPU data

	stx PPU_ADDR				; Reset palette PPU address 1/2
	sty PPU_ADDR				; Reset palette PPU address 2/2
	sty PPU_ADDR				; Reset overall PPU address 1/2
	sty PPU_ADDR				; Reset overall PPU address 2/2

	; clear first nametable's data
	ldx #$20
	ldy #$00
	stx PPU_ADDR
	sty PPU_ADDR
.rept (32*30)+64
	sty PPU_DATA
.endr

	; send sprite data to PPU
	lda #2
	sta OAM_DMA

	; and then write the "Hello World!" string to the screen.

	; first, set the PPU address to the desired location.
	; In our case, we want to center the text (x=10, y=15) on the screen.
	; The PPU addresses start at $2000 (for the first nametable, anyways).
	ldx #$21
	ldy #$EA
	stx PPU_ADDR
	sty PPU_ADDR

	; the data for the string is in the str_HelloWorld variable.
	ldy #0
@writeString:
	lda str_HelloWorld,y
	sta PPU_DATA
	iny
	cpy #12						; the string is 12 characters long.
	bne @writeString			; loop if not finished

	; perform final commands (setting up PPU)
	; reset PPU and scroll
	ldx #$20					; first nametable lives at PPU address $2000
	ldy #$00
	stx PPU_ADDR				; write new PPU address 1/2
	sty PPU_ADDR				; write new PPU address 2/2
	sty PPU_SCROLL				; Reset X scroll to 0
	sty PPU_SCROLL				; Reset Y scroll to 0

	; enable NMIs, put sprites on PPU $1000
	lda int_ppuCtrl
	ora #%10001000
	sta int_ppuCtrl
	sta PPU_CTRL

	; turn ppu on
	lda int_ppuMask
	ora #%00011110
	sta int_ppuMask
	sta PPU_MASK

	; and then run your program's main loop.
MainLoop:
	; things before vblank

	jsr waitVBlank				; wait for vblank

	; things after vblank

	jmp MainLoop

;==============================================================================;
; waitVBlank: waits for VBlank

waitVBlank:
	inc vblanked
@waitLoop:
	lda vblanked
	bne @waitLoop
	rts

;==============================================================================;
; Vectors
.org $FFFA
	.dw NMI
	.dw Reset
	.dw IRQ

;==============================================================================;
; CHR-ROM (if needed)
.incbin "test.chr"
