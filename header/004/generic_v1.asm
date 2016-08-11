; Generic MMC3 Template (iNES v1.0)
; This template does not impose a specific "T*ROM" board layout.
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks
PRG_BANKS = $08

; number of 8K CHR banks ($00 = CHR-RAM)
CHR_BANKS = $02

; MMC3 mirroring is mapper controlled. This just sets the default.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Should the SRAM be battery backed or not?
; %0010 = battery backed
; %0000 = no battery
SRAM_BATTERY = %0000

; number of 8K PRG-RAM banks
SRAM_SIZE = $00

; Mapper 004 (MMC3 - generic) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG-ROM banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $40|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte SRAM_SIZE ; PRG RAM size in 8K increments
	.dsb 7, $00 ; clear the remaining bytes
