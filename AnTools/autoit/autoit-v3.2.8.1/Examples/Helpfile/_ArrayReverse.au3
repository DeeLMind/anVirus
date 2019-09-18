#include <Array.au3>
Dim $avArray[10]
$avArray[0] = "JPM"
$avArray[1] = "Holger"
$avArray[2] = "Jon"
$avArray[3] = "Larry"
$avArray[4] = "Jeremy"
$avArray[5] = "Valik"
$avArray[6] = "Cyberslug"
$avArray[7] = "Nutster"
$avArray[8] = "Tylo"
$avArray[9] = "JdeB"

_ArrayDisplay( $avArray, "Normal" )
_ArrayReverse( $avArray)
_ArrayDisplay( $avArray, "Reversed" )

; Example Reverse Array created with StringSplit.
$avArray = StringSplit("0,1,2,3,4,5,6,7,8,9,10,11,12",",")
_ArrayDisplay( $avArray, "Normal" )
_ArrayReverse( $avArray, 1)   ; added the 1 as second parameter
_ArrayDisplay( $avArray, "Reversed" )

Exit
