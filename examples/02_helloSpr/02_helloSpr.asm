; freemco NES Corelib Example 02: "Hello World" on the Sprite Layer
;==============================================================================;
; This example demonstrates usage of the Sprite layer. Unlike the first example,
; this one uses the freemco NES Corelib, as well as manual sprite handling.

; Sprite mode used is 8x8, though the sprites being displayed are 8x16.
; It's just simpler this way, compared to 8x16 sprites.
;==============================================================================;
; iNES header (still NROM-128)
.include "NROM-128.asm"

; defines
.include "nes.inc"				; NES hardware defines
.include "ram.inc"				; program RAM defines

;==============================================================================;
; program code
.org $C000					; starting point for NROM-128

; include freemco corelib files here, before any data
	.include "corelib/oam.asm"	; freem Corelib OAM (Sprite) routines [excerpt]

; ["Hello World" sprite tiles]
; top row (manual writes)
spr_yPos_Top1	.db 112		; Y position for top of 8x16 sprite
spr_yPos_Bot1	.db 120		; Y position for bottom of 8x16 sprite

; bottom row (freemlib writes)
spr_yPos_Top2	.db 128		; Y position for top of 8x16 sprite
spr_yPos_Bot2	.db 136		; Y position for bottom of 8x16 sprite

; X positions for sprites
spr_xPos_01		.db 112		; X position for character 1
spr_xPos_02		.db 120		; X position for character 2
spr_xPos_03		.db 128		; X position for character 3
spr_xPos_04		.db 136		; X position for character 4
spr_xPos_05		.db 144		; X position for character 5

; letter tops
spr_topH:		.db $80
spr_topE:		.db $81
spr_topL:		.db $82
spr_topO:		.db $83
spr_topW:		.db $84
spr_topR:		.db $85
spr_topD:		.db $86

; letter bottoms
spr_botH:		.db $90
spr_botE:		.db $91
spr_botL:		.db $92
spr_botO:		.db $93
spr_botW:		.db $94
spr_botR:		.db $95
spr_botD:		.db $96

; "WORLD" bottoms for oam_setEntryData
sprDataBot_W:	.db 136,$94,0,112
sprDataBot_O:	.db 136,$93,0,120
sprDataBot_R:	.db 136,$95,0,128
sprDataBot_L:	.db 136,$92,0,136
sprDataBot_D:	.db 136,$96,0,144

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
	; update the sprites
	lda #0
	sta OAM_ADDR
	lda #>OAM_BUF
	sta OAM_DMA

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
; Handles NES initialization

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

	; in our case, we're going to set up a simple palette...
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
	lda #$00					; Color $00 is a dark gray.
	sta PPU_DATA				; write white palette value to PPU data

	ldy #$10					; $3F10 is the beginning of the sprite palettes.
	stx PPU_ADDR				; X is still #$3F.
	sty PPU_ADDR

	lda #$0F					; Color $0F is a safe black.
	sta PPU_DATA				; write black palette value to PPU data
	lda #$30					; Color $30 is white.
	sta PPU_DATA				; write white palette value to PPU data
	lda #$10					; Color $10 is a light gray.
	sta PPU_DATA				; write white palette value to PPU data
	lda #$00					; Color $00 is a dark gray.
	sta PPU_DATA				; write white palette value to PPU data

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

	; send all hidden sprites to PPU
	lda #2
	sta OAM_DMA

	; now to set up the sprites.
	; "Hello" will be displayed via manual writes to the OAM_BUF area.

	; Sprite 1 ($0204, OAM_BUF+4): "H" top
	lda spr_yPos_Top1
	sta OAM_BUF+4				; y position
	lda spr_topH
	sta OAM_BUF+5				; tile number
	lda #0
	sta OAM_BUF+6				; attributes
	lda spr_xPos_01
	sta OAM_BUF+7				; x position

	; Sprite 2 ($0208, OAM_BUF+8): "E" top
	lda spr_yPos_Top1
	sta OAM_BUF+8				; y position
	lda spr_topE
	sta OAM_BUF+9				; tile number
	lda #0
	sta OAM_BUF+10				; attributes
	lda spr_xPos_02
	sta OAM_BUF+11				; x position

	; Sprite 3 ($020C): "L" top
	lda spr_yPos_Top1
	sta OAM_BUF+12				; y position
	lda spr_topL
	sta OAM_BUF+13				; tile number
	lda #0
	sta OAM_BUF+14				; attributes
	lda spr_xPos_03
	sta OAM_BUF+15				; x position

	; Sprite 4 ($0210): "L" top
	lda spr_yPos_Top1
	sta OAM_BUF+16				; y position
	lda spr_topL
	sta OAM_BUF+17				; tile number
	lda #0
	sta OAM_BUF+18				; attributes
	lda spr_xPos_04
	sta OAM_BUF+19				; x position

	; Sprite 5 ($0214): "O" top
	lda spr_yPos_Top1
	sta OAM_BUF+20				; y position
	lda spr_topO
	sta OAM_BUF+21				; tile number
	lda #0
	sta OAM_BUF+22				; attributes
	lda spr_xPos_05
	sta OAM_BUF+23				; x position

	; Sprite 6 ($0218): "H" bottom
	lda spr_yPos_Bot1
	sta OAM_BUF+24				; y position
	lda spr_botH
	sta OAM_BUF+25				; tile number
	lda #0
	sta OAM_BUF+26				; attributes
	lda spr_xPos_01
	sta OAM_BUF+27				; x position

	; Sprite 7 ($021C): "E" bottom
	lda spr_yPos_Bot1
	sta OAM_BUF+28				; y position
	lda spr_botE
	sta OAM_BUF+29				; tile number
	lda #0
	sta OAM_BUF+30				; attributes
	lda spr_xPos_02
	sta OAM_BUF+31				; x position

	; Sprite 8 ($0220): "L" bottom
	lda spr_yPos_Bot1
	sta OAM_BUF+32				; y position
	lda spr_botL
	sta OAM_BUF+33				; tile number
	lda #0
	sta OAM_BUF+34				; attributes
	lda spr_xPos_03
	sta OAM_BUF+35				; x position

	; Sprite 9 ($0224): "L" bottom
	lda spr_yPos_Bot1
	sta OAM_BUF+36				; y position
	lda spr_botL
	sta OAM_BUF+37				; tile number
	lda #0
	sta OAM_BUF+38				; attributes
	lda spr_xPos_04
	sta OAM_BUF+39				; x position

	; Sprite 10 ($0228): "O" bottom
	lda spr_yPos_Bot1
	sta OAM_BUF+40				; y position
	lda spr_botO
	sta OAM_BUF+41				; tile number
	lda #0
	sta OAM_BUF+42				; attributes
	lda spr_xPos_05
	sta OAM_BUF+43				; x position

	; "World" will be displayed via freemco Corelib OAM functionality.

	; first, via manual writes:
	lda #11
	ldx spr_yPos_Top2
	jsr oam_setEntryY
	ldx spr_topW
	jsr oam_setEntryTile
	ldx #0
	jsr oam_setEntryAttr
	ldx spr_xPos_01
	jsr oam_setEntryX

	lda #12
	ldx spr_yPos_Top2
	jsr oam_setEntryY
	ldx spr_topO
	jsr oam_setEntryTile
	ldx #0
	jsr oam_setEntryAttr
	ldx spr_xPos_02
	jsr oam_setEntryX

	lda #13
	ldx spr_yPos_Top2
	jsr oam_setEntryY
	ldx spr_topR
	jsr oam_setEntryTile
	ldx #0
	jsr oam_setEntryAttr
	ldx spr_xPos_03
	jsr oam_setEntryX

	lda #14
	ldx spr_yPos_Top2
	jsr oam_setEntryY
	ldx spr_topL
	jsr oam_setEntryTile
	ldx #0
	jsr oam_setEntryAttr
	ldx spr_xPos_04
	jsr oam_setEntryX

	lda #15
	ldx spr_yPos_Top2
	jsr oam_setEntryY
	ldx spr_topD
	jsr oam_setEntryTile
	ldx #0
	jsr oam_setEntryAttr
	ldx spr_xPos_05
	jsr oam_setEntryX

	; then, via oam_setEntryData:
	lda #<sprDataBot_W
	sta tmp00
	lda #>sprDataBot_W
	sta tmp01
	lda #16
	jsr oam_setEntryData

	lda #<sprDataBot_O
	sta tmp00
	lda #>sprDataBot_O
	sta tmp01
	lda #17
	jsr oam_setEntryData

	lda #<sprDataBot_R
	sta tmp00
	lda #>sprDataBot_R
	sta tmp01
	lda #18
	jsr oam_setEntryData

	lda #<sprDataBot_L
	sta tmp00
	lda #>sprDataBot_L
	sta tmp01
	lda #19
	jsr oam_setEntryData

	lda #<sprDataBot_D
	sta tmp00
	lda #>sprDataBot_D
	sta tmp01
	lda #20
	jsr oam_setEntryData

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
