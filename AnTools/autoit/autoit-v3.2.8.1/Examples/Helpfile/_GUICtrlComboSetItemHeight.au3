#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt ('MustDeclareVars', 1)

Dim $Height = 25, $Btn_Set, $Combo, $Btn_Exit, $msg, $ret

GUICreate("ComboBox Set Item Height", 392, 254)

$Combo = GUICtrlCreateCombo("", 70, 10, 270, 120)
GUICtrlSetData($Combo, "AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Set = GUICtrlCreateButton("Set", 150, 140, 90, 30)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Set
			$ret = _GUICtrlComboSetItemHeight ($Combo, -1, $Height)
			If ($Height == 25) Then
				$Height = 15
			Else
				$Height = 25
			EndIf
	EndSelect
WEnd
Exit
