#Include<Array.au3>
Dim $Array[6]
$Array[0] = "String0|SubString0"
$Array[1] = "String1|SubString1"
$Array[2] = "String2|SubString2"
$Array[3] = "String3|SubString3"
$Array[4] = "String4|SubString4"
$Array[5] = "String5|SubString5"

$Input = InputBox("ArraySearch Demo", "String To Find?")
If @error Then Exit

$Pos = _ArraySearch ($Array, $Input, 0, 0, 0, True)
Select
    Case $Pos = -1
        MsgBox(0, "Not Found", '"' & $Input & '" was not found in the array.')
    Case Else
        MsgBox(0, "Found", '"' & $Input & '" was found in the array at pos ' & $Pos & ".")
EndSelect
