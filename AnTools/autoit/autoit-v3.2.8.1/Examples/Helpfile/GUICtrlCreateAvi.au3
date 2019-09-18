#include <GUIConstants.au3>

GUICreate ("My GUI Animation",300,200)
$ani1 = GUICtrlCreateAvi (@SystemDir & "\shell32.dll",150, 50,10)

$buttonstart = GUICtrlCreateButton ("start",50,150,70,22)
$buttonstop  = GUICtrlCreateButton ("stop",150,150,70,22)

GUISetState( )

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()

	Select
	  case $msg = $GUI_EVENT_CLOSE
		ExitLoop
		
	  case $msg = $buttonstart
		GUICtrlSetState ($ani1, 1)
		
	  case $msg = $buttonstop
		GUICtrlSetState ($ani1, 0)
		
	EndSelect
Wend

