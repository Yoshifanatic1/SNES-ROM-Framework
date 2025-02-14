asar 1.91

; Modify these as needed
sfxrom								; The memory map of the ROM. Seeing as this script is for SuperFX asm, you likely won't need to change it.
!ROMOffset = $088000				; The ROM offset to begin disassembly from.
!Bank = 08							; Affects the bank byte for the label used in IWT R15 instructions.
!DoTwoPassesFlag = 1				; If 1, the script will run twice, with the purpose of generating labels that appear before the branch that points to it. Turning this on may slow down disassembly speed, however.
!MaxBytes = 32768					; The maximum amount of bytes that will be read at a time. Setting this lower/higher will speed up/slow down disassembly.

; Don't touch these
!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!TEMP1 = ""
!TEMP2 = ""
!TEMP3 = ""
!Pass = 0
!CurrentOffset #= !ROMOffset

macro GetOpcode()
	!Input1 #= read1(!ROMOffset+!ByteCounter)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readbyte(Input, TEMP)
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
	%readbyte(Input1, TEMP1)
	if !Input1 == $01
		if !Pass == 1
			print "	STOP : NOP"
		endif
	else
		if !Pass == 1
			print "	STOP"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op1()
if !Pass == 1
	print "	NOP"
endif
endmacro

macro Op2()
if !Pass == 1
	print "	CACHE"
endif
endmacro

macro Op3()
if !Pass == 1
	print "	LSR"
endif
endmacro

macro Op4()
if !Pass == 1
	print "	ROL"
endif
endmacro

macro Op5()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BRA CODE_",hex(!Input1, 6)
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op6()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BGE CODE_",hex(!Input1, 6)
endif
endmacro

macro Op7()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BLT CODE_",hex(!Input1, 6)
endif
endmacro

macro Op8()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BNE CODE_",hex(!Input1, 6)
endif
endmacro

macro Op9()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BEQ CODE_",hex(!Input1, 6)
endif
endmacro

macro Op10()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BPL CODE_",hex(!Input1, 6)
endif
endmacro

macro Op11()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BMI CODE_",hex(!Input1, 6)
endif
endmacro

macro Op12()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BCC CODE_",hex(!Input1, 6)
endif
endmacro

macro Op13()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BCS CODE_",hex(!Input1, 6)
endif
endmacro

macro Op14()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BVC CODE_",hex(!Input1, 6)
endif
endmacro

macro Op15()
	%readbyte(Input1, TEMP1)
	%HandleBranch($80, !ByteCounter)
if !Pass == 1
	print "	BVS CODE_",hex(!Input1, 6)
endif
endmacro

macro Op16()
if !Pass == 1
	print "	TO R0"
endif
endmacro

macro Op17()
if !Pass == 1
	print "	TO R1"
endif
endmacro

macro Op18()
if !Pass == 1
	print "	TO R2"
endif
endmacro

macro Op19()
if !Pass == 1
	print "	TO R3"
endif
endmacro

macro Op20()
if !Pass == 1
	print "	TO R4"
endif
endmacro

macro Op21()
if !Pass == 1
	print "	TO R5"
endif
endmacro

macro Op22()
if !Pass == 1
	print "	TO R6"
endif
endmacro

macro Op23()
if !Pass == 1
	print "	TO R7"
endif
endmacro

macro Op24()
if !Pass == 1
	print "	TO R8"
endif
endmacro

macro Op25()
if !Pass == 1
	print "	TO R9"
endif
endmacro

macro Op26()
if !Pass == 1
	print "	TO R10"
endif
endmacro

macro Op27()
if !Pass == 1
	print "	TO R11"
endif
endmacro

macro Op28()
if !Pass == 1
	print "	TO R12"
endif
endmacro

macro Op29()
if !Pass == 1
	print "	TO R13"
endif
endmacro

macro Op30()
if !Pass == 1
	print "	TO R14"
endif
endmacro

macro Op31()
if !Pass == 1
	print "	TO R15"
endif
endmacro

macro Op32()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10					; WITH/TO
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R0"
		endif
	elseif !Input1&$F0 == $B0				; WITH/FROM
		if !Pass == 1
			print "	MOVES R0, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R0"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op33()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R1"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R1, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R1"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op34()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R2"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R2, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R2"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op35()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R3"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R3, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R3"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op36()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R4"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R4, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R4"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op37()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R5"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R5, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R5"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op38()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R6"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R6, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R6"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op39()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R7"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R7, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R7"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op40()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R8"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R8, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R8"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op41()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R9"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R9, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R9"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op42()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R10"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R10, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R10"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op43()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R11"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R11, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R11"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op44()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R12"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R12, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R12"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op45()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R13"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R13, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R13"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op46()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R14"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R14, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R14"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op47()
	%readbyte(Input1, TEMP1)
	if !Input1&$F0 == $10
		if !Pass == 1
			print "	MOVE R",dec(!Input1&$0F),", R15"
		endif
	elseif !Input1&$F0 == $B0
		if !Pass == 1
			print "	MOVES R15, R",dec(!Input1&$0F)
		endif
	else
		if !Pass == 1
			print "	WITH R15"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op48()
if !Pass == 1
	print "	STW (R0)"
endif
endmacro

macro Op49()
if !Pass == 1
	print "	STW (R1)"
endif
endmacro

macro Op50()
if !Pass == 1
	print "	STW (R2)"
endif
endmacro

macro Op51()
if !Pass == 1
	print "	STW (R3)"
endif
endmacro

macro Op52()
if !Pass == 1
	print "	STW (R4)"
endif
endmacro

macro Op53()
if !Pass == 1
	print "	STW (R5)"
endif
endmacro

macro Op54()
if !Pass == 1
	print "	STW (R6)"
endif
endmacro

macro Op55()
if !Pass == 1
	print "	STW (R7)"
endif
endmacro

macro Op56()
if !Pass == 1
	print "	STW (R8)"
endif
endmacro

macro Op57()
if !Pass == 1
	print "	STW (R9)"
endif
endmacro

macro Op58()
if !Pass == 1
	print "	STW (R10)"
endif
endmacro

macro Op59()
if !Pass == 1
	print "	STW (R11)"
endif
endmacro

macro Op60()
	%readbyte(Input1, TEMP1)
	if !Input1 == $01
		if !Pass == 1
			print "	LOOP : NOP"
		endif
	else
		if !Pass == 1
			print "	LOOP"
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
endmacro

macro Op61()
	%readbyte(Input1, TEMP1)
	!TEMP3 #= !Input1&$0F
	if !Input1&$F0 == $30
		if !Input1 >= $3C
			if !Pass == 1
				print "	ALT1"
			endif
			%GetOpcode()
			%Op!Input1()
		else
			if !Pass == 1
				print "	STB (R",dec(!TEMP3),")"
			endif
		endif
	elseif !Input1 == $4C
		if !Pass == 1
			print "	RPIX"
		endif
	elseif !Input1 == $4E
		if !Pass == 1
			print "	CMODE"
		endif
	elseif !Input1&$F0 == $40
		if !Input1 >= $4C
			if !Pass == 1
				print "	ALT1"
			endif
			%GetOpcode()
			%Op!Input1()
		else
			if !Pass == 1
				print "	LDB (R",dec(!TEMP3),")"
			endif
		endif
	elseif !Input1&$F0 == $50
		if !Pass == 1
			print "	ADC R",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $60
		if !Pass == 1
			print "	SBC R",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $70
		if !Input1 == $70
			if !Pass == 1
				print "	ALT1"
			endif
			%GetOpcode()
			%Op!Input1()
		else
			if !Pass == 1
				print "	BIC R",dec(!TEMP3)
			endif
		endif
	elseif !Input1&$F0 == $80
		if !Pass == 1
			print "	UMULT R",dec(!TEMP3)
		endif
	elseif !Input1 == $96
		if !Pass == 1
			print "	DIV2"
		endif
	elseif !Input1 == $98
		if !Pass == 1
			print "	LJMP R",dec(!TEMP3)
		endif
		%DefineLabelAfterNoPassOpcode(!CurrentOffset)
	elseif !Input1 == $99
		if !Pass == 1
			print "	LJMP R",dec(!TEMP3)
		endif
		%DefineLabelAfterNoPassOpcode(!CurrentOffset)
	elseif !Input1 == $9A
		if !Pass == 1
			print "	LJMP R",dec(!TEMP3)
		endif
		%DefineLabelAfterNoPassOpcode(!CurrentOffset)
	elseif !Input1 == $9B
		if !Pass == 1
			print "	LJMP R",dec(!TEMP3)
		endif
		%DefineLabelAfterNoPassOpcode(!CurrentOffset)
	elseif !Input1 == $9C
		if !Pass == 1
			print "	LJMP R",dec(!TEMP3)
		endif
		%DefineLabelAfterNoPassOpcode(!CurrentOffset)
	elseif !Input1 == $9D
		if !Pass == 1
			print "	LJMP R",dec(!TEMP3)
		endif
		%DefineLabelAfterNoPassOpcode(!CurrentOffset)
	elseif !Input1 == $9F
		if !Pass == 1
			print "	LMULT"
		endif
	elseif !Input1&$F0 == $A0
		%readbyte(Input1, TEMP1)
		if !Pass == 1
			print "	LMS R",dec(!TEMP3),", ($",hex(!Input1*$02, 2),")"
		endif
	elseif !Input1&$F0 == $C0
		if !Pass == 1
			print "	XOR R",dec(!TEMP3)
		endif
	elseif !Input1 == $EF
		if !Pass == 1
			print "	GETBH"
		endif
	elseif !Input1&$F0 == $F0
		%readword()
		if !Pass == 1
			print "	LM R",dec(!TEMP3),", ($",hex(!Input1, 4),")"
		endif
	else
		if !Pass == 1
			print "	ALT1"
		endif
		%GetOpcode()
		%Op!Input1()
	endif
endmacro

macro Op62()
	%readbyte(Input1, TEMP1)
	!TEMP3 #= !Input1&$0F
	if !Input1&$F0 == $50
		if !Pass == 1
			print "	ADD #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $60
		if !Pass == 1
			print "	SUB #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $70
		if !Pass == 1
			print "	AND #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $80
		if !Pass == 1
			print "	MULT #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $A0
		%readbyte(Input1, TEMP1)
		if !Pass == 1
			print "	SMS ($",hex(!Input1*$02, 2),"), R",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $C0
		if !Pass == 1
			print "	OR #",dec(!TEMP3)
		endif
	elseif !Input1 == $DF
		if !Pass == 1
			print "	RAMB"
		endif
	elseif !Input1 == $EF
		if !Pass == 1
			print "	GETBL"
		endif
	elseif !Input1&$F0 == $F0
		%readword()
		if !Pass == 1
			print "	SM ($",hex(!Input1, 4),"), R",dec(!TEMP3)
		endif
	else
		if !Pass == 1
			print "	ALT2"
		endif
		%GetOpcode()
		%Op!Input1()
	endif
endmacro

macro Op63()
	%readbyte(Input1, TEMP1)
	!TEMP3 #= !Input1&$0F
	if !Input1&$F0 == $50
		if !Pass == 1
			print "	ADC #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $60
		if !Pass == 1
			print "	CMP R",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $70
		if !Pass == 1
			print "	BIC #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $80
		if !Pass == 1
			print "	UMULT #",dec(!TEMP3)
		endif
	elseif !Input1&$F0 == $C0
		if !Pass == 1
			print "	XOR #",dec(!TEMP3)
		endif
	elseif !Input1 == $DF
		if !Pass == 1
			print "	ROMB"
		endif
	elseif !Input1 == $EF
		if !Pass == 1
			print "	GETBS"
		endif
	else
		if !Pass == 1
			print "	ALT3"
		endif
		%GetOpcode()
		%Op!Input1()
	endif
endmacro

macro Op64()
if !Pass == 1
	print "	LDW (R0)"
endif
endmacro

macro Op65()
if !Pass == 1
	print "	LDW (R1)"
endif
endmacro

macro Op66()
if !Pass == 1
	print "	LDW (R2)"
endif
endmacro

macro Op67()
if !Pass == 1
	print "	LDW (R3)"
endif
endmacro

macro Op68()
if !Pass == 1
	print "	LDW (R4)"
endif
endmacro

macro Op69()
if !Pass == 1
	print "	LDW (R5)"
endif
endmacro

macro Op70()
if !Pass == 1
	print "	LDW (R6)"
endif
endmacro

macro Op71()
if !Pass == 1
	print "	LDW (R7)"
endif
endmacro

macro Op72()
if !Pass == 1
	print "	LDW (R8)"
endif
endmacro

macro Op73()
if !Pass == 1
	print "	LDW (R9)"
endif
endmacro

macro Op74()
if !Pass == 1
	print "	LDW (R10)"
endif
endmacro

macro Op75()
if !Pass == 1
	print "	LDW (R11)"
endif
endmacro

macro Op76()
if !Pass == 1
	print "	PLOT"
endif
endmacro

macro Op77()
if !Pass == 1
	print "	SWAP"
endif
endmacro

macro Op78()
if !Pass == 1
	print "	COLOR"
endif
endmacro

macro Op79()
if !Pass == 1
	print "	NOT"
endif
endmacro

macro Op80()
if !Pass == 1
	print "	ADD R0"
endif
endmacro

macro Op81()
if !Pass == 1
	print "	ADD R1"
endif
endmacro

macro Op82()
if !Pass == 1
	print "	ADD R2"
endif
endmacro

macro Op83()
if !Pass == 1
	print "	ADD R3"
endif
endmacro

macro Op84()
if !Pass == 1
	print "	ADD R4"
endif
endmacro

macro Op85()
if !Pass == 1
	print "	ADD R5"
endif
endmacro

macro Op86()
if !Pass == 1
	print "	ADD R6"
endif
endmacro

macro Op87()
if !Pass == 1
	print "	ADD R7"
endif
endmacro

macro Op88()
if !Pass == 1
	print "	ADD R8"
endif
endmacro

macro Op89()
if !Pass == 1
	print "	ADD R9"
endif
endmacro

macro Op90()
if !Pass == 1
	print "	ADD R10"
endif
endmacro

macro Op91()
if !Pass == 1
	print "	ADD R11"
endif
endmacro

macro Op92()
if !Pass == 1
	print "	ADD R12"
endif
endmacro

macro Op93()
if !Pass == 1
	print "	ADD R13"
endif
endmacro

macro Op94()
if !Pass == 1
	print "	ADD R14"
endif
endmacro

macro Op95()
if !Pass == 1
	print "	ADD R15"
endif
endmacro

macro Op96()
if !Pass == 1
	print "	SUB R0"
endif
endmacro

macro Op97()
if !Pass == 1
	print "	SUB R1"
endif
endmacro

macro Op98()
if !Pass == 1
	print "	SUB R2"
endif
endmacro

macro Op99()
if !Pass == 1
	print "	SUB R3"
endif
endmacro

macro Op100()
if !Pass == 1
	print "	SUB R4"
endif
endmacro

macro Op101()
if !Pass == 1
	print "	SUB R5"
endif
endmacro

macro Op102()
if !Pass == 1
	print "	SUB R6"
endif
endmacro

macro Op103()
if !Pass == 1
	print "	SUB R7"
endif
endmacro

macro Op104()
if !Pass == 1
	print "	SUB R8"
endif
endmacro

macro Op105()
if !Pass == 1
	print "	SUB R9"
endif
endmacro

macro Op106()
if !Pass == 1
	print "	SUB R10"
endif
endmacro

macro Op107()
if !Pass == 1
	print "	SUB R11"
endif
endmacro

macro Op108()
if !Pass == 1
	print "	SUB R12"
endif
endmacro

macro Op109()
if !Pass == 1
	print "	SUB R13"
endif
endmacro

macro Op110()
if !Pass == 1
	print "	SUB R14"
endif
endmacro

macro Op111()
if !Pass == 1
	print "	SUB R15"
endif
endmacro

macro Op112()
if !Pass == 1
	print "	MERGE"
endif
endmacro

macro Op113()
if !Pass == 1
	print "	AND R1"
endif
endmacro

macro Op114()
if !Pass == 1
	print "	AND R2"
endif
endmacro

macro Op115()
if !Pass == 1
	print "	AND R3"
endif
endmacro

macro Op116()
if !Pass == 1
	print "	AND R4"
endif
endmacro

macro Op117()
if !Pass == 1
	print "	AND R5"
endif
endmacro

macro Op118()
if !Pass == 1
	print "	AND R6"
endif
endmacro

macro Op119()
if !Pass == 1
	print "	AND R7"
endif
endmacro

macro Op120()
if !Pass == 1
	print "	AND R8"
endif
endmacro

macro Op121()
if !Pass == 1
	print "	AND R9"
endif
endmacro

macro Op122()
if !Pass == 1
	print "	AND R10"
endif
endmacro

macro Op123()
if !Pass == 1
	print "	AND R11"
endif
endmacro

macro Op124()
if !Pass == 1
	print "	AND R12"
endif
endmacro

macro Op125()
if !Pass == 1
	print "	AND R13"
endif
endmacro

macro Op126()
if !Pass == 1
	print "	AND R14"
endif
endmacro

macro Op127()
if !Pass == 1
	print "	AND R15"
endif
endmacro

macro Op128()
if !Pass == 1
	print "	MULT R0"
endif
endmacro

macro Op129()
if !Pass == 1
	print "	MULT R1"
endif
endmacro

macro Op130()
if !Pass == 1
	print "	MULT R2"
endif
endmacro

macro Op131()
if !Pass == 1
	print "	MULT R3"
endif
endmacro

macro Op132()
if !Pass == 1
	print "	MULT R4"
endif
endmacro

macro Op133()
if !Pass == 1
	print "	MULT R5"
endif
endmacro

macro Op134()
if !Pass == 1
	print "	MULT R6"
endif
endmacro

macro Op135()
if !Pass == 1
	print "	MULT R7"
endif
endmacro

macro Op136()
if !Pass == 1
	print "	MULT R8"
endif
endmacro

macro Op137()
if !Pass == 1
	print "	MULT R9"
endif
endmacro

macro Op138()
if !Pass == 1
	print "	MULT R10"
endif
endmacro

macro Op139()
if !Pass == 1
	print "	MULT R11"
endif
endmacro

macro Op140()
if !Pass == 1
	print "	MULT R12"
endif
endmacro

macro Op141()
if !Pass == 1
	print "	MULT R13"
endif
endmacro

macro Op142()
if !Pass == 1
	print "	MULT R14"
endif
endmacro

macro Op143()
if !Pass == 1
	print "	MULT R15"
endif
endmacro

macro Op144()
if !Pass == 1
	print "	SBK"
endif
endmacro

macro Op145()
if !Pass == 1
	print "	LINK #1"
endif
endmacro

macro Op146()
if !Pass == 1
	print "	LINK #2"
endif
endmacro

macro Op147()
if !Pass == 1
	print "	LINK #3"
endif
endmacro

macro Op148()
if !Pass == 1
	print "	LINK #4"
endif
endmacro

macro Op149()
if !Pass == 1
	print "	SEX"
endif
endmacro

macro Op150()
if !Pass == 1
	print "	ASR"
endif
endmacro

macro Op151()
if !Pass == 1
	print "	ROR"
endif
endmacro

macro Op152()
if !Pass == 1
	print "	JMP R8"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op153()
if !Pass == 1
	print "	JMP R9"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op154()
if !Pass == 1
	print "	JMP R10"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op155()
if !Pass == 1
	print "	JMP R11"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op156()
if !Pass == 1
	print "	JMP R12"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op157()
if !Pass == 1
	print "	JMP R13"
endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
endmacro

macro Op158()
if !Pass == 1
	print "	LOB"
endif
endmacro

macro Op159()
if !Pass == 1
	print "	FMULT"
endif
endmacro

macro Op160()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R0, #$",hex(!Input1, 2)
endif
endmacro

macro Op161()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R1, #$",hex(!Input1, 2)
endif
endmacro

macro Op162()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R2, #$",hex(!Input1, 2)
endif
endmacro

macro Op163()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R3, #$",hex(!Input1, 2)
endif
endmacro

macro Op164()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R4, #$",hex(!Input1, 2)
endif
endmacro

macro Op165()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R5, #$",hex(!Input1, 2)
endif
endmacro

macro Op166()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R6, #$",hex(!Input1, 2)
endif
endmacro

macro Op167()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R7, #$",hex(!Input1, 2)
endif
endmacro

macro Op168()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R8, #$",hex(!Input1, 2)
endif
endmacro

macro Op169()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R9, #$",hex(!Input1, 2)
endif
endmacro

macro Op170()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R10, #$",hex(!Input1, 2)
endif
endmacro

macro Op171()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R11, #$",hex(!Input1, 2)
endif
endmacro

macro Op172()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R12, #$",hex(!Input1, 2)
endif
endmacro

macro Op173()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R13, #$",hex(!Input1, 2)
endif
endmacro

macro Op174()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R14, #$",hex(!Input1, 2)
endif
endmacro

macro Op175()
	%readbyte(Input1, TEMP1)
if !Pass == 1
	print "	IBT R15, #$",hex(!Input1, 2)
endif
endmacro

macro Op176()
if !Pass == 1
	print "	FROM R0"
endif
endmacro

macro Op177()
if !Pass == 1
	print "	FROM R1"
endif
endmacro

macro Op178()
if !Pass == 1
	print "	FROM R2"
endif
endmacro

macro Op179()
if !Pass == 1
	print "	FROM R3"
endif
endmacro

macro Op180()
if !Pass == 1
	print "	FROM R4"
endif
endmacro

macro Op181()
if !Pass == 1
	print "	FROM R5"
endif
endmacro

macro Op182()
if !Pass == 1
	print "	FROM R6"
endif
endmacro

macro Op183()
if !Pass == 1
	print "	FROM R7"
endif
endmacro

macro Op184()
if !Pass == 1
	print "	FROM R8"
endif
endmacro

macro Op185()
if !Pass == 1
	print "	FROM R9"
endif
endmacro

macro Op186()
if !Pass == 1
	print "	FROM R10"
endif
endmacro

macro Op187()
if !Pass == 1
	print "	FROM R11"
endif
endmacro

macro Op188()
if !Pass == 1
	print "	FROM R12"
endif
endmacro

macro Op189()
if !Pass == 1
	print "	FROM R13"
endif
endmacro

macro Op190()
if !Pass == 1
	print "	FROM R14"
endif
endmacro

macro Op191()
if !Pass == 1
	print "	FROM R15"
endif
endmacro

macro Op192()
if !Pass == 1
	print "	HIB"
endif
endmacro

macro Op193()
if !Pass == 1
	print "	OR R1"
endif
endmacro

macro Op194()
if !Pass == 1
	print "	OR R2"
endif
endmacro

macro Op195()
if !Pass == 1
	print "	OR R3"
endif
endmacro

macro Op196()
if !Pass == 1
	print "	OR R4"
endif
endmacro

macro Op197()
if !Pass == 1
	print "	OR R5"
endif
endmacro

macro Op198()
if !Pass == 1
	print "	OR R6"
endif
endmacro

macro Op199()
if !Pass == 1
	print "	OR R7"
endif
endmacro

macro Op200()
if !Pass == 1
	print "	OR R8"
endif
endmacro

macro Op201()
if !Pass == 1
	print "	OR R9"
endif
endmacro

macro Op202()
if !Pass == 1
	print "	OR R10"
endif
endmacro

macro Op203()
if !Pass == 1
	print "	OR R11"
endif
endmacro

macro Op204()
if !Pass == 1
	print "	OR R12"
endif
endmacro

macro Op205()
if !Pass == 1
	print "	OR R13"
endif
endmacro

macro Op206()
if !Pass == 1
	print "	OR R14"
endif
endmacro

macro Op207()
if !Pass == 1
	print "	OR R15"
endif
endmacro

macro Op208()
if !Pass == 1
	print "	INC R0"
endif
endmacro

macro Op209()
if !Pass == 1
	print "	INC R1"
endif
endmacro

macro Op210()
if !Pass == 1
	print "	INC R2"
endif
endmacro

macro Op211()
if !Pass == 1
	print "	INC R3"
endif
endmacro

macro Op212()
if !Pass == 1
	print "	INC R4"
endif
endmacro

macro Op213()
if !Pass == 1
	print "	INC R5"
endif
endmacro

macro Op214()
if !Pass == 1
	print "	INC R6"
endif
endmacro

macro Op215()
if !Pass == 1
	print "	INC R7"
endif
endmacro

macro Op216()
if !Pass == 1
	print "	INC R8"
endif
endmacro

macro Op217()
if !Pass == 1
	print "	INC R9"
endif
endmacro

macro Op218()
if !Pass == 1
	print "	INC R10"
endif
endmacro

macro Op219()
if !Pass == 1
	print "	INC R11"
endif
endmacro

macro Op220()
if !Pass == 1
	print "	INC R12"
endif
endmacro

macro Op221()
if !Pass == 1
	print "	INC R13"
endif
endmacro

macro Op222()
if !Pass == 1
	print "	INC R14"
endif
endmacro

macro Op223()
if !Pass == 1
	print "	GETC"
endif
endmacro

macro Op224()
if !Pass == 1
	print "	DEC R0"
endif
endmacro

macro Op225()
if !Pass == 1
	print "	DEC R1"
endif
endmacro

macro Op226()
if !Pass == 1
	print "	DEC R2"
endif
endmacro

macro Op227()
if !Pass == 1
	print "	DEC R3"
endif
endmacro

macro Op228()
if !Pass == 1
	print "	DEC R4"
endif
endmacro

macro Op229()
if !Pass == 1
	print "	DEC R5"
endif
endmacro

macro Op230()
if !Pass == 1
	print "	DEC R6"
endif
endmacro

macro Op231()
if !Pass == 1
	print "	DEC R7"
endif
endmacro

macro Op232()
if !Pass == 1
	print "	DEC R8"
endif
endmacro

macro Op233()
if !Pass == 1
	print "	DEC R9"
endif
endmacro

macro Op234()
if !Pass == 1
	print "	DEC R10"
endif
endmacro

macro Op235()
if !Pass == 1
	print "	DEC R11"
endif
endmacro

macro Op236()
if !Pass == 1
	print "	DEC R12"
endif
endmacro

macro Op237()
if !Pass == 1
	print "	DEC R13"
endif
endmacro

macro Op238()
if !Pass == 1
	print "	DEC R14"
endif
endmacro

macro Op239()
if !Pass == 1
	print "	GETB"
endif
endmacro

macro Op240()
	%readword()
if !Pass == 1
	print "	IWT R0, #$",hex(!Input1, 4)
endif
endmacro

macro Op241()
	%readword()
if !Pass == 1
	print "	IWT R1, #$",hex(!Input1, 4)
endif
endmacro

macro Op242()
	%readword()
if !Pass == 1
	print "	IWT R2, #$",hex(!Input1, 4)
endif
endmacro

macro Op243()
	%readword()
if !Pass == 1
	print "	IWT R3, #$",hex(!Input1, 4)
endif
endmacro

macro Op244()
	%readword()
if !Pass == 1
	print "	IWT R4, #$",hex(!Input1, 4)
endif
endmacro

macro Op245()
	%readword()
if !Pass == 1
	print "	IWT R5, #$",hex(!Input1, 4)
endif
endmacro

macro Op246()
	%readword()
if !Pass == 1
	print "	IWT R6, #$",hex(!Input1, 4)
endif
endmacro

macro Op247()
	%readword()
if !Pass == 1
	print "	IWT R7, #$",hex(!Input1, 4)
endif
endmacro

macro Op248()
	%readword()
if !Pass == 1
	print "	IWT R8, #$",hex(!Input1, 4)
endif
endmacro

macro Op249()
	%readword()
if !Pass == 1
	print "	IWT R9, #$",hex(!Input1, 4)
endif
endmacro

macro Op250()
	%readword()
if !Pass == 1
	print "	IWT R10, #$",hex(!Input1, 4)
endif
endmacro

macro Op251()
	%readword()
if !Pass == 1
	print "	IWT R11, #$",hex(!Input1, 4)
endif
endmacro

macro Op252()
	%readword()
if !Pass == 1
	print "	IWT R12, #$",hex(!Input1, 4)
endif
endmacro

macro Op253()
	%readword()
if !Pass == 1
	print "	IWT R13, #$",hex(!Input1, 4)
endif
endmacro

macro Op254()
	%readword()
if !Pass == 1
	print "	IWT R14, #$",hex(!Input1, 4)
endif
endmacro

macro Op255()
	%readword()
	!Input2 #= !Input1+($!Bank<<16)
	%HandleJump(!Input2)
	%readbyte(Input2, TEMP2)
	if !Input2 == $01
		if !Pass == 1
			print "	IWT R15, #CODE_!Bank",hex(!Input1, 4)," : NOP"
		endif
	else
		if !Pass == 1
			print "	IWT R15, #CODE_!Bank",hex(!Input1, 4)
		endif
		!ByteCounter #= !ByteCounter-1
		!CurrentOffset #= !CurrentOffset-1
	endif
	%DefineLabelAfterNoPassOpcode(!CurrentOffset)
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
endif
	!Pass = 1
	!CurrentOffset #= !ROMOffset
while !ByteCounter < !MaxBytes
	%PrintLabel(!CurrentOffset)
	%GetOpcode()
	%Op!Input1()
	!LoopCounter #= !LoopCounter+1
endwhile

print "Disassembly has ended at $",hex(!ROMOffset+!ByteCounter, 6)
