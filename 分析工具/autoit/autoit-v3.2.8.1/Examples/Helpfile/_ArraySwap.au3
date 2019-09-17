#include <Array.au3>

Dim $asArray[2]

$asArray[0] = "World!"
$asArray[1] = "Hello"

_ArrayDisplay( $asArray, "_ArraySwap() - BEFORE" )
_ArraySwap( $asArray[0], $asArray[1] )
_ArrayDisplay( $asArray, "_ArraySwap() - AFTER" )
Exit
