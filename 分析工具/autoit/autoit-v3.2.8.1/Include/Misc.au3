#include-once
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1++
; Language:       English
; Description:    Functions that assist with Common Dialogs.
;
; ------------------------------------------------------------------------------
; Color Dialog constants
Global Const $CC_ANYCOLOR = 0x100
Global Const $CC_FULLOPEN = 0x2
Global Const $CC_RGBINIT = 0x1
; Font Dialog constants
Global Const $CF_EFFECTS = 0x100
Global Const $CF_PRINTERFONTS = 0x2
Global Const $CF_SCREENFONTS = 0x1
Global Const $CF_NOSCRIPTSEL = 0x800000
Global Const $CF_INITTOLOGFONTSTRUCT = 0x40
Global Const $DEFAULT_PITCH = 0
Global Const $FF_DONTCARE = 0
Global Const $LOGPIXELSX = 88
;===============================================================================
;
; Description:            _ChooseColor
; Parameter(s):			$i_ReturnType - Optional: determines return type
;								$i_colorref - Optional: default selected Color
;								$i_refType - Optional: Type of $i_colorref passed in
;								$h_wnd_owner - Optional: Handle of owner window
; Requirement:            None
; Return Value(s):    Returns COLORREF rgbcolor if $i_refType = 0 (default)
;                            Returns Hex RGB value if $i_refType = 1
;                            Returns Hex BGR Color if $i_refType = 2
;                            if error occurs, @error is set
; User CallTip:        _ChooseColor([$i_ReturnType = 0[, $i_colorref = 0[, $i_refType=0[, $h_wnd_owner]]]]) Creates a Color dialog box that enables the user to select a color. (required: <Misc.au3>)
; Author(s):            Gary Frost (custompcs at charter dot net)
; Note(s):                $i_ReturnType = 0 then COLORREF rgbcolor is returned (default)
;                            $i_ReturnType = 1 then Hex BGR Color is returned
;                            $i_ReturnType = 2 Hex RGB Color is returned
;
;                            $i_colorref = 0 (default)
;
;                            $i_refType = 0 then $i_colorref is COLORREF rgbcolor value (default)
;                            $i_refType = 1 then $i_colorref is BGR hex value
;                            $i_refType = 2 then $i_colorref is RGB hex value
;
;===============================================================================
Func _ChooseColor($i_ReturnType = 0, $i_colorref = 0, $i_refType = 0, $h_wnd_owner = 0)
;~ typedef struct {
;~     DWORD lStructSize;
;~     HWND hwndOwner;
;~     HWND hInstance;
;~     COLORREF rgbResult;
;~     COLORREF *lpCustColors;
;~     DWORD Flags;
;~     LPARAM lCustData;
;~     LPCCHOOKPROC lpfnHook;
;~     LPCTSTR lpTemplateName;
;~ } CHOOSECOLOR, *LPCHOOSECOLOR;
	Local $custcolors = "int[16]"
	Local $struct = "dword;int;int;int;ptr;dword;int;ptr;ptr"
	Local $p = DllStructCreate($struct)
	If @error Then
		;MsgBox(0,"","Error in DllStructCreate " & @error);
		SetError(-1)
		Return -1
	EndIf
	Local $cc = DllStructCreate($custcolors)
	If @error Then
		; MsgBox(0,"","Error in DllStructCreate " & @error);
		;        DllStructDelete ($p)
		SetError(-2)
		Return -1
	EndIf
	If ($i_refType == 1) Then
		$i_colorref = Int($i_colorref)
	ElseIf ($i_refType == 2) Then
		$i_colorref = Hex(String($i_colorref), 6)
		$i_colorref = '0x' & StringMid($i_colorref, 5, 2) & StringMid($i_colorref, 3, 2) & StringMid($i_colorref, 1, 2)
	EndIf
	DllStructSetData($p, 1, DllStructGetSize($p))
	DllStructSetData($p, 2, $h_wnd_owner)
	DllStructSetData($p, 4, $i_colorref)
	DllStructSetData($p, 5, DllStructGetPtr($cc))
	DllStructSetData($p, 6, BitOR($CC_ANYCOLOR, $CC_FULLOPEN, $CC_RGBINIT))
	Local $ret = DllCall("comdlg32.dll", "long", "ChooseColor", "ptr", DllStructGetPtr($p))
	If ($ret[0] == 0) Then
		; user selected cancel or struct settings incorrect
		;        DllStructDelete ($p)
		;        DllStructDelete ($cc)
		SetError(-3)
		Return -1
	EndIf
	Local $color_picked = DllStructGetData($p, 4)
	;    DllStructDelete ($p)
	;    DllStructDelete ($cc)
	If ($i_ReturnType == 1) Then
		; return Hex BGR Color
		Return '0x' & Hex(String($color_picked), 6)
	ElseIf ($i_ReturnType == 2) Then
		; return Hex RGB Color
		$color_picked = Hex(String($color_picked), 6)
		Return '0x' & StringMid($color_picked, 5, 2) & StringMid($color_picked, 3, 2) & StringMid($color_picked, 1, 2)
	ElseIf ($i_ReturnType == 0) Then
		Return $color_picked
	Else
		SetError(-4)
		Return -1
	EndIf
EndFunc   ;==>_ChooseColor
;===============================================================================
;
; Description:			_ChooseFont
; Parameter(s):		$s_FontName - Optional: Default font name
;							$i_size - Optional: pointsize of font
;							$i_colorref - Optional: COLORREF rgbColors
;							$i_FontWeight - Optional: Font Weight
;							$i_Italic - Optional: Italic
;							$i_Underline - Optional: Underline
;							$i_Strikethru - Optional: Strikethru
;							$h_wnd_owner - Optional: Handle of owner window
; Requirement:			None.
; Return Value(s):	Returns Array, $array[0] contains the number of elements
;							if error occurs, @error is set
; User CallTip:		_ChooseFont([$s_FontName = "Courier New"[, $i_size = 10[, $i_colorref = 0[, $i_FontWeight = 0[, $i_Italic= 0[, $i_Underline = [0, $i_Strikethru = 0[, $h_wnd_owner]]]]]]]) Creates a Font dialog box that enables the user to choose attributes for a logical font. (required: <Misc.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] - attributes = BitOr of italic:2, undeline:4, strikeout:8
;							$array[2] - fontname
;							$array[3] - font size = point size
;							$array[4] - font weight = = 0-1000
;							$array[5] - COLORREF rgbColors
;							$array[6] - Hex BGR Color
;							$array[7] - Hex RGB Color
;
;===============================================================================
Func _ChooseFont($s_FontName = "Courier New", $i_size = 10, $i_colorref = 0, $i_FontWeight = 0, $i_Italic = 0, $i_Underline = 0, $i_Strikethru = 0, $h_wnd_owner = 0)
;~ typedef struct {
;~     DWORD lStructSize;
;~     HWND hwndOwner;
;~     HDC hDC;
;~     LPLOGFONT lpLogFont;
;~     INT iPointSize;
;~     DWORD Flags;
;~     COLORREF rgbColors;
;~     LPARAM lCustData;
;~     LPCFHOOKPROC lpfnHook;
;~     LPCTSTR lpTemplateName;
;~     HINSTANCE hInstance;
;~     LPTSTR lpszStyle;
;~     WORD nFontType;
;~     INT nSizeMin;
;~     INT nSizeMax;
;~ } CHOOSEFONT, *LPCHOOSEFONT;
;~ typedef struct tagLOGFONT {
;~   LONG lfHeight;
;~   LONG lfWidth;
;~   LONG lfEscapement;
;~   LONG lfOrientation;
;~   LONG lfWeight;
;~   BYTE lfItalic;
;~   BYTE lfUnderline;
;~   BYTE lfStrikeOut;
;~   BYTE lfCharSet;
;~   BYTE lfOutPrecision;
;~   BYTE lfClipPrecision;
;~   BYTE lfQuality;
;~   BYTE lfPitchAndFamily;
;~   TCHAR lfFaceName[LF_FACESIZE]; 32 chars max
;~ } LOGFONT, *PLOGFONT;
	Local $ret = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", 0, "long", $LOGPIXELSX)
	If ($ret[0] == -1) Then
		SetError(-3)
		Return -1
	EndIf
	Local $lfHeight = Round(($i_size * $ret[2]) / 72, 0)
	Local $logfont = "int;int;int;int;int;byte;byte;byte;byte;byte;byte;byte;byte;char[32]"
	Local $struct = "dword;int;int;ptr;int;dword;int;int;ptr;ptr;int;ptr;dword;int;int"
	Local $p = DllStructCreate($struct)
	If @error Then
		;MsgBox(0,"","Error in DllStructCreate " & @error);
		SetError(-1)
		Return -1
	EndIf
	Local $lf = DllStructCreate($logfont)
	If @error Then
		; MsgBox(0,"","Error in DllStructCreate " & @error);
		;		DllStructDelete ($p)
		SetError(-2)
		Return -1
	EndIf
	DllStructSetData($p, 1, DllStructGetSize($p))
	DllStructSetData($p, 2, $h_wnd_owner)
	DllStructSetData($p, 4, DllStructGetPtr($lf))
	DllStructSetData($p, 5, $i_size)
	DllStructSetData($p, 6, BitOR($CF_SCREENFONTS, $CF_PRINTERFONTS, $CF_EFFECTS, $CF_INITTOLOGFONTSTRUCT, $CF_NOSCRIPTSEL))
	DllStructSetData($p, 7, $i_colorref)
	DllStructSetData($p, 13, 0)
	DllStructSetData($lf, 1, $lfHeight + 1)
	DllStructSetData($lf, 5, $i_FontWeight)
	DllStructSetData($lf, 6, $i_Italic)
	DllStructSetData($lf, 7, $i_Underline)
	DllStructSetData($lf, 8, $i_Strikethru)
	DllStructSetData($lf, 14, $s_FontName)
	$ret = DllCall("comdlg32.dll", "long", "ChooseFont", "ptr", DllStructGetPtr($p))
	If ($ret[0] == 0) Then
		; user selected cancel or struct settings incorrect
		;		DllStructDelete ($p)
		;		DllStructDelete ($lf)
		SetError(-3)
		Return -1
	EndIf
	Local $fontname = DllStructGetData($lf, 14)
	If (StringLen($fontname) == 0 And StringLen($s_FontName) > 0) Then
		$fontname = $s_FontName
	EndIf
	Local $italic = 0
	Local $underline = 0
	Local $strikeout = 0
	If (DllStructGetData($lf, 6)) Then
		$italic = 2
	EndIf
	If (DllStructGetData($lf, 7)) Then
		$underline = 4
	EndIf
	If (DllStructGetData($lf, 8)) Then
		$strikeout = 8
	EndIf
	Local $attributes = BitOR($italic, $underline, $strikeout)
	Local $size = DllStructGetData($p, 5) / 10
	Local $weight = DllStructGetData($lf, 5)
	Local $colorref = DllStructGetData($p, 7)
	;	DllStructDelete ($p)
	;	DllStructDelete ($lf)
	Local $color_picked = Hex(String($colorref), 6)
	Return StringSplit($attributes & "," & $fontname & "," & $size & "," & $weight & "," & $colorref & "," & '0x' & $color_picked & "," & '0x' & StringMid($color_picked, 5, 2) & StringMid($color_picked, 3, 2) & StringMid($color_picked, 1, 2), ",")
EndFunc   ;==>_ChooseFont
;===============================================================================
;
; Description:      Copy Files to Clipboard Like Explorer does
; Parameter(s):     $sFile      - Full Path to File(s)
;                   $sSeperator - Seperator for multiple Files, Default = '|'
; Requirement(s):   v3.1.1.122+
; Return Value(s):  On Success - True
;                   On Failure - False and
;									Sets @ERROR to:	1 - Unable to Open Clipboard
;													2 - Unable to Empty Cipboard
;													3 - GlobalAlloc Failed
;													4 - GlobalLock Failed
;													5 - Unable to Create H_DROP
;													6 - Unable to Update Clipboard
;													7 - Unable to Close Clipboard
;													8 - GlobalUnlock Failed
; Author(s):        Piccaso (Florian Fida)
; Note(s):
;
;===============================================================================
Func _ClipPutFile($sFile, $sSeperator = "|")
	Local $vDllCallTmp, $nGlobMemSize, $hGlobal, $DROPFILES, $i, $hLock
	Local $GMEM_MOVEABLE = 0x0002, $CF_HDROP = 15
	$sFile = $sFile & $sSeperator & $sSeperator
	$nGlobMemSize = StringLen($sFile) + 20 ; 20 = size of DROPFILES whitout buffer
	$vDllCallTmp = DllCall("user32.dll", "int", "OpenClipboard", "hwnd", 0)
	If @error Or $vDllCallTmp[0] = 0 Then
		SetError(1)
		Return False
	EndIf
	$vDllCallTmp = DllCall("user32.dll", "int", "EmptyClipboard")
	If @error Or $vDllCallTmp[0] = 0 Then
		SetError(2)
		Return False
	EndIf
	$vDllCallTmp = DllCall("kernel32.dll", "long", "GlobalAlloc", "int", $GMEM_MOVEABLE, "int", $nGlobMemSize)
	If @error Or $vDllCallTmp[0] < 1 Then
		SetError(3)
		Return False
	EndIf
	$hGlobal = $vDllCallTmp[0]
	$vDllCallTmp = DllCall("kernel32.dll", "long", "GlobalLock", "long", $hGlobal)
	If @error Or $vDllCallTmp[0] < 1 Then
		SetError(4)
		Return False
	EndIf
	$hLock = $vDllCallTmp[0]
	$DROPFILES = DllStructCreate("dword;ptr;int;int;int;char[" & StringLen($sFile) & "]", $hLock)
	If @error Then
		SetError(5)
		Return False
	EndIf
	DllStructSetData($DROPFILES, 1, DllStructGetSize($DROPFILES) - StringLen($sFile))
	DllStructSetData($DROPFILES, 2, 0)
	DllStructSetData($DROPFILES, 3, 0)
	DllStructSetData($DROPFILES, 4, 0)
	DllStructSetData($DROPFILES, 5, 0)
	DllStructSetData($DROPFILES, 6, $sFile)
	For $i = 1 To StringLen($sFile)
		If DllStructGetData($DROPFILES, 6, $i) = Asc($sSeperator) Then DllStructSetData($DROPFILES, 6, 0, $i)
	Next
	$vDllCallTmp = DllCall("user32.dll", "long", "SetClipboardData", "int", $CF_HDROP, "long", $hGlobal)
	If @error Or $vDllCallTmp[0] < 1 Then
		SetError(6)
		$DROPFILES = 0
		Return False
	EndIf
	$vDllCallTmp = DllCall("user32.dll", "int", "CloseClipboard")
	If @error Or $vDllCallTmp[0] = 0 Then
		SetError(7)
		$DROPFILES = 0
		Return False
	EndIf
	$vDllCallTmp = DllCall("kernel32.dll", "int", "GlobalUnlock", "long", $hGlobal)
	If @error Then
		SetError(8)
		$DROPFILES = 0
		Return False
	EndIf
	$vDllCallTmp = DllCall("kernel32.dll", "int", "GetLastError")
	If $vDllCallTmp = 0 Then
		$DROPFILES = 0
		SetError(8)
		Return False
	Else
		$DROPFILES = 0
		Return True
	EndIf
EndFunc   ;==>_ClipPutFile
;
;===============================================================================
;
; Function Name:    _Iif()
; Description:      Perform a boolean test within an expression.
; Parameter(s):     $f_Test     - Boolean test.
;                   $v_TrueVal  - Value to return if $f_Test is true.
;                   $v_FalseVal - Value to return if $f_Test is false.
; Requirement(s):   None.
; Return Value(s):  One of $v_TrueVal or $v_FalseVal.
; Author(s):        Dale (Klaatu) Thompson
;
;===============================================================================
Func _Iif($f_Test, $v_TrueVal, $v_FalseVal)
	If $f_Test Then
		Return $v_TrueVal
	Else
		Return $v_FalseVal
	EndIf
EndFunc   ;==>_Iif
;===============================================================================
;
; Description:    _MouseTrap
; Parameter(s):	$i_left - Left coord
;                 $i_top - Top coord
;                 $i_right - Right coord
;                 $i_bottom - Bottom coord
; User CallTip:   _MouseTrap([$i_left = 0[, $i_top = 0[, $i_right = 0[, $i_bottom = 0]]]]) Confine the Mouse Cursor to specified coords. (required: <Misc.au3>)
; Author(s):      Gary Frost (custompcs at charter dot net)
; Note(s):        Use _MouseTrap() with no params to release the Mouse Cursor
;
;===============================================================================
Func _MouseTrap($i_left = 0, $i_top = 0, $i_right = 0, $i_bottom = 0)
	Local $av_ret
	If @NumParams == 0 Then
		$av_ret = DllCall("user32.dll", "int", "ClipCursor", "int", 0)
	Else
		If @NumParams == 2 Then
			$i_right = $i_left + 1
			$i_bottom = $i_top + 1
		EndIf
		Local $Rect = DllStructCreate("int;int;int;int")
		If @error Then Return 0
		DllStructSetData($Rect, 1, $i_left)
		DllStructSetData($Rect, 2, $i_top)
		DllStructSetData($Rect, 3, $i_right)
		DllStructSetData($Rect, 4, $i_bottom)
		$av_ret = DllCall("user32.dll", "int", "ClipCursor", "ptr", DllStructGetPtr($Rect))
		;		DllStructDelete($Rect)
	EndIf
	Return $av_ret[0]
EndFunc   ;==>_MouseTrap
;===============================================================================
;
; Description:    _Singleton
; Parameter(s):	$occurenceName
;               $flag
; User CallTip:   _Singleton($occurenceName [,$flag = 0]) Check if no other occurence is running. (required: <Misc.au3>)
; Return Value(s):  if $flag = 1
; Author(s):      Valik
;
;===============================================================================
Func _Singleton($occurenceName, $flag = 0)
	Local $ERROR_ALREADY_EXISTS = 183
	$occurenceName = StringReplace($occurenceName, "\", "") ; to avoid error
	;    Local $handle = DllCall("kernel32.dll", "int", "CreateSemaphore", "int", 0, "long", 1, "long", 1, "str", $occurenceName)
	Local $handle = DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $occurenceName)
	Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If $flag = 0 Then
			Exit -1
		Else
			SetError($lastError[0])
			Return 0
		EndIf
	EndIf
	Return $handle[0]
EndFunc   ;==>_Singleton
;
;===============================================================================
;
; Description:    _IsPressed
; Parameter(s):	$s_hexKey - key to check for
;						$v_dll = Handle to dll or default to user32.dll
;
; User CallTip:   _IsPressed($s_hexKey[, $v_dll = 'user32.dll']) Check if key has been pressed. (required: <Misc.au3>)
; Return Value(s):  1 if true
;							0 if false
; Author(s):      ezzetabi and Jon
;
;===============================================================================
Func _IsPressed($s_hexKey, $v_dll = 'user32.dll')
	; $hexKey must be the value of one of the keys.
	; _Is_Key_Pressed will return 0 if the key is not pressed, 1 if it is.
	Local $a_R = DllCall($v_dll, "int", "GetAsyncKeyState", "int", '0x' & $s_hexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc   ;==>_IsPressed
;
;===============================================================================
;
; Description:    _SendMessage
; Parameter(s): hwnd - window/control handle
;                  msg    - message to send to control (number)
;                  wParam - Specifies additional message-specific information (Optional: Default 0)
;                  lParam - Specifies additional message-specific information (Optional: Default 0)
;                  return - what to return (Optional: Default 0)
;                  wParam Type    - Specifies what type of additional information (Optional: Default "int")
;                  lParam Type    - Specifies what type of additional information (Optional: Default "int")
;
; User CallTip:   _SendMessage(hWnd, msg[, wParam = 0[, lParam = 0[, return = 0[, wParam Type = "int"[, lParam Type = "int"]]]]]) Wrapper for commonly used Dll Call. (required: <Misc.au3>)
; Return Value(s):
;    Success - User selected value from the DllCall() result.
;                     return = 0 thru 4 corresponds to the parameter of the _SendMessage Wrapper
;                     return < 0 or > 4 returns array same as DllCall
;    Failure - Sets @error if DllCall() fails.
; Author(s):      Valik
;
;===============================================================================
Func _SendMessage($h_hWnd, $i_msg, $wParam = 0, $lParam = 0, $i_r = 0, $s_t1 = "int", $s_t2 = "int")
	Local $a_ret = DllCall("user32.dll", "long", "SendMessage", "hwnd", $h_hWnd, "int", $i_msg, $s_t1, $wParam, $s_t2, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $i_r >= 0 And $i_r <= 4 Then Return $a_ret[$i_r]
	Return $a_ret
EndFunc   ;==>_SendMessage

;===============================================================================
;
; Description:    _IsClassName
; Parameter(s): 	 $h_hWnd - control ID/Handle
;
; User CallTip:   _IsClassName($h_hWnd, $s_ClassName) Check ClassName of the control. (required: <Misc.au3>)
; Return Value(s):
;    Success - 1.
;    Failure - Sets @error and returns 0.
; Author(s):			Gary Frost (custompcs at charter dot net)
;
;===============================================================================
Func _IsClassName($h_hWnd, $s_ClassName)
	If Not IsHWnd($h_hWnd) Then $h_hWnd = GUICtrlGetHandle($h_hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetClassNameA", "hwnd", $h_hWnd, "str", "", "int", 256)
	If @error Then Return SetError(@error, @error, "")
	If IsArray($aResult) Then
		If StringUpper(StringMid($aResult[2], 1, StringLen($s_ClassName))) = StringUpper($s_ClassName) Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return SetError(-1, -1, 0)
	EndIf
EndFunc   ;==>_IsClassName

; ===================================================================
; 
; Description:    _VersionCompare
; Parameters:
;	$sVersion1 - IN - The first version.
;	$sVersion2 - IN - The second version.
;
; User CallTip:   _VersionCompare($sVersion1, $sVersion2) Compares two file versions for equality. (required: <Misc.au3>)
; Return Value(s):
;	Success - 0 - Both versions equal
;		      1 - Version 1 greater
;		     -1 - Version 2 greater.
;		          @extended can be set as follows:  0 - Numeric comparison; 1 - String comparison
;	Failure - @error will be set in the event of a catasrophic error.
; Author(s):      Valik
; Note(s):        This will try to use a numerical comparison but fall back on
;	              a lexicographical comparison.  See @extended for details about which type was performed.
;
; ===================================================================
Func _VersionCompare($sVersion1, $sVersion2)
	If $sVersion1 = $sVersion2 Then Return 0
	Local $sep = "."
	If StringInstr($sVersion1, $sep) = 0 Then $sep = ","
	Local $aVersion1 = StringSplit($sVersion1, $sep)
	Local $aVersion2 = StringSplit($sVersion2, $sep)
	If UBound($aVersion1) <> UBound($aVersion2) Or UBound($aVersion1) = 0 Then
		; Compare as strings
		SetExtended(1)
		If $sVersion1 > $sVersion2 Then
			Return 1
		ElseIf $sVersion1 < $sVersion2 Then
			Return -1
		EndIf
	Else
		For $i = 1 To UBound($aVersion1)-1
			; Compare this segment as numbers
			If StringIsDigit($aVersion1[$i]) And StringIsDigit($aVersion2[$i]) Then
				If Number($aVersion1[$i]) > Number($aVersion2[$i]) Then
					Return 1
				ElseIf Number($aVersion1[$i]) < Number($aVersion2[$i]) Then
					Return -1
				EndIf
			Else	; Compare the segment as strings
				SetExtended(1)
				If $aVersion1[$i] > $aVersion2[$i] Then
					Return 1
				ElseIf $aVersion1[$i] < $aVersion2[$i] Then
					Return -1
				EndIf
			EndIf
		Next
	EndIf
	; This point should never be reached
	SetError(2)
	Return 0
EndFunc	; _VersionCompare()
