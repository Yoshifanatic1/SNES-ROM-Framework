
macro GAMEX_GameSpecificAssemblySettings()
	!ROM_GAMEX_V1 = $0001							;\ These defines assign each ROM version with a different bit so version difference checks will work. Do not touch them!
	!ROM_GAMEX_V2 = $0002							;/

	%SetROMToAssembleForHack(GAMEX_V2, !ROMID)
endmacro

macro GAMEX_LoadGameSpecificMainSNESFiles()
	incsrc ../SPC700/ARAMPtrs_GAMEX.asm
	incsrc ../Misc_Defines_GAMEX.asm
	incsrc ../RAM_Map_GAMEX.asm
	incsrc ../Routine_Macros_GAMEX.asm
	incsrc ../SNES_Macros_GAMEX.asm
	%LoadExtraRAMFile("SRAM_Map_GAMEX.asm", !GameID, GAMEX)
endmacro

macro GAMEX_LoadGameSpecificMainSPC700Files()
	incsrc ../SPC700/ARAM_Map_GAMEX.asm
	incsrc ../Misc_Defines_GAMEX.asm
	incsrc ../SPC700/SPC700_Routine_Macros_GAMEX.asm
	incsrc ../SPC700/SPC700_Macros_GAMEX.asm
endmacro

macro GAMEX_LoadGameSpecificMainExtraHardwareFiles()
endmacro

macro GAMEX_LoadGameSpecificMSU1Files()
endmacro

macro GAMEX_GlobalAssemblySettings()
	!Define_Global_ApplyAsarPatches = !FALSE
	!Define_Global_ApplyDefaultPatches = !TRUE
	!Define_Global_InsertRATSTags = !TRUE
	!Define_Global_IgnoreCodeAlignments = !FALSE
	!Define_Global_IgnoreOriginalFreespace = !FALSE
	!Define_Global_CompatibleControllers = !Controller_StandardJoypad
	!Define_Global_DisableROMMirroring = !FALSE
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_FixIncorrectChecksumHack = !FALSE
	!Define_Global_ROMFrameworkVer = 1
	!Define_Global_ROMFrameworkSubVer = 4
	!Define_Global_ROMFrameworkSubSubVer = 0
	!Define_Global_AsarChecksum = $0000
	!Define_Global_LicenseeName = "N/A"
	!Define_Global_DeveloperName = "Yoshifanatic"
	!Define_Global_ReleaseDate = "N/A"
	!Define_Global_BaseROMMD5Hash = "N/A"

	!Define_Global_MakerCode = "00"
	!Define_Global_GameCode = "xxxx"
	!Define_Global_ReservedSpace = $00,$00,$00,$00,$00,$00
	!Define_Global_ExpansionFlashSize = !ExpansionMemorySize_0KB
	!Define_Global_ExpansionRAMSize = !ExpansionMemorySize_0KB
	!Define_Global_IsSpecialVersion = $00
	!Define_Global_InternalName = "GAME X TITLE"
	!Define_Global_ROMLayout = !ROMLayout_LoROM
	!Define_Global_ROMType = !ROMType_ROM_RAM_SRAM
	!Define_Global_CustomChip = !Chip_None
	!Define_Global_ROMSize1 = !ROMSize_256KB
	!Define_Global_ROMSize2 = !ROMSize_0KB
	!Define_Global_SRAMSize = !SRAMSize_2KB
	!Define_Global_Region = !Region_NorthAmerica
	!Define_Global_LicenseeID = $00
	!Define_Global_VersionNumber = $01
	!Define_Global_ChecksumCompliment = !Define_Global_Checksum^$FFFF
	!Define_Global_Checksum = $3B9A
	!UnusedNativeModeVector1 = $FFFF
	!UnusedNativeModeVector2 = $FFFF
	!NativeModeCOPVector = !RAM_GAMEX_Global_BRKRoutineVector
	!NativeModeBRKVector = !RAM_GAMEX_Global_BRKRoutineVector
	!NativeModeAbortVector = !RAM_GAMEX_Global_BRKRoutineVector
	!NativeModeNMIVector = GAMEX_VBlankRoutine_Main
	!NativeModeResetVector = GAMEX_InitAndMainLoop_Main
	!NativeModeIRQVector = GAMEX_IRQRoutine_Main
	!UnusedEmulationModeVector1 = $FFFF
	!UnusedEmulationModeVector2 = $FFFF
	!EmulationModeCOPVector = !RAM_GAMEX_Global_BRKRoutineVector
	!EmulationModeBRKVector = !RAM_GAMEX_Global_BRKRoutineVector
	!EmulationModeAbortVector = !RAM_GAMEX_Global_BRKRoutineVector
	!EmulationModeNMIVector = GAMEX_VBlankRoutine_Main
	!EmulationModeResetVector = GAMEX_InitAndMainLoop_Main
	!EmulationModeIRQVector = GAMEX_IRQRoutine_Main
endmacro

macro GAMEX_LoadROMMap()
%BANK_START(!BANK_00)
	%ROUTINE_GAMEX_InitAndMainLoop(NULLROM)
RAMBufferedRoutinesStart:
	%ROUTINE_GAMEX_VBlankRoutine(NULLROM)
	%ROUTINE_GAMEX_IRQRoutine(NULLROM)
	%ROUTINE_GAMEX_BRKRoutine(NULLROM)
if !Define_Global_CustomChip == !Chip_SA1
	%ROUTINE_GAMEX_BeginSA1Processing(NULLROM)
elseif !Define_Global_CustomChip == !Chip_SuperFX1
	%ROUTINE_GAMEX_BeginSuperFXProcessing(NULLROM)
elseif !Define_Global_CustomChip == !Chip_SuperFX2
	%ROUTINE_GAMEX_BeginSuperFXProcessing(NULLROM)
endif
RAMBufferedRoutinesEnd:
	%ROUTINE_GAMEX_UploadDataToSPC700(NULLROM)
	%ROUTINE_GAMEX_InitializeHardwareRegisters(NULLROM)
	%ROUTINE_GAMEX_GameMode00_InitializeSplashScreen(NULLROM)
	%ROUTINE_GAMEX_GameMode01_FadeIntoSplashScreen(NULLROM)
	%ROUTINE_GAMEX_GameMode02_DisplaySplashScreen(NULLROM)
	%ROUTINE_GAMEX_CheckWhichControllersArePluggedIn(NULLROM)
	%ROUTINE_GAMEX_PollJoypadInputs(NULLROM)
	%ROUTINE_GAMEX_ProcessDMAUploads(NULLROM)
	%DATATABLE_GAMEX_BasicFontGFX(NULLROM)
%BANK_END(!BANK_00)

%BANK_START(!BANK_01)
%BANK_END(!BANK_01)

%BANK_START(!BANK_02)
%BANK_END(!BANK_02)

%BANK_START(!BANK_03)
%BANK_END(!BANK_03)

%BANK_START(!BANK_04)
%BANK_END(!BANK_04)

%BANK_START(!BANK_05)
%BANK_END(!BANK_05)

%BANK_START(!BANK_06)
%BANK_END(!BANK_06)

%BANK_START(!BANK_07)
%BANK_END(!BANK_07)
endmacro

;#############################################################################################################
;#############################################################################################################

macro GAMEX_LoadSPC700ROMMap()
%SPC700RoutinePointer(GAMEX_SPC700_Engine_Main, GAMEX_SPC700Block0Start, GAMEX_SPC700Block0End)
%SPC700RoutinePointer(GAMEX_GlobalSampleBank_Ptrs, GAMEX_SPC700Block1Start, GAMEX_SPC700Block1End)

GAMEX_SPC700Block0Start:
	%SPC700_GAMEX_SPC700_Engine($0500)
GAMEX_SPC700Block0End:
GAMEX_SPC700Block1Start:
	%SPC700_GAMEX_GlobalSampleBank($0400)
GAMEX_SPC700Block1End:
endmacro

;#############################################################################################################
;#############################################################################################################

macro GAMEX_LoadSuperFXROMMap()
endmacro

;#############################################################################################################
;#############################################################################################################

macro GAMEX_LoadMSU1ROMMap()
endmacro

;#############################################################################################################
;#############################################################################################################
