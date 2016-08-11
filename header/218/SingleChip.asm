; Single Chip Cartridge
; http://forums.nesdev.com/viewtopic.php?t=9342
; Used by Magic Floor: http://problemkaputt.de/magicflr.htm
;------------------------------------------------------------------------------;
; This one is interesting; it doesn't have any CHR-ROM or CHR-RAM. Instead, it
; uses the internal 2KB Nametable RAM as CHR-RAM.

; Mapper 218 nametable mirroring is unique.
; The Four-Screen bit is used as a One-Screen flag instead.
; Vertical   %0001
; Horizontal %0000
; 1Screen A  %1000
; 1Screen B  %1001
MIRRORING =  %1001

; Mapper 218 (PRG chip-only; CIC if required) iNES header
	.byte "NES",$1A
	.byte $01 ; 1x 16K PRG banks
	.byte $00 ; Using nametable ram as CHR-RAM
	.byte $A0|MIRRORING ; flags 6
	.byte $D0 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
