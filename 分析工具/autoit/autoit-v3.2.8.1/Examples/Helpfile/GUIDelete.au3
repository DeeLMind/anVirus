#include <GUIConstants.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered

GUISetState ()       ; will display an empty dialog box

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

GUIDelete();	; will return 1
