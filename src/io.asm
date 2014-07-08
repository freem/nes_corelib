; freemco NES Corelib | io.asm - shared I/O code
;==============================================================================;
; Code for io_readJoy and io_readJoySafe comes from
; http://wiki.nesdev.com/w/index.php/Controller_Reading
; However, I have modified the latter, with no indications as to why.
;==============================================================================;
; io_readJoy
; Reads P1 and P2 controllers (not DMC fortified)

io_readJoy:
	; joystick latch
	lda #1
	sta JOYSTICK1
	lda #0
	sta JOYSTICK1

	ldx #$08			; read 8 buttons
@loop:
	lda JOYSTICK1
	and #$03			; %00000011 (Famicom uses P1 on 0 and P3 on 1)
	cmp #$01
	rol tmp00

	lda JOYSTICK2
	and #$03			; %00000011 (Famicom uses P2 on 0 and P4 on 1)
	cmp #$01
	rol tmp01

	dex
	bne @loop

	rts

;==============================================================================;
; io_readJoySafe
; Reads P1 and P2 controllers (DMC fortified)

io_readJoySafe:
	; Store current keypress state
	lda pad1State
	sta tmp04			; last frame keys P1
	lda pad2State
	sta tmp05			; last frame keys P2

	; read pads first time around
	jsr io_readJoy
	lda tmp00			; get player 1
	sta tmp02			; store first P1 read
	lda tmp01			; get player 2
	sta tmp03			; store first P2 read
	jsr io_readJoy		; read again

	ldx #1
@fixKeys:
	lda tmp00,x			; get new P1/P2 read
	cmp tmp02,x			; compare with first P1/P2 read
	bne @keepLastPress
	sta pad1State,x

@keepLastPress:
	lda tmp04,x
	eor #$FF
	and pad1State,x
	sta pad1Trigger,x
	dex
	bpl @fixKeys		; do it again for the other player

	rts
