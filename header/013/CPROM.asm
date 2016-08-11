; CPROM: 32KB PRG-ROM + 16KB CHR-RAM
; http://bootgod.dyndns.org:7777/search.php?keywords=CPROM&kwtype=pcb
;------------------------------------------------------------------------------;
; Mapper 013 (CPROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $D1 ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
