#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date, $Btn_Exit, $Combo, $msg

GUICreate( "Set First Day Of Week", 450, 254)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10)

$Btn_Exit = GUICtrlCreateButton("Exit", 180, 180, 90, 30)

$Combo = GUICtrlCreateCombo("", 220, 10, 100, 21, $CBS_DROPDOWNLIST)
GUICtrlSetData($Combo, "Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday", "Sunday")

GUISetState()

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Combo
         _GUICtrlMonthCalSet1stDOW ($Date, GUICtrlRead($Combo))
   EndSelect
WEnd
