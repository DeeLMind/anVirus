#include <GuiConstants.au3>
#include <GuiListView.au3>

;~ Const $LVS_SORTDESCENDING = 0x0020
opt('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $Status, $Btn_Insert, $ret, $Input_Index
GUICreate("ListView Insert Item", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 75)
_GUICtrlListViewSetColumnWidth ($listview, 1, 75)
_GUICtrlListViewSetColumnWidth ($listview, 2, 75)
GUICtrlCreateLabel("Enter Item # to Insert To:", 90, 190, 130, 20)
$Input_Index = GUICtrlCreateInput("", 220, 190, 80, 20, $ES_NUMBER)
$Btn_Insert = GUICtrlCreateButton("Insert Item", 150, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Btn_Insert
         If (StringLen(GUICtrlRead($Input_Index)) > 0) Then
            $ret = _GUICtrlListViewInsertItem ($listview, Int(GUICtrlRead($Input_Index)), "test|1|2")
            If ($ret <> $LV_ERR) Then
               GUICtrlSetData($Status, 'Inserted Item at: ' & $ret)
            Else
               GUICtrlSetData($Status, 'Failed to Insert Item')
            EndIf
         Else
            GUICtrlSetData($Status, 'Must enter a Item Index to insert')
         EndIf
   EndSelect
WEnd
Exit
