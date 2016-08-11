; File: ppu.asm
; shared PPU code
;==============================================================================;
; Topic: Internal PPU variables
; - *int_ppuCtrl* - Last write to <PPU_CTRL>/$2000
; - *int_ppuMask* - Last write to <PPU_MASK>/$2001
; - *int_scrollX* - Last X scroll (first write) to <PPU_SCROLL>/$2005
; - *int_scrollY* - Last Y scroll (second write) to <PPU_SCROLL>/$2005
;
; "Resetting PPU_ADDR (i.e. writing $00 to $2006 twice) works in most cases,
; but the correct way to fully reset the scroll is to write to $2000 and $2005
; instead. Write once to $2000 to select the name table and twice to $2005 to
; set the horizontal and vertical scroll. If you do that you don't need to
; reset $2006." - tokumaru, <NESDev forums post at http://forums.nesdev.com/viewtopic.php?p=84785#p84785>

;==[External Routines]=========================================================;
.include "ppu/nametable.asm" ; Nametable routines
.include "ppu/oam.asm"       ; OAM (Sprite) routines
.include "ppu/palette.asm"   ; Palette routines

; todo: use some sort of define so CHR-RAM code doesn't end up in CHR-ROM games.
;.include "ppu/chr-ram.asm"   ; CHR-RAM routines

;==[PPU Register Routines]=====================================================;

; Macro: ppu_writeCtrl
; Writes the value of A to $2000 and the internal "last $2000" var.
;
; Parameters:
; - *A* - new <PPU_CTRL> value

.macro ppu_writeCtrl
	sta int_ppuCtrl
	sta PPU_CTRL
.endm

;==============================================================================;
; Macro: ppu_writeMask
; Writes the value of A to $2001 and the internal "last $2001" var.
;
; Parameters:
; - *A* - new <PPU_MASK> value

.macro ppu_writeMask
	sta int_ppuMask
	sta PPU_MASK
.endm

;==============================================================================;
; Macro: ppu_writeScroll
; Writes the values from X and Y into $2005 and the internal scroll registers.
;
; Parameters:
; - *X* - new X scroll value (first <PPU_SCROLL> write)
; - *Y* - new Y scroll value (second <PPU_SCROLL> write)

.macro ppu_writeScroll
	stx int_scrollX
	stx PPU_SCROLL
	sty int_scrollY
	sty PPU_SCROLL
.endm

;==============================================================================;
; Macro: ppu_writeScrollInt
; Writes the values from X and Y into the internal scroll register copies.
;
; Parameters:
; - *X* - new X scroll value
; - *Y* - new Y scroll value

.macro ppu_writeScrollInt
	stx int_scrollX
	sty int_scrollY
.endm

;==============================================================================;
; Macro: ppu_writeScrollSame
; Writes the same value (A) to X and Y scroll values.
;
; Parameters:
; - *A* - new scroll value

.macro ppu_writeScrollSame
	sta int_scrollX
	sta PPU_SCROLL
	sta int_scrollY
	sta PPU_SCROLL
.endm

;==============================================================================;
; Macro: ppu_writeScrollIntSame
; Writes the same value (A) to the internal X and Y scroll values.
;
; Parameters:
; - *A* - new scroll value

.macro ppu_writeScrollIntSame
	sta int_scrollX
	sta int_scrollY
.endm

;==============================================================================;
; Routine: ppu_resetScroll
; Resets the scroll to the first nametable by writing to <PPU_CTRL> and <PPU_SCROLL>.

ppu_resetScroll:
	; reset scroll
	lda #0
	sta PPU_SCROLL
	sta PPU_SCROLL
	sta int_scrollX
	sta int_scrollY

	; write to PPU control
	lda int_ppuCtrl
	and #%11111100
	sta PPU_CTRL
	sta int_ppuCtrl
	rts

;==============================================================================;
; Routine: ppu_sprite0HitCheck
; Probes <PPU_STATUS> once to see if the Sprite 0 hit has been triggered.
;
; Returns:
; Result in *A* (0 = not triggered, 1 = triggered)

ppu_sprite0HitCheck:
	bit PPU_STATUS
	bvc @notyet

	lda #1
	rts

@notyet:
	lda #0
	rts

;==============================================================================;
; Routine: ppu_waitVBLSet
; [dwedit] Waits for the vbl flag to become set.

ppu_waitVBLSet:
	bit PPU_STATUS
	bpl ppu_waitVBLSet
	rts

;==============================================================================;
; Routine: ppu_waitVBLClear
; [dwedit] Waits for the vbl flag to become cleared.

ppu_waitVBLClear:
	bit PPU_STATUS
	bmi ppu_waitVBLClear
	rts

;==============================================================================;
; Macro: ppu_setAddr
; Sets the current PPU address. (14 cycles)
;
; Parameters:
; - *X* - High byte ($__00)/first <PPU_ADDR> write
; - *Y* - Low byte ($00__)/second <PPU_ADDR> write

.macro ppu_setAddr
	stx PPU_ADDR
	sty PPU_ADDR
.endm

;==============================================================================;
; Macro: ppu_resetPalNTPos
; resets palette ($3F00) and nametable ($0000) positions.

.macro ppu_resetPalNTPos:
	ldx #$3F
	ldy #$00
	stx PPU_ADDR
	sty PPU_ADDR		; reset palette address
	sty PPU_ADDR
	sty PPU_ADDR		; reset PPU address
.endm

;==[NMI-related macros]======================================================;
; These used to live elsewhere, but they mess with the PPU, so they probably
; belong here.
;==============================================================================;

; Macro: ppu_enableNMI
; Enable NMIs.

.macro ppu_enableNMI
	lda int_ppuCtrl
	ora #$80
	sta int_ppuCtrl
	sta PPU_CTRL
.endm

;==============================================================================;
; Macro: ppu_disableNMI
; Used to quickly disable NMIs from the PPU.

.macro ppu_disableNMI
	lda int_ppuCtrl
	and #$7F
	sta int_ppuCtrl
	sta PPU_CTRL
.endm
