#include <GUIConstants.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered

GUISetHelp("notepad")  ; will run notepad if F1 is typed


GUISetState ()       ; will display an empty dialog box

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

