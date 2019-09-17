#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_DeleteCol, $Btn_Exit, $msg, $Input_col, $Status
GUICreate("ListView Delete Column", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
GUICtrlCreateLabel("Enter Column # to Delete:", 90, 190, 130, 20)
$Input_col = GUICtrlCreateInput("", 220, 190, 80, 20, $ES_NUMBER)
GUICtrlSetLimit($Input_col, 1)
$Btn_DeleteCol = GUICtrlCreateButton("Delete Column", 150, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("Remember columns are zero-indexed", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_DeleteCol
			If (StringLen(GUICtrlRead($Input_col)) > 0) Then
				If (_GUICtrlListViewDeleteColumn ($listview, Int(GUICtrlRead($Input_col)))) Then
					GUICtrlSetData($Status, 'Deleted column: ' & GUICtrlRead($Input_col) & ' Successful')
				Else
					GUICtrlSetData($Status, 'Failed to Delete column: ' & GUICtrlRead($Input_col))
				EndIf
			Else
				GUICtrlSetData($Status, 'Must enter a column to delete')
			EndIf
	EndSelect
WEnd
Exit
