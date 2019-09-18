#include <GuiConstants.au3>
#include <GuiCombo.au3>

opt('MustDeclareVars', 1)

Dim $Combo, $Btn_Exit, $msg, $Status

GUICreate("ComboBox Get Edit Sel", 392, 254)

$Combo = GUICtrlCreateCombo("", 70, 10, 270, 100, $CBS_SIMPLE)
GUICtrlSetData($Combo, "AutoIt|v3|is|freeware|BASIC-like|scripting|language", "freeware")
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 200, 90, 30)

$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
Local $a_sel = _GUICtrlComboGetEditSel($Combo)
If (IsArray($a_sel)) Then
   GUICtrlSetData($Status, "Chars Position Selected From: " & $a_sel[1] & " To: " & $a_sel[2])
EndIf

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
   EndSelect
WEnd
Exit
