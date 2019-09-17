#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$ret,$Btn_Exit,$Status,$msg,$allocated

GuiCreate("ComboBox Init Storage", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 100,$CBS_SIMPLE)
$allocated = _GUICtrlComboInitStorage($Combo, 26, 50)
$ret = _GUICtrlComboAddDir($Combo,"drives")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
GUICtrlSetData($Status,"Pre-Allocated Memory For: " & $allocated & " Items, Drives Added To ComboBox: " & _GUICtrlComboGetCount($Combo))
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
Exit
