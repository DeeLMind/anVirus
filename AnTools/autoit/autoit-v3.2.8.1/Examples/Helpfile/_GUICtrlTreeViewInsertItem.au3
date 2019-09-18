#include <WindowsConstants.au3>
#include <GuiTreeView.au3>

Opt("MustDeclareVars", 1)

Dim $h_GUI, $Msg, $treeview
Dim $h_root1, $h_root2, $h_root3
Dim $n_btn_insert

$h_GUI = GUICreate("TreeView UDF Sample", 220, 250)

$treeview = GUICtrlCreateTreeView(10, 10, 200, 200, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetImage(-1, "shell32.dll", 3, 4)
GUICtrlSetImage(-1, "shell32.dll", 4, 2)

$h_root1 = _GUICtrlTreeViewInsertItem($treeview, "RootItem1")
_GUICtrlTreeViewInsertItem($treeview, "SubItem1", $h_root1)
_GUICtrlTreeViewInsertItem($treeview, "SubItem2", $h_root1)

$h_root2 = _GUICtrlTreeViewInsertItem($treeview, "RootItem2")

$h_root3 = _GUICtrlTreeViewInsertItem($treeview, "RootItem3")
_GUICtrlTreeViewInsertItem($treeview, "SubItem3", $h_root3)
_GUICtrlTreeViewInsertItem($treeview, "SubItem4", $h_root3)

$n_btn_insert	= GUICtrlCreateButton("Insert Items", 10, 220, 200, 20)

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
    	
		Case $n_btn_insert
			GUICtrlSetCursor($treeview, 1)
			For $i = 3 To 500
				_GUICtrlTreeViewInsertItem($treeview, "RootItem" & $i)
				ToolTip((500 - $i) & " items are created...")
			Next
			ToolTip("")
			GUICtrlSetCursor($treeview, 2)
	EndSwitch
WEnd

Exit
									