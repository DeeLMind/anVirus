#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $Status
GUICreate("ListView Get Counter Page", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 260, 70, 30)
$Status = GUICtrlCreateLabel("Possible Fully Visible Rows: " & _GUICtrlListViewGetCounterPage ($listview), 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
Exit
