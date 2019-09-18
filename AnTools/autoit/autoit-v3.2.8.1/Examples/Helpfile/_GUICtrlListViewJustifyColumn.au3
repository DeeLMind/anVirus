#include <GuiConstants.au3>
#include <GuiListView.au3>

opt('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $Status, $hList

;================================================================
; Example 1 - Justify Column using AutoIt Control
;================================================================
GUICreate("ListView Justify Column", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
$Status = GUICtrlCreateLabel("Remember columns are zero-indexed", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
If (_GUICtrlListViewJustifyColumn ($listview, 1, 2)) Then
   GUICtrlSetData($Status, 'Justify column: 2 Successful')
Else
   GUICtrlSetData($Status, 'Failed to Justify column: 2')
EndIf
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 75)
_GUICtrlListViewSetColumnWidth ($listview, 1, 75)
_GUICtrlListViewSetColumnWidth ($listview, 2, 75)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
   EndSelect
WEnd
GUIDelete()

;================================================================
; Example 2 - Justify Column using System Control
;================================================================
Run("explorer.exe /root, ,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
WinWaitActive("My Computer")
$hList = ControlGetHandle("My Computer", "", "SysListView321")
_GUICtrlListViewJustifyColumn($hList, 1, 2)
