; File: ppu/oam.asm
; PPU functionality, focusing specifically on OAM (Sprites).
;
; Sprites live at $0200-$02FF. (This can be changed by setting OAM_BUF)
;
; Get an index into the OAM by asl'ing a value from $00-$3F twice.
;==============================================================================;
; todo:
; * metasprites (multiple sprites operated as a single sprite)
; * animation system
;==============================================================================;
; Routine: oam_clearAll
; [shiru] Clears the OAM "properly", by hiding sprites.

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
; Routine: oam_update
; Updates all OAM data by transferring OAM_BUF contents via OAM_DMA.

oam_update:
	lda #0
	sta OAM_ADDR
	lda #>OAM_BUF
	sta OAM_DMA
	rts

;==============================================================================;
; Routine: oam_setEntryData
; Updates a single OAM data entry at the specified index.
;
; Parameters:
; - *A* - OAM Index ($00-$3F)
; - *tmp00* - Data Location (Low byte)
; - *tmp01* - Data Location (High byte)

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
; Routine: oam_setEntryY
; Sets the Y value for the specified OAM entry.
;
; Parameters:
; - *A* - OAM index
; - *X* - new Y value

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
; Macro: oam_setSingleEntry
; A macro used by the oam_setEntry* routines for values other than Y.
;
; Parameters:
; - *A* - OAM index
; - *X* - new value

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
; Routine: oam_setEntryTile
; Sets the tile index for the specified OAM entry.
;
; Note:
; When in 8x16 sprite mode, the LSB controls what bank to grab the tiles
; from. Also, 8x16 sprite mode uses two consecutive tiles to make the sprite.
; (Use <oam_setEntryTile816> for 8x16 sprite-specific behavior.)
;
; Parameters:
; - *A* - OAM index
; - *X* - new tile index

oam_setEntryTile:
	oam_setSingleEntry $01
	rts

;==============================================================================;
; Routine: oam_setEntryTile816
; Sets the tile index for the specified OAM entry for 8x16 sprite modes.
;
; todo:
; make tile index selection more intuitive
;
; Parameters:
; - *A* - OAM index
; - *X* - new tile index (set as normal)
; - *Y* - pattern table select ($00 or $01)

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
; Routine: oam_setEntryAttr
; Sets the attributes for the specified OAM entry.
;
; Parameters:
; - *A* - OAM index
; - *X* - new attributes
;
; Attributes:
; (begin code)
; 76543210
; ||||||||
; ||||||++- Palette (4-7)
; |||+++--- Unimplemented; always reads back as $00 via OAMDATA
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Horizontal flip
; +-------- Vertical flip
; (end code)

oam_setEntryAttr:
	oam_setSingleEntry $02
	rts

;==============================================================================;
; Routine: oam_setEntryX
; Sets the X value for the specified OAM entry.
;
; Parameters:
; - *A* - OAM index
; - *X* - new X value

oam_setEntryX:
	oam_setSingleEntry $03
	rts

;==============================================================================;
; Metasprites

; Use a system like the one in "Quack - a duck simulator".
; the system there is multi-tiered, and set up for animation.

; The following things need to be taken into account:
; * number of sprites needed in metasprite
; * sprite definitions (x offset, y offset, attribs, tilenum)

; the Quack system's metasprites are known as "animation frames", and have the
; following information, in order:
; * number of sprites
; * frame length
; * pointers to directional tilemaps (4)
; * pointers to hitbox data (4)

; The tilemaps themselves are sets of {Y offset, tile, attrib., X offset} values.

; Other games may need different setups, so this isn't a 1:1 recreation.
; Decoupling the animation data from the actual metasprite data is the first step.
; Figuring out a flexible system (w/r/t tilemap definitions) is harder.

; When adding a metasprite to the display, you need to know:
; * Initial sprite index (may get OAM cycled)
; * Base X position
; * Base Y position

;==============================================================================;
; Animation System

; In "Quack - a duck simulator", the sprite and animation data are intertwined.
; (The collision hitboxes are too, but that isn't dealt with here.)

; Essentially, an animation is a collection of assembled metasprites, along with
; a timer to change what frame is displayed.

; Animations:
; * number of frames in animation
; * pointers to animation frames (metasprites)
; * frame lengths
