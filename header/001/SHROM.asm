; SHROM: 32KB PRG-ROM + 128KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SHROM&kwtype=pcb
; [SH1ROM has a nonstandard pinout, but that doesn't matter for iNES headers.]
;------------------------------------------------------------------------------;
; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mapping, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 001 (MMC1 - SEROM) iNES header
	.byte "NES",$1A
	.byte $02 ; 2x 16K PRG banks (32K total)
	.byte $10 ; 16x 8K CHR banks (128K total)
	.byte $10|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
