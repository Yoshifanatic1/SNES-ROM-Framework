asar 1.91

; Modify these as needed
lorom								; The memory map of the ROM. Change this if the ROM uses a different memory map, or else the output may be wrong.
!ROMOffset = $008000				; The ROM offset to begin disassembly from.
!Bank = 00							; Affects the bank byte for the label used in JSR/JMP instructions.
!DoTwoPassesFlag = 1				; If 1, the script will run twice, with the purpose of generating labels that appear before the branch that points to it. Turning this on may slow down disassembly speed, however.
!MaxBytes = 32768					; The maximum amount of bytes that will be read at a time. Setting this lower/higher will speed up/slow down disassembly.

; Don't touch these
!Input1 = $00
!Input2 = $00
!Output = ""
!ByteCounter = 0
!LoopCounter = 0
!Pass = 0
!CurrentOffset #= !ROMOffset

macro GetOpcode()
	!Input1 #= read1(!ROMOffset+!ByteCounter)
	;!Input1 #= !LoopCounter
	!ByteCounter #= !ByteCounter+1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readbyte(Input)
	!<Input> #= read1(!ROMOffset+!ByteCounter)
	;!<Input> = $01
	!ByteCounter #= !ByteCounter+1
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readword(Input)
	!<Input> #= read2(!ROMOffset+!ByteCounter)
	;!Input1 = $0123
	!ByteCounter #= !ByteCounter+2
	!CurrentOffset #= !ROMOffset+!ByteCounter
endmacro

macro readlong(Input)
	!<Input> #= read3(!ROMOffset+!ByteCounter)
	;!Input1 = $012345
	!ByteCounter #= !ByteCounter+3
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

if !Pass == 1
	print "	Opcode 0x00   "
endif
endmacro

macro Op1()

if !Pass == 1
	print "	Opcode 0x01   "
endif
endmacro

macro Op2()

if !Pass == 1
	print "	Opcode 0x02   "
endif
endmacro

macro Op3()

if !Pass == 1
	print "	Opcode 0x03   "
endif
endmacro

macro Op4()

if !Pass == 1
	print "	Opcode 0x04   "
endif
endmacro

macro Op5()

if !Pass == 1
	print "	Opcode 0x05   "
endif
endmacro

macro Op6()

if !Pass == 1
	print "	Opcode 0x06   "
endif
endmacro

macro Op7()

if !Pass == 1
	print "	Opcode 0x07   "
endif
endmacro

macro Op8()

if !Pass == 1
	print "	Opcode 0x08   "
endif
endmacro

macro Op9()

if !Pass == 1
	print "	Opcode 0x09   "
endif
endmacro

macro Op10()

if !Pass == 1
	print "	Opcode 0x0A   "
endif
endmacro

macro Op11()

if !Pass == 1
	print "	Opcode 0x0B   "
endif
endmacro

macro Op12()

if !Pass == 1
	print "	Opcode 0x0C   "
endif
endmacro

macro Op13()

if !Pass == 1
	print "	Opcode 0x0D   "
endif
endmacro

macro Op14()

if !Pass == 1
	print "	Opcode 0x0E   "
endif
endmacro

macro Op15()

if !Pass == 1
	print "	Opcode 0x0F   "
endif
endmacro

macro Op16()

if !Pass == 1
	print "	Opcode 0x10   "
endif
endmacro

macro Op17()

if !Pass == 1
	print "	Opcode 0x11   "
endif
endmacro

macro Op18()

if !Pass == 1
	print "	Opcode 0x12   "
endif
endmacro

macro Op19()

if !Pass == 1
	print "	Opcode 0x13   "
endif
endmacro

macro Op20()

if !Pass == 1
	print "	Opcode 0x14   "
endif
endmacro

macro Op21()

if !Pass == 1
	print "	Opcode 0x15   "
endif
endmacro

macro Op22()

if !Pass == 1
	print "	Opcode 0x16   "
endif
endmacro

macro Op23()

if !Pass == 1
	print "	Opcode 0x17   "
endif
endmacro

macro Op24()

if !Pass == 1
	print "	Opcode 0x18   "
endif
endmacro

macro Op25()

if !Pass == 1
	print "	Opcode 0x19   "
endif
endmacro

macro Op26()

if !Pass == 1
	print "	Opcode 0x1A   "
endif
endmacro

macro Op27()

if !Pass == 1
	print "	Opcode 0x1B   "
endif
endmacro

macro Op28()

if !Pass == 1
	print "	Opcode 0x1C   "
endif
endmacro

macro Op29()

if !Pass == 1
	print "	Opcode 0x1D   "
endif
endmacro

macro Op30()

if !Pass == 1
	print "	Opcode 0x1E   "
endif
endmacro

macro Op31()

if !Pass == 1
	print "	Opcode 0x1F   "
endif
endmacro

macro Op32()

if !Pass == 1
	print "	Opcode 0x20   "
endif
endmacro

macro Op33()

if !Pass == 1
	print "	Opcode 0x21   "
endif
endmacro

macro Op34()

if !Pass == 1
	print "	Opcode 0x22   "
endif
endmacro

macro Op35()

if !Pass == 1
	print "	Opcode 0x23   "
endif
endmacro

macro Op36()

if !Pass == 1
	print "	Opcode 0x24   "
endif
endmacro

macro Op37()

if !Pass == 1
	print "	Opcode 0x25   "
endif
endmacro

macro Op38()

if !Pass == 1
	print "	Opcode 0x26   "
endif
endmacro

macro Op39()

if !Pass == 1
	print "	Opcode 0x27   "
endif
endmacro

macro Op40()

if !Pass == 1
	print "	Opcode 0x28   "
endif
endmacro

macro Op41()

if !Pass == 1
	print "	Opcode 0x29   "
endif
endmacro

macro Op42()

if !Pass == 1
	print "	Opcode 0x2A   "
endif
endmacro

macro Op43()

if !Pass == 1
	print "	Opcode 0x2B   "
endif
endmacro

macro Op44()

if !Pass == 1
	print "	Opcode 0x2C   "
endif
endmacro

macro Op45()

if !Pass == 1
	print "	Opcode 0x2D   "
endif
endmacro

macro Op46()

if !Pass == 1
	print "	Opcode 0x2E   "
endif
endmacro

macro Op47()

if !Pass == 1
	print "	Opcode 0x2F   "
endif
endmacro

macro Op48()

if !Pass == 1
	print "	Opcode 0x30   "
endif
endmacro

macro Op49()

if !Pass == 1
	print "	Opcode 0x31   "
endif
endmacro

macro Op50()

if !Pass == 1
	print "	Opcode 0x32   "
endif
endmacro

macro Op51()

if !Pass == 1
	print "	Opcode 0x33   "
endif
endmacro

macro Op52()

if !Pass == 1
	print "	Opcode 0x34   "
endif
endmacro

macro Op53()

if !Pass == 1
	print "	Opcode 0x35   "
endif
endmacro

macro Op54()

if !Pass == 1
	print "	Opcode 0x36   "
endif
endmacro

macro Op55()

if !Pass == 1
	print "	Opcode 0x37   "
endif
endmacro

macro Op56()

if !Pass == 1
	print "	Opcode 0x38   "
endif
endmacro

macro Op57()

if !Pass == 1
	print "	Opcode 0x39   "
endif
endmacro

macro Op58()

if !Pass == 1
	print "	Opcode 0x3A   "
endif
endmacro

macro Op59()

if !Pass == 1
	print "	Opcode 0x3B   "
endif
endmacro

macro Op60()

if !Pass == 1
	print "	Opcode 0x3C   "
endif
endmacro

macro Op61()

if !Pass == 1
	print "	Opcode 0x3D   "
endif
endmacro

macro Op62()

if !Pass == 1
	print "	Opcode 0x3E   "
endif
endmacro

macro Op63()

if !Pass == 1
	print "	Opcode 0x3F   "
endif
endmacro

macro Op64()

if !Pass == 1
	print "	Opcode 0x40   "
endif
endmacro

macro Op65()

if !Pass == 1
	print "	Opcode 0x41   "
endif
endmacro

macro Op66()

if !Pass == 1
	print "	Opcode 0x42   "
endif
endmacro

macro Op67()

if !Pass == 1
	print "	Opcode 0x43   "
endif
endmacro

macro Op68()

if !Pass == 1
	print "	Opcode 0x44   "
endif
endmacro

macro Op69()

if !Pass == 1
	print "	Opcode 0x45   "
endif
endmacro

macro Op70()

if !Pass == 1
	print "	Opcode 0x46   "
endif
endmacro

macro Op71()

if !Pass == 1
	print "	Opcode 0x47   "
endif
endmacro

macro Op72()

if !Pass == 1
	print "	Opcode 0x48   "
endif
endmacro

macro Op73()

if !Pass == 1
	print "	Opcode 0x49   "
endif
endmacro

macro Op74()

if !Pass == 1
	print "	Opcode 0x4A   "
endif
endmacro

macro Op75()

if !Pass == 1
	print "	Opcode 0x4B   "
endif
endmacro

macro Op76()

if !Pass == 1
	print "	Opcode 0x4C   "
endif
endmacro

macro Op77()

if !Pass == 1
	print "	Opcode 0x4D   "
endif
endmacro

macro Op78()

if !Pass == 1
	print "	Opcode 0x4E   "
endif
endmacro

macro Op79()

if !Pass == 1
	print "	Opcode 0x4F   "
endif
endmacro

macro Op80()

if !Pass == 1
	print "	Opcode 0x50   "
endif
endmacro

macro Op81()

if !Pass == 1
	print "	Opcode 0x51   "
endif
endmacro

macro Op82()

if !Pass == 1
	print "	Opcode 0x52   "
endif
endmacro

macro Op83()

if !Pass == 1
	print "	Opcode 0x53   "
endif
endmacro

macro Op84()

if !Pass == 1
	print "	Opcode 0x54   "
endif
endmacro

macro Op85()

if !Pass == 1
	print "	Opcode 0x55   "
endif
endmacro

macro Op86()

if !Pass == 1
	print "	Opcode 0x56   "
endif
endmacro

macro Op87()

if !Pass == 1
	print "	Opcode 0x57   "
endif
endmacro

macro Op88()

if !Pass == 1
	print "	Opcode 0x58   "
endif
endmacro

macro Op89()

if !Pass == 1
	print "	Opcode 0x59   "
endif
endmacro

macro Op90()

if !Pass == 1
	print "	Opcode 0x5A   "
endif
endmacro

macro Op91()

if !Pass == 1
	print "	Opcode 0x5B   "
endif
endmacro

macro Op92()

if !Pass == 1
	print "	Opcode 0x5C   "
endif
endmacro

macro Op93()

if !Pass == 1
	print "	Opcode 0x5D   "
endif
endmacro

macro Op94()

if !Pass == 1
	print "	Opcode 0x5E   "
endif
endmacro

macro Op95()

if !Pass == 1
	print "	Opcode 0x5F   "
endif
endmacro

macro Op96()

if !Pass == 1
	print "	Opcode 0x60   "
endif
endmacro

macro Op97()

if !Pass == 1
	print "	Opcode 0x61   "
endif
endmacro

macro Op98()

if !Pass == 1
	print "	Opcode 0x62   "
endif
endmacro

macro Op99()

if !Pass == 1
	print "	Opcode 0x63   "
endif
endmacro

macro Op100()

if !Pass == 1
	print "	Opcode 0x64   "
endif
endmacro

macro Op101()

if !Pass == 1
	print "	Opcode 0x65   "
endif
endmacro

macro Op102()

if !Pass == 1
	print "	Opcode 0x66   "
endif
endmacro

macro Op103()

if !Pass == 1
	print "	Opcode 0x67   "
endif
endmacro

macro Op104()

if !Pass == 1
	print "	Opcode 0x68   "
endif
endmacro

macro Op105()

if !Pass == 1
	print "	Opcode 0x69   "
endif
endmacro

macro Op106()

if !Pass == 1
	print "	Opcode 0x6A   "
endif
endmacro

macro Op107()

if !Pass == 1
	print "	Opcode 0x6B   "
endif
endmacro

macro Op108()

if !Pass == 1
	print "	Opcode 0x6C   "
endif
endmacro

macro Op109()

if !Pass == 1
	print "	Opcode 0x6D   "
endif
endmacro

macro Op110()

if !Pass == 1
	print "	Opcode 0x6E   "
endif
endmacro

macro Op111()

if !Pass == 1
	print "	Opcode 0x6F   "
endif
endmacro

macro Op112()

if !Pass == 1
	print "	Opcode 0x70   "
endif
endmacro

macro Op113()

if !Pass == 1
	print "	Opcode 0x71   "
endif
endmacro

macro Op114()

if !Pass == 1
	print "	Opcode 0x72   "
endif
endmacro

macro Op115()

if !Pass == 1
	print "	Opcode 0x73   "
endif
endmacro

macro Op116()

if !Pass == 1
	print "	Opcode 0x74   "
endif
endmacro

macro Op117()

if !Pass == 1
	print "	Opcode 0x75   "
endif
endmacro

macro Op118()

if !Pass == 1
	print "	Opcode 0x76   "
endif
endmacro

macro Op119()

if !Pass == 1
	print "	Opcode 0x77   "
endif
endmacro

macro Op120()

if !Pass == 1
	print "	Opcode 0x78   "
endif
endmacro

macro Op121()

if !Pass == 1
	print "	Opcode 0x79   "
endif
endmacro

macro Op122()

if !Pass == 1
	print "	Opcode 0x7A   "
endif
endmacro

macro Op123()

if !Pass == 1
	print "	Opcode 0x7B   "
endif
endmacro

macro Op124()

if !Pass == 1
	print "	Opcode 0x7C   "
endif
endmacro

macro Op125()

if !Pass == 1
	print "	Opcode 0x7D   "
endif
endmacro

macro Op126()

if !Pass == 1
	print "	Opcode 0x7E   "
endif
endmacro

macro Op127()

if !Pass == 1
	print "	Opcode 0x7F   "
endif
endmacro

macro Op128()

if !Pass == 1
	print "	Opcode 0x80   "
endif
endmacro

macro Op129()

if !Pass == 1
	print "	Opcode 0x81   "
endif
endmacro

macro Op130()

if !Pass == 1
	print "	Opcode 0x82   "
endif
endmacro

macro Op131()

if !Pass == 1
	print "	Opcode 0x83   "
endif
endmacro

macro Op132()

if !Pass == 1
	print "	Opcode 0x84   "
endif
endmacro

macro Op133()

if !Pass == 1
	print "	Opcode 0x85   "
endif
endmacro

macro Op134()

if !Pass == 1
	print "	Opcode 0x86   "
endif
endmacro

macro Op135()

if !Pass == 1
	print "	Opcode 0x87   "
endif
endmacro

macro Op136()

if !Pass == 1
	print "	Opcode 0x88   "
endif
endmacro

macro Op137()

if !Pass == 1
	print "	Opcode 0x89   "
endif
endmacro

macro Op138()

if !Pass == 1
	print "	Opcode 0x8A   "
endif
endmacro

macro Op139()

if !Pass == 1
	print "	Opcode 0x8B   "
endif
endmacro

macro Op140()

if !Pass == 1
	print "	Opcode 0x8C   "
endif
endmacro

macro Op141()

if !Pass == 1
	print "	Opcode 0x8D   "
endif
endmacro

macro Op142()

if !Pass == 1
	print "	Opcode 0x8E   "
endif
endmacro

macro Op143()

if !Pass == 1
	print "	Opcode 0x8F   "
endif
endmacro

macro Op144()

if !Pass == 1
	print "	Opcode 0x90   "
endif
endmacro

macro Op145()

if !Pass == 1
	print "	Opcode 0x91   "
endif
endmacro

macro Op146()

if !Pass == 1
	print "	Opcode 0x92   "
endif
endmacro

macro Op147()

if !Pass == 1
	print "	Opcode 0x93   "
endif
endmacro

macro Op148()

if !Pass == 1
	print "	Opcode 0x94   "
endif
endmacro

macro Op149()

if !Pass == 1
	print "	Opcode 0x95   "
endif
endmacro

macro Op150()

if !Pass == 1
	print "	Opcode 0x96   "
endif
endmacro

macro Op151()

if !Pass == 1
	print "	Opcode 0x97   "
endif
endmacro

macro Op152()

if !Pass == 1
	print "	Opcode 0x98   "
endif
endmacro

macro Op153()

if !Pass == 1
	print "	Opcode 0x99   "
endif
endmacro

macro Op154()

if !Pass == 1
	print "	Opcode 0x9A   "
endif
endmacro

macro Op155()

if !Pass == 1
	print "	Opcode 0x9B   "
endif
endmacro

macro Op156()

if !Pass == 1
	print "	Opcode 0x9C   "
endif
endmacro

macro Op157()

if !Pass == 1
	print "	Opcode 0x9D   "
endif
endmacro

macro Op158()

if !Pass == 1
	print "	Opcode 0x9E   "
endif
endmacro

macro Op159()

if !Pass == 1
	print "	Opcode 0x9F   "
endif
endmacro

macro Op160()

if !Pass == 1
	print "	Opcode 0xA0   "
endif
endmacro

macro Op161()

if !Pass == 1
	print "	Opcode 0xA1   "
endif
endmacro

macro Op162()

if !Pass == 1
	print "	Opcode 0xA2   "
endif
endmacro

macro Op163()

if !Pass == 1
	print "	Opcode 0xA3   "
endif
endmacro

macro Op164()

if !Pass == 1
	print "	Opcode 0xA4   "
endif
endmacro

macro Op165()

if !Pass == 1
	print "	Opcode 0xA5   "
endif
endmacro

macro Op166()

if !Pass == 1
	print "	Opcode 0xA6   "
endif
endmacro

macro Op167()

if !Pass == 1
	print "	Opcode 0xA7   "
endif
endmacro

macro Op168()

if !Pass == 1
	print "	Opcode 0xA8   "
endif
endmacro

macro Op169()

if !Pass == 1
	print "	Opcode 0xA9   "
endif
endmacro

macro Op170()

if !Pass == 1
	print "	Opcode 0xAA   "
endif
endmacro

macro Op171()

if !Pass == 1
	print "	Opcode 0xAB   "
endif
endmacro

macro Op172()

if !Pass == 1
	print "	Opcode 0xAC   "
endif
endmacro

macro Op173()

if !Pass == 1
	print "	Opcode 0xAD   "
endif
endmacro

macro Op174()

if !Pass == 1
	print "	Opcode 0xAE   "
endif
endmacro

macro Op175()

if !Pass == 1
	print "	Opcode 0xAF   "
endif
endmacro

macro Op176()

if !Pass == 1
	print "	Opcode 0xB0   "
endif
endmacro

macro Op177()

if !Pass == 1
	print "	Opcode 0xB1   "
endif
endmacro

macro Op178()

if !Pass == 1
	print "	Opcode 0xB2   "
endif
endmacro

macro Op179()

if !Pass == 1
	print "	Opcode 0xB3   "
endif
endmacro

macro Op180()

if !Pass == 1
	print "	Opcode 0xB4   "
endif
endmacro

macro Op181()

if !Pass == 1
	print "	Opcode 0xB5   "
endif
endmacro

macro Op182()

if !Pass == 1
	print "	Opcode 0xB6   "
endif
endmacro

macro Op183()

if !Pass == 1
	print "	Opcode 0xB7   "
endif
endmacro

macro Op184()

if !Pass == 1
	print "	Opcode 0xB8   "
endif
endmacro

macro Op185()

if !Pass == 1
	print "	Opcode 0xB9   "
endif
endmacro

macro Op186()

if !Pass == 1
	print "	Opcode 0xBA   "
endif
endmacro

macro Op187()

if !Pass == 1
	print "	Opcode 0xBB   "
endif
endmacro

macro Op188()

if !Pass == 1
	print "	Opcode 0xBC   "
endif
endmacro

macro Op189()

if !Pass == 1
	print "	Opcode 0xBD   "
endif
endmacro

macro Op190()

if !Pass == 1
	print "	Opcode 0xBE   "
endif
endmacro

macro Op191()

if !Pass == 1
	print "	Opcode 0xBF   "
endif
endmacro

macro Op192()

if !Pass == 1
	print "	Opcode 0xC0   "
endif
endmacro

macro Op193()

if !Pass == 1
	print "	Opcode 0xC1   "
endif
endmacro

macro Op194()

if !Pass == 1
	print "	Opcode 0xC2   "
endif
endmacro

macro Op195()

if !Pass == 1
	print "	Opcode 0xC3   "
endif
endmacro

macro Op196()

if !Pass == 1
	print "	Opcode 0xC4   "
endif
endmacro

macro Op197()

if !Pass == 1
	print "	Opcode 0xC5   "
endif
endmacro

macro Op198()

if !Pass == 1
	print "	Opcode 0xC6   "
endif
endmacro

macro Op199()

if !Pass == 1
	print "	Opcode 0xC7   "
endif
endmacro

macro Op200()

if !Pass == 1
	print "	Opcode 0xC8   "
endif
endmacro

macro Op201()

if !Pass == 1
	print "	Opcode 0xC9   "
endif
endmacro

macro Op202()

if !Pass == 1
	print "	Opcode 0xCA   "
endif
endmacro

macro Op203()

if !Pass == 1
	print "	Opcode 0xCB   "
endif
endmacro

macro Op204()

if !Pass == 1
	print "	Opcode 0xCC   "
endif
endmacro

macro Op205()

if !Pass == 1
	print "	Opcode 0xCD   "
endif
endmacro

macro Op206()

if !Pass == 1
	print "	Opcode 0xCE   "
endif
endmacro

macro Op207()

if !Pass == 1
	print "	Opcode 0xCF   "
endif
endmacro

macro Op208()

if !Pass == 1
	print "	Opcode 0xD0   "
endif
endmacro

macro Op209()

if !Pass == 1
	print "	Opcode 0xD1   "
endif
endmacro

macro Op210()

if !Pass == 1
	print "	Opcode 0xD2   "
endif
endmacro

macro Op211()

if !Pass == 1
	print "	Opcode 0xD3   "
endif
endmacro

macro Op212()

if !Pass == 1
	print "	Opcode 0xD4   "
endif
endmacro

macro Op213()

if !Pass == 1
	print "	Opcode 0xD5   "
endif
endmacro

macro Op214()

if !Pass == 1
	print "	Opcode 0xD6   "
endif
endmacro

macro Op215()

if !Pass == 1
	print "	Opcode 0xD7   "
endif
endmacro

macro Op216()

if !Pass == 1
	print "	Opcode 0xD8   "
endif
endmacro

macro Op217()

if !Pass == 1
	print "	Opcode 0xD9   "
endif
endmacro

macro Op218()

if !Pass == 1
	print "	Opcode 0xDA   "
endif
endmacro

macro Op219()

if !Pass == 1
	print "	Opcode 0xDB   "
endif
endmacro

macro Op220()

if !Pass == 1
	print "	Opcode 0xDC   "
endif
endmacro

macro Op221()

if !Pass == 1
	print "	Opcode 0xDD   "
endif
endmacro

macro Op222()

if !Pass == 1
	print "	Opcode 0xDE   "
endif
endmacro

macro Op223()

if !Pass == 1
	print "	Opcode 0xDF   "
endif
endmacro

macro Op224()

if !Pass == 1
	print "	Opcode 0xE0   "
endif
endmacro

macro Op225()

if !Pass == 1
	print "	Opcode 0xE1   "
endif
endmacro

macro Op226()

if !Pass == 1
	print "	Opcode 0xE2   "
endif
endmacro

macro Op227()

if !Pass == 1
	print "	Opcode 0xE3   "
endif
endmacro

macro Op228()

if !Pass == 1
	print "	Opcode 0xE4   "
endif
endmacro

macro Op229()

if !Pass == 1
	print "	Opcode 0xE5   "
endif
endmacro

macro Op230()

if !Pass == 1
	print "	Opcode 0xE6   "
endif
endmacro

macro Op231()

if !Pass == 1
	print "	Opcode 0xE7   "
endif
endmacro

macro Op232()

if !Pass == 1
	print "	Opcode 0xE8   "
endif
endmacro

macro Op233()

if !Pass == 1
	print "	Opcode 0xE9   "
endif
endmacro

macro Op234()

if !Pass == 1
	print "	Opcode 0xEA   "
endif
endmacro

macro Op235()

if !Pass == 1
	print "	Opcode 0xEB   "
endif
endmacro

macro Op236()

if !Pass == 1
	print "	Opcode 0xEC   "
endif
endmacro

macro Op237()

if !Pass == 1
	print "	Opcode 0xED   "
endif
endmacro

macro Op238()

if !Pass == 1
	print "	Opcode 0xEE   "
endif
endmacro

macro Op239()

if !Pass == 1
	print "	Opcode 0xEF   "
endif
endmacro

macro Op240()

if !Pass == 1
	print "	Opcode 0xF0   "
endif
endmacro

macro Op241()

if !Pass == 1
	print "	Opcode 0xF1   "
endif
endmacro

macro Op242()

if !Pass == 1
	print "	Opcode 0xF2   "
endif
endmacro

macro Op243()

if !Pass == 1
	print "	Opcode 0xF3   "
endif
endmacro

macro Op244()

if !Pass == 1
	print "	Opcode 0xF4   "
endif
endmacro

macro Op245()

if !Pass == 1
	print "	Opcode 0xF5   "
endif
endmacro

macro Op246()

if !Pass == 1
	print "	Opcode 0xF6   "
endif
endmacro

macro Op247()

if !Pass == 1
	print "	Opcode 0xF7   "
endif
endmacro

macro Op248()

if !Pass == 1
	print "	Opcode 0xF8   "
endif
endmacro

macro Op249()

if !Pass == 1
	print "	Opcode 0xF9   "
endif
endmacro

macro Op250()

if !Pass == 1
	print "	Opcode 0xFA   "
endif
endmacro

macro Op251()

if !Pass == 1
	print "	Opcode 0xFB   "
endif
endmacro

macro Op252()

if !Pass == 1
	print "	Opcode 0xFC   "
endif
endmacro

macro Op253()

if !Pass == 1
	print "	Opcode 0xFD   "
endif
endmacro

macro Op254()

if !Pass == 1
	print "	Opcode 0xFE   "
endif
endmacro

macro Op255()

if !Pass == 1
	print "	Opcode 0xFF   "
endif
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

!Input1 #= !ROMOffset+!ByteCounter
print "Disassembly has ended at $",hex(!ROMOffset+!ByteCounter, 6)
