#include <GuiIPAddress.au3>

Opt("MustDeclareVars", 1)

_Main()

Func _Main()
	Local $msg, $hgui, $button, $hIPAddress
	
	$hgui = GUICreate("IP Address Control Create Example", 300, 150)
	
	$hIPAddress = _GUICtrlIpAddressCreate ($hgui, 10, 10, 125, 30, $WS_THICKFRAME)
	
	$button = GUICtrlCreateButton("Exit", 100, 100, 100, 25)
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		
		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
				Exit
		EndSelect
	WEnd
EndFunc   ;==>_Main
