#include <GUIConstants.au3>

GUICreate("slider",220,100, 100,200)
GUISetBkColor (0x00E0FFFF)  ; will change background color

$slider1 = GUICtrlCreateSlider (10,10,200,20)
GUICtrlSetLimit(-1,200,0)	; change min/max value
$button = GUICtrlCreateButton ("Value?",75,70,70,20)
GUISetState()
GUICtrlSetData($slider1,45)	; set cursor

$start=TimerInit()
Do
  $n = GUIGetMsg ()
 	 
   If $n = $button Then
      MsgBox(0,"slider1",GUICtrlRead($slider1),2)
   $start=TimerInit()
   EndIf
Until $n = $GUI_EVENT_CLOSE
