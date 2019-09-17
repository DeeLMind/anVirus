Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[4] = [100, 200, 350, -1]
Local $a_PartsText[4] = ["New Text", "More Text", "Even More Text", "Hey some more"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Get Rect", 500, -1, -1, -1, $WS_SIZEBOX)
$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)

For $x = 0 To 3
	_GetRectInformation($StatusBar1, $x)
Next

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
Local $v_rect = _GUICtrlStatusBarGetRect($h_status, 0)
ConsoleWrite("Left: " & $v_rect[0] & @LF & _
		"Top: " & $v_rect[1] & @LF & _
		"Right: " & $v_rect[2] & @LF & _
		"Bottom: " & $v_rect[3] & @LF)


Func _GetRectInformation(ByRef $StatusBar1, ByRef $i_part)
	Local $a_rect = _GUICtrlStatusBarGetRect($StatusBar1, $i_part)
	If IsArray($a_rect) Then _GUICtrlStatusBarSetText($StatusBar1, $a_rect[0] & "," & $a_rect[1] & "," & $a_rect[2] & "," & $a_rect[3], $i_part)
EndFunc   ;==>_GetRectInformation