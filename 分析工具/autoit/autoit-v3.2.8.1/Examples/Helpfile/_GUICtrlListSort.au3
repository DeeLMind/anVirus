#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars',1)

Dim $msg, $ret,$listbox,$button

GUICreate("ListBox Sort Demo",400,250,-1,-1)

$listbox = GUICtrlCreateList("",125,40,180,120,BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY,$LBS_MULTIPLESEL))
GUICtrlSetData($listbox,"test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton('Sort',150,160,120,40)

GUISetState ()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSort($listbox)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListBoxSort")
			EndIf
	EndSelect
Wend
