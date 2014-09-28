; freemco NES Corelib | ppu/oam.asm
; PPU functionality, focusing specifically on OAM (Sprites).

; Sprites live at $0200-$02FF. (This can be changed)
; Get an index into the OAM by asl'ing a value from $00-$3F twice.
;==============================================================================;
; todo:
; * metasprites (multiple sprites operated as a single sprite)
;==============================================================================;
; oam_clearAll [shiru]
; Clears the OAM "properly", by hiding sprites.

oam_clearAll:
	ldx #0
	lda #$FF

@clrOAM1:
	sta OAM_BUF,x
	inx
	inx
	inx
	inx
	bne @clrOAM1
	rts

;==============================================================================;
; oam_update
; Updates all OAM data by transferring OAM_BUF contents via OAM_DMA.

oam_update:
	lda #0
	sta OAM_ADDR
	lda #>OAM_BUF
	sta OAM_DMA
	rts

;==============================================================================;
; oam_setEntryData
; Updates a single OAM data entry at the specified index.

; Params:
; A				OAM Index ($00-$3F)
; tmp00			Data Location (Low)
; tmp01			Data Location (High)

oam_setEntryData:
	; multiply by 4 for initial OAM index
	asl
	asl
	tax

	ldy #0
@writeData:
	lda (tmp00),y
	sta OAM_BUF,x
	inx
	iny
	cpy #4
	bne @writeData

	rts

;==============================================================================;
; oam_setEntryY
; Sets the Y value for the specified OAM entry.

; Params:
; A				OAM index
; X				new Y value

oam_setEntryY:
	pha
	asl
	asl
	tay					; set base OAM index
	txa
	sta OAM_BUF,y		; set new Y position
	pla
	rts

;==============================================================================;
; [M] oam_setSingleEntry
; A macro used by the oam_setEntry* routines for values other than Y.

; Params:
; A				OAM index
; X				new value

.macro oam_setSingleEntry slot
	pha
	asl
	asl
	clc
	adc #slot
	tay
	txa
	sta OAM_BUF,y
	pla
.endm

;==============================================================================;
; oam_setEntryTile
; Sets the tile index for the specified OAM entry.

; Note: When in 8x16 sprite mode, the LSB controls what bank to grab the tiles
; from. Also, 8x16 sprite mode uses two consecutive tiles to make the sprite.
; (Use oam_setEntryTile816 for 8x16 sprite-specific behavior.)

; Params:
; A				OAM index
; X				new tile index

oam_setEntryTile:
	oam_setSingleEntry $01
	rts

;==============================================================================;
; oam_setEntryTile816
; Sets the tile index for the specified OAM entry for 8x16 sprite modes.

; todo: make tile index selection more intuitive

; Params:
; A				OAM index
; X				new tile index (set as normal)
; Y -> tmp00	pattern table select ($00 or $01)

oam_setEntryTile816:
	pha			; temporarily save OAM index
	tya
	and #$FE	; mask this in case anyone tries something funny/stupid.
	sty tmp00

	; restore OAM index and find the slot
	pla
	asl
	asl
	clc
	adc #1
	tay

	; set tile index
	txa
	asl			; value is now $00-$FE
	ora tmp00	; set pattern table bit
	sta OAM_BUF,y
	rts

;==============================================================================;
; oam_setEntryAttr
; Sets the attributes for the specified OAM entry.

; Params:
; A				OAM index
; X				new attributes

; Attributes:
; 76543210
; ||||||||
; ||||||++- Palette (4-7)
; |||+++--- Unimplemented; always reads back as $00 via OAMDATA
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Horizontal flip
; +-------- Vertical flip

oam_setEntryAttr:
	oam_setSingleEntry $02
	rts

;==============================================================================;
; oam_setEntryX
; Sets the X value for the specified OAM entry.

; Params:
; A				OAM index
; X				new X value

oam_setEntryX:
	oam_setSingleEntry $03
	rts

;==============================================================================;
; Metasprites

; 8x8 mode:		All tiles are based on 8x8.
; 8x16 mode:	Width (tiles) is based on 8x8, Height (tiles) is based on 8x16.

; Metasprites need the following data:
; * metasprite width (tiles)
; * metasprite height (tiles)
; * general metasprite attributes (h/v flip status)
; {
; * metasprite tilemaps
; * specific metasprite attributes (palette)
; }

; When adding a metasprite, you need to know:
; * Initial sprite index (may get OAM cycled)
; * Base X position
; * Base Y position

; something about Metasprites and Animation frames
