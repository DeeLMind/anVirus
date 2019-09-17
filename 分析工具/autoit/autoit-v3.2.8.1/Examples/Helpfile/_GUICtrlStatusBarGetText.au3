Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg, $lbl_Info
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Get Text", 500, -1, -1, -1, $WS_SIZEBOX)
$lbl_Info = GUICtrlCreateLabel("", 10, 10, 150, 50, $SS_SUNKEN)
$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)

GUICtrlSetData($lbl_Info, "1st Part: " & _GUICtrlStatusBarGetText($StatusBar1, 0) & @LF & _
		"2nd Part: " & _GUICtrlStatusBarGetText($StatusBar1, 1) & @LF & _
		"3rd Part: " & _GUICtrlStatusBarGetText($StatusBar1, 2))

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

;================================================================
; Example 2 - External Control
;================================================================
Opt("WinTitleMatchMode", 4)
Local $h_win = WinGetHandle("classname=SciTEWindow")
Local $h_status = ControlGetHandle($h_win, "", "msctls_statusbar321")
Local $v_rect = _GUICtrlStatusBarGetText($h_status)
ConsoleWrite("Text: " & _GUICtrlStatusBarGetText($h_status) & @LF)