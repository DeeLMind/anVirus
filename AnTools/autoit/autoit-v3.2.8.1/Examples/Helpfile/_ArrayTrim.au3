#include <Array.au3>

Dim $avArray[5]
$avArray[0] = "ab"
$avArray[1] = "bc"
$avArray[2] = "cd"
$avArray[3] = "de"
$avArray[4] = "ef"

$aNewArray = _ArrayTrim( $avArray, 1, 1,1,3)
_ArrayDisplay($aNewArray,"demo _ArrayTrim")
Exit

;The new array in order should now be "a", "b" , "c" , "d", "e".