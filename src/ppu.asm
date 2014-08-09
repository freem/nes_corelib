; freemco NES Corelib | ppu.asm - shared PPU code
;==============================================================================;
; Internal PPU variables from engine.h:
; * int_ppuCtrl		Last write to PPU_CTRL/$2000
; * int_ppuMask		Last write to PPU_MASK/$2001
; * int_scrollX		Last X scroll (first write) to PPU_SCROLL/$2005
; * int_scrollY		Last Y scroll (second write) to PPU_SCROLL/$2005

; "Resetting PPU_ADDR (i.e. writing $00 to $2006 twice) works in most cases,
; but the correct way to fully reset the scroll is to write to $2000 and $2005
; instead. Write once to $2000 to select the name table and twice to $2005 to
; set the horizontal and vertical scroll. If you do that you don't need to
; reset $2006." - tokumaru, http://forums.nesdev.com/viewtopic.php?p=84785#p84785

;==[External Routines]=========================================================;
;.include "ppu/nametable.s"		; NameTable routines
.include "ppu/oam.s"			; OAM (Sprite) routines
.include "ppu/palette.s"		; Palette routines
;.include "ppu/vrambuf.s"		; VRAM Buffer routines
;.include "ppu/chr-ram.s"		; CHR-RAM routines

;==[PPU Register Routines]=====================================================;
; ppu_writeCtrl
; Writes the value of A to $2000 and the internal "last $2000" var.

ppu_writeCtrl:
	sta int_ppuCtrl
	sta PPU_CTRL
	rts
;==============================================================================;
; ppu_writeMask
; Writes the value of A to $2001 and the internal "last $2001" var.

ppu_writeMask:
	sta int_ppuMask
	sta PPU_MASK
	rts
;==============================================================================;
; ppu_writeScroll
; Writes the values from X and Y into $2005 and the internal scroll registers.

ppu_writeScroll:
	stx int_scrollX
	stx PPU_SCROLL
	sty int_scrollY
	sty PPU_SCROLL
	rts
;==============================================================================;
; ppu_writeScrollInt
; Writes the values from X and Y into the internal scroll registers.

ppu_writeScrollInt:
	stx int_scrollX
	sty int_scrollY
	rts
;==============================================================================;
; ppu_writeScrollSame
; Writes the same value (A) to X and Y scroll values.

ppu_writeScrollSame:
	sta int_scrollX
	sta PPU_SCROLL
	sta int_scrollY
	sta PPU_SCROLL
	rts
;==============================================================================;
; ppu_writeScrollIntSame
; Writes the same value (A) to the internal X and Y scroll values.

ppu_writeScrollIntSame:
	sta int_scrollX
	sta int_scrollY
	rts
;==============================================================================;
; ppu_resetScroll
; Resets the scroll to the first nametable by writing to PPU_CTRL and PPU_SCROLL.

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
; ppu_sprite0HitCheck
; Probes PPU_STATUS once to see if the Sprite 0 hit has been triggered.
; Returns the result in A. (0 = not triggered, 1 = triggered)

ppu_sprite0HitCheck:
	bit PPU_STATUS
	bvc @notyet

	lda #1
	jmp @end

@notyet:
	lda #0

@end:
	rts
;==============================================================================;
; ppu_waitVBLSet [dwedit]
; Waits for the vbl flag to become set.

ppu_waitVBLSet:
	bit PPU_STATUS
	bpl ppu_waitVBLSet
	rts
;==============================================================================;
; ppu_waitVBLClear [dwedit]
; Waits for the vbl flag to become cleared.

ppu_waitVBLClear:
	bit PPU_STATUS
	bmi ppu_waitVBLClear
	rts
;==============================================================================;
; ppu_setAddr
; Sets the current PPU address. (14 cycles)

; Params:
; X				High byte ($__00)
; Y				Low byte ($00__)

ppu_setAddr:
	stx PPU_ADDR
	sty PPU_ADDR
	rts

;==============================================================================;
; ppu_resetPalNTPos
; resets palette ($3F00) and nametable ($0000) positions.

ppu_resetPalNTPos:
	ldx #$3f
	ldy #$00
	jsr ppu_setAddr		; reset palette pos

	sty PPU_ADDR
	sty PPU_ADDR		; reset PPU address

	rts

;==[NMI-related Routines]======================================================;
; These used to live elsewhere but fuck it, they do shit with the PPU,
; so they probably belong here.
;==============================================================================;
; ppu_enableNMI
; Enable NMIs.

ppu_enableNMI:
	lda int_ppuCtrl
	ora #$80
	sta int_ppuCtrl
	sta PPU_CTRL
	rts

;==============================================================================;
; ppu_disableNMI
; Used to quickly disable NMIs from the PPU.

ppu_disableNMI:
	lda int_ppuCtrl
	and #$7F
	sta int_ppuCtrl
	sta PPU_CTRL
	rts
