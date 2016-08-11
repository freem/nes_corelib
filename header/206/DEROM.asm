; DEROM: 64KB PRG-ROM + (32,64)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=DEROM&kwtype=pcb
; DEROM uses Nintendo's clone of a Tengen 800002.
;------------------------------------------------------------------------------;
; number of 8K CHR banks
; Valid values: $04 (32K), $08 (64K)
CHR_BANKS = $04

; DEROM mirroring is like MMC3; mapper controlled.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 206 (DEROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks
	.byte CHR_BANKS ; 8K CHR-ROM banks
	.byte $E0|MIRRORING ; flags 6
	.byte $C0 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
