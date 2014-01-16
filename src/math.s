; freemco NES Corelib | shared math code
;------------------------------------------------------------------------------;
; Quick Division routines. Shifts values to the right.

; div_32: Divide by 32
div_32:
	lsr

; div_16: Divide by 16
div_16:
	lsr

; div_8: Divide by 8
div_8:
	lsr
	lsr
	lsr
	rts
;--------------------------------;
; Quick Multiply routines. Shifts values to the left.

; mul_32: Multiply by 32
mul_32:
	asl

; mul_16: Multiply by 16
mul_16:
	asl

; mul_8: Multiply by 8
mul_8:
	asl
	asl
	asl
	rts

;------------------------------------------------------------------------------;
; Fast Multiply by 10, by Leo Nechaev
; Sourced from http://6502.org/source/integers/fastx10.htm
mul_10:
	asl					; multiply by 2
	sta tmp00
	asl					; multiply by 2 again
	asl					; and once more
	clc
	adc tmp00			; A = x*8 + x*2
	rts

;------------------------------------------------------------------------------;
; Fast modulus 255
; Sourced from http://6502org.wikidot.com/software-math-fastmod

; Params:
; tmp00		Low byte
; tmp01		High byte
modulus255:
	clc
	lda tmp00
	adc tmp01
	adc #1
	sbc #0
	rts

;------------------------------------------------------------------------------;
; fast 8-bit linear feedback shift register-based random number generator
; Sourced from http://codebase64.org/doku.php?id=base:small_fast_8-bit_prng

; todo: figure out how to properly use multiple values in the routine

; These values run a complete loop of all 256 values:
randGenXorVals:
	.hex 1D 2B 2D 4D 5F 63 65 69 71 87 8D A9 C3 CF E7 F5

fastRand8:
	lda randSeed8
	beq @xorIt
	asl
	beq @noXor
	bcc @noXor

@xorIt:
	pha					; save cur seed value
	and #$0F			; mask with $0F (max index of randGenXorVals)
	tay
	pla					; restore cur seed value
	eor randGenXorVals+4	; xor with one of the values from the table.
@noXor:
	sta randSeed8
	rts

;------------------------------------------------------------------------------;
; fast 16-bit linear feedback shift register-based random number generator
; Sourced from http://codebase64.org/doku.php?id=base:small_fast_16-bit_prng

; todo: figure out what magic number to use
; todo2: use a set of random numbers, a la fastRand8

; fastRand16:
	; lda randSeed16
	; beq @lowZero

	; normal shift
	; asl randSeed16
	; lda randSeed16+1
	; rol
	; bcc @noXor

; @xorIt:
	; high byte in A
	;eor #>magic
	; sta randSeed16+1
	; lda randSeed16
	;eor #<magic
	; sta randSeed16
	; rts

; @lowZero:
	; lda randSeed16+1
	; beq @xorIt

	; asl
	; beq @noXor
	; bcs @xorIt

; @noXor:
	; sta randSeed16+1
	; rts

