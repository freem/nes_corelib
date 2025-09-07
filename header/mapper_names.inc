; Common mapper names, for use with "nes2_header.asm"
;------------------------------------------------------------------------------;
; todo:
; - submappers
; - more explanation on each mapper, but not TOO much
;   (that's what other references are for)
;------------------------------------------------------------------------------;
MAPPER_NUMBER_NROM         = 0
MAPPER_NUMBER_MMC1         = 1
MAPPER_NUMBER_UxROM        = 2
MAPPER_NUMBER_CNROM        = 3
MAPPER_NUMBER_MMC3         = 4 ; also used for MMC6
MAPPER_NUMBER_MMC5         = 5
; 006 = FFE
MAPPER_NUMBER_AxROM        = 7
; 008 = FFE ("synonym of mapper 6 submapper 4")
MAPPER_NUMBER_MMC2         = 9
MAPPER_NUMBER_MMC4         = 10
MAPPER_NUMBER_COLOR_DREAMS = 11
; 012 = SL-5020B (submapper 0) and FFE F6xxx (submapper 1)
MAPPER_NUMBER_CPROM        = 13 ; Videomation
; 014 = SL-1632
; 015 = K-1029, K-1030P (Contra multicarts)
; 016 = Bandai
; 017 = FFE
; 018 = Jaleco SS 88006
MAPPER_NUMBER_NAMCO_129    = 19 ; Namco 129 and 163
; 020 = Famicom Disk System (mostly used internally)
MAPPER_NUMBER_KONAMI_VRC4A = 21 ; VRC4a and VRC4c
MAPPER_NUMBER_KONAMI_VRC2A = 22
MAPPER_NUMBER_KONAMI_VRC2B = 23 ; VRC2b, VRC4e, VRC4f
MAPPER_NUMBER_KONAMI_VRC6A = 24 ; VRC6a (Akumajou Densetsu)
MAPPER_NUMBER_KONAMI_VRC4B = 25 ; VRC4b, VRC4d
MAPPER_NUMBER_KONAMI_VRC6B = 26 ; VRC6b (Madara, Esper Dream 2)
; 027 = pirate VRC4 variant?
MAPPER_NUMBER_ACTION_53    = 28
MAPPER_NUMBER_CUFROM       = 29 ; Sealie Computing RET-CUFROM
MAPPER_NUMBER_UNROM_512    = 30
MAPPER_NUMBER_NSF_SUBSET   = 31 ; "created to facilitate cartridge compilations of NSF music"
MAPPER_NUMBER_IREM_G_101   = 32
MAPPER_NUMBER_TAITO_TC0190 = 33
; 034 is both NINA-001/002 and BNROM
; 035 is a duplicate of mapper 209
; 036 = TXC 05-00002-010
; 037 = {Super Mario Bros. + Tetris + Nintendo World Cup} MMC3 multicart
; 038 = Bit Corp. Crime Busters
; 039 = ?
; 040 = NTDEC 2722
; 041 = Caltron 6-in-1
; 042 = hacked FDS conversions
; 043 = TONY-I, YS-612
; 044 = MMC3 multicart ("Super Big 7-in-1")
; 045 = GA23C (MMC3 clone used on multicarts)
; 046 = Rumble Station 15-in-1
; 047 = {Super Spike V'Ball + Nintendo World Cup} MMC3 multicart
; 048 = Taito TC0690
