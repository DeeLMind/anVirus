Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = [@TAB & @TAB & "New Text", "Left" & @TAB & "Center" & @TAB & "Right", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Set Text", 500, -1, -1, -1, $WS_SIZEBOX)

$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)
_GUICtrlStatusBarSetText($StatusBar1, @TAB & "Text has been set", 1)

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
Local $s_text = _GUICtrlStatusBarGetText($h_status)
_GUICtrlStatusBarSetText($h_status, "Text has been set")
Sleep(5000)
_GUICtrlStatusBarSetText($h_status, $s_text)