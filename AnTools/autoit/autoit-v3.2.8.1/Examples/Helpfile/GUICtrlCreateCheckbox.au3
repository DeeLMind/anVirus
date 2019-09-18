#include <GUIConstants.au3>

GUICreate("My GUI Checkbox")  ; will create a dialog box that when displayed is centered

$checkCN = GUICtrlCreateCheckbox ("CHECKBOX 1", 10, 10, 120, 20)

GUISetState ()       ; will display an  dialog box with 1 checkbox

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend




