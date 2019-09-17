#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars',1)

Dim $msg, $ret
Dim $listbox,$button,$i,$button2,$button3

GUICreate("ListBox Set Selection(s) Demo",400,250,-1,-1)

$listbox = GUICtrlCreateList("",125,40,180,120,BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY,$LBS_MULTIPLESEL))
GUICtrlSetData($listbox,"test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton("Toggle All",85,160,120,40)
$button2 = GUICtrlCreateButton("Set index 3",215,160,120,40)
$button3 = GUICtrlCreateButton("Toggle index 3",150,210,120,40)

GUISetState ()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSetSel($listbox)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSetSel")
			EndIf
		Case $msg = $button2
			$ret = _GUICtrlListSetSel($listbox,1,3)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSetSel")
			EndIf
		Case $msg = $button3
			$ret = _GUICtrlListSetSel($listbox,-1,3)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSetSel")
			EndIf
	EndSelect
Wend
