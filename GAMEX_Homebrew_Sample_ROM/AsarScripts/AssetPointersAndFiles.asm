; Note: This file is used by the ExtractAssets.bat batch script to define where each file is, how large they are, and their filenames.

hirom
;!ROMVer = $0000						; Note: This is set within the batch script
!GAMEX_V1 = $0001
!GAMEX_V2 = $0002

check bankcross off

org $C00000
MainPointerTableStart:
	dl MainPointerTableStart,MainPointerTableEnd-MainPointerTableStart
	dl UncompressedGFXPointersStart,(UncompressedGFXPointersEnd-UncompressedGFXPointersStart)/$0C
	dl CompressedGFXPointersStart,(CompressedGFXPointersEnd-CompressedGFXPointersStart)/$0C
	dl PalettePointersStart,(PalettePointersEnd-PalettePointersStart)/$0C
	dl MusicPointersStart,(MusicPointersEnd-MusicPointersStart)/$0C
	dl BRRPointersStart,(BRRPointersEnd-BRRPointersStart)/$0C
MainPointerTableEnd:

;--------------------------------------------------------------------

UncompressedGFXPointersStart:
	;dl $008000,$008020,GFX_ExampleGraphicsFile,GFX_ExampleGraphicsFileEnd
UncompressedGFXPointersEnd:

;--------------------------------------------------------------------

CompressedGFXPointersStart:
	;dl $008000,$008037,GFX_ExampleCompressedGraphicsFile,GFX_ExampleCompressedGraphicsFileEnd
CompressedGFXPointersEnd:

;--------------------------------------------------------------------

PalettePointersStart:
	;dl $000001,PAL_ExamplePaletteFile_Ptrs,PAL_ExamplePaletteFile,PAL_ExamplePaletteFileEnd
PalettePointersEnd:

PAL_ExamplePaletteFile_Ptrs:
	db $03 : dw $0000
	dl $000000,$008000,$008020
	dl $000000,$008020,$008040
	dl $000000,$008040,$008060

;--------------------------------------------------------------------

MusicPointersStart:
	;dl $008000,$008029,Music_ExampleMusicFile,Music_ExampleMusicFileEnd
MusicPointersEnd:

;--------------------------------------------------------------------

BRRPointersStart:
	;dl $008000,$008022,BRR_ExampleSampleFile,BRR_ExampleSampleFileEnd
BRRPointersEnd:

;--------------------------------------------------------------------

GFX_ExampleGraphicsFile:
	db "GFX_ExampleGraphicsFile.bin"
GFX_ExampleGraphicsFileEnd:

;--------------------------------------------------------------------

GFX_ExampleCompressedGraphicsFile:
	db "GFX_ExampleCompressedGraphicsFile.bin"
GFX_ExampleCompressedGraphicsFileEnd:

;--------------------------------------------------------------------

PAL_ExamplePaletteFile:
	db "PAL_ExamplePaletteFile.tpl"
PAL_ExamplePaletteFileEnd:

;--------------------------------------------------------------------

Music_ExampleMusicFile:
	db "Music_ExampleMusicFile.bin"
Music_ExampleMusicFileEnd:

;--------------------------------------------------------------------

BRR_ExampleSampleFile:
	db "BRR_ExampleSampleFile.brr"
BRR_ExampleSampleFileEnd:

;--------------------------------------------------------------------
