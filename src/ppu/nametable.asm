; File: ppu/nametable.asm
; Nametable-focused PPU routines.
;==============================================================================;
; todo: Finish adding attribute table routines

;==============================================================================;

; Routine: ppu_clearNT
; Clears the specified nametable using tile 0.
;
; Parameters:
; - *A* - Nametable to clear (0-3)

; 0=$2000, 1=$2400, 2=$2800, 3=$2C00
ppu_ntIndex: .db $20, $24, $28, $2C

ppu_clearNT:
	tay
	lda ppu_ntIndex,y
	sta PPU_ADDR
	ldy #0
	sty PPU_ADDR

	; clear tiles
	ldy #$C0
	ldx #4
	lda #0
@writeTiles:
	sta PPU_DATA
	dey
	bne @writeTiles
	dex
	bne @writeTiles

	; clear attrib
	ldy #$40
@writeAttrib:
	sta PPU_DATA
	dey
	bne @writeAttrib

	rts

;------------------------------------------------------------------------------;
; Routine: ppu_clearAllNT
; Clears all four nametables.
;
; Probably overkill except on four-screen games and on mappers with dynamic
; nametable mirroring.

ppu_clearAllNT:
	lda #0
	jsr ppu_clearNT
	lda #1
	jsr ppu_clearNT
	lda #2
	jsr ppu_clearNT
	lda #3
	jsr ppu_clearNT

	rts

;==============================================================================;
; Routine: ppu_writeString
; Writes a string of data to the PPU at the specified location.
;
; Parameters:
; - *A* - String length (copied to *tmp02*)
; - *X* - Nametable addr high
; - *Y* - Nametable addr low
; - *tmp00* - String Pointer Low
; - *tmp01* - String Pointer High

ppu_writeString:
	sta tmp02			; store string length for later use.
	jsr ppu_setAddr		; set address based on X and Y.

	; and now actually write the string.
	ldy #0
@writeLoop:
	lda (tmp00),y
	sta PPU_DATA
	iny
	cpy tmp02
	bne @writeLoop

	rts

;==============================================================================;
; Routine: ppu_writeCharRepeat
; Writes a single character to the PPU repeatedly.
;
; Parameters:
; - *A* - Tile Number
; - *X* - Nametable addr high
; - *Y* - Nametable addr low
; - *tmp00* - write length

ppu_writeCharRepeat:
	jsr ppu_setAddr		; set address based on X and Y

	ldy tmp00
@writeLoop:
	sta PPU_DATA
	dey
	cpy #0
	bne @writeLoop

	rts

;==[Nametable Buffer Routines]=================================================;

; Routine: ppu_WriteBuffer
; Transfer the contents of the VRAM buffer to the PPU.

ppu_WriteBuffer:
	ldy #0 ; start at the beginning

@ppu_WriteBuffer_BufferEntry:
	; get PPU address from buffer
	lda vramBufData,y
	sta tmp00
	iny
	lda vramBufData,y
	sta tmp01
	iny

	; get length/flags
	lda vramBufData,y
	beq @ppu_WriteBuffer_end ; length of 0 = buffer done

	sta tmp02 ; combined length and flags
	and #$7F
	sta tmp03 ; length only

	; change PPU increment value
	lda tmp02
	and #$80
	bne @ppu_WriteBuffer_Inc32

	; increment 1
	lda int_ppuCtrl
	and #%11111011
	sta PPU_CTRL
	jmp @ppu_WriteBuffer_SetAddr

@ppu_WriteBuffer_Inc32:
	; increment 32
	lda int_ppuCtrl
	and #%11111011
	ora #%00000100
	sta PPU_CTRL

@ppu_WriteBuffer_SetAddr:
	; set PPU address
	lda tmp00
	sta PPU_ADDR
	lda tmp01
	sta PPU_ADDR

	; write data
	ldx #0
	iny
@ppu_WriteBuffer_WriteLoop:
	lda vramBufData,y
	sta PPU_DATA
	iny
	inx
	cpx tmp03
	bne @ppu_WriteBuffer_WriteLoop

	jmp @ppu_WriteBuffer_BufferEntry ; loop until reaching a length of 0

@ppu_WriteBuffer_end:
	; reset to +1 increment
	lda int_ppuCtrl
	and #%11111011
	sta int_ppuCtrl
	rts

;==============================================================================;
; Routine: ppu_ClearBuffer
; Clears the VRAM buffer.

ppu_ClearBuffer:
	ldy #0
	lda #0
@ppu_ClearBuffer_loop:
	sta vramBufData,y
	iny
	cpy #$E0 ; xxx: hardcoded size
	bne @ppu_ClearBuffer_loop
	rts

;==[Attribute Table Routines]==================================================;

; Routine: ppu_ClearAttrib
; Clears an attribute table to all 0 values.
;
; Parameters:
; - *A* - Nametable to clear attributes for (0-3)

ppu_ClearAttrib:
	tay
	lda ppu_ntIndex,y
	clc
	adc #$03
	sta PPU_ADDR
	ldy #$C0
	sty PPU_ADDR

	lda #0
	ldy #$40
@ppu_ClearAttrib_loop:
	sta PPU_DATA
	dey
	bne @ppu_ClearAttrib_loop

	rts

;==============================================================================;
; ppu_WriteAttribFull
; routine for writing a full set of attributes (64 bytes)
;
; Parameters:
; - *A* - Nametable to clear attributes for (0-3)
; - *tmp00*, *tmp01* - Pointer to attribute data to write.

ppu_WriteAttribFull:
	tay
	lda ppu_ntIndex,y
	clc
	adc #$03
	sta PPU_ADDR
	ldy #$C0
	sty PPU_ADDR

	lda #0
	tay
@ppu_WriteAttribFull_loop:
	lda (tmp00),y
	sta PPU_DATA
	iny
	cpy #64
	bne @ppu_WriteAttribFull_loop

	rts

;==============================================================================;
; ppu_WriteAttribPartial
; routine for setting a 16x16 chunk's palette
; Parameters: A (section/palette), X, Y

; todo: will require masks in ROM for simplest operation

ppu_WriteAttribPartial:
	rts

;==============================================================================;
; ppu_WriteAttribSingle
; routine for setting a 32x32 chunk's palette
; Parameters: A (normal data, 00_00_00_00), X, Y

ppu_WriteAttribSingle:
	rts

;==============================================================================;
