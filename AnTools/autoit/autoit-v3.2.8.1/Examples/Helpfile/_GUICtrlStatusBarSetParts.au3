Opt("MustDeclareVars", 1)
#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

;================================================================
; Example 1 - Using AutoIt Control
;================================================================
_Main()

Func _Main()
	Local $a_PartsRightEdge[3] = [150, 300, -1]
	Local $a_PartsText[3] = ["New Text", "More Text", "Even More Text"]
	Local $a_PartsRightEdge2[2] = [100, -1]
	Local $gui, $input, $Button_1, $Button_2, $Button_3, $Button_4, $StatusBar1, $msg
	$gui = GUICreate("Status Bar - Parts", 500, -1, -1, -1, $WS_SIZEBOX)
	$input = GUICtrlCreateInput("", 10, 10, 120, 20, $ES_NUMBER)
	$Button_1 = GUICtrlCreateButton("<-- Create", 140, 10, 100)
	$Button_2 = GUICtrlCreateButton("3 Parts", 10, 40, 100, 20)
	$Button_3 = GUICtrlCreateButton("2 Parts", 10, 70, 100, 20)
	$Button_4 = GUICtrlCreateButton("3 Parts", 10, 100, 100, 20)
	$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)
	GUISetState(@SW_SHOW)
	_GUICtrlStatusBarSetParts($gui, $StatusBar1, $a_PartsRightEdge2) ; force an error, param 2 can not be an array
	If @error Then _GUICtrlStatusBarSetText($StatusBar1, "Error: " & @error, 0)

	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_RESIZED
				_GUICtrlStatusBarResize($StatusBar1)
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Button_1
				If StringLen(GUICtrlRead($input)) Then _GUICtrlStatusBarSetParts($gui, $StatusBar1, Number(GUICtrlRead($input)))
			Case $msg = $Button_2
				_GUICtrlStatusBarSetParts($gui, $StatusBar1, 3, $a_PartsRightEdge)
			Case $msg = $Button_3
				_GUICtrlStatusBarSetParts($gui, $StatusBar1, 5, $a_PartsRightEdge2) ; number of parts is larger than array, parts = size of array
			Case $msg = $Button_4
				_GUICtrlStatusBarSetParts($gui, $StatusBar1, -1, $a_PartsRightEdge) ; number of parts is smaller than array, parts = size of array
		EndSelect
	WEnd
	GUIDelete()
EndFunc   ;==>_Main

;================================================================
; Example 2 - External Control
;================================================================
_External()

Func _External()
	Opt("WinTitleMatchMode", 4)
	Local $h_win = WinGetHandle("classname=SciTEWindow")
	Local $h_status = ControlGetHandle($h_win, "", "msctls_statusbar321")
	_GUICtrlStatusBarSetParts($h_win, $h_status, 3)
	Sleep(10000)
	_GUICtrlStatusBarSetParts($h_win, $h_status, 1)
EndFunc   ;==>_External