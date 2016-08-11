; PEEOROM: 128KB PRG-ROM + 8KB PRG-RAM (battery optional) + 128KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=PEEOROM&kwtype=pcb
; PEEOROM can be configured to support EPROM chips via jumpers on the PCB.
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks ($01-$08)
PRG_BANKS = $08

; number of 8KB CHR-ROM banks ($01-$10)
CHR_BANKS = $10

; MMC2 mirroring is mapper controlled. This just sets the default.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 009 (PEEOROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $90|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $01 ; 8K PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
