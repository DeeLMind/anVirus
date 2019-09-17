#include <GUIConstants.au3>

GUICreate ( "My GUI delete control", 200,200,800,200)
$date=GUICtrlCreateDate ("1953/04/25", 10,10,185,20 )
$del=GUICtrlCreateButton("Delete control", 50,50,70,20 )
GUISetState ()

; Run the GUI until the dialog is closed
Do
	$msg = GUIGetMsg()
	if $msg = $del then
		GUICtrlDelete($date)
		GUICtrlDelete($del)
	endif
Until $msg = $GUI_EVENT_CLOSE

