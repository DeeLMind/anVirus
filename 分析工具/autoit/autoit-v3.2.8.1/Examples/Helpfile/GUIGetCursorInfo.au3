#include <GUIConstants.au3>
$IDC = 0
HotkeySet("{Esc}", "GetPos")

GUICreate("Press Esc to Get Pos", 400, 400)
$x=GUICtrlCreateLabel ("0", 10, 10,50)
$y=GUICtrlCreateLabel ("0", 10, 30,50)
GUISetState()

; Run the GUI until the dialog is closed
Do
$msg = GUIGetMsg()
Until $msg = $GUI_EVENT_CLOSE
Exit

Func GetPos()
    $a=GUIGetCursorInfo()
    GUIctrlSetData($x,$a[0]) 
    GUIctrlSetData($y,$a[1]) 
EndFunc
