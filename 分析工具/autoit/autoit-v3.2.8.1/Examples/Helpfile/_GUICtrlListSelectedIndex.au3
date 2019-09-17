#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $label

GUICreate("ListBox Current Selection Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120)
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|")
$label = GUICtrlCreateLabel("Item #", 150, 210, 120)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $listbox
			$ret = _GUICtrlListSelectedIndex ($listbox)
			If ($ret == $LB_ERR) Then
				MsgBox(16, "Error", "Unknown error from _GUICtrlListSelectedIndex")
			Else
				GUICtrlSetData($label, "Item #: " & $ret)
			EndIf
	EndSelect
WEnd
