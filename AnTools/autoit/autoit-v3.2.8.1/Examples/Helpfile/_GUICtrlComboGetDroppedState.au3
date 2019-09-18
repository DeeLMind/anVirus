#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$Status,$msg,$state,$current

GuiCreate("ComboBox Dropped State", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 120)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GUICtrlSetData($Status,"Dropped State: False")
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case Else
			$state = _GUICtrlComboGetDroppedState($Combo)
			If($state And $state <> $current) Then
				$current = $state
				GUICtrlSetData($Status,"Dropped State: True")
			ElseIf($state <> $current) Then
				$current = $state
				GUICtrlSetData($Status,"Dropped State: False")
			EndIf
	EndSelect
WEnd
Exit
