#include <GuiTreeView.au3>

opt("MustDeclareVars", 1)
Dim $h_GUI, $treeview, $nItem1, $nItem2, $nItem3
Dim $nSubItem1, $nSubItem2, $nSubItem3, $nSubItem4, $nSubItem5, $nSubItem6, $nSubItem7
Dim $Btn_Sort, $Msg

$h_GUI = GUICreate("TreeView Sort", 392, 254)

$treeview = GUICtrlCreateTreeView(10, 10, 200, 150)
$nItem2 = GUICtrlCreateTreeViewItem("Item2", $treeview)
$nItem1 = GUICtrlCreateTreeViewItem("Item1", $treeview)
$nItem3 = GUICtrlCreateTreeViewItem("Item3", $treeview)
$nSubItem2 = GUICtrlCreateTreeViewItem("SubItem2", $nItem1)
$nSubItem1 = GUICtrlCreateTreeViewItem("SubItem1", $nItem1)
$nSubItem4 = GUICtrlCreateTreeViewItem("SubItem4", $nSubItem1)
$nSubItem5 = GUICtrlCreateTreeViewItem("SubItem5", $nSubItem4)
$nSubItem6 = GUICtrlCreateTreeViewItem("SubItem6", $nSubItem5)
$nSubItem3 = GUICtrlCreateTreeViewItem("SubItem3", $nSubItem1)
$nSubItem7 = GUICtrlCreateTreeViewItem("SubItem7", $nItem3)

$Btn_Sort = GUICtrlCreateButton("Sort", 70, 170, 90, 20)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $Msg = $Btn_Sort
			_GUICtrlTreeViewSort ($treeview)
	EndSelect
WEnd

Exit
