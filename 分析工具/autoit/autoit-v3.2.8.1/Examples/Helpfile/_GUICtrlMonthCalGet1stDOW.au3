#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date

GUICreate( "Get First Day Of Week", 210, 190)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10)
MsgBox(0, "First Day Of Week", _GUICtrlMonthCalGet1stDOW ($Date), 10)
