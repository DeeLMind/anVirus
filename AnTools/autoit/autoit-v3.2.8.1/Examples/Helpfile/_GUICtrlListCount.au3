#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $button, $label

GUICreate("ListBox Count Item(s) Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120)
GUICtrlSetData($listbox, "test1|test2|test3|")
$button = GUICtrlCreateButton("Count Items", 150, 160, 120, 40)
$label = GUICtrlCreateLabel("# of Items", 150, 210, 120)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListCount ($listbox)
			If ($ret == $LB_ERR) Then
				MsgBox(16, "Error", "Unknown error from _GUICtrlListCount")
			Else
				GUICtrlSetData($label, "# of Items: " & $ret)
			EndIf
	EndSelect
WEnd
