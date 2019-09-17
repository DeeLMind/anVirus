#include <GUIConstants.au3>
#include <GuiTreeView.au3>

opt("MustDeclareVars", 1)

If Not IsDeclared('Turquoise') Then Dim $Turquoise = 0x40e0d0
If Not IsDeclared('Crimson') Then Dim $Crimson = 0xDC143C
If Not IsDeclared('White') Then Dim $White = 0xFFFFFF

Dim $hGUI, $treeview, $nItem1, $nItem2, $nItem3
Dim $nSubItem1, $nSubItem2, $nSubItem3, $nSubItem4
Dim $nButton, $Status, $nMsg

$hGUI = GUICreate("TreeView Item Get Tree", 392, 254)

$treeview = GUICtrlCreateTreeView(10, 10, 150, 150)
$nItem2 = GUICtrlCreateTreeViewItem("Item2", $treeview)
$nItem1 = GUICtrlCreateTreeViewItem("Item1", $treeview)
$nSubItem2 = GUICtrlCreateTreeViewItem("SubItem2", $nItem1)
$nSubItem1 = GUICtrlCreateTreeViewItem("SubItem1", $nItem1)
$nSubItem4 = GUICtrlCreateTreeViewItem("SubItem4", $nSubItem1)
$nSubItem3 = GUICtrlCreateTreeViewItem("SubItem3", $nSubItem1)

$nButton = GUICtrlCreateButton("Path?", 70, 170, 70, 20)
$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

_GUICtrlTreeViewSetBkColor ($treeview, $Turquoise)
_GUICtrlTreeViewSetTextColor ($treeview, $Crimson)
_GUICtrlTreeViewSetLineColor ($treeview, $White)
_GUICtrlTreeViewSetIndent ($treeview, 30)

GUISetState()

While 1
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $nMsg = $nButton
			GUICtrlSetData($Status, "Path: " & _GUICtrlTreeViewItemGetTree ($hGUI, $treeview, "\"))
	EndSelect
WEnd

Exit
