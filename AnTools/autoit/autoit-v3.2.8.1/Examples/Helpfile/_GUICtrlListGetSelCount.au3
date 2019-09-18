#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $button, $label

GUICreate("ListBox Selected Count Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $LBS_MULTIPLESEL))
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|")
$button = GUICtrlCreateButton("Get Sel Count", 150, 160, 120, 40)
$label = GUICtrlCreateLabel("# Selected: ", 150, 210, 120)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListGetSelCount ($listbox)
			If ($ret == $LB_ERR) Then
				MsgBox(16, "Error", "Unknown error from _GUICtrlListGetSelCount")
			Else
				GUICtrlSetData($label, "# Selected: " & $ret)
			EndIf
	EndSelect
WEnd
