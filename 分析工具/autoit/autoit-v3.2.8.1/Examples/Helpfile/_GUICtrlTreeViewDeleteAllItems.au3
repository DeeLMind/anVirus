#include <GuiTreeView.au3>

opt("MustDeclareVars", 1)
opt("GUIDataSeparatorChar", "\")
Dim $h_GUI, $treeview, $nItem1, $nItem2, $nSubItem1, $nSubItem2, $nSubItem3, $nSubItem4, $Btn_DeleteAll, $Msg

$h_GUI = GUICreate("TreeView Delete All Items", 392, 254)

$treeview = GUICtrlCreateTreeView(10, 10, 150, 150)
$nItem2 = GUICtrlCreateTreeViewItem("Item2", $treeview)
$nItem1 = GUICtrlCreateTreeViewItem("Item1", $treeview)
$nSubItem2 = GUICtrlCreateTreeViewItem("SubItem2", $nItem1)
$nSubItem1 = GUICtrlCreateTreeViewItem("SubItem1", $nItem1)
$nSubItem4 = GUICtrlCreateTreeViewItem("SubItem4", $nSubItem1)
$nSubItem3 = GUICtrlCreateTreeViewItem("SubItem3", $nSubItem1)

$Btn_DeleteAll = GUICtrlCreateButton("Delete All", 70, 170, 70, 20)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $Msg = $Btn_DeleteAll
			_GUICtrlTreeViewDeleteAllItems ($treeview)
	EndSelect
WEnd

Exit
