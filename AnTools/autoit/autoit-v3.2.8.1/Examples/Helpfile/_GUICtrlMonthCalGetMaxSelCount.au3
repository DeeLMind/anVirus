#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date

GUICreate( "Get Max Sel Count", 210, 190)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10)
GUISetState()

MsgBox(0, "Total number of days that can be selected for the control.", _GUICtrlMonthCalGetMaxSelCount ($Date), 10)
