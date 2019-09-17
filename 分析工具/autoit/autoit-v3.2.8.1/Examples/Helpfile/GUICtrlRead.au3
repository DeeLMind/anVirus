#include <GUIConstants.au3>

GUICreate("My GUICtrlRead") ; will create a dialog box that when displayed is centered

$menu1	= GUICtrlCreateMenu("File")

$n1		= GUICtrlCreateList("", 10, 10, -1, 100)
GUICtrlSetData(-1, "item1|item2|item3", "item2")

$n2		= GUICtrlCreateButton("Read", 10, 100, 50)
GUICtrlSetState(-1, $GUI_FOCUS) ; the focus is on this button

GUISetState () ; will display an empty dialog box
; Run the GUI until the dialog is closed
Do
	$msg = GUIGetMsg()
	if $msg = $n2 Then
		Msgbox(0, "Selected listbox entry", GUICtrlRead($n1)) ; display the selected listbox entry
		$menustate	= GUICtrlRead($menu1) ; return the state of the menu item
		$menutext	= GUICtrlRead($menu1, 1) ; return the text of the menu item
		Msgbox(0, "State and text of the menuitem", "state:" & $menustate & @LF & "text:" & $menutext)
	EndIf
Until $msg = $GUI_EVENT_CLOSE 
