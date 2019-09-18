#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt ('MustDeclareVars', 1)

Dim $Min = 5, $Combo, $ret, $Btn_Exit, $msg, $ret, $Btn_Set

GUICreate("ComboBox Set Min Visible", 392, 254)

$Combo = GUICtrlCreateCombo("", 70, 10, 270, 120)
$ret = _GUICtrlComboAddDir ($Combo, "drives")
$Btn_Set = GUICtrlCreateButton("Set", 150, 160, 90, 30)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 200, 90, 30)
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Set
			_GUICtrlComboSetMinVisible ($Combo, $Min)
			If ($Min == 5) Then
				$Min = 30
			Else
				$Min = 5
			EndIf
	EndSelect
WEnd
Exit
