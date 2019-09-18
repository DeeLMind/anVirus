#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $button, $label, $i

GUICreate("ListBox Selected Items Text Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $LBS_MULTIPLESEL))
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|")
$button = GUICtrlCreateButton("Get Selected", 150, 160, 120, 40)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListGetSelItemsText ($listbox)
			If (Not IsArray($ret)) Then
				MsgBox(16, "Error", "Unknown error from _GUICtrlListGetSelItemsText")
			Else
				For $i = 1 To $ret[0]
					MsgBox(0, "Selected", $ret[$i])
				Next
			EndIf
	EndSelect
WEnd
