#include <GUIConstants.au3>

GUICreate("My GUI menu",300,200)

Global $defaultstatus = "Ready"
Global $status

$filemenu = GUICtrlCreateMenu ("&File")
$fileitem = GUICtrlCreateMenuitem ("Open",$filemenu)
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$helpmenu = GUICtrlCreateMenu ("?")
$saveitem = GUICtrlCreateMenuitem ("Save",$filemenu)
GUICtrlSetState(-1,$GUI_DISABLE)
$infoitem = GUICtrlCreateMenuitem ("Info",$helpmenu)
$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)
$recentfilesmenu = GUICtrlCreateMenu ("Recent Files",$filemenu,1)

$separator1 = GUICtrlCreateMenuitem ("",$filemenu,2)	; create a separator line

$viewmenu = GUICtrlCreateMenu("View",-1,1)	; is created before "?" menu
$viewstatusitem = GUICtrlCreateMenuitem ("Statusbar",$viewmenu)
GUICtrlSetState(-1,$GUI_CHECKED)
$okbutton = GUICtrlCreateButton ("OK",50,130,70,20)
GUICtrlSetState(-1,$GUI_FOCUS)
$cancelbutton = GUICtrlCreateButton ("Cancel",180,130,70,20)

$statuslabel = GUICtrlCreateLabel ($defaultstatus,0,165,300,16,BitOr($SS_SIMPLE,$SS_SUNKEN))

GUISetState ()
While 1
	$msg = GUIGetMsg()
	
	If $msg = $fileitem Then
		$file = FileOpenDialog("Choose file...",@TempDir,"All (*.*)")
		If @error <> 1 Then GUICtrlCreateMenuitem ($file,$recentfilesmenu)
	EndIf 
	If $msg = $viewstatusitem Then
		If BitAnd(GUICtrlRead($viewstatusitem),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($viewstatusitem,$GUI_UNCHECKED)
			GUICtrlSetState($statuslabel,$GUI_HIDE)
		Else
			GUICtrlSetState($viewstatusitem,$GUI_CHECKED)
			GUICtrlSetState($statuslabel,$GUI_SHOW)
		EndIf
	EndIf
	If $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton Or $msg = $exititem Then ExitLoop
	If $msg = $infoitem Then Msgbox(0,"Info","Only a test...")
WEnd
GUIDelete()

Exit
