#include <GuiConstants.au3>
#include <GuiListView.au3>

opt('MustDeclareVars', 1)

Dim $listview, $button, $msg, $i, $a_order, $hList

;================================================================
; Example 1 - Get Column Order from AutoIt Control
;================================================================
GUICreate("ListView Get Column Order", 392, 254)
$listview = GUICtrlCreateListView("col1|col2|col3|col4", 100, 10, 200, 100, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_HEADERDRAGDROP, $LVS_EX_HEADERDRAGDROP)
$button = GUICtrlCreateButton("Get Order", 150, 120, 90, 30)
GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $button
         $a_order = StringSplit(_GUICtrlListViewGetColumnOrder($listview),"|")
			For $i = 1 To $a_order[0]
				MsgBox(0, "col", $a_order[$i])
			Next
   EndSelect
WEnd
GUIDelete()

;================================================================
; Example 2 - Get Column Order from System Control
;================================================================
Run("explorer.exe /root, ,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
WinWaitActive("My Computer")
$hList = ControlGetHandle("My Computer", "", "SysListView321")
$a_order = StringSplit( _GUICtrlListViewGetColumnOrder($hList),"|")
For $i = 1 To $a_order[0]
	MsgBox(0, "col", $a_order[$i])
Next
