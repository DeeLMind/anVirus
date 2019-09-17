#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$Status,$msg,$Btn_Standard,$Btn_Extended,$state,$current

GuiCreate("ComboBox Set Extended UI", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 120)
GUICtrlSetData($Combo,"AutoIt|v3|is|freeware|BASIC-like|scripting|language")
$Btn_Standard = GuiCtrlCreateButton("Standard", 75, 90, 90, 30)
$Btn_Extended = GuiCtrlCreateButton("Extended", 200, 90, 90, 30)
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
$current = Not $state
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Standard
			_GUICtrlComboSetExtendedUI($Combo, 0)
		Case $msg = $Btn_Extended
			_GUICtrlComboSetExtendedUI($Combo, 1)
		Case Else
			$state = _GUICtrlComboGetExtendedUI($Combo)
			If($state And $state <> $current) Then
				$current = $state
				GUICtrlSetData($Status,"Extend UI: True")
			ElseIf($state <> $current) Then
				$current = $state
				GUICtrlSetData($Status,"Extend UI: False")
			EndIf
	EndSelect
WEnd
Exit
