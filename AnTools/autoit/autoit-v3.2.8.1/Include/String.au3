#include-once

;===============================================================================
;
; Function Name:    _HexToStr("hex")
; Description:      Convert a hex string of characters to ASCII Characters.
; Parameter(s):     $strHex is the hex string you want to convert.
; Requirement(s):   Hex Input.
; Return Value(s):  On Success - Returns the converted string of characters.
;                   On Failure - -1  and sets @ERROR = 1
; Author(s):        Jarvis Stubblefield
; Corrected:		2005/09/04 jpm error checking
;
;===============================================================================

Func _HexToString($strHex)
	Local $strChar, $aryHex, $i, $iDec, $Char, $iOne, $iTwo
	
	$aryHex = StringSplit($strHex, "")
	If Mod($aryHex[0], 2) <> 0 Then
		SetError(1)
		Return -1
	EndIf
	
	For $i = 1 To $aryHex[0]
		$iOne = $aryHex[$i]
		$i = $i + 1
		$iTwo = $aryHex[$i]
		$iDec = Dec($iOne & $iTwo)
		If @error <> 0 Then
			SetError(1)
			Return -1
		EndIf
		
		$Char = Chr($iDec)
		$strChar &= $Char
	Next
	
	Return $strChar
EndFunc   ;==>_HexToString

;==================================================================================================
; Function Name:         _StringAddComma($sStr, $sSeparator, $sEnd)
;
; Parameters:            $sStr:   The Numbered string to pass
;                        $sSeparator:   The seperator string you wish to use as the delimiter
;                        $sEnd:   The End delimiter to distinguish decimal remainder
;
; Description:           Adds your preferred delimiter to a Number string
;
; Return Value(s)
;                        On Success:        @Error: = 0 No Error | Returns the number string with its separators
;                        On Failure:        @Error = 1: String passed was not a number
; Author(s):             SmOke_N
;==================================================================================================
Func _StringAddComma($sStr, $sSeparator = -1, $sEnd = -1)
    If $sSeparator = -1 Or $sSeparator = Default Then $sSeparator = ','
    If $sEnd = -1 Or $sEnd = Default Then $sEnd = '.'
    Local $aNum = StringSplit($sStr, $sEnd), $sHold = '', $aSRE, $bUB = False
    If UBound($aNum) > 2 Then
        $aSRE = StringRegExp($aNum[1], '(\d+)(\d{3})', 1)
        $bUB = True
    Else
        $aSRE = StringRegExp($sStr, '(\d+)(\d{3})', 3)
    EndIf
    If UBound($aSRE) = 2 Then
        While IsArray($aSRE)
            $sHold = $sSeparator & $aSRE[1] & $sHold
            $aSRE = StringRegExp($aSRE[0], '(\d+)(\d{3})', 3)
        WEnd
    EndIf
    Local $nStrLen = StringLen(StringReplace($sHold, $sSeparator, ''))
    If $bUB And $sHold Then
        Return StringTrimRight($aNum[1], $nStrLen) & $sHold & $sEnd & $aNum[2]
    ElseIf $sHold Then
        Return StringTrimRight($sStr, $nStrLen) & $sHold
    EndIf
    Return SetError(1, 0, $sStr)
EndFunc   ;==>_StringAddComma

;==================================================================================================
; Function Name:        _StringBetween($sString, $sStart, $sEnd, $vCase, $iSRE)
;
; Parameters:           $sString:     The string to search
;                       $sStart:      The beginning of the string to find
;                       $sEnd:        The end of the string to find
;                       $vCase:       Case sensitive search:  Default or -1 = Not case sensitive
;                       $iSRE:        Choose whether to use StringRegExp or Regular Sting Manipulation to get the result
;                                     Default or -1:  Regular String Manipulation used (Non StringRegExp())
;
; Description:          Returns the string between the start search ($sStart) and the end search ($sEnd)
;
; Requirement(s)        AuotIt Beta 3.2.1.8 or higher
;
; Return Value(s)       On Success:    A 0 based array [0] contains the first found string
;                       On Failure:    @Error = 1: No inbetween string was found
;
; Author(s):            SmOke_N
;                       Thanks to Valik for helping with the new StringRegExp (?s)(?i) isssue
;==================================================================================================

Func _StringBetween($sString, $sStart, $sEnd, $vCase = -1, $iSRE = -1)
	If $iSRE = -1 Or $iSRE = Default Then
		If $vCase = -1 Or $vCase = Default Then
			$vCase = 0
		Else
			$vCase = 1
		EndIf
		Local $sHold = '', $sSnSStart = '', $sSnSEnd = ''
		While StringLen($sString) > 0
			$sSnSStart = StringInStr($sString, $sStart, $vCase)
			If Not $sSnSStart Then ExitLoop
			$sString = StringTrimLeft($sString, ($sSnSStart + StringLen($sStart)) - 1)
			$sSnSEnd = StringInStr($sString, $sEnd, $vCase)
			If Not $sSnSEnd Then ExitLoop
			$sHold &= StringLeft($sString, $sSnSEnd - 1) & Chr(1)
			$sString = StringTrimLeft($sString, $sSnSEnd)
		WEnd
		If Not $sHold Then Return SetError(1, 0, 0)
		$sHold = StringSplit(StringTrimRight($sHold, 1), Chr(1))
		Local $avArray[UBound($sHold) - 1]
		For $iCC = 1 To UBound($sHold) - 1
			$avArray[$iCC - 1] = $sHold[$iCC]
		Next
		Return $avArray
	Else
		If $vCase = Default Or $vCase = -1 Then
			$vCase = '(?i)'
		Else
			$vCase = ''
		EndIf
		Local $aArray = StringRegExp($sString, '(?s)' & $vCase & $sStart & '(.*?)' & $sEnd, 3)
		If IsArray($aArray) Then Return $aArray
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_StringBetween

;===============================================================================
;
; Function Name:    _StringEncrypt()
; Description:      RC4 Based string encryption
; Parameter(s):     $i_Encrypt - 1 to encrypt, 0 to decrypt
;                   $s_EncryptText - string to encrypt
;                   $s_EncryptPassword - string to use as an encryption password
;                   $i_EncryptLevel - integer to use as number of times to encrypt string
; Requirement(s):   None
; Return Value(s):  On Success - Returns the string encrypted (blank) times with (blank) password
;                   On Failure - Returns a blank string and sets @error = 1
; Author(s):        Wes Wolfe-Wolvereness <Weswolf at aol dot com>
;
;===============================================================================
;
Func _StringEncrypt($i_Encrypt, $s_EncryptText, $s_EncryptPassword, $i_EncryptLevel = 1)
	If $i_Encrypt <> 0 And $i_Encrypt <> 1 Then
		SetError(1)
		Return ''
	ElseIf $s_EncryptText = '' Or $s_EncryptPassword = '' Then
		SetError(1)
		Return ''
	Else
		If Number($i_EncryptLevel) <= 0 Or Int($i_EncryptLevel) <> $i_EncryptLevel Then $i_EncryptLevel = 1
		Local $v_EncryptModified
		Local $i_EncryptCountH
		Local $i_EncryptCountG
		Local $v_EncryptSwap
		Local $av_EncryptBox[256][2]
		Local $i_EncryptCountA
		Local $i_EncryptCountB
		Local $i_EncryptCountC
		Local $i_EncryptCountD
		Local $i_EncryptCountE
		Local $v_EncryptCipher
		Local $v_EncryptCipherBy
		If $i_Encrypt = 1 Then
			For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
				$i_EncryptCountG = ''
				$i_EncryptCountH = ''
				$v_EncryptModified = ''
				For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
					If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
						$i_EncryptCountH = 1
					Else
						$i_EncryptCountH += 1
					EndIf
					$v_EncryptModified = $v_EncryptModified & Chr(BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountG, 1)), Asc(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
				Next
				$s_EncryptText = $v_EncryptModified
				$i_EncryptCountA = ''
				$i_EncryptCountB = 0
				$i_EncryptCountC = ''
				$i_EncryptCountD = ''
				$i_EncryptCountE = ''
				$v_EncryptCipherBy = ''
				$v_EncryptCipher = ''
				$v_EncryptSwap = ''
				$av_EncryptBox = ''
				Local $av_EncryptBox[256][2]
				For $i_EncryptCountA = 0 To 255
					$av_EncryptBox[$i_EncryptCountA][1] = Asc(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
					$av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
				Next
				For $i_EncryptCountA = 0 To 255
					$i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
					$v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
					$av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
					$av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
				Next
				For $i_EncryptCountA = 1 To StringLen($s_EncryptText)
					$i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
					$i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
					$i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256) ][0]
					$v_EncryptCipherBy = BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountA, 1)), $i_EncryptCountE)
					$v_EncryptCipher &= Hex($v_EncryptCipherBy, 2)
				Next
				$s_EncryptText = $v_EncryptCipher
			Next
		Else
			For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
				$i_EncryptCountB = 0
				$i_EncryptCountC = ''
				$i_EncryptCountD = ''
				$i_EncryptCountE = ''
				$v_EncryptCipherBy = ''
				$v_EncryptCipher = ''
				$v_EncryptSwap = ''
				$av_EncryptBox = ''
				Local $av_EncryptBox[256][2]
				For $i_EncryptCountA = 0 To 255
					$av_EncryptBox[$i_EncryptCountA][1] = Asc(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
					$av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
				Next
				For $i_EncryptCountA = 0 To 255
					$i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
					$v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
					$av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
					$av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
				Next
				For $i_EncryptCountA = 1 To StringLen($s_EncryptText) Step 2
					$i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
					$i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
					$i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256) ][0]
					$v_EncryptCipherBy = BitXOR(Dec(StringMid($s_EncryptText, $i_EncryptCountA, 2)), $i_EncryptCountE)
					$v_EncryptCipher = $v_EncryptCipher & Chr($v_EncryptCipherBy)
				Next
				$s_EncryptText = $v_EncryptCipher
				$i_EncryptCountG = ''
				$i_EncryptCountH = ''
				$v_EncryptModified = ''
				For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
					If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
						$i_EncryptCountH = 1
					Else
						$i_EncryptCountH += 1
					EndIf
					$v_EncryptModified &= Chr(BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountG, 1)), Asc(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
				Next
				$s_EncryptText = $v_EncryptModified
			Next
		EndIf
		Return $s_EncryptText
	EndIf
EndFunc   ;==>_StringEncrypt

;===============================================================================
;
; Function Name:	_StringInsert(), version 1.02
; Description:    	Inserts a string within another
; Parameters: 		$s_String 		- Original string
;					$s_InsertString	- String to insert
;					$i_Position		- Position to insert string (negatives values
;									  count from right hand side)
; Requirement(s): 	None
; Author(s):      	Louis Horvath <celeri at videotron dot ca>
;
; Return value: 	upon success, returns a string containing the desired insert string.
; 					upon error, sets @error to the following values:
;					@error = 1 : Source string empty / not a string
;					@error = 2 : Insert string empty / not a string
;					@error = 3 : Invalid position
;
;					and returns original string unmodified.
;===============================================================================
Func _StringInsert($s_String, $s_InsertString, $i_Position)
	Local $i_Length, $s_Start, $s_End
	
	If $s_String = "" Or (Not IsString($s_String)) Then
		SetError(1) ; Source string empty / not a string
		Return $s_String
	ElseIf $s_InsertString = "" Or (Not IsString($s_String)) Then
		SetError(2) ; Insert string empty / not a string
		Return $s_String
	Else
		$i_Length = StringLen($s_String) ; Take a note of the length of the source string
		If (Abs($i_Position) > $i_Length) Or (Not IsInt($i_Position)) Then
			SetError(3) ; Invalid position
			Return $s_String
		EndIf
	EndIf
	
	; If $i_Position at start of string
	If $i_Position = 0 Then
		Return $s_InsertString & $s_String ; Just add them up :) Easy :)
		; If $i_Position is positive
	ElseIf $i_Position > 0 Then
		$s_Start = StringLeft($s_String, $i_Position) ; Chop off first part
		$s_End = StringRight($s_String, $i_Length - $i_Position) ; and the second part
		Return $s_Start & $s_InsertString & $s_End ; Assemble all three pieces together
		; If $i_Position is negative
	ElseIf $i_Position < 0 Then
		$s_Start = StringLeft($s_String, Abs($i_Length + $i_Position)) ; Chop off first part
		$s_End = StringRight($s_String, Abs($i_Position)) ; and the second part
		Return $s_Start & $s_InsertString & $s_End ; Assemble all three pieces together
	EndIf
EndFunc   ;==>_StringInsert

;===============================================================================
;
; Description:      Changes a string to proper case, same a =Proper function in Excel
; Syntax:           _StringProper( $sString)
; Parameter(s):     $sString      - String to change to proper case.
; Requirement(s):   None
; Return Value(s):  On Success - Returns the proper string.
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jos van der Zande <jdeb at autoitscript dot com>
; Note(s):          None
;
;===============================================================================

Func _StringProper($s_Str)
	Local $iX = 0
	Local $CapNext = 1
	Local $s_nStr = ""
	Local $s_CurChar
	For $iX = 1 To StringLen($s_Str)
		$s_CurChar = StringMid($s_Str, $iX, 1)
		Select
			Case $CapNext = 1
				If __CharacterIsApha($s_CurChar) Then
					$s_CurChar = StringUpper($s_CurChar)
					$CapNext = 0
				EndIf
			Case Not __CharacterIsApha($s_CurChar)
				$CapNext = 1
			Case Else
				$s_CurChar = StringLower($s_CurChar)
		EndSelect
		$s_nStr &= $s_CurChar
	Next
	Return ($s_nStr)
EndFunc   ;==>_StringProper

;===============================================================================
;
; Description:      Repeats a string a specified number of times.
; Syntax:           _StringRepeat( $sString, $iRepeatCount )
; Parameter(s):     $sString      - String to repeat
;                   $iRepeatCount - Number of times to repeat the string
; Requirement(s):   None
; Return Value(s):  On Success - Returns string with specified number of repeats
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          None
;
;===============================================================================
Func _StringRepeat($sString, $iRepeatCount)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $sResult
	
	Select
		Case Not StringIsInt($iRepeatCount)
			SetError(1)
			Return ""
		Case StringLen($sString) < 1
			SetError(1)
			Return ""
		Case $iRepeatCount <= 0
			SetError(1)
			Return ""
		Case Else
			For $iCount = 1 To $iRepeatCount
				$sResult &= $sString
			Next
			
			Return $sResult
	EndSelect
EndFunc   ;==>_StringRepeat

;===============================================================================
;
; Description:      Reverses the contents of the specified string.
; Syntax:           _StringReverse( $sString )
; Parameter(s):     $sString - String to reverse
; Requirement(s):   None
; Return Value(s):  On Success - Returns reversed string
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jonathan Bennett <jon at hiddensoft com>
; Note(s):          None
;
;===============================================================================
Func _StringReverse($sString)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $sReverse
	Local $iCount
	
	If StringLen($sString) >= 1 Then
		For $iCount = 1 To StringLen($sString)
			$sReverse = StringMid($sString, $iCount, 1) & $sReverse
		Next
		
		Return $sReverse
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_StringReverse

;===============================================================================
;
; Function Name:    _StringToHex("string")
; Description:      Convert a string of characters to hexadecimal.
; Parameter(s):     $strChar is the string you want to convert.
; Requirement(s):   String Input.
; Return Value(s):  Returns the converted string in hexadecimal.
; Author(s):        Jarvis Stubblefield
; Corrected:		2005/09/04 jpm error checking
;
;===============================================================================

Func _StringToHex($strChar)
	Local $aryChar, $i, $iDec, $hChar, $strHex
	
	$aryChar = StringSplit($strChar, "")
	
	For $i = 1 To $aryChar[0]
		$iDec = Asc($aryChar[$i])
		$hChar = Hex($iDec, 2)
		$strHex &= $hChar
	Next
	
	Return $strHex
	
EndFunc   ;==>_StringToHex

;=================================================================================
; Helper functions
Func __CharacterIsApha($s_Str)
	Local $a_Alpha = "abcdefghijklmnopqrstuvwxyz"
	Return (StringInStr($a_Alpha, $s_Str))
EndFunc   ;==>__CharacterIsApha
