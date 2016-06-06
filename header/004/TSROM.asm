; TSROM: (128,256,512)KB PRG-ROM + 8KB PRG-RAM (no battery) + (128,256)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=TSROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K)
PRG_BANKS = $08

; number of 8K CHR banks
; Valid values: $10 (128K), $20 (256K)
CHR_BANKS = $10

; TSROM mirroring is controlled by MMC3.
		  ; %0000 = Horizontal
		  ; %0001 = Vertical
MIRRORING = %0001

; Mapper 004 (MMC3 - TSROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS			; 16K PRG banks
	.byte CHR_BANKS			; 8K CHR-ROM banks
	.byte $40|MIRRORING		; flags 6
	.byte $00				; flags 7
	.byte $01				; PRG RAM in 8K increments
	.dsb 7, $00				; clear the remaining bytes
