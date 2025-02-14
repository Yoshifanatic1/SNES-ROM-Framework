asar 1.91
; This will create a pointer table that uses relative offsets when applied to the ROM. Just set the beginning and end offset of the pointer table.

hirom
!LoopCounter = 0
!Offset = $FD934D
!EndOffset = $FD94ED
while !LoopCounter < !EndOffset-!Offset
	!Input1 = read2(!Offset+!LoopCounter)
	print "	dw DATA_",hex(!Input1+!Offset, 6),"-DATA_",hex(!Offset, 6)
	!LoopCounter #= !LoopCounter+2
endwhile

print ""
!LoopCounter #= 0
while !LoopCounter < !EndOffset-!Offset
	!Input1 = read2(!Offset+!LoopCounter)
	print "DATA_",hex(!Input1+!Offset, 6),":"
	!LoopCounter #= !LoopCounter+2
endwhile