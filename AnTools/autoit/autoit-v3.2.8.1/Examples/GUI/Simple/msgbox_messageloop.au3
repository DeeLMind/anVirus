; A simple custom messagebox that uses the MessageLoop mode

#include <GUIConstants.au3>

GUICreate("Custom Msgbox", 210, 80)

$Label = GUICtrlCreateLabel("Please click a button!", 10, 10)
$YesID  = GUICtrlCreateButton("Yes", 10, 50, 50, 20)
$NoID   = GUICtrlCreateButton("No", 80, 50, 50, 20)
$ExitID = GUICtrlCreateButton("Exit", 150, 50, 50, 20)

GUISetState()  ; display the GUI

Do
	$msg = GUIGetMsg()
   
	Select
		Case $msg= $YesID
			MsgBox(0,"You clicked on", "Yes")
		Case $msg= $NoID
			MsgBox(0,"You clicked on", "No")
		Case $msg= $ExitID
			MsgBox(0,"You clicked on", "Exit")
		Case $msg= $GUI_EVENT_CLOSE
			MsgBox(0,"You clicked on", "Close")
	EndSelect
Until $msg = $GUI_EVENT_CLOSE or $msg = $ExitID

