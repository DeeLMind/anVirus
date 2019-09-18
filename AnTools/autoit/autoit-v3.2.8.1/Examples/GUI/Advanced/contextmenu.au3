GUICreate("GUI with simple context menu",300,200)

$trackmenu = GuiCtrlCreateContextMenu ()
$aboutitem = GuiCtrlCreateMenuitem ("About",$trackmenu)
; next one creates a menu separator (line)
GuiCtrlCreateMenuitem ("",$trackmenu)
$exititem = GuiCtrlCreateMenuitem ("Exit",$trackmenu)

GuiSetState()

While 1
	$msg = GuiGetMsg()
	If $msg = $exititem Or $msg = -3 Or $msg = -1 Then ExitLoop
	If $msg = $aboutitem Then Msgbox(0,"About","A simple example with a context menu!")
WEnd

GUIDelete()

Exit