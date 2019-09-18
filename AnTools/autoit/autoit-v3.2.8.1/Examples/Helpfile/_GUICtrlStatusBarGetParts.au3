opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg, $lbl_Parts
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

$gui = GUICreate("Status Bar Get Parts", 500, -1, -1, -1, $WS_SIZEBOX)
$StatusBar1 = _GUICtrlStatusBarCreate ($gui, $a_PartsRightEdge, $a_PartsText)
$lbl_Parts = GUICtrlCreateLabel("Number of Parts: " & _GUICtrlStatusBarGetParts($StatusBar1),10,10,100,25,$SS_SUNKEN )

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