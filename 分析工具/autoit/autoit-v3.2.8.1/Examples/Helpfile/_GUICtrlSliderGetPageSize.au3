#include <GUIConstants.au3>
#include <GuiSlider.au3>

opt('MustDeclareVars', 1)

Dim $Gui_Slider, $slider1, $msg, $h_slider, $Status

$Gui_Slider = GUICreate("Slider Get Page Size", 220, 100, 100, 200)
GUISetBkColor(0x00E0FFFF)  ; will change background color

$slider1 = GUICtrlCreateSlider(10, 10, 200, 20)
GUICtrlSetLimit(-1, 200, 0) ; change min/max value
GUISetState()
GUICtrlSetData($slider1, 45) ; set cursor
$h_slider = ControlGetHandle($Gui_Slider, "", "msctls_trackbar321")
$Status = GUICtrlCreateLabel("Page Size: " & _GUICtrlSliderGetPageSize ($h_slider), 0, 80, 220, 20, BitOR($SS_SUNKEN, $SS_CENTER))
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
   EndSelect
WEnd
