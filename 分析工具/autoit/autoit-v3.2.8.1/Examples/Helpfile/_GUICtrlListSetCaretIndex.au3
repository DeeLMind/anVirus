#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $label, $button

GUICreate("ListBox Set Caret Index Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $LBS_MULTIPLESEL))
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|")
$button = GUICtrlCreateButton("Set Index", 150, 160, 120, 40)
$label = GUICtrlCreateLabel("Item #", 150, 210, 120)
$ret = _GUICtrlListGetCaretIndex ($listbox)
GUICtrlSetData($label, "Item : " & $ret)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSetCaretIndex ($listbox, 3, 1)
			$ret = _GUICtrlListGetCaretIndex ($listbox)
			GUICtrlSetData($label, "Item : " & $ret)
	EndSelect
WEnd
