#include <GuiTreeView.au3>
#include <GuiStatusBar.au3>
opt("MustDeclareVars", 1)

Dim $tree, $item1, $subitem1, $subitem2, $item2, $subitem3, $subitem4, $button, $msg, $Status, $gui
$gui = GUICreate("GuiTreeView Get Parent ID", 392, 254)
$tree = GUICtrlCreateTreeView(10, 10, 200, 200)
$item1 = GUICtrlCreateTreeViewItem("Mainitem1", $tree)
$subitem1 = GUICtrlCreateTreeViewItem("Subitem11", $item1)
$subitem2 = GUICtrlCreateTreeViewItem("Subitem12", $item1)
$item2 = GUICtrlCreateTreeViewItem("Mainitem2", $tree)
$subitem3 = GUICtrlCreateTreeViewItem("Subitem21", $item2)
$subitem4 = GUICtrlCreateTreeViewItem("Subitem22", $item2)
$button = GUICtrlCreateButton("Check", 220, 100, 70, 20)
$Status = _GuiCtrlStatusBarCreate($gui, -1, "")
_GuiCtrlStatusBarSetSimple($Status)

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $button
			_GuiCtrlStatusBarSetText($Status, "Parent Text: " & GUICtrlRead(_GUICtrlTreeViewGetParentID ($tree), 1),255)
   EndSelect
WEnd
Exit
