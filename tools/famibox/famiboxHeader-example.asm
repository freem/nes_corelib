; FamicomBox ROM Header
; Source: http://problemkaputt.de/everynes.htm#famicomboxromheaderatffe0h

; starts at $FFE0
; Game Title (ASCII, right-justified) [16 chars]
	.db "  GAME NAME HERE"

; PRG-ROM Checksum (ALL bytes or only last 16KBytes) [2 bytes]
	.ifdef _WITHOUT_HEADER ; PRG-only build (put dummy values here)
	.dw $0000
	.else
	.incbin "game.prg.chk" ; file calculated by external program
	.endif

; CHR-ROM Checksum ($0000 if no CHR-ROM) [2 bytes]
	.ifdef _WITHOUT_HEADER ; PRG-only build (put dummy values here)
	.dw $0000
	.else
	.incbin "game.chr.chk" ; file calculated by external program
	;or put .dw $0000 here if your game uses CHR-RAM
	.endif

; Unknown/Unused Cartridge Size "(MSB=PRG-ROM, LSB=CHR-ROM/RAM) (or so)"
	.db $00

; Mapper Type (implies Checksum Type), and bit7=Nametable Mirroring
; $00 NROM   PRG=8K,16K,32K
; $01 CNROM  PRG=8K,16K,32K
; $02 UNROM  PRG=128K (fixed size) (8 banks of 16K) chksum per whole 128K
; $03 GNROM? PRG=128K (fixed size) (4 banks of 32K) chksum per 32K bank
; $04 MMC's  PRG=16K  chksum per (any) mappable 16K bank(s) at C000h-FFFFh
; $05..$7F   Invalid
	.db $01 ; CNROM game

; Unknown/Unused (00h=NoTitle?, 01h=Normal, 02h=Mapper4?)
	.db 0

; Length of Title minus 1 (typically 02h..0Fh) (or often 10h=Corrupt)
	.db 14-1

; Maker Code (same as for Gameboy and SNES)
	.db 0

; Header Checksum (00h minus all bytes at [FFF2h..FFF8h]; covers CHR-ROM to maker code)
	.db 0 ; filled in by external program (fbxhsum)
