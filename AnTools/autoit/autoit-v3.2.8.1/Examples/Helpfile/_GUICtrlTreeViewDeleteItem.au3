#include <GuiTreeView.au3>

opt("MustDeclareVars", 1)
opt("GUIDataSeparatorChar", "\")
Dim $h_GUI, $treeview, $nItem1, $nItem2, $nSubItem1, $nSubItem2, $nSubItem3, $nSubItem4
Dim $Btn_Delete, $Btn_DeleteItem, $Msg

$h_GUI = GUICreate("TreeView Delete Item", 392, 254)

$treeview = GUICtrlCreateTreeView(10, 10, 150, 150)
$nItem2 = GUICtrlCreateTreeViewItem("Item2", $treeview)
$nItem1 = GUICtrlCreateTreeViewItem("Item1", $treeview)
$nSubItem2 = GUICtrlCreateTreeViewItem("SubItem2", $nItem1)
$nSubItem1 = GUICtrlCreateTreeViewItem("SubItem1", $nItem1)
$nSubItem3 = GUICtrlCreateTreeViewItem("SubItem3", $nSubItem1)
$nSubItem4 = GUICtrlCreateTreeViewItem("SubItem4", $nSubItem3)

$Btn_Delete = GUICtrlCreateButton("Delete Selected", 70, 170, 90, 20)
$Btn_DeleteItem = GUICtrlCreateButton("Delete SubItem4", 70, 200, 90, 20)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $Msg = $Btn_Delete
			_GUICtrlTreeViewDeleteItem ($h_GUI, $treeview)
		Case $Msg = $Btn_DeleteItem
			_GUICtrlTreeViewDeleteItem ($h_GUI, $treeview, $nSubItem4)
	EndSelect
WEnd

Exit
