#include <GuiIPAddress.au3>

Opt("MustDeclareVars", 1)

_Main()

Func _Main()
	Local $msg, $hgui, $btn_show, $button, $hIPAddress, $Visible = True
	
	$hgui = GUICreate("IP Address Control Show/Hide Example", 300, 150)
	
	$hIPAddress = _GUICtrlIpAddressCreate ($hgui, 10, 10, 150, 30,  $WS_DLGFRAME, $WS_EX_CLIENTEDGE)
	_GUICtrlIpAddressSet ($hIPAddress, "24.168.2.128")
	
	$btn_show = GUICtrlCreateButton("Show/Hide", 10, 50, 100, 25)
	
	$button = GUICtrlCreateButton("Exit", 100, 120, 100, 25)

	GUISetState(@SW_SHOW)


	While 1
		$msg = GUIGetMsg()
		
		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $button
				Exit
			Case $msg = $btn_show
				If $Visible Then
					_GUICtrlIpAddressShowHide ($hIPAddress, @SW_HIDE)
				Else
					_GUICtrlIpAddressShowHide ($hIPAddress, @SW_SHOW)
				EndIf
				$Visible = Not $Visible
		EndSelect
	WEnd
EndFunc   ;==>_Main
