; TQROM: 128KB PRG-ROM + (16,32,64)KB CHR-ROM + 8KB CHR-RAM
; http://bootgod.dyndns.org:7777/search.php?keywords=TQROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 8K CHR banks
; Valid values: $02 (16K), $04 (32K), $08 (64K)
CHR_BANKS = $02

; TQROM mirroring is handled by MMC3.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 119 (TQROM) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte CHR_BANKS ; CHR-ROM (this mapper also includes CHR-RAM)
	.byte $70|MIRRORING ; flags 6
	.byte $70 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
