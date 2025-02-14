asar 1.91

; Modify these as needed
lorom								; The memory map of the ROM. Change this if the ROM uses a different memory map, or else the output may be wrong.
!CorrectErrorsFlag = 1			; If 1, this script will change the size of A/X/Y in some situations besides REP/SEP. For example, if the instruction after an LDA.b #$00 is BRK, A will be changed to 16-bit.
!16BitA = 0						; If 1, A will start off as 16-bit during disassembly. Otherwise, it will be 8-bit
!16BitXY = 0						; If 1, X/Y will start off as 16-bit during disassembly. Otherwise, they'll be 8-bit
!ROMOffset = $008000				; The ROM offset to begin disassembly from.
!Bank = 00							; Affects the bank byte for the label used in JSR/JMP instructions.
!DoTwoPassesFlag = 1				; If 1, the script will run twice, with the purpose of generating labels that appear before the branch that points to it. Turning this on may slow down disassembly speed, however.
!MaxBytes = 32768					; The maximum amount of bytes that will be read at a time. Setting this lower/higher will speed up/slow down disassembly.

; Don't touch these
!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!Pass = 0
!CurrentOffset #= !ROMOffset
!InitialASize #= !16BitA
!InitialXYSize #= !16BitXY

macro GetOpcode()
	!Input1 #= read1(!ROMOffset+!ByteCounter)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readbyte(Input)
	!<Input> #= read1(!ROMOffset+!ByteCounter)
	;!<Input> = $01
	!ByteCounter #= !ByteCounter+1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readword(Input)
	!<Input> #= read2(!ROMOffset+!ByteCounter)
	;!Input1 = $0123
	!ByteCounter #= !ByteCounter+2
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readlong(Input)
	!<Input> #= read3(!ROMOffset+!ByteCounter)
	;!Input1 = $012345
	!ByteCounter #= !ByteCounter+3
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro HandleBranch(Value, ByteCounter)
if !Input1 >= <Value>
	if <Value> == $80
		!Input1 #= (!ROMOffset+!ByteCounter)-((!Input1^$FF)+$01)
	else
		!Input1 #= (!ROMOffset+!ByteCounter)-((!Input1^$FFFF)+$01)
	endif
else
	!Input1 #= (!ROMOffset+!ByteCounter)+!Input1
endif
	%GetBranchLabelLocation(!Input1)
endmacro

macro PrintLabel(Address)
if defined("ROM_<Address>") == 1
	if !ROM_<Address> == 1
		print ""
	endif
	print "CODE_",hex(!ROMOffset+!ByteCounter, 6),":"
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

macro HandleJump(Address)
if defined("ROM_<Address>") == 0
	!ROM_<Address> = 0
endif
endmacro

macro CheckForASizeError()
if !CorrectErrorsFlag == 1
	if !16BitA == 0
		if read1(!ROMOffset+!ByteCounter+1) == $00
			!16BitA #= 1
		elseif read1(!ROMOffset+!ByteCounter+1) == $02
			!16BitA #= 1
		endif
	else
		if read1(!ROMOffset+!ByteCounter+2) == $00
			!16BitA #= 0
		elseif read1(!ROMOffset+!ByteCounter+2) == $02
			!16BitA #= 0
		endif
	endif
endif
endmacro

macro CheckForXYSizeError()
if !CorrectErrorsFlag == 1
	if !16BitXY == 0
		if read1(!ROMOffset+!ByteCounter+1) == $00
			!16BitXY #= 1
		elseif read1(!ROMOffset+!ByteCounter+1) == $02
			!16BitXY #= 1
		endif
	else
		if read1(!ROMOffset+!ByteCounter+2) == $00
			!16BitXY #= 0
		elseif read1(!ROMOffset+!ByteCounter+2) == $02
			!16BitXY #= 0
		endif
	endif
endif
endmacro

macro Op0()
	%readbyte(Input1)
if !Pass == 1
	print "	BRK.b #$",hex(!Input1, 2)
endif
endmacro

macro Op1()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op2()
	%readbyte(Input1)
if !Pass == 1
	print "	COP.b #$",hex(!Input1, 2)
endif
endmacro

macro Op3()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op4()
	%readbyte(Input1)
if !Pass == 1
	print "	TSB.b $",hex(!Input1, 2)
endif
endmacro

macro Op5()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b $",hex(!Input1, 2)
endif
endmacro

macro Op6()
	%readbyte(Input1)
if !Pass == 1
	print "	ASL.b $",hex(!Input1, 2)
endif
endmacro

macro Op7()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op8()
if !Pass == 1
	print "	PHP"
endif
endmacro

macro Op9()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	ORA.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	ORA.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op10()
if !Pass == 1
	print "	ASL"
endif
endmacro

macro Op11()
if !Pass == 1
	print "	PHD"
endif
endmacro

macro Op12()
	%readword(Input1)
if !Pass == 1
	print "	TSB.w $",hex(!Input1, 4)
endif
endmacro

macro Op13()
	%readword(Input1)
if !Pass == 1
	print "	ORA.w $",hex(!Input1, 4)
endif
endmacro

macro Op14()
	%readword(Input1)
if !Pass == 1
	print "	ASL.w $",hex(!Input1, 4)
endif
endmacro

macro Op15()
	%readlong(Input1)
if !Pass == 1
	print "	ORA.l $",hex(!Input1, 6)
endif
endmacro

macro Op16()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BPL.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op17()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op18()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op19()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op20()
	%readbyte(Input1)
if !Pass == 1
	print "	TRB.b $",hex(!Input1, 2)
endif
endmacro

macro Op21()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op22()
	%readbyte(Input1)
if !Pass == 1
	print "	ASL.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op23()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op24()
if !Pass == 1
	print "	CLC"
endif
endmacro

macro Op25()
	%readword(Input1)
if !Pass == 1
	print "	ORA.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op26()
if !Pass == 1
	print "	INC"
endif
endmacro

macro Op27()
if !Pass == 1
	print "	TCS"
endif
endmacro

macro Op28()
	%readword(Input1)
if !Pass == 1
	print "	TRB.w $",hex(!Input1, 4)
endif
endmacro

macro Op29()
	%readword(Input1)
if !Pass == 1
	print "	ORA.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op30()
	%readword(Input1)
if !Pass == 1
	print "	ASL.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op31()
	%readlong(Input1)
if !Pass == 1
	print "	ORA.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op32()
	%readword(Input1)
	!Input2 #= !Input1+($!Bank<<16)
	%HandleJump(!Input2)
if !Pass == 1
	print "	JSR.w CODE_!Bank",hex(!Input1, 4)
endif
endmacro

macro Op33()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op34()
	%readlong(Input1)
	%HandleJump(!Input1)
if !Pass == 1
	print "	JSL.l CODE_",hex(!Input1, 6)
endif
endmacro

macro Op35()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op36()
	%readbyte(Input1)
if !Pass == 1
	print "	BIT.b $",hex(!Input1, 2)
endif
endmacro

macro Op37()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b $",hex(!Input1, 2)
endif
endmacro

macro Op38()
	%readbyte(Input1)
if !Pass == 1
	print "	ROL.b $",hex(!Input1, 2)
endif
endmacro

macro Op39()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op40()
if !Pass == 1
	print "	PLP"
endif
endmacro

macro Op41()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	AND.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	AND.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op42()
if !Pass == 1
	print "	ROL"
endif
endmacro

macro Op43()
if !Pass == 1
	print "	PLD"
endif
endmacro

macro Op44()
	%readword(Input1)
if !Pass == 1
	print "	BIT.w $",hex(!Input1, 4)
endif
endmacro

macro Op45()
	%readword(Input1)
if !Pass == 1
	print "	AND.w $",hex(!Input1, 4)
endif
endmacro

macro Op46()
	%readword(Input1)
if !Pass == 1
	print "	ROL.w $",hex(!Input1, 4)
endif
endmacro

macro Op47()
	%readlong(Input1)
if !Pass == 1
	print "	AND.l $",hex(!Input1, 6)
endif
endmacro

macro Op48()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BMI.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op49()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op50()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op51()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op52()
	%readbyte(Input1)
if !Pass == 1
	print "	BIT.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op53()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op54()
	%readbyte(Input1)
if !Pass == 1
	print "	ROL.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op55()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op56()
if !Pass == 1
	print "	SEC"
endif
endmacro

macro Op57()
	%readword(Input1)
if !Pass == 1
	print "	AND.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op58()
if !Pass == 1
	print "	DEC"
endif
endmacro

macro Op59()
if !Pass == 1
	print "	TSC"
endif
endmacro

macro Op60()
	%readword(Input1)
if !Pass == 1
	print "	BIT.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op61()
	%readword(Input1)
if !Pass == 1
	print "	AND.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op62()
	%readword(Input1)
if !Pass == 1
	print "	ROL.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op63()
	%readlong(Input1)
if !Pass == 1
	print "	AND.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op64()
if !Pass == 1
	print "	RTI"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op65()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op66()
	%readbyte(Input1)
if !Pass == 1
	print "	WDM #$",hex(!Input1, 2)
endif
endmacro

macro Op67()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op68()
	%readbyte(Input1)
	%readbyte(Input2)
if !Pass == 1
	print "	MVP $",hex(!Input1, 2),"0000>>16,$",hex(!Input2, 2),"0000>>16"
endif
endmacro

macro Op69()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b $",hex(!Input1, 2)
endif
endmacro

macro Op70()
	%readbyte(Input1)
if !Pass == 1
	print "	LSR.b $",hex(!Input1, 2)
endif
endmacro

macro Op71()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op72()
if !Pass == 1
	print "	PHA"
endif
endmacro

macro Op73()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	EOR.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	EOR.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op74()
if !Pass == 1
	print "	LSR"
endif
endmacro

macro Op75()
if !Pass == 1
	print "	PHK"
endif
endmacro

macro Op76()
	%readword(Input1)
	!Input2 #= !Input1+($!Bank<<16)
	%HandleJump(!Input2)
if !Pass == 1
	print "	JMP.w CODE_!Bank",hex(!Input1, 4)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op77()
	%readword(Input1)
if !Pass == 1
	print "	EOR.w $",hex(!Input1, 4)
endif
endmacro

macro Op78()
	%readword(Input1)
if !Pass == 1
	print "	LSR.w $",hex(!Input1, 4)
endif
endmacro

macro Op79()
	%readlong(Input1)
if !Pass == 1
	print "	EOR.l $",hex(!Input1, 6)
endif
endmacro

macro Op80()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BVC.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op81()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op82()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op83()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op84()
	%readbyte(Input1)
	%readbyte(Input2)
if !Pass == 1
	print "	MVN $",hex(!Input1, 2),"0000>>16,$",hex(!Input2, 2),"0000>>16"
endif
endmacro

macro Op85()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op86()
	%readbyte(Input1)
if !Pass == 1
	print "	LSR.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op87()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op88()
if !Pass == 1
	print "	CLI"
endif
endmacro

macro Op89()
	%readword(Input1)
if !Pass == 1
	print "	EOR.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op90()
if !Pass == 1
	print "	PHY"
endif
endmacro

macro Op91()
if !Pass == 1
	print "	TCD"
endif
endmacro

macro Op92()
	%readlong(Input1)
	%HandleJump(!Input1)
if !Pass == 1
	print "	JML.l CODE_",hex(!Input1, 6)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op93()
	%readword(Input1)
if !Pass == 1
	print "	EOR.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op94()
	%readword(Input1)
if !Pass == 1
	print "	LSR.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op95()
	%readlong(Input1)
if !Pass == 1
	print "	EOR.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op96()
if !Pass == 1
	print "	RTS"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op97()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op98()
	%readword(Input1)
	%HandleBranch($8000, !ByteCounter+$01)
if !Pass == 1
	print "	PER.w CODE_",hex(!Input1+$01, 6),"-$01"
endif
endmacro

macro Op99()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op100()
	%readbyte(Input1)
if !Pass == 1
	print "	STZ.b $",hex(!Input1, 2)
endif
endmacro

macro Op101()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b $",hex(!Input1, 2)
endif
endmacro

macro Op102()
	%readbyte(Input1)
if !Pass == 1
	print "	ROR.b $",hex(!Input1, 2)
endif
endmacro

macro Op103()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op104()
if !Pass == 1
	print "	PLA"
endif
endmacro

macro Op105()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	ADC.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	ADC.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op106()
if !Pass == 1
	print "	ROR"
endif
endmacro

macro Op107()
if !Pass == 1
	print "	RTL"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op108()
	%readword(Input1)
if !Pass == 1
	print "	JMP.w ($",hex(!Input1, 4),")"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op109()
	%readword(Input1)
if !Pass == 1
	print "	ADC.w $",hex(!Input1, 4)
endif
endmacro

macro Op110()
	%readword(Input1)
if !Pass == 1
	print "	ROR.w $",hex(!Input1, 4)
endif
endmacro

macro Op111()
	%readlong(Input1)
if !Pass == 1
	print "	ADC.l $",hex(!Input1, 6)
endif
endmacro

macro Op112()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BVS.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op113()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op114()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op115()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op116()
	%readbyte(Input1)
if !Pass == 1
	print "	STZ.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op117()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op118()
	%readbyte(Input1)
if !Pass == 1
	print "	ROR.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op119()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op120()
if !Pass == 1
	print "	SEI"
endif
endmacro

macro Op121()
	%readword(Input1)
if !Pass == 1
	print "	ADC.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op122()
if !Pass == 1
	print "	PLY"
endif
endmacro

macro Op123()
if !Pass == 1
	print "	TDC"
endif
endmacro

macro Op124()
	%readword(Input1)
if !Pass == 1
	print "	JMP.w ($",hex(!Input1, 4),",x)"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op125()
	%readword(Input1)
if !Pass == 1
	print "	ADC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op126()
	%readword(Input1)
if !Pass == 1
	print "	ROR.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op127()
	%readlong(Input1)
if !Pass == 1
	print "	ADC.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op128()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BRA.b CODE_",hex(!Input1, 6)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op129()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op130()
	%readword(Input1)
	%HandleBranch($8000, !ByteCounter)
if !Pass == 1
	print "	BRL.w CODE_",hex(!Input1, 6)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op131()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op132()
	%readbyte(Input1)
if !Pass == 1
	print "	STY.b $",hex(!Input1, 2)
endif
endmacro

macro Op133()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b $",hex(!Input1, 2)
endif
endmacro

macro Op134()
	%readbyte(Input1)
if !Pass == 1
	print "	STX.b $",hex(!Input1, 2)
endif
endmacro

macro Op135()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op136()
if !Pass == 1
	print "	DEY"
endif
endmacro

macro Op137()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	BIT.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	BIT.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op138()
if !Pass == 1
	print "	TXA"
endif
endmacro

macro Op139()
if !Pass == 1
	print "	PHB"
endif
endmacro

macro Op140()
	%readword(Input1)
if !Pass == 1
	print "	STY.w $",hex(!Input1, 4)
endif
endmacro

macro Op141()
	%readword(Input1)
if !Pass == 1
	print "	STA.w $",hex(!Input1, 4)
endif
endmacro

macro Op142()
	%readword(Input1)
if !Pass == 1
	print "	STX.w $",hex(!Input1, 4)
endif
endmacro

macro Op143()
	%readlong(Input1)
if !Pass == 1
	print "	STA.l $",hex(!Input1, 6)
endif
endmacro

macro Op144()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BCC.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op145()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op146()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op147()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op148()
	%readbyte(Input1)
if !Pass == 1
	print "	STY.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op149()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op150()
	%readbyte(Input1)
if !Pass == 1
	print "	STX.b $",hex(!Input1, 2),",y"
endif
endmacro

macro Op151()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op152()
if !Pass == 1
	print "	TYA"
endif
endmacro

macro Op153()
	%readword(Input1)
if !Pass == 1
	print "	STA.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op154()
if !Pass == 1
	print "	TXS"
endif
endmacro

macro Op155()
if !Pass == 1
	print "	TXY"
endif
endmacro

macro Op156()
	%readword(Input1)
if !Pass == 1
	print "	STZ.w $",hex(!Input1, 4)
endif
endmacro

macro Op157()
	%readword(Input1)
if !Pass == 1
	print "	STA.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op158()
	%readword(Input1)
if !Pass == 1
	print "	STZ.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op159()
	%readlong(Input1)
if !Pass == 1
	print "	STA.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op160()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	LDY.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	LDY.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op161()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op162()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	LDX.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	LDX.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op163()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op164()
	%readbyte(Input1)
if !Pass == 1
	print "	LDY.b $",hex(!Input1, 2)
endif
endmacro

macro Op165()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b $",hex(!Input1, 2)
endif
endmacro

macro Op166()
	%readbyte(Input1)
if !Pass == 1
	print "	LDX.b $",hex(!Input1, 2)
endif
endmacro

macro Op167()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op168()
if !Pass == 1
	print "	TAY"
endif
endmacro

macro Op169()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	LDA.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	LDA.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op170()
if !Pass == 1
	print "	TAX"
endif
endmacro

macro Op171()
if !Pass == 1
	print "	PLB"
endif
endmacro

macro Op172()
	%readword(Input1)
if !Pass == 1
	print "	LDY.w $",hex(!Input1, 4)
endif
endmacro

macro Op173()
	%readword(Input1)
if !Pass == 1
	print "	LDA.w $",hex(!Input1, 4)
endif
endmacro

macro Op174()
	%readword(Input1)
if !Pass == 1
	print "	LDX.w $",hex(!Input1, 4)
endif
endmacro

macro Op175()
	%readlong(Input1)
if !Pass == 1
	print "	LDA.l $",hex(!Input1, 6)
endif
endmacro

macro Op176()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BCS.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op177()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op178()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op179()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op180()
	%readbyte(Input1)
if !Pass == 1
	print "	LDY.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op181()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op182()
	%readbyte(Input1)
if !Pass == 1
	print "	LDX.b $",hex(!Input1, 2),",y"
endif
endmacro

macro Op183()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op184()
if !Pass == 1
	print "	CLV"
endif
endmacro

macro Op185()
	%readword(Input1)
if !Pass == 1
	print "	LDA.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op186()
if !Pass == 1
	print "	TSX"
endif
endmacro

macro Op187()
if !Pass == 1
	print "	TYX"
endif
endmacro

macro Op188()
	%readword(Input1)
if !Pass == 1
	print "	LDY.w $",hex(!Input1, 4),",x"	
endif
endmacro

macro Op189()
	%readword(Input1)
if !Pass == 1
	print "	LDA.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op190()
	%readword(Input1)
if !Pass == 1
	print "	LDX.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op191()
	%readlong(Input1)
if !Pass == 1
	print "	LDA.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op192()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	CPY.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	CPY.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op193()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op194()
	%readbyte(Input1)
	if !Input1&$20 == $20
		!16BitA #= 1
	endif
	if !Input1&$10 == $10
		!16BitXY #= 1
	endif
if !Pass == 1
	print "	REP.b #$",hex(!Input1, 2)
endif
endmacro

macro Op195()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op196()
	%readbyte(Input1)
if !Pass == 1
	print "	CPY.b $",hex(!Input1, 2)
endif
endmacro

macro Op197()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b $",hex(!Input1, 2)
endif
endmacro

macro Op198()
	%readbyte(Input1)
if !Pass == 1
	print "	DEC.b $",hex(!Input1, 2)
endif
endmacro

macro Op199()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op200()
if !Pass == 1
	print "	INY"
endif
endmacro

macro Op201()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	CMP.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	CMP.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op202()
if !Pass == 1
	print "	DEX"
endif
endmacro

macro Op203()
if !Pass == 1
	print "	WAI"
endif
endmacro

macro Op204()
	%readword(Input1)
if !Pass == 1
	print "	CPY.w $",hex(!Input1, 4)
endif
endmacro

macro Op205()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w $",hex(!Input1, 4)
endif
endmacro

macro Op206()
	%readword(Input1)
if !Pass == 1
	print "	DEC.w $",hex(!Input1, 4)
endif
endmacro

macro Op207()
	%readlong(Input1)
if !Pass == 1
	print "	CMP.l $",hex(!Input1, 6)
endif
endmacro

macro Op208()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BNE.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op209()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op210()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op211()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op212()
	%readbyte(Input1)
if !Pass == 1
	print "	PEI.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op213()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op214()
	%readbyte(Input1)
if !Pass == 1
	print "	DEC.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op215()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op216()
if !Pass == 1
	print "	CLD"
endif
endmacro

macro Op217()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op218()
if !Pass == 1
	print "	PHX"
endif
endmacro

macro Op219()
if !Pass == 1
	print "	STP"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op220()
	%readword(Input1)
if !Pass == 1
	print "	JMP.w [$",hex(!Input1, 4),"]"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op221()
	%readword(Input1)
if !Pass == 1
	print "	CMP.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op222()
	%readword(Input1)
if !Pass == 1
	print "	DEC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op223()
	%readlong(Input1)
if !Pass == 1
	print "	CMP.l $",hex(!Input1, 6),",x"
endif
endmacro

macro Op224()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	CPX.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	CPX.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op225()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op226()
	%readbyte(Input1)
	if !Input1&$20 == $20
		!16BitA #= 0
	endif
	if !Input1&$10 == $10
		!16BitXY #= 0
	endif
if !Pass == 1
	print "	SEP.b #$",hex(!Input1, 2)
endif
endmacro

macro Op227()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b $",hex(!Input1, 2),",S"
endif
endmacro

macro Op228()
	%readbyte(Input1)
if !Pass == 1
	print "	CPX.b $",hex(!Input1, 2)
endif
endmacro

macro Op229()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b $",hex(!Input1, 2)
endif
endmacro

macro Op230()
	%readbyte(Input1)
if !Pass == 1
	print "	INC.b $",hex(!Input1, 2)
endif
endmacro

macro Op231()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b [$",hex(!Input1, 2),"]"
endif
endmacro

macro Op232()
if !Pass == 1
	print "	INX"
endif
endmacro

macro Op233()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1)
		if !Pass == 1
			print "	SBC.b #$",hex(!Input1, 2)
		endif
	else
		%readword(Input1)
		if !Pass == 1
			print "	SBC.w #$",hex(!Input1, 4)
		endif
	endif
endmacro

macro Op234()
if !Pass == 1
	print "	NOP"
endif
endmacro

macro Op235()
if !Pass == 1
	print "	XBA"
endif
endmacro

macro Op236()
	%readword(Input1)
if !Pass == 1
	print "	CPX.w $",hex(!Input1, 4)
endif
endmacro

macro Op237()
	%readword(Input1)
if !Pass == 1
	print "	SBC.w $",hex(!Input1, 4)
endif
endmacro

macro Op238()
	%readword(Input1)
if !Pass == 1
	print "	INC.w $",hex(!Input1, 4)
endif
endmacro

macro Op239()
	%readlong(Input1)
if !Pass == 1
	print "	SBC.l $",hex(!Input1, 6)
endif
endmacro

macro Op240()
	%readbyte(Input1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BEQ.b CODE_",hex(!Input1, 6)
endif
endmacro

macro Op241()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b ($",hex(!Input1, 2),"),y"
endif
endmacro

macro Op242()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b ($",hex(!Input1, 2),")"
endif
endmacro

macro Op243()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b ($",hex(!Input1, 2),",S),y"
endif
endmacro

macro Op244()
	%readword(Input1)
if !Pass == 1
	print "	PEA.w $",hex(!Input1, 4)
endif
endmacro

macro Op245()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op246()
	%readbyte(Input1)
if !Pass == 1
	print "	INC.b $",hex(!Input1, 2),",x"
endif
endmacro

macro Op247()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b [$",hex(!Input1, 2),"],y"
endif
endmacro

macro Op248()
if !Pass == 1
	print "	SED"
endif
endmacro

macro Op249()
	%readword(Input1)
if !Pass == 1
	print "	SBC.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op250()
if !Pass == 1
	print "	PLX"
endif
endmacro

macro Op251()
if !Pass == 1
	print "	XCE"
endif
endmacro

macro Op252()
	%readword(Input1)
if !Pass == 1
	print "	JSR.w ($",hex(!Input1, 4),",x)"
endif
endmacro

macro Op253()
	%readword(Input1)
if !Pass == 1
	print "	SBC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op254()
	%readword(Input1)
if !Pass == 1
	print "	INC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op255()
	%readlong(Input1)
if !Pass == 1
	print "	SBC.l $",hex(!Input1, 6),",x"
endif
endmacro

%HandleJump(!CurrentOffset)
org !ROMOffset
if !DoTwoPassesFlag == 1
	while !ByteCounter < !MaxBytes
		%GetOpcode()
		%Op!Input1()
		!LoopCounter #= !LoopCounter+1
	endwhile
	!LoopCounter #= 0
	!ByteCounter #= 0
	!16BitA #= !InitialASize
	!16BitXY #= !InitialXYSize
	!CurrentOffset #= !ROMOffset
endif
	!Pass = 1
while !ByteCounter < !MaxBytes
	%PrintLabel(!CurrentOffset)
	%GetOpcode()
	%Op!Input1()
	!LoopCounter #= !LoopCounter+1
endwhile

!Input1 #= !ROMOffset+!ByteCounter
print "Disassembly has ended at $",hex(!ROMOffset+!ByteCounter, 6)
