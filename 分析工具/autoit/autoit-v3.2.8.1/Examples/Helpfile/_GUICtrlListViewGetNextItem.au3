#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_GetAbove, $Btn_GetBelow, $Btn_Exit, $msg, $Status, $GUI
$GUI = GUICreate("ListView Get Next Item", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
$Btn_GetAbove = GUICtrlCreateButton("Get Next Above", 75, 200, 90, 40)
$Btn_GetBelow = GUICtrlCreateButton("Get Next Below", 200, 200, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_GetAbove
			GUICtrlSetData($Status, "")
			If (_GUICtrlListViewGetCurSel ($listview) > 0) Then
				GUICtrlSetData($Status, "Next Above Index: " & _GUICtrlListViewGetNextItem ($GUI, $listview, _GUICtrlListViewGetCurSel ($listview), $LVNI_ABOVE))
			Else
				GUICtrlSetData($Status, "Nothing Selected or Nothing Above")
			EndIf
		Case $msg = $Btn_GetBelow
			GUICtrlSetData($Status, "")
			If (_GUICtrlListViewGetCurSel ($listview) > $LV_ERR And _GUICtrlListViewGetCurSel ($listview) < _GUICtrlListViewGetItemCount ($listview) -1) Then
				GUICtrlSetData($Status, "Next Below Index: " & _GUICtrlListViewGetNextItem ($GUI, $listview, _GUICtrlListViewGetCurSel ($listview), $LVNI_BELOW))
			Else
				GUICtrlSetData($Status, "Nothing Selected or Nothing Below")
			EndIf
	EndSelect
WEnd
Exit
