opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

$gui = GUICreate("Status Bar Get Icon", 500, -1, -1, -1, $WS_SIZEBOX)

$StatusBar1 = _GUICtrlStatusBarCreate ($gui, $a_PartsRightEdge, $a_PartsText)
_GUICtrlStatusBarSetIcon($StatusBar1, 1, "shell32.dll", 168)
_GUICtrlStatusBarSetIcon($StatusBar1, 0, "shell32.dll", 21)
_GUICtrlStatusBarSetIcon($StatusBar1, 2, "shell32.dll", 24)

_GUICtrlStatusBarSetText($StatusBar1, _GUICtrlStatusBarGetIcon($StatusBar1, 0), 0)
_GUICtrlStatusBarSetText($StatusBar1, _GUICtrlStatusBarGetIcon($StatusBar1, 1), 1)
_GUICtrlStatusBarSetText($StatusBar1, _GUICtrlStatusBarGetIcon($StatusBar1, 2), 2)

GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_RESIZED
			_GUICtrlStatusBarResize ($StatusBar1)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			;;;;;
	EndSelect
	
WEnd