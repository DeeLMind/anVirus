#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo, $Btn_Delete, $Btn_Exit, $msg

GuiCreate("ComboBox Delete String", 392, 254)

$Combo = GuiCtrlCreateCombo("A", 70, 10, 270, 110,$CBS_SIMPLE)
$Btn_Delete = GuiCtrlCreateButton("Delete String", 135, 120, 90, 30)
GUICtrlSetData($Combo,"B|C|D|E|F")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Delete
			If(_GUICtrlComboGetCurSel($Combo) <> $CB_ERR) Then
				_GUICtrlComboDeleteString($Combo,_GUICtrlComboGetCurSel($Combo))
			EndIf
	EndSelect
WEnd
Exit
