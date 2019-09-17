#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$ret,$Btn_Exit,$msg,$ret,$Label,$Input,$Btn_Set

GuiCreate("ComboBox Set Top Index", 392, 254)

$Label = GuiCtrlCreateLabel("Enter Top Index", 80, 20, 120, 20)
$Input = GuiCtrlCreateInput("", 160, 20, 50, 20,$ES_NUMBER)
GUICtrlSetLimit($Input,2)
$Btn_Set = GuiCtrlCreateButton("Set", 160, 50, 90, 30)
$Combo = GuiCtrlCreateCombo("", 70, 100, 270, 80,BitOR($CBS_SIMPLE,$CBS_DISABLENOSCROLL,$WS_VSCROLL))
$ret = _GUICtrlComboAddDir($Combo,"drives")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 200, 90, 30)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Set
			If(StringLen(GUICtrlRead($Input)) > 0) Then
				_GUICtrlComboSetTopIndex($Combo,Int(GUICtrlRead($Input)))
			EndIf
	EndSelect
WEnd
Exit
