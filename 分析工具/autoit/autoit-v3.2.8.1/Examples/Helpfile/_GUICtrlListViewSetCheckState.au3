#include <GuiConstants.au3>
#include <GuiListView.au3>

opt('MustDeclareVars', 1)
Dim $listview, $Btn_Set, $Btn_SetAll, $Btn_Exit, $msg, $Status, $ret
GUICreate("ListView Set Check State", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlCreateListViewItem("index 0|data1|more1", $listview)
GUICtrlCreateListViewItem("index 1|data2|more2", $listview)
GUICtrlCreateListViewItem("index 2|data3|more3", $listview)
GUICtrlCreateListViewItem("index 3|data4|more4", $listview)
GUICtrlCreateListViewItem("index 4|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 100)
$Btn_Set = GUICtrlCreateButton("Set Index 2", 150, 200, 90, 25)
$Btn_SetAll = GUICtrlCreateButton("Set All", 150, 230, 90, 25)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
Local $check = 1
Local $checkall = 1
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_SetAll
			Local $ret = _GUICtrlListViewSetCheckState($listview, -1, $checkall)
			$checkall = Not $checkall
			If ($ret == $LV_ERR) Then
				MsgBox(0, "Error", "Error setting Check state")
			EndIf
		Case $msg = $Btn_Set
			Local $ret = _GUICtrlListViewSetCheckState($listview, 2, $check)
			$check = Not $check
			If ($ret == $LV_ERR) Then
				MsgBox(0, "Error", "Error setting Check state")
			EndIf
	EndSelect
WEnd
Exit
