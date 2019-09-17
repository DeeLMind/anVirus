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

_ArrayDisplay( $avArray, "Unsorted" )
_ArraySort( $avArray)
_ArrayDisplay( $avArray, "Sort Ascending" )
_ArraySort( $avArray,1)
_ArrayDisplay( $avArray, "Sort Decending" )

; Example sort Array created with StringSplit.
$avArray = StringSplit("b,d,c,w,a,e,s,r,x,q",",")
_ArrayDisplay( $avArray, "UnSorted" )
_ArraySort( $avArray,0,1,5)  ; sort first 5 entries
_ArrayDisplay( $avArray, "Sort first 5 entries" )
_ArraySort( $avArray,0,1)  ; sort and start at 1.. skip array[0]
_ArrayDisplay( $avArray, "Sorted starting at 1" )
_ArraySort( $avArray,1,1)  ; sort and start at 1.. skip array[0]
_ArrayDisplay( $avArray, "Sorted Desc starting at 1" )

; Demonstration difference Alpha-numeric and Numeric sorting
Dim $avArray = StringSplit("2|4|7|1|-9|5","|")
_ArrayDisplay( $avArray, "Unsorted" )
_ArraySort( $avArray,1,1)
_ArrayDisplay( $avArray, "Alpha numeric Sorted Descending" )
;Convert Array entries to numeric values
For $x = 1 To UBound($avArray) -1
	$avArray[$x] = Number($avArray[$x])
Next
_ArraySort( $avArray,1,1) 
_ArrayDisplay( $avArray, "Numeric Sorted Descending" )
Exit
