@asar 1.71

lorom

!BaseOffset = $0500
!EngineOffset = 0500
!GetBaseOffsetFromROM = 1
!ReadSizeOffset = 1
!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!ROMOffset = $0E8000
!TEMP1 = ""
!TEMP2 = ""
!TEMP3 = ""
!SizeOfBlock #= $0100

macro GetOpcode()
	!Input1 #= read1(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
	!BaseOffsetOffset #= !BaseOffsetOffset+1
	!SizeOfBlock #= !SizeOfBlock-1
endmacro

macro readbyte(Input, TEMP)
	!<Input> #= read1(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)
	;!Input1 = $01
	;!Input2 = $0F
	!ByteCounter #= !ByteCounter+1
	!BaseOffsetOffset #= !BaseOffsetOffset+1
	!SizeOfBlock #= !SizeOfBlock-1
	if !<Input> < 16
		!<TEMP> = "0"
	else
		!<TEMP> = ""
	endif
endmacro

macro readword()
	!Input1 #= read2(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)
	;!Input1 = $0123
	!ByteCounter #= !ByteCounter+2
	!BaseOffsetOffset #= !BaseOffsetOffset+2
	!SizeOfBlock #= !SizeOfBlock-2
	if !Input1 < 16
		!TEMP1 = "000"
	elseif !Input1 < 256
		!TEMP1 = "00"
	elseif !Input1 < 4096
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
endmacro

macro HandleBranch(Value, ByteCounter)
if !Input1 >= <Value>
	!Input1 #= (!BaseOffset+!BaseOffsetOffset)-((!Input1^$FF)+$01)
else
	!Input1 #= (!BaseOffset+!BaseOffsetOffset)+!Input1
endif
	if !Input1 < 16
		!TEMP1 = "000"
	elseif !Input1 < 256
		!TEMP1 = "00"
	elseif !Input1 < 4096
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
endmacro

macro AdjustMemBitOpcodeOutput()
	!TEMP2 #= (!Input1&$F000)/$2000
	!Input1 #= !Input1&$1FFF
	if !Input1 < 16
		!TEMP1 = "000"
	elseif !Input1 < 256
		!TEMP1 = "00"
	elseif !Input1 < 4096
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
endmacro

macro PrintLabel()
	if !BaseOffset+!BaseOffsetOffset < 16
		!TEMP1 = "000"
	elseif !BaseOffset+!BaseOffsetOffset < 256
		!TEMP1 = "00"
	elseif !BaseOffset+!BaseOffsetOffset < 4096
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
	print ""
	print "CODE_!TEMP1",hex(!BaseOffset+!BaseOffsetOffset),":"
endmacro

macro HandleShortJump()
endmacro

macro Op0()
	print "	NOP"
endmacro

macro Op1()
	print "	TCALL 0"
endmacro

macro Op2()
	%readbyte(Input1, TEMP1)
	print "	SET0 $!TEMP1",hex(!Input1)
endmacro

macro Op3()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS0 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op4()
	%readbyte(Input1, TEMP1)
	print "	OR A, $!TEMP1",hex(!Input1)
endmacro

macro Op5()
	%readword()
	print "	OR A, $!TEMP1",hex(!Input1)
endmacro

macro Op6()
	print "	OR A, (X)"
endmacro

macro Op7()
	%readbyte(Input1, TEMP1)
	print "	OR A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op8()
	%readbyte(Input1, TEMP1)
	print "	OR A, #$!TEMP1",hex(!Input1)
endmacro

macro Op9()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	OR $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op10()
	%readword()
	print "	OR1 C, $!TEMP1",hex(!Input1)
endmacro

macro Op11()
	%readbyte(Input1, TEMP1)
	print "	ASL $!TEMP1",hex(!Input1)
endmacro

macro Op12()
	%readword()
	print "	ASL $!TEMP1",hex(!Input1)
endmacro

macro Op13()
	print "	PUSH P"
endmacro

macro Op14()
	%readword()
	print "	TSET $!TEMP1",hex(!Input1),", A"
endmacro

macro Op15()
	print "	BRK"
	%PrintLabel()
endmacro

macro Op16()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BPL CODE_!TEMP1",hex(!Input1)
endmacro

macro Op17()
	print "	TCALL 1"
endmacro

macro Op18()
	%readbyte(Input1, TEMP1)
	print "	CLR0 $!TEMP1",hex(!Input1)
endmacro

macro Op19()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC0 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op20()
	%readbyte(Input1, TEMP1)
	print "	OR A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op21()
	%readword()
	print "	OR A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op22()
	%readword()
	print "	OR A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op23()
	%readbyte(Input1, TEMP1)
	print "	OR A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op24()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	OR $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op25()
	print "	OR (X), (Y)"
endmacro

macro Op26()
	%readbyte(Input1, TEMP1)
	print "	DECW $!TEMP1",hex(!Input1)
endmacro

macro Op27()
	%readbyte(Input1, TEMP1)
	print "	ASL $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op28()
	print "	ASL A"
endmacro

macro Op29()
	print "	DEC X"
endmacro

macro Op30()
	%readword()
	print "	CMP X, $!TEMP1",hex(!Input1)
endmacro

macro Op31()
	%readword()
	print "	JMP ($!TEMP1",hex(!Input1),"+x)"
	%PrintLabel()
endmacro

macro Op32()
	print "	CLRP"
endmacro

macro Op33()
	print "	TCALL 2"
endmacro

macro Op34()
	%readbyte(Input1, TEMP1)
	print "	SET1 $!TEMP1",hex(!Input1)
endmacro

macro Op35()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS1 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op36()
	%readbyte(Input1, TEMP1)
	print "	AND A, $!TEMP1",hex(!Input1)
endmacro

macro Op37()
	%readword()
	print "	AND A, $!TEMP1",hex(!Input1)
endmacro

macro Op38()
	print "	AND A, (X)"
endmacro

macro Op39()
	%readbyte(Input1, TEMP1)
	print "	AND A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op40()
	%readbyte(Input1, TEMP1)
	print "	AND A, #$!TEMP1",hex(!Input1)
endmacro

macro Op41()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	AND $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op42()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	OR",hex(!TEMP2)," C, !$!TEMP1",hex(!Input1)
endmacro

macro Op43()
	%readbyte(Input1, TEMP1)
	print "	ROL $!TEMP1",hex(!Input1)
endmacro

macro Op44()
	%readword()
	print "	ROL $!TEMP1",hex(!Input1)
endmacro

macro Op45()
	print "	PUSH A"
endmacro

macro Op46()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	CBNE $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op47()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BRA CODE_!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op48()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BMI CODE_!TEMP1",hex(!Input1)
endmacro

macro Op49()
	print "	TCALL 3"
endmacro

macro Op50()
	%readbyte(Input1, TEMP1)
	print "	CLR1 $!TEMP1",hex(!Input1)
endmacro

macro Op51()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC1 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op52()
	%readbyte(Input1, TEMP1)
	print "	AND A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op53()
	%readword()
	print "	AND A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op54()
	%readword()
	print "	AND A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op55()
	%readbyte(Input1, TEMP1)
	print "	AND A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op56()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	AND $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op57()
	print "	AND (X), (Y)"
endmacro

macro Op58()
	%readbyte(Input1, TEMP1)
	print "	INCW $!TEMP1",hex(!Input1)
endmacro

macro Op59()
	%readbyte(Input1, TEMP1)
	print "	ROL $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op60()
	print "	ROL A"
endmacro

macro Op61()
	print "	INC X"
endmacro

macro Op62()
	%readbyte(Input1, TEMP1)
	print "	CMP X, $!TEMP1",hex(!Input1)
endmacro

macro Op63()
	%readword()
	print "	CALL CODE_!TEMP1",hex(!Input1)
endmacro

macro Op64()
	print "	SETP"
endmacro

macro Op65()
	print "	TCALL 4"
endmacro

macro Op66()
	%readbyte(Input1, TEMP1)
	print "	SET2 $!TEMP1",hex(!Input1)
endmacro

macro Op67()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS2 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op68()
	%readbyte(Input1, TEMP1)
	print "	EOR A, $!TEMP1",hex(!Input1)
endmacro

macro Op69()
	%readword()
	print "	EOR A, $!TEMP1",hex(!Input1)
endmacro

macro Op70()
	print "	EOR A, (X)"
endmacro

macro Op71()
	%readbyte(Input1, TEMP1)
	print "	EOR A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op72()
	%readbyte(Input1, TEMP1)
	print "	EOR A, #$!TEMP1",hex(!Input1)
endmacro

macro Op73()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	EOR $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op74()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	AND",hex(!TEMP2)," C, $!TEMP1",hex(!Input1)
endmacro

macro Op75()
	%readbyte(Input1, TEMP1)
	print "	LSR $!TEMP1",hex(!Input1)
endmacro

macro Op76()
	%readword()
	print "	LSR $!TEMP1",hex(!Input1)
endmacro

macro Op77()
	print "	PUSH X"
endmacro

macro Op78()
	%readword()
	print "	TCLR $!TEMP1",hex(!Input1),", A"
endmacro

macro Op79()
	%readbyte(Input1, TEMP1)
	print "	PCALL $FF!TEMP1",hex(!Input1)
endmacro

macro Op80()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BVC CODE_!TEMP1",hex(!Input1)
endmacro

macro Op81()
	print "	TCALL 5"
endmacro

macro Op82()
	%readbyte(Input1, TEMP1)
	print "	CLR2 $!TEMP1",hex(!Input1)
endmacro

macro Op83()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC2 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op84()
	%readbyte(Input1, TEMP1)
	print "	EOR A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op85()
	%readword()
	print "	EOR A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op86()
	%readword()
	print "	EOR A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op87()
	%readbyte(Input1, TEMP1)
	print "	EOR A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op88()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	EOR $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op89()
	print "	EOR (X), (Y)"
endmacro

macro Op90()
	%readbyte(Input1, TEMP1)
	print "	CMPW YA, $!TEMP1",hex(!Input1)
endmacro

macro Op91()
	%readbyte(Input1, TEMP1)
	print "	LSR $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op92()
	print "	LSR A"
endmacro

macro Op93()
	print "	MOV X, A"
endmacro

macro Op94()
	%readword()
	print "	CMP Y, $!TEMP1",hex(!Input1)
endmacro

macro Op95()
	%readword()
	print "	JMP CODE_!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op96()
	print "	CLRC"
endmacro

macro Op97()
	print "	TCALL 6"
endmacro

macro Op98()
	%readbyte(Input1, TEMP1)
	print "	SET3 $!TEMP1",hex(!Input1)
endmacro

macro Op99()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS3 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op100()
	%readbyte(Input1, TEMP1)
	print "	CMP A, $!TEMP1",hex(!Input1)
endmacro

macro Op101()
	%readword()
	print "	CMP A, $!TEMP1",hex(!Input1)
endmacro

macro Op102()
	print "	CMP A, (X)"
endmacro

macro Op103()
	%readbyte(Input1, TEMP1)
	print "	CMP A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op104()
	%readbyte(Input1, TEMP1)
	print "	CMP A, #$!TEMP1",hex(!Input1)
endmacro

macro Op105()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	CMP $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op106()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	AND",hex(!TEMP2)," C, !$!TEMP1",hex(!Input1)
endmacro

macro Op107()
	%readbyte(Input1, TEMP1)
	print "	ROR $!TEMP1",hex(!Input1)
endmacro

macro Op108()
	%readword()
	print "	ROR $!TEMP1",hex(!Input1)
endmacro

macro Op109()
	print "	PUSH Y"
endmacro

macro Op110()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	DBNZ $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op111()
	print "	RET"
	%PrintLabel()
endmacro

macro Op112()
	%readword()
	%HandleBranch($80, !ByteCounter)
	print "	BVS CODE_!TEMP1",hex(!Input1)
endmacro

macro Op113()
	print "	TCALL 7"
endmacro

macro Op114()
	%readbyte(Input1, TEMP1)
	print "	CLR3 $!TEMP1",hex(!Input1)
endmacro

macro Op115()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC3 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op116()
	%readbyte(Input1, TEMP1)
	print "	CMP A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op117()
	%readword()
	print "	CMP A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op118()
	%readword()
	print "	CMP A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op119()
	%readbyte(Input1, TEMP1)
	print "	CMP A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op120()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	CMP $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op121()
	print "	CMP (X), (Y)"
endmacro

macro Op122()
	%readbyte(Input1, TEMP1)
	print "	ADDW YA, $!TEMP1",hex(!Input1)
endmacro

macro Op123()
	%readbyte(Input1, TEMP1)
	print "	ROR $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op124()
	print "	ROR A"
endmacro

macro Op125()
	print "	MOV A, X"
endmacro

macro Op126()
	%readbyte(Input1, TEMP1)
	print "	CMP Y, $!TEMP1",hex(!Input1)
endmacro

macro Op127()
	print "	RETI"
	%PrintLabel()
endmacro

macro Op128()
	print "	SETC"
endmacro

macro Op129()
	print "	TCALL 8"
endmacro

macro Op130()
	%readbyte(Input1, TEMP1)
	print "	SET4 $!TEMP1",hex(!Input1)
endmacro

macro Op131()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS4 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op132()
	%readbyte(Input1, TEMP1)
	print "	ADC A, $!TEMP1",hex(!Input1)
endmacro

macro Op133()
	%readword()
	print "	ADC A, $!TEMP1",hex(!Input1)
endmacro

macro Op134()
	print "	ADC A, (X)"
endmacro

macro Op135()
	%readbyte(Input1, TEMP1)
	print "	ADC A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op136()
	%readbyte(Input1, TEMP1)
	print "	ADC A, #$!TEMP1",hex(!Input1)
endmacro

macro Op137()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	ADC $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op138()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	EOR",hex(!TEMP2)," C, $!TEMP1",hex(!Input1)
endmacro

macro Op139()
	%readbyte(Input1, TEMP1)
	print "	DEC $!TEMP1",hex(!Input1)
endmacro

macro Op140()
	%readword()
	print "	DEC $!TEMP1",hex(!Input1)
endmacro

macro Op141()
	%readbyte(Input1, TEMP1)
	print "	MOV Y, #$!TEMP1",hex(!Input1)
endmacro

macro Op142()
	print "	POP P"
endmacro

macro Op143()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op144()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BCC CODE_!TEMP1",hex(!Input1)
endmacro

macro Op145()
	print "	TCALL 9"
endmacro

macro Op146()
	%readbyte(Input1, TEMP1)
	print "	CLR4 $!TEMP1",hex(!Input1)
endmacro

macro Op147()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC4 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op148()
	%readbyte(Input1, TEMP1)
	print "	ADC A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op149()
	%readword()
	print "	ADC A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op150()
	%readword()
	print "	ADC A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op151()
	%readbyte(Input1, TEMP1)
	print "	ADC A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op152()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	ADC $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op153()
	print "	ADC (X), (Y)"
endmacro

macro Op154()
	%readbyte(Input1, TEMP1)
	print "	SUBW YA, $!TEMP1",hex(!Input1)
endmacro

macro Op155()
	%readbyte(Input1, TEMP1)
	print "	DEC $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op156()
	print "	DEC A"
endmacro

macro Op157()
	print "	MOV X, SP"
endmacro

macro Op158()
	print "	DIV YA, X"
endmacro

macro Op159()
	print "	XCN A"
endmacro

macro Op160()
	print "	EI"
endmacro

macro Op161()
	print "	TCALL 10"
endmacro

macro Op162()
	%readbyte(Input1, TEMP1)
	print "	SET5 $!TEMP1",hex(!Input1)
endmacro

macro Op163()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS5 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op164()
	%readbyte(Input1, TEMP1)
	print "	SBC A, $!TEMP1",hex(!Input1)
endmacro

macro Op165()
	%readword()
	print "	SBC A, $!TEMP1",hex(!Input1)
endmacro

macro Op166()
	print "	SBC A, (X)"
endmacro

macro Op167()
	%readbyte(Input1, TEMP1)
	print "	SBC A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op168()
	%readbyte(Input1, TEMP1)
	print "	SBC A, #$!TEMP1",hex(!Input1)
endmacro

macro Op169()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	SBC $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op170()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	MOV",hex(!TEMP2)," C, $!TEMP1",hex(!Input1)
endmacro

macro Op171()
	%readbyte(Input1, TEMP1)
	print "	INC $!TEMP1",hex(!Input1)
endmacro

macro Op172()
	%readword()
	print "	INC $!TEMP1",hex(!Input1)
endmacro

macro Op173()
	%readbyte(Input1, TEMP1)
	print "	CMP Y, #$!TEMP1",hex(!Input1)
endmacro

macro Op174()
	print "	POP A"
endmacro

macro Op175()
	print "	MOV (X+), A"
endmacro

macro Op176()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BCS CODE_!TEMP1",hex(!Input1)
endmacro

macro Op177()
	print "	TCALL 11"
endmacro

macro Op178()
	%readbyte(Input1, TEMP1)
	print "	CLR5 $!TEMP1",hex(!Input1)
endmacro

macro Op179()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC5 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op180()
	%readbyte(Input1, TEMP1)
	print "	SBC A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op181()
	%readword()
	print "	SBC A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op182()
	%readword()
	print "	SBC A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op183()
	%readbyte(Input1, TEMP1)
	print "	SBC A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op184()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	SBC $!TEMP1",hex(!Input1),", #$!TEMP2",hex(!Input2)
endmacro

macro Op185()
	print "	SBC (X), (Y)"
endmacro

macro Op186()
	%readbyte(Input1, TEMP1)
	print "	MOVW YA, $!TEMP1",hex(!Input1)
endmacro

macro Op187()
	%readbyte(Input1, TEMP1)
	print "	INC $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op188()
	print "	INC A"
endmacro

macro Op189()
	print "	MOV SP, X"
endmacro

macro Op190()
	print "	DAS A"
endmacro

macro Op191()
	print "	MOV A, (X+)"
endmacro

macro Op192()
	print "	DI"
endmacro

macro Op193()
	print "	TCALL 12"
endmacro

macro Op194()
	%readbyte(Input1, TEMP1)
	print "	SET6 $!TEMP1",hex(!Input1)
endmacro

macro Op195()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS6 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op196()
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),", A"
endmacro

macro Op197()
	%readword()
	print "	MOV $!TEMP1",hex(!Input1),", A"
endmacro

macro Op198()
	print "	MOV (X), A"
endmacro

macro Op199()
	%readbyte(Input1, TEMP1)
	print "	MOV ($!TEMP1",hex(!Input1),"+x), A"
endmacro

macro Op200()
	%readbyte(Input1, TEMP1)
	print "	CMP X, #$!TEMP1",hex(!Input1)
endmacro

macro Op201()
	%readword()
	print "	MOV $!TEMP1",hex(!Input1),", X"
endmacro

macro Op202()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	MOV",hex(!TEMP2)," $!TEMP1",hex(!Input1),", C"
endmacro

macro Op203()
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),", Y"
endmacro

macro Op204()
	%readword()
	print "	MOV $!TEMP1",hex(!Input1),", Y"
endmacro

macro Op205()
	%readbyte(Input1, TEMP1)
	print "	MOV X, #$!TEMP1",hex(!Input1)
endmacro

macro Op206()
	print "	POP X"
endmacro

macro Op207()
	print "	MUL YA"
endmacro

macro Op208()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BNE CODE_!TEMP1",hex(!Input1)
endmacro

macro Op209()
	print "	TCALL 13"
endmacro

macro Op210()
	%readbyte(Input1, TEMP1)
	print "	CLR6 $!TEMP1",hex(!Input1)
endmacro

macro Op211()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC6 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op212()
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),"+x, A"
endmacro

macro Op213()
	%readword()
	print "	MOV $!TEMP1",hex(!Input1),"+x, A"
endmacro

macro Op214()
	%readword()
	print "	MOV $!TEMP1",hex(!Input1),"+y, A"
endmacro

macro Op215()
	%readbyte(Input1, TEMP1)
	print "	MOV ($!TEMP1",hex(!Input1),")+y, A"
endmacro

macro Op216()
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),", X"
endmacro

macro Op217()
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),"+y, X"
endmacro

macro Op218()
	%readbyte(Input1, TEMP1)
	print "	MOVW $!TEMP1",hex(!Input1),", YA"
endmacro

macro Op219()
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),"+x, Y"
endmacro

macro Op220()
	print "	DEC Y"
endmacro

macro Op221()
	print "	MOV A, Y"
endmacro

macro Op222()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	CBNE $!TEMP2",hex(!Input2),"+x, CODE_!TEMP1",hex(!Input1)
endmacro

macro Op223()
	print "	DAA"
endmacro

macro Op224()
	print "	CLRV"
endmacro

macro Op225()
	print "	TCALL 14"
endmacro

macro Op226()
	%readbyte(Input1, TEMP1)
	print "	SET7 $!TEMP1",hex(!Input1)
endmacro

macro Op227()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBS7 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op228()
	%readbyte(Input1, TEMP1)
	print "	MOV A, $!TEMP1",hex(!Input1)
endmacro

macro Op229()
	%readword()
	print "	MOV A, $!TEMP1",hex(!Input1)
endmacro

macro Op230()
	print "	MOV A, (X)"
endmacro

macro Op231()
	%readbyte(Input1, TEMP1)
	print "	MOV A, ($!TEMP1",hex(!Input1),"+x)"
endmacro

macro Op232()
	%readbyte(Input1, TEMP1)
	print "	MOV A, #$!TEMP1",hex(!Input1)
endmacro

macro Op233()
	%readword()
	print "	MOV X, $!TEMP1",hex(!Input1)
endmacro

macro Op234()
	%readword()
	%AdjustMemBitOpcodeOutput()
	print "	NOT",hex(!TEMP2)," C, $!TEMP1",hex(!Input1)
endmacro

macro Op235()
	%readbyte(Input1, TEMP1)
	print "	MOV Y, $!TEMP1",hex(!Input1)
endmacro

macro Op236()
	%readword()
	print "	MOV Y, $!TEMP1",hex(!Input1)
endmacro

macro Op237()
	print "	NOTC"
endmacro

macro Op238()
	print "	POP Y"
endmacro

macro Op239()
	print "	SLEEP"
	%PrintLabel()
endmacro

macro Op240()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BEQ CODE_!TEMP1",hex(!Input1)
endmacro

macro Op241()
	print "	TCALL 15"
endmacro

macro Op242()
	%readbyte(Input1, TEMP1)
	print "	CLR7 $!TEMP1",hex(!Input1)
endmacro

macro Op243()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BBC7 $!TEMP2",hex(!Input2),", CODE_!TEMP1",hex(!Input1)
endmacro

macro Op244()
	%readbyte(Input1, TEMP1)
	print "	MOV A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op245()
	%readword()
	print "	MOV A, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op246()
	%readword()
	print "	MOV A, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op247()
	%readbyte(Input1, TEMP1)
	print "	MOV A, ($!TEMP1",hex(!Input1),")+y"
endmacro

macro Op248()
	%readbyte(Input1, TEMP1)
	print "	MOV X, $!TEMP1",hex(!Input1)
endmacro

macro Op249()
	%readbyte(Input1, TEMP1)
	print "	MOV X, $!TEMP1",hex(!Input1),"+y"
endmacro

macro Op250()
	%readbyte(Input2, TEMP2)
	%readbyte(Input1, TEMP1)
	print "	MOV $!TEMP1",hex(!Input1),", $!TEMP2",hex(!Input2)
endmacro

macro Op251()
	%readbyte(Input1, TEMP1)
	print "	MOV Y, $!TEMP1",hex(!Input1),"+x"
endmacro

macro Op252()
	print "	INC Y"
endmacro

macro Op253()
	print "	MOV Y, A"
endmacro

macro Op254()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	DBNZ Y, CODE_!TEMP1",hex(!Input1)
endmacro

macro Op255()
	print "	STOP"
	%PrintLabel()
endmacro

org !ROMOffset
!InLoop = 1
!BlockSizeWarning = 0
!TotalBlockSize #= $0000
!BaseOffsetOffset #= $0000 
print "Disassembling from !ROMOffset"
while !InLoop != 0
	if !ReadSizeOffset == 1
		!SizeOfBlock #= read2(!ROMOffset+!TotalBlockSize)
		!TotalBlockSize #= !TotalBlockSize+2
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
	if !BaseOffset < 16
		!TEMP3 = "000"
	elseif !BaseOffset < 256
		!TEMP3 = "00"
	elseif !BaseOffset < 4096
		!TEMP3 = "0"
	else
		!TEMP3 = ""
	endif
	if !SizeOfBlock > 1
		print "%SPCDataBlockStart(!TEMP3",hex(!BaseOffset),")"
	endif
	while !SizeOfBlock > 0
		%GetOpcode()
		%Op!Input1()
		!LoopCounter #= !LoopCounter+1
		if !ByteCounter >= 8192
			!SizeOfBlock #= $0000
			!InLoop #= 0
			print "%SPCDataBlockEnd(!TEMP3",hex(!BaseOffset),")"
			print ""
		endif
		if  !SizeOfBlock < 1
			if !SizeOfBlock != 0
				!BlockSizeWarning = 1
			endif
			!SizeOfBlock #= $0000
			print "%SPCDataBlockEnd(!TEMP3",hex(!BaseOffset),")"
			print ""
		endif
	endif
	!TotalBlockSize #= !TotalBlockSize+!CurrentBlockSize
endif
print "%EndSPCUploadAndJumpToEngine(!EngineOffset)"

!Input1 #= !ROMOffset+!BaseOffsetOffset+!TotalBlockSize
if !Input1 < 16
	!TEMP1 = "00000"
elseif !Input1 < 256
	!TEMP1 = "0000"
elseif !Input1 < 4096
	!TEMP1 = "000"
elseif !Input1 < 65536
	!TEMP1 = "00"
elseif !Input1 < 1048576
	!TEMP1 = "0"
else
	!TEMP1 = ""
endif
print "Disassembly has ended at $!TEMP1",hex(!ROMOffset+!BaseOffsetOffset+!TotalBlockSize)

if !ReadSizeOffset == 0
	!Input1 #= !BaseOffset+!BaseOffsetOffset
	if !Input1 < 16
		!TEMP2 = "000"
	elseif !Input1 < 256
		!TEMP2 = "00"
	elseif !Input1 < 4096
		!TEMP2 = "0"
	else
		!TEMP2 = ""
	endif
	print "Base Offset has ended at $!TEMP2",hex(!BaseOffset+!BaseOffsetOffset)
endif

if !BlockSizeWarning != 0
	print "Warning, one or more data blocks disassembled more bytes than the specified size. Closer inspection is needed."
endif
