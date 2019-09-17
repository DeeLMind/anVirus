#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt('MustDeclareVars', 1)
Dim $listview, $Btn_FindExact, $Btn_FindPartial, $Btn_FindByID, $Btn_Exit, $msg, $ret, $input_find, $index, $item[5]
GUICreate("ListView Find Item", 392, 322)

$listview = GUICtrlCreateListView("Fruit|Item Id", 40, 30, 310, 149, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_REPORT))
$item[0] = GUICtrlCreateListViewItem("orange|", $listview)
$item[1] = GUICtrlCreateListViewItem("apple|", $listview)
$item[2] = GUICtrlCreateListViewItem("lime|", $listview)
$item[3] = GUICtrlCreateListViewItem("tangerine|", $listview)
$item[4] = GUICtrlCreateListViewItem("banana|", $listview)
For $x = 0 To UBound($item) - 1
	_GUICtrlListViewSetItemText($listview, $x, 1, $item[$x])
Next
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
_GUICtrlListViewSetColumnWidth($listview, 0, 100)
$input_find = GUICtrlCreateInput("", 40, 200, 200, 20)
$Btn_FindPartial = GUICtrlCreateButton("Find (Partial)", 40, 230, 90, 30)
$Btn_FindExact = GUICtrlCreateButton("Find (Exact)", 145, 230, 90, 30)
$Btn_FindByID = GUICtrlCreateButton("Find by ID", 95, 270, 90, 30)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_FindPartial
			$index = _GUICtrlListViewFindItem ($listview, GUICtrlRead($input_find), -1, BitOR($LVFI_PARTIAL, $LVFI_WRAP))
			If $index = $LV_ERR Then
				MsgBox(0, "Find Partial", "Error")
			Else
				MsgBox(0, "Find Partial", "Index: " & $index)
			EndIf
		Case $msg = $Btn_FindExact
			$index = _GUICtrlListViewFindItem ($listview, GUICtrlRead($input_find), -1, BitOR($LVFI_STRING, $LVFI_WRAP))
			If $index = $LV_ERR Then
				MsgBox(0, "Find Exact", "Error")
			Else
				MsgBox(0, "Find Exact", "Index: " & $index)
			EndIf
		Case $msg = $Btn_FindByID
			$index = _GUICtrlListViewFindItem ($listview, GUICtrlRead($input_find), -1, BitOR($LVFI_PARAM, $LVFI_WRAP))
			If $index = $LV_ERR Then
				MsgBox(0, "Find by ID", "Error")
			Else
				MsgBox(0, "Find by ID", "Index: " & $index)
			EndIf
	EndSelect
WEnd
Exit