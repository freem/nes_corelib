; CNROM: (16,32)KB PRG-ROM + (8,16,32)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=UNROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks ($01 or $02)
PRG_BANKS = $02

; number of 8K CHR banks ($01, $02, or $04)
CHR_BANKS = $04

; CNROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 003 (CNROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $30|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
