; Konami VRC4a: (up to 256KB) PRG-ROM + (0,2,8)KB PRG-RAM + (up to 512KB) CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=21&kwtype=pcb
;
; This is the version with registers at $x000, $x002, $x004, $x006.
;------------------------------------------------------------------------------;
; number of 16K PRG banks
PRG_BANKS = $04

; number of 8K CHR banks
; Valid values: $02 (16K), $04 (32K), $06 (64K), $08 (128K), $0A (256K), $0C (512K)
CHR_BANKS = $02

; VRC4 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mirroring, you will need to set it via a write.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; xxx: PRG-RAM thing

; Mapper 021 (VRC4a) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $50|MIRRORING ; flags 6
	.byte $10 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes

; VRC4a defines
; Registers: $x000, $x002, $x004, $x006
VRC4_PRGModeSwap = $9004 ; ($9004,$9006)
VRC4_PRGSelect0  = $8000 ; ($8000,$8002,$8004,$8006)
VRC4_PRGSelect1  = $A000 ; ($A000,$A002,$A004,$A006)
VRC4_Mirroring   = $9000 ; ($9000,$9002)
VRC4_IRQControl  = $F000 ; ($F000,$F002,$F004,$F006)
;-----------------------------------------------------;
VRC4_CHRSel0_Lo  = $B000 ; low 4 bits (PPU $0000)
VRC4_CHRSel0_Hi  = $B002 ; high 5 bits (PPU $0000)
VRC4_CHRSel1_Lo  = $B004 ; low 4 bits (PPU $0400)
VRC4_CHRSel1_Hi  = $B006 ; high 5 bits (PPU $0400)
VRC4_CHRSel2_Lo  = $C000 ; low 4 bits (PPU $0800)
VRC4_CHRSel2_Hi  = $C002 ; high 5 bits (PPU $0800)
VRC4_CHRSel3_Lo  = $C004 ; low 4 bits (PPU $0C00)
VRC4_CHRSel3_Hi  = $C006 ; high 5 bits (PPU $0C00)
;-----------------------------------------------------;
VRC4_CHRSel4_Lo  = $D000 ; low 4 bits (PPU $1000)
VRC4_CHRSel4_Hi  = $D002 ; high 5 bits (PPU $1000)
VRC4_CHRSel5_Lo  = $D004 ; low 4 bits (PPU $1400)
VRC4_CHRSel5_Hi  = $D006 ; high 5 bits (PPU $1400)
VRC4_CHRSel6_Lo  = $E000 ; low 4 bits (PPU $1800)
VRC4_CHRSel6_Hi  = $E002 ; high 5 bits (PPU $1800)
VRC4_CHRSel7_Lo  = $E004 ; low 4 bits (PPU $1C00)
VRC4_CHRSel7_Hi  = $E006 ; high 5 bits (PPU $1C00)
