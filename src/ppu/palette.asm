; File: ppu/palette.asm
; PPU functionality, focusing specifically on Palettes.

;==============================================================================;
; [Quick Overview]

; > Palette Register Routines
;  (uses $3F00 writes; rendering should|must be off)
;  - ppu_clearPal			Resets entire palette to black ($0f).
;  - ppu_XferFullPalToPPU	Transfers 32 bytes into PPU palette.

; > Palette Buffer Routines
;  (uses the space at $03E0-$03FF; transferred to PPU in vblank)
;  - ppu_palBufToPPU		Transfers data from the Palette Buffer to the PPU.

;==[Palette Register Routines]=================================================;

; Routine: ppu_clearPal
; Resets the entire palette to black ($0F) using the PPU addresses.
;
; *RENDERING MUST BE OFF FOR THIS TO HAVE A CHANCE AT WORKING!*
;
; (usually only used at boot, but useful if you need to blank all pals)

ppu_clearPal:
	ldy #$3f
	ldx #$00
	jsr ppu_setAddr
	lda #$0f
	ldx #$20
@loop:
	sta PPU_DATA
	dex
	bne @loop

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_XferFullPalToPPU
; Transfers 32 bytes of palette data to the PPU via $3F00.
;
; *RENDERING MUST BE OFF FOR THIS TO HAVE A CHANCE AT WORKING!*
;
; Parameters:
; - *tmp00* - Address low byte
; - *tmp01* - Address high byte

ppu_XferFullPalToPPU:
	ldx #$3f
	ldy #$00
	stx PPU_ADDR
	sty PPU_ADDR		; set PPUADDR to $3F00 (palettes)

	ldy #$00
@loop:
	lda (tmp00),y		; load pal data byte
	sta PPU_DATA		; store in pal data
	iny
	cpy #$20			; 32 bytes
	bne @loop

	rts

;==[Palette Buffer Routines]===================================================;

; Routine: ppu_palBufToPPU
; Transfers data from the Palette Buffer to the PPU.
; Clobbers A,X,Y. Best used during VBlank.

ppu_palBufToPPU:
	lda #$3F
	ldx #$00
	sta PPU_ADDR
	stx PPU_ADDR

	ldy #0
@loop:
	lda palBufData,y
	sta PPU_DATA
	iny
	cpy #$20
	bne @loop

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_dataToPalBuf
; Transfer a set of bytes to the palette buffer.
;
; Parameters:
; - *A* - number of bytes to transfer
; - *X* - position in palette buffer to begin writing at
; - *tmp00* - data location hi
; - *tmp01* - data location lo

ppu_dataToPalBuf:
	sta tmp02

	ldy #0
@loop:
	lda (tmp00),y
	sta palBufData,x
	inx					; next position in pal buffer
	iny					; next position in pal data
	cpy tmp02			; check if we've reached the end
	bne @loop

	rts

;------------------------------------------------------------------------------;

