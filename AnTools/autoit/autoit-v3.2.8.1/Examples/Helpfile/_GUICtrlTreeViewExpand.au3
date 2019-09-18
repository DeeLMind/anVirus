#include <GuiTreeView.au3>

opt("MustDeclareVars", 1)
opt("GUIDataSeparatorChar", "\")
Dim $h_GUI, $treeview, $nItem1, $nItem2, $nItem3
Dim $nSubItem1, $nSubItem2, $nSubItem3, $nSubItem4, $nSubItem5, $nSubItem6, $nSubItem7
Dim $Btn_Expand, $Btn_ExpandItem, $Msg, $Btn_Collapse, $Btn_CollapseItem

$h_GUI = GUICreate("TreeView Expand", 392, 254)

$treeview = GUICtrlCreateTreeView(10, 10, 150, 150)
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

$Btn_Expand = GUICtrlCreateButton("Expand All", 70, 170, 90, 20)
$Btn_Collapse = GUICtrlCreateButton("Collapse All", 200, 170, 90, 20)
$Btn_ExpandItem = GUICtrlCreateButton("Expand Item1", 70, 200, 90, 20)
$Btn_CollapseItem = GUICtrlCreateButton("Collapse Item1", 200, 200, 90, 20)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $Msg = $Btn_Expand
			_GUICtrlTreeViewExpand($treeview)
		Case $Msg = $Btn_ExpandItem
			_GUICtrlTreeViewExpand($treeview, 1, $nItem1)
		Case $Msg = $Btn_Collapse
			_GUICtrlTreeViewExpand($treeview, 0)
		Case $Msg = $Btn_CollapseItem
			_GUICtrlTreeViewExpand($treeview, 0, $nItem1)
	EndSelect
WEnd

Exit
