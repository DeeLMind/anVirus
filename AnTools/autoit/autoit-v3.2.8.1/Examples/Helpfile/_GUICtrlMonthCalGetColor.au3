#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date, $i, $a_colors

GUICreate( "Get Color", 210, 190)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10)
GUISetState()

; 1 - COLORREF rgbcolor
; 2 - Hex BGR color
; 3 - Hex RGB color
$a_colors = _GUICtrlMonthCalGetColor ($Date, $MCSC_BACKGROUND)
For $i = 1 To $a_colors[0]
   MsgBox(0, "Background color displayed between months.", $a_colors[$i])
Next

$a_colors = _GUICtrlMonthCalGetColor ($Date, $MCSC_MONTHBK)
For $i = 1 To $a_colors[0]
   MsgBox(0, "Background color displayed within the month.", $a_colors[$i])
Next

$a_colors = _GUICtrlMonthCalGetColor ($Date, $MCSC_TEXT)
For $i = 1 To $a_colors[0]
   MsgBox(0, "Color used to display text within a month.", $a_colors[$i])
Next

$a_colors = _GUICtrlMonthCalGetColor ($Date, $MCSC_TITLEBK)
For $i = 1 To $a_colors[0]
   MsgBox(0, "Background color displayed in the calendar's title.", $a_colors[$i])
Next

$a_colors = _GUICtrlMonthCalGetColor ($Date, $MCSC_TITLETEXT)
For $i = 1 To $a_colors[0]
   MsgBox(0, "Color used to display text within the calendar's title.", $a_colors[$i])
Next

$a_colors = _GUICtrlMonthCalGetColor ($Date, $MCSC_TRAILINGTEXT)
For $i = 1 To $a_colors[0]
   MsgBox(0, "Color used to display header day and trailing day text.", $a_colors[$i])
Next
