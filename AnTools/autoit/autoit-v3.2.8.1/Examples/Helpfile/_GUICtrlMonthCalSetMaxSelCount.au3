#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date, $Btn_Exit, $Combo, $msg, $Status

GUICreate( "Set Max Sel Count", 450, 254)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10, 190, 155, $MCS_MULTISELECT)
$Status = GUICtrlCreateLabel("", 0, 234, 450, 20, BitOR($SS_SUNKEN, $SS_CENTER))

$Btn_Exit = GUICtrlCreateButton("Exit", 180, 180, 90, 30)

$Combo = GUICtrlCreateCombo("", 220, 10, 100, 21, $CBS_DROPDOWNLIST)
GUICtrlSetData($Combo, "1|2|3|4|5|6|7|8|9|10|11|12", "1")

GUISetState()

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Combo
         If (_GUICtrlMonthCalSetMaxSelCount ($Date, GUICtrlRead($Combo))) Then
            GUICtrlSetData($Status, "Successful")
         Else
            GUICtrlSetData($Status, "Failed")
         EndIf
   EndSelect
WEnd
