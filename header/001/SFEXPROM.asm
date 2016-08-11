; SFEXPROM: 256KB PRG-ROM + 64KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SFEXPROM&kwtype=pcb

; "Patches PRG at runtime": http://forums.nesdev.com/viewtopic.php?t=1371
;------------------------------------------------------------------------------;
; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mapping, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 001 (MMC1 - SFEXPROM) iNES header
	.byte "NES",$1A
	.byte $10 ; 16x 16K PRG banks
	.byte $08 ; 8x 8K CHR banks
	.byte $10|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
