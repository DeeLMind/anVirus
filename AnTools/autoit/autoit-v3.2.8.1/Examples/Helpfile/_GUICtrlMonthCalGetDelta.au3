#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date, $Btn_Exit, $Status, $msg

GUICreate( "Get Delta", 392, 254)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 90, 10, 200, 160)

$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)

GUISetState()
GUICtrlSetData($Status, "Month Delta: " & _GUICtrlMonthCalGetDelta ($Date))
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
   EndSelect
WEnd
