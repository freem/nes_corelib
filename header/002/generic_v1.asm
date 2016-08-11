; Generic UxROM template (iNES)
; This template does not impose a specific "U*ROM" board layout.
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks
PRG_BANKS = $08

; UOROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 002 (UOROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $20|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
