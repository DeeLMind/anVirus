#include <GUIConstants.au3>

GUICreate("My GUI style")  ; will create a dialog box that when displayed is centered

GUICtrlCreateLabel ( "my label which will split on several lines", 10,20, 100, 100)
GUICtrlSetStyle (-1, $SS_RIGHT )
				
GUISetState ()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend


