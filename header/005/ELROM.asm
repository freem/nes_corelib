; ELROM: (128,256,512,1024)KB PRG-ROM + (128,256,512,1024)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=ELROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K), $40 (1024K)
PRG_BANKS = $08

; number of 8K CHR banks
; Valid values: $10 (128K), $20 (256K), $40 (512K), $80 (1024K)
CHR_BANKS = $04

; ELROM mirroring is controlled by MMC5.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 005 (MMC5 - ELROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR-ROM banks
	.byte $50|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
