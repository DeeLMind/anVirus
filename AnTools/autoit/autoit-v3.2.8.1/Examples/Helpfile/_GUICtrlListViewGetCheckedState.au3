#include <GuiConstants.au3>
#include <GuiListView.au3>


opt('MustDeclareVars', 1)
Dim $listview, $Btn_Get, $Btn_Exit, $msg, $Status, $ret
GUICreate("ListView Get Checked State", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
GUICtrlCreateListViewItem("index 0|data1|more1", $listview)
GUICtrlCreateListViewItem("index 1|data2|more2", $listview)
GUICtrlCreateListViewItem("index 2|data3|more3", $listview)
GUICtrlCreateListViewItem("index 3|data4|more4", $listview)
GUICtrlCreateListViewItem("index 4|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 100)
$Btn_Get = GUICtrlCreateButton("Get From Index 2", 150, 200, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Btn_Get
         GUICtrlSetData($Status, "")
         Local $is_Checked = _GUICtrlListViewGetCheckedState ($listview, 2)
         If ($is_Checked <> $LV_ERR) Then
            If ($is_Checked) Then
               GUICtrlSetData($Status, "Item is Checked")
            Else
               GUICtrlSetData($Status, "Item not Checked")
            EndIf
         EndIf
   EndSelect
WEnd
Exit
