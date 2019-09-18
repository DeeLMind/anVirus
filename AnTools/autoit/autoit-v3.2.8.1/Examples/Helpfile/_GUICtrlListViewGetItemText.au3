#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt('MustDeclareVars', 1)
Dim $listview, $Btn_Get, $Btn_GetSelected, $Btn_Exit, $msg, $Status, $ret

;================================================================
; Example 1 - Get Text from AutoIt Control
;================================================================
GUICreate("ListView Get Item Text AutoIt Created Control", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
$Btn_Get = GUICtrlCreateButton("Get From Index 2", 75, 200, 90, 40)
$Btn_GetSelected = GUICtrlCreateButton("Get Selected", 200, 200, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Get
			GUICtrlSetData($Status, "")
			MsgBox(0, "Passed Item Index only", _GUICtrlListViewGetItemText($listview, 2))
			MsgBox(0, "Passed Item Index, SubItem 0", _GUICtrlListViewGetItemText($listview, 2, 0))
		Case $msg = $Btn_GetSelected
			GUICtrlSetData($Status, "")
			$ret = _GUICtrlListViewGetItemText($listview, _GUICtrlListViewGetSelectedIndices($listview))
			If ($ret <> $LV_ERR) Then
				MsgBox(0, "Selected Item", $ret)
				$ret = _GUICtrlListViewGetItemText($listview, _GUICtrlListViewGetSelectedIndices($listview), 0)
				If ($ret <> $LV_ERR) Then
					MsgBox(0, "Selected Item, SubItem 0", $ret)
				EndIf
			Else
				GUICtrlSetData($Status, "Nothing Selected")
			EndIf
	EndSelect
WEnd
GUIDelete()


;================================================================
; Example 2 - Get Text from System Control
;================================================================
Dim $h_desktop = ControlGetHandle("Program Manager", "FolderView", 1)
GUICreate("ListView Get Item Text From System Control", 392, 322)

$listview = GUICtrlCreateListView("Items on DeskTop", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
For $x = 0 To _GUICtrlListViewGetItemCount($h_desktop) - 1
	GUICtrlCreateListViewItem(_GUICtrlListViewGetItemText($h_desktop, $x, 0), $listview)
Next
_GUICtrlListViewSetColumnWidth($listview,0,$LVSCW_AUTOSIZE)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
	EndSelect
WEnd
GUIDelete()