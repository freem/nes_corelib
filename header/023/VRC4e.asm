; Konami VRC4e: (up to 256KB) PRG-ROM + (0,2,8)KB PRG-RAM + (up to 512KB) CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=23&kwtype=pcb
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

; Mapper 023 (VRC4e) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $70|MIRRORING ; flags 6
	.byte $10 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes

; VRC4e defines
; Registers: $x000, $x008, $x008, $x00C
VRC4_PRGModeSwap = $9008 ; ($9008,$900C)
VRC4_PRGSelect0  = $8000 ; ($8000,$8004,$8008,$800C)
VRC4_PRGSelect1  = $A000 ; ($A000,$A004,$A008,$A00C)
VRC4_Mirroring   = $9000 ; ($9000,$9004)
VRC4_IRQControl  = $F000 ; ($F000,$F004,$F008,$F00C)
;-----------------------------------------------------;
VRC4_CHRSel0_Lo  = $B000 ; low 4 bits (PPU $0000)
VRC4_CHRSel0_Hi  = $B004 ; high 5 bits (PPU $0000)
VRC4_CHRSel1_Lo  = $B008 ; low 4 bits (PPU $0400)
VRC4_CHRSel1_Hi  = $B00C ; high 5 bits (PPU $0400)
VRC4_CHRSel2_Lo  = $C000 ; low 4 bits (PPU $0800)
VRC4_CHRSel2_Hi  = $C004 ; high 5 bits (PPU $0800)
VRC4_CHRSel3_Lo  = $C008 ; low 4 bits (PPU $0C00)
VRC4_CHRSel3_Hi  = $C00C ; high 5 bits (PPU $0C00)
;-----------------------------------------------------;
VRC4_CHRSel4_Lo  = $D000 ; low 4 bits (PPU $1000)
VRC4_CHRSel4_Hi  = $D004 ; high 5 bits (PPU $1000)
VRC4_CHRSel5_Lo  = $D008 ; low 4 bits (PPU $1400)
VRC4_CHRSel5_Hi  = $D00C ; high 5 bits (PPU $1400)
VRC4_CHRSel6_Lo  = $E000 ; low 4 bits (PPU $1800)
VRC4_CHRSel6_Hi  = $E004 ; high 5 bits (PPU $1800)
VRC4_CHRSel7_Lo  = $E008 ; low 4 bits (PPU $1C00)
VRC4_CHRSel7_Hi  = $E00C ; high 5 bits (PPU $1C00)
