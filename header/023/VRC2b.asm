; Konami VRC2b: 
; http://bootgod.dyndns.org:7777/search.php?unif_op=LIKE+%60%25%40%25%60&unif=KONAMI-VRC-2&ines_op=%3D%60%40%60&ines=23
;------------------------------------------------------------------------------;
; number of 16K PRG banks
PRG_BANKS = $04

; number of 8K CHR banks
CHR_BANKS = $02

; VRC2 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mirroring, you will need to set it via a write.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; xxx: PRG-RAM thing

; Mapper 023 (VRC2b) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $70|MIRRORING ; flags 6
	.byte $10 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes

; VRC2b defines
; Registers: $x000, $x002, $x001, $x003
VRC2_PRGSelect0 = $8000 ; ($8000,$8002,$8001,$8003)
VRC2_PRGSelect1 = $A000 ; ($A000,$A002,$A001,$A003)
VRC2_Mirroring  = $9000 ; ($9000,$9001,$9002,$9003)
VRC2_Microwire  = $6000 ; ($6000-$6FFF)
;-----------------------------------------------------;
VRC2_CHRSel0_Lo = $B000 ; low 4 bits (PPU $0000)
VRC2_CHRSel0_Hi = $B002 ; high 5 bits (PPU $0000)
VRC2_CHRSel1_Lo = $B001 ; low 4 bits (PPU $0400)
VRC2_CHRSel1_Hi = $B003 ; high 5 bits (PPU $0400)
VRC2_CHRSel2_Lo = $C000 ; low 4 bits (PPU $0800)
VRC2_CHRSel2_Hi = $C002 ; high 5 bits (PPU $0800)
VRC2_CHRSel3_Lo = $C001 ; low 4 bits (PPU $0C00)
VRC2_CHRSel3_Hi = $C003 ; high 5 bits (PPU $0C00)
;-----------------------------------------------------;
VRC2_CHRSel4_Lo = $D000 ; low 4 bits (PPU $1000)
VRC2_CHRSel4_Hi = $D002 ; high 5 bits (PPU $1000)
VRC2_CHRSel5_Lo = $D001 ; low 4 bits (PPU $1400)
VRC2_CHRSel5_Hi = $D003 ; high 5 bits (PPU $1400)
VRC2_CHRSel6_Lo = $E000 ; low 4 bits (PPU $1800)
VRC2_CHRSel6_Hi = $E002 ; high 5 bits (PPU $1800)
VRC2_CHRSel7_Lo = $E001 ; low 4 bits (PPU $1C00)
VRC2_CHRSel7_Hi = $E003 ; high 5 bits (PPU $1C00)
