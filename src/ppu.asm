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
