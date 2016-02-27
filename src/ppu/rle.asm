; File: ppu/rle.asm
; RLE decompressor by Shiru (ASM6 version)
;
; Uses 4 bytes in zero page (tmp00-tmp03).

; Routine: unrle
; Decompress data from an address in X/Y to PPU_DATA.
;
; Parameters:
; - *X* - Address low byte
; - *Y* - Address high byte

unrle:
	stx tmp00			; RLE_LOW
	sty tmp01			; RLE_HIGH

	ldy #0
	jsr rle_byte
	sta tmp02			; RLE_TAG
@1:
	jsr rle_byte
	cmp tmp02			; RLE_TAG
	beq @2
	sta PPU_DATA
	sta tmp03			; RLE_BYTE
	bne @1
@2:
	jsr rle_byte
	cmp #0
	beq @4
	tax
	lda tmp03			; RLE_BYTE
@3:
	sta PPU_DATA
	dex
	bne @3
	beq @1
@4:
	rts

rle_byte:
	lda (tmp00),y		; RLE_LOW
	inc tmp00			; RLE_LOW
	bne @1
	inc tmp01			; RLE_HIGH
@1:
	rts
