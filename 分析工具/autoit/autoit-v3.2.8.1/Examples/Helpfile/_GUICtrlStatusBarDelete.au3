opt("MustDeclareVars", 1)

#include <GUIConstantsEx.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg, $btn_delete
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

$gui = GUICreate("Status Bar Delete", 500, -1, -1, -1, $WS_SIZEBOX)
$StatusBar1 = _GUICtrlStatusBarCreate ($gui, $a_PartsRightEdge, $a_PartsText)
$btn_delete = GUICtrlCreateButton("Delete StatusBar", 10, 10, 120, 25)
GUISetState(@SW_SHOW)


While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_RESIZED
			_GUICtrlStatusBarResize ($StatusBar1)
		Case $msg = $btn_delete
			_GUICtrlStatusBarDelete($StatusBar1)
			GUICtrlSetState($btn_delete, $GUI_DISABLE)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			;;;;;
	EndSelect
	
WEnd