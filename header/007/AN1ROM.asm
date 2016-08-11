; AN1ROM: 64KB PRG-ROM + 8KB CHR-RAM
;------------------------------------------------------------------------------;
; AN1ROM mirroring is mapper controlled single screen.
MIRRORING = %0000

; Mapper 007 (AN1ROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $70|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
