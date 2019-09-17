#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ("GUIOnEventMode", 1)
Opt ('MustDeclareVars', 1)

Dim $listview, $listview2, $Btn_MoveLeft, $Btn_MoveRight, $Btn_Exit1, $Btn_Exit2, $msg, $GUI1, $GUI2
Dim $Btn_CopyRight, $Btn_CopyLeft
Dim $OptionsMenu, $OptionsItem1, $OptionsItem2, $separator1, $OptionsItem3, $OptionsItem4
Dim $Dock = 1, $Dock_Location = 1, $x1, $x2, $y1, $y2

$GUI1 = GUICreate("GuiListView Copy Items", 300, 220, 10, 10)
$OptionsMenu = GUICtrlCreateMenu("Options")
$OptionsItem1 = GUICtrlCreateMenu("Docking", $OptionsMenu)

$OptionsItem2 = GUICtrlCreateMenuItem("Docked", $OptionsItem1)
$separator1 = GUICtrlCreateMenuItem("", $OptionsItem1)
$OptionsItem3 = GUICtrlCreateMenuItem("Side By Side", $OptionsItem1)
$OptionsItem4 = GUICtrlCreateMenuItem("Top And Bottom", $OptionsItem1)
GUICtrlSetState($OptionsItem2, $GUI_CHECKED)
GUICtrlSetState($OptionsItem3, $GUI_CHECKED)
GUICtrlSetOnEvent($OptionsItem2, "_SetDocking")
GUICtrlSetOnEvent($OptionsItem3, "_SetDockSideBySide")
GUICtrlSetOnEvent($OptionsItem4, "_SetDockTopAndBottom")

GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

$listview = GUICtrlCreateListView("col1|col2|col3", 5, 5, 150, 185, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_REPORT))
_GUICtrlListViewSetColumnWidth ($listview, 0, 60)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)

$Btn_MoveRight = GUICtrlCreateButton("Move", 175, 35, 90, 20)
GUICtrlSetOnEvent($Btn_MoveRight, "_MoveRight")

$Btn_CopyRight = GUICtrlCreateButton("Copy", 175, 60, 90, 20)
GUICtrlSetOnEvent($Btn_CopyRight, "_CopyRight")

$Btn_Exit1 = GUICtrlCreateButton("Exit", 175, 140, 90, 25)
GUICtrlSetOnEvent($Btn_Exit1, "_Exit")

$GUI2 = GUICreate("Right/Bottom Window", 300, 220, 315, 10)

GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

$Btn_MoveLeft = GUICtrlCreateButton("Move", 175, 55, 90, 20)
GUICtrlSetOnEvent($Btn_MoveLeft, "_MoveLeft")

$Btn_CopyLeft = GUICtrlCreateButton("Copy", 175, 80, 90, 20)
GUICtrlSetOnEvent($Btn_CopyLeft, "_CopyLeft")

$Btn_Exit2 = GUICtrlCreateButton("Exit", 175, 160, 90, 25)
GUICtrlSetOnEvent($Btn_Exit2, "_Exit")

$listview2 = GUICtrlCreateListView("col1|col2|col3", 5, 25, 150, 185, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_REPORT))
_GUICtrlListViewSetColumnWidth ($listview2, 0, 60)
GUICtrlSendMsg($listview2, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview2, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview2, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)

GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)

GUISetState(@SW_SHOW, $GUI2)
GUISetState(@SW_SHOW, $GUI1)

While 1
	If $Dock Then _KeepWindowsDocked()
	Sleep(10)
WEnd

Func _SetDocking()
	If BitAND(GUICtrlRead($OptionsItem2), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($OptionsItem2, $GUI_UNCHECKED)
		$Dock = 0
	Else
		GUICtrlSetState($OptionsItem2, $GUI_CHECKED)
		$Dock = 2
	EndIf
	If $Dock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDocking

Func _SetDockSideBySide()
	If BitAND(GUICtrlRead($OptionsItem3), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($OptionsItem3, $GUI_UNCHECKED)
		GUICtrlSetState($OptionsItem4, $GUI_CHECKED)
		$Dock_Location = 2
	Else
		GUICtrlSetState($OptionsItem3, $GUI_CHECKED)
		GUICtrlSetState($OptionsItem4, $GUI_UNCHECKED)
		$Dock_Location = 1
		If $Dock Then $Dock = 2
	EndIf
	If $Dock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockSideBySide

Func _SetDockTopAndBottom()
	If BitAND(GUICtrlRead($OptionsItem4), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($OptionsItem4, $GUI_UNCHECKED)
		GUICtrlSetState($OptionsItem3, $GUI_CHECKED)
		$Dock_Location = 1
	Else
		GUICtrlSetState($OptionsItem4, $GUI_CHECKED)
		GUICtrlSetState($OptionsItem3, $GUI_UNCHECKED)
		$Dock_Location = 2
		If $Dock Then $Dock = 2
	EndIf
	If $Dock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockTopAndBottom

Func _KeepWindowsDocked()
	Local $p_win1 = WinGetPos($GUI1)
	Local $p_win2 = WinGetPos($GUI2)
	If $Dock_Location == 1 Then
		If (($p_win1[0] <> $x1 Or $p_win1[1] <> $y1) And BitAND(WinGetState($GUI1), 8) Or $Dock = 2) Then
			$x1 = $p_win1[0]
			$y1 = $p_win1[1]
			$x2 = $p_win1[2] + $x1
			$y2 = $y1
			WinMove($GUI2, "", $x2, $y2)
			$Dock = 1
		ElseIf (($p_win2[0] <> $x2 Or $p_win2[1] <> $y2) And BitAND(WinGetState($GUI2), 8)) Then
			$x2 = $p_win2[0]
			$y2 = $p_win2[1]
			$x1 = $p_win2[0] - $p_win1[2]
			$y1 = $y2
			WinMove($GUI1, "", $x1, $y1)
		EndIf
	Else
		If (($p_win1[0] <> $x1 Or $p_win1[1] <> $y1) And BitAND(WinGetState($GUI1), 8) Or $Dock = 2) Then
			$x1 = $p_win1[0]
			$y1 = $p_win1[1]
			$x2 = $x1
			$y2 = $p_win1[3] + $y1
			WinMove($GUI2, "", $x2, $y2)
			$Dock = 1
		ElseIf (($p_win2[0] <> $x2 Or $p_win2[1] <> $y2) And BitAND(WinGetState($GUI2), 8)) Then
			$x2 = $p_win2[0]
			$y2 = $p_win2[1]
			$x1 = $x2
			$y1 = $p_win2[1] - $p_win1[3]
			WinMove($GUI1, "", $x1, $y1)
		EndIf
	EndIf
EndFunc   ;==>_KeepWindowsDocked

Func _CopyRight()
	_GUICtrlListViewCopyItems ($listview, $listview2)
EndFunc   ;==>_CopyRight

Func _MoveRight()
	_GUICtrlListViewCopyItems ($listview, $listview2, 1)
EndFunc   ;==>_MoveRight

Func _CopyLeft()
	_GUICtrlListViewCopyItems ($listview2, $listview)
EndFunc   ;==>_CopyLeft

Func _MoveLeft()
	_GUICtrlListViewCopyItems ($listview2, $listview, 1)
EndFunc   ;==>_MoveLeft

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			Exit
	EndSelect
EndFunc   ;==>SpecialEvents
