; Note: This file is used by the ExtractAssets.bat batch script to define where each file is, how large they are, and their filenames.

lorom
;!ROMVer = $0000						; Note: This is set within the batch script
!GAMEX_V1 = $0001
!GAMEX_V2 = $0002

org $008000
MainPointerTableStart:
	dl MainPointerTableStart,MainPointerTableEnd-MainPointerTableStart
	dl UncompressedGFXPointersStart,(UncompressedGFXPointersEnd-UncompressedGFXPointersStart)/$0C
	dl CompressedGFXPointersStart,(CompressedGFXPointersEnd-CompressedGFXPointersStart)/$0C
	dl MusicPointersStart,(MusicPointersEnd-MusicPointersStart)/$0C
	dl BRRPointersStart,(BRRPointersEnd-BRRPointersStart)/$0C
MainPointerTableEnd:

;--------------------------------------------------------------------

UncompressedGFXPointersStart:
UncompressedGFXPointersEnd:

;--------------------------------------------------------------------

CompressedGFXPointersStart:
CompressedGFXPointersEnd:

;--------------------------------------------------------------------

MusicPointersStart:
MusicPointersEnd:

;--------------------------------------------------------------------

BRRPointersStart:
BRRPointersEnd:

;--------------------------------------------------------------------

;--------------------------------------------------------------------

;--------------------------------------------------------------------

;--------------------------------------------------------------------

;--------------------------------------------------------------------
