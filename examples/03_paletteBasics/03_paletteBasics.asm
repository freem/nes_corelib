; freemco NES Corelib Example 03: Palette Basics
;==============================================================================;
; This example shows how to set the entire palette, and displays both the
; active background and sprite colors.
;==============================================================================;
; iNES header (still NROM-128)
.include "NROM-128.asm"

; defines
.include "nes.inc"				; NES hardware defines
.include "ram.inc"				; program RAM defines

;==============================================================================;
; Macros
; Let's talk about code duplication, and how to get rid of some of it.
;------------------------------------------------------------------------------;
; drawBgPalBox
; Draws a background palette box.

; Params:
; tile			tile index to use ($01,$02,$03)
; addr1			top byte of PPU address (both writes)
; addr2			bottom byte of PPU address (first write)
; addr3			bottom byte of PPU address (second write)

.macro drawBgPalBox tile,addr1,addr2,addr3
	; line 1
	ldx #addr1
	ldy #addr2
	stx PPU_ADDR
	sty PPU_ADDR
	lda #tile
	sta PPU_DATA
	sta PPU_DATA
	; line 2
	ldy #addr3
	stx PPU_ADDR
	sty PPU_ADDR
	sta PPU_DATA
	sta PPU_DATA
.endm

;------------------------------------------------------------------------------;
; drawSprPalBox

; Params:
; index			starting sprite index
; tile			tile index to use ($01,$02,$03)
; pal			palette to use
; x				x position of top left sprite
; y				y position of top left sprite

.macro drawSprPalBox index,tile,pal,x,y
	; (sprite 1/4)
	; y position
	lda #y
	sta OAM_BUF+(index*4)
	; tile index
	lda #tile
	sta OAM_BUF+(index*4)+1
	; attributes
	lda #pal
	sta OAM_BUF+(index*4)+2
	; x position
	lda #x
	sta OAM_BUF+(index*4)+3

	; (sprite 2/4)
	; y position
	lda #y
	sta OAM_BUF+(index*4)+4
	; tile index
	lda #tile
	sta OAM_BUF+(index*4)+5
	; attributes
	lda #pal
	sta OAM_BUF+(index*4)+6
	; x position
	lda #x+8
	sta OAM_BUF+(index*4)+7

	; (sprite 3/4)
	; y position
	lda #y+8
	sta OAM_BUF+(index*4)+8
	; tile index
	lda #tile
	sta OAM_BUF+(index*4)+9
	; attributes
	lda #pal
	sta OAM_BUF+(index*4)+10
	; x position
	lda #x
	sta OAM_BUF+(index*4)+11

	; (sprite 4/4)
	; y position
	lda #y+8
	sta OAM_BUF+(index*4)+12
	; tile index
	lda #tile
	sta OAM_BUF+(index*4)+13
	; attributes
	lda #pal
	sta OAM_BUF+(index*4)+14
	; x position
	lda #x+8
	sta OAM_BUF+(index*4)+15
.endm

;==============================================================================;
; program code
.org $C000					; starting point for NROM-128

; include freemco corelib files here, before any data
	.include "corelib/palette.asm"	; freem Corelib Palette routines [excerpt]

; [Palette Data]
; We were manually writing the palette data to the PPU in the previous two
; examples. This time, we're going to use the freemco NES Corelib to write
; the background and sprite palettes in one shot.
palData:
	.db $0F,$30,$10,$00			; [BG1] black, dark gray, light gray, white
	.db $0F,$31,$21,$11			; [BG2] black, lightest blue, lighter blue, blue
	.db $0F,$33,$23,$13			; [BG3] black, lightest purple, lighter purple, purple
	.db $0F,$35,$25,$15			; [BG4] black, lightest pink, lighter pink, pink
	;---------------------------;
	.db $0F,$37,$27,$17			; [Spr1] black, tan, lighter orange, orange
	.db $0F,$39,$29,$19			; [Spr2] black, lightest green/yellow, lighter green/yellow, green/yellow
	.db $0F,$3A,$2A,$1A			; [Spr3] black, lightest green/blue, lighter green/blue, green/blue
	.db $0F,$3C,$2C,$1C			; [Spr4] black, lightest cyan, lighter cyan, cyan

; [String data]
strPalettes:		.db "Palettes"
strBackground:		.db "Background"
strSprites:			.db "Sprites"

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

	; set up the base palette using ppu_XferFullPalToPPU
	lda #<palData
	sta tmp00
	lda #>palData
	sta tmp01
	jsr ppu_XferFullPalToPPU

	; reset ppu addresses
	ldx #$3F
	ldy #$00
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

	; set up the nametable data
	; 0) labels and crap
	; "Palettes" at $204C
	ldx #$20
	ldy #$4C
	stx PPU_ADDR
	sty PPU_ADDR

	ldy #0
@loopPalText:
	lda strPalettes,y
	sta PPU_DATA
	iny
	cpy #8
	bne @loopPalText

	; 0x0A,0x0A,0x0A,0x0F at $2080
	ldy #$80
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$0A
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	lda #$0F
	sta PPU_DATA

	; "Background" at $2084
	ldy #0
@loopBGText:
	lda strBackground,y
	sta PPU_DATA
	iny
	cpy #10
	bne @loopBGText

	; 0x10,0x0A... at $208E
	lda #$10
	sta PPU_DATA
	lda #$0A

	ldy #0
@loopTopLineRight:
	sta PPU_DATA
	iny
	cpy #17
	bne @loopTopLineRight

	; 1 ($20E8), 2 ($20F2), 3 ($21A8), 4 ($21B2)
	ldx #$20
	ldy #$E8
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"1"
	sta PPU_DATA

	ldy #$F2
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"2"
	sta PPU_DATA

	ldx #$21
	ldy #$A8
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"3"
	sta PPU_DATA

	ldy #$B2
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"4"
	sta PPU_DATA

	; 0x0A,0x0A,0x0A,0x0F at $2220
	ldx #$22
	ldy #$20
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$0A
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	lda #$0F
	sta PPU_DATA

	; "Sprites" at $2224
	ldy #0
@loopSprText:
	lda strSprites,y
	sta PPU_DATA
	iny
	cpy #7
	bne @loopSprText

	; 0x10,0x0A... at $222B
	lda #$10
	sta PPU_DATA
	lda #$0A

	ldy #0
@loopBotLineRight:
	sta PPU_DATA
	iny
	cpy #20
	bne @loopBotLineRight

	; 1 ($2288), 2 ($2292), 3 ($2328), 4 ($2332)
	ldx #$22
	ldy #$88
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"1"
	sta PPU_DATA

	ldy #$92
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"2"
	sta PPU_DATA

	ldx #$23
	ldy #$28
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"3"
	sta PPU_DATA

	ldy #$32
	stx PPU_ADDR
	sty PPU_ADDR
	lda #"4"
	sta PPU_DATA

	; 1) BG tiles ($01, $02, $03)
	; 1/$01 ($20CC, $20EC)
	drawBgPalBox $01,$20,$CC,$EC
	; 1/$02 ($210A, $212A)
	drawBgPalBox $02,$21,$0A,$2A
	; 1/$03 ($210C, $212C)
	drawBgPalBox $03,$21,$0C,$2C

	; 2/$01 ($20D6, $20F6)
	drawBgPalBox $01,$20,$D6,$F6
	; 2/$02 ($2114, $2134)
	drawBgPalBox $02,$21,$14,$34
	; 2/$03 ($2116, $2136)
	drawBgPalBox $03,$21,$16,$36

	; 3/$01 ($218C)
	drawBgPalBox $01,$21,$8C,$AC
	; 3/$02 ($21CA)
	drawBgPalBox $02,$21,$CA,$EA
	; 3/$03 ($21CC)
	drawBgPalBox $03,$21,$CC,$EC

	; 4/$01 ($2196)
	drawBgPalBox $01,$21,$96,$B6
	; 4/$02 ($21D4)
	drawBgPalBox $02,$21,$D4,$F4
	; 4/$03 ($21D6)
	drawBgPalBox $03,$21,$D6,$F6

	; 2) attribute data
	; this stuff is a nightmare to calculate by hand, btw.
	; I didn't, but you might have to.

	; $23CD: $50
	ldx #$23
	ldy #$CD
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$50
	sta PPU_DATA

	; $23D5: $05
	ldy #$D5
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$05
	sta PPU_DATA

	; $23DA: $88
	ldy #$DA
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$88
	sta PPU_DATA

	; $23DB: $22
	ldy #$DB
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$22
	sta PPU_DATA

	; $23DD: $FF
	ldy #$DD
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$FF
	sta PPU_DATA

	; set up the sprites

	; 1/1 (Sprites 01-04)
	drawSprPalBox 1,1,0,96,151
	; 1/2 (Sprites 05-08)
	drawSprPalBox 5,2,0,80,167
	; 1/3 (Sprites 09-12)
	drawSprPalBox 9,3,0,96,167

	; 2/1 (Sprites 13-16)
	drawSprPalBox 13,1,1,176,151
	; 2/2 (Sprites 17-20)
	drawSprPalBox 17,2,1,160,167
	; 2/3 (Sprites 21-24)
	drawSprPalBox 21,3,1,176,167

	; 3/1 (Sprites 25-28)
	drawSprPalBox 25,1,2,96,191
	; 3/2 (Sprites 29-32)
	drawSprPalBox 29,2,2,80,207
	; 3/3 (Sprites 33-36)
	drawSprPalBox 33,3,2,96,207

	; 4/1 (Sprites 37-40)
	drawSprPalBox 37,1,3,176,191
	; 4/2 (Sprites 41-44)
	drawSprPalBox 41,2,3,160,207
	; 4/3 (Sprites 45-48)
	drawSprPalBox 45,3,3,176,207

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
