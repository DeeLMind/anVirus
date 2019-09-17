#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $Status, $msg, $Btn_GET, $a_sel

GUICreate("Edit Get Line Count", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 140, 32, 121, 97, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE))
GUICtrlSetLimit($myedit, 1500)
$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$Btn_GET = GUICtrlCreateButton("Get Sel", 150, 130, 90, 40, $BS_MULTILINE)

; will be append dont' forget 3rd parameter
GUICtrlSetData($myedit, "2nd line" & @CRLF & "3rd line" & @CRLF & "4th line" & @CRLF & _
		"5th line" & @CRLF & "6th line" & @CRLF & "7th line" & @CRLF & "8th line" & @CRLF & "9th line", 1)

GUISetState()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Btn_GET
			$a_sel = _GUICtrlEditGetSel ($myedit)
			If ($a_sel == $EC_ERR) Then
				GUICtrlSetData($Status, "Error getting sel positions")
			ElseIf (IsArray($a_sel)) Then
				GUICtrlSetData($Status, "Starting Pos: " & $a_sel[1] & " Ending Pos: " & $a_sel[2])
			Else
				GUICtrlSetData($Status, "")
			EndIf
	EndSelect
WEnd
