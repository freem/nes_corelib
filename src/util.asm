; File: util.asm
; Shared utility code
;==============================================================================;
; Topic: Sources
; - http://wiki.nesdev.com/w/index.php/Synthetic_Instructions
; - http://www.ffd2.com/fridge/chacking/c=hacking9.txt ("Coding Tricks" section)
;==============================================================================;
; Macro: b7c
; Bit 7 to Carry (2 cycles)
;
; (start code)
; b7c:
;	cmp #$80
; (end code)
.macro b7c
	cmp #$80
.endm

;==============================================================================;
; Macro: asr
; Arithmetic shift right (4 cycles). Uses <b7c> macro.
;
; (start code)
; asr:
;	b7c
;	ror a
; (end code)
.macro asr
	b7c
	ror a
.endm

;==============================================================================;
; Macro: rsl
; Rotate Straight Left (4 cycles). Uses <b7c> macro.
;
; (start code)
; rsl:
;	b7c
;	rol
; (end code)
.macro rsl
	b7c
	rol
.endm

;==============================================================================;
; Macro: neg
; Negate A (6 cycles)
;
; (start code)
; neg:
;	eor #$FF
;	sec
;	adc #0
; (end code)
.macro neg
	eor #$FF
	sec
	adc #0
.endm

;==============================================================================;
; Macro: gbs
; Get Bits Set (6+ cycles; how many depends on how many branches)
;
; Source: http://6502org.wikidot.com/software-counting-bits
.macro gbs
	ldx #$FF
@1:	inx
@2:	asl
	bcs @1
	bne @2
.endm

;==============================================================================;
; Macro: txy
; Transfer X to Y (4 cycles, clobbers A)
;
; (start code)
; txy:
;	txa
;	tay
; (end code)
.macro txy
	txa
	tay
.endm

;==============================================================================;
; Macro: tyx
; Transfer Y to X (4 cycles, clobbers A)
;
; (start code)
; tyx:
;	tya
;	tax
; (end code)
.macro tyx
	tya
	tax
.endm

;==============================================================================;
; Macro: phx
; Push X pseudo for NMOS 6502 (5 cycles, clobbers A)
;
; (start code)
; phx:
;	txa
;	pha
; (end code)
.macro phx
	txa
	pha
.endm

;==============================================================================;
; Macro: phy
; Push Y pseudo for NMOS 6502 (5 cycles, clobbers A)
;
; (start code)
; phy:
;	tya
;	pha
; (end code)
.macro phy
	tya
	pha
.endm

;==============================================================================;
; Macro: plx
; Pull X pseudo for NMOS 6502 (6 cycles, clobbers A)
;
; (start code)
; plx:
;	pla
;	tax
; (end code)
.macro plx
	pla
	tax
.endm

;==============================================================================;
; Macro: ply
; Pull Y pseudo for NMOS 6502 (6 cycles, clobbers A)
;
; (start code)
; ply:
;	pla
;	tay
; (end code)
.macro ply
	pla
	tay
.endm

;==============================================================================;
; Routine: delay
; Delays for a number of milliseconds (1790*(Y+5) cycles).
;
; (1790 is somehow derived from the 1.79MHz of the 2A03/6502.)
;
; xxx: the jsr and rts are not included in the above calculation... are they?
;
; Parameters:
; - *Y* -Number of milliseconds to delay.

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
