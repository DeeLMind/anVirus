#include <GUIConstants.au3>
#include <GuiSlider.au3>

opt('MustDeclareVars', 1)

Dim $Gui_Slider, $slider1, $button, $msg, $h_slider

$Gui_Slider = GUICreate("Slider Clear Tics", 220, 100, 100, 200)
GUISetBkColor(0x00E0FFFF)  ; will change background color

$slider1 = GUICtrlCreateSlider(10, 10, 200, 20)
GUICtrlSetLimit(-1, 200, 0) ; change min/max value
$button = GUICtrlCreateButton("Clear Tics", 75, 70, 70, 20)
GUISetState()
GUICtrlSetData($slider1, 45) ; set cursor
$h_slider = ControlGetHandle($Gui_Slider, "", "msctls_trackbar321")
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $button
         _GUICtrlSliderClearTics ($h_slider)
   EndSelect
WEnd
