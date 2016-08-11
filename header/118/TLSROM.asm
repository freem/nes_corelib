; TLSROM: (128,256,512)KB PRG-ROM + 128KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=TLSROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K)
PRG_BANKS = $08

; TLSROM mirroring is handled in a nonstandard way.
; These values may or may not be used.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 118 (TLSROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $10 ; 16x 8K CHR-ROM
	.byte $60|MIRRORING ; flags 6
	.byte $70 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
