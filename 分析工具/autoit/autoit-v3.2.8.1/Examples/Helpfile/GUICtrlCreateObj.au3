#include <GUIConstants.au3>
; Simple example: Embedding an Internet Explorer Object inside an AutoIt GUI
;
; See also: http://msdn.microsoft.com/workshop/browser/webbrowser/reference/objects/internetexplorer.asp

$oIE = ObjCreate("Shell.Explorer.2")

; Create a simple GUI for our output
GUICreate ( "Embedded Web control Test", 640, 580,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2, BitOr($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
$GUIActiveX			= GUICtrlCreateObj		( $oIE,		 10, 40 , 600 , 360 )
$GUI_Button_Back	= GuiCtrlCreateButton	("Back",	 10, 420, 100,  30)
$GUI_Button_Forward	= GuiCtrlCreateButton	("Forward",	120, 420, 100,  30)
$GUI_Button_Home	= GuiCtrlCreateButton	("Home",	230, 420, 100,  30)
$GUI_Button_Stop	= GuiCtrlCreateButton	("Stop",	330, 420, 100,  30)

GUISetState ()       ;Show GUI

$oIE.navigate("http://www.autoitscript.com")

; Waiting for user to close the window
While 1
    $msg = GUIGetMsg()
    
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $GUI_Button_Home
			$oIE.navigate("http://www.autoitscript.com")
		Case $msg = $GUI_Button_Back
			$oIE.GoBack
		Case $msg = $GUI_Button_Forward
			$oIE.GoForward
		Case $msg = $GUI_Button_Stop
			$oIE.Stop
	EndSelect
	
Wend

GUIDelete ()

Exit

