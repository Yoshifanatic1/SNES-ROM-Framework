@echo off

set ROMName=MP.sfc
set Input1=""
set Input2=""
set Input3=""
set Input4=""
set Input5=""
set Input6=""

setlocal EnableDelayedExpansion

:Start

echo Type the SNES address of the start of the sample bank pointer table.
set /p Input1=""

echo Type the SNES address of the end of the sample bank pointer table.

set /p Input2=""

echo Type the SNES address of the start of the sample bank data.

set /p Input3=""

echo Type the memory map mode the ROM uses (ie. lorom, hirom, sa1rom, etc.)

set /p Input4=""

echo Type the ARAM address the sample bank is uploaded to.

set /p Input5=""

echo Type the size of the sample bank

set /p Input6=""

set BasePtrAddr=%Input1%
set EndPtrAddr=%Input2%
set BaseAddr=%Input3%
set MemMap=%Input4%
set ARAMAddr=%Input5%
set Size=%Input6%

echo Extracting Samples...
set /a LoopCounter=0
set /a MaxLoopCount=(0x%EndPtrAddr%-0x%BasePtrAddr%)/4

:Loop

if exist Temp.asm del Temp.asm

echo:%MemMap% >> Temp.asm
echo:org $008000>> Temp.asm
echo:^^!LoopCounter = %LoopCounter% >> Temp.asm
echo:^^!ROMName = %ROMName% >> Temp.asm
echo:check bankcross off >> Temp.asm
echo:if stringsequalnocase("%MemMap%", "lorom") >> Temp.asm
echo:^^!BankOffset = $8000 >> Temp.asm
echo:else >> Temp.asm
echo:^^!BankOffset = $0000 >> Temp.asm
echo:endif >> Temp.asm
echo:^^!offset1 #= readfile2("^!ROMName", snestopc($%BasePtrAddr%)+(^^!LoopCounter*$04))-$%ARAMAddr% >> Temp.asm
echo:if (^^!LoopCounter*$04)+$%BasePtrAddr%+$04 == $%EndPtrAddr% >> Temp.asm
echo:^^!offset2 #= $%Size% >> Temp.asm
echo:else >> Temp.asm
echo:^^!offset2 #= readfile2("^!ROMName", snestopc($%BasePtrAddr%+$04)+(^^!LoopCounter*$04))-$%ARAMAddr% >> Temp.asm
echo:if ^^!offset2+$%ARAMAddr% == $FFFF >> Temp.asm
echo:^^!offset2 #= $%Size% >> Temp.asm
echo:elseif ^^!offset2+$%ARAMAddr% == $0000 >> Temp.asm
echo:^^!offset2 #= $%Size% >> Temp.asm
echo:endif >> Temp.asm
echo:endif >> Temp.asm
echo:^^!offset3 #= snestopc((^^!offset1+$%BaseAddr%)^|^^!BankOffset) >> Temp.asm
echo:^^!offset4 #= snestopc((^^!offset2+$%BaseAddr%)^|^^!BankOffset) >> Temp.asm
::echo:print hex(^^!offset1) >> Temp.asm
::echo:print hex(^^!offset2) >> Temp.asm
::echo:print hex(^^!offset3) >> Temp.asm
::echo:print hex(^^!offset4) >> Temp.asm
::echo:print hex((^^!offset1+$%BaseAddr%)^|^^!BankOffset) >> Temp.asm
::echo:print hex((^^!offset2+$%BaseAddr%)^|^^!BankOffset) >> Temp.asm
echo:incbin ^^!ROMName:(^^!offset3)-(^^!offset4) >> Temp.asm
echo:print "Extracted the file at offset $",hex((^^!offset1+$%BaseAddr%)^|^^!BankOffset) >> Temp.asm

asar --fix-checksum=off --no-title-check "Temp.asm" %LoopCounter%.brr

set /a LoopCounter+=1

if %LoopCounter% lss %MaxLoopCount% goto :Loop
if exist Temp.asm del Temp.asm
goto :Start
