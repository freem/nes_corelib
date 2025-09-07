; configurable NES 2.0 header
;==============================================================================;
; Most information sourced from https://www.nesdev.org/wiki/NES_2.0
;==============================================================================;

;==============================================================================;
; User-Configurable section
;==============================================================================;

;------------------------------------------------------------------------------;
; Mapper Number
;------------------------------------------------------------------------------;
; Unless you've memorized the mapper number you want to use, you'll probably
; need to check out https://www.nesdev.org/wiki/Mapper

; See "mapper_names.inc" for possible values.

HEADER_MAPPER_NUMBER = 0

;------------------------------------------------------------------------------;
; Sub-mapper Number
;------------------------------------------------------------------------------;
; You probably won't need this.
; When available, valid values are 0-15 ($0-$F).
; Meaning depends on the main mapper number.
; https://www.nesdev.org/wiki/NES_2.0_submappers

HEADER_SUBMAPPER_NUMBER = 0

;------------------------------------------------------------------------------;
; PRG-ROM size
;------------------------------------------------------------------------------;
; This value is set in 16KB units.
; Any value in the range $000-$EFF (3839) will be treated as normal.
; values $F00 (3840) and higher use an exponent-multiplier notation.

HEADER_PRG_ROM_SIZE = 1

; from https://www.nesdev.org/wiki/NES_2.0#PRG-ROM_Area
; If the MSB nibble is $F, an exponent-multiplier notation is used:
;   ++++----------- Header byte 9 D3..D0
;   |||| ++++-++++- Header byte 4
; D~BA98 7654 3210
;   --------------
;   1111 EEEE EEMM
;        |||| ||++- Multiplier, actual value is MM*2+1 (1,3,5,7)
;        ++++-++--- Exponent (2^E), 0-63
; 
; The actual PRG-ROM size is 2^E *(MM*2+1) bytes.

;------------------------------------------------------------------------------;
; CHR-ROM size
;------------------------------------------------------------------------------;
; This value is set in 8KB units.
; If using CHR-RAM, set this to 0, and find the "RAM Sizes" section below.

; Any value in the range $000-$EFF (3839) will be treated as normal.
; values $F00 (3840) and higher use an exponent-multiplier notation.

HEADER_CHR_ROM_SIZE = 1

; from https://www.nesdev.org/wiki/NES_2.0#CHR-ROM_Area
; If the MSB nibble is $F, an exponent-multiplier notation is used:
;   ++++----------- Header byte 9 D7..D4
;   |||| ++++-++++- Header byte 5
; D~BA98 7654 3210
;   --------------
;   1111 EEEE EEMM
;        |||| ||++- Multiplier, actual value is MM*2+1 (1,3,5,7)
;        ++++-++--- Exponent (2^E), 0-63
; 
; The actual CHR-ROM size therefore becomes 2^E * (MM*2+1).

;------------------------------------------------------------------------------;
; Flags 6 values
;------------------------------------------------------------------------------;
; Nametable Layout
; 0 = vertical arrangement (horizontal mirroring) OR mapper-controlled
; 1 = horizontal arrangement (vertical mirroring)
HEADER_FLAGS_6_NAMETABLE_LAYOUT = 0

; Battery and non-volatile memory
; 0 = no battery
; 1 = has battery
HEADER_FLAGS_6_BATTERY = 0

; 512 byte Trainer
; Most of the time, this should be left as 0.
HEADER_FLAGS_6_TRAINER = 0

; Alternative Nametables
; 0 = standard setup
; 1 = meaning depends on mapper; see below
HEADER_FLAGS_6_ALTERNATIVE_NAMETABLES = 0

; When set to 1, the following mappers provide 4KiB of RAM at $2000-$2FFF:
; - 004 (MMC3)
; - 206 (DxROM and related)
; - 262 (Street Heroes)

; Mapper 218 (Magic Floor) uses the Alternative Nametables bit as a selector
; for one-screen mirroring. Possible combinations:
; Vertical   %0xx1 (nametable layout == 1; alt. nametables == 0)
; Horizontal %0xx0 (nametable layout == 0; alt. nametables == 0)
; 1 Screen A %1xx0 (nametable layout == 0; alt. nametables == 1)
; 1 Screen B %1xx1 (nametable layout == 1; alt. nametables == 1)

; The behavior of Mapper 030 (UNROM 512) depends on the sub-mapper number:
; - Mapper 030 sub-mapper 3 ignores these bits entirely, so set them to 0.

; - Mapper 030 sub-mappers 0,1,2, and 4 use the following combinations:
; Vertical   %0xx0 (nametable layout == 0; alt. nametables == 0)
; Horizontal %0xx1 (nametable layout == 1; alt. nametables == 0)
; 1 Screen   %1xx0 (nametable layout == 0; alt. nametables == 1) switchable
; 4 Screen   %1xx1 (nametable layout == 1; alt. nametables == 1)

;------------------------------------------------------------------------------;
; Flags 7 values
;------------------------------------------------------------------------------;
; Console Type
; 0=NES/Famicom
; 1=Vs. System
; 2=PlayChoice-10
; 3=Extended Console Type

; Most of the time, this will be 0.
HEADER_FLAGS_7_CONSOLE_TYPE = 0

;------------------------------------------------------------------------------;
; RAM Sizes
;------------------------------------------------------------------------------;

; PRG-RAM shift count
; Set this to 0 if there is no PRG-RAM.
; Otherwise, value is treated as 64 << shift count; e.g. shift count of 7 = 8192 bytes
HEADER_PRG_RAM_SHIFT_COUNT = 0

; PRG-NVRAM shift count
; Follows the same rules as PRG-RAM shift count, but for non-volatile PRG-RAM.
HEADER_PRG_NVRAM_SHIFT_COUNT = 0

; CHR-RAM shift count
; Follows the same rules as PRG-RAM shift count, but for volatile CHR-RAM.
HEADER_CHR_RAM_SHIFT_COUNT = 0

; CHR-NVRAM shift count
; Follows the same rules as PRG-RAM shift count, but for non-volatile CHR-RAM.
HEADER_CHR_NVRAM_SHIFT_COUNT = 0

;------------------------------------------------------------------------------;
; CPU/PPU Timing
;------------------------------------------------------------------------------;
; 0=NTSC NES
; 1=PAL NES
; 2=multi-region
; 3=Dendy
HEADER_CPU_PPU_TIMING = 0

;------------------------------------------------------------------------------;
; byte 13 System Type
;------------------------------------------------------------------------------;
; when Vs. System (Flags 7 & 3 == 1):
; 76543210
; ||||||||
; ||||++++-- Vs. PPU type
; ++++------ Vs. Hardware Type

; Vs. PPU type
; (all unlisted values are reserved)
; $0 = Any RP2C03/RC2C03 variant
; $2 = RP2C04-0001
; $3 = RP2C04-0002
; $4 = RP2C04-0003
; $5 = RP2C04-0004
; $8 = RC2C05-01 (signature unknown)
; $9 = RC2C05-02 ($2002 AND $3F =$3D)
; $A = RC2C05-03 ($2002 AND $1F =$1C)
; $B = RC2C05-04 ($2002 AND $1F =$1B)
HEADER_VS_PPU_TYPE = 0

; Vs. Hardware Type
; (all unlisted values are undefined)
; $0: Vs. Unisystem (normal)
; $1: Vs. Unisystem (RBI Baseball protection)
; $2: Vs. Unisystem (TKO Boxing protection)
; $3: Vs. Unisystem (Super Xevious protection)
; $4: Vs. Unisystem (Vs. Ice Climber Japan protection)
; $5: Vs. Dual System (normal)
; $6: Vs. Dual System (Raid on Bungeling Bay protection)
HEADER_VS_HARDWARE_TYPE = 0

; when Extended Console Type (flags 7 & 3 == 3)
; 76543210
; xxxx||||
;     ++++-- Extended Console Type

; (all unlisted values are reserved)
; "Values $0-$2 are not used for the extended console type"
; $0 [Regular NES/Famicom/Dendy]
; $1 [Nintendo Vs. System]
; $2 [Playchoice 10]
; $3 Regular Famiclone, but with CPU that supports Decimal Mode
; $4 Regular NES/Famicom with EPSM module or plug-through cartridge
; $5 V.R. Technology VT01 with red/cyan STN palette
; $6 V.R. Technology VT02
; $7 V.R. Technology VT03
; $8 V.R. Technology VT09
; $9 V.R. Technology VT32
; $A V.R. Technology VT369
; $B UMC UM6578
; $C Famicom Network System
HEADER_EXTENDED_CONSOLE_TYPE = 0

;------------------------------------------------------------------------------;
; Miscellaneous ROM Area
;------------------------------------------------------------------------------;
; valid values are 0-3
HEADER_MISC_ROM_COUNT = 0

;------------------------------------------------------------------------------;
; Default Expansion Device
;------------------------------------------------------------------------------;
; full list at https://www.nesdev.org/wiki/NES_2.0#Default_Expansion_Device
HEADER_DEFAULT_EXPANSION_DEVICE = 0

;------------------------------------------------------------------------------;
; [end User-Configurable section]
;==============================================================================;
; Header Data
;==============================================================================;
	; file identifier
	.db 'N','E','S',$1A

	;----------------------------------;
	; PRG-ROM size LSB
	.db HEADER_PRG_ROM_SIZE & $00FF

	;----------------------------------;
	; CHR-ROM size LSB
	.db HEADER_CHR_ROM_SIZE & $00FF

	;----------------------------------;
	; Flags 6
	; 76543210
	; ||||||||
	; |||||||+-- Hard-wired nametable layout (0=vertical or mapper controlled, 1=horizontal)
	; ||||||+--- "Battery" and non-volatile memory
	; |||||+---- 512 byte trainer (0=no, 1=yes)
	; ||||+----- "Alternative nametables" (0=no, 1=yes)
	; ++++------ Mapper number LSB (bits D3..D0)
	.db (HEADER_MAPPER_NUMBER & $000F)<<4 | HEADER_FLAGS_6_ALTERNATIVE_NAMETABLES<<3 | HEADER_FLAGS_6_TRAINER<<2 | HEADER_FLAGS_6_BATTERY<<1 | HEADER_FLAGS_6_NAMETABLE_LAYOUT

	;----------------------------------;
	; Flags 7
	; 76543210
	; ||||10||
	; ||||||||
	; ||||||++-- Console type (0=NES/Famicom, 1=VS System 2=PlayChoice 10, 3=Extended)
	; ||||++---- NES 2.0 identifier
	; ++++------ Mapper number middle nibble (bits D7..D4)
	.db (HEADER_MAPPER_NUMBER & $00F0) | $08 | HEADER_FLAGS_7_CONSOLE_TYPE

	;----------------------------------;
	; Mapper MSB, Submapper
	; 76543210
	; ||||||||
	; ||||++++-- Mapper number MSB (bits D11--D8)
	; ++++------ Submapper number
	.db HEADER_SUBMAPPER_NUMBER<<4 | (HEADER_MAPPER_NUMBER & $0F00)

	;----------------------------------;
	; PRG and CHR-ROM size MSB
	; 76543210
	; ||||||||
	; ||||++++-- PRG-ROM size MSB
	; ++++------ CHR-ROM size MSB
	.db (HEADER_PRG_ROM_SIZE & $0F00) >> 4 | (HEADER_CHR_ROM_SIZE & $0F00) >> 8

	;----------------------------------;
	; PRG-RAM/EEPROM size
	; 76543210
	; ||||||||
	; ||||++++-- PRG-RAM (volatile) shift count
	; ++++------ PRG-NVRAM/EEPROM (non-volatile) shift count
	.db HEADER_PRG_NVRAM_SHIFT_COUNT << 4 | HEADER_PRG_RAM_SHIFT_COUNT

	;----------------------------------;
	; CHR-RAM size
	; 76543210
	; ||||||||
	; ||||++++-- CHR-RAM (volatile) shift count
	; ++++------ CHR-NVRAM (non-volatile) shift count
	.db HEADER_CHR_NVRAM_SHIFT_COUNT << 4 | HEADER_CHR_RAM_SHIFT_COUNT

	;----------------------------------;
	; CPU/PPU timing
	; 76543210
	; xxxxxx||
	;       ++-- CPU/PPU timing (0=NTSC NES, 1=PAL NES, 2=multi-region, 3=Dendy)
	.db HEADER_CPU_PPU_TIMING

	;----------------------------------;
	; byte 13 system type
.if (HEADER_FLAGS_7_CONSOLE_TYPE&3) == 1
	; Vs. System
	.db (HEADER_VS_HARDWARE_TYPE << 4) | HEADER_VS_PPU_TYPE
.elseif (HEADER_FLAGS_7_CONSOLE_TYPE&3) == 3
	; Extended Console Type
	.db HEADER_EXTENDED_CONSOLE_TYPE
.else
	.db 0
.endif

	;----------------------------------;
	; Misc. ROMs
	; 76543210
	; xxxxxx||
	;       ++-- Number of miscellaneous ROMs present
	.db HEADER_MISC_ROM_COUNT

	;----------------------------------;
	; Default Expansion Device
	; 76543210
	; xx||||||
	;   ++++++-- Default Expansion Device
	.db HEADER_DEFAULT_EXPANSION_DEVICE
