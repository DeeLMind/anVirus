#include <GUIConstants.au3>
#include <GuiList.au3>

Opt ('MustDeclareVars', 1)

Dim $msg, $ret
Dim $input, $listbox, $button, $label, $button2

GUICreate("ListBox Select String Demo", 400, 250, -1, -1)
GUICtrlCreateLabel("Enter String to Select", 25, 15)
$input = GUICtrlCreateInput("", 125, 10, 180, 25)

$listbox = GUICtrlCreateList("", 125, 40, 180, 120)
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|")
$button = GUICtrlCreateButton("Start from index 3", 85, 160, 120, 40)
$button2 = GUICtrlCreateButton("Start from index 0", 215, 160, 120, 40)
$label = GUICtrlCreateLabel("Item #", 150, 210, 120)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			If (StringLen(GUICtrlRead($input)) > 0) Then
				$ret = _GUICtrlListSelectString ($listbox, GUICtrlRead($input), 3)
				If ($ret == $LB_ERR) Then
					MsgBox(16, "Error", "Not Found")
				Else
					GUICtrlSetData($label, "Item #: " & $ret)
				EndIf
			EndIf
		Case $msg = $button2
			If (StringLen(GUICtrlRead($input)) > 0) Then
				$ret = _GUICtrlListSelectString ($listbox, GUICtrlRead($input))
				If ($ret == $LB_ERR) Then
					MsgBox(16, "Error", "Not Found")
				Else
					GUICtrlSetData($label, "Item #: " & $ret)
				EndIf
			EndIf
	EndSelect
WEnd
