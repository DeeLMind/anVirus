#include <GuiConstants.au3>
#include <GuiListView.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $i, $Styles, $Status, $Btn_Get, $i
GUICreate("ListView Get Extended List View Style", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
GUICtrlSendMsg($listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_HEADERDRAGDROP, $LVS_EX_HEADERDRAGDROP)
For $i = 1 To 20
	GUICtrlCreateListViewItem("line" & $i & "|data" & $i & "|more" & $i, $listview)
Next
$Btn_Get = GUICtrlCreateButton("Get Styles", 150, 230, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("Extended List View Style(s): " & _GUICtrlListViewGetExtendedListViewStyle($listview), 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_Get
			For $i = 1 to 17
				Select
					Case $i = 1
						If(BitAND(_GUICtrlListViewGetExtendedListViewStyle($listview),$LVS_EX_CHECKBOXES) = $LVS_EX_CHECKBOXES) Then
							$Styles &= "$LVS_EX_CHECKBOXES" & @LF
						EndIf
					Case $i = 2
						If(BitAND(_GUICtrlListViewGetExtendedListViewStyle($listview),$LVS_EX_GRIDLINES) = $LVS_EX_GRIDLINES) Then
							$Styles &= "$LVS_EX_GRIDLINES" & @LF
						EndIf
					Case $i = 4
						If(BitAND(_GUICtrlListViewGetExtendedListViewStyle($listview),$LVS_EX_HEADERDRAGDROP) = $LVS_EX_HEADERDRAGDROP) Then
							$Styles &= "$LVS_EX_HEADERDRAGDROP"
						EndIf
				EndSelect
			Next
			If($Styles) Then
				MsgBox(0,"Extend Styles found", $Styles)
			EndIf
	EndSelect
WEnd
Exit
