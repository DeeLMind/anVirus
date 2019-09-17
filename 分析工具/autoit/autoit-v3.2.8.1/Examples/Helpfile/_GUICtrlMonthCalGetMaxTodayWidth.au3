#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date

GUICreate( "Get Max Today Width", 210, 190)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10)
GUISetState()

MsgBox(0, 'Maximum width of the "today" string in a month calendar control.', _GUICtrlMonthCalGetMaxTodayWidth ($Date), 10)
