; Common mapper names, for use with "nes2_header.asm"
;==============================================================================;
; See also:
; https://www.nesdev.org/wiki/Mapper
; https://www.nesdev.org/wiki/NES_2.0_submappers
;------------------------------------------------------------------------------;
; todo:
; - submappers
; - more explanation on each mapper, but not TOO much
;   (that's what other references are for)
; - handle common questions
; - table of common mappers
;==============================================================================;

; todo: various JY Company ASIC mappers
; 035 "explicitly specifies 8 KiB of WRAM"; duplicate of mapper 209
; 090 "inhibits...ROM nametables and Extended Mirroring"
; 209 "standard implementation"
; 211 "No such PCB exists in real hardware"; duplicate of mapper 209
; 281 "outer PRG bank size of 256 KiB", different Outer Bank register bits
; 282 "outer PRG bank size of 256 KiB", different Outer Bank register bits
; 295 "outer PRG bank size of 128 KiB"
; 358 "outer PRG bank size of 512 KiB selected in part by the CHR banking mode"
; 386 "YY860729C"
; 387 "YY850735C" and "YY850817C"
; 388 "YY841145C" and "YY850835C"
; 397 "1996 Soccer 6-in-1 (JY-082)"

;==============================================================================;
; Mapper Defines
;==============================================================================;
MAPPER_NUMBER_NROM           = 0

MAPPER_NUMBER_MMC1           = 1
; "Submapper 5 denotes the SEROM/SHROM/SH1ROM circuit boards with 32 KiB of unbanked PRG-ROM"
MAPPER_NUMBER_1_SUBMAPPER_FNS_2ME = 6 ; Famicom Network System 2ME circuit board
; "Submapper 7 denotes the Kaiser KS-7058 that mounts the KS 203 MMC1 clone, but with hard-wired nametable arrangement"

MAPPER_NUMBER_UxROM          = 2
MAPPER_NUMBER_CNROM          = 3

MAPPER_NUMBER_MMC3           = 4 ; also used for MMC6
;MAPPER_NUMBER_4_SUBMAPPER_MMC6 = 1
;MAPPER_NUMBER_4_SUBMAPPER_MC_ACC = 3 ; Acclaim MC-ACC
;MAPPER_NUMBER_4_NEC_MMC3 = 4 ; "Loading the latch with 0 disables IRQ" ("old" behavior)

MAPPER_NUMBER_MMC5           = 5
; 006 = FFE ("Doctor Header file denotes a Magic Card 1M/2M disk", "Submapper field denotes the initial latch-based banking mode (0-7)")
MAPPER_NUMBER_AxROM          = 7
; 008 = FFE ("synonym of mapper 6 submapper 4")
MAPPER_NUMBER_MMC2           = 9
MAPPER_NUMBER_MMC4           = 10
MAPPER_NUMBER_COLOR_DREAMS   = 11
; 012 = SL-5020B (submapper 0) and FFE F6xxx (submapper 1)
MAPPER_NUMBER_CPROM          = 13 ; Videomation
; 014 = SL-1632
; 015 = K-1029, K-1030P (Contra multicarts)
; 016 = Bandai
; 017 = FFE ("Doctor Header file denotes a Super Magic Card disk")
; 018 = Jaleco SS 88006

MAPPER_NUMBER_NAMCO_163      = 19 ; Namco 163 and 129
;MAPPER_NUMBER_19_SUBMAPPER_NO_EXP_SOUND = 2
;MAPPER_NUMBER_19_SUBMAPPER_EXP_SOUND_11dB = 3 ; Expansion sound 11.0-13.0dB louder than NES APU
;MAPPER_NUMBER_19_SUBMAPPER_EXP_SOUND_16dB = 4 ; Expansion sound 16.0-17.0dB louder than NES APU
;MAPPER_NUMBER_19_SUBMAPPER_EXP_SOUND_18dB = 5 ; Expansion sound 18.0-19.5dB louder than NES APU

; 020 = Famicom Disk System (mostly used internally; you (likely) won't need this)
MAPPER_NUMBER_KONAMI_VRC4A   = 21 ; Konami VRC4a and VRC4c
MAPPER_NUMBER_KONAMI_VRC2A   = 22
MAPPER_NUMBER_KONAMI_VRC2B   = 23 ; Konami VRC2b, VRC4e, VRC4f
MAPPER_NUMBER_KONAMI_VRC6A   = 24 ; Konami VRC6a (Akumajou Densetsu)
MAPPER_NUMBER_KONAMI_VRC4B   = 25 ; Konami VRC4b, VRC4d
MAPPER_NUMBER_KONAMI_VRC6B   = 26 ; Konami VRC6b (Madara, Esper Dream 2)
; 027 = pirate VRC4 variant?
MAPPER_NUMBER_ACTION_53      = 28
MAPPER_NUMBER_CUFROM         = 29 ; Sealie Computing RET-CUFROM
MAPPER_NUMBER_UNROM_512      = 30
MAPPER_NUMBER_NSF_SUBSET     = 31 ; "created to facilitate cartridge compilations of NSF music"
MAPPER_NUMBER_IREM_G_101     = 32
MAPPER_NUMBER_TAITO_TC0190   = 33

; 034 is both NINA-001/002 and BNROM
MAPPER_NUMBER_BNROM_NINA     = 34
MAPPER_NUMBER_34_SUBMAPPER_NINA  = 1 ; 034.1 = NINA-001/002
MAPPER_NUMBER_34_SUBMAPPER_BNROM = 2 ; 034.2 = BNROM

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
; 049 = (pirate MMC3 multicart)
; 050 = "N-32 conversion of Super Mario Bros. 2 (J)"

; 051 = "11-in-1 Ball Games [p1][!]"
; 051.1 "Submapper 1 is used for 11-in-1 Ball Games (JY-010)(850828C)"

; 052 = Realtec 8213 and similar MMC3 multicarts
; 053 = "Supervision 16-in-1 [p1]"
; 055 = UNIF "BTL-MARIO1-MALEE2" board
; 056 = "a specific unlicensed reproduction of Super Mario Bros. 3"
; 057 = "GK" multicarts
; 058 = simple NROM/CNROM multicarts
; 059 = UNIF "BMC-T3H53", "BMC-D1038"
; 060 = reset-based 4-in-1 multicart
; 061 = three multicart PCBs (GS-2017, {NTDEC 0324 and BS-N032})
; 062 = "Super 700-in-1"
; 063 = NTDEC POWERFUL 250-IN-1
MAPPER_NUMBER_TENGEN_RAMBO_1 = 64 ; Tengen RAMBO-1
MAPPER_NUMBER_IREM_H3001     = 65 ; Irem H3001
MAPPER_NUMBER_GxROM          = 66 ; GNROM, MHROM
MAPPER_NUMBER_SUNSOFT_3      = 67 ; Sunsoft-3
MAPPER_NUMBER_SUNSOFT_4      = 68 ; Sunsoft-4
MAPPER_NUMBER_SUNSOFT_FME7   = 69 ; Sunsoft 5A, 5B, FME-7
; 070 = Bandai
; 071 = Codemasters
MAPPER_NUMBER_JALECO_JF17    = 72 ; Jaleco JF-17
MAPPER_NUMBER_KONAMI_VRC3    = 73
; 074 = Waixing 43-393/43-406/860908C PCB (MMC3 clone)
MAPPER_NUMBER_KONAMI_VRC1    = 75
; 076 = Namco NAMCOT-3446 (Namcot 108-based)
; 077 = Napoleon Senki

; 078 = Holy Diver and Uchuusen - Cosmo Carrier
; 078.1 = Uchuusen   (single screen mirroring)
; 078.3 = Holy Diver (mapper controlled H/V mirroring)

; 079 = NINA 003-006
MAPPER_NUMBER_TAITO_X1_005   = 80 ; Taito X1-005
; 081 = NTDEC "Super Gun"
; 082 = Taito X1-017 (old PRG bank order)

; 083 = Cony/Yoko
; 083.0 = 1 KiB CHR-ROM banking, no WRAM
; 083.1 = 2 KiB CHR-ROM banking, no WRAM
; 083.2 = 1 KiB CHR-ROM banking with outer bank, 32 KiB banked WRAM

MAPPER_NUMBER_KONAMI_VRC7    = 85
; 085.1 = VRC7b (Tiny Toon Adventures 2)
; 085.2 = VRC7a (Lagrange Point)

; 086 = Jaleco JF-13
; 087 = Jaleco "J87" (unofficial name)
; 089 = Sunsoft-2 chip on Sunsoft-3 board

; 091 = Super Fighter III etc. (JY830623C, YY840238C)
; 091.0 = PA12-based IRQ counter and hard-wired mirroring
; 091.1 = M2-based IRQ counter and selectable mirroring

; 093 = Sunsoft-2 chip on Sunsoft-3R board
MAPPER_NUMBER_OEKA_KIDS      = 96 ; Oeka Kids
; 097 = Irem TAM-S1

; Nintendulator-specific debugging mapper
MAPPER_NUMBER_NINTENDULATOR_DEBUG = 100

; 103 = "a specific pirate port of the FDS version of Doki Doki Panic"
; 104 = "PEGASUS 5 IN 1"
; 105 = NES-EVENT (MMC1)
; 106 = Super Mario Bros 3 bootleg using discrete logic
; 107 = "Magic Dragon"

; 108 = various FDS-to-cart conversions
; todo: submappers 1-4

MAPPER_NUMBER_GTROM          = 111 ; Cheapocabra/GTROM

; 112 = mapper 206 clone with scrambled registers
; 113 = HES NTD-8 multicart

; 114 = "MMC3-clone-bearing board with scrambled register addresses and indices"
; 114.0 = Aladdin (Super Game), The Lion King (Super Game)
; 114.1 = Boogerman (Super Game)

; 115 = Ka Sheng SFC-02B/-03/-004 (MMC3 clone)

MAPPER_NUMBER_GOUDER_SOMARI_P = 116 ; Gouder SOMARI-P
; 116.0 = Huang-1 chip, PAL configuration -W
; 116.1 = Huang-1 chip, PAL confituration -P
; 116.2 = Huang-2 chip
; 116.3 = "Reset-based multicart with Huang-1 chip"

; 117 = Future Media "Crayon Shin-Chan (Ch)", "San Guo Zhi 4 - Chi Bi Feng Yun"
MAPPER_NUMBER_MMC3_TxSROM    = 118 ; TxSROM (MMC3)
MAPPER_NUMBER_MMC3_TQROM     = 119 ; TQROM (MMC3)
; 120 = Whirlwind Manu LH15
; 121 = Ka Sheng A9711, A9713 (MMC3 clone, protection)
; 122 = JY043
; 123 = Ka Sheng H2288 (MMC3 clone with scrambled register indices)
; 124 = "Super Game Mega Type III pirate arcade board"
; 125 = Whirlwind Manu LH32 (UNIF "UNL-LH32")
; 127 = "a particular pirate version of Double Dragon II - The Revenge (Japan)"
; 132 = TXC boards (UNIF "UNL-22211")
; 133 = Sachen 3009 and 72008
; 134 = T4A54A, WX-KB4K, BS-5652 (MMC3 clones)
MAPPER_NUMBER_SACHEN_3011    = 136 ; Sachen 3011
MAPPER_NUMBER_SACHEN_8259D   = 137 ; Sachen 8259D (UNIF "UNL-Sachen-8259D")
MAPPER_NUMBER_SACHEN_8259B   = 138 ; Sachen 8259B (UNIF "UNL-Sachen-8259B")
MAPPER_NUMBER_SACHEN_8259C   = 139 ; Sachen 8259C (UNIF "UNL-Sachen-8259C")
; 140 = Jaleco JF-11, JF-14
MAPPER_NUMBER_SACHEN_8259A   = 141 ; Sachen 8259A (UNIF "UNL-Sachen-8259A")
; 142 = Kaiser KS202 (UNIF "UNL-KS7032")
; 143 = Sachen NROM with protection
; 144 = AGCI 50282
; 145 = Sachen SA-72007
; 146 = Sachen 3015, SA-016
; 147 = Sachen 3018
; 148 = Sachen SA-008-A, Tengen 800008
; 149 = Sachen SA-0036
; 150 = Sachen SA-015, SA-630 (UNIF "UNL-Sachen-74LS374N')
; 152 = discrete logic 74*161/161/32
; 153 = Bandai FCG with LZ93D50 ASIC and 8192 bytes of battery-backed WRAM
; 154 = Namco NAMCOT-3453
; 155 = MMC1A
; 156 = Daou DIS23C01 DAOU 245
; 157 = Bandai Datach Joint ROM
; 158 = Tengen 800037
; 159 = Bandai FCG with LZ93D50 ASIC and 128 byte serial EEPROM
; 162 = Waixing FS304

; 163 = Nanjing FC-001
; 163.1 = Nanjing FC-001 with ADPCM chip

; 165 = MMC2+MMC3 hybrid
; 167 = Subor
; 168 = Racermate Challenge 2
; 169 = "This mapper is used in Yuxing's ROMs"
; 170 = "Shiko Game Syu"
; 171 = BBK Floppy-1 and SC-98 keyboard famiclones
; 172 = Super Mega P-4070 board
; 173 = Idea-Tek using 05-00002-010 ASIC
; 174 = NTDEC 5-in-1 (NTSC)
; 175 = Kaiser "15-in-1" multicart

; 176 = 8025 enhanced MMC3 clone
; todo: submappers

; 177 = Hengge Dianzi oversize BNROM

; 178 = Waixing FS305, Nanjing NJ0430, etc.
; todo: submappers

; 180 = "Crazy Climber" UNROM variant
MAPPER_NUMBER_SUNSOFT_1      = 184 ; Sunsoft-1

; 185 = CNROM with CHR-ROM protection
; todo: submappers

; 187 = Ka Sheng A98402 (MMC3 clone)
; 188 = Bandai "Karaoke Studio"
; 189 = unlicensed MMC3 games with 32KiB PRG banks
; 190 = Zemina "Magic Kid Googoo"
; 191 = (MMC3 clone)
; 192 = Waixing FS308 (MMC3 clone)
; 193 = NTDEC TC-112
; 194 = (MMC3 clone)
; 195 = Waixing FS303 (MMC3 clone)

; 196 = MRCM (MMC3 clone)
; todo: submappers

; 197 = (MMC3 clone)
; todo: submappers

; 198 = (MMC3 clone)
; 199 = Waixing FS309 (MMC3 clone)

; 200 = Address latch-based NROM-128 multicarts
; todo: submappers

; 201 = multicart mapper with multiple NROM-256 games
; 202 = "150-in-1" shipped with SP60 famiclone
; 203 = "35-in-1"
; 204 = (various pirate multicarts)
; 205 = multicart with MMC3 clone (UNIF "BMC-JC-016-2")
; 206 = Tengen MIMIC-1, Namcot 118, DxROM
; 207 = Taito X1-005 with alternate mirroring

; 208 = Gouder "Street Fighter IV" (MMC3 clone)
; todo: submappers

; 209 = J.Y. Company ASIC "standard implementation"

; 210 = Namco 175/340
; 210.1 = Namco 175
; 210.2 = Namco 340

; 212 = "BMC Super HiK 300-in-1"
; 214 = "Super Gun 20-in-1" multicart

; 215 = Sugar Softec MMC3 clone with scrambling
; 215.0 = UNIF "UNL-8237"
; 215.1 = UNIF "UNL-8237A"

; 216 = "certain games in Russian, including Bonza and Videopoker Bonza as well as Magic Jewelry II by RCM Group"
; 217 = "500-in-1" and "2000-in-1" multicarts
; 218 = Single Chip Cart/Magic Floor
; 219 = Ka Sheng A9461 (MMC3 clone)
; 220 = FCEUX debugging mapper
; 221 = NTDEC N625092 multicarts (UNIF "BMC-N625092")
; 224 = Jncota KT-008
; 225 = ET-4310 and K-1010 multicarts
; 228 = Active Enterprises ("Action 52", "Cheetahmen II")
; 229 = "BMC 31-IN-1"
; 230 = "22-in-1" reset-based multicart
; 231 = "20-in-1" multicart
; 232 = Codemasters Quattro multicarts
; 234 = "Maxi 15" multicart
; 235 = "Golden Game" 150 in 1
; 236 = Realtec {8031 and 8155}, 8099, and 8106
; 237 = "Teletubbies 420-in-1 multicart"
; 238 = Contra Fighter
; 243 = Sachen SA-020A
; 244 = "Decathlon" by C&E
; 245 = Waixing F003 (MMC3 clone)
; 246 = G0151-1
; 250 = Nitra ("Time Diver Avenger", "Queen Bee V")

; 256 = VR Technology OneBus (UNIF names "UNL-OneBus", "BMC-OneBus", "UNL-DANCE")
; todo: various submappers

; 257 = [tentative] UNIF "PEC-586"
; 258 = [tentative] UNIF "158B"
; 259 = [tentative] UNIF "F-15" (MMC3 multicart)
; 260 = HP10xx/HP20xx multicarts (UNIF "BMC-HPxx", "BMC-HP2018-A")
; 261 = 810544-C-A1, NTDEC 2746 (UNIF "BMC-810544-C-A1")
; 262 = Sachen "Street Heroes" (UNIF "UNL-SHERO")
; 263 = Rex Soft MMC3 clone (UNIF "UNL-KOF97")
; 264 = Yoko/Cony (UNIF "UNL-YOKO")
; 265 = UNIF "BMC-T-262"
; 266 = "City Fighter IV" (UNIF "UNL-CITYFIGHT")
; 267 = 8-in-1 JY-119 multicart (MMC3 clone)

; 268 = AA6023 ASIC (SMD132/SMD133) (MMC3 clone)
; todo: submapper situation is tricky

; 269 = (MMC3 clone)

; 270 = OneBus multicart variant
; todo: submappers

; 271 = TXC 4-in-1 multicart (MGC-026) (UNIF "BMC-22026")
; 274 = RCM Group "Cartridge Story" multicarts (UNIF "BMC-80013-B")
; 283 = "Block Family 6-in-1/7-in-1 multicarts" (UNIF "BMC-GS-2004", "BMC-GS-2013")
; 284 = UNIF "UNL-DRIPGAME"

; 285 = A65AS and JY-066 multicarts
; todo: submappers

; 286 = Benshieng multicarts (UNIF "BMC-BS-5")
; 287 = 411120-C and 811120-C multicarts (MMC3 clone) (UNIF "BMC-411120-C", "BMC-K-3088")
; 288 = GKCX1 21-in-1 multicarts
; 289 = UNIF "BMC-60311C"
; 290 = Asder 20-in-1 multicart (BMC-NTD-03)
; 291 = Kasheng 2-in-1 multicarts (MMC3 clone)
; 292 = "Dragon Fighter" (Flying Star), PCB "BMW8544" (UNIF "UNL-DRAGONFIGHTER")
; 293 = NewStar 12-in-1 and 76-in-1 multicarts
; 294 = 63-1601 multicart PCB
; 295 = JY Company multicarts (UNIF "BMC-13in1JY110")
; 296 = "FC Pocket RS-20" and "dreamGEAR My Arcade Gamer V" (VT3x hardware)
; 297 = TXC 01-22110-000
; 298 = UNIF "UNL-TF1201"
; 299 = TXC 6-in-1 multicart (UNIF "BMC-11160")
; 300 = Golden 190-in-1 multicart (UNIF "BMC-190in1")
; 302 = Kaiser (UNIF "UNL-KS7057")
; 303 = Kaiser (UNIF "UNL-KS7017")
; 305 = Kaiser (UNIF "KS7031")
; 306 = Kaiser (UNIF "UNL-KS7016")
; 307 = Kaiser (UNIF "UNL-KS7037")
; 308 = UNIF "UNL-TH2131-1"
; 309 = Whirlwind Manu (UNIF "UNL-LH51")
; 310 = K-1053 ("New World Multi" multicart)
; 312 = Kaiser (UNIF "UNL-KS7013B")

; 313 = reset-based MMC3 multicarts (UNIF "BMC-RESET-TXROM")
; todo: submappers

; 314 = UNIF "BMC-64in1NoRepeat"
; 315 = UNIF "BMC-830134C"
; 319 = HP-898F and KD-7/9-E boards (UNIF "BMC-HP898F")
; 320 = Super HiK 6-in-1 A-030 multicart (UNIF "BMC-830425C-4391T")
; 321 = 820310 MMC3-based multicart (UNIF "BMC-820310-C")
; 322 = 35-in-1 (K-3033) multicart (UNIF "BMC-K-3033")
; 323 = Farid's homebrew 8-in-1 SLROM multicart (MMC3 clone) (UNIF "FARID_SLROM_8-IN-1")
; 324 = Farid's homebrew 8-in-1 UNROM multicart (UNIF "FARID_UNROM_8-IN-1")
; 325 = "Super Mali Splash Bomb" (MMC3 clone) (UNIF "UNL-MALISB")
; 327 = 6-in-1 multicart (UNIF "BMC-10-24-C-A1")
; 328 = Test Ver. 1.01 Dlya Proverki TV Pristavok test cartridge (UNIF "UNL-RT-01")
; 329 = "Education Computer 2000" (UNIF "UNL-EDU2000")
; 331 = 7-in-1 (NS03) multicart (UNIF "BMC-12-IN-1")
; 332 = Super 40-in-1 and Super 500-in-1 multicarts (UNIF "BMC-WS")
; 333 = New Star Super 8-in-1 multicart (MMC3 clone) (UNIF "BMC-8-IN-1", "BMC-NEWSTAR-GRM070-8IN1")
; 334 = 5/20-in-1 1993 Copyright multicart
; 335 = 10-in-1 multicart (UNIF "BMC-CTC-09")
; 336 = UNIF "BMC-K-3046"
; 337 = UNIF "BMC-CTC-12IN1"
; 338 = UNIF "BMC-SA005-A"
; 340 = UNIF "BMC-K-3036"
; 341 = UNIF "BMC-TJ-03"
; 342 = COOLGIRL
; 343 = "a certain reset-based 4-in-1 pirate multicart"
; 344 = UNIF "BMC-GN-26"
; 345 = New Star 6-in-1 Game Cartridge multicart (UNIF "BMC-L6IN1")
; 346 = Kaiser (UNIF "UNL-KS7012")
; 347 = Kaiser (UNIF "UNL-KS7030")
; 348 = (UNIF "BMC-830118C")
; 349 = UNIF "BMC-G-146"
; 350 = UNIF "BMC-891227"
; 351 = Techline XB-xxx multicarts
; 355 = UNIF "3D-BLOCK"
; 356 = J.Y. Company 7-in-1 Rockman (JY-208) multicart
; 357 = Bit Corp 4-in-1 multicart with dip switches
; 359 = UNIF "BMC-SB-5013"
; 360 = Bit Corp 31-in-1 multicart with dip switches
; 365 = Asder PC-95 educational computer
; 369 = UNIF "BMC-N49C-300"
; 370 = F600 board (MMC3 clone)
; 385 = NTDEC 2779
; 386 = J.Y. Company YY860729C
; 389 = Caltron 9-in-1 multicart
; 396 = UNIF "BMC-830752C"
; 399 = Star Versus
; 405 = UMC UM6578
; 409 = retroUSB DPCMcart
; 413 = Super Russian Roulette
