#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_SetWidth, $Btn_Exit, $msg, $Input_width, $Status
GUICreate("ListView Sets Column Width", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
GUICtrlCreateLabel("Enter Column Width:", 90, 190, 130, 20)
$Input_width = GUICtrlCreateInput("", 220, 190, 80, 20, $ES_NUMBER)
GUICtrlSetLimit($Input_width, 3)
$Btn_SetWidth = GUICtrlCreateButton("Set Width", 75, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_SetWidth
			If (StringLen(GUICtrlRead($Input_width)) > 0) Then
				If (_GUICtrlListViewSetColumnWidth ($listview, 1, Int(GUICtrlRead($Input_width)))) Then
					GUICtrlSetData($Status, 'Set Column Width Successful')
				Else
					GUICtrlSetData($Status, 'Failed to set column width')
				EndIf
			Else
				GUICtrlSetData($Status, 'Must enter a width')
			EndIf
	EndSelect
WEnd
Exit
