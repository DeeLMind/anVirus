#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret, $listbox, $button

GUICreate("ListBox Text Len Demo", 400, 250, -1, -1)
GUICtrlCreateLabel("Select from list", 125, 10)
$listbox = GUICtrlCreateList("", 125, 40, 180, 120)
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton('Exit', 150, 160, 120, 40)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
			ExitLoop
		Case $msg = $listbox
			$ret = _GUICtrlListGetTextLen ($listbox, _GUICtrlListSelectedIndex ($listbox))
			If ($ret == $LB_ERR) Then
				MsgBox(16, "Error", "Unknown error from _GUICtrlListGetTextLen")
			Else
				MsgBox(0, "Text", "Length: " & $ret)
			EndIf
	EndSelect
WEnd
