includeonce
!ChipName = "Satellaview"
!Firmware = "NULL"
!ExtraChipHeaderByte = $00

!REGISTER_BSX_Stream1HardwareChannelLo = $002188
!REGISTER_BSX_Stream1HardwareChannelHi = $002189
!REGISTER_BSX_Stream1QueueSize = $00218A
!REGISTER_BSX_Stream1QueueStatus = $00218B
!REGISTER_BSX_Stream1QueueDataUnits = $00218C
!REGISTER_BSX_Stream1Status = $00218D
!REGISTER_BSX_Stream2HardwareChannelLo = $00218E
!REGISTER_BSX_Stream2HardwareChannelHi = $00218F
!REGISTER_BSX_Stream2QueueSize = $002190
!REGISTER_BSX_Stream2QueueStatus = $002191
!REGISTER_BSX_Stream2QueueDataUnits = $002192
!REGISTER_BSX_Stream2Status = $002193
!REGISTER_BSX_PowerAndAccessLEDControl = $002194
!REGISTER_BSX_Unknown = $002195
!REGISTER_BSX_BIOSStatus = $002196
!REGISTER_BSX_BIOSControl = $002197
!REGISTER_BSX_SerialIOPort1 = $002198
!REGISTER_BSX_SerialIOPort2 = $002199

;---------------------------------------------------------------------------

macro Satelliview_Header(Address)
if !NumOfInsertedSNESHeader != $00
	!SNESHeaderLoc = <Address>
endif

Satelliview_Header_!NumOfInsertedSNESHeader:
if !ROMBankSplitFlag == !TRUE
	warnpc (!SNESHeaderLoc|!FastROMAddressOffset)^!HiROMAddressOffset
else
	warnpc !SNESHeaderLoc|!FastROMAddressOffset|!HiROMAddressOffset
endif

org (!SNESHeaderLoc)|!FastROMAddressOffset|!HiROMAddressOffset
.ProgramMakerCode:	db "!Define_Global_MakerCode"
padbyte $20
pad (!SNESHeaderLoc+$02)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$02)|!FastROMAddressOffset|!HiROMAddressOffset
.ProgramType:	db !Define_Global_ProgramType
padbyte $20
pad (!SNESHeaderLoc+$06)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$06)|!FastROMAddressOffset|!HiROMAddressOffset
.ReservedSpace:		db !Define_Global_ReservedSpace
padbyte $00
pad (!SNESHeaderLoc+$10)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$10)|!FastROMAddressOffset|!HiROMAddressOffset
.ProgramTitle:		db "!Define_Global_InternalName"
padbyte $20
pad (!SNESHeaderLoc+$20)|!FastROMAddressOffset|!HiROMAddressOffset
org (!SNESHeaderLoc+$20)|!FastROMAddressOffset|!HiROMAddressOffset
!TEMP1 #= $0000
!TEMP2 #= !Define_Global_ROMSize1/$40
while !TEMP2 != $0000
	!TEMP2 #= !TEMP2-1
	!TEMP1 #= (!TEMP1<<1)+$01
endif
.BlockAllocationFlags1:	dw !TEMP1
!TEMP1 #= $0000
!TEMP2 #= !Define_Global_ROMSize2/$40
while !TEMP2 != $0000
	!TEMP2 #= !TEMP2-$01
	!TEMP1 #= (!TEMP1<<1)+$01
endif
.BlockAllocationFlags2:	dw !TEMP1
.AllowedPlayCount:		dw !Define_Global_AllowedPlayCount
.Month:	db !Define_Global_Month
.Day:	db !Define_Global_Day
.ProgramLayout:		db !ROMLayoutHeaderByte
.ExecutionType:		db !Define_Global_ExecutionType
.ProgramLicensee:	db !Define_Global_LicenseeID
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
