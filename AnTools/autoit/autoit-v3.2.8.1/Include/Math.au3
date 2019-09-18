#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with mathematical calculations.
;
; ------------------------------------------------------------------------------


;=============================================================================
;
; Function Name:   _Degrees()
;
; Description:     Converts radians to degrees.
;
; Syntax:          _Degrees( $nRadians )
;
; Parameter(s);    $nRadians   = Radians to be converted into degrees.
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): On Success: = Returns the degrees converted from radians.
;                  On Failure: = Returns a blank string.
;                  @ERROR:     = 0 = No error.
;                                1 = $nRadians is not a number.
;
; Author(s):       Erifash <erifash at gmail dot com>
;
; Notes:           Multiplies instead of dividing.
;
; Example(s):
;   MsgBox(4096, "_Degree() Test", "_Degree( 3.1415 ) = " & _Radian( 3.1415 ))
;
;=============================================================================
Func _Degree($nRadians)
	If Not IsNumber($nRadians) Then
		SetError(1)
		Return ""
	EndIf
	Return $nRadians * 57.2957795130823
EndFunc  ;==>_Degree()

;===============================================================================
;
; Function Name:    _MathCheckDiv()
; Description:      Checks to see if numberA is divisable by numberB
; Parameter(s):     $i_NumA   - Dividend
;                   $i_NumB   - Divisor
; Requirement(s):   None.
; Return Value(s):  On Success - 1 if not evenly divisable
;                              - 2 if evenly divisable
;                   On Failure - -1 and @error = 1
; Author(s):        Wes Wolfe-Wolvereness <Weswolf at aol dot com>
;
;===============================================================================
Func _MathCheckDiv($i_NumA, $i_NumB = 2)
	If Number($i_NumA) = 0 Or Number($i_NumB) = 0 Or Int($i_NumA) <> $i_NumA Or Int($i_NumB) <> $i_NumB Then
		Return -1
		SetError(1)
	ElseIf Int($i_NumA / $i_NumB) <> $i_NumA / $i_NumB Then
		Return 1
	Else
		Return 2
	EndIf
EndFunc   ;==>_MathCheckDiv

;===============================================================================
;
; Function Name:   _Max()
;
; Description:     Evaluates which of the two numbers is higher.
;
; Syntax:          _Max( $nNum1, $nNum2 )
;
; Parameter(s):    $nNum1      = First number
;                  $nNum2      = Second number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): On Success: = Returns the higher of the two numbers
;                  On Failure: = Returns 0.
;                  @ERROR:     = 0 = No error.
;                                1 = $nNum1 isn't a number.
;                                2 = $nNum2 isn't a number.
;
; Author(s):       Jeremy Landes <jlandes at landeserve dot com>
;
; Note(s):         Works with floats as well as integers
;
; Example(s):
;   #Include <Math.au3>
;   MsgBox( 4096, "_Max() - Test", "_Max( 3.5, 10 )	= " & _Max( 3.5, 10 ) )
;   Exit
;
;===============================================================================
Func _Max($nNum1, $nNum2)
	; Check to see if the parameters are indeed numbers of some sort.
	If (Not IsNumber($nNum1)) Then
		SetError(1)
		Return (0)
	EndIf
	If (Not IsNumber($nNum2)) Then
		SetError(2)
		Return (0)
	EndIf
	
	If $nNum1 > $nNum2 Then
		Return $nNum1
	Else
		Return $nNum2
	EndIf
EndFunc   ;==>_Max

;===============================================================================
;
; Function Name:   _Min()
;
; Description:     Evaluates which of the two numbers is lower.
;
; Syntax:          _Min( $nNum1, $nNum2 )
;
; Parameter(s):    $nNum1      = First number
;                  $nNum2      = Second number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): On Success: = Returns the higher of the two numbers
;                  On Failure: = Returns 0.
;                  @ERROR:     = 0 = No error.
;                                1 = $nNum1 isn't a number.
;                                2 = $nNum2 isn't a number.
;
; Author(s):       Jeremy Landes <jlandes at landeserve dot com>
;
; Note(s):         Works with floats as well as integers
;
; Example(s):
;   #Include <Math.au3>
;   MsgBox( 4096, "_Min() - Test", "_Min( 3.5, 10 )	= " & _Min( 3.5, 10 ) )
;   Exit
;
;===============================================================================
Func _Min($nNum1, $nNum2)
	; Check to see if the parameters are indeed numbers of some sort.
	If (Not IsNumber($nNum1)) Then
		SetError(1)
		Return (0)
	EndIf
	If (Not IsNumber($nNum2)) Then
		SetError(2)
		Return (0)
	EndIf
	
	If $nNum1 > $nNum2 Then
		Return $nNum2
	Else
		Return $nNum1
	EndIf
EndFunc   ;==>_Min

;=============================================================================
;
; Function Name:   _Radian()
;
; Description:     Converts degrees to radians.
;
; Syntax:          _Radian( $nDegrees )
;
; Parameter(s);    $nDegrees   = Degrees to be converted into radians.
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): On Success: = Returns the radians converted from degrees.
;                  On Failure: = Returns a blank string.
;                  @ERROR:     = 0 = No error.
;                                1 = $nDegrees is not a number.
;
; Author(s):       Erifash <erifash at gmail dot com>
;
; Notes:           In mathmatics and physics, the radian is a unit of
;                  angle measurement. One radian is approximately
;                  57.2957795130823 degrees. To figure out that number,
;                  use the formula ( 180 / pi ). Since pi is used in
;                  the formula the result is infinite in decimal places.
;                  The fact that AutoIt has a limited number of decimal
;                  places makes the result more innaccurate as you move
;                  down the decimal line. This is perfect for basic
;                  physics calculations though.
;
; Example(s):
;   MsgBox(4096, "_Radian() Test", "_Radian( 35 ) = " & _Radian( 35 ))
;
;=============================================================================
Func _Radian($nDegrees)
        If not Number($nDegrees) Then
		SetError(1)
		Return ""
	EndIf
	Return $nDegrees / 57.2957795130823
EndFunc  ;==>_Radian()
