; TK1ROM: 128KB PRG-ROM + 8KB PRG-RAM + 128KB CHR-ROM
; http://forums.nesdev.com/viewtopic.php?f=9&t=9891
; Uses a 7432 IC for a 28-pin CHR-ROM chip.
;------------------------------------------------------------------------------;
; TK1ROM mirroring is controlled by MMC3.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 004 (MMC3 - TK1ROM) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte $10 ; 16x 8K CHR-ROM banks
	.byte $40|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $01 ; PRG RAM in 8K increments
	.dsb 7, $00 ; clear the remaining bytes
