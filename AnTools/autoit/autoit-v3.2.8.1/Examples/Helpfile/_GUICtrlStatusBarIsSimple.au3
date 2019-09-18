Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

Local $gui, $StatusBar1, $msg, $button
Local $a_PartsRightEdge[3] = [100, 350, -1]
Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
$gui = GUICreate("Status Bar Is Simple", 500, -1, -1, -1, $WS_SIZEBOX)
$button = GUICtrlCreateButton("Toggle", 10, 10, 90, 25)
$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)

GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_RESIZED
			_GUICtrlStatusBarResize($StatusBar1)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			If _GUICtrlStatusBarIsSimple($StatusBar1) Then
				_GUICtrlStatusBarSetSimple($StatusBar1, False)
			Else
				_GUICtrlStatusBarSetSimple($StatusBar1)
				_GUICtrlStatusBarSetText($StatusBar1, "simple mode", $SB_SIMPLEID)
				_GUICtrlStatusBarResize($StatusBar1)
			EndIf
	EndSelect
	
WEnd
GUIDelete()

;================================================================
; Example 2 - External Control
;================================================================
Opt("WinTitleMatchMode", 4)
Local $h_win = WinGetHandle("classname=SciTEWindow")
Local $h_status = ControlGetHandle($h_win, "", "msctls_statusbar321")
If _GUICtrlStatusBarIsSimple($h_status) Then
	ConsoleWrite("simple mode" & @LF)
Else
	ConsoleWrite("NOT simple mode" & @LF)
EndIf