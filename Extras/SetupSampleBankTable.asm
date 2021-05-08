@asar 1.81
; This will set up the sample pointer table and data when applied to the ROM. Just set the beginning and end offset of the pointer table.

!LoopCounter = 0
!SubFolder = "FlySwatting/"
!Offset = $1E9FAC
!EndOffset = $1EA02C
while !LoopCounter < !EndOffset-!Offset
	!Input1 = read2(!Offset+!LoopCounter)
	!Input2 = read2(!Offset+!LoopCounter+$02)-!Input1
	if !Input1 == $FFFF
		print "	dw $FFFF	:	dw $FFFF"
	elseif !Input1 == $0000
		print "	dw $0000	:	dw $0000"
	else
		print "	dw DATA_",hex(!Input1, 4),"	:	dw DATA_",hex(!Input1, 4),"+$",hex(!Input2, 4)
	endif
	!LoopCounter #= !LoopCounter+4
endif

print ""
!LoopCounter #= 0
while !LoopCounter < !EndOffset-!Offset
	!Input1 = read2(!Offset+!LoopCounter)
	if !Input1 == $FFFF
	elseif !Input1 == $0000
	else
		print "DATA_",hex(!Input1, 4),":"
		print "	incbin 'Samples/!SubFolder",hex(!LoopCounter/$04, 2),".brr'"
		print ""
	endif
	!LoopCounter #= !LoopCounter+4
endif