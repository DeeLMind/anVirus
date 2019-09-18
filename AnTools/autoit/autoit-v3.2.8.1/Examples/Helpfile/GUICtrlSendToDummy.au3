#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)

GUICreate("GUISendToDummy",220,200, 100,200)
GUISetBkColor (0x00E0FFFF)  ; will change background color
GUICtrlSetOnEvent($GUI_EVENT_CLOSE, "OnClick") ; to handle click on button

$user = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "Onexit") ; to handle click on button
$button = GUICtrlCreateButton ("event",75,170,70,20)
GUICtrlSetOnEvent(-1, "OnClick") ; to handle click on button
GUISetState()

While 1
   Sleep (100)
Wend

Exit

Func OnClick()
   GUICtrlSendToDummy($user)  ; fired dummy control
EndFunc

Func OnExit()
   ; special action before exiting
   Exit
EndFunc
