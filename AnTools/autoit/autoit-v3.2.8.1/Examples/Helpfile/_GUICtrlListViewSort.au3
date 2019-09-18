#include <GuiConstants.au3>
#include <GuiListView.au3>

opt('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $Status, $Btn_Insert, $ret, $Input_Index
GUICreate("ListView Sort", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlCreateListViewItem("line4|5|more_a", $listview)
GUICtrlCreateListViewItem("line5|4.50 |more_c", $listview)
GUICtrlCreateListViewItem("line5|4.0 |more_c", $listview)
GUICtrlCreateListViewItem("line3|23|more_e", $listview)
GUICtrlCreateListViewItem("line2|0.34560 |more_d", $listview)
GUICtrlCreateListViewItem("line1|1.0 |more_b", $listview)
GUICtrlCreateListViewItem("line1|0.1 |more_b", $listview)
GUICtrlCreateListViewItem("line1|10|more_b", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 75)
_GUICtrlListViewSetColumnWidth ($listview, 1, 75)
_GUICtrlListViewSetColumnWidth ($listview, 2, 75)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)

GUISetState()

Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($listview) ]

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
        Case $msg = $listview
            ; sort the list by the column header clicked on
            _GUICtrlListViewSort($listview, $B_DESCENDING, GUICtrlGetState($listview))
   EndSelect
WEnd

Exit
