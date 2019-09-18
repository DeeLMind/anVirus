#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$Status,$msg,$Btn_Get

GuiCreate("ComboBox Get Top Index", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 100,BitOR($CBS_SIMPLE,$CBS_DISABLENOSCROLL,$WS_VSCROLL))
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language|designed|for|automating")
$Btn_Get = GuiCtrlCreateButton("Get Top Index", 150, 140, 90, 30)
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GUICtrlSetData($Status,"Top Index: " & _GUICtrlComboGetTopIndex($Combo))
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Get
			GUICtrlSetData($Status,"Top Index: " & _GUICtrlComboGetTopIndex($Combo))
	EndSelect
WEnd
Exit
