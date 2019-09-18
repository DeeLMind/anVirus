#include <GUIConstants.au3>

GUICreate("My GUI limit input 3 chars")  ; will create a dialog box that when displayed is centered

GUICtrlCreateInput("", 10,20)
GUICtrlSetLimit(-1,3)	; to limit the entry to 3 chars
				
GUISetState ()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend


