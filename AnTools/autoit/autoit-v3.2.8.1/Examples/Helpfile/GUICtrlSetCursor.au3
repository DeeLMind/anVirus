#include <GUIConstants.au3>

GUICreate("put cursor over label", 300, 100)
GUICtrlCreateLabel("label",125,40)
GUICtrlSetCursor(-1, 4)
GUISetState ()

While GUIGetMsg()<> $GUI_EVENT_CLOSE
WEnd
Exit

