Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Set Unicode", 500, -1, -1, -1, $WS_SIZEBOX)

$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)

_GUICtrlStatusBarSetUnicode($StatusBar1, False)
If _GUICtrlStatusBarGetUnicode($StatusBar1) Then
	_GUICtrlStatusBarSetText($StatusBar1, "using Unicode characters", 1)
Else
	_GUICtrlStatusBarSetText($StatusBar1, "NOT using Unicode characters", 1)
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
Local $s_text = _GUICtrlStatusBarGetText($h_status)
Local $Unicode = _GUICtrlStatusBarGetUnicode($h_status)
If $Unicode Then
	_GUICtrlStatusBarSetUnicode($StatusBar1, False)
	If _GUICtrlStatusBarGetUnicode($h_status) Then
		_GUICtrlStatusBarSetText($h_status, "Was using Unicode characters, Not Now")
	Else
		_GUICtrlStatusBarSetText($h_status, "Couldn't turn off Unicode")
	EndIf
Else
	_GUICtrlStatusBarSetUnicode($StatusBar1)
	If Not _GUICtrlStatusBarGetUnicode($h_status) Then
		_GUICtrlStatusBarSetText($h_status, "Was NOT using Unicode characters, Is Now")
	Else
		_GUICtrlStatusBarSetText($h_status, "Couldn't turn on Unicode")
	EndIf
EndIf
Sleep(10000)
_GUICtrlStatusBarSetUnicode($StatusBar1, $Unicode)
_GUICtrlStatusBarSetText($h_status, $s_text)