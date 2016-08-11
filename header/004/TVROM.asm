; TVROM: 64KB PRG-ROM + (16,32,64)KB CHR-ROM + Four-screen Mirorring
; http://bootgod.dyndns.org:7777/search.php?keywords=TVROM&kwtype=pcb
; Used for Rad Racer II.
;------------------------------------------------------------------------------;
; number of 8K CHR banks
; Valid values: $02 (16K), $04 (32K), $08 (64K)
CHR_BANKS = $04

; TVROM has extra RAM for four-screen mirroring.
; %1xxx = four-screen mirroring
MIRRORING = %1000

; Mapper 004 (MMC3 - TVROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 16K PRG banks
	.byte CHR_BANKS ; 8x 8K CHR-ROM banks
	.byte $40|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
