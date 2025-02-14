
;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_InitAndMainLoop(Address)
namespace GAMEX_InitAndMainLoop
%InsertMacroAtXPosition(<Address>)

Main:
	SEI
	CLC
	XCE
if !Define_Global_ROMLayout == !ROMLayout_LoROM_FastROM
	LDA.b #$01
	STA.w !REGISTER_EnableFastROM
	JML.l FastROM
FastROM:
elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
	LDA.b #$01
	STA.w !REGISTER_EnableFastROM
	JML.l FastROM
FastROM:
endif
	STZ.w !REGISTER_IRQNMIAndJoypadEnableFlags
	STZ.w !REGISTER_HDMAEnable
	STZ.w !REGISTER_DMAEnable
	LDA.b #!ScreenDisplayRegister_SetForceBlank|!ScreenDisplayRegister_MinBrightness00
	STA.w !REGISTER_ScreenDisplayRegister
	REP.b #$30
	LDA.w #$0000
	TCD
	LDA.w #!RAM_GAMEX_Global_StartOfStack
	TCS
	PHK
	PLB
	SEP.b #$10
	LDA.w #((!REGISTER_ReadOrWriteToWRAMPort&$0000FF)<<8)+$08
	STA.w DMA[$00].Parameters
	LDX.b #$01
RAMClearLoop:
	LDY.w RAMBNKClearTBL,x
	STY.w !REGISTER_WRAMAddressBank
	STZ.w !REGISTER_WRAMAddressLo
	LDA.w #NullByte
	STA.w DMA[$00].SourceLo
	LDY.b #NullByte>>16
	STY.w DMA[$00].SourceBank
	STZ.w DMA[$00].SizeLo
	LDY.b #$01
	STY.w !REGISTER_DMAEnable
	DEX
	BPL.b RAMClearLoop
	SEP.b #$20
	JSR.w GAMEX_InitializeHardwareRegisters_Main
	JSR.w GAMEX_UploadDataToSPC700_Main
	STZ.w !RAM_GAMEX_Global_WaitForVBlankFlag
	LDA.b #$81
	STA.w !REGISTER_IRQNMIAndJoypadEnableFlags
MainLoop:
	WAI
	LDA.w !RAM_GAMEX_Global_WaitForVBlankFlag
	BEQ.b MainLoop
	REP.b #$10
	JSL.l ProcessCurrentGameMode
	SEP.b #$30
	STZ.w !RAM_GAMEX_Global_WaitForVBlankFlag
	JSR.w GAMEX_CheckWhichControllersArePluggedIn_Main
	BRA.b MainLoop

RAMBNKClearTBL:
	db !RAMBank7FStart>>16,!RAMBank7EStart>>16

NullByte:
	db $00

ProcessCurrentGameMode:
	REP.b #$20
	INC.w !RAM_GAMEX_Global_FrameCounterLo
	LDA.w !RAM_GAMEX_Global_CurrentGamemodeLo
	ASL
	CLC
	ADC.w !RAM_GAMEX_Global_CurrentGamemodeLo
	TAX
	LDA.l GameModePointers,x
	STA.b !RAM_GAMEX_Global_ScratchRAM000000
	LDA.l GameModePointers+$02,x
	STA.b !RAM_GAMEX_Global_ScratchRAM000002
	SEP.b #$20
	JMP.w [!RAM_GAMEX_Global_ScratchRAM000000]

GameModePointers:
	dl GAMEX_GameMode00_InitializeSplashScreen_Main
	dl GAMEX_GameMode01_FadeIntoSplashScreen_Main
	dl GAMEX_GameMode02_DisplaySplashScreen_Main

namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_UploadDataToSPC700(Address)
namespace GAMEX_UploadDataToSPC700
%InsertMacroAtXPosition(<Address>)

Main:
	RTS
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_InitializeHardwareRegisters(Address)
namespace GAMEX_InitializeHardwareRegisters
%InsertMacroAtXPosition(<Address>)

Main:
	LDA.b #$00
	STA.w !RAM_GAMEX_Global_OAMSizeAndDataAreaDesignation
	STA.w !RAM_GAMEX_Global_BGModeAndTileSizeSetting
	STA.w !RAM_GAMEX_Global_MosaicSizeAndBGEnable
	STA.w !RAM_GAMEX_Global_BG1AddressAndSize
	STA.w !RAM_GAMEX_Global_BG2AddressAndSize
	STA.w !RAM_GAMEX_Global_BG3AddressAndSize
	STA.w !RAM_GAMEX_Global_BG4AddressAndSize
	STA.w !RAM_GAMEX_Global_BG1And2TileDataDesignation
	STA.w !RAM_GAMEX_Global_BG3And4TileDataDesignation
	STA.w !RAM_GAMEX_Global_Mode7TilemapSettings
	STA.w !RAM_GAMEX_Global_BG1And2WindowMaskSettings
	STA.w !RAM_GAMEX_Global_BG3And4WindowMaskSettings
	STA.w !RAM_GAMEX_Global_ObjectAndColorWindowSettings
	STA.w !RAM_GAMEX_Global_Window1LeftPositionDesignation
	STA.w !RAM_GAMEX_Global_Window1RightPositionDesignation
	STA.w !RAM_GAMEX_Global_Window2LeftPositionDesignation
	STA.w !RAM_GAMEX_Global_Window2RightPositionDesignation
	STA.w !RAM_GAMEX_Global_BGWindowLogicSettings
	STA.w !RAM_GAMEX_Global_ColorAndObjectWindowLogicSettings
	STA.w !RAM_GAMEX_Global_MainScreenLayers
	STA.w !RAM_GAMEX_Global_SubScreenLayers
	STA.w !RAM_GAMEX_Global_MainScreenWindowMask
	STA.w !RAM_GAMEX_Global_SubScreenWindowMask
	STA.w !RAM_GAMEX_Global_ColorMathInitialSettings
	STA.w !RAM_GAMEX_Global_ColorMathSelectAndEnable
	STA.w !RAM_GAMEX_Global_InitialScreenSettings
	LDA.b #$20
	STA.w !RAM_GAMEX_Global_FixedColorData1
	ASL
	STA.w !RAM_GAMEX_Global_FixedColorData2
	ASL
	STA.w !RAM_GAMEX_Global_FixedColorData3
	LDA.b #$FF
	STA.b !RAM_GAMEX_Global_HCountTimerLo
	STA.b !RAM_GAMEX_Global_VCountTimerLo
	LDA.b #$01
	STA.b !RAM_GAMEX_Global_HCountTimerHi
	STA.b !RAM_GAMEX_Global_VCountTimerHi
	LDX.b #$04
-
	LDA.w VectorPointers,x
	STA.b !RAM_GAMEX_Global_VBlankRoutineVector,x
	LDA.w VectorPointers+$04,x
	STA.b !RAM_GAMEX_Global_IRQRoutineVector
	LDA.w VectorPointers+$08,x
	STA.w !RAM_GAMEX_Global_BRKRoutineVector
	DEX
	BPL.b -
	RTS

VectorPointers:
	JML GAMEX_VBlankRoutine_Main
	JML GAMEX_IRQRoutine_Main
	JML GAMEX_BRKRoutine_Main
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_VBlankRoutine(Address)
namespace GAMEX_VBlankRoutine
%InsertMacroAtXPosition(<Address>)

if !Define_Global_CustomChip == !Chip_SA1
	base !RAM_GAMEX_Global_RAMBufferedRoutines
elseif !Define_Global_CustomChip == !Chip_SuperFX1
	base !RAM_GAMEX_Global_RAMBufferedRoutines
elseif !Define_Global_CustomChip == !Chip_SuperFX2
	base !RAM_GAMEX_Global_RAMBufferedRoutines
endif

Main:
if !Define_Global_ROMLayout == !ROMLayout_LoROM_FastROM
	JML.l FastROM
FastROM:
elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
	JML.l FastROM
FastROM:
endif
	SEI
	REP.b #$30
	PHB
	PHK
	PLB
	PHA
	PHX
	PHY
	PHD
	LDA.w #$0000
	TCD
	SEP.b #$30
	LDA.b #!ScreenDisplayRegister_SetForceBlank|!ScreenDisplayRegister_MinBrightness00
	STA.w !REGISTER_ScreenDisplayRegister
	LDA.w !RAM_GAMEX_Global_WaitForVBlankFlag
	BEQ.b +
	JMP.w NoVBlank
+
	INC.w !RAM_GAMEX_Global_WaitForVBlankFlag
	LDA.w !REGISTER_NMIEnable
	REP.b #$10
	PHD
	TSX							;\ Transfer the stack pointer into Y
	TXY							;/
	LDX.w #!REGISTER_BG4VertScrollOffset			;\ Set the stack pointer to the location of the scroll registers
	TXS							;/
	LDX.w #$000E
-:
	LDA.b !RAM_GAMEX_Global_Layer1XPosLo,x			;\ Write to most of the BG scroll registers by pushing the low byte to the stack and writing the high byte directly
	PHA							;| This method of writing to these registers is ever so slightly faster than just using LDA/STAs
	LDA.b !RAM_GAMEX_Global_Layer1XPosHi,x			;| This would be a bit faster if I could push all the low bytes, reset the stack pointer, then push all the high bytes...
	STA.b $01,S						;| ... but sadly, that doesn't work.
	DEX							;| Also, the STA $01,S save 1 byte over writing to the registers directly without any loss of speed.
	DEX							;|
	BPL.b -							;/
	LDA.w !RAM_GAMEX_Global_BGModeAndTileSizeSetting	;\ Is the current BG mode set to Mode 7?
	EOR.b #$07						;|
	AND.b #$07						;|
	BNE.b NotUsingMode7					;/ If not, don't bother updating the Mode 7 registers
	LDA.w !RAM_GAMEX_Global_Mode7TilemapSettings
	STA.w !REGISTER_Mode7TilemapSettings
	LDX.w #!REGISTER_Mode7CenterY
	TXS
	LDX.w #$000A
-:
	LDA.b !RAM_GAMEX_Global_Mode7MatrixParameterALo,x
	PHA
	LDA.b !RAM_GAMEX_Global_Mode7MatrixParameterAHi,x
	STA.b $01,S
	DEX
	DEX
	BNE.b -	
NotUsingMode7:
	REP #$20							;\			
	LDA.w #!RAM_GAMEX_Global_ScreenDisplayRegister&$FF00		;|
	TCD								;|
	TYA								;| This bit of code was gotten from a forum thread on NESDev.com and used in some of my homebrew projects
	LDX.w #!REGISTER_ColorMathSelectAndEnable			;| It's basically a fast way to write to many of the registers that can only be written to during a blank.
	TXS								;| It does so by changing the stack pointer (after preserving it, of course) to point to the hardware registers...
	PEI.b (!RAM_GAMEX_Global_ColorMathInitialSettings)		;|
	PEI.b (!RAM_GAMEX_Global_MainScreenWindowMask)			;| ... then using PEI to push the values of their hardware mirrors into the registers
	PEI.b (!RAM_GAMEX_Global_MainScreenLayers)			;|
	PEI.b (!RAM_GAMEX_Global_BGWindowLogicSettings)			;|
	PEI.b (!RAM_GAMEX_Global_Window1RightPositionDesignation)	;|
	PEI.b (!RAM_GAMEX_Global_Window2RightPositionDesignation)	;| Also, the reason the scroll and Mode 7 registers are not handled by this routine is because those registers are dual write...
	PEI.b (!RAM_GAMEX_Global_BG3And4WindowMaskSettings)		;| All the registers handled by this are single write
	LDX.w #!REGISTER_BG3And4TileDataDesignation			;|
	TXS								;|
	PEI.b (!RAM_GAMEX_Global_BG1And2TileDataDesignation)		;|
	PEI.b (!RAM_GAMEX_Global_BG3AddressAndSize)			;|
	PEI.b (!RAM_GAMEX_Global_BG1AddressAndSize)			;|
	PEI.b (!RAM_GAMEX_Global_BGModeAndTileSizeSetting)		;|
	SEP.b #$10							;|
	LDX.b !RAM_GAMEX_Global_OAMSizeAndDataAreaDesignation		;|
	STX.w !REGISTER_OAMSizeAndDataAreaDesignation			;|
	LDX.b !RAM_GAMEX_Global_BG1And2WindowMaskSettings		;|
	STX.w !REGISTER_BG1And2WindowMaskSettings			;|
	LDX.b !RAM_GAMEX_Global_InitialScreenSettings			;|
	STX.w !REGISTER_InitialScreenSettings				;|
	LDX.b !RAM_GAMEX_Global_FixedColorData1				;|
	STX.w !REGISTER_FixedColorData					;|
	LDX.b !RAM_GAMEX_Global_FixedColorData2				;|
	STX.w !REGISTER_FixedColorData					;|
	LDX.b !RAM_GAMEX_Global_FixedColorData3				;|
	STX.w !REGISTER_FixedColorData					;|
	LDX.b !RAM_GAMEX_Global_HCountTimerLo				;|
	STX.w !REGISTER_HCountTimerLo					;|
	LDX.b !RAM_GAMEX_Global_HCountTimerHi				;|
	STX.w !REGISTER_HCountTimerHi					;|
	LDX.b !RAM_GAMEX_Global_VCountTimerLo				;|
	STX.w !REGISTER_VCountTimerLo					;|
	LDX.b !RAM_GAMEX_Global_VCountTimerHi				;|
	STX.w !REGISTER_VCountTimerHi					;|
	TCS								;|
	PLD								;/
	SEP.b #$30
	JSR.w GAMEX_ProcessDMAUploads_Main
	JSR.w GAMEX_PollJoypadInputs_Main
;Insert V-Blank code here

NoVBlank:
	LDA.w !RAM_GAMEX_Global_ScreenDisplayRegister
	STA.w !REGISTER_ScreenDisplayRegister
	REP.b #$30
	PLD
	PLY
	PLX
	PLA
	PLB
EndofVBlank:
	RTI
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_IRQRoutine(Address)
namespace GAMEX_IRQRoutine
%InsertMacroAtXPosition(<Address>)

Main:
if !Define_Global_ROMLayout == !ROMLayout_LoROM_FastROM
	JML.l FastROM
FastROM:
elseif !Define_Global_ROMLayout == !ROMLayout_HiROM_FastROM
	JML.l FastROM
FastROM:
endif
	SEI
	REP.b #$30
	PHB
	PHK
	PLB
	PHA
	PHX
	PHY
	PHD
	LDA.w #$0000
	TCD
	SEP.b #$30
	LDA.w !REGISTER_IRQEnable
;Insert IRQ code here
	REP.b #$30
	PLD
	PLY
	PLX
	PLA
	PLB
	RTI
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_BRKRoutine(Address)
namespace GAMEX_BRKRoutine
%InsertMacroAtXPosition(<Address>)

Main:
	BRA.b Main
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_PollJoypadInputs(Address)
namespace GAMEX_PollJoypadInputs
%InsertMacroAtXPosition(<Address>)

Main:
	LDX.w !RAM_GAMEX_Global_Controller1PluggedInFlag	;\ Check what buttons are being pressed this frame for player 1 and store it to some RAM addresses
	LDA.w !REGISTER_Joypad1Lo,x				;|
	AND.w #$FFF0						;|
	STA.w !RAM_GAMEX_Global_ControllerHold1P1		;|
	EOR.w !RAM_GAMEX_Global_P1CtrlDisableLo			;|
	AND.w !RAM_GAMEX_Global_ControllerHold1P1		;|
	STA.w !RAM_GAMEX_Global_ControllerPress1P1		;|
	LDA.w !REGISTER_Joypad1Lo,x				;|
	STA.w !RAM_GAMEX_Global_P1CtrlDisableLo			;/
	LDX.w !RAM_GAMEX_Global_Controller1PluggedInFlag	;\
	LDA.w !REGISTER_Joypad1Lo,x				;| Check what buttons are being pressed this frame for player 2 and store it to some RAM addresses
	AND.w #$FFF0						;|
	STA.w !RAM_GAMEX_Global_ControllerHold1P2		;|
	EOR.w !RAM_GAMEX_Global_P2CtrlDisableLo			;|
	AND.w !RAM_GAMEX_Global_ControllerHold1P2		;|
	STA.w !RAM_GAMEX_Global_ControllerPress1P2		;|
	LDA.w !REGISTER_Joypad1Lo,x				;|
	STA.w !RAM_GAMEX_Global_P2CtrlDisableLo			;/
	RTS
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

; Note: This routine was borrowed from SMAS. It's a pretty simple way of handling this sort of function and I don't think I could have done it better.

macro ROUTINE_GAMEX_CheckWhichControllersArePluggedIn(Address)
namespace GAMEX_CheckWhichControllersArePluggedIn
%InsertMacroAtXPosition(<Address>)

Main:
	LDA.w !REGISTER_JoypadSerialPort1
	AND.b #$01
	EOR.b #$01
	ASL
	STA.w !RAM_GAMEX_Global_Controller1PluggedInFlag
	LDA.w !REGISTER_JoypadSerialPort2
	AND.b #$01
	ASL
	STA.w !RAM_GAMEX_Global_Controller2PluggedInFlag
	RTS
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_GameMode00_InitializeSplashScreen(Address)
namespace GAMEX_GameMode00_InitializeSplashScreen
%InsertMacroAtXPosition(<Address>)

Main:
	LDA.b #!ScreenDisplayRegister_SetForceBlank|!ScreenDisplayRegister_MinBrightness00
	STA.w !REGISTER_ScreenDisplayRegister
	STA.w !RAM_GAMEX_Global_ScreenDisplayRegister
	LDY.w #((!REGISTER_ReadOrWriteToWRAMPort&$0000FF)<<8)+$08
	STY.w DMA[$00].Parameters
	LDA.b #!RAM_GAMEX_Global_GenericDataBuffer>>16
	STA.w !REGISTER_WRAMAddressBank
	LDY.w #!RAM_GAMEX_Global_GenericDataBuffer
	STY.w !REGISTER_WRAMAddressLo
	LDY.w #BlankTileData
	STY.w DMA[$00].SourceLo
	LDA.b #BlankTileData>>16
	STA.w DMA[$00].SourceBank
	LDY.w #$0800
	STY.w DMA[$00].SizeLo
	LDA.b #$01
	STA.w !REGISTER_DMAEnable
	LDY.w #TextData_Line2-TextData_Line1-$01
	LDX.w #(TextData_Line2-TextData_Line1-$01)*$02
-:
	LDA.w TextData_Line1,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$42,x
	LDA.w TextData_Line2,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$82,x
	LDA.w TextData_Line3,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$C2,x
	LDA.w TextData_Line4,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$0102,x
	LDA.w TextData_Line5,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$0142,x
	LDA.w TextData_Line6,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$0182,x
	LDA.w TextData_Line7,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$0202,x
	LDA.w TextData_Line8,y
	STA.l !RAM_GAMEX_Global_GenericDataBuffer+$0242,x
	DEX
	DEX
	DEY
	BPL.b -
	LDA.b #$01
	STA.w !REGISTER_CGRAMAddress
	LDX.w #$0000
-:
	LDA.w SplashScreenTextPalette,x
	STA.w !REGISTER_WriteToCGRAMPort
	INX
	CPX.w #$0002
	BCC.b -
	LDA.b #$80
	STA.w GAMEX_Global_DMAUpdateTable[$00].ExtraParam
	STA.w GAMEX_Global_DMAUpdateTable[$00].ExtraParam
	LDY.w #((!REGISTER_WriteToVRAMPortLo&$0000FF)<<8)+$01
	STY.w GAMEX_Global_DMAUpdateTable[$00].Parameters
	STY.w GAMEX_Global_DMAUpdateTable[$01].Parameters
	LDA.b #$08
	STA.w GAMEX_Global_DMAUpdateTable[$00].DMAType
	STA.w GAMEX_Global_DMAUpdateTable[$01].DMAType
	LDY.w #$0000
	STY.w GAMEX_Global_DMAUpdateTable[$00].DestAddressLo
	LDY.w #GAMEX_BasicFontGFX_Main
	STY.w GAMEX_Global_DMAUpdateTable[$00].SourceLo
	LDA.b #GAMEX_BasicFontGFX_Main>>16
	STA.w GAMEX_Global_DMAUpdateTable[$00].SourceBank
	LDY.w #GAMEX_BasicFontGFX_End-GAMEX_BasicFontGFX_Main
	STY.w GAMEX_Global_DMAUpdateTable[$00].SizeLo
	LDY.w #$1000
	STY.w GAMEX_Global_DMAUpdateTable[$01].DestAddressLo
	STY.w GAMEX_Global_DMAUpdateTable[$01].SizeLo
	LDY.w #!RAM_GAMEX_Global_GenericDataBuffer
	STY.w GAMEX_Global_DMAUpdateTable[$01].SourceLo
	LDA.b #!RAM_GAMEX_Global_GenericDataBuffer>>16
	STA.w GAMEX_Global_DMAUpdateTable[$01].SourceBank
	LDY.w #$0001
	STY.w !RAM_GAMEX_Global_MainScreenLayers
	LDA.b #$01
	STA.w !RAM_GAMEX_Global_BGModeAndTileSizeSetting
	LDA.b #$10
	STA.w !RAM_GAMEX_Global_BG1AddressAndSize
	INC.w !RAM_GAMEX_Global_CurrentGamemodeLo
	INC.w !RAM_GAMEX_Global_NumberOfDMAUpdates
	INC.w !RAM_GAMEX_Global_NumberOfDMAUpdates
	RTL

BlankTileData:
	dw $5500

SplashScreenTextPalette:
	dw $7FFF

%GAMEX_BasicFont()

TextData:
.Line1:	db " THIS IS YOSHIFANATIC'S GAMEX "
.Line2:	db " ROM, MEANT FOR SNES HOMEBREW "
.Line3:	db " DEVELOPMENT. IF YOU HAVE ANY "
.Line4:	db " QUESTIONS OR FEEDBACK, VISIT "
.Line5:	db "YOSHIFANATIC'S DISCORD SERVER "
.Line6:	db "   LINKED TO IN THE README.   "
.Line7:	db "    BY THE WAY, THIS IS A     "
if !Define_Global_ROMToAssemble&(!ROM_GAMEX_V1) != $00
.Line8:	db "        V1 GAMEX ROM.        "
elseif !Define_Global_ROMToAssemble&(!ROM_GAMEX_V2) != $00
.Line8:	db "        V2 GAMEX ROM.        "
else
.Line8:	db "      CUSTOM GAMEX ROM.      "
endif

cleartable

namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_GameMode01_FadeIntoSplashScreen(Address)
namespace GAMEX_GameMode01_FadeIntoSplashScreen
%InsertMacroAtXPosition(<Address>)

Main:
	PHB
	PHK
	PLB
	LDY.w !RAM_GAMEX_Global_FadeDirection
	LDA.w FadeTable,y
	CLC
	ADC.w !RAM_GAMEX_Global_ScreenDisplayRegister
	AND.b #$0F
	STA.w !RAM_GAMEX_Global_ScreenDisplayRegister
	CMP.w FadeDest,y
	BEQ.b +
	BRA.b ++

+:
	CMP.b !ScreenDisplayRegister_MinBrightness00
	BNE.b +
	LDA.w !RAM_GAMEX_Global_ScreenDisplayRegister
	ORA.w !ScreenDisplayRegister_SetForceBlank
	STA.w !RAM_GAMEX_Global_ScreenDisplayRegister
+:
	REP.b #$20
	INC.w !RAM_GAMEX_Global_CurrentGamemodeLo
	SEP.b #$20
++:
	PLB
	RTL

FadeTable:
	db $01,$FF

FadeDest:
	db !ScreenDisplayRegister_MaxBrightness0F,!ScreenDisplayRegister_MinBrightness00
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_GameMode02_DisplaySplashScreen(Address)
namespace GAMEX_GameMode02_DisplaySplashScreen
%InsertMacroAtXPosition(<Address>)

Main:
	RTL
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_ProcessDMAUploads(Address)
namespace GAMEX_ProcessDMAUploads
%InsertMacroAtXPosition(<Address>)

Main:
	LDA.w !RAM_GAMEX_Global_NumberOfDMAUpdates			;\ Load the number of NMI updates that need to be done, double it, and transfer it into Y for later
	ASL								;|
	ASL								;|
	PHA								;|
	ASL								;|
	CLC								;|
	ADC.b $01,S							;|
	TAY								;/
	PLA
	CPY.b #$0C							; If the number of updates is 0, then the carry flag will be cleared
	PHD								; Preserve the direct page register
	REP.b #$20
	LDA.w #DMA[$00].Parameters					;\ Set the direct page to $4300 so the upcoming loop and the next bit of code runs faster
	TCD								;/
	LDX.b #!RAM_GAMEX_Global_OAMBuffer>>16				;\ Set up a DMA transfer that updates the entire OAM table
	STX.b DMA[$00].SourceBank					;| This must be done every frame which is why it's not handled in the upcoming loop
	LDA.w #!RAM_GAMEX_Global_OAMBuffer				;|
	STA.b DMA[$00].SourceLo						;|
	LDA.w #$0220							;|
	STA.b DMA[$00].SizeLo						;|
	LDA.w #$0400							;|
	STA.b DMA[$00].Parameters					;|
	STZ.w !REGISTER_OAMDataWritePort				;|
	LDX.b #$01							;|
	STX.w !REGISTER_DMAEnable					;/
	BCS.b NMIUploadLoop						; If the carry flag was cleared earlier, then skip the DMA loop
	JMP.w NothingtoUpdate						; Fun fact: By the time the CPU gets here, the V-Counter won't have advanced much.
									; That means that you'll have almost the entire V-Blank period available for VRAM/CGRAM updates
NMIUploadLoop:
	LDA.w GAMEX_Global_DMAUpdateTable[$00].SourceLo-$0C,y		;\ Store the DMA Source Address for DMA channel 0
	STA.b DMA[$00].SourceLo						;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].SizeLo-$0C,y		;\ Store the number of bytes to transfer for DMA channel 0
	STA.b DMA[$00].SizeLo						;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].Parameters-$0C,y		;\ Store the DMA settings and the destination register for DMA channel 0
	STA.b DMA[$00].Parameters					;/
	LDX.w GAMEX_Global_DMAUpdateTable[$00].SourceBank-$0C,y		;\ Store the DMA Source Bank for DMA channel 0
	STX.b DMA[$00].SourceBank					;/
	LDX.w GAMEX_Global_DMAUpdateTable[$00].DMAType-$0C,y		;\ Jump to a location based on what type of update we're doing
	JMP.w (DMATypeTBL,x)						;/

VRAMRead:
	LDX.w GAMEX_Global_DMAUpdateTable[$00].ExtraParam-$0B,y		;\ Store the VRAM settings for the upcoming VRAM read
	STX.w !REGISTER_VRAMAddressIncrementValue			;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].DestAddressLo-$0C,y	;\ Store the VRAM address we will be reading from
	STA.w !REGISTER_VRAMAddressLo					;/
	LDA.w !REGISTER_ReadFromVRAMPortLo				; Perform a dummy read so the actual VRAM read will work correctly
	JMP.w DoneTask							; Branch to some code shared by all of these mini routines

VRAMWriteGeneral:
VRAMWriteSprite8x8:
	LDX.w GAMEX_Global_DMAUpdateTable[$00].ExtraParam-$0B,y		;\ Store the VRAM settings for the upcoming VRAM write
	STX.w !REGISTER_VRAMAddressIncrementValue			;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].DestAddressLo-$0C,y	;\ Store the VRAM address we will be writing to
	STA.w !REGISTER_VRAMAddressLo					;/
	JMP.w DoneTask							; Branch to some code shared by all of these mini routines

CGRAMRead:
CGRAMWrite:
	LDX.w GAMEX_Global_DMAUpdateTable[$00].DestAddressLo-$0C,y	;\ Store the CGRAM address we will be reading from or writing to
	STX.w !REGISTER_CGRAMAddress					;/
	JMP.w DoneTask							; Branch to some code shared by all of these mini routines

OAMWrite:
	STZ.w !REGISTER_OAMAddressLo					; Set the OAM Write address to 0 so we can update the entire OAM
	JMP.w DoneTask							; Branch to some code shared by all of these mini routines

VRAMWriteSprite16x16:
	LDX.w GAMEX_Global_DMAUpdateTable[$00].ExtraParam-$0B,y		;\ Store the VRAM settings for the upcoming VRAM write
	STX.w !REGISTER_VRAMAddressIncrementValue			;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].DestAddressLo-$0C,y	;\ Store the VRAM address we will be writing to
	STA.w !REGISTER_VRAMAddressLo					;/
	LDX.b #$01							;\ Start up DMA channel 0 so we can update the top half of the sprite, then we'll set things up to update the bottom half
	STX.w !REGISTER_DMAEnable					;/
	CLC								;\
	ADC.w #$0100							;| Add 0100 to the VRAM address we will be writing to
	STA.w !REGISTER_VRAMAddressLo					;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].SourceLo-$0C,y		;\ Add 0200 to the DMA source address
	CLC								;|
	ADC.w #$0200							;|
	STA.b DMA[$00].SourceLo						;/
	LDA.w GAMEX_Global_DMAUpdateTable[$00].SizeLo-$0C,y		;\ Set the number of bytes to transfer again
	STA.b DMA[$00].SizeLo						;/
DoneTask:
	LDX.b #$01							;\ Start up DMA channel 0 so we can update whatever needed updating
	STX.w !REGISTER_DMAEnable					;/
	TYA								;\ Decrement Y 12 times to prepare for the next loop/end the loop
	SEC								;|
	SBC.w #$000C							;|
	TAY								;/
	BNE.b NMIUploadLoop						; If Y = 0, exit the DMA loop
NothingtoUpdate:
	PLD								; Restore the direct page register
	STZ.w !RAM_GAMEX_Global_NumberOfDMAUpdates
	RTS

DMATypeTBL:
	dw OAMWrite,CGRAMWrite,CGRAMRead,VRAMRead,VRAMWriteGeneral,VRAMWriteSprite16x16

namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro DATATABLE_GAMEX_BasicFontGFX(Address)
namespace GAMEX_BasicFontGFX
%InsertMacroAtXPosition(<Address>)

Main:
	incbin "Graphics/BasicText.bin"
End:
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_BeginSA1Processing(NULLROM)
namespace GAMEX_BeginSA1Processing
%InsertMacroAtXPosition(<Address>)

Main:


base off
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################

macro ROUTINE_GAMEX_BeginSuperFXProcessing(NULLROM)
namespace GAMEX_BeginSuperFXProcessing
%InsertMacroAtXPosition(<Address>)

Main:

base off
namespace off
endmacro

;#############################################################################################################
;#############################################################################################################
