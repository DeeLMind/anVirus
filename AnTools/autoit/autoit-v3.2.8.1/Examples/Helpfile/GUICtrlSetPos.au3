#include <GUIConstants.au3>

GUICreate("My GUI position")  ; will create a dialog box that when displayed is centered

$right = 0
$label=GUICtrlCreateLabel ( "my moving label", 10,20)
				
$button = GUICtrlCreateButton ("Click to close", 50,50)
GUICtrlSetState(-1,$GUI_FOCUS)				; the focus is on this button

GUISetState ()

While 1
	$msg = GUIGetMsg()

	if $msg = $button Or $msg = $GUI_EVENT_CLOSE then Exit
	If $right = 0 then
		$right = 1
		GUICtrlSetPos ($label, 20,20)
	else
		$right = 0
		GUICtrlSetPos ($label, 10,20)
	endif
	Sleep(100)
Wend
