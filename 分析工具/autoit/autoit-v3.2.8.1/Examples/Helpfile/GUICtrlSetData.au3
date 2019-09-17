#include <GUIConstants.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered

GUICtrlCreateCombo ("", 10,10)

GUICtrlSetData(-1,"item1|item2|item3", "item3")

GUISetState ()       ; will display an empty dialog box with a combo control with focus on

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

