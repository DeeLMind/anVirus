#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $input, $listbox, $button

GUICreate("ListBox Add Item Demo", 400, 250, -1, -1)
GUICtrlCreateLabel("Enter item to add", 25, 15)
$input = GUICtrlCreateInput("", 125, 10, 180, 25)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120)
$button = GUICtrlCreateButton("Add to List", 150, 160, 120, 40)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			If (StringLen(GUICtrlRead($input)) > 0) Then
				$ret = _GUICtrlListAddItem ($listbox, GUICtrlRead($input))
				If ($ret < 0) Then
					If ($ret == $LB_ERRSPACE) Then
						MsgBox(16, "Error", "insufficient space to store the new strings from calling _GUICtrlListAddItem")
					ElseIf ($ret == $LB_ERR) Then
						MsgBox(16, "Error", "Unknown error from _GUICtrlListAddItem")
					EndIf
				EndIf
			EndIf
	EndSelect
WEnd
