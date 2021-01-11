@asar 1.71

sfxrom

!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!ROMOffset = $088000
!TEMP1 = ""
!TEMP2 = ""
!TEMP3 = ""

macro GetOpcode()
	!Input1 #= read1(!ROMOffset+!ByteCounter)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
endmacro

macro readbyte(Input, TEMP)
	!<Input> #= read1(!ROMOffset+!ByteCounter)
	;!<Input> = $01
	!ByteCounter #= !ByteCounter+1
	if !<Input> < 16
		!<TEMP> = "0"
	else
		!<TEMP> = ""
	endif
endmacro

macro readword()
	!Input1 #= read2(!ROMOffset+!ByteCounter)
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
	if !ROMOffset+!ByteCounter < 16
		!TEMP1 = "00000"
	elseif !ROMOffset+!ByteCounter < 256
		!TEMP1 = "0000"
	elseif !ROMOffset+!ByteCounter < 4096
		!TEMP1 = "000"
	elseif !ROMOffset+!ByteCounter < 65536
		!TEMP1 = "00"
	elseif !ROMOffset+!ByteCounter < 1048576
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
	print ""
	print "CODE_!TEMP1",hex(!ROMOffset+!ByteCounter),":"
endmacro

macro HandleShortJump()
endmacro

macro Op0()
	%readbyte(Input1, TEMP1)
	if !Input1 == $01
		print "	STOP : NOP"
	else
		print "	STOP"
		!ByteCounter #= !ByteCounter-1
	endif
	%PrintLabel()
endmacro

macro Op1()
	print "	NOP"
endmacro

macro Op2()
	print "	CACHE"
endmacro

macro Op3()
	print "	LSR"
endmacro

macro Op4()
	print "	ROL"
endmacro

macro Op5()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BRA CODE_!TEMP1",hex(!Input1)
	%PrintLabel()
endmacro

macro Op6()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BGE CODE_!TEMP1",hex(!Input1)
endmacro

macro Op7()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BLT CODE_!TEMP1",hex(!Input1)
endmacro

macro Op8()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BNE CODE_!TEMP1",hex(!Input1)
endmacro

macro Op9()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BEQ CODE_!TEMP1",hex(!Input1)
endmacro

macro Op10()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BPL CODE_!TEMP1",hex(!Input1)
endmacro

macro Op11()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BMI CODE_!TEMP1",hex(!Input1)
endmacro

macro Op12()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BCC CODE_!TEMP1",hex(!Input1)
endmacro

macro Op13()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BCS CODE_!TEMP1",hex(!Input1)
endmacro

macro Op14()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BVC CODE_!TEMP1",hex(!Input1)
endmacro

macro Op15()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
	print "	BVS CODE_!TEMP1",hex(!Input1)
endmacro

macro Op16()
	print "	TO R0"
endmacro

macro Op17()
	print "	TO R1"
endmacro

macro Op18()
	print "	TO R2"
endmacro

macro Op19()
	print "	TO R3"
endmacro

macro Op20()
	print "	TO R4"
endmacro

macro Op21()
	print "	TO R5"
endmacro

macro Op22()
	print "	TO R6"
endmacro

macro Op23()
	print "	TO R7"
endmacro

macro Op24()
	print "	TO R8"
endmacro

macro Op25()
	print "	TO R9"
endmacro

macro Op26()
	print "	TO R10"
endmacro

macro Op27()
	print "	TO R11"
endmacro

macro Op28()
	print "	TO R12"
endmacro

macro Op29()
	print "	TO R13"
endmacro

macro Op30()
	print "	TO R14"
endmacro

macro Op31()
	print "	TO R15"
endmacro

macro Op32()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10					; WITH/TO
		print "	MOVE R",dec(!Input1&$0F),", R0"
	elseif !Input1&$F0 == $B0				; WITH/FROM
		print "	MOVES R0, R",dec(!Input1&$0F)
	else
		print "	WITH R0"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op33()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R1"
	elseif !Input1&$F0 == $B0
		print "	MOVES R1, R",dec(!Input1&$0F)
	else
		print "	WITH R1"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op34()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R2"
	elseif !Input1&$F0 == $B0
		print "	MOVES R2, R",dec(!Input1&$0F)
	else
		print "	WITH R2"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op35()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R3"
	elseif !Input1&$F0 == $B0
		print "	MOVES R3, R",dec(!Input1&$0F)
	else
		print "	WITH R3"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op36()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R4"
	elseif !Input1&$F0 == $B0
		print "	MOVES R4, R",dec(!Input1&$0F)
	else
		print "	WITH R4"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op37()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R5"
	elseif !Input1&$F0 == $B0
		print "	MOVES R5, R",dec(!Input1&$0F)
	else
		print "	WITH R5"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op38()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R6"
	elseif !Input1&$F0 == $B0
		print "	MOVES R6, R",dec(!Input1&$0F)
	else
		print "	WITH R6"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op39()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R7"
	elseif !Input1&$F0 == $B0
		print "	MOVES R7, R",dec(!Input1&$0F)
	else
		print "	WITH R7"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op40()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R8"
	elseif !Input1&$F0 == $B0
		print "	MOVES R8, R",dec(!Input1&$0F)
	else
		print "	WITH R8"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op41()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R9"
	elseif !Input1&$F0 == $B0
		print "	MOVES R9, R",dec(!Input1&$0F)
	else
		print "	WITH R9"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op42()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R10"
	elseif !Input1&$F0 == $B0
		print "	MOVES R10, R",dec(!Input1&$0F)
	else
		print "	WITH R10"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op43()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R11"
	elseif !Input1&$F0 == $B0
		print "	MOVES R11, R",dec(!Input1&$0F)
	else
		print "	WITH R11"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op44()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R12"
	elseif !Input1&$F0 == $B0
		print "	MOVES R12, R",dec(!Input1&$0F)
	else
		print "	WITH R12"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op45()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R13"
	elseif !Input1&$F0 == $B0
		print "	MOVES R13, R",dec(!Input1&$0F)
	else
		print "	WITH R13"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op46()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R14"
	elseif !Input1&$F0 == $B0
		print "	MOVES R14, R",dec(!Input1&$0F)
	else
		print "	WITH R14"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op47()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		print "	MOVE R",dec(!Input1&$0F),", R15"
	elseif !Input1&$F0 == $B0
		print "	MOVES R15, R",dec(!Input1&$0F)
	else
		print "	WITH R15"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op48()
	print "	STW (R0)"
endmacro

macro Op49()
	print "	STW (R1)"
endmacro

macro Op50()
	print "	STW (R2)"
endmacro

macro Op51()
	print "	STW (R3)"
endmacro

macro Op52()
	print "	STW (R4)"
endmacro

macro Op53()
	print "	STW (R5)"
endmacro

macro Op54()
	print "	STW (R6)"
endmacro

macro Op55()
	print "	STW (R7)"
endmacro

macro Op56()
	print "	STW (R8)"
endmacro

macro Op57()
	print "	STW (R9)"
endmacro

macro Op58()
	print "	STW (R10)"
endmacro

macro Op59()
	print "	STW (R11)"
endmacro

macro Op60()
	%readbyte(Input1, TEMP1)
	if !Input1 == $01
		print "	LOOP : NOP"
	else
		print "	LOOP"
		!ByteCounter #= !ByteCounter-1
	endif
endmacro

macro Op61()
	%readbyte(Input1, TEMP1)
	!TEMP3 #= !Input1&$0F
	if !Input1&$F0 == $30
		if !Input1 >= $3C
			print "	ALT1"
			%GetOpcode()
			%Op!Input1()
		else
			print "	STB (R",dec(!TEMP3),")"
		endif
	elseif !Input1 == $4C
		print "	RPIX"
	elseif !Input1 == $4E
		print "	CMODE"
	elseif !Input1&$F0 == $40
		if !Input1 >= $4C
			print "	ALT1"
			%GetOpcode()
			%Op!Input1()
		else
			print "	LDB (R",dec(!TEMP3),")"
		endif
	elseif !Input1&$F0 == $50
		print "	ADC R",dec(!TEMP3)
	elseif !Input1&$F0 == $60
		print "	SBC R",dec(!TEMP3)
	elseif !Input1&$F0 == $70
		if !Input1 == $70
			print "	ALT1"
			%GetOpcode()
			%Op!Input1()
		else
			print "	BIC R",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $80
		print "	UMULT R",dec(!TEMP3)
	elseif !Input1 == $96
		print "	DIV2"
	elseif !Input1 == $98
		print "	LJMP R",dec(!TEMP3)
		%PrintLabel()
	elseif !Input1 == $99
		print "	LJMP R",dec(!TEMP3)
		%PrintLabel()
	elseif !Input1 == $9A
		print "	LJMP R",dec(!TEMP3)
		%PrintLabel()
	elseif !Input1 == $9B
		print "	LJMP R",dec(!TEMP3)
		%PrintLabel()
	elseif !Input1 == $9C
		print "	LJMP R",dec(!TEMP3)
		%PrintLabel()
	elseif !Input1 == $9D
		print "	LJMP R",dec(!TEMP3)
		%PrintLabel()
	elseif !Input1 == $9F
		print "	LMULT"
	elseif !Input1&$F0 == $A0
		%readbyte(Input1, TEMP1)
		print "	LMS R",dec(!TEMP3),", ($!TEMP1",hex(!Input1*$02),")"
	elseif !Input1&$F0 == $C0
		print "	XOR R",dec(!TEMP3)
	elseif !Input1 == $EF
		print "	GETBH"
	elseif !Input1&$F0 == $F0
		%readword()
		print "	LM R",dec(!TEMP3),", ($!TEMP1",hex(!Input1),")"
	else
		print "	ALT1"
		%GetOpcode()
		%Op!Input1()
	endif
endmacro

macro Op62()
	%readbyte(Input1, TEMP1)
	!TEMP3 #= !Input1&$0F
	if !Input1&$F0 == $50
		print "	ADD #",dec(!TEMP3)
	elseif !Input1&$F0 == $60
		print "	SUB #",dec(!TEMP3)
	elseif !Input1&$F0 == $70
		print "	AND #",dec(!TEMP3)
	elseif !Input1&$F0 == $80
		print "	MULT #",dec(!TEMP3)
	elseif !Input1&$F0 == $A0
		%readbyte(Input1, TEMP1)
		print "	SMS ($!TEMP1",hex(!Input1*$02),"), R",dec(!TEMP3)
	elseif !Input1&$F0 == $C0
		print "	OR #",dec(!TEMP3)
	elseif !Input1 == $DF
		print "	RAMB"
	elseif !Input1 == $EF
		print "	GETBL"
	elseif !Input1&$F0 == $F0
		%readword()
		print "	SM ($!TEMP1",hex(!Input1),"), R",dec(!TEMP3)
	else
		print "	ALT2"
		%GetOpcode()
		%Op!Input1()
	endif
endmacro

macro Op63()
	%readbyte(Input1, TEMP1)
	!TEMP3 #= !Input1&$0F
	if !Input1&$F0 == $50
		print "	ADC #",dec(!TEMP3)
	elseif !Input1&$F0 == $60
		print "	CMP R",dec(!TEMP3)
	elseif !Input1&$F0 == $70
		print "	BIC #",dec(!TEMP3)
	elseif !Input1&$F0 == $80
		print "	UMULT #",dec(!TEMP3)
	elseif !Input1&$F0 == $C0
		print "	XOR #",dec(!TEMP3)
	elseif !Input1 == $DF
		print "	ROMB"
	elseif !Input1 == $EF
		print "	GETBS"
	else
		print "	ALT3"
		%GetOpcode()
		%Op!Input1()
	endif
endmacro

macro Op64()
	print "	LDW (R0)"
endmacro

macro Op65()
	print "	LDW (R1)"
endmacro

macro Op66()
	print "	LDW (R2)"
endmacro

macro Op67()
	print "	LDW (R3)"
endmacro

macro Op68()
	print "	LDW (R4)"
endmacro

macro Op69()
	print "	LDW (R5)"
endmacro

macro Op70()
	print "	LDW (R6)"
endmacro

macro Op71()
	print "	LDW (R7)"
endmacro

macro Op72()
	print "	LDW (R8)"
endmacro

macro Op73()
	print "	LDW (R9)"
endmacro

macro Op74()
	print "	LDW (R10)"
endmacro

macro Op75()
	print "	LDW (R11)"
endmacro

macro Op76()
	print "	PLOT"
endmacro

macro Op77()
	print "	SWAP"
endmacro

macro Op78()
	print "	COLOR"
endmacro

macro Op79()
	print "	NOT"
endmacro

macro Op80()
	print "	ADD R0"
endmacro

macro Op81()
	print "	ADD R1"
endmacro

macro Op82()
	print "	ADD R2"
endmacro

macro Op83()
	print "	ADD R3"
endmacro

macro Op84()
	print "	ADD R4"
endmacro

macro Op85()
	print "	ADD R5"
endmacro

macro Op86()
	print "	ADD R6"
endmacro

macro Op87()
	print "	ADD R7"
endmacro

macro Op88()
	print "	ADD R8"
endmacro

macro Op89()
	print "	ADD R9"
endmacro

macro Op90()
	print "	ADD R10"
endmacro

macro Op91()
	print "	ADD R11"
endmacro

macro Op92()
	print "	ADD R12"
endmacro

macro Op93()
	print "	ADD R13"
endmacro

macro Op94()
	print "	ADD R14"
endmacro

macro Op95()
	print "	ADD R15"
endmacro

macro Op96()
	print "	SUB R0"
endmacro

macro Op97()
	print "	SUB R1"
endmacro

macro Op98()
	print "	SUB R2"
endmacro

macro Op99()
	print "	SUB R3"
endmacro

macro Op100()
	print "	SUB R4"
endmacro

macro Op101()
	print "	SUB R5"
endmacro

macro Op102()
	print "	SUB R6"
endmacro

macro Op103()
	print "	SUB R7"
endmacro

macro Op104()
	print "	SUB R8"
endmacro

macro Op105()
	print "	SUB R9"
endmacro

macro Op106()
	print "	SUB R10"
endmacro

macro Op107()
	print "	SUB R11"
endmacro

macro Op108()
	print "	SUB R12"
endmacro

macro Op109()
	print "	SUB R13"
endmacro

macro Op110()
	print "	SUB R14"
endmacro

macro Op111()
	print "	SUB R15"
endmacro

macro Op112()
	print "	MERGE"
endmacro

macro Op113()
	print "	AND R1"
endmacro

macro Op114()
	print "	AND R2"
endmacro

macro Op115()
	print "	AND R3"
endmacro

macro Op116()
	print "	AND R4"
endmacro

macro Op117()
	print "	AND R5"
endmacro

macro Op118()
	print "	AND R6"
endmacro

macro Op119()
	print "	AND R7"
endmacro

macro Op120()
	print "	AND R8"
endmacro

macro Op121()
	print "	AND R9"
endmacro

macro Op122()
	print "	AND R10"
endmacro

macro Op123()
	print "	AND R11"
endmacro

macro Op124()
	print "	AND R12"
endmacro

macro Op125()
	print "	AND R13"
endmacro

macro Op126()
	print "	AND R14"
endmacro

macro Op127()
	print "	AND R15"
endmacro

macro Op128()
	print "	MULT R0"
endmacro

macro Op129()
	print "	MULT R1"
endmacro

macro Op130()
	print "	MULT R2"
endmacro

macro Op131()
	print "	MULT R3"
endmacro

macro Op132()
	print "	MULT R4"
endmacro

macro Op133()
	print "	MULT R5"
endmacro

macro Op134()
	print "	MULT R6"
endmacro

macro Op135()
	print "	MULT R7"
endmacro

macro Op136()
	print "	MULT R8"
endmacro

macro Op137()
	print "	MULT R9"
endmacro

macro Op138()
	print "	MULT R10"
endmacro

macro Op139()
	print "	MULT R11"
endmacro

macro Op140()
	print "	MULT R12"
endmacro

macro Op141()
	print "	MULT R13"
endmacro

macro Op142()
	print "	MULT R14"
endmacro

macro Op143()
	print "	MULT R15"
endmacro

macro Op144()
	print "	SBK"
endmacro

macro Op145()
	print "	LINK #1"
endmacro

macro Op146()
	print "	LINK #2"
endmacro

macro Op147()
	print "	LINK #3"
endmacro

macro Op148()
	print "	LINK #4"
endmacro

macro Op149()
	print "	SEX"
endmacro

macro Op150()
	print "	ASR"
endmacro

macro Op151()
	print "	ROR"
endmacro

macro Op152()
	print "	JMP R8"
	%PrintLabel()
endmacro

macro Op153()
	print "	JMP R9"
	%PrintLabel()
endmacro

macro Op154()
	print "	JMP R10"
	%PrintLabel()
endmacro

macro Op155()
	print "	JMP R11"
	%PrintLabel()
endmacro

macro Op156()
	print "	JMP R12"
	%PrintLabel()
endmacro

macro Op157()
	print "	JMP R13"
	%PrintLabel()
endmacro

macro Op158()
	print "	LOB"
endmacro

macro Op159()
	print "	FMULT"
endmacro

macro Op160()
	%readbyte(Input1, TEMP1)
	print "	IBT R0, #$!TEMP1",hex(!Input1)
endmacro

macro Op161()
	%readbyte(Input1, TEMP1)
	print "	IBT R1, #$!TEMP1",hex(!Input1)
endmacro

macro Op162()
	%readbyte(Input1, TEMP1)
	print "	IBT R2, #$!TEMP1",hex(!Input1)
endmacro

macro Op163()
	%readbyte(Input1, TEMP1)
	print "	IBT R3, #$!TEMP1",hex(!Input1)
endmacro

macro Op164()
	%readbyte(Input1, TEMP1)
	print "	IBT R4, #$!TEMP1",hex(!Input1)
endmacro

macro Op165()
	%readbyte(Input1, TEMP1)
	print "	IBT R5, #$!TEMP1",hex(!Input1)
endmacro

macro Op166()
	%readbyte(Input1, TEMP1)
	print "	IBT R6, #$!TEMP1",hex(!Input1)
endmacro

macro Op167()
	%readbyte(Input1, TEMP1)
	print "	IBT R7, #$!TEMP1",hex(!Input1)
endmacro

macro Op168()
	%readbyte(Input1, TEMP1)
	print "	IBT R8, #$!TEMP1",hex(!Input1)
endmacro

macro Op169()
	%readbyte(Input1, TEMP1)
	print "	IBT R9, #$!TEMP1",hex(!Input1)
endmacro

macro Op170()
	%readbyte(Input1, TEMP1)
	print "	IBT R10, #$!TEMP1",hex(!Input1)
endmacro

macro Op171()
	%readbyte(Input1, TEMP1)
	print "	IBT R11, #$!TEMP1",hex(!Input1)
endmacro

macro Op172()
	%readbyte(Input1, TEMP1)
	print "	IBT R12, #$!TEMP1",hex(!Input1)
endmacro

macro Op173()
	%readbyte(Input1, TEMP1)
	print "	IBT R13, #$!TEMP1",hex(!Input1)
endmacro

macro Op174()
	%readbyte(Input1, TEMP1)
	print "	IBT R14, #$!TEMP1",hex(!Input1)
endmacro

macro Op175()
	%readbyte(Input1, TEMP1)
	print "	IBT R15, #$!TEMP1",hex(!Input1)
endmacro

macro Op176()
	print "	FROM R0"
endmacro

macro Op177()
	print "	FROM R1"
endmacro

macro Op178()
	print "	FROM R2"
endmacro

macro Op179()
	print "	FROM R3"
endmacro

macro Op180()
	print "	FROM R4"
endmacro

macro Op181()
	print "	FROM R5"
endmacro

macro Op182()
	print "	FROM R6"
endmacro

macro Op183()
	print "	FROM R7"
endmacro

macro Op184()
	print "	FROM R8"
endmacro

macro Op185()
	print "	FROM R9"
endmacro

macro Op186()
	print "	FROM R10"
endmacro

macro Op187()
	print "	FROM R11"
endmacro

macro Op188()
	print "	FROM R12"
endmacro

macro Op189()
	print "	FROM R13"
endmacro

macro Op190()
	print "	FROM R14"
endmacro

macro Op191()
	print "	FROM R15"
endmacro

macro Op192()
	print "	HIB"
endmacro

macro Op193()
	print "	OR R1"
endmacro

macro Op194()
	print "	OR R2"
endmacro

macro Op195()
	print "	OR R3"
endmacro

macro Op196()
	print "	OR R4"
endmacro

macro Op197()
	print "	OR R5"
endmacro

macro Op198()
	print "	OR R6"
endmacro

macro Op199()
	print "	OR R7"
endmacro

macro Op200()
	print "	OR R8"
endmacro

macro Op201()
	print "	OR R9"
endmacro

macro Op202()
	print "	OR R10"
endmacro

macro Op203()
	print "	OR R11"
endmacro

macro Op204()
	print "	OR R12"
endmacro

macro Op205()
	print "	OR R13"
endmacro

macro Op206()
	print "	OR R14"
endmacro

macro Op207()
	print "	OR R15"
endmacro

macro Op208()
	print "	INC R0"
endmacro

macro Op209()
	print "	INC R1"
endmacro

macro Op210()
	print "	INC R2"
endmacro

macro Op211()
	print "	INC R3"
endmacro

macro Op212()
	print "	INC R4"
endmacro

macro Op213()
	print "	INC R5"
endmacro

macro Op214()
	print "	INC R6"
endmacro

macro Op215()
	print "	INC R7"
endmacro

macro Op216()
	print "	INC R8"
endmacro

macro Op217()
	print "	INC R9"
endmacro

macro Op218()
	print "	INC R10"
endmacro

macro Op219()
	print "	INC R11"
endmacro

macro Op220()
	print "	INC R12"
endmacro

macro Op221()
	print "	INC R13"
endmacro

macro Op222()
	print "	INC R14"
endmacro

macro Op223()
	print "	GETC"
endmacro

macro Op224()
	print "	DEC R0"
endmacro

macro Op225()
	print "	DEC R1"
endmacro

macro Op226()
	print "	DEC R2"
endmacro

macro Op227()
	print "	DEC R3"
endmacro

macro Op228()
	print "	DEC R4"
endmacro

macro Op229()
	print "	DEC R5"
endmacro

macro Op230()
	print "	DEC R6"
endmacro

macro Op231()
	print "	DEC R7"
endmacro

macro Op232()
	print "	DEC R8"
endmacro

macro Op233()
	print "	DEC R9"
endmacro

macro Op234()
	print "	DEC R10"
endmacro

macro Op235()
	print "	DEC R11"
endmacro

macro Op236()
	print "	DEC R12"
endmacro

macro Op237()
	print "	DEC R13"
endmacro

macro Op238()
	print "	DEC R14"
endmacro

macro Op239()
	print "	GETB"
endmacro

macro Op240()
	%readword()
	print "	IWT R0, #$!TEMP1",hex(!Input1)
endmacro

macro Op241()
	%readword()
	print "	IWT R1, #$!TEMP1",hex(!Input1)
endmacro

macro Op242()
	%readword()
	print "	IWT R2, #$!TEMP1",hex(!Input1)
endmacro

macro Op243()
	%readword()
	print "	IWT R3, #$!TEMP1",hex(!Input1)
endmacro

macro Op244()
	%readword()
	print "	IWT R4, #$!TEMP1",hex(!Input1)
endmacro

macro Op245()
	%readword()
	print "	IWT R5, #$!TEMP1",hex(!Input1)
endmacro

macro Op246()
	%readword()
	print "	IWT R6, #$!TEMP1",hex(!Input1)
endmacro

macro Op247()
	%readword()
	print "	IWT R7, #$!TEMP1",hex(!Input1)
endmacro

macro Op248()
	%readword()
	print "	IWT R8, #$!TEMP1",hex(!Input1)
endmacro

macro Op249()
	%readword()
	print "	IWT R9, #$!TEMP1",hex(!Input1)
endmacro

macro Op250()
	%readword()
	print "	IWT R10, #$!TEMP1",hex(!Input1)
endmacro

macro Op251()
	%readword()
	print "	IWT R11, #$!TEMP1",hex(!Input1)
endmacro

macro Op252()
	%readword()
	print "	IWT R12, #$!TEMP1",hex(!Input1)
endmacro

macro Op253()
	%readword()
	print "	IWT R13, #$!TEMP1",hex(!Input1)
endmacro

macro Op254()
	%readword()
	print "	IWT R14, #$!TEMP1",hex(!Input1)
endmacro

macro Op255()
	%readword()
	%readbyte(Input2, TEMP2)
	if !Input2 == $01
		print "	IWT R15, #$!TEMP1",hex(!Input1)," : NOP"
	else
		print "	IWT R15, #$!TEMP1",hex(!Input1)
		!ByteCounter #= !ByteCounter-1
	endif
	%PrintLabel()
endmacro

org !ROMOffset
while !ByteCounter < 8192
	%GetOpcode()
	%Op!Input1()
	!LoopCounter #= !LoopCounter+1
endif

!Input1 #= !ROMOffset+!ByteCounter
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
print "Disassembly has ended at $!TEMP1",hex(!ROMOffset+!ByteCounter)
