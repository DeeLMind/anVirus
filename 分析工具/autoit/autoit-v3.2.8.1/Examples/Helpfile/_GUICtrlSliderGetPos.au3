#include <GUIConstants.au3>
#include <GuiSlider.au3>

opt('MustDeclareVars', 1)

Dim $Gui_Slider, $slider1, $button, $msg, $h_slider, $Status, $Pos = 0

$Gui_Slider = GUICreate("Slider Get Pos",220,100)
GUISetBkColor (0x00E0FFFF)  ; will change background color

$slider1 = GUICtrlCreateSlider (10,10,200,20)
GUICtrlSetLimit(-1,200,0)	; change min/max value
$button = GUICtrlCreateButton ("Value?",75,50,70,20)
GUISetState()
GUICtrlSetData($slider1,45)	; set cursor
$h_slider = ControlGetHandle($Gui_Slider, "", "msctls_trackbar321")
$Status = GUICtrlCreateLabel("Pos: " & _GUICtrlSliderGetPos($h_slider), 0, 80, 220, 20, BitOR($SS_SUNKEN, $SS_CENTER))

While 1
  $msg = GUIGetMsg ()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $button
			GUICtrlSetData($Status,"Pos: " & _GUICtrlSliderGetPos($h_slider))
		EndSelect
WEnd
