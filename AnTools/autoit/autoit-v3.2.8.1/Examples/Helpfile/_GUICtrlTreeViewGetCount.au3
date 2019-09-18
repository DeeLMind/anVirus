#include <WindowsConstants.au3>
#include <GuiTreeView.au3>
#include <GuiStatusBar.au3>

opt("MustDeclareVars", 1)

Dim $myGui, $treeview, $generalitem, $displayitem, $aboutitem
Dim $compitem, $useritem, $resitem, $otheritem, $Status, $startlabel, $aboutlabel
Dim $compinfo, $msg, $cancelbutton

Global Const $Turquoise = 0x40e0d0
Global Const $Crimson = 0xDC143C
Global Const $White = 0xFFFFFF

$myGui = GUICreate("TreeView Get Count", 392, 254)

$treeview = GUICtrlCreateTreeView(6, 6, 100, 150, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
$generalitem = GUICtrlCreateTreeViewItem("General", $treeview)
$displayitem = GUICtrlCreateTreeViewItem("Display", $treeview)
$aboutitem = GUICtrlCreateTreeViewItem("About", $generalitem)
$compitem = GUICtrlCreateTreeViewItem("Computer", $generalitem)
$useritem = GUICtrlCreateTreeViewItem("User", $generalitem)
$resitem = GUICtrlCreateTreeViewItem("Resolution", $displayitem)
$otheritem = GUICtrlCreateTreeViewItem("Other", $displayitem)
$Status = _GuiCtrlStatusBarCreate($myGui, -1, "")
_GuiCtrlStatusBarSetSimple($Status)

$startlabel = GUICtrlCreateLabel("TreeView Demo", 190, 90, 100, 20)
$aboutlabel = GUICtrlCreateLabel("This little scripts demonstates the using of a treeview-control.", 190, 70, 100, 60)
GUICtrlSetState(-1, $GUI_HIDE)
$compinfo = GUICtrlCreateLabel("Name:" & @TAB & @ComputerName & @LF & "OS:" & @TAB & @OSVersion & @LF & "SP:" & @TAB & @OSServicePack, 120, 30, 200, 80)
GUICtrlSetState(-1, $GUI_HIDE)

$cancelbutton = GUICtrlCreateButton("Cancel", 180, 185, 70, 20)

_GUICtrlTreeViewSetBkColor ($treeview, $Turquoise)
_GUICtrlTreeViewSetTextColor ($treeview, $Crimson)
_GUICtrlTreeViewSetLineColor ($treeview, $White)

GUISetState()
_GuiCtrlStatusBarSetText($Status,"Number Of Items: " & _GUICtrlTreeViewGetCount ($treeview),255)
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $cancelbutton Or $msg = $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $msg = $generalitem
			GUIChangeItems($aboutlabel, $compinfo, $startlabel, $startlabel)
			
		Case $msg = $aboutitem
			GUICtrlSetState($compinfo, $GUI_HIDE)
			GUIChangeItems($startlabel, $startlabel, $aboutlabel, $aboutlabel)
			
		Case $msg = $compitem
			GUIChangeItems($startlabel, $aboutlabel, $compinfo, $compinfo)
			
	EndSelect
WEnd

GUIDelete()
Exit

Func GUIChangeItems($hidestart, $hideend, $showstart, $showend)
	Local $idx
	
	For $idx = $hidestart To $hideend
		GUICtrlSetState($idx, $GUI_HIDE)
	Next
	For $idx = $showstart To $showend
		GUICtrlSetState($idx, $GUI_SHOW)
	Next
EndFunc   ;==>GUIChangeItems
