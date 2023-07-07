@echo off
setlocal EnableDelayedExpansion

set PATH="Global"

asar.exe --fix-checksum=off --no-title-check SNESASMDis.asm ROMName.sfc > Output.asm

pause
exit