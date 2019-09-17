#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars',1)

Dim $msg, $ret,$listbox,$button

GUICreate("ListBox Swap String Demo",400,250,-1,-1)

$listbox = GUICtrlCreateList("",125,40,180,120,BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY,$LBS_MULTIPLESEL))
GUICtrlSetData($listbox,"test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton('Swap Strings on Indexes 3,5',140,160,150,40)

GUISetState ()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSwapString($listbox,3,5)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSwapString")
			EndIf
	EndSelect
Wend
