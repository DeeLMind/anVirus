#include <WindowsConstants.au3>
#include <GuiTreeView.au3>
#include <GuiStatusBar.au3>

opt("MustDeclareVars", 1)

Global Const $Turquoise = 0x40e0d0
Global Const $Crimson = 0xDC143C
Global Const $White = 0xFFFFFF

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
$Status = _GuiCtrlStatusBarCreate($hGUI, -1, "")
_GuiCtrlStatusBarSetSimple($Status)

_GUICtrlTreeViewSetBkColor($treeview, $Turquoise)
_GUICtrlTreeViewSetTextColor($treeview, $Crimson)
_GUICtrlTreeViewSetLineColor($treeview, $White)
_GUICtrlTreeViewSetIndent($treeview, 30)

GUISetState()

While 1
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $nMsg = $nButton
			_GuiCtrlStatusBarSetText($Status,"Path: " & _GUICtrlTreeViewGetTree($treeview, "\"),255)
	EndSelect
WEnd

Exit
