#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars',1)

Dim $msg, $ret
Dim $listbox,$button,$i

GUICreate("ListBox Set Top Index Demo",400,250,-1,-1)

$listbox = GUICtrlCreateList("",125,40,180,120)
GUICtrlSetData($listbox,"test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton("Set Top Index to 4",150,160,120,40)

GUISetState ()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSetTopIndex($listbox,4)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSetTopIndex")
			EndIf
	EndSelect
Wend
