; AOROM: (128,256)KB PRG-ROM + 8KB CHR-RAM
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K)
PRG_BANKS = $08

; AOROM mirroring is mapper controlled single screen.
MIRRORING = %0000

; Mapper 007 (AOROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $70|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
