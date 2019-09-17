#include <GuiConstants.au3>
#include <GuiListView.au3>


opt('MustDeclareVars', 1)
Dim $listview, $Btn_SetItem0, $Btn_Exit, $msg, $Status, $ret, $Btn_SetSub1
GUICreate("ListView Set Item Text", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlCreateListViewItem("index 0|data1|more1", $listview)
GUICtrlCreateListViewItem("index 1|data2|more2", $listview)
GUICtrlCreateListViewItem("index 2|data3|more3", $listview)
GUICtrlCreateListViewItem("index 3|data4|more4", $listview)
GUICtrlCreateListViewItem("index 4|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 100)
$Btn_SetItem0 = GUICtrlCreateButton("Set 2 Item", 150, 200, 120, 40)
$Btn_SetSub1 = GUICtrlCreateButton("Set 2 SubItem", 150, 250, 120, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_SetItem0
			_GUICtrlListViewSetItemText ($listview, 2, 0, "Testing")
		Case $msg = $Btn_SetSub1
			_GUICtrlListViewSetItemText ($listview, 2, 1, "Sub")
	EndSelect
WEnd
Exit
