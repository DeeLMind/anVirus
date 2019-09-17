#include <GUIConstants.au3>
#include <GUICombo.au3>

GUICreate("My GUI combo")

Global $g_idCombo = GUICtrlCreateCombo ("", 10, 10, 100, 120)
GUICtrlSetData($g_idCombo, "item1|item1")

GUISetState ()

While 1
	If GUIGetMsg() = $GUI_EVENT_CLOSE Then ExitLoop
Wend

MsgBox(4096, "", _GUICtrlComboGetList($g_idCombo))
