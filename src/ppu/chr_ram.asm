; File: ppu/chr_ram.s
; PPU functionality, focusing specifically on CHR-RAM.
;==============================================================================;
; Routine: ppu_clearCHR
; Clears a page of CHR-RAM.
;
; Parameters:
; - *A* - Page to clear ($00 = page $0000, $10 = page $1000)

ppu_clearCHR:
	; set page to clear
	sta PPU_ADDR
	lda #0
	sta PPU_ADDR

	ldx #0
	ldy #0
@clearLoop:
	; store twice since tiles are 2BPP
	sta PPU_DATA
	sta PPU_DATA
	inx
	bne @clearLoop
	iny
	cpy #8
	bne @clearLoop

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_clearAllCHR
; Clears all pages of active CHR-RAM.

ppu_clearAllCHR:
	lda #$00
	jsr ppu_clearCHR
	lda #$10
	jmp ppu_clearCHR

;------------------------------------------------------------------------------;
; Routine: ppu_clearCHRPartial
; Clears a specified number of tiles of CHR-RAM.
;
; Parameters:
; - *A* - Number of tiles to clear (copied to tmp00)
; - *X* - Starting point High
; - *Y* - Starting point Low

ppu_clearCHRPartial:
	stx PPU_ADDR
	sty PPU_ADDR
	sta tmp00

	lda #0
	ldx #0
@clearData:
	; clear data for this tile
.rept 16
	sta PPU_DATA
.endr

	inx
	cpx tmp00
	bne @clearData

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_loadTiles
; Loads tiles from memory into the specified section of CHR-RAM.
;
; Parameters:
; - *A* - number of tiles to read
; - *X* - PPU write location high byte
; - *Y* - PPU write location low byte
; - *tmp00,tmp01* - pointer to data to read

ppu_loadTiles:
	; set starting PPU addr
	stx PPU_ADDR
	sty PPU_ADDR

	; store number of tiles to write and prepare for the loop
	sta tmp02
	ldx #0
	ldy #0

	; writing tiles: the loop
@writeTiles:
	; part 1: each tile is comprised of 16 bytes.
	lda (tmp00),y
	sta PPU_DATA
	iny
	cpy #16
	bne @writeTiles

	; part 2: advance one tile
	clc
	lda tmp00
	adc #$10
	sta tmp00
	; check if we need to increment tmp01
	bcc @noFix
	inc tmp01

@noFix:
	; part 3: check if we're done.
	ldy #0
	inx
	cpx tmp02
	bne @writeTiles

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_loadTiles8K
; Loads 8K worth of tiles (both sides) into CHR-RAM.
;
; Parameters:
; - *tmp00*,*tmp01* - pointer to data to read

loadTiles8k:
	; disable rendering
	ldy #0
	sty PPU_MASK

	; write tiles starting at PPU $0000
	sty PPU_ADDR
	sty PPU_ADDR

	ldx #32
@writeLoop:
	lda (tmp00),y
	sta PPU_DATA
	iny
	bne @writeLoop
	inc tmp01
	dex
	bne @writeLoop

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_loadTilesCompressed
; Loads 4K worth of compressed tiles into CHR-RAM. Requires ppu/decomp_tiles.s.
;
; Parameters:
; - *A* - Page to load in ($00 or $10)
; - *X* - low byte
; - *Y* - high byte

ppu_loadTilesCompressed:
	; store pointer to input stream
	stx InputStream
	sty InputStream+1
	; set PPU address and decompress
	ldy #0
	sta PPU_ADDR
	sty PPU_ADDR
	jsr DecompressTiles

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_updateTile
; Updates the data of a single tile (16 bytes).
;
; Parameters:
; - *A* - tile index to change ($00-$FF)
; - *X* - CHR bank where tile index lives ($00 or $10)
; - *tmp00,tmp01* - pointer to data to write
;
; Usage:
; - *tmp02* - High byte of PPU location to write to
; - *tmp03* - Low byte of PPU location to write to
; - *tmp04* - raw tile index to change

ppu_updateTile:
	sta tmp04			; raw tile index
	stx tmp02			; base upper location byte

	; now the hard part, finding out the real location.
	; 1) find the lower nybble of the high byte ($#_)
	and #$F0
	lsr
	lsr
	lsr
	lsr
	ora tmp02
	sta tmp02

	; 2) find the upper nybble of the low byte ($_#)
	lda tmp04
	and #$0F
	asl
	asl
	asl
	asl
	sta tmp03

	; set up PPU address for writing
	ldx tmp02
	stx PPU_ADDR
	sta PPU_ADDR

	; and write the tile data
	ldy #0
.rept 16
	lda (tmp00),y
	sta PPU_DATA
	iny
.endr
	rts

;------------------------------------------------------------------------------;
; Routine: ppu_writeSolidTile
; Writes a solid tile to the PPU.
; It's assumed you've set the PPU address before calling this.
;
; Parameters:
; - *A* - Tile Data 1
; - *X* - Tile Data 2

ppu_writeSolidTile:
	; data 1
.rept 8
	sta PPU_DATA
.endr

	; data 2
.rept 8
	stx PPU_DATA
.endr
	rts
