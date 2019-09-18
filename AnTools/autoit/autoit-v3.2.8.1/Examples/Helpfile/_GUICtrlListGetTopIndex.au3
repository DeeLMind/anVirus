#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $button, $label, $i

GUICreate("ListBox Get Top Index Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120)
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|")
$button = GUICtrlCreateButton("Get Top Index", 150, 160, 120, 40)
$label = GUICtrlCreateLabel("Top Index:", 150, 210, 120)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListGetTopIndex ($listbox)
			If ($ret == $LB_ERR) Then
				MsgBox(16, "Error", "Unknown error from _GUICtrlListGetTopIndex")
			Else
				GUICtrlSetData($label, "Top Index: " & $ret)
			EndIf
	EndSelect
WEnd
