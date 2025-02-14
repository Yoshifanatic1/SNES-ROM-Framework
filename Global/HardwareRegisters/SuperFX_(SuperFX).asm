includeonce

;---------------------------------------------------------------------------

; SuperFX code assembly specific macros

macro SuperFXRoutinePointer(Label, BlockStart, BlockEnd)
	dd <Label>
	dd <BlockStart>
	dd <BlockEnd>
endmacro

;---------------------------------------------------------------------------

macro InsertMacroAtXPosition(Address)
if !Define_Global_IgnoreCodeAlignments == !FALSE
	if stringsequal("<Address>", "NULLROM")
	else
		assert pc() <= <Address>|!FastROMAddressOffset|!HiROMAddressOffset
		base <Address>|!FastROMAddressOffset|!HiROMAddressOffset
	endif
endif
endmacro

;---------------------------------------------------------------------------

macro SetDuplicateOrNullPointer(BaseLoc, Pointer)
pushbase
base <BaseLoc>
<Pointer>:
pullbase
endmacro

;---------------------------------------------------------------------------
