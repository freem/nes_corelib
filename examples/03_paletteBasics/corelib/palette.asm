; freemco NES Corelib | palette.asm (Trimmed for use in example 3)
; PPU functionality, focusing specifically on Palettes.
;==============================================================================;
; ppu_XferFullPalToPPU
; Transfers 32 bytes of palette data to the PPU via $3F00.
; RENDERING MUST BE OFF FOR THIS TO HAVE A CHANCE AT WORKING!

; Params:
; tmp00			Address low byte
; tmp01			Address high byte

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
