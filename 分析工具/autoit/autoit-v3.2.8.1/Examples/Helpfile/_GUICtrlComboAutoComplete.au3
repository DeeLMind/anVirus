#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt ('MustDeclareVars', 1)

Dim $Combo, $Btn_Exit, $msg, $old_string = ""

GUICreate("ComboBox AutoComplete", 392, 254)

$Combo = GUICtrlCreateCombo("", 70, 100, 270, 120)
GUICtrlSetData($Combo, "AutoIt|v3|is|freeware|BASIC-like|scripting|language|Autobot|Animal")
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case Else
			_GUICtrlComboAutoComplete ($Combo, $old_string)
	EndSelect
WEnd
Exit