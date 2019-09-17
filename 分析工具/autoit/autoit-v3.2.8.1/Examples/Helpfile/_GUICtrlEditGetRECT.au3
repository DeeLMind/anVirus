#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $s_rect, $label_rect, $msg, $rect_array

GUICreate("Edit Get RECT", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 10, 32, 121, 97, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL))

$s_rect = "Left:" & @LF & "Top:" & @LF & "Right:" & @LF & "Bottom:"
$label_rect = GUICtrlCreateLabel($s_rect, 145, 50, 100, 55, $SS_SUNKEN)

GUISetState()
$rect_array = _GUICtrlEditGetRECT ($myedit)
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
	EndSelect
WEnd
