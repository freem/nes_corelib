; freemco NES Corelib | oam.asm (Trimmed for use in example 2)
; PPU functionality, focusing specifically on OAM (Sprites).
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

;------------------------------------------------------------------------------;
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

;------------------------------------------------------------------------------;
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

;------------------------------------------------------------------------------;
; oam_setEntryTile
; Sets the tile index for the specified OAM entry.

; Params:
; A				OAM index
; X				new tile index

oam_setEntryTile:
	oam_setSingleEntry $01
	rts

;------------------------------------------------------------------------------;
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

;------------------------------------------------------------------------------;
; oam_setEntryX
; Sets the X value for the specified OAM entry.

; Params:
; A				OAM index
; X				new X value

oam_setEntryX:
	oam_setSingleEntry $03
	rts
