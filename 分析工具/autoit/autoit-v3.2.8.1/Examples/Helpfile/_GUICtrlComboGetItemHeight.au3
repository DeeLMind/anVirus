#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$msg,$Status

GuiCreate("ComboBox Get Item Height", 392, 254)

$Combo = GuiCtrlCreateCombo("A", 70, 10, 270, 100,$CBS_SIMPLE)
GUICtrlSetData($Combo,"B|C|D|E|F")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GUICtrlSetData($Status,"Item 1 Height " & _GUICtrlComboGetItemHeight($Combo, 1))

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
Exit
