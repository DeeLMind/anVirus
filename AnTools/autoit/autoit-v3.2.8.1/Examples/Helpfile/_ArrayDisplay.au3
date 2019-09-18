; Ex. #1:
#include <Array.au3>
$asControls = StringSplit(WinGetClassList("", ""), @LF)
_ArrayDisplay($asControls, "Class List of Active Window")

; Ex. #2:
#include <Array.au3>
Dim $arGrid[2][4] = [["Paul", "Jim", "Richard", "Louis"], [485.44, 160.68, 275.16, 320.00]]
_ArrayDisplay($arGrid, "_ArrayDisplay() 2D Test", 1, 1) ; [2D, transposed]

; Ex. #3:
#include <Array.au3>
Dim $avArray[8]
$avArray[0] = 7
$avArray[1] = "Brian"
$avArray[2] = "Jon"
$avArray[3] = "Larry"
$avArray[4] = "Christa"
$avArray[5] = "Rick"
$avArray[6] = "Jack"
$avArray[7] = "Gregory"
_ArrayDisplay($avArray, "_ArrayDisplay() Test")