#include <GuiIPAddress.au3>

Opt("MustDeclareVars", 1)

_Main()

Func _Main()
	Local $msg, $hgui, $setfocus, $button, $hIPAddress
	Local $index = 1
	
	$hgui = GUICreate("IP Address Control Create Example", 300, 150)
	
	$hIPAddress = _GUICtrlIpAddressCreate ($hgui, 10, 10, 125, 30, $WS_THICKFRAME)
	
	$setfocus = GUICtrlCreateButton("Set Focus", 10, 50, 80, 20)
	
	$button = GUICtrlCreateButton("Exit", 100, 100, 100, 25)
	
	_GUICtrlIpAddressSet ($hIPAddress, "24.168.2.128")
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		
		Select
			
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
				Exit
			Case $msg = $setfocus
				_GUICtrlIpAddressSetFocus ($hIPAddress, $index)
				If $index < 3 Then
					$index += 1
				Else
					$index = 0
				EndIf
		EndSelect
	WEnd
EndFunc   ;==>_Main
