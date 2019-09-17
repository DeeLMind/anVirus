#include <GUIConstants.au3>

Global Const $MIM_APPLYTOSUBMENUS	= 0x80000000
Global Const $MIM_BACKGROUND		= 0x00000002


$hGui			= GUICreate("My GUI", 300, 200)

$FileMenu		= GUICtrlCreateMenu("&File")
$OpenItem		= GUICtrlCreateMenuItem("&Open", $FileMenu)
$SaveItem		= GUICtrlCreateMenuItem("&Save", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)

$OptionsMenu	= GUICtrlCreateMenu("O&ptions", $FileMenu)
$ViewItem		= GUICtrlCreateMenuItem("View", $OptionsMenu)
GUICtrlCreateMenuItem("", $OptionsMenu)
$ToolsItem		= GUICtrlCreateMenuItem("Tools", $OptionsMenu)

GUICtrlCreateMenuItem("", $FileMenu)
$ExitItem		= GUICtrlCreateMenuItem("&Exit", $FileMenu)

$HelpMenu		= GUICtrlCreateMenu("&?")
$AboutItem		= GUICtrlCreateMenuItem("&About", $HelpMenu)

$EndBtn			= GUICtrlCreateButton("End", 110, 140, 70, 20)

SetMenuColor($FileMenu, 0xEEBB99)	; BGR color value
SetMenuColor($OptionsMenu, 0x66BB99); BGR color value
SetMenuColor($HelpMenu, 0x99BBEE)	; BGR color value

GUISetState()

While 1
	$Msg = GUIGetMsg()
	
	Switch $Msg
		Case $EndBtn, $GUI_EVENT_CLOSE
			ExitLoop
		
		Case $AboutItem
			Msgbox(64, "About...", "Colored menu sample")
	EndSwitch	
WEnd
    
Exit


; Apply the color to the menu
Func SetMenuColor($nMenuID, $nColor)
	; Minimum OS are Windows98 and 2000 
	If @OSVersion = "WIN_95" Or @OSVersion = "WIN_NT4" Then Return
	
	$hMenu	= GUICtrlGetHandle($nMenuID)
	
	$hBrush	= DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $nColor)
	$hBrush	= $hBrush[0]
		
Local $stMenuInfo = DllStructCreate("dword;dword;dword;uint;dword;dword;ptr")
	DllStructSetData($stMenuInfo, 1, DllStructGetSize($stMenuInfo))
	DllStructSetData($stMenuInfo, 2, BitOr($MIM_APPLYTOSUBMENUS, $MIM_BACKGROUND))
	DllStructSetData($stMenuInfo, 5, $hBrush)
	
	DllCall("user32.dll", "int", "SetMenuInfo", "hwnd", $hMenu, "ptr", DllStructGetPtr($stMenuInfo))
	
	; release Struct not really needed as it is a local 
	$stMenuInfo = 0
EndFunc