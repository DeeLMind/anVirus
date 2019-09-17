#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars',1)

Dim $msg, $ret,$listbox,$button,$i_sel=1

GUICreate("ListBox Set Item Range Demo",400,250,-1,-1)

$listbox = GUICtrlCreateList("",125,40,180,120,BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY,$LBS_MULTIPLESEL))
GUICtrlSetData($listbox,"test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton("Set/UnSet Items 1 - 5",150,160,120,40)

GUISetState ()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSelItemRange($listbox,$i_sel,1,5)
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSelItemRange")
			EndIf
			$i_sel = Not $i_sel
	EndSelect
Wend
