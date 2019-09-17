#include <GUIConstants.au3>
#include <GuiEdit.au3>

Opt('MustDeclareVars', 1)


Dim $myedit, $Status, $msg, $s_rect, $label_rect, $rect_array, $btn_set

GUICreate("Edit Set Rect", 392, 254)
$myedit = GUICtrlCreateEdit("AutoIt v3 is a freeware BASIC-like scripting language designed for automating the Windows GUI. It uses a combination of simulated keystrokes, mouse movement and window/control manipulation" & @CRLF, 10, 32, 171, 97, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE))
GUICtrlSetLimit($myedit, 1500)
$label_rect = GUICtrlCreateLabel($s_rect, 195, 50, 100, 55, $SS_SUNKEN)
$btn_set = GUICtrlCreateButton("Set", 150, 150, 90, 40)
GUISetState()
$rect_array = _GUICtrlEditGetRECT($myedit)
If ($rect_array == $EC_ERR) Then
	MsgBox(0, "Error", "Unable to Get RECT")
ElseIf (IsArray($rect_array)) Then
	$s_rect = "Left:" & $rect_array[1] & @LF & "Top:" & $rect_array[2] & @LF & "Right:" & $rect_array[3] & @LF & "Bottom:" & $rect_array[4]
	GUICtrlSetData($label_rect, $s_rect)
EndIf

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $btn_set
			_GUICtrlEditSetRect($myedit, 0, 0, 80, $rect_array[4])
			$rect_array = _GUICtrlEditGetRECT($myedit)
			If ($rect_array == $EC_ERR) Then
				MsgBox(0, "Error", "Unable to Get RECT")
			ElseIf (IsArray($rect_array)) Then
				$s_rect = "Left:" & $rect_array[1] & @LF & "Top:" & $rect_array[2] & @LF & "Right:" & $rect_array[3] & @LF & "Bottom:" & $rect_array[4]
				GUICtrlSetData($label_rect, $s_rect)
			EndIf
	EndSelect
WEnd
