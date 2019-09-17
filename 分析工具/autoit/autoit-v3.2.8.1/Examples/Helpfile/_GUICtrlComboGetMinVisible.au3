#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$Status,$msg

GuiCreate("ComboBox Get Min Visible", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 100,$CBS_SIMPLE)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GUICtrlSetData($Status,"Min Visible: " & _GUICtrlComboGetMinVisible($Combo))
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
Exit
