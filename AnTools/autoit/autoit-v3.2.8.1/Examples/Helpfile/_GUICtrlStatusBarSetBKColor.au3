Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg, $old_color
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]
Local Const $Yellow = 0xffff00

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Set Back Color", 500, -1, -1, -1, $WS_SIZEBOX)

$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)
$old_color = _GUICtrlStatusBarSetBKColor($StatusBar1, $Yellow)

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
Local $old_color = _GUICtrlStatusBarSetBKColor($h_status, $Yellow)
Sleep(5000)
_GUICtrlStatusBarSetBKColor($h_status, $old_color)