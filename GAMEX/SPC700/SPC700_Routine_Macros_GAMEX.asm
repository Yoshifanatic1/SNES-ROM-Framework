
;#############################################################################################################
;#############################################################################################################

macro SPC700_GAMEX_SPC700_Engine(Base)
%InsertMacroAtXPosition(<Base>)
namespace GAMEX_SPC700_Engine

Main:
	BRA Main
namespace off
base off
endmacro

;#############################################################################################################
;#############################################################################################################

macro SPC700_GAMEX_GlobalSampleBank(Base)
%InsertMacroAtXPosition(<Base>)
namespace GAMEX_GlobalSampleBank

Ptrs:
	dw SPC700_Sample00	:	dw SPC700_Sample00+$1B

SPC700_Sample00:

namespace off
base off
endmacro

;#############################################################################################################
;#############################################################################################################
