#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Label,$Input,$Btn_Search,$Btn_ExactSearch,$Combo,$Btn_Exit,$Status,$msg,$ret

GuiCreate("ComboBox Find String", 392, 254)

$Label = GuiCtrlCreateLabel("Enter Search String", 20, 20, 120, 20)
$Input = GuiCtrlCreateInput("", 160, 20, 180, 20)
$Btn_Search = GuiCtrlCreateButton("Search", 160, 50, 90, 30)
$Btn_ExactSearch = GuiCtrlCreateButton("Exact Search", 255, 50, 90, 30)
$Combo = GuiCtrlCreateCombo("", 70, 100, 270, 120)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Search
			If(StringLen(GUICtrlRead($Input)) > 0) Then
				$ret = _GUICtrlComboFindString($Combo,GUICtrlRead($Input))
				If($ret <> $CB_ERR) Then
					GUICtrlSetData($Status,'Found "' & GUICtrlRead($Input) & '" at index: ' & $ret)
				Else
					GUICtrlSetData($Status,'"' & GUICtrlRead($Input) & '" Not Found')
				EndIf
			EndIf
		Case $msg = $Btn_ExactSearch
			If(StringLen(GUICtrlRead($Input)) > 0) Then
				$ret = _GUICtrlComboFindString($Combo,GUICtrlRead($Input),1)
				If($ret <> $CB_ERR) Then
					GUICtrlSetData($Status,'Found "' & GUICtrlRead($Input) & '" at index: ' & $ret)
				Else
					GUICtrlSetData($Status,'"' & GUICtrlRead($Input) & '" Not Found')
				EndIf
			EndIf
	EndSelect
WEnd
Exit
