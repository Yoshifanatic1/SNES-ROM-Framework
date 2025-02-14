; This will dump the data for an asar patch that will be applied to any ROM. Said patch will set up the asset extraction script data entries when applied to the ROM.
; The reason I'm generating a patch and not the tables directly is because of asar limitations. I don't think it's possible for asar to resolve commands through a define while in a print statement.
; Also, it may take a second before asar starts displaying anything on the command line. In addition, you'll need to replace the ' with " in the output patch, and the % with " in the second output patch, otherwise asar won't assemble the patch.

!PtrStartOffset = $EE0D86
!PtrEndOffset =	$EE1014

hirom

!LoopCounter1 = 0
!LoopCounter2 = 0
print "hirom"

while !PtrStartOffset+!LoopCounter1 < !PtrEndOffset
	!Input1 #= read3(!PtrStartOffset+!LoopCounter1)
	!Input2 #= read3(!PtrStartOffset+!LoopCounter1+$03)
	print "print '	dl $',hex(!Input1+$04),',$',hex(!Input2),',BRRFile',hex(!LoopCounter2, 2),',BRRFile',hex(!LoopCounter2, 2),'End'"
	!LoopCounter1 #= !LoopCounter1+3
	!LoopCounter2 #= !LoopCounter2+1
endwhile

!LoopCounter1 = 0
!LoopCounter2 = 0

while !PtrStartOffset+!LoopCounter1 < !PtrEndOffset
	print "print 'BRRFile',hex(!LoopCounter2, 2),':'"
	print "print '	db %',hex(!LoopCounter2, 2),'.brr%'"
	print "print 'BRRFile',hex(!LoopCounter2, 2),'End:'"
	!LoopCounter1 #= !LoopCounter1+3
	!LoopCounter2 #= !LoopCounter2+1
endwhile
