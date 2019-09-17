#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$ret,$Btn_Exit,$msg,$allocated,$Btn_Clear

GuiCreate("ComboBox Reset Content", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 270, 100,$CBS_SIMPLE)
$allocated = _GUICtrlComboInitStorage($Combo, 26, 50)
$ret = _GUICtrlComboAddDir($Combo,"drives")
$Btn_Clear = GUICtrlCreateButton("Reset Content",150,140,90,30)
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Clear
			_GUICtrlComboResetContent($Combo)
	EndSelect
WEnd
Exit
