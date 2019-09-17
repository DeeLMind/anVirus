#include <GuiIPAddress.au3>

Opt("MustDeclareVars", 1)

_Main()

Func _Main()
	Local $msg, $hgui, $button, $hIPAddress, $btn_Delete
	
	$hgui = GUICreate("IP Address Delete Control Example", 300, 150)
	
	$hIPAddress = _GUICtrlIpAddressCreate ($hgui, 10, 10, 125, 30, $WS_THICKFRAME)
	$btn_Delete = GUICtrlCreateButton("Delete",10,100,100,25)
	$button = GUICtrlCreateButton("Exit", 150, 100, 100, 25)
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		
		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
				Exit
			Case $msg = $btn_Delete
				_GUICtrlIpAddressDelete($hIPAddress)
		EndSelect
	WEnd
EndFunc   ;==>_Main
