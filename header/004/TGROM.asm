; TGROM: (128,256,512)KB PRG-ROM + 8KB CHR-RAM
; http://bootgod.dyndns.org:7777/search.php?keywords=TGROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K)
PRG_BANKS = $08

; TGROM mirroring is controlled by MMC3.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 004 (MMC3 - TGROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $40|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
