; HKROM: (! MMC6 !) 256KB PRG-ROM + 8KB PRG-RAM + 256KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=HKROM&kwtype=pcb
; Used only for StarTropics and StarTropics II.
; (todo: use NES 2.0 mapper 004.1; remember to use 1024 bytes for SRAM)
;------------------------------------------------------------------------------;
; HKROM mirroring is handled in the same fashion as MMC3.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 004 (MMC6 - HKROM) iNES header
	.byte "NES",$1A
	.byte $10 ; 16x 16K PRG banks
	.byte $20 ; 32x 8K CHR banks
	.byte $40|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
