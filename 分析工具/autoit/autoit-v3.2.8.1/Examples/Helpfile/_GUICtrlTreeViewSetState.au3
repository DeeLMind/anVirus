#include <GUIConstants.au3>
#include <GuiTreeView.au3>

Opt("MustDeclareVars", 1)

Dim $h_GUI, $Msg, $treeview, $h_search, $s_file, $h_item

$h_GUI = GUICreate("TreeView UDF Sample", 220, 220)

$treeview = GUICtrlCreateTreeView(10, 10, 200, 200, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetImage(-1, "shell32.dll", 3, 4)
GUICtrlSetImage(-1, "shell32.dll", 4, 2)

GUISetState()

$h_search = FileFindFirstFile("C:\*.*")
If $h_search <> -1 Then
	While 1
		$s_file = FileFindNextFile($h_search)
		If @error Then ExitLoop
		If Not StringInStr(FileGetAttrib("C:\" & $s_file), "D") Then ContinueLoop
		$h_item = _GUICtrlTreeViewInsertItem($treeview, $s_file)
		_GUICtrlTreeViewSetState($treeview, $h_item, $TVIS_BOLD) ; bold all items
		If StringInStr(FileGetAttrib("C:\" & $s_file), "H") Then _
			_GUICtrlTreeViewSetState($treeview, $h_item, $TVIS_CUT, $TVIS_BOLD) ; set to appear as hidden, remove bold state
	WEnd
EndIf

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
	EndSwitch
WEnd

Exit
