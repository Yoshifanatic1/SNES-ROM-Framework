asar 1.91
; This will set up the sample pointer table and data when applied to the ROM. Just set the beginning and end offset of the pointer table.

lorom

!LoopCounter = 0
!SamplePtrCount = 0
!SampleCount = 0
!SubFolder = ""
!Offset = $84982A
!EndOffset = $849886
!StartOfSampleData = $849910
!EndOfSampleData = $84E80B
!BaseAddressOfSampleData = $50E6
!InitialSampleID = 0

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
	!SamplePtrCount #= !SamplePtrCount+$01
endwhile

if !SamplePtrCount != 0
	!SamplePtrCount #= !SamplePtrCount-$01
endif

!SampleCount #= !SamplePtrCount

print ""
!Input1 = $FFFF
!LoopCounter #= 0
!SampleID #= !InitialSampleID
while !LoopCounter < !EndOffset-!Offset
	!PreviousInput #= !Input1
	!Input1 #= read2(!Offset+!LoopCounter)
	if !Input1 == !PreviousInput
		!SampleCount #= !SampleCount-$01
	elseif !Input1 == $FFFF
		!SampleCount #= !SampleCount-$01
	elseif !Input1 == $0000
		!SampleCount #= !SampleCount-$01
	else
		print "DATA_",hex(!Input1, 4),":"
		print "	incbin 'Samples/!SubFolder",hex(!SampleID, 2),".brr'"
		print ""
		!SampleID #= !SampleID+$01
	endif
	!LoopCounter #= !LoopCounter+4
endwhile

print ""
!LoopCounter #= 0
!SampleID #= !InitialSampleID
while !LoopCounter < !EndOffset-!Offset
	if !LoopCounter/$04 == !SamplePtrCount
		!Input1 #= read2(!Offset+!LoopCounter)
		!Input2 #= $FFFF
	else
		!Input1 #= read2(!Offset+!LoopCounter)
		!Input2 #= read2(!Offset+!LoopCounter+$04)
	endif
	if !Input1 == $FFFF
	elseif !Input1 == $0000
	elseif !Input1 == !Input2
	elseif !Input1 > !Input2
		warn "The pointers in this table aren't stored in order. You may want to sort the pointers from lowest to highest address, and then re-apply this script."
		!LoopCounter #= !EndOffset-!Offset
	elseif !Input2 == $0000
		warn "The pointers in this table aren't stored in order. You may want to sort the pointers from lowest to highest address, and then re-apply this script."
		!LoopCounter #= !EndOffset-!Offset
	elseif !Input2 == $FFFF
		warn "The pointers in this table aren't stored in order. You may want to sort the pointers from lowest to highest address, and then re-apply this script."
		!LoopCounter #= !EndOffset-!Offset
	else
		if !LoopCounter/$04 == !SamplePtrCount
			print "	dl $",hex(!StartOfSampleData+(!Input1-!BaseAddressOfSampleData), 6),",$",hex(!EndOfSampleData, 6),",BRRFile",hex(!SampleID, 2),",BRRFile",hex(!SampleID, 2),"End"
		else
			print "	dl $",hex(!StartOfSampleData+(!Input1-!BaseAddressOfSampleData), 6),",$",hex(!StartOfSampleData+(!Input2-!BaseAddressOfSampleData), 6),",BRRFile",hex(!SampleID, 2),",BRRFile",hex(!SampleID, 2),"End"
		endif
		!SampleID #= !SampleID+$01
	endif
	!LoopCounter #= !LoopCounter+4
endwhile

print ""
!LoopCounter #= 0
!SampleID #= !InitialSampleID
while !LoopCounter <= !SampleCount
	print "BRRFile",hex(!SampleID, 2),":"
	print "	db '",hex(!SampleID, 2),".brr'"
	print "BRRFile",hex(!SampleID, 2),"End:"
	!SampleID #= !SampleID+1
	!LoopCounter #= !LoopCounter+1
endwhile
