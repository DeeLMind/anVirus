Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[3] = [150, 300, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Get Border Widths", 500, -1, -1, -1, $WS_SIZEBOX)
$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)

Local $a_borders = _GUICtrlStatusBarGetBorders($StatusBar1)
If IsArray($a_borders) Then
	_GUICtrlStatusBarSetText($StatusBar1, "horizontal border: " & $a_borders[0], 0)
	_GUICtrlStatusBarSetText($StatusBar1, "vertical border: " & $a_borders[1], 1)
	_GUICtrlStatusBarSetText($StatusBar1, "between rectangles: " & $a_borders[2], 2)
EndIf

GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_RESIZED
			_GUICtrlStatusBarResize($StatusBar1)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			;;;;;
	EndSelect
	
WEnd
GUIDelete()

;================================================================
; Example 2 - External Control
;================================================================
Opt("WinTitleMatchMode", 4)
Local $h_win = WinGetHandle("classname=SciTEWindow")
Local $h_status = ControlGetHandle($h_win, "", "msctls_statusbar321")
$a_borders = _GUICtrlStatusBarGetBorders($h_status)
ConsoleWrite("horizontal border: " & $a_borders[0] & @LF & _
		"vertical border: " & $a_borders[1] & @LF & _
		"between rectangles: " & $a_borders[2] & @LF)