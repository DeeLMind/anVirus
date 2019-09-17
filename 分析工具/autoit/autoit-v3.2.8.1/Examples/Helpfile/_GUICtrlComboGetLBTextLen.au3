#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$Status,$msg

GuiCreate("ComboBox Get LB Text Len", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 100,$CBS_SIMPLE)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Combo
			If(_GUICtrlComboGetCurSel($Combo) <> $CB_ERR) Then
				GUICtrlSetData($Status,"Length of Item[" & _GUICtrlComboGetCurSel($Combo) & "] = " & _GUICtrlComboGetLBTextLen($Combo, _GUICtrlComboGetCurSel($Combo)))
			EndIf
	EndSelect
WEnd
Exit
