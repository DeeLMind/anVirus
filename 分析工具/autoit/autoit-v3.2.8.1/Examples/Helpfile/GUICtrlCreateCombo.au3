#include <GUIConstants.au3>

GUICreate("My GUI combo")  ; will create a dialog box that when displayed is centered

GUICtrlCreateCombo ("item1", 10,10) ; create first item
GUICtrlSetData(-1,"item2|item3","item3") ; add other item snd set a new default

GUISetState ()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend
