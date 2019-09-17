#Include <Constants.au3>
#NoTrayIcon

Opt("TrayAutoPause",0)	; Script will not be paused when clicking the tray icon.

$valitem	= TrayCreateItem("Val:")
TrayCreateItem("")
$aboutitem	= TrayCreateItem("About")

TraySetState()

TrayItemSetText($TRAY_ITEM_EXIT,"Exit Program")
TrayItemSetText($TRAY_ITEM_PAUSE,"Pause Program")

While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $valitem
			TrayItemSetText($valitem,"Val:" & Int(Random(1,10,1)))
		Case $msg = $aboutitem
			Msgbox(64,"About:","AutoIt3-Tray-sample")
	EndSelect
WEnd

Exit
