#include <Constants.au3>
#NoTrayIcon

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.

$exit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitEvent")

TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE,"SpecialEvent")
TraySetOnEvent($TRAY_EVENT_SECONDARYUP,"SpecialEvent")

TraySetState()

While 1
	Sleep(10)	; Idle loop
WEnd

Exit


; Functions
Func SpecialEvent()
	Select
		Case @TRAY_ID = $TRAY_EVENT_PRIMARYDOUBLE
			Msgbox(64,"SpecialEvent-Info","Primary mouse button double clicked.")
		Case @TRAY_ID = $TRAY_EVENT_SECONDARYUP
			Msgbox(64,"SpecialEvent-Info","Secondary mouse button clicked.")
	EndSelect
EndFunc


Func ExitEvent()
	Exit
EndFunc
