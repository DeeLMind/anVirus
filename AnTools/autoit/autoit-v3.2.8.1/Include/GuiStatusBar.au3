#include-once
#include <Array.au3>
#include <Misc.au3>
#include <Memory.au3>
#include <StatusBarConstants.au3>
#include <WindowsConstants.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with the Statusbar control
;
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; These functions use some code developed by Paul Campbell (PaulIA) for the Auto3Lib project
; particularly the _Mem* function calls which can be found in Memory.au3
; ------------------------------------------------------------------------------

;=== Globals
Global $debug = True
Global Const $LowOrder = 0xFFFF
;=== End Globals

;=== function list
;===============================================================================
;_GUICtrlStatusBarCreate
;_GUICtrlStatusBarCreateProgress
;_GUICtrlStatusBarDelete
;_GUICtrlStatusBarGetBorders
;_GUICtrlStatusBarGetIcon
;_GUICtrlStatusBarGetParts
;_GUICtrlStatusBarGetRect
;_GUICtrlStatusBarGetText
;_GUICtrlStatusBarGetTextLength
;_GUICtrlStatusBarGetTip
;_GUICtrlStatusBarGetUnicode
;_GUICtrlStatusBarIsSimple
;_GUICtrlStatusBarResize
;_GUICtrlStatusBarSetBKColor
;_GUICtrlStatusBarSetIcon
;_GUICtrlStatusBarSetMinHeight
;_GUICtrlStatusBarSetParts
;_GUICtrlStatusBarSetSimple
;_GUICtrlStatusBarSetText
;_GUICtrlStatusBarSetTip
;_GUICtrlStatusBarSetUnicode
;_GUICtrlStatusBarShowHide
;**********Helper**************
;_CreateStructFromArray
;********** ToDo **************
;_GUICtrlStatusBarSetExtendedStyle

;===============================================================================
;
; Description:       _GUICtrlStatusBarCreate
; Parameter(s):      $h_Gui			-	Handle to parent window
;                    $v_PartWidth	-	width of part or parts (for more than 1 part pass in zero based array)
;                    v_PartText	-	text of part or parts (for more than 1 part pass in zero based array)
;							$v_styles		-	styles to apply to the status bar (Optional) for multiple styles bitor them.
; Requirement:
; Return Value(s):   Returns hWhnd if successful, or 0 with error set to 1 otherwise.
; User CallTip:      _GUICtrlStatusBarCreate($h_Gui, $a_PartWidth, $s_PartText[, $v_styles = ""]) Creates Statusbar. (required: <GuiStatusBar.au3>)
; Author(s):         rysiora, JdeB, tonedef,
;                    gafrost (Gary Frost (custompcs at charter dot net)), Steve Podhajecki <gehossafats at netmdc dot com>
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarCreate($h_Gui, $a_PartWidth, $s_PartText, $v_styles = "")
	Local $a_PW[1], $a_PT[1]
	If IsArray($a_PartWidth) Then
		$a_PW = $a_PartWidth
	Else
		$a_PW[0] = $a_PartWidth
	EndIf
	If IsArray($s_PartText) Then
		$a_PT = $s_PartText
	Else
		$a_PT[0] = $s_PartText
	EndIf
	If UBound($a_PW) <> UBound($a_PT) Then Return SetError(-1, -1, 0)
	If Not IsHWnd($h_Gui) Then $h_Gui = HWnd($h_Gui)
	Local $hwnd_Bar1, $x
	Local $style = BitOR($WS_CHILD, $WS_VISIBLE)
	If @NumParams = 4 Then $style = BitOR($style, $v_styles)

;~ 	$hwnd_Bar1 = DllCall("comctl32.dll", "long", "CreateStatusWindow", "long", $style, "str", "", "hwnd", $h_Gui, "int", 0)
	$hwnd_Bar1 = DllCall("user32.dll", "long", "CreateWindowEx", "long", 0, _
			"str", "msctls_statusbar32", "str", "", _
			"long", $style, "long", 0, "long", 0, "long", 0, "long", 0, _
			"hwnd", $h_Gui, "long", 0, "hwnd", $h_Gui, "long", 0)
	
	If @error Then Return SetError(1, 1, 0)
	_GUICtrlStatusBarSetParts($h_Gui, $hwnd_Bar1[0], UBound($a_PW), $a_PW)
	For $x = 0 To UBound($s_PartText) - 1
		_GUICtrlStatusBarSetText($hwnd_Bar1[0], $a_PT[$x], $x)
	Next
	
	Return HWnd($hwnd_Bar1[0])
EndFunc   ;==>_GUICtrlStatusBarCreate

;===============================================================================
;
; Description:       _GUICtrlStatusBarCreateProgress
; Parameter(s):      $h_StatusBar    -    Controld Id of status bar
;                    $i_Part        -    Optional: Part of the status bar to create the progress in (Default 0)
;                    $v_styles        -    Optional: Styles to apply to the progress bar for multiple styles bitor them.
; Requirement:
; Return Value(s):   Returns Control Id if successful, or if error is set to -1 and -1 is returned.
; User CallTip:      _GUICtrlStatusBarCreateProgress($h_StatusBar[, $i_Part = 0[, $v_styles = ""]]) Creates ProgressBar in Statusbar part. (required: <GuiStatusBar.au3>)
; Author(s):         eltorro, RagnaroktA,
;                    gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarCreateProgress($h_StatusBar, $i_Part, $v_styles = "")
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, -1)
	Local $i_pad = 2, $a_box[4], $v_ret
	If _GUICtrlStatusBarIsSimple($h_StatusBar) Then
		Local $i_parts = _GUICtrlStatusBarGetParts($h_StatusBar)
		_GUICtrlStatusBarSetSimple($h_StatusBar, False)
		$v_ret = _GUICtrlStatusBarGetRect($h_StatusBar, 0)
		$a_box[0] = $v_ret[0]; left
		$a_box[1] = $v_ret[1]; top
		$a_box[3] = $v_ret[3]; height
		$v_ret = _GUICtrlStatusBarGetRect($h_StatusBar, $i_parts - 1)
		$a_box[2] = $v_ret[2]; width
		_GUICtrlStatusBarSetSimple($h_StatusBar, True)
	Else
		If _GUICtrlStatusBarGetParts($h_StatusBar) - 1 < $i_Part Or $i_Part < 0 Then Return SetError(-1, -1, -1)
		$a_box = _GUICtrlStatusBarGetRect($h_StatusBar, $i_Part)
	EndIf
	; Shrink the rect a little to fit inside panel
	$a_box[0] = $a_box[0] + $i_pad; left
	$a_box[1] = $a_box[1] + $i_pad; top
	$a_box[2] = $a_box[2] - $a_box[0] - $i_pad; width
	$a_box[3] = $a_box[3] - $a_box[1] - $i_pad; height

	; Create the progress bar with the proper size.
	Local $Progress1 = GUICtrlCreateProgress($a_box[0], $a_box[1], $a_box[2], $a_box[3], $v_styles)
	GUICtrlSetResizing($Progress1, 802) ; dock all

	; Change progressbars parent to statusbar
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	Local $h_Progress = GUICtrlGetHandle($Progress1)
	$v_ret = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $h_Progress, "hwnd", $h_StatusBar)
	If Not IsHWnd($v_ret[0]) Then Return SetError(-1, -1, -1)

	Return $Progress1
EndFunc   ;==>_GUICtrlStatusBarCreateProgress

;===============================================================================
;
; Description:       _GUICtrlStatusBarDelete
; Parameter(s):      hwnd    -    Handle to statusbar
; Requirement:
; Return Value(s):   If the function succeeds, the return value is nonzero
;                    If the function fails, the return value is zero
; User CallTip:      _GUICtrlStatusBarDelete(hwnd) Deletes the StatusBar control. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarDelete($h_StatusBar)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Local $v_ret = DllCall("user32.dll", "int", "DestroyWindow", "hwnd", HWnd($h_StatusBar))
	If Not @error And IsArray($v_ret) Then Return $v_ret[0]
	Return SetError(1, 1, 0)
EndFunc   ;==>_GUICtrlStatusBarDelete

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetBorders
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
; Requirement:
; Return Value(s):   Returns zero based array
;                       0 - width of the horizontal border
;                       1 - width of the vertical border
;                       2 - width of the border between rectangles
;                    or zero otherwise.
; User CallTip:      _GUICtrlStatusBarGetBorders($h_StatusBar) Retrieves the current widths of the horizontal and vertical borders of a status window. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetBorders($h_StatusBar)
	Local $ret
	Local $borders_struct = DllStructCreate("int;int;int")
	Local $borders_struct_pointer = DllStructGetPtr($borders_struct)
	If @error Then Return SetError(@error, @error, 0)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Local $struct_MemMap
	Local $i_Size = DllStructGetSize($borders_struct)
	Local $Memory_pointer = _MemInit ($h_StatusBar, $i_Size, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	$ret = _SendMessage($h_StatusBar, $SB_GETBORDERS, 0, $Memory_pointer, 0, "int", "ptr")
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemRead ($struct_MemMap, $Memory_pointer, $borders_struct_pointer, $i_Size)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemFree ($struct_MemMap)
	If @error Then Return SetError(-1, -1, 0)
	If (Not $ret) Then
		Return SetError(-1, -1, 0)
	Else
		Local $a_borders[3], $x
		For $x = 0 To 2
			$a_borders[$x] = DllStructGetData($borders_struct, $x + 1)
		Next
		Return $a_borders
	EndIf
EndFunc   ;==>_GUICtrlStatusBarGetBorders

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetIcon
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;                    $i_Part            -    The part to hold the text
; Requirement:
; Return Value(s):   return hwnd or zero otherwise.
; User CallTip:      _GUICtrlStatusBarGetIcon($h_StatusBar[, $i_Part=0]) Retrieves the icon for a part in a status bar. (required: <GuiStatusBar.au3>)
; Author(s):         Steve Podhajecki <gehossafats at netmdc dotcom>, gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetIcon($h_StatusBar, $i_Part = 0)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Return _SendMessage($h_StatusBar, $SB_GETICON, $i_Part)
EndFunc   ;==>_GUICtrlStatusBarGetIcon

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetParts
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;
; Requirement:
; Return Value(s):   Returns the number of parts in the window, otherwise zero.
; User CallTip:      _GUICtrlStatusBarGetParts($h_StatusBar) Retrieves a count of the parts in a status window. (required: <GuiStatusBar.au3>)
; Author(s):         Steve Podhajecki <gehossafats at netmdc dot com>, gafrost (Gary Frost (custompcs at charter dot net))
;
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetParts($h_StatusBar)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Return _SendMessage($h_StatusBar, $SB_GETPARTS)
EndFunc   ;==>_GUICtrlStatusBarGetParts

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetRect
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $i_part         -    zero based index of part to retrieve rectangle from
; Requirement:
; Return Value(s):   Returns zero based array
;                       0 - Left
;                       1 - Top
;                       2 - Right
;                       3 - Bottom
;                    zero otherwise.
; User CallTip:      _GUICtrlStatusBarGetRect($StatusBar[, $i_part = 0]) Retrieves the bounding rectangle of a part in a status window. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetRect($h_StatusBar, $i_Part = 0)
;~     typedef struct _RECT {
;~       LONG left;
;~       LONG top;
;~       LONG right;
;~       LONG bottom;
;~     } RECT, *PRECT;
	Local $ret
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, -1)
	Local $RECT_struct = DllStructCreate("int;int;int;int")
	If @error Then Return SetError(-1, -1, 0)
	Local $RECT_struct_pointer = DllStructGetPtr($RECT_struct)
	If @error Then Return SetError(@error, @error, 0)
	Local $struct_MemMap
	Local $i_Size = DllStructGetSize($RECT_struct)
	Local $Memory_pointer = _MemInit ($h_StatusBar, $i_Size, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	$ret = _SendMessage($h_StatusBar, $SB_GETRECT, $i_Part, $Memory_pointer, 0, "int", "ptr")
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemRead ($struct_MemMap, $Memory_pointer, $RECT_struct_pointer, $i_Size)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemFree ($struct_MemMap)
	If @error Then Return SetError(-1, -1, 0)
	If Not $ret Then
		Return SetError(-1, -1, 0)
	Else
		Local $a_rect[4], $x
		For $x = 0 To 3
			$a_rect[$x] = DllStructGetData($RECT_struct, $x + 1)
		Next
		Return $a_rect
	EndIf
EndFunc   ;==>_GUICtrlStatusBarGetRect

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetText
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;                    $i_Part        -    The part to retreive the text from
; Requirement:
; Return Value(s):   Text from part
; User CallTip:      _GUICtrlStatusBarGetText($h_StatusBar[,$i_Part=0]) Retrieves the text from the specified part of a status window. (required: <GuiStatusBar.au3>)
; Author(s):         tonedef, gafrost (Gary Frost (custompcs at charter dot net)), Steve Podhajecki <gehossafats@netmdc.com>
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetText($h_StatusBar, $i_Part = 0)
	;== there is a built in function to use for this. See help documentation
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, "")
	Local $struct_String = DllStructCreate("char[4096]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $i_Size = DllStructGetSize($struct_String)
	Local $struct_MemMap
	Local $Memory_pointer = _MemInit ($h_StatusBar, $i_Size + 4096, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf

;~ 	Local $v_ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_StatusBar, "int", $SB_GETTEXT, "int", $i_Part, "ptr", $Memory_pointer)
	_SendMessage($h_StatusBar, $SB_GETTEXT, $i_Part, $Memory_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	_MemRead ($struct_MemMap, $Memory_pointer, $sBuffer_pointer, 4096)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	_MemFree ($struct_MemMap)
	If @error Then Return SetError(-1, -1, "")
	Return DllStructGetData($struct_String, 1)
EndFunc   ;==>_GUICtrlStatusBarGetText

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetTextLength
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;                    $i_Part        -    Nubmer of the part to retrieve length from
;
; Requirement:
; Return Value(s):   Text Length
; User CallTip:      _GUICtrlStatusBarGetTextLength ($h_StatusBar[, $i_Part = 0]) Retrieves the length, in characters, of the text from the specified part of a status window. (required: <GuiStatusBar.au3>)
; Author(s):         Steve Podhajecki <gehossafats@netmdc.com>, gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetTextLength($h_StatusBar, $i_Part = 0)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_StatusBar, $SB_GETTEXTLENGTH, $i_Part)
EndFunc   ;==>_GUICtrlStatusBarGetTextLength

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetTip
; Parameter(s):      $h_StatusBar	-	The Control Id (will be converted to hWnd)
;                    $i_Part			-	The part to retreive the text from
; Requirement:
; Return Value(s):   Tip Text, on error empty string and @error is set to -1
; User CallTip:      _GUICtrlStatusBarGetTip($h_StatusBar[, $i_Part=0]) Retrieves the ToolTip text for a part in a status bar. (required: <GuiStatusBar.au3>)
; Author(s):         Steve Podhajecki <gehossafats@netmdc.com>, , gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):           The status bar must be created with the $SBT_TOOLTIPS style to enable ToolTips.
;===============================================================================
Func _GUICtrlStatusBarGetTip($h_StatusBar, $i_Part = 0)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, -1)
	Local $struct_String = DllStructCreate("char[255]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $i_Size = DllStructGetSize($struct_String)
	Local $wParam = (($i_Size * 0x10000) + $i_Part)
	Local $struct_MemMap
	Local $Memory_pointer = _MemInit ($h_StatusBar, $i_Size + 255, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf

;~ 	Local $v_ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_StatusBar, "int", $SB_GETTIPTEXT, "long", $wParam, "ptr", $Memory_pointer)
	_SendMessage($h_StatusBar, $SB_GETTIPTEXT, $wParam, $Memory_pointer, 0, "long", "ptr")
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	_MemRead ($struct_MemMap, $Memory_pointer, $sBuffer_pointer, 255)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	_MemFree ($struct_MemMap)
	If @error Then Return SetError(-1, -1, "")
	Return StringStripWS(DllStructGetData($struct_String, 1), 7);strip leading, trailing, and double ws.
EndFunc   ;==>_GUICtrlStatusBarGetTip

;===============================================================================
;
; Description:       _GUICtrlStatusBarGetUnicode
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;
; Requirement:
; Return Value(s):   If this value is nonzero, the control is using Unicode characters.
;                    If this value is zero, the control is using ANSI characters
; User CallTip:      _GUICtrlStatusBarGetUnicode ($h_StatusBar) Retrieves the Unicode character format flag for the control. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarGetUnicode($h_StatusBar)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Return _SendMessage($h_StatusBar, $SB_GETUNICODEFORMAT)
EndFunc   ;==>_GUICtrlStatusBarGetUnicode

;===============================================================================
;
; Description:       _GUICtrlStatusBarIsSimple
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
; Requirement:
; Return Value(s):   non zero	- if a simple statusbar
;							zero		- if not a simple statusbar
; User CallTip:      _GUICtrlStatusBarIsSimple($h_StatusBar) Checks a status bar control to determine if it is in simple mode. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarIsSimple($h_StatusBar)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Return _SendMessage($h_StatusBar, $SB_ISSIMPLE)
EndFunc   ;==>_GUICtrlStatusBarIsSimple

;===============================================================================
;
; Description:       _GUICtrlStatusBarResize
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;
; Requirement:
; Return Value(s):   If the function succeeds, the return value is nonzero, otherwise zero.
; User CallTip:      _GUICtrlStatusBarResize($h_StatusBar)    Resize Statusbar. (required: <GuiStatusBar.au3>)
; Author(s):         Steve Podhajecki <gehossafats@netmdc.com>
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarResize($h_StatusBar)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Local $ret = DllCall("user32.dll", "int", "MoveWindow", "hwnd", $h_StatusBar, "int", 0, "int", 0, "int", 0, "int", 0, "int", 1)
	If IsArray($ret) Then
		Return $ret[0]
	Else
		Return SetError(-1, -1, 0)
	EndIf
EndFunc   ;==>_GUICtrlStatusBarResize

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetBKColor
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $v_HexRGB       -    Hex RGB color to set Status Bar background
; Requirement:
; Return Value(s):   Returns the previous background color or zero upon failure
; User CallTip:      _GUICtrlStatusBarSetBKColor($h_StatusBar, $v_HexRGB) Sets the background color in a status bar. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarSetBKColor($h_StatusBar, $v_HexRGB)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Local Const $CLR_DEFAULT = 0xFF000000
	Local $tc, $ret
	If $v_HexRGB = $CLR_DEFAULT Then
		$ret = _SendMessage($h_StatusBar, $SB_SETBKCOLOR, 0, $CLR_DEFAULT)
	Else
		$tc = Hex(String($v_HexRGB), 6)
		$ret = _SendMessage($h_StatusBar, $SB_SETBKCOLOR, 0, '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2))
	EndIf
	If @error Then Return SetError(-1, -1, 0)
	If $ret = $CLR_DEFAULT Then Return $CLR_DEFAULT
	$tc = Hex(String($ret), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_GUICtrlStatusBarSetBKColor

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetIcon
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $i_part         -    Nubmer of part to add icon too
;                    $s_IconFile     -    file to extract icon from
;                    $i_iconID       -    id of the icon
; Requirement:
; Return Value(s):   Returns nonzero if successful, or zero otherwise.
; User CallTip:      _GUICtrlStatusBarSetIcon($StatusBar, $i_part, $szIconFile, $iconID) Sets the icon for a part in a status bar. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost ([email="custompcs at charter dot net"]custompcs at charter dot net[/email]))
; Note(s):    To remove the icon from a part use -1 for $i_iconID
;       If using simple status bar then set $i_part to 255
;===============================================================================
Func _GUICtrlStatusBarSetIcon($h_StatusBar, $i_Part, $s_IconFile = "", $i_iconID = -1)
	Local $hIcon, $result
	If $i_Part = 255 Then $i_Part = -1
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	If $i_iconID = -1 Then
		Return _SendMessage($h_StatusBar, $SB_SETICON, $i_Part, $i_iconID, 0, "int", "hwnd")
	Else
		$hIcon = DllStructCreate("int")
		$result = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $s_IconFile, "int", $i_iconID, "hwnd", 0, "ptr", DllStructGetPtr($hIcon), "int", 1)
		$result = $result[0]
		If $result > 0 Then $result = _SendMessage($h_StatusBar, $SB_SETICON, $i_Part, DllStructGetData($hIcon, 1), 0, "int", "hwnd")
		DllCall("user32.dll", "int", "DestroyIcon", "hwnd", DllStructGetPtr($hIcon, 1))
		$hIcon = 0
		Return $result
	EndIf
EndFunc   ;==>_GUICtrlStatusBarSetIcon

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetMinHeight
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $i_MinHeight    -    Minimum height, in pixels, of the window
; Requirement:
; Return Value(s):   None
; User CallTip:      _GUICtrlStatusBarSetMinHeight($h_StatusBar, $i_MinHeight) Sets the minimum height of a status window's drawing area. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarSetMinHeight($h_StatusBar, $i_MinHeight)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	_SendMessage($h_StatusBar, $SB_SETMINHEIGHT, $i_MinHeight)
	_GUICtrlStatusBarResize($h_StatusBar)
EndFunc   ;==>_GUICtrlStatusBarSetMinHeight

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetSimple
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $b_Simple       -    Display type flag.
;                        If this parameter is TRUE, the window displays simple text. (Default)
;                        If it is FALSE, it displays multiple parts
; Requirement:
; Return Value(s):   None
; User CallTip:      _GUICtrlStatusBarSetSimple($h_StatusBar[, $b_Simple = True]) Specifies whether a status window displays simple text or displays all window parts. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarSetSimple($h_StatusBar, $b_Simple = True)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	_SendMessage($h_StatusBar, $SB_SIMPLE, $b_Simple)
EndFunc   ;==>_GUICtrlStatusBarSetSimple

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetText
; Parameter(s):      $h_StatusBar    -    The Control Id (will be converted to hWnd)
;                    $s_Data         -    The text to display in the part
;                    $i_Part        -    The part to hold the text (Default: 0)
; Requirement:
; Return Value(s):   Returns TRUE if successful, or FALSE otherwise.
; User CallTip:      _GUICtrlStatusBarSetText($h_StatusBar[, $s_Data = ""[, $i_Part = 0]]) Sets the text in the specified part of a status window. (required: <GuiStatusBar.au3>)
; Author(s):         rysiora, JdeB, tonedef,
;                    gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):           Set $i_Part to 255 for simple statusbar
;===============================================================================
Func _GUICtrlStatusBarSetText($h_StatusBar, $s_Data = "", $i_Part = 0)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, False)
	Local $struct_String = DllStructCreate("char[" & StringLen($s_Data) + 1 & "]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $struct_MemMap
	Local $Memory_pointer = _MemInit ($h_StatusBar, StringLen($s_Data) + 1, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	DllStructSetData($struct_String, 1, $s_Data)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemWrite ($struct_MemMap, $sBuffer_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
;~ 	Local $ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_StatusBar, "int", $SB_SETTEXT, "long", $i_Part, "ptr", $Memory_pointer)
	Local $ret = _SendMessage($h_StatusBar, $SB_SETTEXT, $i_Part, $Memory_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemFree ($struct_MemMap)
	Return $ret
EndFunc   ;==>_GUICtrlStatusBarSetText

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetTip
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $i_part         -    Zero-based index of the part that will receive the ToolTip text
;                    $s_ToolTip      -    new ToolTip text
; Requirement:
; Return Value(s):   None
; User CallTip:      _GUICtrlStatusBarSetTip($h_StatusBar, $i_part, $s_ToolTip) Sets the ToolTip text for a part in a status bar. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarSetTip($h_StatusBar, $i_Part, $s_ToolTip)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	Local $struct_String = DllStructCreate("char[" & StringLen($s_ToolTip) + 1 & "]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $struct_MemMap
	Local $Memory_pointer = _MemInit ($h_StatusBar, StringLen($s_ToolTip) + 1, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	DllStructSetData($struct_String, 1, $s_ToolTip)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemWrite ($struct_MemMap, $sBuffer_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_SendMessage($h_StatusBar, $SB_SETTIPTEXT, $i_Part, $Memory_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, 0)
	EndIf
	_MemFree ($struct_MemMap)
EndFunc   ;==>_GUICtrlStatusBarSetTip

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetUnicode
; Parameter(s):      $h_StatusBar    -    Handle to statusbar
;                    $b_Unicode        -    Determines the character set that is used by the control.
;                        If this value is TRUE, the control will use Unicode characters. (Default)
;                        If this value is FALSE, the control will use ANSI characters.
; Requirement:
; Return Value(s):   Returns the previous Unicode format flag for the control
; User CallTip:      _GUICtrlStatusBarSetUnicode($h_StatusBar[, $b_Unicode = True[) Sets the Unicode character format flag for the control. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarSetUnicode($h_StatusBar, $b_Unicode = True)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, False)
	Return _SendMessage($h_StatusBar, $SB_SETUNICODEFORMAT, $b_Unicode)
EndFunc   ;==>_GUICtrlStatusBarSetUnicode

;===============================================================================
;
; Description:       _GUICtrlStatusBarShowHide
; Parameter(s):      hwnd		-	Handle to statusbar
;							state		-	@SW_SHOW/@SW_HIDE
; Requirement:
; Return Value(s):   If the window was previously visible, the return value is nonzero
;							If the window was previously hidden, the return value is zero
;                    If the function fails, the return value is zero
; User CallTip:      _GUICtrlStatusBarShowHide(hwnd, state) Show/Hide the StatusBar control. (required: <GuiStatusBar.au3>)
; Author(s):         gafrost (Gary Frost (custompcs at charter dot net))
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarShowHide($h_StatusBar, $i_state)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	If $i_state <> @SW_HIDE And $i_state <> @SW_SHOW Then Return SetError(1, 1, 0)
	Local $v_ret = DllCall("user32.dll", "int", "ShowWindow", "hwnd", HWnd($h_StatusBar), "int", $i_state)
	If Not @error And IsArray($v_ret) Then Return $v_ret[0]
	Return SetError(2, 2, 0)
EndFunc   ;==>_GUICtrlStatusBarShowHide

;===============================================================================
;
; Description:       _GUICtrlStatusBarSetParts
; Parameter(s):      $h_GUI 			-	Control Id of parent window
;							$h_StatusBar	-	The Control Id (will be converted to hWnd)
;                    $i_Parts		-	Nubmer of parts to create
;                    $v_PartWidth	-	width of part(s) (Default: 100, can be an array of widths)
;
; Requirement:
; Return Value(s):   1 if successfull, otherwise zero
; User CallTip:      _GUICtrlStatusBarSetParts ($h_GUI, $h_StatusBar, $i_Parts[, $v_PartWidth = 100]). Sets the number of parts in a status window and the coordinate of the right edge of each part (required: <GuiStatusBar.au3>)
; Author(s):         tonedef, gafrost (Gary Frost (custompcs at charter dot net)), Steve Podhajecki <gehossafats at netmdc dot com>
; Note(s):
;===============================================================================
Func _GUICtrlStatusBarSetParts($h_Gui, $h_StatusBar, $i_parts, $v_PartWidth = 100)
	Local $struct_parts
	
	If IsArray($i_parts) Then Return SetError(1, 1, 0)
	If $i_parts < 1 Then $i_parts = 1
	If IsArray($v_PartWidth) Then $i_parts = UBound($v_PartWidth)
	If Not IsHWnd($h_StatusBar) Then $h_StatusBar = HWnd($h_StatusBar)
	If Not _IsClassName ($h_StatusBar, "msctls_statusbar32") Then Return SetError(-1, -1, 0)
	;=== Set each part to be same size and assign the last one the remainder
	If Not IsArray($v_PartWidth) Then
		Local $a_tPartWidth[$i_parts], $part, $size
		$size = WinGetClientSize($h_Gui)
		For $part = 1 To $i_parts
			$a_tPartWidth[$part - 1] = Int(($size[0] / $i_parts) * $part + 1)
		Next
		$a_tPartWidth[$i_parts - 1] = -1
		$struct_parts = _CreateStuctFromArray($a_tPartWidth, "int")
		If @error Then Return SetError(1, 1, 0)
	Else
		$struct_parts = _CreateStuctFromArray($v_PartWidth, "int")
		If @error Then Return SetError(1, 1, 0)
	EndIf
	;== end set sizing
	Local $struct_parts_pointer = DllStructGetPtr($struct_parts)
	Local $struct_MemMap
	Local $i_Size = DllStructGetSize($struct_parts)
	Local $Memory_pointer = _MemInit ($h_StatusBar, $i_Size, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(1, 1, 0)
	EndIf
	_MemWrite ($struct_MemMap, $struct_parts_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(1, 1, 0)
	EndIf
	_SendMessage($h_StatusBar, $SB_SETPARTS, $i_parts, $Memory_pointer)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(1, 1, 0)
	EndIf
	_MemFree ($struct_MemMap)
	If @error Then Return SetError(1, 1, 0)
	_GUICtrlStatusBarResize($h_StatusBar)
	Return 1
EndFunc   ;==>_GUICtrlStatusBarSetParts

;===============================================================================
; Helper functions
;===============================================================================
;===============================================================================
;
; Description:       CreateStructFromArray
; Parameter(s):      $a_Variable array to create struct with
;                    $structType, the SINGLE type of struct to create.
; Requirement:
; Return Value(s):
; User CallTip:      _CreateStructFromArray
; Author(s):			Steve Podhajecki <gehossafats at netmdc dot com>
; Note(s):
;===============================================================================
Func _CreateStuctFromArray($a_Variable, $structType)
	If Not IsArray($a_Variable) Then Return SetError(1, 1, 0)
	Local $a_ctr, $strVar, $struct
;~ 	, $emsg[6]
	For $a_ctr = 0 To UBound($a_Variable) - 1
		$strVar &= $structType & ";"
	Next
	$strVar = StringTrimRight($strVar, 1)
;~ 	$emsg[0] = "No Error."
;~ 	$emsg[1] = "Variable passed to DllStructCreate was not a string."
;~ 	$emsg[2] = "There is an unknown Data Type in the string passed. "
;~ 	$emsg[3] = "Failed to allocate the memory needed for the struct, or Pointer = 0."
;~ 	$emsg[4] = "Error allocating memory for the passed string."
;~ 	$emsg[5] = ""
	
	$struct = DllStructCreate($strVar)
	If @error Then Return SetError(1, 1, 0)
	
;~ 	$emsg[0] = 'No Error. '
;~ 	$emsg[1] = 'Struct not a correct struct returned by DllStructCreate.'
;~ 	$emsg[2] = 'Element value out of range. '
;~ 	$emsg[3] = 'index would be outside of the struct.'
;~ 	$emsg[4] = 'Element data type is unknown'
;~ 	$emsg[5] = 'index < 0.'
	For $a_ctr = 0 To UBound($a_Variable) - 1
		DllStructSetData($struct, ($a_ctr) + 1, $a_Variable[$a_ctr])
		If @error Then Return SetError(1, 1, 0)
	Next
	Return $struct
EndFunc   ;==>_CreateStuctFromArray