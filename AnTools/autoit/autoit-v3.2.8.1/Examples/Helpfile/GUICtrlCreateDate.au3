; example1
#include <GUIConstants.au3>

GUICreate ( "My GUI get date", 200,200,800,200)
$date=GUICtrlCreateDate ("1953/04/25", 10,10,185,20 )
GUISetState ()

; Run the GUI until the dialog is closed
Do
	$msg = GUIGetMsg()
Until $msg = $GUI_EVENT_CLOSE

MsgBox(0,"Date",GUICtrlRead($date))
GUIDelete()

; example2
#include <GUIConstants.au3>

GUICreate("My GUI get time")
$n=GUICtrlCreateDate ( "", 20, 20, 100, 20, $DTS_TIMEFORMAT) 
GUISetState ()

; Run the GUI until the dialog is closed
Do
	$msg = GUIGetMsg()
Until $msg = $GUI_EVENT_CLOSE

MsgBox(0,"Time", GUICtrlRead($n))
GUIDelete()

; example3
#include <GUIConstants.au3>

GUICreate ( "My GUI get date", 200,200,800,200)
$date = GUICtrlCreateDate ("1953/04/25", 10,10,185,20 )

; to select a specific default format
If @UNICODE Then
	$DTM_SETFORMAT = 0x1032
Else
	$DTM_SETFORMAT = 0x1005
Endif
 $style = "yyyy/MM/dd HH:mm:s"
GuiCtrlSendMsg($date, $DTM_SETFORMAT, 0, $style)

GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd

MsgBox(0,"Time", GUICtrlRead($date))
