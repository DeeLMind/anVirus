#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Label,$Input,$Btn_Set,$Combo,$Btn_Exit,$msg,$ret

GuiCreate("ComboBox Set Dropped Width", 392, 254)

$Label = GuiCtrlCreateLabel("Enter New Width", 20, 20, 100, 20)
$Input = GuiCtrlCreateInput("", 160, 20, 180, 20,$ES_NUMBER)
GUICtrlSetLimit($Input,3)
$Btn_Set = GuiCtrlCreateButton("Set Width", 160, 50, 90, 30)
$Combo = GuiCtrlCreateCombo("", 70, 100, 50, 120)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 200, 90, 30)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Set
			If(StringLen(GUICtrlRead($Input)) > 0) Then
				$ret = _GUICtrlComboSetDroppedWidth($Combo,Int(GUICtrlRead($Input)))
				If($ret == $CB_ERR) Then
					MsgBox(0,"Error","Couldn't set width")
				EndIf
			EndIf
	EndSelect
WEnd
Exit
