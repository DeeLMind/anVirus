#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_TestScroll, $Btn_Exit, $msg, $Status, $i
GUICreate("ListView Scroll", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
GUICtrlCreateListViewItem("line6|data6|more6", $listview)
GUICtrlCreateListViewItem("line7|data7|more7", $listview)
GUICtrlCreateListViewItem("line8|data8|more8", $listview)
GUICtrlCreateListViewItem("line9|data9|more9", $listview)
GUICtrlCreateListViewItem("line10|data10|more10", $listview)
GUICtrlCreateListViewItem("line11|data11|more11", $listview)
GUICtrlCreateListViewItem("line12|data12|more12", $listview)
$Btn_TestScroll = GUICtrlCreateButton("Scroll Test", 150, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("Remember items are zero-indexed", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_TestScroll
			For $i = 10 To 50 Step 10
				_GUICtrlListViewScroll($listview,0,$i)
				Sleep( 500 )
				_GUICtrlListViewScroll($listview,0,$i - ($i * 2))
				Sleep( 500 )
			Next
	EndSelect
WEnd
Exit
