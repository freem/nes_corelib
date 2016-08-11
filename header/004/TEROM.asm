; TEROM: 32KB PRG-ROM + (16,32,64)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=TEROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 8K CHR banks
; Valid values: $02 (16K), $04 (32K), $08 (64K)
CHR_BANKS = $04

; TEROM mirroring is controlled by MMC3.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 004 (MMC3 - TEROM) iNES header
	.byte "NES",$1A
	.byte $02 ; 4x 16K PRG banks
	.byte CHR_BANKS ; 8K CHR-ROM banks
	.byte $40|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
