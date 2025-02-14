asar 1.91

; Modify these as needed
lorom								; The memory map of the ROM. Change this if the ROM uses a different memory map, or else the output may be wrong.
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
!CurrentOffset = 0

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

macro readword()
	!Input1 #= read2(!ROMOffset+!ByteCounter)
	;!Input1 = $0123
	!ByteCounter #= !ByteCounter+2
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

macro Op0()
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
if !Pass == 1
	print "	Opcode 0x02"
endif
endmacro

macro Op3()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x03"
endif
endmacro

macro Op4()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x04"
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
	print "	Opcode 0x07"
endif
endmacro

macro Op8()
if !Pass == 1
	print "	PHP"
endif
endmacro

macro Op9()
	%readbyte(Input1)
if !Pass == 1
	print "	ORA.b #$",hex(!Input1, 2)
endif
endmacro

macro Op10()
if !Pass == 1
	print "	ASL"
endif
endmacro

macro Op11()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x0B"
endif
endmacro

macro Op12()
	%readword()
if !Pass == 1
	print "	Opcode 0x0C"
endif
endmacro

macro Op13()
	%readword()
if !Pass == 1
	print "	ORA.w $",hex(!Input1, 4)
endif
endmacro

macro Op14()
	%readword()
if !Pass == 1
	print "	ASL.w $",hex(!Input1, 4)
endif
endmacro

macro Op15()
	%readword()
if !Pass == 1
	print "	Opcode 0x0F"
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
if !Pass == 1
	print "	Opcode 0x12"
endif
endmacro

macro Op19()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x13"
endif
endmacro

macro Op20()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x14"
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
	print "	Opcode 0x17"
endif
endmacro

macro Op24()
if !Pass == 1
	print "	CLC"
endif
endmacro

macro Op25()
	%readword()
if !Pass == 1
	print "	ORA.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op26()
if !Pass == 1
	print "	Opcode 0x1A"
endif
endmacro

macro Op27()
if !Pass == 1
	print "	Opcode 0x1B"
endif
endmacro

macro Op28()
	%readword()
if !Pass == 1
	print "	Opcode 0x1C"
endif
endmacro

macro Op29()
	%readword()
if !Pass == 1
	print "	ORA.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op30()
	%readword()
if !Pass == 1
	print "	ASL.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op31()
	%readword()
if !Pass == 1
	print "	Opcode 0x1F"
endif
endmacro

macro Op32()
	%readword()
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
if !Pass == 1
	print "	Opcode 0x22"
endif
endmacro

macro Op35()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x23"
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
	print "	Opcode 0x27"
endif
endmacro

macro Op40()
if !Pass == 1
	print "	PLP"
endif
endmacro

macro Op41()
	%readbyte(Input1)
if !Pass == 1
	print "	AND.b #$",hex(!Input1, 2)
endif
endmacro

macro Op42()
if !Pass == 1
	print "	ROL"
endif
endmacro

macro Op43()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x2B"
endif
endmacro

macro Op44()
	%readword()
if !Pass == 1
	print "	BIT.w $",hex(!Input1, 4)
endif
endmacro

macro Op45()
	%readword()
if !Pass == 1
	print "	AND.w $",hex(!Input1, 4)
endif
endmacro

macro Op46()
	%readword()
if !Pass == 1
	print "	ROL.w $",hex(!Input1, 4)
endif
endmacro

macro Op47()
	%readword()
if !Pass == 1
	print "	Opcode 0x2F"
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
if !Pass == 1
	print "	Opcode 0x32"
endif
endmacro

macro Op51()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x33"
endif
endmacro

macro Op52()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x34"
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
	print "	Opcode 0x37"
endif
endmacro

macro Op56()
if !Pass == 1
	print "	SEC"
endif
endmacro

macro Op57()
	%readword()
if !Pass == 1
	print "	AND.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op58()
if !Pass == 1
	print "	Opcode 0x3A"
endif
endmacro

macro Op59()
	%readword()
if !Pass == 1
	print "	Opcode 0x3B"
endif
endmacro

macro Op60()
	%readword()
if !Pass == 1
	print "	Opcode 0x3C"
endif
endmacro

macro Op61()
	%readword()
if !Pass == 1
	print "	AND.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op62()
	%readword()
if !Pass == 1
	print "	ROL.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op63()
	%readword()
if !Pass == 1
	print "	Opcode 0x3F"
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
if !Pass == 1
	print "	Opcode 0x42"
endif
endmacro

macro Op67()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x43"
endif
endmacro

macro Op68()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x44"
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
	print "	Opcode 0x47"
endif
endmacro

macro Op72()
if !Pass == 1
	print "	PHA"
endif
endmacro

macro Op73()
	%readbyte(Input1)
if !Pass == 1
	print "	EOR.b #$",hex(!Input1, 2)
endif
endmacro

macro Op74()
if !Pass == 1
	print "	LSR"
endif
endmacro

macro Op75()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x4B"
endif
endmacro

macro Op76()
	%readword()
	!Input2 #= !Input1+($!Bank<<16)
	%HandleJump(!Input2)
if !Pass == 1
	print "	JMP.w CODE_!Bank",hex(!Input1, 4)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op77()
	%readword()
if !Pass == 1
	print "	EOR.w $",hex(!Input1, 4)
endif
endmacro

macro Op78()
	%readword()
if !Pass == 1
	print "	LSR.w $",hex(!Input1, 4)
endif
endmacro

macro Op79()
	%readword()
if !Pass == 1
	print "	Opcode 0x4F"
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
if !Pass == 1
	print "	Opcode 0x52"
endif
endmacro

macro Op83()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x53"
endif
endmacro

macro Op84()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x54"
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
	print "	Opcode 0x57"
endif
endmacro

macro Op88()
if !Pass == 1
	print "	CLI"
endif
endmacro

macro Op89()
	%readword()
if !Pass == 1
	print "	EOR.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op90()
if !Pass == 1
	print "	Opcode 0x5A"
endif
endmacro

macro Op91()
	%readword()
if !Pass == 1
	print "	Opcode 0x5B"
endif
endmacro

macro Op92()
	%readword()
if !Pass == 1
	print "	Opcode 0x5C"
endif
endmacro

macro Op93()
	%readword()
if !Pass == 1
	print "	EOR.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op94()
	%readword()
if !Pass == 1
	print "	LSR.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op95()
	%readword()
if !Pass == 1
	print "	Opcode 0x5F"
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
if !Pass == 1
	print "	Opcode 0x62"
endif
endmacro

macro Op99()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x63"
endif
endmacro

macro Op100()
if !Pass == 1
	print "	Opcode 0x64"
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
if !Pass == 1
	print "	Opcode 0x67"
endif
endmacro

macro Op104()
if !Pass == 1
	print "	PLA"
endif
endmacro

macro Op105()
	%readbyte(Input1)
if !Pass == 1
	print "	ADC.b #$",hex(!Input1, 2)
endif
endmacro

macro Op106()
if !Pass == 1
	print "	ROR"
endif
endmacro

macro Op107()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x6B"
endif
endmacro

macro Op108()
	%readword()
if !Pass == 1
	print "	JMP.w ($",hex(!Input1, 4),")"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op109()
	%readword()
if !Pass == 1
	print "	ADC.w $",hex(!Input1, 4)
endif
endmacro

macro Op110()
	%readword()
if !Pass == 1
	print "	ROR.w $",hex(!Input1, 4)
endif
endmacro

macro Op111()
	%readword()
if !Pass == 1
	print "	Opcode 0x6F"
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
if !Pass == 1
	print "	Opcode 0x72"
endif
endmacro

macro Op115()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x73"
endif
endmacro

macro Op116()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x74"
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
	print "	Opcode 0x77"
endif
endmacro

macro Op120()
if !Pass == 1
	print "	SEI"
endif
endmacro

macro Op121()
	%readword()
if !Pass == 1
	print "	ADC.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op122()
if !Pass == 1
	print "	Opcode 0x7A"
endif
endmacro

macro Op123()
	%readword()
if !Pass == 1
	print "	Opcode 0x7B"
endif
endmacro

macro Op124()
	%readword()
if !Pass == 1
	print "	Opcode 0x7C"
endif
endmacro

macro Op125()
	%readword()
if !Pass == 1
	print "	ADC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op126()
	%readword()
if !Pass == 1
	print "	ROR.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op127()
	%readword()
if !Pass == 1
	print "	Opcode 0x7F"
endif
endmacro

macro Op128()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x80"
endif
endmacro

macro Op129()
	%readbyte(Input1)
if !Pass == 1
	print "	STA.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op130()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x82"
endif
endmacro

macro Op131()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x83"
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
	print "	Opcode 0x87"
endif
endmacro

macro Op136()
if !Pass == 1
	print "	DEY"
endif
endmacro

macro Op137()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x89"
endif
endmacro

macro Op138()
if !Pass == 1
	print "	TXA"
endif
endmacro

macro Op139()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x8B"
endif
endmacro

macro Op140()
	%readword()
if !Pass == 1
	print "	STY.w $",hex(!Input1, 4)
endif
endmacro

macro Op141()
	%readword()
if !Pass == 1
	print "	STA.w $",hex(!Input1, 4)
endif
endmacro

macro Op142()
	%readword()
if !Pass == 1
	print "	STX.w $",hex(!Input1, 4)
endif
endmacro

macro Op143()
	%readword()
if !Pass == 1
	print "	Opcode 0x8F"
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
if !Pass == 1
	print "	Opcode 0x92"
endif
endmacro

macro Op147()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0x93"
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
	print "	Opcode 0x97"
endif
endmacro

macro Op152()
if !Pass == 1
	print "	TYA"
endif
endmacro

macro Op153()
	%readword()
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
	%readword()
if !Pass == 1
	print "	Opcode 0x9B"
endif
endmacro

macro Op156()
	%readword()
if !Pass == 1
	print "	Opcode 0x9C"
endif
endmacro

macro Op157()
	%readword()
if !Pass == 1
	print "	STA.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op158()
	%readword()
if !Pass == 1
	print "	Opcode 0x9E"
endif
endmacro

macro Op159()
	%readword()
if !Pass == 1
	print "	Opcode 0x9F"
endif
endmacro

macro Op160()
	%readbyte(Input1)
if !Pass == 1
	print "	LDY.b #$",hex(!Input1, 2)
endif
endmacro

macro Op161()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b ($",hex(!Input1, 2),",x)"
endif
endmacro

macro Op162()
	%readbyte(Input1)
if !Pass == 1
	print "	LDX.b #$",hex(!Input1, 2)
endif
endmacro

macro Op163()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xA3"
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
	print "	Opcode 0xA7"
endif
endmacro

macro Op168()
if !Pass == 1
	print "	TAY"
endif
endmacro

macro Op169()
	%readbyte(Input1)
if !Pass == 1
	print "	LDA.b #$",hex(!Input1, 2)
endif
endmacro

macro Op170()
if !Pass == 1
	print "	TAX"
endif
endmacro

macro Op171()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xAB"
endif
endmacro

macro Op172()
	%readword()
if !Pass == 1
	print "	LDY.w $",hex(!Input1, 4)
endif
endmacro

macro Op173()
	%readword()
if !Pass == 1
	print "	LDA.w $",hex(!Input1, 4)
endif
endmacro

macro Op174()
	%readword()
if !Pass == 1
	print "	LDX.w $",hex(!Input1, 4)
endif
endmacro

macro Op175()
	%readword()
if !Pass == 1
	print "	Opcode 0xAF"
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
if !Pass == 1
	print "	Opcode 0xB2"
endif
endmacro

macro Op179()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xB3"
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
	print "	Opcode 0xB7"
endif
endmacro

macro Op184()
if !Pass == 1
	print "	CLV"
endif
endmacro

macro Op185()
	%readword()
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
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xBB"
endif
endmacro

macro Op188()
	%readword()
if !Pass == 1
	print "	LDY.w $",hex(!Input1, 4),",x"	
endif
endmacro

macro Op189()
	%readword()
if !Pass == 1
	print "	LDA.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op190()
	%readword()
if !Pass == 1
	print "	LDX.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op191()
	%readword()
if !Pass == 1
	print "	Opcode 0xBF"
endif
endmacro

macro Op192()
	%readbyte(Input1)
if !Pass == 1
	print "	CPY.b #$",hex(!Input1, 2)
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
if !Pass == 1
	print "	Opcode 0xC2"
endif
endmacro

macro Op195()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xC3"
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
	print "	Opcode 0xC7"
endif
endmacro

macro Op200()
if !Pass == 1
	print "	INY"
endif
endmacro

macro Op201()
	%readbyte(Input1)
if !Pass == 1
	print "	CMP.b #$",hex(!Input1, 2)
endif
endmacro

macro Op202()
if !Pass == 1
	print "	DEX"
endif
endmacro

macro Op203()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xCB"
endif
endmacro

macro Op204()
	%readword()
if !Pass == 1
	print "	CPY.w $",hex(!Input1, 4)
endif
endmacro

macro Op205()
	%readword()
if !Pass == 1
	print "	CMP.w $",hex(!Input1, 4)
endif
endmacro

macro Op206()
	%readword()
if !Pass == 1
	print "	DEC.w $",hex(!Input1, 4)
endif
endmacro

macro Op207()
	%readword()
if !Pass == 1
	print "	Opcode 0xCF"
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
if !Pass == 1
	print "	Opcode 0xD2"
endif
endmacro

macro Op211()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xD3"
endif
endmacro

macro Op212()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xD4"
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
	print "	Opcode 0xD7"
endif
endmacro

macro Op216()
if !Pass == 1
	print "	CLD"
endif
endmacro

macro Op217()
	%readword()
if !Pass == 1
	print "	CMP.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op218()
if !Pass == 1
	print "	Opcode 0xDA"
endif
endmacro

macro Op219()
	%readword()
if !Pass == 1
	print "	Opcode 0xDB"
endif
endmacro

macro Op220()
	%readword()
if !Pass == 1
	print "	Opcode 0xDC"
endif
endmacro

macro Op221()
	%readword()
if !Pass == 1
	print "	CMP.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op222()
	%readword()
if !Pass == 1
	print "	DEC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op223()
	%readword()
if !Pass == 1
	print "	Opcode 0xDF"
endif
endmacro

macro Op224()
	%readbyte(Input1)
if !Pass == 1
	print "	CPX.b #$",hex(!Input1, 2)
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
if !Pass == 1
	print "	Opcode 0xE2"
endif
endmacro

macro Op227()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xE3"
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
	print "	Opcode 0xE7"
endif
endmacro

macro Op232()
if !Pass == 1
	print "	INX"
endif
endmacro

macro Op233()
	%readbyte(Input1)
if !Pass == 1
	print "	SBC.b #$",hex(!Input1, 2)
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
	%readword()
if !Pass == 1
	print "	CPX.w $",hex(!Input1, 4)
endif
endmacro

macro Op237()
	%readword()
if !Pass == 1
	print "	SBC.w $",hex(!Input1, 4)
endif
endmacro

macro Op238()
	%readword()
if !Pass == 1
	print "	INC.w $",hex(!Input1, 4)
endif
endmacro

macro Op239()
	%readword()
if !Pass == 1
	print "	Opcode 0xEF"
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
if !Pass == 1
	print "	Opcode 0xF2"
endif
endmacro

macro Op243()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xF3"
endif
endmacro

macro Op244()
	%readbyte(Input1)
if !Pass == 1
	print "	Opcode 0xF4"
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
	print "	Opcode 0xF7"
endif
endmacro

macro Op248()
if !Pass == 1
	print "	SED"
endif
endmacro

macro Op249()
	%readword()
if !Pass == 1
	print "	SBC.w $",hex(!Input1, 4),",y"
endif
endmacro

macro Op250()
if !Pass == 1
	print "	Opcode 0xFA"
endif
endmacro

macro Op251()
	%readword()
if !Pass == 1
	print "	Opcode 0xFB"
endif
endmacro

macro Op252()
	%readword()
if !Pass == 1
	print "	Opcode 0xFC"
endif
endmacro

macro Op253()
	%readword()
if !Pass == 1
	print "	SBC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op254()
	%readword()
if !Pass == 1
	print "	INC.w $",hex(!Input1, 4),",x"
endif
endmacro

macro Op255()
	%readword()
if !Pass == 1
	print "	Opcode 0xFF"
endif
endmacro

org !ROMOffset
if !DoTwoPassesFlag == 1
	while !ByteCounter < !MaxBytes
		%GetOpcode()
		%Op!Input1()
		!LoopCounter #= !LoopCounter+1
	endwhile
	!LoopCounter #= 0
	!ByteCounter #= 0
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
