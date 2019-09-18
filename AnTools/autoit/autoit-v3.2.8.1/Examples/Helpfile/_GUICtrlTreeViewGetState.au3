#include <WindowsConstants.au3>
#include <GuiTreeView.au3>

Opt("MustDeclareVars", 1)
Opt("GUIDataSeparatorChar", "\")

Dim $h_GUI, $Msg, $treeview
Dim $h_root1, $h_root2, $h_root3, $h_tmp
Dim $n_btn_getstate

$h_GUI = GUICreate("TreeView UDF Sample", 220, 250)

$treeview = GUICtrlCreateTreeView(10, 10, 200, 200, -1, $WS_EX_CLIENTEDGE)
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

$n_btn_getstate = GUICtrlCreateButton("Get RootItem2 State", 10, 220, 200, 20)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
    	
		Case $n_btn_getstate
			Msgbox(0, "State", _GUICtrlTreeViewGetState($treeview, $h_root2))
	EndSwitch
WEnd

Exit
									