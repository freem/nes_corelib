; TKSROM: (128,256,512)KB PRG-ROM + 8KB PRG-RAM + 128KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=TKSROM&kwtype=pcb
; Apparently only used for "Ys III: Wanderers from Ys" (J)
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K)
PRG_BANKS = $08

; TKSROM mirroring is handled in a nonstandard way.
; These values may or may not be used.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Should the SRAM be battery backed or not?
; %0010 = battery backed
; %0000 = no battery
SRAM_BATTERY = %0000

; Mapper 118 (TKSROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $10 ; 16x 8K CHR-ROM
	.byte $60|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $70 ; flags 7
	.byte $01 ; 8K of PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
