#include-once
#include <GUIConstants.au3>
#include <Misc.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with SysIPAddress32.
;
; ------------------------------------------------------------------------------

Global Const $WM_SETFONT = 0x30

; font weight
Global Const $FW_DONTCARE = 0
Global Const $FW_THIN = 100
Global Const $FW_EXTRALIGHT = 200
Global Const $FW_ULTRALIGHT = 200
Global Const $FW_LIGHT = 300
Global Const $FW_NORMAL = 400
Global Const $FW_REGULAR = 400
Global Const $FW_MEDIUM = 500
Global Const $FW_SEMIBOLD = 600
Global Const $FW_DEMIBOLD = 600
Global Const $FW_BOLD = 700
Global Const $FW_EXTRABOLD = 800
Global Const $FW_ULTRABOLD = 800
Global Const $FW_HEAVY = 900
Global Const $FW_BLACK = 900

;~ lfItalic
;~ Specifies an italic font if set to TRUE.
;~ lfUnderline
;~ Specifies an underlined font if set to TRUE.
;~ lfStrikeOut
;~ Specifies a strikeout font if set to TRUE.

Global Const $PROOF_QUALITY = 2

Global Const $IPM_CLEARADDRESS = ($WM_USER + 100)
Global Const $IPM_SETADDRESS = ($WM_USER + 101)
Global Const $IPM_GETADDRESS = ($WM_USER + 102)
Global Const $IPM_SETRANGE = ($WM_USER + 103)
Global Const $IPM_SETFOCUS = ($WM_USER + 104)
Global Const $IPM_ISBLANK = ($WM_USER + 105)

Global Const $IPN_FIRST = (-860)
Global Const $IPN_FIELDCHANGED = ($IPN_FIRST - 0)

Global Const $ICC_INTERNET_CLASSES = 0x800

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressCreate
; Description::		Create a GUI IP Address Control
; Parameter(s):		hwnd		- handle to a gui window
;							left		- The left side of the control
;							top		- The top of the control
;							width		- The width of the control
;							height	- The height of the control
;							style		- [optional] defines the style of the control
;										default (-1): none
;										forced styles : $WS_CHILD, $WS_VISIBLE, $WS_TABSTOP
;							exstyles	- [optional] Defines the extended style of the control
;										default (-1): none
; Requirement(s):		none
; Return Value(s):	handle to the control
; User CallTip:		_GUICtrlIpAddressCreate(hwnd, left, top, width, height[, style[, exstyles]]) Create a GUI IP Address Control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressCreate($h_Gui, $i_x, $i_y, $i_width, $i_heigth, $v_styles = -1, $v_exstyles = -1)
	Local $h_IPAddress, $style
	If $v_exstyles = -1 Then $v_exstyles = 0
	If Not IsHWnd($h_Gui) Then $h_Gui = HWnd($h_Gui)
	$style = BitOR($WS_CHILD, $WS_VISIBLE, $WS_TABSTOP)
	If $v_styles <> -1 Then $style = BitOR($style, $v_styles)
	Local $stICCE = DllStructCreate('dword;dword')
	DllStructSetData($stICCE, 1, DllStructGetSize($stICCE))
	DllStructSetData($stICCE, 2, $ICC_INTERNET_CLASSES)
	DllCall('comctl32.dll', 'int', 'InitCommonControlsEx', 'ptr', DllStructGetPtr($stICCE))
	
	$h_IPAddress = DllCall("user32.dll", "long", "CreateWindowEx", "long", $v_exstyles, _
			"str", "SysIPAddress32", "str", "", _
			"long", $style, "long", $i_x, "long", $i_y, "long", $i_width, "long", $i_heigth, _
			"hwnd", $h_Gui, "long", 0, "hwnd", $h_Gui, "long", 0)
	
	If Not @error Then
		Return HWnd($h_IPAddress[0])
	Else
		SetError(1)
	EndIf
	
	Return 0
EndFunc   ;==>_GUICtrlIpAddressCreate

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressClear
; Description::		Clears the contents of the IP address control
; Parameter(s):		hwnd		- handle to a GUI IP Address control
; Requirement(s):		none
; Return Value(s):	none
; User CallTip:		_GUICtrlIpAddressClear(hwnd) Clears the contents of the IP address control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressClear($h_IPAddress)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	_SendMessage($h_IPAddress, $IPM_CLEARADDRESS)
EndFunc   ;==>_GUICtrlIpAddressClear

;===============================================================================
;
; Description:       _GUICtrlIpAddressDelete
; Parameter(s):      hwnd    -    Handle to statusbar
; Requirement:
; Return Value(s):   If the function succeeds, the return value is nonzero
;                    If the function fails, the return value is zero
; User CallTip:      _GUICtrlIpAddressDelete(hwnd) Deletes the IpAddress control. (required: <GuiIPAddress.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlIpAddressDelete($h_IPAddress)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	Local $v_ret = DllCall("user32.dll", "int", "DestroyWindow", "hwnd", HWnd($h_IPAddress))
	If Not @error Then Return $v_ret
	Return SetError(1, 1, 0)
EndFunc   ;==>_GUICtrlIpAddressDelete

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressGet
; Description::		Retrieves the address values for all four fields in the IP address control
; Parameter(s):		hwnd		- handle to a GUI IP Address control
; Requirement(s):		none
; Return Value(s):	string containing the ip address from the control
; User CallTip:		_GUICtrlIpAddressGet(hwnd) Retrieves the address values for all four fields in the IP address control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
Func _GUICtrlIpAddressGet($h_IPAddress)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, "")
	Local $dwIP, $ret
	$dwIP = DllStructCreate("ubyte;ubyte;ubyte;ubyte")
	If @error Then Return SetError(1, 1, "")
	_SendMessage($h_IPAddress, $IPM_GETADDRESS, 0, DllStructGetPtr($dwIP), 0, "int", "ptr")
	If @error Then Return SetError(2, 2, "")
	$ret = StringFormat("%d.%d.%d.%d", DllStructGetData($dwIP, 4), _
			DllStructGetData($dwIP, 3), _
			DllStructGetData($dwIP, 2), _
			DllStructGetData($dwIP, 1))
	Return $ret
EndFunc   ;==>_GUICtrlIpAddressGet

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressIsBlank
; Description::		Determines if all fields in the IP address control are blank
; Parameter(s):		hwnd		- handle to a GUI IP Address control
; Requirement(s):		none
; Return Value(s):	Returns nonzero if all fields are blank, or zero otherwise
; User CallTip:		_GUICtrlIpAddressIsBlank(hwnd) Determines if all fields in the IP address control are blank (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressIsBlank($h_IPAddress)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	Local $lResult = _SendMessage($h_IPAddress, $IPM_ISBLANK)
	If Not @error Then
		Return $lResult
	Else
		Return SetError(1, 1, 0)
	EndIf
EndFunc   ;==>_GUICtrlIpAddressIsBlank

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressSet
; Description::		Sets the address values for all four fields in the IP address control
; Parameter(s):		hwnd		- handle to a GUI IP Address control
;							ip			- string containing new ip address for the control
; Requirement(s):		none
; Return Value(s):	none
; User CallTip:		_GUICtrlIpAddressSet(hwnd, ip) Sets the address values for all four fields in the IP address control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressSet($h_IPAddress, $s_address)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	Local $a_address = StringSplit($s_address, ".")
	If $a_address[0] = 4 Then _SendMessage($h_IPAddress, $IPM_SETADDRESS, 0, _MakeIP(_MakeWord($a_address[4], $a_address[3]), _MakeWord($a_address[2], $a_address[1])))
EndFunc   ;==>_GUICtrlIpAddressSet

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressSetFocus
; Description::		Sets the keyboard focus to the specified field in the IP address control.
;							All of the text in that field will be selected.
; Parameter(s):		hwnd		- handle to a GUI IP Address control
;							field		- Zero-based field index to which the focus should be set.
;										- If this value is greater than the number of fields,
;										- focus is set to the first blank field. If all fields are nonblank,
;										- focus is set to the first field.
; Requirement(s):		none
; Return Value(s):	none
; User CallTip:		_GUICtrlIpAddressSetFocus(hwnd, field) Sets the keyboard focus to the specified field in the IP address control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressSetFocus($h_IPAddress, $i_index)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	_SendMessage($h_IPAddress, $IPM_SETFOCUS, $i_index)
EndFunc   ;==>_GUICtrlIpAddressSetFocus

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressSetRange
; Description::		Sets the valid range for the specified field in the IP address control
; Parameter(s):		hwnd		- handle to a GUI IP Address control
;							field		- Zero-based field index to which the range will be applied
;							low		- [optional] value that contains the lower limit of the range
;										default (0)
;							high		- [optional] value that contains the upper limit of the range
;										default (255)
; Requirement(s):		none
; Return Value(s):	Returns nonzero if successful, or zero otherwise
; User CallTip:		_GUICtrlIpAddressSetRange(hwnd, field[, low[, high]]) Sets the valid range for the specified field in the IP address control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressSetRange($h_IPAddress, $i_index, $i_low_range = 0, $i_high_range = 255)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	If $i_low_range < 0 Or $i_low_range > $i_high_range Then
		Return SetError(1, 1, 0)
	ElseIf $i_high_range > 255 Then
		Return SetError(2, 2, 0)
	ElseIf $i_index < 0 Or $i_index > 3 Then
		Return SetError(3, 3, 0)
	EndIf
	Local $lResult = _SendMessage($h_IPAddress, $IPM_SETRANGE, $i_index, _MakeWord($i_low_range, $i_high_range))
	If Not @error Then
		Return $lResult
	Else
		Return SetError(4, 4, 0)
	EndIf
EndFunc   ;==>_GUICtrlIpAddressSetRange

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressShowHide
; Description::		Shows/Hides the IP address control
; Parameter(s):		hwnd		- handle to a GUI IP Address control
;							state		- @SW_SHOW/@SW_HIDE
; Requirement(s):		none
; Return Value(s):	If the control was previously visible, the return value is nonzero.
;							If the control was previously hidden, the return value is zero.
; User CallTip:		_GUICtrlIpAddressShowHide(hwnd, state) Sets the IP address control show state (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressShowHide($h_IPAddress, $i_state)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	If $i_state <> @SW_HIDE And $i_state <> @SW_SHOW Then Return SetError(1, 1, 0)
	Local $v_ret = DllCall("user32.dll", "int", "ShowWindow", "hwnd", $h_IPAddress, "int", $i_state)
	If Not @error And IsArray($v_ret) Then Return $v_ret[0]
	Return SetError(2, 2, 0)
EndFunc   ;==>_GUICtrlIpAddressShowHide

;===============================================================================
;
; Function Name:		_GUICtrlIpAddressSetFont
; Description::		Set the font for the control
; Parameter(s):		hwnd		- handle to a GUI IP Address control
;							Name		- Optional: The Font Name of the font to use (Default: Arial)
;							Size		- Optional: The Font Size (Default: 10)
;							Weight	- Optional: The Font Weight (Default: 400 = normal)
;							Italic	- Optional: Use Italic Attribute (Default: False)
; Requirement(s):		none
; Return Value(s):	None
;							If the control was previously hidden, the return value is zero.
; User CallTip:		_GUICtrlIpAddressSetFont(hwnd [, Name = "Arial"[, Size = 10[, Weight = 400[, Italic = False]]]]) Sets the Font for the IP address control (required: <GuiIPAddress.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
;
Func _GUICtrlIpAddressSetFont($h_IPAddress, $FontName = "Arial", $FontSize = 10, $FontWeight = 400, $FontItalic = False)
	If Not IsHWnd($h_IPAddress) Then $h_IPAddress = HWnd($h_IPAddress)
	If Not _IsClassName ($h_IPAddress, "SysIPAddress32") Then Return SetError(-1, -1, 0)
	Local $ret = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", 0, "long", $LOGPIXELSX)
	If ($ret[0] == -1) Then Return SetError(3, 3, 5)
	Local $lfHeight = Round(($FontSize * $ret[2]) / 72, 0)
	Local $font = DllStructCreate("int;int;int;int;int;byte;byte;byte;byte;byte;byte;byte;byte;char[32]")
	DllStructSetData($font, 1, $lfHeight + 1)
	DllStructSetData($font, 5, $FontWeight)
	DllStructSetData($font, 6, $FontItalic)
	DllStructSetData($font, 7, False) ; font underline
	DllStructSetData($font, 8, False) ; font strikethru
	DllStructSetData($font, 12, $PROOF_QUALITY)
	DllStructSetData($font, 14, $FontName)
	$ret = DllCall("gdi32.dll", "long", "CreateFontIndirect", "long", DllStructGetPtr($font))
	If IsArray($ret) And Not @error Then
		If $ret[0] Then _SendMessage($h_IPAddress, $WM_SETFONT, $ret[0], True, 0, "long", "int")
	EndIf
	
EndFunc   ;==>_GUICtrlIpAddressSetFont

;===============================================================================
; the following functions are for internal use
;===============================================================================
Func _HiWord($x)
	Return BitShift($x, 16)
EndFunc   ;==>_HiWord

Func _LoWord($x)
	Return BitAND($x, 0xFFFF)
EndFunc   ;==>_LoWord

Func _MakeIP($HiWord, $LoWord)
	Return BitOR($LoWord * 0x10000, BitAND($HiWord, 0xFFFF))
EndFunc   ;==>_MakeIP

Func _MakeWord($LoByte, $HiByte)
	Return BitOR($LoByte, 0x100 * $HiByte)
EndFunc   ;==>_MakeWord