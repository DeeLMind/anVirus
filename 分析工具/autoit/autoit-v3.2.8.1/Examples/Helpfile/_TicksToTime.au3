; *** Demo to show a timer window
#include <GUIConstants.au3>
#include <Date.au3>
opt("TrayIconDebug",1)
Global $Secs, $Mins, $Hour, $Time
;Create GUI
GUICreate("Timer",120, 50)
GUICtrlCreateLabel("00:00:00", 10,10)
GUISetState()
;Start timer
$timer = TimerInit()
AdlibEnable("Timer", 50)
;
While 1
 ;FileWriteLine("debug.log",@min & ":" & @sec & " ==> before")
  $msg = GUIGetMsg()
 ;FileWriteLine("debug.log",@min & ":" & @sec & " ==> after")
  Select
     Case $msg = $GUI_EVENT_CLOSE
        Exit
  EndSelect
Wend
;
Func Timer()
  _TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs )
  Local $sTime = $Time  ; save current time to be able to test and avoid flicker..
  $Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
  If $sTime <> $Time Then ControlSetText("Timer", "", "Static1", $Time)
EndFunc  ;==>Timer