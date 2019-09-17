#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date, $s_rect, $label_rect, $Btn_GETRECT, $Btn_Exit, $msg

GUICreate("Month Calender Get Min Required RECT", 400, 250)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10)

$s_rect = "Left:" & @LF & "Top:" & @LF & "Right:" & @LF & "Bottom:"
$label_rect = GUICtrlCreateLabel($s_rect, 270, 40, 100, 55, $SS_SUNKEN)

$Btn_GETRECT = GUICtrlCreateButton("Get Rect", 270, 120, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Btn_GETRECT
         Local $rect_array = _GUICtrlMonthCalGetMinReqRECT ($Date)
         If (IsArray($rect_array)) Then
            $s_rect = "Left:" & $rect_array[1] & @LF & "Top:" & $rect_array[2] & @LF & "Right:" & $rect_array[3] & @LF & "Bottom:" & $rect_array[4]
            GUICtrlSetData($label_rect, $s_rect)
         EndIf
   EndSelect
WEnd
