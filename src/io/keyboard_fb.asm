; File: io/keyboard_fb.asm
; I/O for the Family BASIC Keyboard (HVC-007).
;==============================================================================;
; Routine: io_readKeyboard
; Handles reading the keyboard hardware.
;
; Data is stored starting at tmp00... (todo: find a better solution?)

io_readKeyboard:
	; initialize keyboard for reading
	lda #%00000101		; b00000101: enable KB, column 0, reset to row 1
	sta JOYSTICK1

	; wait between writes
	nop
	nop
	nop
	nop
	nop
	nop

	ldx #$08			; row counter
@doRow:
	; keyboard read (column 0)
	lda #%00000100
	sta JOYSTICK1

	ldy #$0a
@waitLoop1:
	dey
	bne @waitLoop1		; loop while nonzero
	nop

	; get first half of input
	lda JOYSTICK2
	lsr
	and #$0F
	beq @end			; end if zero

	sta tmp00,x

	lda #%00000110		; b00000110: enable KB, select column 1
	sta JOYSTICK1		; keyboard write

	ldy #$0a
@waitLoop2:
	dey
	bne @waitLoop2		; loop while nonzero
	nop
	nop

	; get second half of input
	lda JOYSTICK2
	asl
	asl
	asl
	; combine with first half
	and #$F0
	ora tmp00,x
	eor #$FF			; keys are normally active low, this fixes them to active high
	sta tmp00,x
	dex
	bpl @doRow			; loop until finished with rows

	rts
