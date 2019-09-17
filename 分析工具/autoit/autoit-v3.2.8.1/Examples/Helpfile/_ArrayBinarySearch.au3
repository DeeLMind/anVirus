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
$avArray[8] = "JdeB"
$avArray[9] = "Tylo"

; sort the array to be able to do  a binary search
_ArraySort( $avArray)

; display sorted array
_ArrayDisplay( $avArray, "sorted" )

; Lookup existing entry
$iKeyIndex = _ArrayBinarySearch ( $avArray, "Jon" )
If Not @error Then
   Msgbox(0,'Entry found',' Index:' & $iKeyIndex)
Else
   Msgbox(0,'Entry Not found',' Error:' & @error)
EndIf

; Lookup None existing entry
$iKeyIndex = _ArrayBinarySearch ( $avArray, "Unknown" )
If Not @error Then
   Msgbox(0,'Entry found',' Index:' & $iKeyIndex)
Else
   Msgbox(0,'Entry Not found',' Error:' & @error)
EndIf


;
; Example 2, using an Array returned by StringSplit
;
$avArray = StringSplit("a,b,d,c,e,f,g,h,i",",")

; sort the array to be able to do  a binary search
_ArraySort( $avArray, 0, 1)

; display sorted array
_ArrayDisplay( $avArray, "sorted" )

; added 1 as second parameter to skip looking in $avArray[0]
$iKeyIndex = _ArrayBinarySearch ( $avArray, "c",1 )  
If Not @error Then
   Msgbox(0,'Entry found',' Index:' & $iKeyIndex)
Else
   Msgbox(0,'Entry Not found',' Error:' & @error)
EndIf

Exit
