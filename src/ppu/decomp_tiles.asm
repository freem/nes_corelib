; File: ppu/decomp_tiles.asm
; PRG-ROM to CHR-RAM tile decompressor
;
; Code by tokumaru, from http://forums.nesdev.com/viewtopic.php?f=2&t=5860

; Variables: Tile decompressor variables
; These variables are in the zero page starting at $00C0.
;
; ColorCount - number of colors that can follow each color
; NextColor0 - first color that can follow each color
; NextColor1 - second color that can follow each color
; NextColor2 - third color that can follow each color
; SpecifiedColor - color necessary to find all the colors that follow a color (shares location with TempBit)
; TempBit - temporally holds a bit when reading 2 from the stream (shares location with SpecifiedColor)
; CurrentColor - color that can be followed by other colors (shares location with CurrentRow)
; CurrentRow - backup of the index of the row being worked on (shares location with CurrentColor)
; InputStream - pointer to the data being decompressed
; TileCount - number of tiles to decompress
; BitBuffer - buffer of bits comming from the stream
; Plane0 - lower plane of a tile's row
; Plane1 - upper plane of a tile's row
; PlaneBuffer - buffer that holds the second plane until it's time to output it
.enum $00C0
	ColorCount .dsb 4	;number of colors that can follow each color
	NextColor0 .dsb 4	;first color that can follow each color
	NextColor1 .dsb 4	;second color that can follow each color
	NextColor2 .dsb 4	;third color that can follow each color

	SpecifiedColor		;color necessary to find all the colors that follow a color
	TempBit .dsb 1		;temporally holds a bit when reading 2 from the stream
	CurrentColor		;color that can be followed by other colors
	CurrentRow .dsb 1	;backup of the index of the row being worked on

	InputStream .dsb 2	;pointer to the data being decompressed
	TileCount .dsb 1	;number of tiles to decompress
	BitBuffer .dsb 1	;buffer of bits comming from the stream

	Plane0 .dsb 1		;lower plane of a tile's row
	Plane1 .dsb 1		;upper plane of a tile's row
	PlaneBuffer .dsb 8	;buffer that holds the second plane until it's time to output it
.ende

; Routine: DecompressTiles
; Decompresses a group of tiles from PRG-ROM to CHR-RAM.
DecompressTiles:
	;clear the bit buffer
	lda #$80
	sta BitBuffer

	;copy the tile count from the stream
	ldy #$00
	lda (InputStream), y
	sta TileCount
	iny

-StartBlock:
	;start by specifying how many colors can follow color 3 and listing all of them
	ldx #$03

-ProcessColor:
	;copy from the stream the number of colors that can follow the current one
	jsr +Read2Bits
	sta ColorCount, x

	;go process the next color if the current one is only followed by itself
	beq +AdvanceColor

	;read from the stream the one color necessary to figure all of them out
	lda #$01
	sta SpecifiedColor
	jsr +ReadBit
	bcc +
	inc SpecifiedColor
	jsr +ReadBit
	bcc +
	inc SpecifiedColor
+	cpx SpecifiedColor
	bcc +ListColors
	dec SpecifiedColor

+ListColors:
	;assume the color is going to be listed
	lda SpecifiedColor
	pha

	;go list the color if it's the only one that can follow the current one
	lda ColorCount, x
	cmp #$02
	bcc +List1Color

	;keep the color from being listed if only 2 colors follow the current one
	bne +FindColors
	pla

+FindColors:
	;save a copy of the current color so that values can be compared to it
	stx CurrentColor

	;find the 2 colors that are not the current one or the specified one
	lda #$00
-	cmp SpecifiedColor
	beq +
	cmp CurrentColor
	beq +
	pha
	sec
+	adc #$00
	cmp #$04
	bne -

	;skip listing the third color if only 2 can follow the current one
	lda ColorCount, x
	cmp #$02
	beq +List2Colors

	;write the third color that can follow the current one
	pla
	sta NextColor2, x

+List2Colors:
	;write the second color that can follow the current one
	pla
	sta NextColor1, x

+List1Color:
	;write the first color that can follow the current one
	pla
	sta NextColor0, x

+AdvanceColor:
	;move on to the next color if there are still colors left
	dex
	bpl -ProcessColor

	;pretend that all pixels of the previous row used color 0
	lda #$00
	sta Plane0
	sta Plane1

-DecodeTile:
	;prepare to decode 8 rows
	ldx #$07

-DecodeRow:
	;decide between repeating the previous row or decoding a new one
	jsr +ReadBit
	bcs +WriteRow

	;prepare the flag that will indicate the end of the row
	lda #$01
	sta Plane1

	;remember which row is being decoded
	stx CurrentRow

	;read a pixel from the stream and draw it
	jsr +Read2Bits
	bpl +DrawNewPixel

-CheckCount:
	;go draw the pixel if its color can't be followed by any other
	lda ColorCount, x
	beq +RepeatPixel

	;decide between repeating the previous pixel or decoding a new one
	jsr +ReadBit
	bcs +RepeatPixel

	;skip if more than one color can follow the current one
	lda ColorCount, x
	cmp #$01
	bne +DecodeColor

	;go draw the only color that follows the current one
	lda NextColor0, x
	bcs +DrawNewPixel

+DecodeColor:
	;decode a pixel from the stream
	jsr +ReadBit
	bcs +
	lda NextColor0, x
	bcc +DrawNewPixel
+	lda ColorCount, x
	cmp #$03
	bcc +
	jsr +ReadBit
	bcs ++
+	lda NextColor1, x
	bcc +DrawNewPixel
++	lda NextColor2, x

+DrawNewPixel:
	;make a copy of the pixel for the next iteration
	tax

-DrawPixel:
	;draw the pixel to the row
	lsr
	rol Plane0
	lsr
	rol Plane1

	;go process the next pixel if the row isn't done
	bcc -CheckCount

	;restore the index of the row
	ldx CurrentRow

+WriteRow:
	;output the fist plane of the row and buffer the second one
	lda Plane0
	sta $2007
	lda Plane1
	sta PlaneBuffer, x

	;move on to the next row if there are still rows left
	dex
	bpl -DecodeRow

	;output the second plane of the tile
	ldx #$07
-	lda PlaneBuffer, x
	sta $2007
	dex
	bpl -

	;return if there are no more tiles to decode
	dec TileCount
	beq +Return

	;decide between decoding another tile or starting a new block
	jsr +ReadBit
	bcc -DecodeTile
	jmp -StartBlock

+RepeatPixel:
	;go draw a pixel of the same color as the previous one
	txa
	bpl -DrawPixel

+Read2Bits:
	;read 2 bits from the stream and return them in the accumulator
	jsr +ReadBit
	rol TempBit
	jsr +ReadBit
	lda TempBit
	rol
	and #$03
	rts

+ReadBit:
	;read a bit from the stream and return it in the carry flag
	asl BitBuffer
	bne +Return
+	lda (InputStream), y
	iny
	bne +
	inc InputStream+1
+	rol
	sta BitBuffer

+Return:
	;return
	rts
