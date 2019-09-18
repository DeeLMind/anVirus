#include <GUIConstants.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered

GUICtrlCreateButton ("my picture button", 10,20,40,40, $BS_ICON)
GUICtrlSetImage (-1, "shell32.dll",22)
				
GUISetState ()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend


