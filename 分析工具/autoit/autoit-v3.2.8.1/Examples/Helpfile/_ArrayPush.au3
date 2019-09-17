#include <Array.au3>

 
;First Example

Dim $test[5],$var[2],$b=5
$test[0]=0
$test[1]=1
$test[2]=2
$test[3]=3
$test[4]=4

$var[0]=6
$var[1]=7

_ArrayPush($test,$b)
_ArrayDisplay($test,"ArrayUpdate Test") ; The values now are : 1,2,3,4,5

_ArrayPush($test,$var)
_ArrayDisplay($test,"ArrayUpdate Test") ; The values now are : 3,4,5,6,7

;Second Example(not working)
Dim $Monitor[5],$Messages=""
While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $button
		;;;;
	EndSelect
_ArrayPush($Monitor,$msg)
WEnd


For $i = 0 to 4
	$Messages&=$monitor[$i] & ","
Next

MsgBox(0,"Monitoring Test"," The last 5 GUI Messages were : " & $Messages)
