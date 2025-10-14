; File: ppu/nametable.asm
; Nametable-focused PPU routines.
;==============================================================================;
; todo: Finish adding attribute table routines

;==============================================================================;

; Routine: ppu_clearNT
; Clears the specified nametable using tile 0.
;
; Parameters:
; - *Y* - Nametable to clear (0-3)

; 0=$2000, 1=$2400, 2=$2800, 3=$2C00
ppu_ntIndex: .db $20, $24, $28, $2C

ppu_clearNT:
	lda ppu_ntIndex,y
	sta PPU_ADDR
	lda #0
	sta PPU_ADDR

	; clear tiles
	ldy #$C0
	ldx #4
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
	jmp ppu_clearNT

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
	bne @writeLoop

	rts

;==============================================================================;
; Routine: ppu_writeList
; Write the contents of a list to the PPU.
; This routine is only meant to be run when rendering is off.
;
; Parameters:
; - *tmp00* - List pointer low
; - *tmp01* - List pointer high
;
; List Format:
; 0x00 - PPU address high byte
; 0x01 - PPU address low byte
; 0x02 - length of data to write
; 0x03 - pointer to data to write
;
; List is terminated with $FF in the PPU address high byte.

ppu_writeList:
	ldy #0
@doPage:
	; nt addr hi
	lda (tmp00),y
	bmi @writeDone
	sta PPU_ADDR
	iny

	; nt addr lo
	lda (tmp00),y
	sta PPU_ADDR
	iny

	; length
	lda (tmp00),y
	sta tmp0F ; store length for comparison
	iny

	; string pointer
	lda (tmp00),y
	sta tmp02
	iny
	lda (tmp00),y
	sta tmp03
	iny
	sty tmp0E
	ldy #0
@writeString:
	lda (tmp02),y
	sta PPU_DATA
	iny
	cpy tmp0F
	bne @writeString

	ldy tmp0E
	jmp @doPage

@writeDone:
	rts

;==============================================================================;
; Routine: ppu_writeListBuf
; Writes the contents of a list to the PPU buffer.
; Meant to be called multiple times until the Carry flag is set.
;
; Parameters:
; - *Y*     - Current index into message list
; - *tmp00* - List pointer low
; - *tmp01* - List pointer high
;
; Returns:
; - *Carry* - Set if writes are finished, clear if more writes remain
; - *Y*     - Updated index into message list
;
; List format is the same as ppu_writeList.

ppu_writeListBuf:
	sty tmp08
	ldx vramDataCurPos
@writeLoop:
	; nt addr hi
	; check if this is the end
	lda (tmp00),y
	bpl @ntAddrHi_Normal

	; writes are finished
	sec
	bcs @end

@ntAddrHi_Normal:
	sta vramBufData,x
	inx
	iny

	; nt addr lo
	lda (tmp00),y
	sta vramBufData,x
	iny
	inx

	; length
	lda (tmp00),y
	sta vramBufData,x
	sta tmp0F ; store length for comparison
	inx
	iny

	; string pointer
	lda (tmp00),y
	sta tmp02
	iny
	lda (tmp00),y
	sta tmp03
	iny
	sty tmp08
	ldy #0
@writeString:
	lda (tmp02),y
	sta vramBufData,x
	iny
	inx
	cpy tmp0F
	bne @writeString

	clc ; more writes needed
	stx vramDataCurPos
	lda #1
	sta vramUpdateWaiting

@end:
	; return updated message list index
	ldy tmp08
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
	bmi @ppu_WriteBuffer_Inc32

	; increment 1
	lda int_ppuCtrl
	and #%11111011
	sta PPU_CTRL
	bne @ppu_WriteBuffer_SetAddr

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
	ldx tmp03
	iny
@ppu_WriteBuffer_WriteLoop:
	lda vramBufData,y
	sta PPU_DATA
	iny
	dex
	bne @ppu_WriteBuffer_WriteLoop

	beq @ppu_WriteBuffer_BufferEntry ; loop until reaching a length of 0

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
