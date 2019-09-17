#include <GUIConstants.au3>
#include <GuiSlider.au3>

opt('MustDeclareVars', 1)

Dim $Gui_Slider, $slider1, $button, $msg, $h_slider, $Status, $Pos = 0

$Gui_Slider = GUICreate("Slider Set Pos", 220, 100, 100, 200)
GUISetBkColor(0x00E0FFFF)  ; will change background color

$slider1 = GUICtrlCreateSlider(10, 10, 200, 20)
GUICtrlSetLimit(-1, 200, 0) ; change min/max value
$button = GUICtrlCreateButton("Set Pos", 75, 55, 75, 20)
GUISetState()
GUICtrlSetData($slider1, 45) ; set cursor
$h_slider = ControlGetHandle($Gui_Slider, "", "msctls_trackbar321")
$Status = GUICtrlCreateLabel("Pos: " & GUICtrlRead($slider1), 0, 80, 220, 20, BitOR($SS_SUNKEN, $SS_CENTER))
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $button
         $Pos += 10
         If $Pos > 200 Then
            $Pos = 10
         EndIf
         _GUICtrlSliderSetPos ($h_slider, $Pos)
         GUICtrlSetData($Status, "Pos: " & GUICtrlRead($slider1))
   EndSelect
WEnd
