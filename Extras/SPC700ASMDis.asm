asar 1.91

; Modify these as needed
lorom								; The memory map of the ROM. Change this if the ROM uses a different memory map, or else the output may be wrong.
!GetBaseOffsetFromROM = 1		; If 1, this script will get the base offset of a block from the ROM. Some games may not put a base offset at the start of an SPC block, so turn this off in those cases.
!ReadSizeOffset = 1				; If 1, this script will get the size of a block from the ROM. Turning this on will also cause the script to automatically disassemble the next block until one of size 0000 is encountered. Some games may not put the size of a block at the start of an SPC block, so turn this off in those cases.
!BaseOffset = $0500				; This is the base offset used if !GetBaseOffsetFromROM = 0
!EngineOffset = 0500				; This contains the base offset of the address the SPC700 should jump to when the final block is uploaded.
!ROMOffset = $0E8000				; The ROM offset to begin disassembly from.
!SizeOfBlock #= $0100				; This is the size of a block to disassemble if !ReadSizeOffset = 0
!DoTwoPassesFlag = 1				; If 1, the script will run twice, with the purpose of generating labels that appear before the branch that points to it. Turning this on may slow down disassembly speed, however.
!MaxBytes = 16384					; The maximum amount of bytes that will be read if an SPC block doesn't end sooner. Setting this lower/higher will speed up/slow down disassembly.

!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!TEMP2 = ""
!TEMP4 = ""
!Pass = 0
!CurrentOffset #= !ROMOffset

macro GetOpcode()
	!Input1 #= read1(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
	!BaseOffsetOffset #= !BaseOffsetOffset+1
	!SizeOfBlock #= !SizeOfBlock-1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readbyte(Input)
	!<Input> #= read1(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)
	;!Input1 = $01
	;!Input2 = $0F
	!ByteCounter #= !ByteCounter+1
	!BaseOffsetOffset #= !BaseOffsetOffset+1
	!SizeOfBlock #= !SizeOfBlock-1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readword(Input)
	!<Input> #= read2(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)
	;!Input1 = $0123
	!ByteCounter #= !ByteCounter+2
	!BaseOffsetOffset #= !BaseOffsetOffset+2
	!SizeOfBlock #= !SizeOfBlock-2
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro HandleBranch(Value, ByteCounter)
if !Input1 >= <Value>
	!TEMP4 #= (!CurrentOffset)-((!Input1^$FF)+$01)
	!Input1 #= (!BaseOffset+!BaseOffsetOffset)-((!Input1^$FF)+$01)
else
	!TEMP4 #= (!CurrentOffset)+!Input1
	!Input1 #= (!BaseOffset+!BaseOffsetOffset)+!Input1
endif
	%GetBranchLabelLocation(!TEMP4)
endmacro

macro AdjustMemBitOpcodeOutput()
	!TEMP2 #= (!Input1&$F000)/$2000
	!Input1 #= !Input1&$1FFF
endmacro

macro PrintLabel(Address)
if defined("ROM_<Address>") == 1
	if !ROM_<Address> == 1
		print ""
	endif
	print "CODE_",hex(!BaseOffset+!BaseOffsetOffset, 4),":"
endif
endmacro

macro DefineLabelAfterNoPassOpcode(Address)
	!ROM_<Address> = 1
endmacro

macro GetBranchLabelLocation(Address)
if defined("ROM_<Address>") == 0
	!ROM_<Address> = 0
endif
endmacro

macro HandleAbsoluteAddressJump()
	;!TEMP #= 0
	;if !GetBaseOffsetFromROM == 1
	;	!TEMP #= !TEMP+2
	;endif
	;if !ReadSizeOffset == 1
	;	!TEMP #= !TEMP+2
	;endif
	!Input2 #= !Input1+(!CurrentOffset-(!BaseOffset+!BaseOffsetOffset))
	%HandleJump(!Input2)
endmacro

macro HandleJump(Address)
if defined("ROM_<Address>") == 0
	!ROM_<Address> = 0
endif
endmacro

macro Op0()
if !Pass == 1
	print "	NOP"
endif
endmacro

macro Op1()
if !Pass == 1
	print "	TCALL 0"
endif
endmacro

macro Op2()
	%readbyte(Input1)
if !Pass == 1
	print "	SET0.b $",hex(!Input1, 2)
endif
endmacro

macro Op3()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS0.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op4()
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op5()
	%readword(Input1)
if !Pass == 1
	print "	OR.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op6()
if !Pass == 1
	print "	OR.b A, (X)"
endif
endmacro

macro Op7()
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op8()
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op9()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op10()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	OR",hex(!TEMP2, 1),".w C, $",hex(!Input1, 4)
endif
endmacro

macro Op11()
	%readbyte(Input1)
if !Pass == 1
	print "	ASL.b $",hex(!Input1, 2)
endif
endmacro

macro Op12()
	%readword(Input1)
if !Pass == 1
	print "	ASL.w $",hex(!Input1, 4)
endif
endmacro

macro Op13()
if !Pass == 1
	print "	PUSH P"
endif
endmacro

macro Op14()
	%readword(Input1)
if !Pass == 1
	print "	TSET.w $",hex(!Input1, 4),", A"
endif
endmacro

macro Op15()
if !Pass == 1
	print "	BRK"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op16()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BPL.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op17()
if !Pass == 1
	print "	TCALL 1"
endif
endmacro

macro Op18()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR0.b $",hex(!Input1, 2)
endif
endmacro

macro Op19()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC0.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op20()
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op21()
	%readword(Input1)
if !Pass == 1
	print "	OR.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op22()
	%readword(Input1)
if !Pass == 1
	print "	OR.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op23()
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op24()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	OR.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op25()
if !Pass == 1
	print "	OR (X), (Y)"
endif
endmacro

macro Op26()
	%readbyte(Input1)
if !Pass == 1
	print "	DECW.b $",hex(!Input1, 2)
endif
endmacro

macro Op27()
	%readbyte(Input1)
if !Pass == 1
	print "	ASL.b $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op28()
if !Pass == 1
	print "	ASL A"
endif
endmacro

macro Op29()
if !Pass == 1
	print "	DEC X"
endif
endmacro

macro Op30()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w X, $",hex(!Input1, 4)
endif
endmacro

macro Op31()
	%readword(Input1)
if !Pass == 1
	print "	JMP.w ($",hex(!Input1, 4),"+x)"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op32()
if !Pass == 1
	print "	CLRP"
endif
endmacro

macro Op33()
if !Pass == 1
	print "	TCALL 2"
endif
endmacro

macro Op34()
	%readbyte(Input1)
if !Pass == 1
	print "	SET1.b $",hex(!Input1, 2)
endif
endmacro

macro Op35()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS1.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op36()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op37()
	%readword(Input1)
if !Pass == 1
	print "	AND.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op38()
if !Pass == 1
	print "	AND.b A, (X)"
endif
endmacro

macro Op39()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op40()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op41()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op42()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	OR",hex(!TEMP2, 1),".w C, !$",hex(!Input1, 4)
endif
endmacro

macro Op43()
	%readbyte(Input1)
if !Pass == 1
	print "	ROL.b $",hex(!Input1, 2)
endif
endmacro

macro Op44()
	%readword(Input1)
if !Pass == 1
	print "	ROL.w $",hex(!Input1, 4)
endif
endmacro

macro Op45()
if !Pass == 1
	print "	PUSH A"
endif
endmacro

macro Op46()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	CBNE.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op47()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BRA.b CODE_",hex(!Input1, 4)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op48()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BMI.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op49()
if !Pass == 1
	print "	TCALL 3"
endif
endmacro

macro Op50()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR1.b $",hex(!Input1, 2)
endif
endmacro

macro Op51()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC1.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op52()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op53()
	%readword(Input1)
if !Pass == 1
	print "	AND.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op54()
	%readword(Input1)
if !Pass == 1
	print "	AND.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op55()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op56()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op57()
if !Pass == 1
	print "	AND (X), (Y)"
endif
endmacro

macro Op58()
	%readbyte(Input1)
if !Pass == 1
	print "	INCW.b $",hex(!Input1, 2)
endif
endmacro

macro Op59()
	%readbyte(Input1)
if !Pass == 1
	print "	ROL.b $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op60()
if !Pass == 1
	print "	ROL A"
endif
endmacro

macro Op61()
if !Pass == 1
	print "	INC X"
endif
endmacro

macro Op62()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b X, $",hex(!Input1, 2)
endif
endmacro

macro Op63()
	%readword(Input1)
	%HandleAbsoluteAddressJump()
if !Pass == 1
	print "	CALL.w CODE_",hex(!Input1, 4)
endif
endmacro

macro Op64()
if !Pass == 1
	print "	SETP"
endif
endmacro

macro Op65()
if !Pass == 1
	print "	TCALL 4"
endif
endmacro

macro Op66()
	%readbyte(Input1)
if !Pass == 1
	print "	SET2.b $",hex(!Input1, 2)
endif
endmacro

macro Op67()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS2.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op68()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op69()
	%readword(Input1)
if !Pass == 1
	print "	EOR.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op70()
if !Pass == 1
	print "	EOR A, (X)"
endif
endmacro

macro Op71()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op72()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op73()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op74()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	AND",hex(!TEMP2, 1),".w C, $",hex(!Input1, 4)
endif
endmacro

macro Op75()
	%readbyte(Input1)
if !Pass == 1
	print "	LSR.b $",hex(!Input1, 2)
endif
endmacro

macro Op76()
	%readword(Input1)
if !Pass == 1
	print "	LSR.w $",hex(!Input1, 4)
endif
endmacro

macro Op77()
if !Pass == 1
	print "	PUSH X"
endif
endmacro

macro Op78()
	%readword(Input1)
if !Pass == 1
	print "	TCLR.w $",hex(!Input1, 4),", A"
endif
endmacro

macro Op79()
	%readbyte(Input1)
if !Pass == 1
	print "	PCALL.w $FF",hex(!Input1, 2)
endif
endmacro

macro Op80()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BVC.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op81()
if !Pass == 1
	print "	TCALL 5"
endif
endmacro

macro Op82()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR2.b $",hex(!Input1, 2)
endif
endmacro

macro Op83()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC2.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op84()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op85()
	%readword(Input1)
if !Pass == 1
	print "	EOR.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op86()
	%readword(Input1)
if !Pass == 1
	print "	EOR.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op87()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op88()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op89()
if !Pass == 1
	print "	EOR (X), (Y)"
endif
endmacro

macro Op90()
	%readbyte(Input1)
if !Pass == 1
	print "	CMPW.b YA, $",hex(!Input1, 2)
endif
endmacro

macro Op91()
	%readbyte(Input1)
if !Pass == 1
	print "	LSR.b $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op92()
if !Pass == 1
	print "	LSR A"
endif
endmacro

macro Op93()
if !Pass == 1
	print "	MOV X, A"
endif
endmacro

macro Op94()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w Y, $",hex(!Input1, 4)
endif
endmacro

macro Op95()
	%readword(Input1)
	%HandleAbsoluteAddressJump()
if !Pass == 1
	print "	JMP.w CODE_",hex(!Input1, 4)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op96()
if !Pass == 1
	print "	CLRC"
endif
endmacro

macro Op97()
if !Pass == 1
	print "	TCALL 6"
endif
endmacro

macro Op98()
	%readbyte(Input1)
if !Pass == 1
	print "	SET3.b $",hex(!Input1, 2)
endif
endmacro

macro Op99()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS3.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op100()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op101()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op102()
if !Pass == 1
	print "	CMP A, (X)"
endif
endmacro

macro Op103()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op104()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op105()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op106()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	AND",hex(!TEMP2, 1),".w C, !$",hex(!Input1, 4)
endif
endmacro

macro Op107()
	%readbyte(Input1)
if !Pass == 1
	print "	ROR.b $",hex(!Input1, 2)
endif
endmacro

macro Op108()
	%readword(Input1)
if !Pass == 1
	print "	ROR.w $",hex(!Input1, 4)
endif
endmacro

macro Op109()
if !Pass == 1
	print "	PUSH Y"
endif
endmacro

macro Op110()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	DBNZ.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op111()
if !Pass == 1
	print "	RET"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op112()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BVS.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op113()
if !Pass == 1
	print "	TCALL 7"
endif
endmacro

macro Op114()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR3.b $",hex(!Input1, 2)
endif
endmacro

macro Op115()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC3.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op116()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op117()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op118()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op119()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op120()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op121()
if !Pass == 1
	print "	CMP (X), (Y)"
endif
endmacro

macro Op122()
	%readbyte(Input1)
if !Pass == 1
	print "	ADDW.b YA, $",hex(!Input1, 2)
endif
endmacro

macro Op123()
	%readbyte(Input1)
if !Pass == 1
	print "	ROR.b $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op124()
if !Pass == 1
	print "	ROR A"
endif
endmacro

macro Op125()
if !Pass == 1
	print "	MOV A, X"
endif
endmacro

macro Op126()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b Y, $",hex(!Input1, 2)
endif
endmacro

macro Op127()
if !Pass == 1
	print "	RETI"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op128()
if !Pass == 1
	print "	SETC"
endif
endmacro

macro Op129()
if !Pass == 1
	print "	TCALL 8"
endif
endmacro

macro Op130()
	%readbyte(Input1)
if !Pass == 1
	print "	SET4.b $",hex(!Input1, 2)
endif
endmacro

macro Op131()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS4.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op132()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op133()
	%readword(Input1)
if !Pass == 1
	print "	ADC.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op134()
if !Pass == 1
	print "	ADC A, (X)"
endif
endmacro

macro Op135()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op136()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op137()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op138()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	EOR",hex(!TEMP2, 1),".w C, $",hex(!Input1, 4)
endif
endmacro

macro Op139()
	%readbyte(Input1)
if !Pass == 1
	print "	DEC.b $",hex(!Input1, 2)
endif
endmacro

macro Op140()
	%readword(Input1)
if !Pass == 1
	print "	DEC.w $",hex(!Input1, 4)
endif
endmacro

macro Op141()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b Y, #$",hex(!Input1, 2)
endif
endmacro

macro Op142()
if !Pass == 1
	print "	POP P"
endif
endmacro

macro Op143()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op144()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BCC.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op145()
if !Pass == 1
	print "	TCALL 9"
endif
endmacro

macro Op146()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR4.b $",hex(!Input1, 2)
endif
endmacro

macro Op147()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC4.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op148()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op149()
	%readword(Input1)
if !Pass == 1
	print "	ADC.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op150()
	%readword(Input1)
if !Pass == 1
	print "	ADC.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op151()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op152()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op153()
if !Pass == 1
	print "	ADC (X), (Y)"
endif
endmacro

macro Op154()
	%readbyte(Input1)
if !Pass == 1
	print "	SUBW.b YA, $",hex(!Input1, 2)
endif
endmacro

macro Op155()
	%readbyte(Input1)
if !Pass == 1
	print "	DEC.b $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op156()
if !Pass == 1
	print "	DEC A"
endif
endmacro

macro Op157()
if !Pass == 1
	print "	MOV X, SP"
endif
endmacro

macro Op158()
if !Pass == 1
	print "	DIV YA, X"
endif
endmacro

macro Op159()
if !Pass == 1
	print "	XCN A"
endif
endmacro

macro Op160()
if !Pass == 1
	print "	EI"
endif
endmacro

macro Op161()
if !Pass == 1
	print "	TCALL 10"
endif
endmacro

macro Op162()
	%readbyte(Input1)
if !Pass == 1
	print "	SET5.b $",hex(!Input1, 2)
endif
endmacro

macro Op163()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS5.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op164()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op165()
	%readword(Input1)
if !Pass == 1
	print "	SBC.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op166()
if !Pass == 1
	print "	SBC A, (X)"
endif
endmacro

macro Op167()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op168()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op169()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op170()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	MOV",hex(!TEMP2, 1),".w C, $",hex(!Input1, 4)
endif
endmacro

macro Op171()
	%readbyte(Input1)
if !Pass == 1
	print "	INC.b $",hex(!Input1, 2)
endif
endmacro

macro Op172()
	%readword(Input1)
if !Pass == 1
	print "	INC.w $",hex(!Input1, 4)
endif
endmacro

macro Op173()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b Y, #$",hex(!Input1, 2)
endif
endmacro

macro Op174()
if !Pass == 1
	print "	POP A"
endif
endmacro

macro Op175()
if !Pass == 1
	print "	MOV (X+), A"
endif
endmacro

macro Op176()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BCS.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op177()
if !Pass == 1
	print "	TCALL 11"
endif
endmacro

macro Op178()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR5.b $",hex(!Input1, 2)
endif
endmacro

macro Op179()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC5.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op180()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op181()
	%readword(Input1)
if !Pass == 1
	print "	SBC.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op182()
	%readword(Input1)
if !Pass == 1
	print "	SBC.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op183()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op184()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b $",hex(!Input1, 2),", #$",hex(!Input2, 2)
endif
endmacro

macro Op185()
if !Pass == 1
	print "	SBC (X), (Y)"
endif
endmacro

macro Op186()
	%readbyte(Input1)
if !Pass == 1
	print "	MOVW.b YA, $",hex(!Input1, 2)
endif
endmacro

macro Op187()
	%readbyte(Input1)
if !Pass == 1
	print "	INC.b $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op188()
if !Pass == 1
	print "	INC A"
endif
endmacro

macro Op189()
if !Pass == 1
	print "	MOV SP, X"
endif
endmacro

macro Op190()
if !Pass == 1
	print "	DAS A"
endif
endmacro

macro Op191()
if !Pass == 1
	print "	MOV A, (X+)"
endif
endmacro

macro Op192()
if !Pass == 1
	print "	DI"
endif
endmacro

macro Op193()
if !Pass == 1
	print "	TCALL 12"
endif
endmacro

macro Op194()
	%readbyte(Input1)
if !Pass == 1
	print "	SET6.b $",hex(!Input1, 2)
endif
endmacro

macro Op195()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS6.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op196()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),", A"
endif
endmacro

macro Op197()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w $",hex(!Input1, 4),", A"
endif
endmacro

macro Op198()
if !Pass == 1
	print "	MOV (X), A"
endif
endmacro

macro Op199()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b ($",hex(!Input1, 2),"+x), A"
endif
endmacro

macro Op200()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b X, #$",hex(!Input1, 2)
endif
endmacro

macro Op201()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w $",hex(!Input1, 4),", X"
endif
endmacro

macro Op202()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	MOV",hex(!TEMP2, 1),".w $",hex(!Input1, 4),", C"
endif
endmacro

macro Op203()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),", Y"
endif
endmacro

macro Op204()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w $",hex(!Input1, 4),", Y"
endif
endmacro

macro Op205()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b X, #$",hex(!Input1, 2)
endif
endmacro

macro Op206()
if !Pass == 1
	print "	POP X"
endif
endmacro

macro Op207()
if !Pass == 1
	print "	MUL YA"
endif
endmacro

macro Op208()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BNE.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op209()
if !Pass == 1
	print "	TCALL 13"
endif
endmacro

macro Op210()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR6.b $",hex(!Input1, 2)
endif
endmacro

macro Op211()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC6.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op212()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),"+x, A"
endif
endmacro

macro Op213()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w $",hex(!Input1, 4),"+x, A"
endif
endmacro

macro Op214()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w $",hex(!Input1, 4),"+y, A"
endif
endmacro

macro Op215()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b ($",hex(!Input1, 2),")+y, A"
endif
endmacro

macro Op216()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),", X"
endif
endmacro

macro Op217()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),"+y, X"
endif
endmacro

macro Op218()
	%readbyte(Input1)
if !Pass == 1
	print "	MOVW.b $",hex(!Input1, 2),", YA"
endif
endmacro

macro Op219()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),"+x, Y"
endif
endmacro

macro Op220()
if !Pass == 1
	print "	DEC Y"
endif
endmacro

macro Op221()
if !Pass == 1
	print "	MOV A, Y"
endif
endmacro

macro Op222()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	CBNE.b $",hex(!Input2, 2),"+x, CODE_",hex(!Input1, 4)
endif
endmacro

macro Op223()
if !Pass == 1
	print "	DAA A"
endif
endmacro

macro Op224()
if !Pass == 1
	print "	CLRV"
endif
endmacro

macro Op225()
if !Pass == 1
	print "	TCALL 14"
endif
endmacro

macro Op226()
	%readbyte(Input1)
if !Pass == 1
	print "	SET7.b $",hex(!Input1, 2)
endif
endmacro

macro Op227()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBS7.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op228()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b A, $",hex(!Input1, 2)
endif
endmacro

macro Op229()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w A, $",hex(!Input1, 4)
endif
endmacro

macro Op230()
if !Pass == 1
	print "	MOV A, (X)"
endif
endmacro

macro Op231()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b A, ($",hex(!Input1, 2),"+x)"
endif
endmacro

macro Op232()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b A, #$",hex(!Input1, 2)
endif
endmacro

macro Op233()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w X, $",hex(!Input1, 4)
endif
endmacro

macro Op234()
	%readword(Input1)
	%AdjustMemBitOpcodeOutput()
if !Pass == 1
	print "	NOT",hex(!TEMP2, 1),".w C, $",hex(!Input1, 4)
endif
endmacro

macro Op235()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b Y, $",hex(!Input1, 2)
endif
endmacro

macro Op236()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w Y, $",hex(!Input1, 4)
endif
endmacro

macro Op237()
if !Pass == 1
	print "	NOTC"
endif
endmacro

macro Op238()
if !Pass == 1
	print "	POP Y"
endif
endmacro

macro Op239()
if !Pass == 1
	print "	SLEEP"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op240()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BEQ.b CODE_",hex(!Input1, 4)
endif
endmacro

macro Op241()
if !Pass == 1
	print "	TCALL 15"
endif
endmacro

macro Op242()
	%readbyte(Input1)
if !Pass == 1
	print "	CLR7.b $",hex(!Input1, 2)
endif
endmacro

macro Op243()
	%readbyte(Input2)
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BBC7.b $",hex(!Input2, 2),", CODE_",hex(!Input1, 4)
endif
endmacro

macro Op244()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b A, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op245()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w A, $",hex(!Input1, 4),"+x"
endif
endmacro

macro Op246()
	%readword(Input1)
if !Pass == 1
	print "	MOV.w A, $",hex(!Input1, 4),"+y"
endif
endmacro

macro Op247()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b A, ($",hex(!Input1, 2),")+y"
endif
endmacro

macro Op248()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b X, $",hex(!Input1, 2)
endif
endmacro

macro Op249()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b X, $",hex(!Input1, 2),"+y"
endif
endmacro

macro Op250()
	%readbyte(Input2)
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b $",hex(!Input1, 2),", $",hex(!Input2, 2)
endif
endmacro

macro Op251()
	%readbyte(Input1)
if !Pass == 1
	print "	MOV.b Y, $",hex(!Input1, 2),"+x"
endif
endmacro

macro Op252()
if !Pass == 1
	print "	INC Y"
endif
endmacro

macro Op253()
if !Pass == 1
	print "	MOV Y, A"
endif
endmacro

macro Op254()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	DBNZ.b Y, CODE_",hex(!Input1, 4)
endif
endmacro

macro Op255()
if !Pass == 1
	print "	STOP"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

%HandleJump(!CurrentOffset)
org !ROMOffset
!InLoop = 1
!BlockSizeWarning = 0
print "Disassembling from !ROMOffset"
if !DoTwoPassesFlag == 0
	!Pass = 1
endif

!CopyOfSizeOfBlock #= !SizeOfBlock

while !Pass < 2
	!TotalBlockSize #= $0000
	!BaseOffsetOffset #= $0000
	!ByteCounter #= 0
	!InLoop #= 1
	while !InLoop != 0
		if !ReadSizeOffset == 1
			!SizeOfBlock #= read2(!ROMOffset+!TotalBlockSize)
			!TotalBlockSize #= !TotalBlockSize+2
		else
			!SizeOfBlock #= !CopyOfSizeOfBlock
		endif
		if !SizeOfBlock < 1
			!InLoop #= 0
		endif
		if !GetBaseOffsetFromROM == 1
			!BaseOffset #= read2(!ROMOffset+!TotalBlockSize)
			!BaseOffsetOffset #= $0000
			!TotalBlockSize #= !TotalBlockSize+2
		endif
		!CurrentBlockSize #= !SizeOfBlock
		if !SizeOfBlock > 1
			if !Pass == 1
				print "%SPCDataBlockStart(",hex(!BaseOffset, 4),")"
			endif
		endif
		while !SizeOfBlock > 0
			if !Pass == 1
				%PrintLabel(!CurrentOffset)
			endif
			%GetOpcode()
			%Op!Input1()
			!LoopCounter #= !LoopCounter+1
			if !ByteCounter >= !MaxBytes
				!SizeOfBlock #= $0000
				!InLoop #= 0
				if !Pass == 1
					print "%SPCDataBlockEnd(",hex(!BaseOffset, 4),")"
					print ""
				endif
			endif
			if  !SizeOfBlock < 1
				if !SizeOfBlock != 0
					!BlockSizeWarning = 1
				endif
				!SizeOfBlock #= $0000
				if !Pass == 1
					print "%SPCDataBlockEnd(",hex(!BaseOffset, 4),")"
					print ""
				endif
			endif
		endwhile
		!TotalBlockSize #= !TotalBlockSize+!CurrentBlockSize
	endwhile
	!Pass #= !Pass+1
	!CurrentOffset #= !ROMOffset
	!LoopCounter #= 0
endwhile
print "%EndSPCUploadAndJumpToEngine($!EngineOffset)"

!Input1 #= !ROMOffset+!BaseOffsetOffset+!TotalBlockSize
print "Disassembly has ended at $",hex(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize, 6)

if !ReadSizeOffset == 0
	!Input1 #= !BaseOffset+!BaseOffsetOffset
	print "Base Offset has ended at $",hex(!BaseOffset+!BaseOffsetOffset, 4)
endif

if !BlockSizeWarning != 0
	print "Warning, one or more data blocks disassembled more bytes than the specified size. Closer inspection is needed."
endif
