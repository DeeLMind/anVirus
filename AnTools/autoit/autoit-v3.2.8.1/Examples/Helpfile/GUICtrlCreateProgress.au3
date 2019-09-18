#include <GUIConstants.au3>

GUICreate("My GUI Progressbar",220,100, 100,200)
$progressbar1 = GUICtrlCreateProgress (10,10,200,20)
GUICtrlSetColor(-1,32250); not working with Windows XP Style
$progressbar2 = GUICtrlCreateProgress (10,40,200,20,$PBS_SMOOTH)
$button = GUICtrlCreateButton ("Start",75,70,70,20)
GUISetState ()

$wait = 20; wait 20ms for next progressstep
$s = 0; progressbar-saveposition
do
$msg = GUIGetMsg()
If $msg = $button Then
	GUICtrlSetData ($button,"Stop")
	For $i = $s To 100
	If GUICtrlRead($progressbar1) = 50 Then Msgbox(0,"Info","The half is done...", 1)
	$m = GUIGetMsg ()
	
	If $m = -3 Then ExitLoop
	
	If $m = $button Then
	  GUICtrlSetData ($button,"Next")
	  $s = $i;save the current bar-position to $s
	  ExitLoop
	Else
		$s=0
	  GUICtrlSetData ($progressbar1,$i)
	  GUICtrlSetData ($progressbar2,(100 - $i))
	  Sleep($wait)
	EndIf
	Next
	if $i >100 then
;		$s=0
		GUICtrlSetData ($button,"Start")
	endif
EndIf
until $msg = $GUI_EVENT_CLOSE
