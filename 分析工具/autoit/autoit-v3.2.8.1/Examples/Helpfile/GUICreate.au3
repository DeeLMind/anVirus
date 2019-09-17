; example 1
#include <GUIConstants.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered
GUISetState (@SW_SHOW)       ; will display an empty dialog box

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend
	
	
; example 2
#include <GUIConstants.au3>

$gui=GUICreate("Background", 800, 300)
; background picture
$background = GUICtrlCreatePic ("demo-bg.jpg", 0, 0, 800, 300)
GUISetState(@SW_SHOW)

; transparent child window
$pic=GUICreate("", 14, 80, 0, 0,$WS_POPUP,$WS_EX_LAYERED+$WS_EX_MDICHILD,$gui)
; transparent pic
$basti_stay = GUICtrlCreatePic ("l_st.gif", 0, 0, 14, 80)
GUISetState(@SW_SHOW)

do
    $msg = GUIGetMsg()
    
until $msg = $GUI_EVENT_CLOSE
