#include <GUIConstants.au3>

;example1 ---------------------------
GUICreate(" My GUI Icons")

$icon = GUICtrlCreateIcon ("shell32.dll",10, 20,20)
$icon2 = GUICtrlCreateIcon ("explorer.icl",10, 20,80)
$icon3 = GUICtrlCreateIcon ("explorer.icl",6, 80,80)
$n1=GUICtrlCreateIcon (@windowsdir & "\cursors\horse.ani",-1, 20,120,32,32)
$n2=GUICtrlCreateIcon ("shell32.dll",7 ,20,160,32,32)
GUISetState ()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend




; example2 ---------------------------
Opt("GUICoordMode",1)

GUICreate("My GUI icon Race", 350,74,-1,-1)
GUICtrlCreateLabel ("", 331,0,1,74,5)
$n1=GUICtrlCreateIcon (@windowsdir & "\cursors\dinosaur.ani", -1, 0,0,32,32)
$n2=GUICtrlCreateIcon ( @windowsdir & "\cursors\horse.ani", -1, 0,40,32,32)

GUISetState (@SW_SHOW)

Dim $a = 0, $b = 0
While ($a < 300) And ($b < 300)
  $a = $a + int(Random(0,1)+0.5)
  $b = $b + int(Random(0,1)+0.5)
  GUICtrlSetPos($n1, $a,0)
  GUICtrlSetPos($n2, $b,40)
  Sleep(20)
WEnd
sleep(1000)


