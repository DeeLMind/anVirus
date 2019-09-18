#include <GuiConstants.au3>
#include <GuiCombo.au3>

Opt('MustDeclareVars',1)

Dim $Combo,$Btn_Exit,$Status,$msg

GuiCreate("ComboBox Get Horizontal Extent", 392, 254)

$Combo = GuiCtrlCreateCombo("", 70, 10, 100, 150,BitOR($CBS_SIMPLE,$CBS_DISABLENOSCROLL,$WS_HSCROLL))
GUICtrlSetData($Combo,"AutoIt v3 is freeware BASIC-like scripting language designed for automating the Windows GUI.|" & _ 
							 "It uses a combination of simulated keystrokes mouse movement and window/control manipulation|" & _ 
							 "in order to automate tasks in a way not possible or reliable with other languages|" & _ 
							 "(e.g. VBScript and SendKeys).")
$Btn_Exit = GuiCtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("",0,234,392,20,BitOR($SS_SUNKEN,$SS_CENTER))
_GuICtrlComboSetHorizontalExtent($Combo, 500)
GUICtrlSetData($Status,"Horizontal Extent: " & _GUICtrlComboGetHorizontalExtent($Combo))
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
Exit
