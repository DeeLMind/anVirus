#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $i, $Styles, $Btn_visible, $i
GUICreate("ListView Ensure Visible", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 144)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
For $i = 1 To 20
	GUICtrlCreateListViewItem("line" & $i & "|data" & $i & "|more" & $i, $listview)
Next
$Btn_visible = GUICtrlCreateButton("Set Visible", 150, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_visible
			_GUICtrlListViewEnsureVisible($listview, 12, 1)
	EndSelect
WEnd
Exit
