Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg, $lbl_Info
Local $a_PartsRightEdge[3] = [100, 200, -1]
Local $a_PartsText[3] = ["New Text", "Tip works when only icon in part or text exceeds part", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Get Tip Text", 500, -1, -1, -1, $WS_SIZEBOX)

$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText, $SBT_TOOLTIPS)

_GUICtrlStatusBarSetIcon($StatusBar1, 1, "shell32.dll", 168)
_GUICtrlStatusBarSetIcon($StatusBar1, 0, "shell32.dll", 21)
_GUICtrlStatusBarSetIcon($StatusBar1, 2, "shell32.dll", 24)

_GUICtrlStatusBarSetTip($StatusBar1, 0, "Part 1")
_GUICtrlStatusBarSetTip($StatusBar1, 1, "Tip works when only icon in part or text exceeds part")
_GUICtrlStatusBarSetTip($StatusBar1, 2, "Part 3")

$lbl_Info = GUICtrlCreateLabel("Tip Text of 2nd Part: " & _GUICtrlStatusBarGetTip($StatusBar1, 1), 10, 10, 400, 20)

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
ConsoleWrite("Tip Text: " & _GUICtrlStatusBarGetTip($h_status) & @LF)