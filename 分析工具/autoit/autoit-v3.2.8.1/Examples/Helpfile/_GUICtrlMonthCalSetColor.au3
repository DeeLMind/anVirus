#include <GUIConstants.au3>
#include <date.au3>
#include <GuiMonthCal.au3>

opt('MustDeclareVars', 1)

Dim $Date, $i, $a_colors, $Btn_Exit, $msg

GUICreate( "Set Color", 450, 254)

$Date = GUICtrlCreateMonthCal (_NowCalcDate(), 10, 10, 430, 160, 0, 0)

$Btn_Exit = GUICtrlCreateButton("Exit", 180, 180, 90, 30)

GUISetState()

; returns array of previous color if setcolor is successful
; 1 - COLORREF rgbcolor
; 2 - Hex BGR color
; 3 - Hex RGB color

; Set the background color displayed between months.
$a_colors = _GUICtrlMonthCalSetColor ($Date, $MCSC_BACKGROUND, 255)

;Set the background color displayed within the month.
$a_colors = _GUICtrlMonthCalSetColor ($Date, $MCSC_MONTHBK, 0xff0000, 1)

;Set the color used to display text within a month.
$a_colors = _GUICtrlMonthCalSetColor ($Date, $MCSC_TEXT, 0x00ffff, 1)

;Set the background color displayed in the calendar's title.
$a_colors = _GUICtrlMonthCalSetColor ($Date, $MCSC_TITLEBK, 0x000000, 2)

;Set the color used to display text within the calendar's title.
$a_colors = _GUICtrlMonthCalSetColor ($Date, $MCSC_TITLETEXT, 0xC0C0C0, 2)

;Set the color used to display header day and trailing day text.
$a_colors = _GUICtrlMonthCalSetColor ($Date, $MCSC_TRAILINGTEXT, 0xe6e6fa, 2)

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
   EndSelect
WEnd
