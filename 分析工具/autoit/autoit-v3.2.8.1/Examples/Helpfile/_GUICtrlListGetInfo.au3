#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $listbox, $label

GUICreate("ListBox Get Info", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 100, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY))
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|")
$label = GUICtrlCreateLabel("Info: " & _GUICtrlListGetInfo ($listbox), 150, 210, 120)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd
