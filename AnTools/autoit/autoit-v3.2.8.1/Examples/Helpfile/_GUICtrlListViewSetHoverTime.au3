#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_SetHoverTime, $Btn_Exit, $msg, $Input, $Status, $ret, $current
GUICreate("ListView Sets Hover Time", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
GUICtrlCreateLabel("Enter Hover Time:", 90, 190, 130, 20)
$Input = GUICtrlCreateInput("", 220, 190, 80, 20, $ES_NUMBER)
GUICtrlSetLimit($Input, 3)
$Btn_SetHoverTime = GUICtrlCreateButton("Set Hover Time", 75, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$current = _GUICtrlListViewGetHoverTime ($listview)
$Status = GUICtrlCreateLabel("Hover Time:" & $current, 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	If ($current <> _GUICtrlListViewGetHoverTime ($listview)) Then
		GUICtrlSetData($Status, "Hover Time:" & _GUICtrlListViewGetHoverTime ($listview))
		$current = _GUICtrlListViewGetHoverTime ($listview)
	EndIf
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_SetHoverTime
			If (StringLen(GUICtrlRead($Input)) > 0) Then
				$ret = _GUICtrlListViewSetHoverTime ($listview, Int(GUICtrlRead($Input)))
			EndIf
	EndSelect
WEnd
Exit
