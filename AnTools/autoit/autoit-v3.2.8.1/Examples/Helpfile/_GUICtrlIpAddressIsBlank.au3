#include <GuiIPAddress.au3>

Opt("MustDeclareVars", 1)

_Main()

Func _Main()
	Local $msg, $hgui, $clear, $getaddress, $isblank, $button, $hIPAddress
	
	$hgui = GUICreate("IP Address Control Create Example", 300, 150)
	
	$hIPAddress = _GUICtrlIpAddressCreate ($hgui, 10, 10, 125, 30, $WS_THICKFRAME)
	
	$clear = GUICtrlCreateButton("Clear IP", 10, 50, 80, 20)
	$getaddress = GUICtrlCreateButton("Get IP", 95, 50, 80, 20)
	$isblank = GUICtrlCreateButton("Is Blank?", 180, 50, 80, 20)
	
	$button = GUICtrlCreateButton("Exit", 100, 100, 100, 25)
	_GUICtrlIpAddressSet ($hIPAddress, "24.168.2.128")
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		
		Select
			
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
				Exit
			Case $msg = $clear
				_GUICtrlIpAddressClear ($hIPAddress)
			Case $msg = $getaddress
				MsgBox(0, "IP Entered", _GUICtrlIpAddressGet ($hIPAddress))
			Case $msg = $isblank
				If _GUICtrlIpAddressIsBlank ($hIPAddress) Then
					MsgBox(0, "Fields Check", "All IP Fields are blank")
				Else
					MsgBox(0, "Fields Check", "NOT All IP Fields are blank")
				EndIf
		EndSelect
	WEnd
EndFunc   ;==>_Main
