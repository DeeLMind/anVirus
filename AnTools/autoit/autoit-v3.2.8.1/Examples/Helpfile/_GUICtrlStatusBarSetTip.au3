Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[3] = [100, 200, -1]
Local $a_PartsText[3] = ["", "Force tip to be shown when text is more than fits in the box", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Set Tip", 500, -1, -1, -1, $WS_SIZEBOX)

$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText, $SBT_TOOLTIPS)
_GUICtrlStatusBarSetIcon($StatusBar1, 0, "shell32.dll", 21)
_GUICtrlStatusBarSetTip($StatusBar1, 0, "Tip works when only icon in part or text exceeds part")
_GUICtrlStatusBarSetTip($StatusBar1, 1, "Force tip to be shown when text is more than fits in the box")
_GUICtrlStatusBarSetTip($StatusBar1, 2, "Part 3")

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
_GUICtrlStatusBarSetText($h_status, "")
_GUICtrlStatusBarSetIcon($h_status, 0, "shell32.dll", 21)
Sleep(10000)
_GUICtrlStatusBarSetIcon($h_status, 0)
_GUICtrlStatusBarSetText($h_status, $s_text)
