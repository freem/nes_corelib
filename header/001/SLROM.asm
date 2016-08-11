; SLROM: (128,256KB)PRG-ROM + 128KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SLROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K)
PRG_BANKS = $08

; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mapping, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 001 (MMC1 - SLROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $10 ; 16x 8K CHR banks
	.byte $10|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
