; shared utility code
;------------------------------------------------------------------------------;
; Sources:
; http://wiki.nesdev.com/w/index.php/Synthetic_Instructions
; http://www.ffd2.com/fridge/chacking/c=hacking9.txt ("Coding Tricks" section)
;------------------------------------------------------------------------------;
; b7c: Bit 7 to Carry (2 cycles)
.macro b7c
	cmp #$80
.endm
;--------------------------------;
; asr: Arithmetic shift right (4 cycles)
.macro asr
	b7c
	ror a
.endm
;--------------------------------;
; rsl: Rotate Straight Left (4 cycles)
.macro rsl
	b7c
	rol
.endm
;--------------------------------;
; neg: Negate A (6 cycles)
.macro neg
	eor #$FF
	sec
	adc #0
.endm
;--------------------------------;
; gbs: Get Bits Set (6+ cycles; how many depends on how many branches)
; Source: http://6502org.wikidot.com/software-counting-bits
.macro gbs
	ldx #$FF
@1:	inx
@2:	asl
	bcs @1
	bne @2
.endm
;--------------------------------;
; txy: Transfer X to Y (4 cycles, clobbers A)
.macro txy
	txa
	tay
.endm
;--------------------------------;
; tyx: Transfer Y to X (4 cycles, clobbers A)
.macro tyx
	tya
	tax
.endm
;------------------------------------------------------------------------------;
; delay
; Delays for a number of milliseconds (equiv. to 1790*(Y+5) cycles).

; Params:
; Y				Number of milliseconds to delay.

; align so branches don't cross pages
.align 16
delay:
		ldx tmp00		; 3 cycles/2 bytes
		ldx #$FE		; 2 cycles/2 bytes (254)
@loop:
		nop				; 2 cycles/1 byte
		dex				; 2 cycles/1 byte
		bne @loop		; 2 cycles/2 bytes (+1 if branch taken)
		cmp tmp00		; 3 cycles/2 bytes
		dey				; 2 cycles/1 byte
		bne delay		; 2 cycles/2 bytes (+1 if branch taken)
		rts
