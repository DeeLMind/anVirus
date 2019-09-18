#include <GuiIPAddress.au3>

Opt("MustDeclareVars", 1)

_Main()

Func _Main()
	Local $msg, $hgui, $button, $hIPAddress, $hIPAddress2
	
	$hgui = GUICreate("IP Address Control Set Font Example", 300, 150)
	
	$hIPAddress = _GUICtrlIpAddressCreate ($hgui, 10, 10, 150, 30,  $WS_DLGFRAME, $WS_EX_CLIENTEDGE)
	$hIPAddress2 = _GUICtrlIpAddressCreate ($hgui, 10, 50, 150, 30,  $WS_DLGFRAME, $WS_EX_CLIENTEDGE)
	
	$button = GUICtrlCreateButton("Exit", 100, 120, 100, 25)

	GUISetState(@SW_SHOW)

	_GUICtrlIpAddressSet ($hIPAddress, "24.168.2.128")
	_GUICtrlIpAddressSetFont($hIPAddress, "Times New Roman", 14, 800, True)
	_GUICtrlIpAddressSet ($hIPAddress2, "24.168.2.128")
	_GUICtrlIpAddressSetFont($hIPAddress2, "Arial", 12, 300)
	

	
	
	While 1
		$msg = GUIGetMsg()
		
		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
				Exit
		EndSelect
	WEnd
EndFunc   ;==>_Main
