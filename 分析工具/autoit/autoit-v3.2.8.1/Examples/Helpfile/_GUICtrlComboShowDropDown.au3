#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Label,$Input,$Btn_Show,$Btn_Hide,$Combo,$Btn_Exit,$msg,$ret

GuiCreate("ComboBox Show Dropdown", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 120)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Show = GuiCtrlCreateButton("Show", 80, 140, 90, 30)
$Btn_Hide = GuiCtrlCreateButton("Hide", 220, 140, 90, 30)
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Show
			_GUICtrlComboShowDropDown($Combo,1)
		Case $msg = $Btn_Hide
			_GUICtrlComboShowDropDown($Combo,0)
	EndSelect
WEnd
Exit
