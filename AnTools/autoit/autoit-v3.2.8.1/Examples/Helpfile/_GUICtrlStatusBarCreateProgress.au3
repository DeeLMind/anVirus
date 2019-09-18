Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>

;~ DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0) ; turn off XP themes

Local $gui, $StatusBar1, $msg, $ProgressBar1, $ProgressBar2, $iProgress = 0, $button
Local $i, $s, $m, $wait
Local $a_PartsRightEdge[4] = [100, 220, 360, -1]
Local $a_PartsText[4] = ["", "" ,"", ""]

$gui = GUICreate("Status Bar Create", 500, -1, -1, -1, $WS_SIZEBOX)
$button = GUICtrlCreateButton ("Start",75,70,70,20)
$StatusBar1 = _GUICtrlStatusBarCreate($gui, $a_PartsRightEdge, $a_PartsText)
$ProgressBar1 = _GUICtrlStatusBarCreateProgress($StatusBar1, 1, $PBS_SMOOTH)
$ProgressBar2 = _GUICtrlStatusBarCreateProgress($StatusBar1, 2)
GUICtrlSetColor($ProgressBar1,32250)
GUISetState(@SW_SHOW)

$wait = 20; wait 20ms for next progressstep
$s = 0; progressbar-saveposition

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_RESIZED
			_GUICtrlStatusBarResize($StatusBar1)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			GUICtrlSetData ($button,"Stop")
			For $i = $s To 100

				If GUICtrlRead($ProgressBar1) = 50 Then _GUICtrlStatusBarSetText($StatusBar1,"The half is done...")
				If GUICtrlRead($ProgressBar2) = 50 Then _GUICtrlStatusBarSetText($StatusBar1,"The half is done...",3)
				$m = GUIGetMsg ()
    
				If $m = -3 Then ExitLoop
    
				If $m = $button Then
					GUICtrlSetData ($button,"Next")
					$s = $i;save the current bar-position to $s
					ExitLoop
				Else
					$s=0
					GUICtrlSetData ($ProgressBar1,$i)
					GUICtrlSetData ($ProgressBar2,$i)
					Sleep($wait)
				EndIf
			Next
		if $i >100 Then GUICtrlSetData ($button,"Start")

	EndSelect
	
WEnd
