#include <Array.au3>

Dim $avArray[11], $I = 0

; Populate test array.
For $I = 0 to UBound( $avArray ) - 1
	$avArray[$I] = Int( Random( -20000, 20000 ) )
Next

_ArrayDisplay( $avArray, "_ArrayToString() Test" )

Dim $sArrayString = _ArrayToString( $avArray,@TAB, 1, 7 )
MsgBox( 4096, "_ArrayToString() Test", $sArrayString )
Exit
