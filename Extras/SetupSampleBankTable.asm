@asar 1.81
; This will set up the sample pointer table and data when applied to the ROM. Just set the beginning and end offset of the pointer table.

hirom

!LoopCounter = 0
!SubFolder = ""
!Offset = $C219AE
!EndOffset = $C21A4E
!StartOfSampleData = $C21A52
!BaseAddressOfSampleData = $6F00
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

print ""
!LoopCounter #= 0
while !LoopCounter < !EndOffset-!Offset-$04
	!Input1 = read2(!Offset+!LoopCounter)
	!Input2 = read2(!Offset+!LoopCounter+$04)
	if !Input1 == $FFFF
	elseif !Input1 == $0000
	elseif !Input1 > !Input2
		warn "The pointers in this table aren't stored in order. You may want to sort the pointer from lowest to highest address, and then re-apply this script."
		!LoopCounter #= !EndOffset-!Offset
	else
		print "	dl $",hex(!StartOfSampleData+(!Input1-!BaseAddressOfSampleData), 6),",$",hex(!StartOfSampleData+(!Input2-!BaseAddressOfSampleData), 6),",BRRFile",hex(!LoopCounter/$04, 2),",BRRFile",hex(!LoopCounter/$04, 2),"End"
	endif
	!LoopCounter #= !LoopCounter+4
endif
	print "Note: You may need to set up the last entry in the asset extraction table manually."
