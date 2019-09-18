#include <GUIConstants.au3>
#include <GuiList.au3>

opt('MustDeclareVars', 1)

Dim $msg, $ret
Dim $listbox, $button, $button2

GUICreate("ListBox Set Selection(s) Demo", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY))
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton("Set index 3", 160, 160, 120, 40)
$button2 = GUICtrlCreateButton("Set index 12", 160, 210, 120, 40)

GUISetState()
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $button
            $ret = _GUICtrlListSelectIndex ($listbox, 3)
            If ($ret == $LB_ERR) Then
                MsgBox(16, "Error", "Unknown error from _GUICtrlListSelectIndex")
            EndIf
        Case $msg = $button2
            $ret = _GUICtrlListSelectIndex ($listbox, 12)
            If ($ret == $LB_ERR) Then
                MsgBox(16, "Error", "Unknown error from _GUICtrlListSelectIndex")
            EndIf
    EndSelect
WEnd
