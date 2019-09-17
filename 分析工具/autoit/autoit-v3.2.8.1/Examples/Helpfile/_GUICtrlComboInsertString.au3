#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Label,$Input,$Btn_Insert,$Combo,$Btn_Exit,$msg,$Status,$i_index

GuiCreate("ComboBox Insert String", 392, 254)

$Label = GuiCtrlCreateLabel("Enter String to Insert", 20, 20, 120, 20)
$Input = GuiCtrlCreateInput("", 160, 20, 180, 20)
$Btn_Insert = GuiCtrlCreateButton("Add String", 210, 50, 90, 30)
$Combo = GuiCtrlCreateCombo("A", 70, 100, 270, 100,$CBS_SIMPLE)
GUICtrlSetData($Combo,"B|C|D|E|F")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 200, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Insert
			If(StringLen(GUICtrlRead($Input)) > 0) Then
				$i_index =_GUICtrlComboInsertString($Combo,_GUICtrlComboGetCurSel($Combo),GUICtrlRead($Input))
				GUICtrlSetData($Status,"String Inserted At Index: " & $i_index)
			EndIf
	EndSelect
WEnd
Exit
