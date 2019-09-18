#include <GuiConstants.au3>
#include <Misc.au3>

Opt ("MustDeclareVars", 1)

Dim $GUI, $coords[4], $msg

$GUI = GUICreate("Mouse Trap Example", 392, 323)

GUISetState()

While 1
	$coords = WinGetPos($GUI)
	_MouseTrap ($coords[0], $coords[1], $coords[0] + $coords[2], $coords[1] + $coords[3])
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case Else
			;;;
	EndSelect
WEnd
_MouseTrap ()
Exit
