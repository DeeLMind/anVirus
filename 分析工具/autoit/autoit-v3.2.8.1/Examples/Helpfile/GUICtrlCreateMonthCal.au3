#include <GUIConstants.au3>
GUICreate( "Get date", 210,190)

$Date = GUICtrlCreateMonthCal ("1953/03/25",10, 10)
GUISetState()

; Run the GUI until the dialog is closed or timeout

Do
   $msg = GUIGetMsg()
   If $msg = $Date Then MsgBox(0,"debug","calendar clicked")
Until $msg = $GUI_EVENT_CLOSE

MsgBox(0, $msg, GUICtrlread($Date), 2)