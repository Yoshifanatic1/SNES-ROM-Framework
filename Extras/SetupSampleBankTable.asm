; This will set up the sample pointer table and data when applied to the ROM. Just set the beginning and end offset of the pointer table.

!LoopCounter = 0
!SubFolder = "FlySwatting/"
!Offset = $1E9FAC
!EndOffset = $1EA02C
while !LoopCounter < !EndOffset-!Offset
	!Input1 = read2(!Offset+!LoopCounter)
	!Input2 = read2(!Offset+!LoopCounter+$02)-!Input1
	if !Input1 < 16
		!TEMP1 = "000"
	elseif !Input1 < 256
		!TEMP1 = "00"
	elseif !Input1 < 4096
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
	if !Input2 < 16
		!TEMP2 = "000"
	elseif !Input2 < 256
		!TEMP2 = "00"
	elseif !Input2 < 4096
		!TEMP2 = "0"
	else
		!TEMP2 = ""
	endif
	if !Input1 == $FFFF
		print "	dw $FFFF	:	dw $FFFF"
	elseif !Input1 == $0000
		print "	dw $0000	:	dw $0000"
	else
		print "	dw DATA_!TEMP1",hex(!Input1),"	:	dw DATA_!TEMP1",hex(!Input1),"+$!TEMP2",hex(!Input2)
	endif
	!LoopCounter #= !LoopCounter+4
endif

print ""
!LoopCounter #= 0
while !LoopCounter < !EndOffset-!Offset
	!Input1 = read2(!Offset+!LoopCounter)
	if !Input1 < 16
		!TEMP1 = "000"
	elseif !Input1 < 256
		!TEMP1 = "00"
	elseif !Input1 < 4096
		!TEMP1 = "0"
	else
		!TEMP1 = ""
	endif
	if !Input1 == $FFFF
	elseif !Input1 == $0000
	else
		print "DATA_!TEMP1",hex(!Input1),":"
		print "	incbin 'Samples/!SubFolder",dec(!LoopCounter/$04),".brr'"
		print ""
	endif
	!LoopCounter #= !LoopCounter+4
endif