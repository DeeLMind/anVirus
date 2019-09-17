Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Global $StatusBar2

_Example_1()
_Example_2()

Func _Example_1()
	
	Local $gui, $StatusBar1, $msg
	Local $a_PartsRightEdge[3] = [100, 350, -1]
	Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]
	
	$gui = GUICreate("Status Bar Resize", 500, -1, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SYSMENU, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	
	
	$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)
	
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_RESIZED Or $msg = $GUI_EVENT_MINIMIZE Or $msg = $GUI_EVENT_MAXIMIZE Or $msg = $GUI_EVENT_RESTORE
				_GUICtrlStatusBarResize($StatusBar1)
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				;;;;;
		EndSelect
		
	WEnd
	GUIDelete()
EndFunc   ;==>_Example_1

Func _Example_2()
	Local $gui, $msg
	Local $a_PartsRightEdge[3] = [100, 350, -1]
	Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]
	
	$gui = GUICreate("Status Bar Resize", 500, -1, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SYSMENU, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	
	$StatusBar2 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)
	
	;$WM_SIZE/$WM_SIZING are defined in GuiStatusBar.au3
	GUIRegisterMsg($WM_SIZING, "WM_SIZING"); handle resize
	GUIRegisterMsg($WM_SIZE, "WM_SIZING"); button maximize
	
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				;;;;;
		EndSelect
		
	WEnd
	GUIDelete()
EndFunc   ;==>_Example_2

Func WM_SIZING()
	Return _GUICtrlStatusBarResize($StatusBar2)
EndFunc   ;==>WM_SIZING
