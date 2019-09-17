; ****************
; * First sample *
; ****************

#include <GUIConstants.au3>

;right click on gui to bring up context Menu.
;right click on the "ok" button to bring up a controll specific context menu.

GUICreate("My GUI Context Menu", 300, 200)

$contextmenu	= GUICtrlCreateContextMenu ()

$button			= GUICtrlCreateButton("OK", 100, 100, 70, 20)
$buttoncontext	= GUICtrlCreateContextMenu($button)
$buttonitem		= GUICtrlCreateMenuitem("About button", $buttoncontext)

$newsubmenu		= GUICtrlCreateMenu ("new", $contextmenu)
$textitem		= GUICtrlCreateMenuitem ("text", $newsubmenu)

$fileitem		= GUICtrlCreateMenuitem ("Open", $contextmenu)
$saveitem		= GUICtrlCreateMenuitem ("Save", $contextmenu)
GUICtrlCreateMenuitem ("", $contextmenu)	; separator

$infoitem		= GUICtrlCreateMenuitem ("Info", $contextmenu)

GUISetState ()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

Exit


; *****************
; * Second sample *
; *****************

#include <GUIConstants.au3>

$hGui			= GUICreate("My GUI", 170, 40)

$OptionsBtn		= GUICtrlCreateButton("&Options", 10, 10, 70, 20, $BS_FLAT)

; At first create a dummy control for the options and a contextmenu for it
$OptionsDummy	= GUICtrlCreateDummy()
$OptionsContext	= GUICtrlCreateContextMenu($OptionsDummy)
$OptionsCommon	= GUICtrlCreateMenuItem("Common", $OptionsContext)
$OptionsFile	= GUICtrlCreateMenuItem("File", $OptionsContext)
GUICtrlCreateMenuItem("", $OptionsContext)
$OptionsExit	= GUICtrlCreateMenuItem("Exit", $OptionsContext)


$HelpBtn		= GUICtrlCreateButton("&Help", 90, 10, 70, 20, $BS_FLAT)

; Create a dummy control and a contextmenu for the help too
$HelpDummy		= GUICtrlCreateDummy()
$HelpContext	= GUICtrlCreateContextMenu($HelpDummy)
$HelpWWW		= GUICtrlCreateMenuItem("Website", $HelpContext)
GUICtrlCreateMenuItem("", $HelpContext)
$HelpAbout		= GUICtrlCreateMenuItem("About...", $HelpContext)


GUISetState()

While 1
	$Msg = GUIGetMsg()
	
	Switch $Msg
		Case $OptionsExit, $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $OptionsBtn
			ShowMenu($hGui, $Msg, $OptionsContext)
			
		Case $HelpBtn
			ShowMenu($hGui, $Msg, $HelpContext)
			
		Case $HelpAbout
			Msgbox(64, "About...", "GUICtrlGetHandle-Sample")
	EndSwitch	
WEnd
    
Exit


; Show a menu in a given GUI window which belongs to a given GUI ctrl
Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $hMenu = GUICtrlGetHandle($nContextID)
	
	$arPos = ControlGetPos($hWnd, "", $CtrlID)
	
	Local $x = $arPos[0]
	Local $y = $arPos[1] + $arPos[3]
	
	ClientToScreen($hWnd, $x, $y)
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc


; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")
	
	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
	
	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local 
	$stPoint = 0
EndFunc


; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc