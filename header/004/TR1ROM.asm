; TR1ROM: (128,256,512)KB PRG-ROM + 64KB CHR-ROM + Four-screen Mirorring
; http://bootgod.dyndns.org:7777/search.php?keywords=TR1ROM&kwtype=pcb
; Used for Gauntlet (Nintendo Licensed).
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K)
PRG_BANKS = $08

; TR1ROM has extra RAM for four-screen mirroring.
; %1xxx = four-screen mirroring
MIRRORING = %1000

; Mapper 004 (MMC3 - TR1ROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $08 ; 8x 8K CHR-ROM banks
	.byte $40|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
