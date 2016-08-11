; DRROM: 128KB PRG-ROM + 64KB CHR-ROM + Four-screen Mirorring
; http://bootgod.dyndns.org:7777/search.php?keywords=DRROM&kwtype=pcb
; DRROM uses Nintendo's clone of a Tengen 800004.
;------------------------------------------------------------------------------;
; DRROM has extra RAM for four-screen mirroring.
; %1xxx = four-screen mirroring
MIRRORING = %1000

; Mapper 206 (DRROM) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte $08 ; 8x 8K CHR-ROM banks
	.byte $E0|MIRRORING ; flags 6
	.byte $C0 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
