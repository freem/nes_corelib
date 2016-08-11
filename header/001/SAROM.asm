; SAROM: 64KB PRG-ROM + 8KB PRG-RAM + (16,32,64)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SAROM&kwtype=pcb
; Appears to only have been used for "Dragon Warrior" (U)?
;------------------------------------------------------------------------------;
; number of 8K CHR banks
; Valid configurations: $02 (16K), $04 (32K), $08 (64K)
CHR_BANKS = $02

; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mirroring, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Should the SRAM be battery backed or not?
SRAM_BATTERY = %0000 ; %0010 = battery backed; %0000 = no battery

; Mapper 001 (MMC1 - SAROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $10|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $01 ; PRG RAM size in 8K increments
	.dsb 7, $00 ; clear the remaining bytes
