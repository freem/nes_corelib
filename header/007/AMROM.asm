; AMROM: 128KB PRG-ROM + 8KB CHR-RAM
;------------------------------------------------------------------------------;
; AMROM mirroring is mapper controlled single screen.
MIRRORING = %0000

; Mapper 007 (AMROM) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $70|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
