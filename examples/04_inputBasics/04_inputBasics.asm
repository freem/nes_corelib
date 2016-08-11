; freemco NES Corelib Example 04: Input Basics
;==============================================================================;
; description
;==============================================================================;
; iNES header (still NROM-128)
.include "NROM-128.asm"

; defines
.include "nes.inc"				; NES hardware defines
.include "ram.inc"				; program RAM defines

;==============================================================================;
; Macros
;------------------------------------------------------------------------------;
; drawController
; Draws the initial controller onto the screen at the specified location.

; Params:
; addr1			Top half of starting PPU nametable address
; addr2			Bottom half of starting PPU nametable address
; famicomP2		if nonzero, will draw an original Famicom P2 controller.

; Normal Controller
;   ^
; <- ->  Sel Sta   B  A
;   v    --- ---  ( )( )

; Famicom P2 Controller
;   ^
; <- ->    Mic     B  A
;   v      ---    ( )( )

; 13x6 layout
; $09,$0A (11x),$0B
; $0C,$00 (11x),$0C
; $0C,$00,$F0,$00,$00,{variable, see below},$00,$42,$00,$41,$0C
; $0C,$F2,$00,$F3,$00,{variable, see below},$00,$17,$00,$17,$0C
; $0C,$00,$F1,$00,$00,{variable, see below},$00 (4x),$0C
; $0D,$0A (11x),$0E

; Variable lines:
; 1) Regular	$00 (3x)
; 1) Famicom	$4D,$69,$63

; 2) Regular	$73,$00,$53
; 2) Famicom	$00,$14,$00

; 3) Regular	$14,$00,$14
; 3) Famicom	$00 (3x)

.macro drawController addr1 addr2 famicomP2
	ldx #addr1
	ldy #addr2
	stx PPU_ADDR
	sty PPU_ADDR
	stx tmp00
	sty tmp01

	; first line
	ldx #$0D
	ldy #0
@line1:
	lda str_ControllerLine1,y
	sta PPU_DATA
	iny
	dex
	bne @line1

	;--------------------------------------------------------------------------;
	; second line
	lda tmp01
	clc
	adc #32					; 32 8x8 blocks horizontally = 1 line
	sta tmp01
	tay
	lda tmp00
	adc #0
	sta tmp00
	tax
	stx PPU_ADDR
	sty PPU_ADDR

	ldx #$0D
	ldy #0
@line2:
	lda str_ControllerLine2,y
	sta PPU_DATA
	iny
	dex
	bne @line2

	;--------------------------------------------------------------------------;
	; third line
	lda tmp01
	clc
	adc #32					; 32 8x8 blocks horizontally = 1 line
	sta tmp01
	tay
	lda tmp00
	adc #0
	sta tmp00
	tax
	stx PPU_ADDR
	sty PPU_ADDR

	ldx #5
	ldy #0
@line3a:
	lda str_ControllerLine3shr1,y
	sta PPU_DATA
	iny
	dex
	bne @line3a

	lda #famicomP2
	bne @line3Fami

	stx PPU_DATA
	stx PPU_DATA
	stx PPU_DATA
	jmp @branch3

@line3Fami:
	lda #'M'
	ldx #'i'
	ldy #'c'
	sta PPU_DATA
	stx PPU_DATA
	sty PPU_DATA

@branch3:
	ldx #5
	ldy #0
@line3b:
	lda str_ControllerLine3shr2,y
	sta PPU_DATA
	iny
	dex
	bne @line3b

	;--------------------------------------------------------------------------;
@fourth:
	; fourth line
	lda tmp01
	clc
	adc #32					; 32 8x8 blocks horizontally = 1 line
	sta tmp01
	tay
	lda tmp00
	adc #0
	sta tmp00
	tax
	stx PPU_ADDR
	sty PPU_ADDR

	ldx #5
	ldy #0
@line4a:
	lda str_ControllerLine4shr1,y
	sta PPU_DATA
	iny
	dex
	bne @line4a

	lda #famicomP2
	bne @line4Fami

	lda #'s'
	sta PPU_DATA
	lda #'S'
	stx PPU_DATA
	sta PPU_DATA
	jmp @branch4

@line4Fami:
	lda #$14
	stx PPU_DATA
	sta PPU_DATA
	stx PPU_DATA

@branch4:
	ldx #5
	ldy #0
@line4b:
	lda str_ControllerLine4shr2,y
	sta PPU_DATA
	iny
	dex
	bne @line4b

	;--------------------------------------------------------------------------;
	; fifth line
	lda tmp01
	clc
	adc #32					; 32 8x8 blocks horizontally = 1 line
	sta tmp01
	tay
	lda tmp00
	adc #0
	sta tmp00
	tax
	stx PPU_ADDR
	sty PPU_ADDR

	ldx #5
	ldy #0
@line5a:
	lda str_ControllerLine5shr1,y
	sta PPU_DATA
	iny
	dex
	bne @line5a

	lda #famicomP2
	bne @line5Fami

	lda #$14
	sta PPU_DATA
	stx PPU_DATA
	sta PPU_DATA
	jmp @branch5

@line5Fami:
	stx PPU_DATA
	stx PPU_DATA
	stx PPU_DATA

@branch5:
	ldx #5
	ldy #0
@line5b:
	lda str_ControllerLine5shr2,y
	sta PPU_DATA
	iny
	dex
	bne @line5b

	;--------------------------------------------------------------------------;
	; sixth line
	lda tmp01
	clc
	adc #32					; 32 8x8 blocks horizontally = 1 line
	sta tmp01
	tay
	lda tmp00
	adc #0
	sta tmp00
	tax
	stx PPU_ADDR
	sty PPU_ADDR

	ldx #$0D
	ldy #0
@line6:
	lda str_ControllerLine6,y
	sta PPU_DATA
	iny
	dex
	bne @line6

.endm

;==============================================================================;
; program code
.org $C000					; starting point for NROM-128

; include freemco corelib files here, before any data
	.include "corelib/io.asm"	; freem Corelib I/O routines

; [Strings]

; (Controller)
str_Player:				.db "Player "

; static controller lines
str_ControllerLine1:		.db $09,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0B
str_ControllerLine2:		.db $0C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C
str_ControllerLine6:		.db $0D,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0E
str_ControllerLine3shr1:	.db $0C,$00,$F0,$00,$00
str_ControllerLine3shr2:	.db $00,$42,$00,$41,$0C
str_ControllerLine4shr1:	.db $0C,$F2,$00,$F3,$00
str_ControllerLine4shr2:	.db $00,$17,$00,$17,$0C
str_ControllerLine5shr1:	.db $0C,$00,$F1,$00,$00
str_ControllerLine5shr2:	.db $00,$00,$00,$00,$0C

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

	; set up a quick base palette
	ldx #$3F
	ldy #$00
	stx PPU_ADDR
	sty PPU_ADDR
	lda #$0F
	sta PPU_DATA
	lda #$30
	sta PPU_DATA
	lda #$10
	sta PPU_DATA
	lda #$15
	sta PPU_DATA

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

	; draw controllers

	; "Player 1" text
	lda #0
	ldx #$20
	ldy #$AA
	jsr sub_writePlayerLabel

	drawController $20,$C9,$00	; player 1

	; "Player 2" text
	lda #1
	ldx #$21
	ldy #$AA
	jsr sub_writePlayerLabel

.ifdef FAMICOM
	drawController $21,$C9,$01	; player 2 (Famicom w/ Microphone)
.else
	drawController $21,$C9,$00	; player 2 (normal)
.endif

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
;------------------------------------------------------------------------------;
MainLoop:
	; things before vblank
	jsr io_readJoy

	jsr waitVBlank				; wait for vblank

	; things after vblank
	; * handle inputs and write to vramBufData

	jmp MainLoop

;==============================================================================;
; sub_writePlayerLabel
; Writes out a "Player 1" or "Player 2" text at the specified location.

; Params
; A				Player number (0=p1/1=p2)
; X				nt addr top
; Y				nt addr bottom

sub_writePlayerLabel:
	pha						; save player number
	; set ppu address
	stx PPU_ADDR
	sty PPU_ADDR

	ldy #0
@static:
	lda str_Player,y
	sta PPU_DATA
	iny
	cpy #7
	bne @static

	lda #"1"
	sta tmp00
	clc
	pla						; recover player number
	adc tmp00
	sta PPU_DATA

	rts

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
