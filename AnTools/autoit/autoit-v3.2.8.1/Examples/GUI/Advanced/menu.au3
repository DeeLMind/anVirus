#include <GUIConstants.au3>

GUICreate("GUI menu",300,200)

$filemenu = GuiCtrlCreateMenu ("File")
$fileitem = GuiCtrlCreateMenuitem ("Open...",$filemenu)
$recentfilesmenu = GuiCtrlCreateMenu ("Recent Files",$filemenu)
$separator1 = GuiCtrlCreateMenuitem ("",$filemenu)
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)

$okbutton = GuiCtrlCreateButton ("OK",50,130,70,20)

$cancelbutton = GuiCtrlCreateButton ("Cancel",180,130,70,20)

GuiSetState()

While 1
	$msg = GUIGetMsg()
	

	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
			ExitLoop
		
		Case $msg = $fileitem
			$file = FileOpenDialog("Choose file...",@TempDir,"All (*.*)")
			If @error <> 1 Then GuiCtrlCreateMenuItem ($file,$recentfilesmenu)

		Case $msg = $exititem
			ExitLoop
		
		Case $msg = $okbutton
			MsgBox(0, "Click","You clicked OK!")

		Case $msg = $aboutitem
			Msgbox(0,"About","GUI Menu Test")
	EndSelect
WEnd

GUIDelete()

Exit
