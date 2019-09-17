#include <GuiConstants.au3>
#include <GuiCombo.au3>

opt('MustDeclareVars', 1)

Dim $Combo, $Btn_Exit, $msg, $label_rect, $s_rect, $Btn_GETRECT

GUICreate("ComboBox Get Dropped Control RECT", 392, 254)

$Combo = GUICtrlCreateCombo("", 70, 10, 270, 120)
GUICtrlSetData($Combo, "AutoIt|v3|is|freeware|BASIC-like|scripting|language|designed|for|automating|the Windows GUI.")

$Btn_GETRECT = GUICtrlCreateButton("Get Dropped Control Rect", 150, 130, 90, 40, $BS_MULTILINE)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)

$s_rect = "Left:" & @LF & "Top:" & @LF & "Right:" & @LF & "Bottom:"
$label_rect = GUICtrlCreateLabel($s_rect, 145, 50, 100, 55, $SS_SUNKEN)

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Btn_GETRECT
         Local $rect_array = _GUICtrlComboGetDroppedControlRect($Combo)
         If (IsArray($rect_array)) Then
            $s_rect = "Left:" & $rect_array[1] & @LF & "Top:" & $rect_array[2] & @LF & "Right:" & $rect_array[3] & @LF & "Bottom:" & $rect_array[4]
            GUICtrlSetData($label_rect, $s_rect)
         EndIf
   EndSelect
WEnd
Exit
