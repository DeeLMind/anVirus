#include <Misc.au3>

Local $color

$color = _ChooseColor (0)
If (@error) Then
   MsgBox(0, "", "Error _ChooseColor: " & @error)
Else
   MsgBox(0,"_ChooseColor","COLORREF rgbColors: " & $color)
EndIf

$color = _ChooseColor (1)
If (@error) Then
   MsgBox(0, "", "Error _ChooseColor: " & @error)
Else
   MsgBox(0,"_ChooseColor","Hex BGR Color: " & $color)
EndIf

$color = _ChooseColor (2, 255) ; default color selected using COLORREF rgbcolor
If (@error) Then
   MsgBox(0, "", "Error _ChooseColor: " & @error)
Else
   MsgBox(0,"_ChooseColor","Hex RGB Color: " & $color)
EndIf

$color = _ChooseColor (2, 0x0000FF, 1) ; default color selected using BGR hex value
If (@error) Then
   MsgBox(0, "", "Error _ChooseColor: " & @error)
Else
   MsgBox(0,"_ChooseColor","Hex RGB Color: " & $color)
EndIf

$color = _ChooseColor (2, 0xFF0000, 2) ; default color selected using RGB hex value
If (@error) Then
   MsgBox(0, "", "Error _ChooseColor: " & @error)
Else
   MsgBox(0,"_ChooseColor","Hex RGB Color: " & $color)
EndIf
