#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Label,$Input,$Btn_Add,$Combo,$Btn_Exit,$msg

GuiCreate("ComboBox Add String", 392, 254)

$Label = GuiCtrlCreateLabel("Enter String to Add", 20, 20, 120, 20)
$Input = GuiCtrlCreateInput("", 160, 20, 180, 20)
$Btn_Add = GuiCtrlCreateButton("Add String", 210, 50, 90, 30)
$Combo = GuiCtrlCreateCombo("A", 70, 100, 270, 120)
GUICtrlSetData($Combo,"B|C|D|E|F")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Add
			If(StringLen(GUICtrlRead($Input)) > 0) Then
				_GUICtrlComboAddString($Combo,GUICtrlRead($Input))
			EndIf
	EndSelect
WEnd
Exit
