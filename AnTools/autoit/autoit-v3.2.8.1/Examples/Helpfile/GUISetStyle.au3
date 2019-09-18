#include <GuiConstants.au3>
$NewStyle = False
$hWnd = GUICreate("Gui Style", 260, 100)
$Style = GUICtrlCreateButton("Set Style", 45, 50, 150, 20)
GUISetState()

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Style
			If Not $NewStyle Then
				GuiSetStyle ($WS_POPUPWINDOW + $WS_THICKFRAME, $WS_EX_CLIENTEDGE + $WS_EX_TOOLWINDOW)
				GUICtrlSetData($Style, 'Undo Style')
				$NewStyle = True
			Else
				GuiSetStyle ($WS_MINIMIZEBOX + $WS_CAPTION + $WS_POPUP + $WS_SYSMENU, 0)
				GUICtrlSetData($Style, 'Set Style')
				$NewStyle = False
			EndIf
		Case Else
	EndSwitch
WEnd