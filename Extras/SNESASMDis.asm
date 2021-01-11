@asar 1.71

lorom

!CorrectErrorsFlag = 1
!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!16BitA = 0
!16BitXY = 0
!Offset = $008000
!TEMP1 = ""
!TEMP2 = ""
!Bank = 00

macro GetOpcode()
	!Input1 #= read1(!Offset+!ByteCounter)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
endmacro

macro readbyte(Input, TEMP)
	!<Input> #= read1(!Offset+!ByteCounter)
	;!<Input> = $01
	!ByteCounter #= !ByteCounter+1
	if !<Input> < 16
		!<TEMP> = "0"
	else
		!<TEMP> = ""
	endif
endmacro

macro readword()
	!Input1 #= read2(!Offset+!ByteCounter)
	;!Input1 = $0123
	!ByteCounter #= !ByteCounter+2
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

macro readlong()
	!Input1 #= read3(!Offset+!ByteCounter)
	;!Input1 = $012345
	!ByteCounter #= !ByteCounter+3
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
endmacro

macro HandleBranch(Value, ByteCounter)
if !Input1 >= <Value>
	if <Value> == $80
		!Input1 #= (!Offset+!ByteCounter)-((!Input1^$FF)+$01)
	else
		!Input1 #= (!Offset+!ByteCounter)-((!Input1^$FFFF)+$01)
	endif
else
	!Input1 #= (!Offset+!ByteCounter)+!Input1
endif
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
endmacro

macro PrintLabel()
	if !Offset+!ByteCounter < 16
		!TEMP1 = "00000"
	elseif !Offset+!ByteCounter < 256
		!TEMP1 = "0000"
	elseif !Offset+!ByteCounter < 4096
		!TEMP1 = "000"
	elseif !Offset+!ByteCounter < 65536
		!TEMP1 = "00"
	elseif !Offset+!ByteCounter < 1048576
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
	print ""
	print "CODE_!TEMP1",hex(!Offset+!ByteCounter),":"
endmacro

macro HandleShortJump()
endmacro

macro CheckForASizeError()
if !CorrectErrorsFlag == 1
	if !16BitA == 0
		if read1(!Offset+!ByteCounter+1) == $00
			!16BitA #= 1
		elseif read1(!Offset+!ByteCounter+1) == $02
			!16BitA #= 1
		endif
	else
		if read1(!Offset+!ByteCounter+2) == $00
			!16BitA #= 0
		elseif read1(!Offset+!ByteCounter+2) == $02
			!16BitA #= 0
		endif
	endif
endif
endmacro

macro CheckForXYSizeError()
if !CorrectErrorsFlag == 1
	if !16BitXY == 0
		if read1(!Offset+!ByteCounter+1) == $00
			!16BitXY #= 1
		elseif read1(!Offset+!ByteCounter+2) == $02
			!16BitXY #= 1
		endif
	else
		if read1(!Offset+!ByteCounter+2) == $00
			!16BitXY #= 0
		elseif read1(!Offset+!ByteCounter+2) == $02
			!16BitXY #= 0
		endif
	endif
endif
endmacro

macro Op0()
	%readbyte(Input1, TEMP1)
	print "	BRK #$!TEMP1",hex(!Input1)
endmacro

macro Op1()
	%readbyte(Input1, TEMP1)
	print "	ORA.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op2()
	%readbyte(Input1, TEMP1)
	print "	COP #$!TEMP1",hex(!Input1)
endmacro

macro Op3()
	%readbyte(Input1, TEMP1)
	print "	ORA.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op4()
	%readbyte(Input1, TEMP1)
	print "	TSB.b $!TEMP1",hex(!Input1)
endmacro

macro Op5()
	%readbyte(Input1, TEMP1)
	print "	ORA.b $!TEMP1",hex(!Input1)
endmacro

macro Op6()
	%readbyte(Input1, TEMP1)
	print "	ASL.b $!TEMP1",hex(!Input1)
endmacro

macro Op7()
	%readbyte(Input1, TEMP1)
	print "	ORA.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op8()
	print "	PHP"
endmacro

macro Op9()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	ORA.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	ORA.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op10()
	print "	ASL"
endmacro

macro Op11()
	print "	PHD"
endmacro

macro Op12()
	%readword()
	print "	TSB.w $!TEMP1",hex(!Input1)
endmacro

macro Op13()
	%readword()
	print "	ORA.w $!TEMP1",hex(!Input1)
endmacro

macro Op14()
	%readword()
	print "	ASL.w $!TEMP1",hex(!Input1)
endmacro

macro Op15()
	%readlong()
	print "	ORA.l $!TEMP1",hex(!Input1)
endmacro

macro Op16()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BPL.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op17()
	%readbyte(Input1, TEMP1)
	print "	ORA.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op18()
	%readbyte(Input1, TEMP1)
	print "	ORA.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op19()
	%readbyte(Input1, TEMP1)
	print "	ORA.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op20()
	%readbyte(Input1, TEMP1)
	print "	TRB.b $!TEMP1",hex(!Input1)
endmacro

macro Op21()
	%readbyte(Input1, TEMP1)
	print "	ORA.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op22()
	%readbyte(Input1, TEMP1)
	print "	ASL.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op23()
	%readbyte(Input1, TEMP1)
	print "	ORA.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op24()
	print "	CLC"
endmacro

macro Op25()
	%readword()
	print "	ORA.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op26()
	print "	INC"
endmacro

macro Op27()
	print "	TCS"
endmacro

macro Op28()
	%readword()
	print "	TRB.w $!TEMP1",hex(!Input1)
endmacro

macro Op29()
	%readword()
	print "	ORA.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op30()
	%readword()
	print "	ASL.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op31()
	%readlong()
	print "	ORA.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op32()
	%readword()
	%HandleShortJump()
	print "	JSR.w CODE_!Bank!TEMP1",hex(!Input1)
endmacro

macro Op33()
	%readbyte(Input1, TEMP1)
	print "	AND.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op34()
	%readlong()
	print "	JSL.l CODE_!TEMP1",hex(!Input1)
endmacro

macro Op35()
	%readbyte(Input1, TEMP1)
	print "	AND.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op36()
	%readbyte(Input1, TEMP1)
	print "	BIT.b $!TEMP1",hex(!Input1)
endmacro

macro Op37()
	%readbyte(Input1, TEMP1)
	print "	AND.b $!TEMP1",hex(!Input1)
endmacro

macro Op38()
	%readbyte(Input1, TEMP1)
	print "	ROL.b $!TEMP1",hex(!Input1)
endmacro

macro Op39()
	%readbyte(Input1, TEMP1)
	print "	AND.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op40()
	print "	PLP"
endmacro

macro Op41()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	AND.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	AND.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op42()
	print "	ROL"
endmacro

macro Op43()
	print "	PLD"
endmacro

macro Op44()
	%readword()
	print "	BIT.w $!TEMP1",hex(!Input1)
endmacro

macro Op45()
	%readword()
	print "	AND.w $!TEMP1",hex(!Input1)
endmacro

macro Op46()
	%readword()
	print "	ROL.w $!TEMP1",hex(!Input1)
endmacro

macro Op47()
	%readlong()
	print "	AND.l $!TEMP1",hex(!Input1)
endmacro

macro Op48()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BMI.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op49()
	%readbyte(Input1, TEMP1)
	print "	AND.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op50()
	%readbyte(Input1, TEMP1)
	print "	AND.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op51()
	%readbyte(Input1, TEMP1)
	print "	AND.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op52()
	%readbyte(Input1, TEMP1)
	print "	BIT.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op53()
	%readbyte(Input1, TEMP1)
	print "	AND.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op54()
	%readbyte(Input1, TEMP1)
	print "	ROL.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op55()
	%readbyte(Input1, TEMP1)
	print "	AND.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op56()
	print "	SEC"
endmacro

macro Op57()
	%readword()
	print "	AND.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op58()
	print "	DEC"
endmacro

macro Op59()
	print "	TSC"
endmacro

macro Op60()
	%readword()
	print "	BIT.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op61()
	%readword()
	print "	AND.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op62()
	%readword()
	print "	ROL.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op63()
	%readlong()
	print "	AND.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op64()
	print "	RTI"
	%PrintLabel()
endmacro

macro Op65()
	%readbyte(Input1, TEMP1)
	print "	EOR.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op66()
	%readbyte(Input1, TEMP1)
	print "	WDM #$!TEMP1",hex(!Input1)
endmacro

macro Op67()
	%readbyte(Input1, TEMP1)
	print "	EOR.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op68()
	%readbyte(Input1, TEMP1)
	%readbyte(Input2, TEMP2)
	print "	MVP $!TEMP1",hex(!Input1),",$!TEMP2",hex(!Input2)
endmacro

macro Op69()
	%readbyte(Input1, TEMP1)
	print "	EOR.b $!TEMP1",hex(!Input1)
endmacro

macro Op70()
	%readbyte(Input1, TEMP1)
	print "	LSR.b $!TEMP1",hex(!Input1)
endmacro

macro Op71()
	%readbyte(Input1, TEMP1)
	print "	EOR.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op72()
	print "	PHA"
endmacro

macro Op73()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	EOR.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	EOR.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op74()
	print "	LSR"
endmacro

macro Op75()
	print "	PHK"
endmacro

macro Op76()
	%readword()
	%HandleShortJump()
	print "	JMP.w CODE_!Bank!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op77()
	%readword()
	print "	EOR.w $!TEMP1",hex(!Input1)
endmacro

macro Op78()
	%readword()
	print "	LSR.w $!TEMP1",hex(!Input1)
endmacro

macro Op79()
	%readlong()
	print "	EOR.l $!TEMP1",hex(!Input1)
endmacro

macro Op80()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BVC.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op81()
	%readbyte(Input1, TEMP1)
	print "	EOR.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op82()
	%readbyte(Input1, TEMP1)
	print "	EOR.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op83()
	%readbyte(Input1, TEMP1)
	print "	EOR.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op84()
	%readbyte(Input1, TEMP1)
	%readbyte(Input2, TEMP2)
	print "	MVN $!TEMP1",hex(!Input1),",$!TEMP2",hex(!Input2)
endmacro

macro Op85()
	%readbyte(Input1, TEMP1)
	print "	EOR.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op86()
	%readbyte(Input1, TEMP1)
	print "	LSR.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op87()
	%readbyte(Input1, TEMP1)
	print "	EOR.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op88()
	print "	CLI"
endmacro

macro Op89()
	%readword()
	print "	EOR.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op90()
	print "	PHY"
endmacro

macro Op91()
	print "	TCD"
endmacro

macro Op92()
	%readlong()
	print "	JML.l CODE_!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op93()
	%readword()
	print "	EOR.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op94()
	%readword()
	print "	LSR.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op95()
	%readlong()
	print "	EOR.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op96()
	print "	RTS"
	%PrintLabel()
endmacro

macro Op97()
	%readbyte(Input1, TEMP1)
	print "	ADC.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op98()
	%readword()
	%HandleBranch($8000, !ByteCounter)
	print "	PER.w CODE_!TEMP1",hex(!Input1+$01),"-$01"
endmacro

macro Op99()
	%readbyte(Input1, TEMP1)
	print "	ADC.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op100()
	%readbyte(Input1, TEMP1)
	print "	STZ.b $!TEMP1",hex(!Input1)
endmacro

macro Op101()
	%readbyte(Input1, TEMP1)
	print "	ADC.b $!TEMP1",hex(!Input1)
endmacro

macro Op102()
	%readbyte(Input1, TEMP1)
	print "	ROR.b $!TEMP1",hex(!Input1)
endmacro

macro Op103()
	%readbyte(Input1, TEMP1)
	print "	ADC.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op104()
	print "	PLA"
endmacro

macro Op105()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	ADC.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	ADC.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op106()
	print "	ROR"
endmacro

macro Op107()
	print "	RTL"
	%PrintLabel()
endmacro

macro Op108()
	%readword()
	print "	JMP.w ($!TEMP1",hex(!Input1),")"
	%PrintLabel()
endmacro

macro Op109()
	%readword()
	print "	ADC.w $!TEMP1",hex(!Input1)
endmacro

macro Op110()
	%readword()
	print "	ROR.w $!TEMP1",hex(!Input1)
endmacro

macro Op111()
	%readlong()
	print "	ADC.l $!TEMP1",hex(!Input1)
endmacro

macro Op112()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BVS.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op113()
	%readbyte(Input1, TEMP1)
	print "	ADC.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op114()
	%readbyte(Input1, TEMP1)
	print "	ADC.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op115()
	%readbyte(Input1, TEMP1)
	print "	ADC.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op116()
	%readbyte(Input1, TEMP1)
	print "	STZ.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op117()
	%readbyte(Input1, TEMP1)
	print "	ADC.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op118()
	%readbyte(Input1, TEMP1)
	print "	ROR.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op119()
	%readbyte(Input1, TEMP1)
	print "	ADC.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op120()
	print "	SEI"
endmacro

macro Op121()
	%readword()
	print "	ADC.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op122()
	print "	PLY"
endmacro

macro Op123()
	print "	TDC"
endmacro

macro Op124()
	%readword()
	print "	JMP.w ($!TEMP1",hex(!Input1),",x)"
	%PrintLabel()
endmacro

macro Op125()
	%readword()
	print "	ADC.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op126()
	%readword()
	print "	ROR.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op127()
	%readlong()
	print "	ADC.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op128()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BRA.b CODE_!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op129()
	%readbyte(Input1, TEMP1)
	print "	STA.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op130()
	%readword()
	%HandleBranch($8000, !ByteCounter)
	print "	BRL.w CODE_!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op131()
	%readbyte(Input1, TEMP1)
	print "	STA.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op132()
	%readbyte(Input1, TEMP1)
	print "	STY.b $!TEMP1",hex(!Input1)
endmacro

macro Op133()
	%readbyte(Input1, TEMP1)
	print "	STA.b $!TEMP1",hex(!Input1)
endmacro

macro Op134()
	%readbyte(Input1, TEMP1)
	print "	STX.b $!TEMP1",hex(!Input1)
endmacro

macro Op135()
	%readbyte(Input1, TEMP1)
	print "	STA.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op136()
	print "	DEY"
endmacro

macro Op137()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	BIT.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	BIT.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op138()
	print "	TXA"
endmacro

macro Op139()
	print "	PHB"
endmacro

macro Op140()
	%readword()
	print "	STY.w $!TEMP1",hex(!Input1)
endmacro

macro Op141()
	%readword()
	print "	STA.w $!TEMP1",hex(!Input1)
endmacro

macro Op142()
	%readword()
	print "	STX.w $!TEMP1",hex(!Input1)
endmacro

macro Op143()
	%readlong()
	print "	STA.l $!TEMP1",hex(!Input1)
endmacro

macro Op144()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BCC.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op145()
	%readbyte(Input1, TEMP1)
	print "	STA.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op146()
	%readbyte(Input1, TEMP1)
	print "	STA.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op147()
	%readbyte(Input1, TEMP1)
	print "	STA.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op148()
	%readbyte(Input1, TEMP1)
	print "	STY.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op149()
	%readbyte(Input1, TEMP1)
	print "	STA.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op150()
	%readbyte(Input1, TEMP1)
	print "	STX.b $!TEMP1",hex(!Input1),",y"
endmacro

macro Op151()
	%readbyte(Input1, TEMP1)
	print "	STA.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op152()
	print "	TYA"
endmacro

macro Op153()
	%readword()
	print "	STA.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op154()
	print "	TXS"
endmacro

macro Op155()
	print "	TXY"
endmacro

macro Op156()
	%readword()
	print "	STZ.w $!TEMP1",hex(!Input1)
endmacro

macro Op157()
	%readword()
	print "	STA.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op158()
	%readword()
	print "	STZ.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op159()
	%readlong()
	print "	STA.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op160()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1, TEMP1)
		print "	LDY.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	LDY.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op161()
	%readbyte(Input1, TEMP1)
	print "	LDA.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op162()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1, TEMP1)
		print "	LDX.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	LDX.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op163()
	%readbyte(Input1, TEMP1)
	print "	LDA.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op164()
	%readbyte(Input1, TEMP1)
	print "	LDY.b $!TEMP1",hex(!Input1)
endmacro

macro Op165()
	%readbyte(Input1, TEMP1)
	print "	LDA.b $!TEMP1",hex(!Input1)
endmacro

macro Op166()
	%readbyte(Input1, TEMP1)
	print "	LDX.b $!TEMP1",hex(!Input1)
endmacro

macro Op167()
	%readbyte(Input1, TEMP1)
	print "	LDA.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op168()
	print "	TAY"
endmacro

macro Op169()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	LDA.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	LDA.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op170()
	print "	TAX"
endmacro

macro Op171()
	print "	PLB"
endmacro

macro Op172()
	%readword()
	print "	LDY.w $!TEMP1",hex(!Input1)
endmacro

macro Op173()
	%readword()
	print "	LDA.w $!TEMP1",hex(!Input1)
endmacro

macro Op174()
	%readword()
	print "	LDX.w $!TEMP1",hex(!Input1)
endmacro

macro Op175()
	%readlong()
	print "	LDA.l $!TEMP1",hex(!Input1)
endmacro

macro Op176()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BCS.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op177()
	%readbyte(Input1, TEMP1)
	print "	LDA.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op178()
	%readbyte(Input1, TEMP1)
	print "	LDA.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op179()
	%readbyte(Input1, TEMP1)
	print "	LDA.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op180()
	%readbyte(Input1, TEMP1)
	print "	LDY.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op181()
	%readbyte(Input1, TEMP1)
	print "	LDA.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op182()
	%readbyte(Input1, TEMP1)
	print "	LDX.b $!TEMP1",hex(!Input1),",y"
endmacro

macro Op183()
	%readbyte(Input1, TEMP1)
	print "	LDA.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op184()
	print "	CLV"
endmacro

macro Op185()
	%readword()
	print "	LDA.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op186()
	print "	TSX"
endmacro

macro Op187()
	print "	TYX"
endmacro

macro Op188()
	%readword()
	print "	LDY.w $!TEMP1",hex(!Input1),",x"	
endmacro

macro Op189()
	%readword()
	print "	LDA.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op190()
	%readword()
	print "	LDX.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op191()
	%readlong()
	print "	LDA.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op192()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1, TEMP1)
		print "	CPY.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	CPY.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op193()
	%readbyte(Input1, TEMP1)
	print "	CMP.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op194()
	%readbyte(Input1, TEMP1)
	if !Input1&$20 == $20
		!16BitA #= 1
	endif
	if !Input1&$10 == $10
		!16BitXY #= 1
	endif
	print "	REP.b #$!TEMP1",hex(!Input1)
endmacro

macro Op195()
	%readbyte(Input1, TEMP1)
	print "	CMP.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op196()
	%readbyte(Input1, TEMP1)
	print "	CPY.b $!TEMP1",hex(!Input1)
endmacro

macro Op197()
	%readbyte(Input1, TEMP1)
	print "	CMP.b $!TEMP1",hex(!Input1)
endmacro

macro Op198()
	%readbyte(Input1, TEMP1)
	print "	DEC.b $!TEMP1",hex(!Input1)
endmacro

macro Op199()
	%readbyte(Input1, TEMP1)
	print "	CMP.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op200()
	print "	INY"
endmacro

macro Op201()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	CMP.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	CMP.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op202()
	print "	DEX"
endmacro

macro Op203()
	print "	WAI"
endmacro

macro Op204()
	%readword()
	print "	CPY.w $!TEMP1",hex(!Input1)
endmacro

macro Op205()
	%readword()
	print "	CMP.w $!TEMP1",hex(!Input1)
endmacro

macro Op206()
	%readword()
	print "	DEC.w $!TEMP1",hex(!Input1)
endmacro

macro Op207()
	%readlong()
	print "	CMP.l $!TEMP1",hex(!Input1)
endmacro

macro Op208()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BNE.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op209()
	%readbyte(Input1, TEMP1)
	print "	CMP.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op210()
	%readbyte(Input1, TEMP1)
	print "	CMP.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op211()
	%readbyte(Input1, TEMP1)
	print "	CMP.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op212()
	%readbyte(Input1, TEMP1)
	print "	PEI.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op213()
	%readbyte(Input1, TEMP1)
	print "	CMP.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op214()
	%readbyte(Input1, TEMP1)
	print "	DEC.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op215()
	%readbyte(Input1, TEMP1)
	print "	CMP.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op216()
	print "	CLD"
endmacro

macro Op217()
	%readword()
	print "	CMP.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op218()
	print "	PHX"
endmacro

macro Op219()
	print "	STP"
endmacro

macro Op220()
	%readword()
	print "	JMP.w [$!TEMP1",hex(!Input1),"]"
	%PrintLabel()
endmacro

macro Op221()
	%readword()
	print "	CMP.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op222()
	%readword()
	print "	DEC.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op223()
	%readlong()
	print "	CMP.l $!TEMP1",hex(!Input1),",x"
endmacro

macro Op224()
	%CheckForXYSizeError()
	if !16BitXY == 0
		%readbyte(Input1, TEMP1)
		print "	CPX.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	CPX.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op225()
	%readbyte(Input1, TEMP1)
	print "	SBC.b ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op226()
	%readbyte(Input1, TEMP1)
	if !Input1&$20 == $20
		!16BitA #= 0
	endif
	if !Input1&$10 == $10
		!16BitXY #= 0
	endif
	print "	SEP.b #$!TEMP1",hex(!Input1)
endmacro

macro Op227()
	%readbyte(Input1, TEMP1)
	print "	SBC.b $!TEMP1",hex(!Input1),",S"
endmacro

macro Op228()
	%readbyte(Input1, TEMP1)
	print "	CPX.b $!TEMP1",hex(!Input1)
endmacro

macro Op229()
	%readbyte(Input1, TEMP1)
	print "	SBC.b $!TEMP1",hex(!Input1)
endmacro

macro Op230()
	%readbyte(Input1, TEMP1)
	print "	INC.b $!TEMP1",hex(!Input1)
endmacro

macro Op231()
	%readbyte(Input1, TEMP1)
	print "	SBC.b [$!TEMP1",hex(!Input1),"]"
endmacro

macro Op232()
	print "	INX"
endmacro

macro Op233()
	%CheckForASizeError()
	if !16BitA == 0
		%readbyte(Input1, TEMP1)
		print "	SBC.b #$!TEMP1",hex(!Input1)
	else
		%readword()
		print "	SBC.w #$!TEMP1",hex(!Input1)
	endif
endmacro

macro Op234()
	print "	NOP"
endmacro

macro Op235()
	print "	XBA"
endmacro

macro Op236()
	%readword()
	print "	CPX.w $!TEMP1",hex(!Input1)
endmacro

macro Op237()
	%readword()
	print "	SBC.w $!TEMP1",hex(!Input1)
endmacro

macro Op238()
	%readword()
	print "	INC.w $!TEMP1",hex(!Input1)
endmacro

macro Op239()
	%readlong()
	print "	SBC.l $!TEMP1",hex(!Input1)
endmacro

macro Op240()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BEQ.b CODE_!TEMP1",hex(!Input1)
endmacro

macro Op241()
	%readbyte(Input1, TEMP1)
	print "	SBC.b ($!TEMP1",hex(!Input1),"),y"
endmacro

macro Op242()
	%readbyte(Input1, TEMP1)
	print "	SBC.b ($!TEMP1",hex(!Input1),")"
endmacro

macro Op243()
	%readbyte(Input1, TEMP1)
	print "	SBC.b ($!TEMP1",hex(!Input1),",S),y"
endmacro

macro Op244()
	%readword()
	print "	PEA.w $!TEMP1",hex(!Input1)
endmacro

macro Op245()
	%readbyte(Input1, TEMP1)
	print "	SBC.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op246()
	%readbyte(Input1, TEMP1)
	print "	INC.b $!TEMP1",hex(!Input1),",x"
endmacro

macro Op247()
	%readbyte(Input1, TEMP1)
	print "	SBC.b [$!TEMP1",hex(!Input1),"],y"
endmacro

macro Op248()
	print "	SED"
endmacro

macro Op249()
	%readword()
	print "	SBC.w $!TEMP1",hex(!Input1),",y"
endmacro

macro Op250()
	print "	PLX"
endmacro

macro Op251()
	print "	XCE"
endmacro

macro Op252()
	%readword()
	print "	JSR.w ($!TEMP1",hex(!Input1),",x)"
endmacro

macro Op253()
	%readword()
	print "	SBC.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op254()
	%readword()
	print "	INC.w $!TEMP1",hex(!Input1),",x"
endmacro

macro Op255()
	%readlong()
	print "	SBC.l $!TEMP1",hex(!Input1),",x"
endmacro

org !Offset
while !ByteCounter < 16384
	%GetOpcode()
	%Op!Input1()
	!LoopCounter #= !LoopCounter+1
endif

!Input1 #= !Offset+!ByteCounter
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
print "Disassembly has ended at $!TEMP1",hex(!Offset+!ByteCounter)
