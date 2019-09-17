#include <GuiConstants.au3>
#include <GuiListView.au3>
#Include <GuiStatusBar.au3>

Opt('MustDeclareVars', 1)
Local $listview, $Btn_Exit, $msg, $Status, $GUI, $hList
Local $a_PartsRightEdge[2] = [175, -1]
Local $a_PartsText[2] = ["", ""]

;================================================================
; Example 1 - Set Column Header Text in AutoIt Control
;================================================================
$GUI = GUICreate("ListView Set Column Header Text", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
$Status = _GuiCtrlStatusBarCreate ($GUI, $a_PartsRightEdge, $a_PartsText)

If (_GUICtrlListViewJustifyColumn ($listview, 1, 2)) Then
	_GuiCtrlStatusBarSetText ($Status, "Justify column: 2 Successful", 1)
Else
	_GuiCtrlStatusBarSetText ($Status, "Failed to Justify column: 2", 1)
EndIf
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 75)
_GUICtrlListViewSetColumnWidth ($listview, 1, 75)
_GUICtrlListViewSetColumnWidth ($listview, 2, 75)
If _GUICtrlListViewSetColumnHeaderText($listview, 1, "new text") Then
	_GuiCtrlStatusBarSetText ($Status, "Set Header Text: Successful", 0)
Else
	_GuiCtrlStatusBarSetText ($Status, "Failed to Set Header Text", 0)
EndIf
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
; Example 2 - Set Column Header Text in System Control
;================================================================
Run("explorer.exe /root, ,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
WinWaitActive("My Computer")
$hList = ControlGetHandle("My Computer", "", "SysListView321")
_GUICtrlListViewSetColumnHeaderText($hList, 1, "Testing")
