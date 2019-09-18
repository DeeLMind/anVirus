#include-once
;
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with dates and times.
;
;===============================================================================
;
; Description:      Calculates a new date based on a given date and add an interval.
; Parameter(s):     $sType    D = Add number of days to the given date
;                             M = Add number of months to the given date
;                             Y = Add number of years to the given date
;                             w = Add number of Weeks to the given date
;                             h = Add number of hours to the given date
;                             n = Add number of minutes to the given date
;                             s = Add number of seconds to the given date
;                   $iValToAdd - number to be added
;                   $sDate    - Input date in the format YYYY/MM/DD[ HH:MM:SS]
; Requirement(s):   None
; Return Value(s):  On Success - Date newly calculated date.
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $sType
;                                                  2 - Invalid $iValToAdd
;                                                  3 - Invalid $sDate
; Author(s):        Jos van der Zande
; Note(s):          The function will not return an invalid date.
;                   When 3 months is are to '2004/1/31' then the result will be 2004/04/30
;
;
;===============================================================================
Func _DateAdd($sType, $iValToAdd, $sDate)
	Local $asTimePart[4]
	Local $asDatePart[4]
	Local $iJulianDate
	Local $iTimeVal
	Local $iNumDays
	Local $Day2Add
	; Verify that $sType is Valid
	$sType = StringLeft($sType, 1)
	If StringInStr("D,M,Y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		SetError(1)
		Return (0)
	EndIf
	; Verify that Value to Add  is Valid
	If Not StringIsInt($iValToAdd) Then
		SetError(2)
		Return (0)
	EndIf
	; Verify If InputDate is valid
	If Not _DateIsValid($sDate) Then
		SetError(3)
		Return (0)
	EndIf
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	
	; ====================================================
	; adding days then get the julian date
	; add the number of day
	; and convert back to Gregorian
	If $sType = "d" Or $sType = "w" Then
		If $sType = "w" Then $iValToAdd = $iValToAdd * 7
		$iJulianDate = _DateToDayValue($asDatePart[1], $asDatePart[2], $asDatePart[3]) + $iValToAdd
		_DayValueToDate($iJulianDate, $asDatePart[1], $asDatePart[2], $asDatePart[3])
	EndIf
	; ====================================================
	; adding Months
	If $sType = "m" Then
		$asDatePart[2] = $asDatePart[2] + $iValToAdd
		; pos number of months
		While $asDatePart[2] > 12
			$asDatePart[2] = $asDatePart[2] - 12
			$asDatePart[1] = $asDatePart[1] + 1
		WEnd
		; Neg number of months
		While $asDatePart[2] < 1
			$asDatePart[2] = $asDatePart[2] + 12
			$asDatePart[1] = $asDatePart[1] - 1
		WEnd
	EndIf
	; ====================================================
	; adding Years
	If $sType = "y" Then
		$asDatePart[1] = $asDatePart[1] + $iValToAdd
	EndIf
	; ====================================================
	; adding Time value
	If $sType = "h" Or $sType = "n" Or $sType = "s" Then
		$iTimeVal = _TimeToTicks($asTimePart[1], $asTimePart[2], $asTimePart[3]) / 1000
		If $sType = "h" Then $iTimeVal = $iTimeVal + $iValToAdd * 3600
		If $sType = "n" Then $iTimeVal = $iTimeVal + $iValToAdd * 60
		If $sType = "s" Then $iTimeVal = $iTimeVal + $iValToAdd
		; calculated days to add
		$Day2Add = Int($iTimeVal/ (24 * 60 * 60))
		$iTimeVal = $iTimeVal - $Day2Add * 24 * 60 * 60
		If $iTimeVal < 0 Then
			$Day2Add = $Day2Add - 1
			$iTimeVal = $iTimeVal + 24 * 60 * 60
		EndIf
		$iJulianDate = _DateToDayValue($asDatePart[1], $asDatePart[2], $asDatePart[3]) + $Day2Add
		; calculate the julian back to date
		_DayValueToDate($iJulianDate, $asDatePart[1], $asDatePart[2], $asDatePart[3])
		; caluculate the new time
		_TicksToTime($iTimeVal * 1000, $asTimePart[1], $asTimePart[2], $asTimePart[3])
	EndIf
	; ====================================================
	; check if the Input day is Greater then the new month last day.
	; if so then change it to the last possible day in the month
	$iNumDays = StringSplit('31,28,31,30,31,30,31,31,30,31,30,31', ',')
	If _DateIsLeapYear($asDatePart[1]) Then $iNumDays[2] = 29
	;
	If $iNumDays[$asDatePart[2]] < $asDatePart[3] Then $asDatePart[3] = $iNumDays[$asDatePart[2]]
	; ========================
	; Format the return date
	; ========================
	; Format the return date
	$sDate = $asDatePart[1] & '/' & StringRight("0" & $asDatePart[2], 2) & '/' & StringRight("0" & $asDatePart[3], 2)
	; add the time when specified in the input
	If $asTimePart[0] > 0 Then
		If $asTimePart[0] > 2 Then
			$sDate = $sDate & " " & StringRight("0" & $asTimePart[1], 2) & ':' & StringRight("0" & $asTimePart[2], 2) & ':' & StringRight("0" & $asTimePart[3], 2)
		Else
			$sDate = $sDate & " " & StringRight("0" & $asTimePart[1], 2) & ':' & StringRight("0" & $asTimePart[2], 2)
		EndIf
	EndIf
	;
	Return ($sDate)
EndFunc   ;==>_DateAdd

;===============================================================================
;
; Description:      Returns the name of the weekday, based on the specified day.
; Parameter(s):     $iDayNum - Day number
;                   $iShort  - Format:
;                              0 = Long name of the weekday
;                              1 = Abbreviated name of the weekday
; Requirement(s):   None
; Return Value(s):  On Success - Weekday name
;                   On Failure - A NULL string and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          English only
;
;===============================================================================
Func _DateDayOfWeek($iDayNum, $iShort = 0)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $aDayOfWeek[8]
	
	$aDayOfWeek[1] = "Sunday"
	$aDayOfWeek[2] = "Monday"
	$aDayOfWeek[3] = "Tuesday"
	$aDayOfWeek[4] = "Wednesday"
	$aDayOfWeek[5] = "Thursday"
	$aDayOfWeek[6] = "Friday"
	$aDayOfWeek[7] = "Saturday"
	Select
		Case Not StringIsInt($iDayNum) Or Not StringIsInt($iShort)
			SetError(1)
			Return ""
		Case $iDayNum < 1 Or $iDayNum > 7
			SetError(1)
			Return ""
		Case Else
			Select
				Case $iShort = 0
					Return $aDayOfWeek[$iDayNum]
				Case $iShort = 1
					Return StringLeft($aDayOfWeek[$iDayNum], 3)
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateDayOfWeek

;===============================================================================
;
; Function Name:  _DateDaysInMonth()
; Description:    Returns the number of days in a month, based on the specified
;                 month and year.
; Author(s):      Jeremy Landes <jlandes at landeserve dot com>
;
;===============================================================================
Func _DateDaysInMonth($iYear, $iMonthNum)
	Local $aiNumDays
	$aiNumDays = "31,28,31,30,31,30,31,31,30,31,30,31"
	$aiNumDays = StringSplit($aiNumDays, ",")
	If _DateIsMonth($iMonthNum) And _DateIsYear($iYear) Then
		If _DateIsLeapYear($iYear) Then $aiNumDays[2] = $aiNumDays[2] + 1
		SetError(0)
		Return $aiNumDays[$iMonthNum]
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_DateDaysInMonth

;===============================================================================
;
; Description:      Returns the difference between 2 dates, expressed in the type requested
; Parameter(s):     $sType - returns the difference in:
;                               d = days
;                               m = Months
;                               y = Years
;                               w = Weeks
;                               h = Hours
;                               n = Minutes
;                               s = Seconds
;                   $sStartDate    - Input Start date in the format "YYYY/MM/DD[ HH:MM:SS]"
;                   $sEndDate    - Input End date in the format "YYYY/MM/DD[ HH:MM:SS]"
; Requirement(s):   None
; Return Value(s):  On Success - Difference between the 2 dates
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $sType
;                                               2 - Invalid $sStartDate
;                                               3 - Invalid $sEndDate
; Author(s):        Jos van der Zande
; Note(s):
;
;===============================================================================
Func _DateDiff($sType, $sStartDate, $sEndDate)
	Local $asStartDatePart[4]
	Local $asStartTimePart[4]
	Local $asEndDatePart[4]
	Local $asEndTimePart[4]
	Local $iTimeDiff
	Local $iYearDiff
	Local $iMonthDiff
	Local $iStartTimeInSecs
	Local $iEndTimeInSecs
	Local $aDaysDiff
	;
	; Verify that $sType is Valid
	$sType = StringLeft($sType, 1)
	If StringInStr("d,m,y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		SetError(1)
		Return (0)
	EndIf
	; Verify If StartDate is valid
	If Not _DateIsValid($sStartDate) Then
		SetError(2)
		Return (0)
	EndIf
	; Verify If EndDate is valid
	If Not _DateIsValid($sEndDate) Then
		SetError(3)
		Return (0)
	EndIf
	; split the StartDate and Time into arrays
	_DateTimeSplit($sStartDate, $asStartDatePart, $asStartTimePart)
	; split the End  Date and time into arrays
	_DateTimeSplit($sEndDate, $asEndDatePart, $asEndTimePart)
	; ====================================================
	; Get the differens in days between the 2 dates
	$aDaysDiff = _DateToDayValue($asEndDatePart[1], $asEndDatePart[2], $asEndDatePart[3]) - _DateToDayValue($asStartDatePart[1], $asStartDatePart[2], $asStartDatePart[3])
	; ====================================================
	; Get the differens in Seconds between the 2 times when specified
	If $asStartTimePart[0] > 1 And $asEndTimePart[0] > 1 Then
		$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
		$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
		$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
		If $iTimeDiff < 0 Then
			$aDaysDiff = $aDaysDiff - 1
			$iTimeDiff = $iTimeDiff + 24 * 60 * 60
		EndIf
	Else
		$iTimeDiff = 0
	EndIf
	Select
		Case $sType = "d"
			Return ($aDaysDiff)
		Case $sType = "m"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			$iMonthDiff = $asEndDatePart[2] - $asStartDatePart[2] + $iYearDiff * 12
			If $asEndDatePart[3] < $asStartDatePart[3] Then $iMonthDiff = $iMonthDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[3] = $asStartDatePart[3] And $iTimeDiff < 0 Then $iMonthDiff = $iMonthDiff - 1
			Return ($iMonthDiff)
		Case $sType = "y"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			If $asEndDatePart[2] < $asStartDatePart[2] Then $iYearDiff = $iYearDiff - 1
			If $asEndDatePart[2] = $asStartDatePart[2] And $asEndDatePart[3] < $asStartDatePart[3] Then $iYearDiff = $iYearDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[2] = $asStartDatePart[2] And $asEndDatePart[3] = $asStartDatePart[3] And $iTimeDiff < 0 Then $iYearDiff = $iYearDiff - 1
			Return ($iYearDiff)
		Case $sType = "w"
			Return (Int($aDaysDiff / 7))
		Case $sType = "h"
			Return ($aDaysDiff * 24 + Int($iTimeDiff / 3600))
		Case $sType = "n"
			Return ($aDaysDiff * 24 * 60 + Int($iTimeDiff / 60))
		Case $sType = "s"
			Return ($aDaysDiff * 24 * 60 * 60 + $iTimeDiff)
	EndSelect
EndFunc   ;==>_DateDiff

;===============================================================================
;
; Description:      Returns 1 if the specified year falls on a leap year and
;                   returns 0 if it does not.
; Parameter(s):     $iYear - Year to check
; Requirement(s):   None
; Return Value(s):  On Success - 0 = Year is not a leap year
;                                1 = Year is a leap year
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateIsLeapYear($iYear)
	If StringIsInt($iYear) Then
		Select
			Case Mod($iYear, 4) = 0 And Mod($iYear, 100) <> 0
				Return 1
			Case Mod($iYear, 400) = 0
				Return 1
			Case Else
				Return 0
		EndSelect
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_DateIsLeapYear

;===============================================================================
;
; Function Name:  _DateIsMonth()
; Description:    Checks a given number to see if it is a valid month.
; Author(s):      Jeremy Landes <jlandes at landeserve dot com>
;
;===============================================================================
Func _DateIsMonth($iNumber)
	If StringIsInt($iNumber) Then
		If $iNumber >= 1 And $iNumber <= 12 Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_DateIsMonth

;===============================================================================
;
; Description:      Verify if date and time are valid "yyyy/mm/dd[ hh:mm[:ss]]".
; Parameter(s):     $sDate format "yyyy/mm/dd[ hh:mm[:ss]]"
; Requirement(s):   None
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
;                   Jos van der Zande <jdeb at autoitscript dot com>
; Note(s):          None
;
;===============================================================================
Func _DateIsValid($sDate)
	Local $asDatePart[4]
	Local $asTimePart[4]
	Local $iNumDays
	Local $sDateTime
	$iNumDays = "31,28,31,30,31,30,31,31,30,31,30,31"
	$iNumDays = StringSplit($iNumDays, ",")
	; split the Date and Time portion
	$sDateTime = StringSplit($sDate, " T")
	; split the date portion
	If $sDateTime[0] > 0 Then $asDatePart = StringSplit($sDateTime[1], "/-.")
	; Ensure the date contains 3 sections YYYY MM DD
	If UBound($asDatePart) <> 4 Then Return(0)
	If $asDatePart[0] <> 3 Then Return (0)
	; verify valid input date values
	; Make sure the Date parts contains numeric
	If Not StringIsInt($asDatePart[1]) Then Return (0)
	If Not StringIsInt($asDatePart[2]) Then Return (0)
	If Not StringIsInt($asDatePart[3]) Then Return (0)
	$asDatePart[1] = Number($asDatePart[1])
	$asDatePart[2] = Number($asDatePart[2])
	$asDatePart[3] = Number($asDatePart[3])
	; check if all contain valid values
	If _DateIsLeapYear($asDatePart[1]) Then $iNumDays[2] = 29
	If $asDatePart[1] < 1000 Or $asDatePart[1] > 2999 Then Return (0)
	If $asDatePart[2] < 1 Or $asDatePart[2] > 12 Then Return (0)
	If $asDatePart[3] < 1 Or $asDatePart[3] > $iNumDays[$asDatePart[2]] Then Return (0)
	; split the Time portion
	If $sDateTime[0] > 1 Then
		$asTimePart = StringSplit($sDateTime[2], ":")
		If UBound($asTimePart) < 4 Then ReDim $asTimePart[4]
	Else
		Dim $asTimePart[4]
	EndIf
	; check Time portion
	If $asTimePart[0] < 1 Then Return (1)             ; No time specified so date must be correct
	If $asTimePart[0] < 2 Then Return (0)             ; need at least HH:MM when something is specified
	If $asTimePart[0] = 2 Then $asTimePart[3] = "00"  ; init SS when only HH:MM is specified
	; Make sure the Time parts contains numeric
	If Not StringIsInt($asTimePart[1]) Then Return (0)
	If Not StringIsInt($asTimePart[2]) Then Return (0)
	If Not StringIsInt($asTimePart[3]) Then Return (0)
	; check if all contain valid values
	$asTimePart[1] = Number($asTimePart[1])	
	$asTimePart[2] = Number($asTimePart[2])	
	$asTimePart[3] = Number($asTimePart[3])	
	If $asTimePart[1] < 0 Or $asTimePart[1] > 23 Then Return (0)
	If $asTimePart[2] < 0 Or $asTimePart[2] > 59 Then Return (0)
	If $asTimePart[3] < 0 Or $asTimePart[3] > 59 Then Return (0)
	; we got here so date/time must be good
	Return (1)
EndFunc   ;==>_DateIsValid


;===============================================================================
;
; Function Name:  _DateIsYear()
; Description:    Checks a given number to see if it is a valid year.
; Author(s):      Jeremy Landes <jlandes at landeserve dot com>
;
;===============================================================================
Func _DateIsYear($iNumber)
	If StringIsInt($iNumber) Then
		If StringLen($iNumber) = 4 Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_DateIsYear

;===============================================================================
;
; Description:      Returns previous weekday number, based on the specified day
;                   of the week.
; Parameter(s):     $iWeekdayNum - Weekday number
; Requirement(s):   None
; Return Value(s):  On Success - Previous weekday number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateLastWeekdayNum($iWeekdayNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iLastWeekdayNum
	
	Select
		Case Not StringIsInt($iWeekdayNum)
			SetError(1)
			Return 0
		Case $iWeekdayNum < 1 Or $iWeekdayNum > 7
			SetError(1)
			Return 0
		Case Else
			If $iWeekdayNum = 1 Then
				$iLastWeekdayNum = 7
			Else
				$iLastWeekdayNum = $iWeekdayNum - 1
			EndIf
			
			Return $iLastWeekdayNum
	EndSelect
EndFunc   ;==>_DateLastWeekdayNum

;===============================================================================
;
; Description:      Returns previous month number, based on the specified month.
; Parameter(s):     $iMonthNum - Month number
; Requirement(s):   None
; Return Value(s):  On Success - Previous month number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateLastMonthNum($iMonthNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iLastMonthNum
	
	Select
		Case Not StringIsInt($iMonthNum)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 1 Then
				$iLastMonthNum = 12
			Else
				$iLastMonthNum = $iMonthNum - 1
			EndIf
			
			$iLastMonthNum = StringFormat("%02d", $iLastMonthNum)
			Return $iLastMonthNum
	EndSelect
EndFunc   ;==>_DateLastMonthNum

;===============================================================================
;
; Description:      Returns previous month's year, based on the specified month
;                   and year.
; Parameter(s):     $iMonthNum - Month number
;                   $iYear     - Year
; Requirement(s):   None
; Return Value(s):  On Success - Previous month's year
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateLastMonthYear($iMonthNum, $iYear)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iLastYear
	
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iYear)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 1 Then
				$iLastYear = $iYear - 1
			Else
				$iLastYear = $iYear
			EndIf
			
			$iLastYear = StringFormat("%04d", $iLastYear)
			Return $iLastYear
	EndSelect
EndFunc   ;==>_DateLastMonthYear

;===============================================================================
;
; Description:      Returns the name of the month, based on the specified month.
; Parameter(s):     $iMonthNum - Month number
;                   $iShort    - Format:
;                                0 = Long name of the month
;                                1 = Abbreviated name of the month
; Requirement(s):   None
; Return Value(s):  On Success - Month name
;                   On Failure - A NULL string and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          English only
;
;===============================================================================
Func _DateMonthOfYear($iMonthNum, $iShort)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $aMonthOfYear[13]
	
	$aMonthOfYear[1] = "January"
	$aMonthOfYear[2] = "February"
	$aMonthOfYear[3] = "March"
	$aMonthOfYear[4] = "April"
	$aMonthOfYear[5] = "May"
	$aMonthOfYear[6] = "June"
	$aMonthOfYear[7] = "July"
	$aMonthOfYear[8] = "August"
	$aMonthOfYear[9] = "September"
	$aMonthOfYear[10] = "October"
	$aMonthOfYear[11] = "November"
	$aMonthOfYear[12] = "December"
	
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iShort)
			SetError(1)
			Return ""
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return ""
		Case Else
			Select
				Case $iShort = 0
					Return $aMonthOfYear[$iMonthNum]
				Case $iShort = 1
					Return StringLeft($aMonthOfYear[$iMonthNum], 3)
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateMonthOfYear

;===============================================================================
;
; Description:      Returns next weekday number, based on the specified day of
;                   the week.
; Parameter(s):     $iWeekdayNum - Weekday number
; Requirement(s):   None
; Return Value(s):  On Success - Next weekday number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateNextWeekdayNum($iWeekdayNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iNextWeekdayNum
	
	Select
		Case Not StringIsInt($iWeekdayNum)
			SetError(1)
			Return 0
		Case $iWeekdayNum < 1 Or $iWeekdayNum > 7
			SetError(1)
			Return 0
		Case Else
			If $iWeekdayNum = 7 Then
				$iNextWeekdayNum = 1
			Else
				$iNextWeekdayNum = $iWeekdayNum + 1
			EndIf
			
			Return $iNextWeekdayNum
	EndSelect
EndFunc   ;==>_DateNextWeekdayNum

;===============================================================================
;
; Description:      Returns next month number, based on the specified month.
; Parameter(s):     $iMonthNum - Month number
; Requirement(s):   None
; Return Value(s):  On Success - Next month number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateNextMonthNum($iMonthNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iNextMonthNum
	
	Select
		Case Not StringIsInt($iMonthNum)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 12 Then
				$iNextMonthNum = 1
			Else
				$iNextMonthNum = $iMonthNum + 1
			EndIf
			
			$iNextMonthNum = StringFormat("%02d", $iNextMonthNum)
			Return $iNextMonthNum
	EndSelect
EndFunc   ;==>_DateNextMonthNum

;===============================================================================
;
; Description:      Returns next month's year, based on the specified month and
;                   year.
; Parameter(s):     $iMonthNum - Month number
;                   $iYear     - Year
; Requirement(s):   None
; Return Value(s):  On Success - Next month's year
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _DateNextMonthYear($iMonthNum, $iYear)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iNextYear
	
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iYear)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 12 Then
				$iNextYear = $iYear + 1
			Else
				$iNextYear = $iYear
			EndIf
			
			$iNextYear = StringFormat("%04d", $iNextYear)
			Return $iNextYear
	EndSelect
EndFunc   ;==>_DateNextMonthYear

;===============================================================================
;
; Description:      Split Date and Time into two separateArrays.
; Parameter(s):     $sDate format "yyyy/mm/dd[ hh:mm[:ss]]"
;                    or    format "yyyy/mm/dd[Thh:mm[:ss]]"
;                    or    format "yyyy-mm-dd[ hh:mm[:ss]]"
;                    or    format "yyyy-mm-dd[Thh:mm[:ss]]"
;                    or    format "yyyy.mm.dd[ hh:mm[:ss]]"
;                    or    format "yyyy.mm.dd[Thh:mm[:ss]]"
;                   $asDatePart[4] array that contains the Date
;                   $iTimePart[4] array that contains the Time
; Requirement(s):   None
; Return Value(s):  Always 1
; Author(s):        Jos van der Zande
; Note(s):          Its expected you first do a _DateIsValid( $sDate ) for the input
;
;===============================================================================
Func _DateTimeSplit($sDate, ByRef $asDatePart, ByRef $iTimePart)
	Local $sDateTime
	Local $x
	; split the Date and Time portion
	$sDateTime = StringSplit($sDate, " T")
	; split the date portion
	If $sDateTime[0] > 0 Then $asDatePart = StringSplit($sDateTime[1], "/-.")
	; split the Time portion
	If $sDateTime[0] > 1 Then
		$iTimePart = StringSplit($sDateTime[2], ":")
		If UBound($iTimePart) < 4 Then ReDim $iTimePart[4]
	Else
		Dim $iTimePart[4]
	EndIf
	; Ensure the arrays contain 4 values
	If UBound($asDatePart) < 4 Then ReDim $asDatePart[4]
	; update the array to contain numbers not strings
	For $x = 1 To 3
		If StringIsInt($asDatePart[$x]) Then
			$asDatePart[$x] = Number($asDatePart[$x])
		Else
			$asDatePart[$x] = -1
		EndIf
		If StringIsInt($iTimePart[$x]) Then
			$iTimePart[$x] = Number($iTimePart[$x])
		Else
			$iTimePart[$x] = -1
		EndIf
	Next
	Return (1)
EndFunc   ;==>_DateTimeSplit

;===============================================================================
;
; Description:      Returns the number of days since noon 4713 BC January 1.
; Parameter(s):     $Year  - Year in format YYYY
;                   $Month - Month in format MM
;                   $sDate - Day of the month format DD
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Juliandate
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jos van der Zande / Jeremy Landes
; Note(s):          None
;
;===============================================================================
Func _DateToDayValue($iYear, $iMonth, $iDay)
	Local $i_aFactor
	Local $i_bFactor
	Local $i_cFactor
	Local $i_eFactor
	Local $i_fFactor
	Local $iJulianDate
	; Verify If InputDate is valid
	If Not _DateIsValid(StringFormat("%04d/%02d/%02d", $iYear, $iMonth, $iDay)) Then
		SetError(1)
		Return ("")
	EndIf
	If $iMonth < 3 Then
		$iMonth = $iMonth + 12
		$iYear = $iYear - 1
	EndIf
	$i_aFactor = Int($iYear / 100)
	$i_bFactor = Int($i_aFactor / 4)
	$i_cFactor = 2 - $i_aFactor + $i_bFactor
	$i_eFactor = Int(1461 * ($iYear + 4716) / 4)
	$i_fFactor = Int(153 * ($iMonth + 1) / 5)
	$iJulianDate = $i_cFactor + $iDay + $i_eFactor + $i_fFactor - 1524.5
	Return ($iJulianDate)
EndFunc   ;==>_DateToDayValue

;===============================================================================
;
; Description:      Returns the DayofWeek number for a given Date.  1=Sunday
; Parameter(s):     $Year
;                   $Month
;                   $day
; Requirement(s):   None
; Return Value(s):  On Success - Returns Day of the Week Range is 1 to 7 where 1=Sunday.
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jos van der Zande <jdeb at autoitscript dot com>
; Note(s):          None
;
;===============================================================================
Func _DateToDayOfWeek($iYear, $iMonth, $iDay)
	Local $i_aFactor
	Local $i_yFactor
	Local $i_mFactor
	Local $i_dFactor
	; Verify If InputDate is valid
	If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then
		SetError(1)
		Return ("")
	EndIf
	$i_aFactor = Int((14 - $iMonth) / 12)
	$i_yFactor = $iYear - $i_aFactor
	$i_mFactor = $iMonth + (12 * $i_aFactor) - 2
	$i_dFactor = Mod($iDay + $i_yFactor + Int($i_yFactor / 4) - Int($i_yFactor / 100) + Int($i_yFactor / 400) + Int((31 * $i_mFactor) / 12), 7)
	Return ($i_dFactor + 1)
EndFunc   ;==>_DateToDayOfWeek

;===============================================================================
;
; Description:      Returns the DayofWeek number for a given Date.  0=Monday 6=Sunday
; Parameter(s):     $Year
;                   $Month
;                   $day
; Requirement(s):   None
; Return Value(s):  On Success - Returns Day of the Week Range is 0 to 6 where 0=Monday.
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jos van der Zande <jdeb at autoitscript dot com>
; Note(s):          None
;
;===============================================================================
Func _DateToDayOfWeekISO($iYear, $iMonth, $iDay)
	Local $idow = _DateToDayOfWeek($iYear, $iMonth, $iDay)
	If @error Then
		SetError(1)
		Return ""
	EndIf
	If $idow >= 2 Then Return $idow - 2
	Return 6
EndFunc   ;==>_DateToDayOfWeekISO

;===============================================================================
;
; Description:      Returns the name of the month, based on the specified month number.
; Parameter(s):     $iMonthNum - Month number
;                   $iShort  - Format:
;                              0 = Long name of the month
;                              1 = Abbreviated name of the month
; Requirement(s):   None
; Return Value(s):  On Success - Month name
;                   On Failure - A NULL string and sets @ERROR = 1
; Author(s):        Jason Brand <exodius at gmail dot com>
;					(Format based on _DateDayOfWeek by Jeremy Landes)
; Note(s):          English only
;
;===============================================================================
Func _DateToMonth($iMonthNum, $ishort = 0)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $aMonthNumber[13] = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	Local $aMonthNumberAbbrev[13] = ["", "Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
	
	Select
		Case Not StringIsInt($iMonthNum)
			SetError(1)
			Return ""
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return ""
		Case Else
			Select
				Case $ishort = 0
					Return $aMonthNumber[$iMonthNum]
				Case $ishort = 1
					Return $aMonthNumberAbbrev[$iMonthNum]
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateToMonth

;===============================================================================
;
; Description:      Add the given days since noon 4713 BC January 1 and return the date.
; Parameter(s):     $iJulianDate    - Julian date number
;                   $Year  - Year in format YYYY
;                   $Month - Month in format MM
;                   $sDate - Day of the month format DD
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Date in the parameter vars
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _DayValueToDate($iJulianDate, ByRef $iYear, ByRef $iMonth, ByRef $iDay)
	Local $i_zFactor
	Local $i_wFactor
	Local $i_aFactor
	Local $i_bFactor
	Local $i_xFactor
	Local $i_cFactor
	Local $i_dFactor
	Local $i_eFactor
	Local $i_fFactor
	; check for valid input date
	If $iJulianDate < 0 Or Not IsNumber($iJulianDate) Then
		SetError(1)
		Return 0
	EndIf
	; calculte the date
	$i_zFactor = Int($iJulianDate + 0.5)
	$i_wFactor = Int(($i_zFactor - 1867216.25) / 36524.25)
	$i_xFactor = Int($i_wFactor / 4)
	$i_aFactor = $i_zFactor + 1 + $i_wFactor - $i_xFactor
	$i_bFactor = $i_aFactor + 1524
	$i_cFactor = Int(($i_bFactor - 122.1) / 365.25)
	$i_dFactor = Int(365.25 * $i_cFactor)
	$i_eFactor = Int(($i_bFactor - $i_dFactor) / 30.6001)
	$i_fFactor = Int(30.6001 * $i_eFactor)
	$iDay = $i_bFactor - $i_dFactor - $i_fFactor
	; (must get number less than or equal to 12)
	If $i_eFactor - 1 < 13 Then
		$iMonth = $i_eFactor - 1
	Else
		$iMonth = $i_eFactor - 13
	EndIf
	If $iMonth < 3 Then
		$iYear = $i_cFactor - 4715    ; (if Month is January or February)
	Else
		$iYear = $i_cFactor - 4716    ;(otherwise)
	EndIf
	$iYear = StringFormat("%04d", $iYear)
	$iMonth = StringFormat("%02d", $iMonth)
	$iDay = StringFormat("%02d", $iDay)
	Return $iYear & "/" & $iMonth & "/" & $iDay
EndFunc   ;==>_DayValueToDate

;===============================================================================
;
; Description:      Returns the date in the PC's regional settings format.
; Parameter(s):     $date - format "YYYY/MM/DD"
;                   $sType - :
;                      0 - Display a date and/or time. If there is a date part, display it as a short date.
;                          If there is a time part, display it as a long time. If present, both parts are displayed.
;                      1 - Display a date using the long date format specified in your computer's regional settings.
;                      2 - Display a date using the short date format specified in your computer's regional settings.
;                      3 - Display a time using the time format specified in your computer's regional settings.
;                      4 - Display a time using the 24-hour format (hh:mm).
; Requirement(s):   None
; Return Value(s):  On Success - Returns date in proper format
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $sDate
;                                               2 - Invalid $sType
; Author(s):        Jos van der Zande <jdeb at autoitscript dot com>
; Note(s):          None...
;
;===============================================================================
Func _DateTimeFormat($sDate, $sType)
	Local $asDatePart[4]
	Local $asTimePart[4]
	Local $sTempDate = ""
	Local $sTempTime = ""
	Local $sAM
	Local $sPM
	Local $iWday
	Local $lngX
	; Verify If InputDate is valid
	If Not _DateIsValid($sDate) Then
		SetError(1)
		Return ("")
	EndIf
	; input validation
	If $sType < 0 Or $sType > 5 Or Not IsInt($sType) Then
		SetError(2)
		Return ("")
	EndIf
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	;
	; 	Const $LOCALE_USER_DEFAULT = 0x400
	;   Const $LOCALE_SDATE = 0x1D            ;  date separator
	;   Const $LOCALE_STIME = 0x1E            ;  time separator
	;   Const $LOCALE_S1159 = 0x28            ;  AM designator
	;   Const $LOCALE_S2359 = 0x29            ;  PM designator
	; 	Const $LOCALE_SSHORTDATE = 0x1F       ;  short date format string
	; 	Const $LOCALE_SLONGDATE = 0x20        ;  long date format string
	; 	Const $LOCALE_STIMEFORMAT = 0x1003    ;  time format string
	
	Switch $sType
		Case 0
			; Get ShortDate format
			$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1F, "str", "", "long", 255)
			If Not @error And $lngX[0] <> 0 Then
				$sTempDate = $lngX[3]
			Else
				$sTempDate = "M/d/yyyy"
			EndIf
			;
			; Get Time format
			If $asTimePart[0] > 1 Then
				$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1003, "str", "", "long", 255)
				If Not @error And $lngX[0] <> 0 Then
					$sTempTime = $lngX[3]
				Else
					$sTempTime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 1
			; Get LongDate format
			$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x20, "str", "", "long", 255)
			If Not @error And $lngX[0] <> 0 Then
				$sTempDate = $lngX[3]
			Else
				$sTempDate = "dddd, MMMM dd, yyyy"
			EndIf
		Case 2
			; Get ShortDate format
			$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1F, "str", "", "long", 255)
			If Not @error And $lngX[0] <> 0 Then
				$sTempDate = $lngX[3]
			Else
				$sTempDate = "M/d/yyyy"
			EndIf
		Case 3
			;
			; Get Time format
			If $asTimePart[0] > 1 Then
				$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1003, "str", "", "long", 255)
				If Not @error And $lngX[0] <> 0 Then
					$sTempTime = $lngX[3]
				Else
					$sTempTime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 4
			If $asTimePart[0] > 1 Then
				$sTempTime = "hh:mm"
			EndIf
		Case 5
			If $asTimePart[0] > 1 Then
				$sTempTime = "hh:mm:ss"
			EndIf
	EndSwitch
	; Format DATE
	If $sTempDate <> "" Then
		;   Const $LOCALE_SDATE = 0x1D            ;  date separator
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1D, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sTempTime = StringReplace($sTempTime, "/", $lngX[3])
		EndIf
		$iWday = _DateToDayOfWeek($asDatePart[1], $asDatePart[2], $asDatePart[3])
		$asDatePart[3] = StringRight("0" & $asDatePart[3], 2) ; make sure the length is 2
		$asDatePart[2] = StringRight("0" & $asDatePart[2], 2) ; make sure the length is 2
		$sTempDate = StringReplace($sTempDate, "d", "@")
		$sTempDate = StringReplace($sTempDate, "m", "#")
		$sTempDate = StringReplace($sTempDate, "y", "&")
		$sTempDate = StringReplace($sTempDate, "@@@@", _DateDayOfWeek($iWday, 0))
		$sTempDate = StringReplace($sTempDate, "@@@", _DateDayOfWeek($iWday, 1))
		$sTempDate = StringReplace($sTempDate, "@@", $asDatePart[3])
		$sTempDate = StringReplace($sTempDate, "@", StringReplace(StringLeft($asDatePart[3], 1), "0", "") & StringRight($asDatePart[3], 1))
		$sTempDate = StringReplace($sTempDate, "####", _DateMonthOfYear($asDatePart[2], 0))
		$sTempDate = StringReplace($sTempDate, "###", _DateMonthOfYear($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "##", $asDatePart[2])
		$sTempDate = StringReplace($sTempDate, "#", StringReplace(StringLeft($asDatePart[2], 1), "0", "") & StringRight($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "&&&&", $asDatePart[1])
		$sTempDate = StringReplace($sTempDate, "&&", StringRight($asDatePart[1], 2))
	EndIf
	; Format TIME
	If $sTempTime <> "" Then
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x28, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sAM = $lngX[3]
		Else
			$sAM = "AM"
		EndIf
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x29, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sPM = $lngX[3]
		Else
			$sPM = "PM"
		EndIf
		;   Const $LOCALE_STIME = 0x1E            ;  time separator
		$lngX = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", 0x400, "long", 0x1E, "str", "", "long", 255)
		If Not @error And $lngX[0] <> 0 Then
			$sTempTime = StringReplace($sTempTime, ":", $lngX[3])
		EndIf
		If StringInStr($sTempTime, "tt") Then
			If $asTimePart[1] < 12 Then
				$sTempTime = StringReplace($sTempTime, "tt", $sAM)
				If $asTimePart[1] = 0 Then $asTimePart[1] = 12
			Else
				$sTempTime = StringReplace($sTempTime, "tt", $sPM)
				If $asTimePart[1] > 12 Then $asTimePart[1] = $asTimePart[1] - 12
			EndIf
		EndIf
		$asTimePart[1] = StringRight("0" & $asTimePart[1], 2) ; make sure the length is 2
		$asTimePart[2] = StringRight("0" & $asTimePart[2], 2) ; make sure the length is 2
		$asTimePart[3] = StringRight("0" & $asTimePart[3], 2) ; make sure the length is 2
		$sTempTime = StringReplace($sTempTime, "hh", StringFormat("%02d", $asTimePart[1]))
		$sTempTime = StringReplace($sTempTime, "h", StringReplace(StringLeft($asTimePart[1], 1), "0", "") & StringRight($asTimePart[1], 1))
		$sTempTime = StringReplace($sTempTime, "mm", StringFormat("%02d", $asTimePart[2]))
		$sTempTime = StringReplace($sTempTime, "ss", StringFormat("%02d", $asTimePart[3]))
		$sTempDate = StringStripWS($sTempDate & " " & $sTempTime, 3)
	EndIf
	Return ($sTempDate)
EndFunc   ;==>_DateTimeFormat

;===============================================================================
;
; Description:      Returns the the julian date in format YYDDD
; Parameter(s):     $iJulianDate    - Julian date number
;                   $Year  - Year in format YYYY
;                   $Month - Month in format MM
;                   $sDate - Day of the month format DD
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Date in the parameter vars
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jeremy Landes / Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _DateJulianDayNo($iYear, $iMonth, $iDay)
	Local $sFullDate
	Local $aiDaysInMonth
	Local $iJDay
	Local $iCntr
	; Verify If InputDate is valid
	$sFullDate = StringFormat("%04d/%02d/%02d", $iYear, $iMonth, $iDay)
	If Not _DateIsValid($sFullDate) Then
		SetError(1)
		Return ""
	EndIf
	; Build JDay value
	$iJDay = 0
	$aiDaysInMonth = __DaysInMonth($iYear)
	For $iCntr = 1 To $iMonth - 1
		$iJDay = $iJDay + $aiDaysInMonth[$iCntr]
	Next
	$iJDay = ($iYear * 1000) + ($iJDay + $iDay)
	Return $iJDay
EndFunc   ;==>_DateJulianDayNo

;===============================================================================
;
; Description:      Returns the date for a julian date in format YYDDD
; Parameter(s):     $iJDate  - Julian date number
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Date in format YYYY/MM/DD
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jeremy Landes / Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _JulianToDate($iJDay, $sSep = "/")
	Local $aiDaysInMonth
	Local $iYear
	Local $iMonth
	Local $iDay
	Local $iDays
	Local $iMaxDays
	; Verify If InputDate is valid
	$iYear = Int($iJDay / 1000)
	$iDays = Mod($iJDay, 1000)
	$iMaxDays = 365
	If _DateIsLeapYear($iYear) Then $iMaxDays = 366
	If $iDays > $iMaxDays Then
		SetError(1)
		Return ""
	EndIf
	; Convert to regular date
	$aiDaysInMonth = __DaysInMonth($iYear)
	$iMonth = 1
	While $iDays > $aiDaysInMonth[ $iMonth ]
		$iDays = $iDays - $aiDaysInMonth[ $iMonth ]
		$iMonth = $iMonth + 1
	WEnd
	$iDay = $iDays
	Return StringFormat("%04d%s%02d%s%02d", $iYear, $sSep, $iMonth, $sSep, $iDay)
EndFunc   ;==>_JulianToDate

;===============================================================================
;
; Description:      Returns the current Date and Time in the pc's format
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in pc's format
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _Now()
	Return (_DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, 0))
EndFunc   ;==>_Now

;===============================================================================
;
; Description:      Returns the current Date and Time in format YYYY/MM/DD HH:MM:SS
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in in format YYYY/MM/DD HH:MM:SS
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _NowCalc()
	Return (@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
EndFunc   ;==>_NowCalc
;===============================================================================
;
; Description:      Returns the current Date in format YYYY/MM/DD
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in in format YYYY/MM/DD
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _NowCalcDate()
	Return (@YEAR & "/" & @MON & "/" & @MDAY)
EndFunc   ;==>_NowCalcDate

;===============================================================================
;
; Description:      Returns the current Date in the pc's format
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in pc's format
; Author(s):        Jos van der Zande (Larry's idea)
; Note(s):          None
;
;===============================================================================
Func _NowDate()
	Return (_DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY, 0))
EndFunc   ;==>_NowDate

;===============================================================================
;
; Description:      Returns the current Date and Time in the pc's format
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in pc's format
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _NowTime($sType = 3)
	If $sType < 3 Or $sType > 5 Then $sType = 3
	Return (_DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, $sType))
EndFunc   ;==>_NowTime

;===============================================================================
;
; Description:      Sets the local date of the system / computer
; Parameter(s):     $iDay 	- Day of month Values: 1-31
;                   $iMonth - Moth Values: 1-12
;                   $iYear (optional)  - Year Values: > 0 (windows might restrict this further!!)
;
; Requirement(s):   DllCall
; Return Value(s):  On Success - 1
;                   On Failure - 0 sets @ERROR = 1 and @EXTENDED (Windows API error code)
;
; Error code(s): 	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/debug/base/system_error_codes.asp
;
; Author(s):        /dev/null
; Note(s):          -
;
;===============================================================================
Func _SetDate($iDay, $iMonth = 0, $iYear = 0)
	
	Local $iRetval, $SYSTEMTIME, $lpSystemTime
	
	;============================================================================
	;== Some error checking
	;============================================================================
	If $iYear = 0 Then $iYear = @YEAR
	If $iMonth = 0 Then $iMonth = @MON
	If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then Return 1
	
	$SYSTEMTIME = DllStructCreate("ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort")
	$lpSystemTime = DllStructGetPtr($SYSTEMTIME)
	
	;============================================================================
	;== Get the local system time to fill up the SYSTEMTIME structure
	;============================================================================
	$iRetval = DllCall("kernel32.dll", "long", "GetLocalTime", "ptr", $lpSystemTime)
	
	;============================================================================
	;== Change the necessary values
	;============================================================================
	DllStructSetData($SYSTEMTIME, 4, $iDay)
	If $iMonth > 0 Then DllStructSetData($SYSTEMTIME, 2, $iMonth)
	If $iYear > 0 Then DllStructSetData($SYSTEMTIME, 1, $iYear)
	
	;============================================================================
	;== Set the new date
	;============================================================================
	$iRetval = DllCall("kernel32.dll", "long", "SetLocalTime", "ptr", $lpSystemTime)
	; a second call is needed to take care of daylight saving see MSDN
	$iRetval = DllCall("kernel32.dll", "long", "SetLocalTime", "ptr", $lpSystemTime)
	
	;============================================================================
	;== If DllCall was successfull, check for an error of the API Call
	;============================================================================
	If @error = 0 Then
		If $iRetval[0] = 0 Then
			Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
			SetExtended($lastError[0])
			SetError(1)
			Return 0
		Else
			Return 1
		EndIf
		;============================================================================
		;== If DllCall was UNsuccessfull, return an error
		;============================================================================
	Else
		SetError(1)
		Return 0
	EndIf
	
EndFunc   ;==>_SetDate

;===============================================================================
;
; Description:      Sets the local time of the system / computer
; Parameter(s):     $iHour 	- hour Values: 0-23
;                   $iMinute - minute Values: 0-59
;                   $iSecond (optional)  - second Values: 0-59
;
; Requirement(s):   DllCall
; Return Value(s):  On Success - 1
;                   On Failure - 0 sets @ERROR = 1 and @EXTENDED (Windows API error code)
;
; Error code(s): 	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/debug/base/system_error_codes.asp
;
; Author(s):        /dev/null
; Note(s):          -
;
;===============================================================================
Func _SetTime($iHour, $iMinute, $iSecond = 0)
	
	Local $iRetval, $SYSTEMTIME, $lpSystemTime
	
	;============================================================================
	;== Some error checking
	;============================================================================
	If $iHour < 0 Or $iHour > 23 Then Return 1
	If $iMinute < 0 Or $iMinute > 59 Then Return 1
	If $iSecond < 0 Or $iSecond > 59 Then Return 1
	
	$SYSTEMTIME = DllStructCreate("ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort")
	$lpSystemTime = DllStructGetPtr($SYSTEMTIME)
	
	;============================================================================
	;== Get the local system time to fill up the SYSTEMTIME structure
	;============================================================================
	$iRetval = DllCall("kernel32.dll", "long", "GetLocalTime", "ptr", $lpSystemTime)
	
	;============================================================================
	;== Change the necessary values
	;============================================================================
	DllStructSetData($SYSTEMTIME, 5, $iHour)
	DllStructSetData($SYSTEMTIME, 6, $iMinute)
	If $iSecond > 0 Then DllStructSetData($SYSTEMTIME, 7, $iSecond)
	
	;============================================================================
	;== Set the new time
	;============================================================================
	$iRetval = DllCall("kernel32.dll", "long", "SetLocalTime", "ptr", $lpSystemTime)
	; a second call is needed to take care of daylight saving see MSDN
	$iRetval = DllCall("kernel32.dll", "long", "SetLocalTime", "ptr", $lpSystemTime)
	
	;============================================================================
	;== If DllCall was successfull, check for an error of the API Call
	;============================================================================
	If @error = 0 Then
		If $iRetval[0] = 0 Then
			Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
			SetExtended($lastError[0])
			SetError(1)
			Return 0
		Else
			Return 1
		EndIf
		;============================================================================
		;== If DllCall was UNsuccessfull, return an error
		;============================================================================
	Else
		SetError(1)
		Return 0
	EndIf
	
EndFunc   ;==>_SetTime

;===============================================================================
;
; Description:      Converts the specified tick amount to hours, minutes, and
;                   seconds.
; Parameter(s):     $iTicks - Tick amount
;                   $iHours - Variable to store the hours (ByRef)
;                   $iMins  - Variable to store the minutes (ByRef)
;                   $iSecs  - Variable to store the seconds (ByRef)
; Requirement(s):   None
; Return Value(s):  On Success - 1
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Marc <mrd at gmx de>
; Note(s):          None
;
;===============================================================================
Func _TicksToTime($iTicks, ByRef $iHours, ByRef $iMins, ByRef $iSecs)
	If Number($iTicks) > 0 Then
		$iTicks = Round($iTicks / 1000)
		$iHours = Int($iTicks / 3600)
		$iTicks = Mod($iTicks, 3600)
		$iMins = Int($iTicks / 60)
		$iSecs = Round(Mod($iTicks, 60))
		; If $iHours = 0 then $iHours = 24
		Return 1
	ElseIf Number($iTicks) = 0 Then
		$iHours = 0
		$iTicks = 0
		$iMins = 0
		$iSecs = 0
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_TicksToTime

;===============================================================================
;
; Description:      Converts the specified hours, minutes, and seconds to ticks.
; Parameter(s):     $iHours - Hours
;                   $iMins  - Minutes
;                   $iSecs  - Seconds
; Requirement(s):   None
; Return Value(s):  On Success - Converted tick amount
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Marc <mrd at gmx de>
;                   SlimShady: added the default time and made parameters optional
; Note(s):          None
;
;===============================================================================
Func _TimeToTicks($iHours = @HOUR, $iMins = @MIN, $iSecs = @SEC)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iTicks
	
	If StringIsInt($iHours) And StringIsInt($iMins) And StringIsInt($iSecs) Then
		$iTicks = 1000 * ((3600 * $iHours) + (60 * $iMins) + $iSecs)
		Return $iTicks
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_TimeToTicks

;===============================================================================
;
; Function Name:    _WeekNumberISO()
; Description:      Find out the week number of current date OR date given in parameters
;
; Parameter(s):     $iDay    - Day value (default = current day)
;                   $iMonth    - Month value (default = current month)
;                   $iYear    - Year value (default = current year)
; Requirement(s):
; Return Value(s):  On Success     - Returns week number of given date
;                   On Failure     - returns -1  and sets @ERROR = 1 on faulty parameters values
;                   On non-acceptable weekstart value sets @ERROR = 99 and uses default (Sunday) as starting day
; Author(s):        Tuape
;                   JdeB: modified to UDF standards & Doc.
;                   JdeB: Change calculation logic.
;===============================================================================
;
Func _WeekNumberISO($iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY)
	Local $idow, $iDow0101
	
	; Check for erroneous input in $Day, $Month & $Year
	If $iDay > 31 Or $iDay < 1 Then
		SetError(1)
		Return -1
	ElseIf $iMonth > 12 Or $iMonth < 1 Then
		SetError(1)
		Return -1
	ElseIf $iYear < 1 Or $iYear > 2999 Then
		SetError(1)
		Return -1
	EndIf
	
	$idow = _DateToDayOfWeekISO($iYear, $iMonth, $iDay);
	$iDow0101 = _DateToDayOfWeekISO($iYear, 1, 1);
	
	If ($iMonth = 1 And 3 < $iDow0101 And $iDow0101 < 7 - ($iDay - 1)) Then
		;days before week 1 of the current year have the same week number as
		;the last day of the last week of the previous year
		$idow = $iDow0101 - 1;
		$iDow0101 = _DateToDayOfWeekISO($iYear - 1, 1, 1);
		$iMonth = 12
		$iDay = 31
		$iYear = $iYear - 1
	ElseIf ($iMonth = 12 And 30 - ($iDay - 1) < _DateToDayOfWeekISO($iYear + 1, 1, 1) And _DateToDayOfWeekISO($iYear + 1, 1, 1) < 4) Then
		; days after the last week of the current year have the same week number as
		; the first day of the next year, (i.e. 1)
		Return 1;
	EndIf
	
	Return Int((_DateToDayOfWeekISO($iYear, 1, 1) < 4) + 4 * ($iMonth - 1) + (2 * ($iMonth - 1) + ($iDay - 1) + $iDow0101 - $idow + 6) * 36 / 256)
	
EndFunc   ;==>_WeekNumberISO


;===============================================================================
;
; Function Name:    _WeekNumber()
; Description:      Find out the week number of current date OR date given in parameters
;
; Parameter(s):     $iDay    - Day value (default = current day)
;                   $iMonth    - Month value (default = current month)
;                   $iYear    - Year value (default = current year)
;                   $iWeekstart - Week starts from Sunday (1, default) or Monday (2)
; Requirement(s):
; Return Value(s):  On Success     - Returns week number of given date
;                   On Failure     - returns -1  and sets @ERROR = 1 on faulty parameters values
;                   On non-acceptable weekstart value sets @ERROR = 99 and uses default (Sunday) as starting day
; Author(s):        JdeB
;===============================================================================
;
Func _WeekNumber($iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY, $iWeekStart = 1)
	Local $iDow0101, $iDow0101ny
	Local $iDate, $iStartWeek1, $iEndWeek1, $iEndWeek1Date, $iStartWeek1ny, $iStartWeek1Dateny
	Local $iCurrDateDiff, $iCurrDateDiffny
	
	; Check for erroneous input in $Day, $Month & $Year
	If $iDay > 31 Or $iDay < 1 Then
		SetError(1)
		Return -1
	ElseIf $iMonth > 12 Or $iMonth < 1 Then
		SetError(1)
		Return -1
	ElseIf $iYear < 1 Or $iYear > 2999 Then
		SetError(1)
		Return -1
	ElseIf $iWeekStart < 1 Or $iWeekStart > 2 Then
		SetError(2)
		Return -1
	EndIf
	;
	;$idow = _DateToDayOfWeekISO($iYear, $iMonth, $iDay);
	$iDow0101 = _DateToDayOfWeekISO($iYear, 1, 1);
	$iDate = $iYear & '/' & $iMonth & '/' & $iDay
	;Calculate the Start and End date of Week 1 this year
	If $iWeekStart = 1 Then
		If $iDow0101 = 6 Then
			$iStartWeek1 = 0
		Else
			$iStartWeek1 = -1 * $iDow0101 - 1
		EndIf
		$iEndWeek1 = $iStartWeek1 + 6
	Else
		$iStartWeek1 = $iDow0101 * - 1
		$iEndWeek1 = $iStartWeek1 + 6
	EndIf
	;$iStartWeek1Date = _DateAdd('d',$iStartWeek1,$iYear & '/01/01')
	$iEndWeek1Date = _DateAdd('d', $iEndWeek1, $iYear & '/01/01')
	;Calculate the Start and End date of Week 1 this Next year
	$iDow0101ny = _DateToDayOfWeekISO($iYear + 1, 1, 1);
	;  1 = start on Sunday / 2 = start on Monday
	If $iWeekStart = 1 Then
		If $iDow0101ny = 6 Then
			$iStartWeek1ny = 0
		Else
			$iStartWeek1ny = -1 * $iDow0101ny - 1
		EndIf
		;$IEndWeek1ny = $iStartWeek1ny + 6
	Else
		$iStartWeek1ny = $iDow0101ny * - 1
		;$IEndWeek1ny = $iStartWeek1ny + 6
	EndIf
	$iStartWeek1Dateny = _DateAdd('d', $iStartWeek1ny, $iYear + 1 & '/01/01')
	;$iEndWeek1Dateny = _DateAdd('d',$IEndWeek1ny,$iYear+1 & '/01/01')
	;number of days after end week 1
	$iCurrDateDiff = _DateDiff('d', $iEndWeek1Date, $iDate) - 1
	;number of days before next week 1 start
	$iCurrDateDiffny = _DateDiff('d', $iStartWeek1Dateny, $iDate)
	;
	; Check for end of year
	If $iCurrDateDiff >= 0 And $iCurrDateDiffny < 0 Then Return 2 + Int($iCurrDateDiff / 7)
	; > week 1
	If $iCurrDateDiff < 0 Or $iCurrDateDiffny >= 0 Then Return 1
EndFunc   ;==>_WeekNumber


;===============================================================================
;
; Description:      returns an Array that contains the numbers of days per month
;                   te specified year
; Parameter(s):     $iYear
; Requirement(s):   None
; Return Value(s):  On Success - Array that contains the numbers of days per month
;                   On Failure - none
; Author(s):        Jos van der Zande / Jeremy Landes
; Note(s):          None
;
;===============================================================================
Func __DaysInMonth($iYear)
	Local $aiDays
	$aiDays = StringSplit("31,28,31,30,31,30,31,31,30,31,30,31", ",")
	If _DateIsLeapYear($iYear) Then $aiDays[2] = 29
	Return $aiDays
EndFunc   ;==>__DaysInMonth
