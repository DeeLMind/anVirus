#include <GUIConstants.au3>

GUICreate ("My GUI new icon")  ; will create a dialog box that when displayed is centered

GUISetIcon ("autosave.ico")  ; will change icon

GUISetState ( ); will display an empty dialog box

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

