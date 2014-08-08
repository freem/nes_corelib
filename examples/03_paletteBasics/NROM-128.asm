; NROM-128: 16KB PRG-ROM + 8KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=NROM-128&kwtype=pcb
;------------------------------------------------------------------------------;
; NROM mirroring is hardwired via solder pads.
		  ; %0000 = Horizontal
		  ; %0001 = Vertical
MIRRORING = %0001

; Mapper 000 (NROM-128) iNES v1.0 header
	.byte "NES",$1A
	.byte $01				; 1x 16K PRG banks
	.byte $01				; 1x 8K CHR banks
	.byte $00|MIRRORING		; flags 6
	.byte $00				; flags 7
	.byte $00				; no PRG RAM
	.dsb 7, $00				; clear the remaining bytes
