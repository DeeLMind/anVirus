#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$msg

GuiCreate("ComboBox Limit Text", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 100, 270, 100,$CBS_SIMPLE)
GUICtrlSetData($Combo,"A|B|C|D|E|F")
_GUICtrlComboLimitText($Combo,10)
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 200, 90, 30)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
Exit
