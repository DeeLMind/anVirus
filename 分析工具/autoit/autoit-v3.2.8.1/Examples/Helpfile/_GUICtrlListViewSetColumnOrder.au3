#include <GuiConstants.au3>
#include <GuiListView.au3>

opt('MustDeclareVars', 1)

Dim $listview, $button, $msg, $i, $ret

GUICreate("ListView Set Column Order", 392, 254)
$listview = GUICtrlCreateListView("col1|col2|col3|col4", 100, 10, 200, 100, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_HEADERDRAGDROP, $LVS_EX_HEADERDRAGDROP)
$button = GUICtrlCreateButton("Set Order", 150, 120, 90, 30)
GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $button
         $ret = _GUICtrlListViewSetColumnOrder($listview, "3|2|0|1")
   EndSelect
WEnd
