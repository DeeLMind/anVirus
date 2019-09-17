#include <WindowsConstants.au3>
#include <GuiTreeView.au3>
#include <GuiStatusBar.au3>

Opt("MustDeclareVars", 1)

Dim $h_GUI, $Msg, $treeview
Dim $h_root1, $h_root2, $h_root3, $h_item
Dim $n_btn_gettext, $Status

$h_GUI = GUICreate("TreeView UDF Sample", 220, 250)

$treeview = GUICtrlCreateTreeView(10, 10, 200, 180, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetImage(-1, "shell32.dll", 3, 4)
GUICtrlSetImage(-1, "shell32.dll", 4, 2)

$h_root1 = _GUICtrlTreeViewInsertItem($treeview, "RootItem1")
_GUICtrlTreeViewSetIcon($treeview, $h_root1, "shell32.dll", 7)

_GUICtrlTreeViewInsertItem($treeview, "SubItem1", $h_root1)
_GUICtrlTreeViewInsertItem($treeview, "SubItem2", $h_root1)

$h_root2 = _GUICtrlTreeViewInsertItem($treeview, "RootItem2")
_GUICtrlTreeViewSetIcon($treeview, $h_root2, "shell32.dll", 12)

$h_root3 = _GUICtrlTreeViewInsertItem($treeview, "RootItem3")
_GUICtrlTreeViewInsertItem($treeview, "SubItem3", $h_root3)
_GUICtrlTreeViewInsertItem($treeview, "SubItem4", $h_root3)

$n_btn_gettext	= GUICtrlCreateButton("Get text", 10, 200, 200, 20)

$Status = _GuiCtrlStatusBarCreate($h_GUI, -1, "")
_GuiCtrlStatusBarSetSimple($Status)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		
		Case $n_btn_gettext
			$h_item = GUICtrlSendMsg($treeview, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
			If $h_item > 0 Then _GuiCtrlStatusBarSetText($Status,"Get Text: " & _GUICtrlTreeViewGetText($treeview, $h_item),255)
	EndSwitch
WEnd

Exit
									