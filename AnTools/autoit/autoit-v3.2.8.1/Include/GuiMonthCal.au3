#include-once
#include <DateTimeConstants.au3>
#include <Misc.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with MonthCal.
;
; ------------------------------------------------------------------------------


; function list
;===============================================================================
;_GUICtrlMonthCalGet1stDOW
;_GUICtrlMonthCalGetColor
;_GUICtrlMonthCalGetMaxSelCount
;_GUICtrlMonthCalGetMaxTodayWidth
;_GUICtrlMonthCalGetMinReqRECT
;_GUICtrlMonthCalGetDelta
;_GUICtrlMonthCalSetColor
;_GUICtrlMonthCalSet1stDOW
;_GUICtrlMonthCalSetMaxSelCount
;_GUICtrlMonthCalSetDelta
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlMonthCalGet1stDOW
; Parameter(s):		$h_monthcal - controlID
; Requirement:			None.
; Return Value(s):	String of 1st Day Of Week
; User CallTip:		_GUICtrlMonthCalGet1stDOW($h_monthcal) Retrieves the first day of the week for a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlMonthCalGet1stDOW($h_monthcal)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, "")
	Local $result
	If IsHWnd($h_monthcal) Then
		$result = _SendMessage($h_monthcal, $MCM_GETFIRSTDAYOFWEEK)
	Else
		$result = GUICtrlSendMsg($h_monthcal, $MCM_GETFIRSTDAYOFWEEK, 0, 0)
	EndIf
	Select
		Case $result = 0
			Return "Monday"
		Case $result = 1
			Return "Tuesday"
		Case $result = 2
			Return "Wednesday"
		Case $result = 3
			Return "Thursday"
		Case $result = 4
			Return "Friday"
		Case $result = 5
			Return "Saturday"
		Case $result = 6
			Return "Sunday"
	EndSelect
EndFunc   ;==>_GUICtrlMonthCalGet1stDOW

;===============================================================================
;
; Description:			_GUICtrlMonthCalGetColor
; Parameter(s):		$h_monthcal - controlID
;							$i_color - Value of type int specifying which month calendar color to retrieve.
; Requirement:			None.
; Return Value(s):	Array containing the color
; User CallTip:		_GUICtrlMonthCalGetColor($h_monthcal, $i_color) Retrieves the color for a given portion of a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_color this value can be one of the following:
;								$MCSC_BACKGROUND
;									Retrieve the background color displayed between months.
;								$MCSC_MONTHBK
;									Retrieve the background color displayed within the month.
;								$MCSC_TEXT
;									Retrieve the color used to display text within a month.
;								$MCSC_TITLEBK
;									Retrieve the background color displayed in the calendar's title.
;								$MCSC_TITLETEXT
;									Retrieve the color used to display text within the calendar's title.
;								$MCSC_TRAILINGTEXT
;									Retrieve the color used to display header day and trailing day text.
;									Header and trailing days are the days from the previous and following
;									months that appear on the current month calendar.
;
;							$array[0] - contains the number returned
;							$array[1] - contains COLORREF rgbcolor
;							$array[2] - contains Hex BGR color
;							$array[3] - contains Hex RGB color
;===============================================================================
Func _GUICtrlMonthCalGetColor($h_monthcal, $i_color)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	Local $result, $a_result[4]
	$a_result[0] = 3
	If IsHWnd($h_monthcal) Then
		$result = _SendMessage($h_monthcal, $MCM_GETCOLOR, $i_color)
	Else
		$result = GUICtrlSendMsg($h_monthcal, $MCM_GETCOLOR, $i_color, 0)
	EndIf
	$a_result[1] = Int($result) ; COLORREF rgbcolor
	$a_result[2] = "0x" & Hex(String($result), 6) ; Hex BGR color
	$a_result[3] = Hex(String($result), 6)
	$a_result[3] = "0x" & StringMid($a_result[3], 5, 2) & StringMid($a_result[3], 3, 2) & StringMid($a_result[3], 1, 2) ; Hex RGB Color
	Return $a_result
EndFunc   ;==>_GUICtrlMonthCalGetColor

;===============================================================================
;
; Description:			_GUICtrlMonthCalGetDelta
; Parameter(s):		$h_monthcal - controlID
; Requirement:			None.
; Return Value(s):	If the month delta was previously set using the _GUICtrlMonthCalSetDelta,
;								returns an INT value that represents the month calendar's current scroll rate.
;							If the month delta was not previously set using the _GUICtrlMonthCalSetDelta,
;								or the month delta was reset to the default,
;								returns an INT value that represents the current number of months visible.
; User CallTip:		_GUICtrlMonthCalGetDelta($h_monthcal) Retrieves the scroll rate for a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlMonthCalGetDelta($h_monthcal)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	If IsHWnd($h_monthcal) Then
		Return _SendMessage($h_monthcal, $MCM_GETMONTHDELTA)
	Else
		Return GUICtrlSendMsg($h_monthcal, $MCM_GETMONTHDELTA, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCalGetDelta

;===============================================================================
;
; Description:			_GUICtrlMonthCalGetMaxSelCount
; Parameter(s):		$h_monthcal - controlID
; Requirement:			None.
; Return Value(s):	Returns an INT value that represents the total number of days that can be selected for the control.
; User CallTip:		_GUICtrlMonthCalGetMaxSelCount($h_monthcal) Retrieves the maximum date range that can be selected in a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlMonthCalGetMaxSelCount($h_monthcal)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	If IsHWnd($h_monthcal) Then
		Return _SendMessage($h_monthcal, $MCM_GETMAXSELCOUNT)
	Else
		Return GUICtrlSendMsg($h_monthcal, $MCM_GETMAXSELCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCalGetMaxSelCount

;===============================================================================
;
; Description:			_GUICtrlMonthCalGetMaxTodayWidth
; Parameter(s):		$h_monthcal - controlID
; Requirement:			None.
; Return Value(s):	Returns the width of the "today" string, in pixels.
; User CallTip:		_GUICtrlMonthCalGetMaxTodayWidth($h_monthcal) Retrieves the maximum width of the "today" string in a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlMonthCalGetMaxTodayWidth($h_monthcal)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	If IsHWnd($h_monthcal) Then
		Return _SendMessage($h_monthcal, $MCM_GETMAXTODAYWIDTH)
	Else
		Return GUICtrlSendMsg($h_monthcal, $MCM_GETMAXTODAYWIDTH, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCalGetMaxTodayWidth

;===============================================================================
;
; Description:			_GUICtrlMonthCalGetMinReqRECT
; Parameter(s):		$h_monthcal - controlID
; Requirement:			None.
; Return Value(s):	Array containing the RECT, first element ($array[0]) contains the number of elements
;							if error -1 is returned
; User CallTip:		_GUICtrlMonthCalGetMinReqRECT($h_monthcal) Retrieves the minimum size required to display a full month in a month calendar control.  (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The minimum required window size for a month calendar control depends on the currently selected font,
;							control styles, system metrics, and regional settings.
;
;===============================================================================
Func _GUICtrlMonthCalGetMinReqRECT($h_monthcal)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
;~ 	typedef struct _RECT {
;~ 	  LONG left;
;~ 	  LONG top;
;~ 	  LONG right;
;~ 	  LONG bottom;
;~ 	} RECT, *PRECT;
	Local $RECT = "int;int;int;int"
	Local $left = 1
	Local $top = 2
	Local $right = 3
	Local $bottom = 4
	Local $struct_RECT, $v_ret
	$struct_RECT = DllStructCreate($RECT)
	If @error Then Return SetError(-1, -1, -1)
	If IsHWnd($h_monthcal) Then
		$v_ret = _SendMessage($h_monthcal, $MCM_GETMINREQRECT, 0, DllStructGetPtr($struct_RECT), 0, "int", "ptr")
	Else
		$v_ret = GUICtrlSendMsg($h_monthcal, $MCM_GETMINREQRECT, 0, DllStructGetPtr($struct_RECT))
	EndIf
	If (Not $v_ret) Then Return SetError(-1, -1, -1)
	Local $array = StringSplit(DllStructGetData($struct_RECT, $left) & "," & DllStructGetData($struct_RECT, $top) & "," & DllStructGetData($struct_RECT, $right) & "," & DllStructGetData($struct_RECT, $bottom), ",")
	Return $array
EndFunc   ;==>_GUICtrlMonthCalGetMinReqRECT

;===============================================================================
;
; Description:			_GUICtrlMonthCalSet1stDOW
; Parameter(s):		$h_monthcal - controlID
;							$s_day - Value representing which day is to be set as the first day of the week.
; Requirement:			None.
; Return Value(s):	The previous first day of the week.
;							if error -1 is returned
; User CallTip:		_GUICtrlMonthCalSet1stDOW($h_monthcal, $s_day) Sets the first day of the week for a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$s_day:
;								0 or "Monday"
;								1 or "Tuesday"
;								2 or "Wednesday"
;								3 or "Thursday"
;								4 or "Friday"
;								5 or "Saturday"
;								6 or "Sunday"
;
;===============================================================================
Func _GUICtrlMonthCalSet1stDOW($h_monthcal, $s_day)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	Local $i_day
	Select
		Case String($s_day) = "0" Or StringUpper($s_day) = "MONDAY"
			$i_day = 0
		Case String($s_day) = "1" Or StringUpper($s_day) = "TUESDAY"
			$i_day = 1
		Case String($s_day) = "2" Or StringUpper($s_day) = "WEDNESDAY"
			$i_day = 2
		Case String($s_day) = "3" Or StringUpper($s_day) = "THURSDAY"
			$i_day = 3
		Case String($s_day) = "4" Or StringUpper($s_day) = "FRIDAY"
			$i_day = 4
		Case String($s_day) = "5" Or StringUpper($s_day) = "SATURDAY"
			$i_day = 5
		Case String($s_day) = "6" Or StringUpper($s_day) = "SUNDAY"
			$i_day = 6
		Case Else
			Return SetError(-1, -1, -1)
	EndSelect
	If IsHWnd($h_monthcal) Then
		Return _SendMessage($h_monthcal, $MCM_SETFIRSTDAYOFWEEK, 0, $i_day)
	Else
		Return GUICtrlSendMsg($h_monthcal, $MCM_SETFIRSTDAYOFWEEK, 0, $i_day)
	EndIf
EndFunc   ;==>_GUICtrlMonthCalSet1stDOW

;===============================================================================
;
; Description:			_GUICtrlMonthCalSetColor
; Parameter(s):		$h_monthcal - controlID
;							$i_color - Value of type int specifying which month calendar color to set.
;							$i_colorref - Value that represents the color that will be set for the specified area of the month calendar.
;							$i_refType - Optional: Type of value used for $i_colorref
; Requirement:			None.
; Return Value(s):	Returns an array of the previous color setting for the specified portion of the month calendar control if successful.
;							Otherwise, the return is -1.
; User CallTip:		_GUICtrlMonthCalSetColor($h_monthcal, $i_color, $i_colorref[, $i_refType = 0]) Sets the color for a given portion of a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_color this value can be one of the following:
;								$MCSC_BACKGROUND
;									Set the background color displayed between months.
;								$MCSC_MONTHBK
;									Set the background color displayed within the month.
;								$MCSC_TEXT
;									Set the color used to display text within a month.
;								$MCSC_TITLEBK
;									Set the background color displayed in the calendar's title.
;								$MCSC_TITLETEXT
;									Set the color used to display text within the calendar's title.
;								$MCSC_TRAILINGTEXT
;									Set the color used to display header day and trailing day text.
;									Header and trailing days are the days from the previous and following
;									months that appear on the current month calendar.
;
;								$i_refType = 0 $i_colorref is COLORREF rgbcolor (default)
;								$i_refType = 1 $i_colorref is Hex BGR color
;								$i_refType = 0 $i_colorref is Hex RGB color
;
;								Value returned:
;									array[0] = number of elements
;									array[1] = COLORREF rbgcolor
;									array[2] = Hex BGR color
;									array[3] = Hex RGB color
;
;===============================================================================
Func _GUICtrlMonthCalSetColor($h_monthcal, $i_color, $i_colorref, $i_refType = 0)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	Local $result, $a_result[4]
	$a_result[0] = 3
	If ($i_refType == 1) Then
		$i_colorref = Int($i_colorref)
	ElseIf ($i_refType == 2) Then
		$i_colorref = Hex(String($i_colorref), 6)
		$i_colorref = Int('0x' & StringMid($i_colorref, 5, 2) & StringMid($i_colorref, 3, 2) & StringMid($i_colorref, 1, 2))
	EndIf
	If IsHWnd($h_monthcal) Then
		$result = _SendMessage($h_monthcal, $MCM_SETCOLOR, $i_color, $i_colorref)
	Else
		$result = GUICtrlSendMsg($h_monthcal, $MCM_SETCOLOR, $i_color, $i_colorref)
	EndIf
	If ($result == -1) Then Return SetError(-1, -1, -1)

	$a_result[1] = Int($result) ; COLORREF rgbcolor
	$a_result[2] = "0x" & Hex(String($result), 6) ; Hex BGR color
	$a_result[3] = Hex(String($result), 6)
	$a_result[3] = "0x" & StringMid($a_result[3], 5, 2) & StringMid($a_result[3], 3, 2) & StringMid($a_result[3], 1, 2) ; Hex RGB Color
	Return $a_result
EndFunc   ;==>_GUICtrlMonthCalSetColor

;===============================================================================
;
; Description:			_GUICtrlMonthCalSetDelta
; Parameter(s):		$h_monthcal - controlID
;							$i_delta - Value representing the number of months to be set as the control's scroll rate.
; Requirement:			None.
; Return Value(s):	Returns an INT value that represents the previous scroll rate.
; User CallTip:		_GUICtrlMonthCalSetDelta($h_monthcal, $i_delta) Sets the scroll rate for a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_delta
;								If this value is zero, the month delta is reset to the default,
;								which is the number of months displayed in the control.
;
;===============================================================================
Func _GUICtrlMonthCalSetDelta($h_monthcal, $i_delta)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, -1)
	If IsHWnd($h_monthcal) Then
		Return _SendMessage($h_monthcal, $MCM_SETMONTHDELTA, $i_delta)
	Else
		Return GUICtrlSendMsg($h_monthcal, $MCM_SETMONTHDELTA, $i_delta, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCalSetDelta

;===============================================================================
;
; Description:			_GUICtrlMonthCalSetMaxSelCount
; Parameter(s):		$h_monthcal - controlID
;							$i_maxsel - Value of type int that will be set to represent the maximum number of days that can be selected.
; Requirement:			None.
; Return Value(s):	Returns nonzero if successful, or zero otherwise.
; User CallTip:		_GUICtrlMonthCalSetMaxSelCount($h_monthcal, $i_maxsel) Sets the maximum number of days that can be selected in a month calendar control. (required: <GuiMonthCal.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				This will fail if applied to a month calendar control that does not use the $MCS_MULTISELECT style.
;
;===============================================================================
Func _GUICtrlMonthCalSetMaxSelCount($h_monthcal, $i_maxsel)
	If Not _IsClassName ($h_monthcal, "SysMonthCal32") Then Return SetError(-1, -1, 0)
	If IsHWnd($h_monthcal) Then
		Return _SendMessage($h_monthcal, $MCM_SETMAXSELCOUNT, $i_maxsel)
	Else
		Return GUICtrlSendMsg($h_monthcal, $MCM_SETMAXSELCOUNT, $i_maxsel, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCalSetMaxSelCount