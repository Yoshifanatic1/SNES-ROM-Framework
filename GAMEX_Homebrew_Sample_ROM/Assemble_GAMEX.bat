@echo off

set PATH="../Global"
set Input1=
set asarVer=asar
set GAMDID="GAMEX"
set FolderName="GAMEX_Homebrew_Sample_ROM"
set ROMVer=
set ROMExt=.sfc
set HackCheck=""
set HackName=""

setlocal EnableDelayedExpansion


if exist ..\%FolderName%\AsarScripts\AssetsExtracted.txt goto :AssetsGot
echo.----IMPORTANT----
echo This disassembly will not compile until you extract the assets from a clean, headerless ROM of the following game(s):
echo - Game Name (Version)
echo Use ExtractAssets.bat in the AsarScripts folder to create the asset files.
echo Do this for each ROM version you plan on working with, as assets can differ between versions.
echo.
echo And no, don't ask me to send you a ROM. You'll have to get it yourself from somewhere^^!
echo.

pause
exit

:AssetsGot
echo Enter the ROM version you want to assemble.
echo Valid options: "GAMEX_V1" "GAMEX_V2"
echo For custom ROM versions, use "HACK_<HackName>, where <HackName> is the rest of the custom ROM Map file's name before the extension."

:Input
set /p Input1="%Input1%"
set HackCheck=%Input1:~0,5%
if "%Input1%" equ "" goto :Exit
if "%HackCheck%" equ "HACK_" goto :Hack
if "%Input1%" equ "GAMEX_V1" goto :V1
if "%Input1%" equ "GAMEX_V2" goto :V2

echo. "%Input1%" is not a valid ROM version.
set Input1=
goto :Input

:Hack
set ROMNAME=%Input1:~5,100%
set ROMVer=(Hack)
goto :Assemble

:V1
set ROMVer=(V1)
set ROMNAME=GameX
goto :Assemble

:V2
set ROMVer=(V2)
set ROMNAME=GameX

:Assemble

set output="%ROMNAME% %ROMVer%%ROMExt%"

if exist ..\%FolderName%\ROMMap\ROM_Map_%Input1%.asm goto :ValidROMMap

echo.
echo.That ROM version lacks a ROM Map file. Either because it's unsupported by the disassembly, or you need to make one yourself.
echo.
set Input1=
goto :AssetsGot

:ValidROMMap
set output="%ROMNAME% %ROMVer%%ROMExt%"

if exist %output% del %output%

echo.
echo.---------------------------------------------------------------------------
echo.
echo Assembling "%ROMNAME% %ROMVer%%ROMExt%" ... this may take a minute.
echo.

%asarVer% --fix-checksum=on --define MainFolder="%FolderName%" --define GameID="%GAMDID%" --define ROMID="%Input1%" --define FileType=0 ..\Global\AssembleFile.asm %output%

echo Assembling %ROMNAME% SPC700 Blocks...
%asarVer%  --error-limit=200 --no-title-check --define MainFolder="%FolderName%" --define GameID="%GAMDID%" --define ROMID="%Input1%" --define FileType=4 ..\Global\AssembleFile.asm SPC700\SPC700DataBlocks_%GAMDID%.bin

echo Assembling ROM...
%asarVer%  --error-limit=200 --define MainFolder="%FolderName%" --define GameID="%GAMDID%" --define ROMID="%Input1%" --define FileType=1 ..\Global\AssembleFile.asm %output%

if exist ..\%FolderName%\Temp.txt del ..\%FolderName%\Temp.txt
%asarVer% --define MainFolder="%FolderName%" --define GameID="%GAMDID%" --define ROMID="%Input1%" --define FileType=6 ..\Global\AssembleFile.asm Temp.txt
for /f "delims=" %%x in (Temp.txt) do set Firmware=%%x
if "%Firmware%" equ "NULL" goto :NoFirmware
if exist %Firmware% goto :NoFirmware
if exist ..\Firmware\%Firmware% goto :CopyFirmware
goto :NoFirmware

:CopyFirmware
echo Copied %Firmware% to the disassembly folder
copy ..\Firmware\%Firmware% %Firmware%
:NoFirmware
if exist ..\%FolderName%\Temp.txt del ..\%FolderName%\Temp.txt

%asarVer% --define MainFolder="%FolderName%" --define GameID="%GAMDID%" --define ROMID="%Input1%" --define FileType=2 ..\Global\AssembleFile.asm %output%

%asarVer% --fix-checksum=off --define MainFolder="%FolderName%" --define GameID="%GAMDID%" --define ROMID="%Input1%" --define FileType=3 ..\Global\AssembleFile.asm %output%

echo Cleaning up...
if exist ..\%FolderName%\SPC700\SPC700DataBlocks_%GAMDID%.bin del ..\%FolderName%\SPC700\SPC700DataBlocks_%GAMDID%.bin

echo.
echo Done^^!
echo.
echo.---------------------------------------------------------------------------
echo.
echo Press Enter to re-assemble the chosen ROM.
goto :Input

:Exit
exit
