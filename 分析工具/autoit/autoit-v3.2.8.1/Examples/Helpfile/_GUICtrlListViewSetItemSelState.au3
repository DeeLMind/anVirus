#include <GuiConstants.au3>
#include <GuiListView.au3>


opt('MustDeclareVars', 1)
Dim $listview, $Btn_Set, $Btn_Exit, $msg, $Status, $ret, $Btn_UnSet
GUICreate("ListView Set Item Sel State", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlCreateListViewItem("index 0|data1|more1", $listview)
GUICtrlCreateListViewItem("index 1|data2|more2", $listview)
GUICtrlCreateListViewItem("index 2|data3|more3", $listview)
GUICtrlCreateListViewItem("index 3|data4|more4", $listview)
GUICtrlCreateListViewItem("index 4|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 100)
$Btn_Set = GUICtrlCreateButton("Set Index 2 Selected", 150, 200, 120, 40)
$Btn_UnSet = GUICtrlCreateButton("UnSet Index 2 Selected", 150, 250, 120, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
_GUICtrlListViewSetItemSelState ($listview, -1)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Set
			_GUICtrlListViewSetItemSelState ($listview, 2)
		Case $msg = $Btn_UnSet
			_GUICtrlListViewSetItemSelState ($listview, 2, 0)
	EndSelect
WEnd
Exit
