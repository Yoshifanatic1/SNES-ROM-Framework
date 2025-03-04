includeonce

;---------------------------------------------------------------------------

macro StartOfROM(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
incsrc "../Global/HardwareRegisters/SNES.asm"
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GameSpecificAssemblySettings()
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%InitializeROMSettings(!GameID)
%<GameID>_LoadGameSpecificMainSNESFiles()
reset bytes
%<GameID>_LoadROMMap()
incsrc "../<MainFolder>/Custom/Asar_Patches_<GameID>.asm"
reset bytes
endmacro

;---------------------------------------------------------------------------

macro SNES_Header(Address)
if !NumOfInsertedSNESHeader != $00
	!SNESHeaderLoc = <Address>
endif

if !Define_Global_CartridgeHeaderVersion == $00
	!TEMP #= $10
else
	!TEMP #= $00
endif

SNES_Header_!NumOfInsertedSNESHeader:
if !ROMBankSplitFlag == !TRUE
	assert pc() <= ((!SNESHeaderLoc+!TEMP)|!FastROMAddressOffset)^!HiROMAddressOffset
else
	assert pc() <= (!SNESHeaderLoc+!TEMP)|!FastROMAddressOffset|!HiROMAddressOffset
endif

if !Define_Global_CartridgeHeaderVersion == $02
org (!SNESHeaderLoc)|!FastROMAddressOffset|!HiROMAddressOffset
.ProgramMakerCode:	db "!Define_Global_MakerCode"
padbyte $20
pad (!SNESHeaderLoc+$02)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$02)|!FastROMAddressOffset|!HiROMAddressOffset
.ProgramGameCode:	db "!Define_Global_GameCode"
padbyte $20
pad (!SNESHeaderLoc+$06)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$06)|!FastROMAddressOffset|!HiROMAddressOffset
.ReservedSpace:		db !Define_Global_ReservedSpace
padbyte $00
pad (!SNESHeaderLoc+$0C)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$0C)|!FastROMAddressOffset|!HiROMAddressOffset
.ExpandedFlashSize:	db !Define_Global_ExpansionFlashSize 
.ExpandedRAMSize:	db !Define_Global_ExpansionRAMSize 
.ProgramSpecialVersion:	db !Define_Global_IsSpecialVersion
.ChipSubType:		db !ExtraChipHeaderByte
elseif !Define_Global_CartridgeHeaderVersion == $01
.ReservedSpace:		db !Define_Global_ReservedSpace
.ChipSubType:		db !ExtraChipHeaderByte
else
org (!SNESHeaderLoc+$10)|!FastROMAddressOffset|!HiROMAddressOffset
endif
.ProgramTitle:		db "!Define_Global_InternalName"
padbyte $20
pad (!SNESHeaderLoc+$25)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$25)|!FastROMAddressOffset|!HiROMAddressOffset
if !Define_Global_CartridgeHeaderVersion == $01
org (!SNESHeaderLoc+$24)|!FastROMAddressOffset|!HiROMAddressOffset
db $00
endif
.ProgramLayout:		db !ROMLayoutHeaderByte
.ProgramContents:	db !Define_Global_ROMType
!TEMP #= !ROMSize
!ROMSize = 0
while !TEMP != 0
	!TEMP #= !TEMP>>1
	!ROMSize #= !ROMSize+1
endwhile
.ProgramSize:		db !ROMSize
.ProgramMemorySize:	db !Define_Global_SRAMSize
.ProgramRegion:		db !Define_Global_Region
if !Define_Global_CartridgeHeaderVersion == $02
			db $33
else
.ProgramLicensee:	db !Define_Global_LicenseeID
endif
.ProgramVersion:	db !Define_Global_VersionNumber
.ProgramComplement:	dw !Define_Global_ChecksumCompliment
.ProgramChecksum:	dw !Define_Global_Checksum
.Unused1:		dw !UnusedNativeModeVector1
.Unused2:		dw !UnusedNativeModeVector2
.NativeModeCOP:		dw !NativeModeCOPVector
.NativeModeBRK:		dw !NativeModeBRKVector
.NativeModeABORT:	dw !NativeModeAbortVector
.NativeModeNMI:		dw !NativeModeNMIVector
.NativeModeRESET:	dw !NativeModeResetVector
.NativeModeIRQ:		dw !NativeModeIRQVector
.Unused3:		dw !UnusedEmulationModeVector1
.Unused4:		dw !UnusedEmulationModeVector2
.EmulationModeCOP:	dw !EmulationModeCOPVector
.EmulationModeBRK:	dw !EmulationModeBRKVector
.EmulationModeABORT:	dw !EmulationModeAbortVector
.EmulationModeNMI:	dw !EmulationModeNMIVector
.EmulationModeRESET:	dw !EmulationModeResetVector
.EmulationModeIRQ:	dw !EmulationModeIRQVector
!NumOfInsertedSNESHeader #= !NumOfInsertedSNESHeader+$01
if !ROMBankSplitFlag == !TRUE
org (((!SNESHeaderLoc&$FF0000)+$10000)|!FastROMAddressOffset)^!HiROMAddressOffset
endif
endmacro

;---------------------------------------------------------------------------

macro InitializeROM(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
;namespace nested on

print "Yoshifanatic's SNES ROM Framework, Version !FrameworkVer.!FrameworkSubVer.!FrameworkSubSubVer"
print ""

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GameSpecificAssemblySettings()
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%InitializeROMSettings(!GameID)
%<GameID>_LoadGameSpecificMainSNESFiles()

norom
org !MaxROMSize-$01
	db $00

%PrintHeaderInformation(!GameID, !SRAMType)
endmacro

;---------------------------------------------------------------------------

macro InitializeSPCROM(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wspc700_assuming_8_bit
warnings disable Wmapper_already_set
arch spc700
incsrc "../Global/HardwareRegisters/SPC700.asm"
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GameSpecificAssemblySettings()
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%<GameID>_LoadGameSpecificMainSPC700Files()

norom
org $000000
reset bytes
check bankcross off
%<GameID>_LoadSPC700ROMMap()
endmacro

;---------------------------------------------------------------------------

macro InitializeSuperFXROM(CurrentGameID, GameID, ROMID, MainFolder)
org $008000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
arch superfx
;namespace nested on

incsrc "HardwareRegisters/SuperFX_(SuperFX).asm"
incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GameSpecificAssemblySettings()
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%GetMemoryMap()
%<GameID>_LoadGameSpecificMainExtraHardwareFiles()

norom
org $000000
reset bytes
check bankcross off
%<GameID>_LoadSuperFXROMMap()
endmacro

;---------------------------------------------------------------------------

macro FinalizeROM(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wxkas_patch
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GameSpecificAssemblySettings()
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%GetROMSize()
%GetChipData()
%GetMemoryMap()
%<GameID>_LoadGameSpecificMainSNESFiles()
reset bytes
incsrc "../<MainFolder>/Custom/Asar_Patches_<CurrentGameID>.asm"
if !Define_Global_ApplyDefaultPatches == !TRUE
	%<CurrentGameID>_HandleDefaultPatches()
endif
if !Define_Global_ApplyAsarPatches == !TRUE
	%<CurrentGameID>_ApplyPatchesPostAssembly()
endif
endmacro

;---------------------------------------------------------------------------

macro DisplayFinalChecksum(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%GetROMSize()
%GetMemoryMap()
%GetChipData()

if canread2($00FFDE) == !TRUE
	print "Original Checksum: !Define_Global_Checksum"
	if !Define_Global_FixIncorrectChecksumHack == !TRUE
		if read2($00FFDE) == !Define_Global_AsarChecksum
			print "Checksum: $",hex(read2($00FFDE), 4)," (Corrected to !Define_Global_Checksum)"
			org $00FFDC
			dw !Define_Global_ChecksumCompliment,!Define_Global_Checksum
		else
			print "Checksum: $",hex(read2($00FFDE), 4)
		endif
	else
		print "Checksum: $",hex(read2($00FFDE), 4)
	endif
else
	error "The checksum can't be read, because this ROM is too small or something went horribly wrong during assembly!"
endif
	%DisplaySettingMessages()
endmacro

;---------------------------------------------------------------------------

macro GetFirmwareFile(CurrentGameID, GameID, ROMID, MainFolder)
org $008000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%GetChipData()
db "!Firmware"
endmacro

;---------------------------------------------------------------------------

macro InitializeMSU1ROM(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
incsrc "../Global/HardwareRegisters/SNES.asm"
incsrc "../Global/HardwareRegisters/MSU1.asm"
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GameSpecificAssemblySettings()
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%<GameID>_LoadGameSpecificMainMSU1Files()

norom
org $000000
reset bytes
check bankcross off
%<GameID>_LoadMSU1ROMMap()
endmacro

;---------------------------------------------------------------------------

macro GenerateSaveFile(CurrentGameID, GameID, ROMID, MainFolder)
org $000000
warnings disable Wfreespace_leaked
warnings disable Wxkas_patch
warnings disable Wmapper_already_set
incsrc "../Global/HardwareRegisters/SNES.asm"
;namespace nested on

incsrc "../<MainFolder>/RomMap/ROM_Map_!ROMID.asm"
%<GameID>_GlobalAssemblySettings()
!Define_Global_ROMSize = !Define_Global_ROMSize1+!Define_Global_ROMSize2
%<GameID>_GameSpecificAssemblySettings()
reset bytes
if !Define_Global_CartridgeHeaderVersion == $02
	if !Define_Global_SRAMSize|!Define_Global_ExpansionRAMSize|!Define_Global_ExpansionFlashSize != !SRAMSize_0KB 
		incsrc "!PathToFile"
	else
		warn "This game has no extra RAM. Set one of the RAM size defines to a non-zero value if you want to generate a save file."
	endif
else
	if !Define_Global_SRAMSize != !SRAMSize_0KB 
		incsrc "!PathToFile"
	else
		warn "This game has no SRAM/BW_RAM. Set \!Define_Global_SRAMSize to a non-zero value if you want to generate a save file."
	endif
endif
reset bytes
endmacro

;---------------------------------------------------------------------------

macro FREE_BYTES(Address, bytes, fillbyte)
if !Define_Global_IgnoreOriginalFreespace == !FALSE
%InsertMacroAtXPosition(<Address>)
;print "<bytes> bytes of freespace located at: $",pc
	fillbyte <fillbyte> : fill <bytes>
endif
endmacro

;---------------------------------------------------------------------------

; Note: To use this macro, put it somewhere that will execute after everything else, like at the end of a ROM Map file for the ROM you're assembling. Otherwise, asar will throw errors.

macro PrintLabelLocation(Label)
pushpc
org <Label>
	print "(!ROMID) '<Label>' label located at SNES address $",pc
pullpc
endmacro

;---------------------------------------------------------------------------

macro InsertVersionExclusiveFile(Address, Command, Path, ROMID, Size)
%InsertMacroAtXPosition(<Address>)
<Command> "<Path><ROMID>"<Size>
endmacro

;---------------------------------------------------------------------------

macro RATSTagStart(StartLabel, EndLabel)
if !Define_Global_InsertRATSTags == !TRUE
assert !InRATSBlock == !FALSE, "This RATS tag is nested inside another RATS tag!"
;assert <EndLabel>-<StartLabel> <= $010000, "A RATS tag is being set to protect more than $010000 bytes, which is not allowed!"
;assert <EndLabel>-<StartLabel> != $000000, "A RATS tag is being set to protect 0 bytes, which is not allowed!"
	!InRATSBlock = !TRUE
print "RATS Tag inserted at $",pc," protecting $",hex(<EndLabel>-<StartLabel>)," bytes."
	db "STAR"
	dw <EndLabel>-<StartLabel>-$01
	dw (<EndLabel>-<StartLabel>-$01)^$FFFF
<StartLabel>:
endif
endmacro

;---------------------------------------------------------------------------

macro RATSTagEnd(EndLabel)
if !Define_Global_InsertRATSTags == !TRUE
assert !InRATSBlock == !TRUE, "You must put a RATSTagStart macro before calling RATSTagEnd!"
<EndLabel>:
	!InRATSBlock = !FALSE
endif
endmacro

;---------------------------------------------------------------------------

macro InitializeROMSettings(GameID)
!SNESHeaderBank = !BANK_00

%GetROMSize()
%GetMemoryMap()
%GetChipData()

if !Define_Global_SRAMSize == !SRAMSize_0KB
	!SRAMBankEnd = $000000
	!SRAMBankCount = $00
elseif !Define_Global_SRAMSize == !SRAMSize_2KB
	!SRAMBankEnd = $000800
	!SRAMBankCount = $01
elseif !Define_Global_SRAMSize == !SRAMSize_4KB
	!SRAMBankEnd = $001000
	!SRAMBankCount = $01
elseif !Define_Global_SRAMSize == !SRAMSize_8KB
	!SRAMBankEnd = $002000
	!SRAMBankCount = $01
elseif !Define_Global_SRAMSize == !SRAMSize_16KB
	!SRAMBankEnd = $004000
	!SRAMBankCount = $02
elseif !Define_Global_SRAMSize == !SRAMSize_32KB
	!SRAMBankEnd = $008000
	!SRAMBankCount = $04
elseif !Define_Global_SRAMSize == !SRAMSize_64KB
	!SRAMBankEnd = $010000
	!SRAMBankCount = $08
elseif !Define_Global_SRAMSize == !SRAMSize_128KB
	!SRAMBankEnd = $010000
	!SRAMBankCount = $10
else
	!SRAMBankEnd = $010000
	!SRAMBankCount = $20
endif
if !Define_Global_SRAMSize > !SRAMSize_8KB
	if !SRAMBankSize == $2000
		!SRAMBankEnd = $002000
	endif
elseif !Define_Global_SRAMSize == !SRAMSize_64KB
	if !SRAMBankSize == $8000
		!SRAMBankEnd = $008000
		!SRAMBankCount = !SRAMBankCount/$02
	endif
else
	!SRAMBankCount = !SRAMBankCount/$04
endif

if !Define_Global_CustomChip&$80 == !Chip_MSU1
	incsrc "../Global/HardwareRegisters/MSU1.asm"
endif

%GetController()
endmacro

; Note: ROMType bits for the different chips.
;!Chip_DSP1A = $00
;!Chip_DSP1B = $00
;!Chip_SuperFX1 = $10
;!Chip_SuperFX2 = $10
;!Chip_OBC1 = $20
;!Chip_SA1 = $30
;!Chip_Other = $E0
;!Chip_Custom = $F0

;---------------------------------------------------------------------------

macro PrintHeaderInformation(GameID, SRAMType)
	!TEMP = ""

print "Internal Name: !Define_Global_InternalName"

%GetROMSize()
print "ROM Size: ",dec(!MaxROMSize/!TEMP2)," !TEMP"
%GetMemoryMap()
print "ROM Layout: !MemoryMapName"

if !Define_Global_ROMType == !ROMType_SatellaviewGame
	print "ROM Contents: ROM, RAM, PSRAM"
else
	%GetChipData()
	if !Define_Global_ROMType&$0F == !ROMType_ROM
		!TEMP = "ROM"
	elseif !Define_Global_ROMType&$0F == !ROMType_ROM_RAM
		!TEMP = "ROM, RAM"
	elseif !Define_Global_ROMType&$0F == !ROMType_ROM_RAM_SRAM
		!TEMP = "ROM, RAM, !SRAMType"
	elseif !Define_Global_ROMType&$0F == !ROMType_ROM_Chip
		!TEMP = "ROM, Chip"
	elseif !Define_Global_ROMType&$0F == !ROMType_ROM_RAM_Chip
		!TEMP = "ROM, RAM, Chip"
	elseif !Define_Global_ROMType&$0F == !ROMType_ROM_RAM_SRAM_Chip
		!TEMP = "ROM, RAM, !SRAMType, Chip"
	elseif !Define_Global_ROMType&$0F == !ROMType_ROM_SRAM_Chip
		!TEMP = "ROM, !SRAMType, Chip"
	else
		!TEMP = "Unsupported/Invalid ROM contents combination"
	endif
	print "ROM Contents: !TEMP"
	print "Extra Hardware: !ChipName"
endif

if !Define_Global_<SRAMType>Size == !SRAMSize_0KB
	!TEMP = "0 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_2KB
	!TEMP = "2 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_4KB
	!TEMP = "4 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_8KB
	!TEMP = "8 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_16KB
	!TEMP = "16 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_32KB
	!TEMP = "32 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_64KB
	!TEMP = "64 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_128KB
	!TEMP = "128 KB"
elseif !Define_Global_<SRAMType>Size == !SRAMSize_256KB
	!TEMP = "256 KB"
else
	!TEMP = "Unsupported/Invalid !SRAMType Size"
endif
print "!SRAMType Size: !TEMP"

if !Define_Global_Region == !Region_Japan
	!TEMP = "Japan"
elseif !Define_Global_Region == !Region_NorthAmerica
	!TEMP = "North America"
elseif !Define_Global_Region == !Region_Europe
	!TEMP = "Europe"
elseif !Define_Global_Region == !Region_Scandinavia
	!TEMP = "Scandinavia"
elseif !Define_Global_Region == !Region_Finland
	!TEMP = "Finland"
elseif !Define_Global_Region == !Region_Denmark
	!TEMP = "Denmark"
elseif !Define_Global_Region == !Region_French
	!TEMP = "French"
elseif !Define_Global_Region == !Region_Holland
	!TEMP = "Holland"
elseif !Define_Global_Region == !Region_Spanish
	!TEMP = "Spanish"
elseif !Define_Global_Region == !Region_German
	!TEMP = "German"
elseif !Define_Global_Region == !Region_Italian
	!TEMP = "Italian"
elseif !Define_Global_Region == !Region_Chinese
	!TEMP = "Chinese"
elseif !Define_Global_Region == !Region_Indonesia
	!TEMP = "Indonesia"
elseif !Define_Global_Region == !Region_Korean
	!TEMP = "Korean"
elseif !Define_Global_Region == !Region_Common
	!TEMP = "Common"
elseif !Define_Global_Region == !Region_Canada
	!TEMP = "Canada"
elseif !Define_Global_Region == !Region_Brazil
	!TEMP = "Brazil"
elseif !Define_Global_Region == !Region_Australia
	!TEMP = "Australia"
elseif !Define_Global_Region == !Region_Other1
	!TEMP = "Other1"
elseif !Define_Global_Region == !Region_Other2
	!TEMP = "Other2"
elseif !Define_Global_Region == !Region_Other3
	!TEMP = "Other3"
else
	!TEMP = "Unsupported/Invalid region"
endif
print "Distribution Region: !TEMP"

print "Licensee: !Define_Global_LicenseeName"
print "Developer: !Define_Global_DeveloperName"
print "Base ROM MD5 Hash: !Define_Global_BaseROMMD5Hash"
print "Original Release Date: !Define_Global_ReleaseDate"

%GetController()
print "Compatible Controllers: !TEMP"

print "ROM Version Number: !Define_Global_VersionNumber"

if !Define_Global_ApplyAsarPatches == !TRUE
	!TEMP = "Yes"
else
	!TEMP = "No"
endif
print "Apply Custom Asar Patches: !TEMP"

if !Define_Global_ApplyDefaultPatches == !TRUE
	!TEMP = "Yes"
else
	!TEMP = "No"
endif
print "Apply Default Patches: !TEMP"

if !Define_Global_IgnoreCodeAlignments == !TRUE
	!TEMP = "Yes"
else
	!TEMP = "No"
endif
print "Code Alignment Disabled: !TEMP"

print ""
endmacro

;---------------------------------------------------------------------------

macro GetController()
!TEMP = ""
!TEMP2 = !TRUE
if !Define_Global_CompatibleControllers == !Controller_None
	!TEMP = "None"
else
	if !Define_Global_CompatibleControllers&$000001 == !Controller_StandardJoypad
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Joypad")
		incsrc "../Global/Controllers/StandardJoypad.asm"
	endif
	if !Define_Global_CompatibleControllers&$000002 == !Controller_Mouse
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Mouse")
		incsrc "../Global/Controllers/Mouse.asm"
	endif
	if !Define_Global_CompatibleControllers&$000004 == !Controller_SuperScope
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Super Scope")
		incsrc "../Global/Controllers/SuperScope.asm"
	endif
	if !Define_Global_CompatibleControllers&$000008 == !Controller_MultiTap
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Multi-Tap")
		incsrc "../Global/Controllers/MultiTap.asm"
	endif
	if !Define_Global_CompatibleControllers&$000010 == !Controller_KonamiJustifierLightgun
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Konami Justifier")
		incsrc "../Global/Controllers/KonamiJustifierLightgun.asm"
	endif
	if !Define_Global_CompatibleControllers&$000020 == !Controller_MACSLightgun
		%AppendListOfItemsToPrint(TEMP2, TEMP, "M.A.C.S")
		incsrc "../Global/Controllers/MACSLightgun.asm"
	endif
	if !Define_Global_CompatibleControllers&$000040 == !Controller_TwinTap
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Twin Tap")
		incsrc "../Global/Controllers/TwinTap.asm"
	endif
	if !Define_Global_CompatibleControllers&$000080 == !Controller_MiraclePiano
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Miracle Piano")
		incsrc "../Global/Controllers/MiraclePiano.asm"
	endif
	if !Define_Global_CompatibleControllers&$000100 == !Controller_NTTDataPad
		%AppendListOfItemsToPrint(TEMP2, TEMP, "NTT Data Pad")
		incsrc "../Global/Controllers/NTTDataPad.asm"
	endif
	if !Define_Global_CompatibleControllers&$000200 == !Controller_XBandKeyboard
		%AppendListOfItemsToPrint(TEMP2, TEMP, "X-Band Keyboard")
		incsrc "../Global/Controllers/XBandKeyboard.asm"
	endif
	if !Define_Global_CompatibleControllers&$000400 == !Controller_MotionSensor
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Motion Sensor")
		incsrc "../Global/Controllers/MotionSensor.asm"
	endif
	if !Define_Global_CompatibleControllers&$000800 == !Controller_Laserbirdie
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Laserbirdie")
		incsrc "../Global/Controllers/MACSLightgun.asm"
	endif
	if !Define_Global_CompatibleControllers&$001000 == !Controller_ExertainmentBike
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Exertainment Exercise Bicycle")
		incsrc "../Global/Controllers/ExertainmentBike.asm"
	endif
	if !Define_Global_CompatibleControllers&$002000 == !Controller_Pachinko
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Pachinko")
		incsrc "../Global/Controllers/Pachinko.asm"
	endif
	if !Define_Global_CompatibleControllers&$004000 == !Controller_TurboFile
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Turbo File")
		incsrc "../Global/Controllers/TurboFile.asm"
	endif
	if !Define_Global_CompatibleControllers&$008000 == !Controller_BarcodeBattler
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Barcode Battler")
		incsrc "../Global/Controllers/BarcodeBattler.asm"
	endif
	if !Define_Global_CompatibleControllers&$01000 == !Controller_SFCModem
		%AppendListOfItemsToPrint(TEMP2, TEMP, "SFC Modem")
		incsrc "../Global/Controllers/SFCModem.asm"
	endif
	if !Define_Global_CompatibleControllers&$020000 == !Controller_VoiceKun
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Voice-Kun")
		incsrc "../Global/Controllers/VoiceKun.asm"
	endif
	if !Define_Global_CompatibleControllers&$040000 == !Controller_Multiplayer5
		%AppendListOfItemsToPrint(TEMP2, TEMP, "Multiplayer 5")
		incsrc "../Global/Controllers/Multiplayer5.asm"
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro GetROMSize()
if !Define_Global_ROMSize < !ROMSize_32KB
	!ROMSize = $00
	!MaxROMSize = $00
	!TotalFreespace = $00
	!TEMP = "Bytes"
	!TEMP2 = 1
	!StartOfMirrorBanks = $00
	error "!Define_Global_ROMSize is an unsupported/invalid ROM size!"
elseif !Define_Global_ROMSize < !ROMSize_1MB
	!ROMSize = !Define_Global_ROMSize1
	!MaxROMSize = ((!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4)*$8000
	!TotalFreespace = $080000		; Note: Asar will automatically expand the ROM to 1MB if you insert a patch that uses freespace and the ROM size is less than 512 KB.
	!TEMP = "KB"
	!TEMP2 = 1024
	!StartOfMirrorBanks = (!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4
elseif !Define_Global_ROMSize <= !ROMSize_4MB
	!ROMSize = !Define_Global_ROMSize1
	!MaxROMSize = ((!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4)*$8000
	!TotalFreespace = (((!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4)*$8000)-$080000
	!TEMP = "MB"
	!TEMP2 = 1048576
	!StartOfMirrorBanks = (!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4
elseif !Define_Global_ROMSize <= (!ROMSize_8MB+!ROMSize_4MB)
	!ROMSize = !Define_Global_ROMSize1
	!MaxROMSize = ((!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4)*$8000
	!TotalFreespace = (((!Define_Global_ROMSize1+!Define_Global_ROMSize2)>>4)*$8000)-$080000
	!TEMP = "MB"
	!TEMP2 = 1048576
	!StartOfMirrorBanks = $00
else
	!ROMSize = $00
	!MaxROMSize = $00
	!TotalFreespace = $00
	!TEMP = "Bytes"
	!TEMP2 = 1
	!StartOfMirrorBanks = $00
	error "!Define_Global_ROMSize is an unsupported/invalid ROM size!"
endif
if !ROMSize != $00
	if !Define_Global_ROMSize2 != !ROMSize_0KB
		!ROMSize = !Define_Global_ROMSize1<<1
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro GetMemoryMap()
if !Define_Global_ROMSize > !ROMSize_4MB
	if !Define_Global_ROMLayout == !ROMLayout_LoROM
		incsrc "../Global/MemoryMap/ExLoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM
		incsrc "../Global/MemoryMap/ExHiROM_Memory_Map.asm"
		!StartOfMirrorBanks #= !StartOfMirrorBanks/$02
		!SNESHeaderBank = !BANK_40
	elseif !Define_Global_ROMLayout == !ROMLayout_SA1_LoROM
		incsrc "../Global/MemoryMap/SA1_LoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_SA1_HiROM
		incsrc "../Global/MemoryMap/SA1_LoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_SuperFXROM
		incsrc "../Global/MemoryMap/SuperFXROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_SDD1ROM
		incsrc "../Global/MemoryMap/SDD1ROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_LoROM_FastROM
		incsrc "../Global/MemoryMap/Fast_ExLoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
		incsrc "../Global/MemoryMap/Fast_ExHiROM_Memory_Map.asm"
		!SNESHeaderBank = !BANK_40
		!StartOfMirrorBanks #= !StartOfMirrorBanks/$02
	elseif !Define_Global_ROMLayout == !ROMLayout_SPC7110ROM
		incsrc "../Global/MemoryMap/SPC7110ROM_Memory_Map.asm"
		!StartOfMirrorBanks #= !StartOfMirrorBanks/$02
	elseif !Define_Global_ROMLayout == !ROMLayout_Satelliview
		incsrc "../Global/MemoryMap/Satelliview_Memory_Map.asm"	
	else
		incsrc "../Global/MemoryMap/NoROM_Memory_Map.asm"
	endif
else
	if !Define_Global_ROMLayout == !ROMLayout_LoROM
		incsrc "../Global/MemoryMap/LoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM
		incsrc "../Global/MemoryMap/HiROM_Memory_Map.asm"
		!StartOfMirrorBanks #= !StartOfMirrorBanks/$02
		!SNESHeaderBank = !BANK_40
	elseif !Define_Global_ROMLayout == !ROMLayout_SA1_LoROM
		incsrc "../Global/MemoryMap/SA1_LoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_SA1_HiROM
		incsrc "../Global/MemoryMap/SA1_HiROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_SuperFXROM
		incsrc "../Global/MemoryMap/SuperFXROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_SDD1ROM
		incsrc "../Global/MemoryMap/SDD1ROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_LoROM_FastROM
		incsrc "../Global/MemoryMap/Fast_LoROM_Memory_Map.asm"
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
		incsrc "../Global/MemoryMap/Fast_HiROM_Memory_Map.asm"
		!SNESHeaderBank = !BANK_40
		!StartOfMirrorBanks #= !StartOfMirrorBanks/$02
	elseif !Define_Global_ROMLayout == !ROMLayout_SPC7110ROM
		incsrc "../Global/MemoryMap/SPC7110ROM_Memory_Map.asm"
		!StartOfMirrorBanks #= !StartOfMirrorBanks/$02
	else
		incsrc "../Global/MemoryMap/NoROM_Memory_Map.asm"
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro GetChipData()
!ExtraChipHeaderByte = $00
!SRAMType = "SRAM"
!Firmware = ""
if !Define_Global_ROMType == !ROMType_SatellaviewGame
	!Define_Global_ROMType #= !Define_Global_ROMType|$E0
	incsrc "../Global/HardwareRegisters/Satellaview.asm"
endif

if !Define_Global_CustomChip&$7F == !Chip_None
	!ChipName = "None"
	!Firmware = "NULL"
elseif !Define_Global_CustomChip&$7F == !Chip_DSP1
	incsrc "../Global/HardwareRegisters/DSP1.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_DSP1A
	incsrc "../Global/HardwareRegisters/DSP1.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_DSP1B
	incsrc "../Global/HardwareRegisters/DSP1.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_DSP2
	incsrc "../Global/HardwareRegisters/DSP2.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_DSP3
	incsrc "../Global/HardwareRegisters/DSP3.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_DSP4
	incsrc "../Global/HardwareRegisters/DSP4.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SA1
	!Define_Global_ROMType #= !Define_Global_ROMType|$30
	incsrc "../Global/HardwareRegisters/SA1.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SuperFX1
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$10
	!Define_Global_SRAMSize = !SRAMSize_0KB				; Note: SuperFX games use Expansion RAM, rather than SRAM.
	incsrc "../Global/HardwareRegisters/SuperFX_(SNES).asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SuperFX2
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$10
	!Define_Global_SRAMSize = !SRAMSize_0KB				; Note: SuperFX games use Expansion RAM, rather than SRAM.
	incsrc "../Global/HardwareRegisters/SuperFX_(SNES).asm"
elseif !Define_Global_CustomChip&$7F == !Chip_OBC1
	!Define_Global_ROMType #= !Define_Global_ROMType|$20
	incsrc "../Global/HardwareRegisters/OBC1.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SDD1
	!Define_Global_ROMType #= !Define_Global_ROMType|$40
	incsrc "../Global/HardwareRegisters/SDD1.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_Cx4
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$F0
	incsrc "../Global/HardwareRegisters/Cx4.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SPC7110
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$F0
	incsrc "../Global/HardwareRegisters/SPC7110.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_ST010
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$F0
	incsrc "../Global/HardwareRegisters/ST010.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_ST011
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$F0
	incsrc "../Global/HardwareRegisters/ST011.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_ST018
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$F0
	incsrc "../Global/HardwareRegisters/ST018.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SRTC
	!Define_Global_CartridgeHeaderVersion = $02
	!Define_Global_ROMType #= !Define_Global_ROMType|$50
	incsrc "../Global/HardwareRegisters/SRTC.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_SuperGameboy
	!Define_Global_ROMType #= !Define_Global_ROMType|$E0
	incsrc "../Global/HardwareRegisters/SuperGameboy.asm"
elseif !Define_Global_CustomChip&$7F == !Chip_Satellaview
	!Define_Global_ROMType #= !Define_Global_ROMType|$E0
	incsrc "../Global/HardwareRegisters/Satellaview.asm"
else
	!ChipName = "Unsupported/Invalid Chip"
	!Firmware = "NULL"
endif

if !Define_Global_CustomChip&$80 == !Chip_MSU1
	if !Define_Global_CustomChip&$7F == !Chip_None
		!ChipName = "MSU-1"
	else
		!ChipName += ", MSU-1"
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro DisplaySettingMessages()
if !Define_Global_ROMType == !ROMType_SatellaviewGame
	assert !Define_Global_ROMSize1|!Define_Global_ROMSize2 < !ROMSize_2MB, "For Satelliview games, the max ROM size you can use for the ROM size defines is 2MB. If you want a larger ROM, you need to set both defines."
	assert !Define_Global_ROMSize1+!Define_Global_ROMSize2 <= !ROMSize_4MB, "Satelliview games can't be larger than 4MB!"
endif

if !Define_Global_ROMSize > !ROMSize_4MB
	warn "Some emulators/flash carts have iffy support for ROM sizes above 4 MB. This ROM size is not recommended if you want to maximize compatibility."
	if !Define_Global_ROMLayout == !ROMLayout_LoROM
		warn "The ROM layout was automatically changed to ExLoROM due to the ROM size being set to be greater than 4 MB. Is that what you wanted?"
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM
		warn "The ROM layout was automatically changed to ExHiROM due to the ROM size being set to be greater than 4 MB. Is that what you wanted?"
	elseif !Define_Global_ROMLayout == !ROMLayout_SA1_HiROM
		warn "The ROM layout was automatically changed to SA-1 LoROM due to the ROM size being set to be greater than 4 MB. Is that what you wanted?"
	elseif !Define_Global_ROMLayout == !ROMLayout_LoROM_FastROM
		warn "The ROM layout was automatically changed to ExLoROM due to the ROM size being set to be greater than 4 MB. Is that what you wanted?"
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
		warn "The ROM layout was automatically changed to ExHiROM due to the ROM size being set to be greater than 4 MB. Is that what you wanted?"
	endif
endif

if !Define_Global_ROMSize > !ROMSize_8MB
	warn "ROM sizes above 8 MB are not recommended to be used."
elseif !Define_Global_ROMSize > (!ROMSize_4MB+!ROMSize_8MB)
	error "The ROM size can't be set greater than 12 MB!"
endif

if !Define_Global_ROMSize1 < !Define_Global_ROMSize2
	error "\!Define_Global_ROMSize1's value can't be smaller than \!Define_Global_ROMSize2's!"
endif

if !Define_Global_ROMSize < !ROMSize_64KB
	if !Define_Global_ROMLayout == !ROMLayout_HiROM
		warn "You should set the ROM size to at least 64KB if you're using the HiROM memory map."
	elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
		warn "You should set the ROM size to at least 64KB if you're using the HiROM memory map."
	elseif !Define_Global_ROMLayout == !ROMLayout_ExHiROM
		warn "You should set the ROM size to at least 64KB if you're using the ExHiROM memory map."
	elseif !Define_Global_ROMLayout == !ROMLayout_SPC7110ROM
		warn "You should set the ROM size to at least 64KB if you're using the SPC7110ROM memory map."
	endif	
endif

if !Define_Global_CustomChip != !Chip_None
	if !Define_Global_ROMType&$0F < !ROMType_ROM_Chip
		warn "You set this ROM to use a chip, yet you didn't set \!Define_Global_ROMType to specify this ROM is supposed to have a chip."
	endif
	if !Define_Global_CustomChip&$7F == !Chip_DSP1A
		if canreadfile1("../!MainFolder/dsp1a.bin", 1) == !FALSE
			warn "This ROM is set to use the DSP-1A chip, but the firmware file, dsp1a.bin, was not found in the Firmware folder. The ROM may not work without it! Do a web search for it if you don't have it."
		endif
	elseif !Define_Global_CustomChip&$7F == !Chip_DSP1B
		if canreadfile1("../!MainFolder/dsp1b.bin", 1) == !FALSE
			warn "This ROM is set to use the DSP-1B chip, but the firmware file, dsp1b.bin, was not found in the Firmware folder. The ROM may not work without it! Do a web search for it if you don't have it."
		endif
	endif	
else
	if !Define_Global_ROMType != !ROMType_SatellaviewGame
		if !Define_Global_ROMType > !ROMType_ROM_Chip
			warn "You set this ROM to use a chip, yet you didn't specify which one."
		endif
	endif
endif

if !Define_Global_SRAMSize > !SRAMSize_32KB
	warn "Some emulators/flash carts have iffy support for SRAM sizes above 32 KB. This SRAM size is not recommended if you want to maximize compatibility."
endif

if !FastROMAddressOffset&$800000 == $800000
	if !Define_Global_ROMSize > !ROMSize_4MB
		warn "The ROM size can't be greater than 4 MB with FastROM addressing!"
	endif
endif

if !Define_Global_CustomChip&$7F == !Chip_SuperFX1
	assert !Define_Global_ROMLayout == !ROMLayout_SuperFXROM, "SuperFX games are required to use the SuperFX memory map!"
	if !Define_Global_CompatibleControllers == !Controller_None
	elseif !Define_Global_CompatibleControllers&$000001 == !Controller_StandardJoypad
	else
		error "You can't use the SuperFX chip in conjunction with non-standard controllers. The power draw that would require might overwhelm the SNES".
	endif
elseif !Define_Global_CustomChip&$7F == !Chip_SuperFX2
	assert !Define_Global_ROMLayout == !ROMLayout_SuperFXROM, "SuperFX games are required to use the SuperFX memory map!"
	if !Define_Global_CompatibleControllers == !Controller_None
	elseif !Define_Global_CompatibleControllers&$000001 == !Controller_StandardJoypad
	else
		error "You can't use the SuperFX chip in conjunction with non-standard controllers. The power draw that would require might overwhelm the SNES".
	endif
elseif !Define_Global_CustomChip&$7F == !Chip_SA1
	if !Define_Global_ROMLayout == !ROMLayout_SA1_LoROM
	elseif !Define_Global_ROMLayout == !ROMLayout_SA1_HiROM
	else
		error "SA-1 games are required to use an SA-1 memory map!"
	endif
elseif !Define_Global_CustomChip&$7F == !Chip_SDD1
	assert !Define_Global_ROMLayout == !ROMLayout_SDD1ROM, "S-DD1 games are required to use the S-DD1 memory map!"
elseif !Define_Global_CustomChip&$7F == !Chip_SPC7110
	assert !Define_Global_ROMLayout == !ROMLayout_SPC7110ROM, "SPC7110 games are required to use the SPC7110 memory map!"
endif

!TEMP #= 0

if !FrameworkSubSubVer != !Define_Global_ROMFrameworkSubSubVer
	!TEMP #= 1
	print "Fart"
endif
if !FrameworkSubVer != !Define_Global_ROMFrameworkSubVer
	!TEMP #= 2
	print "Poop"
endif
if !FrameworkVer != !Define_Global_ROMFrameworkVer
	!TEMP #= 3
	print "Pee"
endif

if !TEMP == 1
	warn "This disassembly was made for framework version !Define_Global_ROMFrameworkVer.!Define_Global_ROMFrameworkSubVer.!Define_Global_ROMFrameworkSubSubVer while the framework is !FrameworkVer.!FrameworkSubVer.!FrameworkSubSubVer. There may be some slight incompatibilities."
elseif !TEMP == 2
	warn "This disassembly was made for framework version !Define_Global_ROMFrameworkVer.!Define_Global_ROMFrameworkSubVer.!Define_Global_ROMFrameworkSubSubVer while the framework is !FrameworkVer.!FrameworkSubVer.!FrameworkSubSubVer. If it failed to assemble, this is most likely why."
elseif !TEMP == 3
	warn "This disassembly was made for framework version !Define_Global_ROMFrameworkVer.!Define_Global_ROMFrameworkSubVer.!Define_Global_ROMFrameworkSubSubVer while the framework is !FrameworkVer.!FrameworkSubVer.!FrameworkSubSubVer. Now you know why the disassembly failed to assemble."
endif
if !TEMP != 0
	print "Visit Yoshifanatic's SNES ROM Framework GitHub repository (https://github.com/Yoshifanatic1/SNES-ROM-Framework) for the correct version of the framework."
endif

norom
if canread1(!MaxROMSize) == !TRUE
	warn "Something has caused the ROM to be larger than the chosen ROM size. It'd be a wise idea to chose a bigger ROM size setting if this is intended. If not, double check your BANK_START macros, look for org statements pointing past the last valid address, and check if any asar patches you're using use the freespace/freecode/freedata command."
endif
endmacro

;---------------------------------------------------------------------------

macro SetROMToAssembleForHack(ROMID, CurrentROMID)
if !SetROMToAssembleForHackCalled == !FALSE
	if defined("ROM_<CurrentROMID>")
		!HackROMID = ""
		!Define_Global_HackROMToAssemble = $0000
	else
		!HackROMID = !ROMID
		!ROMID = <ROMID>
		!Define_Global_HackROMToAssemble = !ROM_<CurrentROMID>
	endif
		!Define_Global_ROMToAssemble = !ROM_<ROMID>
		!SetROMToAssembleForHackCalled = !TRUE
endif
endmacro

;---------------------------------------------------------------------------

; Note: This inserts "ROM Data Collection" files

macro InsertRDCFile(Address, DataIndex, File)
%InsertMacroAtXPosition(<Address>)
if getfilestatus("<File>") == $00
	if filesize("<File>") != $00
		!TEMP1 #= readfile4("<File>", $00000000)				; Pointer past the header
		!TEMP2 #= readfile1("<File>", $00000004)				; Number of data blocks
		!TEMP3 #= readfile1("<File>", $00000015)-$30		; Version Number
		!TEMP4 #= readfile1("<File>", $00000017)-$30		; Sub Version Number
		!TEMP5 #= readfile1("<File>", $00000019)-$30		; Sub Sub Version Number
		if !RDCFileVer != !TEMP3
			warn "This disassembly was made to use RDC file version !TEMP3.!TEMP4.!TEMP5 while this framework version uses RDC file version !RDCFileVer.!RDCFileSubVer.!RDCFileSubSubVer. Now you know why the disassembly failed to assemble."
		elseif !RDCFileSubVer != !TEMP4
			warn "This disassembly was made to use RDC file version !TEMP3.!TEMP4.!TEMP5 while this framework version uses RDC file version !RDCFileVer.!RDCFileSubVer.!RDCFileSubSubVer. If it failed to assemble, this is most likely why."
		elseif !RDCFileSubSubVer != !TEMP5
			warn "This disassembly was made to use RDC file version !TEMP3.!TEMP4.!TEMP5 while this framework version uses RDC file version !RDCFileVer.!RDCFileSubVer.!RDCFileSubSubVer. There may be some slight incompatibilities."
		endif
		if <DataIndex> < !TEMP2 
			!TEMP3 #= readfile4("<File>", (!TEMP1+$08)+(<DataIndex>*$10))
			!TEMP4 #= readfile4("<File>", (!TEMP1+$0C)+(<DataIndex>*$10))
			incbin "<File>":!TEMP3..!TEMP3+!TEMP4
		else
			error "RDC file '<File>' doesn't contain <DataIndex> data blocks! Use an index of 0-",dec(!TEMP2-1)," for this file!"	
		endif
	endif
else
	error "<File> can't be found or is being used by another program."
endif
endmacro

;---------------------------------------------------------------------------

macro LoadExtraRAMFile(Path, CurrentGameID, GameID)
if stringsequal("<CurrentGameID>", "<GameID>")
	!TEMP1 = !FALSE
	if !FileType == !FileType_SNESROM
		!TEMP1 = !TRUE
	elseif !FileType == !FileType_FinalizeROM
		!TEMP1 = !TRUE
	elseif !FileType == !FileType_SuperFXFile
		!TEMP1 = !TRUE
	elseif !FileType == !FileType_MSU1DataFile
		!TEMP1 = !TRUE
	elseif !FileType == !FileType_SaveFile
		!TEMP1 = !TRUE
	endif

	if !TEMP1 == !TRUE
		if !Define_Global_CartridgeHeaderVersion == $02
			if !Define_Global_SRAMSize|!Define_Global_ExpansionRAMSize|!Define_Global_ExpansionFlashSize != !SRAMSize_0KB 
				incsrc "<Path>"
			endif
		else
			if !Define_Global_SRAMSize != !SRAMSize_0KB 
				incsrc "<Path>"
			endif
		endif
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro ReadPreCompiledFilePointers(Index, File)
!StartOffset #= 0
!EndOffset #= 0
!BlockSize #= !EndOffset-!StartOffset
if getfilestatus("<File>") == $00
	if filesize("<File>") != $00
		!StartOffset #= readfile3("<File>", (<Index>*$0C)+$04)
		!EndOffset #= readfile3("<File>", (<Index>*$0C)+$08)
		!BlockSize #= !EndOffset-!StartOffset
	endif
else
	error "<File> can't be found or is being used by another program."
endif
endmacro

;---------------------------------------------------------------------------

macro SetNextPreCompiledCodePointer(Label, Index, File)
if !FileType != !FileType_InitializeROM
	if getfilestatus("<File>") == $00
		if filesize("<File>") != $00
			<Label> = readfile3("<File>", (<Index>*$0C)+$00)
		else
			<Label> = $000000
		endif
	else
		<Label> = $000000
		error "<File> can't be found or is being used by another program."
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro InsertGarbageData(Address, Command, File)
if !Define_Global_IgnoreOriginalFreespace == !FALSE
%InsertMacroAtXPosition(<Address>)
	<Command> "GarbageData/<File>"
endif
endmacro

;---------------------------------------------------------------------------

macro CalculateFreespaceRemaining()
%GetROMSize()
print "Freespace used by integrated patches: ",freespaceuse
print "Total Freespace: ", dec(!TotalFreespace)
reset freespaceuse
endmacro

;---------------------------------------------------------------------------

macro AppendListOfItemsToPrint(StartOfList, StringVar, NewString)
if !<StartOfList> != !TRUE
	!<StringVar> += "/"
else
	!<StartOfList> = !FALSE
endif
	!<StringVar> += "<NewString>"
endmacro

;---------------------------------------------------------------------------

macro EndofROM(CurrentGameID, GameID, ROMID)
if stringsequal("<CurrentGameID>", "<GameID>")
	org $FFFFFF
	cleartable
	base off
	namespace off
	assert !NumOfInsertedSNESHeader != $00, "This ROM lacks an SNES header! Place a %SNES_Header() macro inside bank 00!"
	assert !InBank == !FALSE, "You forgot to put in the last BANK_END() macro call!"
	assert !InRATSBlock == !FALSE, "You forgot to put in the last RATSTagEnd() macro call!"
	assert !InROMMirror == !FALSE, "You forgot to put in the last EndROMMirroring() macro call!"
	if !Define_Global_ApplyAsarPatches == !TRUE
		%<GameID>_InsertIntegratedPatches()
		%CalculateFreespaceRemaining()
	endif
endif
endmacro

;---------------------------------------------------------------------------
