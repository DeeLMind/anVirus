#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$msg,$Btn_Sel

GuiCreate("ComboBox Set Edit Sel", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 100,$CBS_SIMPLE)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language","freeware")
$Btn_Sel = GUICtrlCreateButton("Select 1st 4 chars",150,150,90,30)
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 200, 90, 30)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Sel
			_GUICtrlComboSetEditSel($Combo,0,4)
	EndSelect
WEnd
Exit
