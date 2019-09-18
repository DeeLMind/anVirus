#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_Get, $Btn_GetSelected, $Btn_Exit, $msg, $Status, $a_Item, $i
GUICreate("ListView Get Item Text Array", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
$Btn_Get = GUICtrlCreateButton("Get From Index 2", 75, 200, 90, 40)
$Btn_GetSelected = GUICtrlCreateButton("Get Selected", 200, 200, 90, 40)
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
			$a_Item = _GUICtrlListViewGetItemTextArray ($listview, 2)
			If (Not IsArray($a_Item)) Then
				GUICtrlSetData($Status, "Invalid Item #")
			Else
				For $i = 1 To $a_Item[0]
					MsgBox(0, "Passed Item Index only", "SubItem[" & $i & "] = " & $a_Item[$i])
				Next
			EndIf
		Case $msg = $Btn_GetSelected
			GUICtrlSetData($Status, "")
			$a_Item = _GUICtrlListViewGetItemTextArray ($listview)
			If (Not IsArray($a_Item)) Then
				GUICtrlSetData($Status, "Nothing Selected")
			Else
				For $i = 1 To $a_Item[0]
					MsgBox(0, "Passed Item Index only", "SubItem[" & $i & "] = " & $a_Item[$i])
				Next
			EndIf
	EndSelect
WEnd
Exit
