#include-once
#include <ComboConstants.au3> ; needed for _GUICtrlComboAddDir
#include <Misc.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with ComboBox.
;
; ------------------------------------------------------------------------------


; function list
;===============================================================================
; _GUICtrlComboAddDir
; _GUICtrlComboAddString
; _GUICtrlComboDeleteString
; _GUICtrlComboFindString
; _GUICtrlComboGetCount
; _GUICtrlComboGetCurSel
; _GUICtrlComboGetDroppedControlRECT
; _GUICtrlComboGetDroppedState
; _GUICtrlComboGetDroppedWidth
; _GUICtrlComboGetEditSel
; _GUICtrlComboGetExtendedUI
; _GUICtrlComboGetHorizontalExtent
; _GUICtrlComboGetItemHeight
; _GUICtrlComboGetLBText
; _GUICtrlComboGetLBTextLen
; _GUICtrlComboGetLocale
; _GUICtrlComboGetMinVisible
; _GUICtrlComboGetTopIndex
; _GUICtrlComboInitStorage
; _GUICtrlComboInsertString
; _GUICtrlComboLimitText
; _GUICtrlComboResetContent
; _GUICtrlComboSelectString
; _GUICtrlComboSetCurSel
; _GUICtrlComboSetDroppedWidth
; _GUICtrlComboSetEditSel
; _GUICtrlComboSetExtendedUI
; _GUICtrlComboSetHorizontalExtent
; _GUICtrlComboSetItemHeight
; _GUICtrlComboSetMinVisible
; _GUICtrlComboSetTopIndex
; _GUICtrlComboShowDropDown
;
; ************** TODO ******************
; _GUICtrlComboGetComboBoxInfo
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlComboAddDir
; Parameter(s):		$h_combobox - control id
;							$s_Attributes - Comma-delimited string
;							$s_file - Optional for "Drives" only: what to get i.e *.*
; Requirement:			None
; Return Value(s):	zero-based index of the last name added to the list
;							If an error occurs, the return value is $CB_ERR.
;							If there is insufficient space to store the new strings, the return value is $CB_ERRSPACE
; User CallTip:		_GUICtrlComboAddDir($h_combobox, $s_Attributes[, $s_file=""]) Add names to the list displayed by the combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$s_Attributes is an comma-delimited string
; 							valid values are any of the following:
; 								A,D,H,RO,RW,S,E,Drives,NB
;							A = ARCHIVE
;								Includes archived files.
;							D = DIRECTORY
;								Includes subdirectories. Subdirectory names are enclosed in square brackets ([ ]).
;							H = HIDDEN
;								Includes hidden files.
;							RO = READONLY
;								Includes read-only files.
;							RW = READWRITE
;								Includes read-write files with no additional attributes. This is the default setting.
;							S = SYSTEM
;								Includes system files.
;							E = EXCLUSIVE
;								Includes only files with the specified attributes. By default, read-write files are listed even if READWRITE is not specified.
;							DRIVES
;								All mapped drives are added to the list. Drives are listed in the form [-x-], where x is the drive letter.
;							NB = No Brackets
;							   Drives are liste in the form x:, where x is the drive letter (used with Drives attribute)
;
;===============================================================================
Func _GUICtrlComboAddDir($h_combobox, $s_Attributes, $s_file = "")
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $i, $v_Attributes = "", $i_drives = 0, $no_brackets = 0
	Local $v_ret, $a_Attributes = StringSplit($s_Attributes, ",")
	For $i = 1 To $a_Attributes[0]
		Select
			Case StringUpper($a_Attributes[$i]) = "A"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_ARCHIVE
				Else
					$v_Attributes = $CB_DDL_ARCHIVE
				EndIf
			Case StringUpper($a_Attributes[$i]) = "D"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_DIRECTORY
				Else
					$v_Attributes = $CB_DDL_DIRECTORY
				EndIf
			Case StringUpper($a_Attributes[$i]) = "H"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_HIDDEN
				Else
					$v_Attributes = $CB_DDL_HIDDEN
				EndIf
			Case StringUpper($a_Attributes[$i]) = "RO"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_READONLY
				Else
					$v_Attributes = $CB_DDL_READONLY
				EndIf
			Case StringUpper($a_Attributes[$i]) = "RW"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_READWRITE
				Else
					$v_Attributes = $CB_DDL_READWRITE
				EndIf
			Case StringUpper($a_Attributes[$i]) = "S"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_SYSTEM
				Else
					$v_Attributes = $CB_DDL_SYSTEM
				EndIf
			Case StringUpper($a_Attributes[$i]) = "DRIVES"
				$i_drives = 1
				$s_file = ""
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_DRIVES
				Else
					$v_Attributes = $CB_DDL_DRIVES
				EndIf
			Case StringUpper($a_Attributes[$i]) = "E"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $CB_DDL_EXCLUSIVE
				Else
					$v_Attributes = $CB_DDL_EXCLUSIVE
				EndIf
			Case StringUpper($a_Attributes[$i]) = "NB"
				If (StringLen($v_Attributes) > 0) And StringInStr($s_Attributes, "DRIVES") Then
					$no_brackets = 1
				Else
					$no_brackets = 0
				EndIf
			Case Else
				; invalid attribute
				Return $CB_ERRATTRIBUTE
		EndSelect
	Next
	If (Not $i_drives And StringLen($s_file) == 0) Then Return $CB_ERRREQUIRED
	If $i_drives And $no_brackets Then
		Local $s_text
		Local $gui_no_brackets = GUICreate("no brackets")
		Local $combo_no_brackets = GUICtrlCreateCombo("", 70, 10, 270, 100, $CBS_SIMPLE)
		$v_ret = GUICtrlSendMsg($combo_no_brackets, $CB_DIR, $v_Attributes, $s_file)
		For $i = 0 To _GUICtrlComboGetCount($combo_no_brackets) - 1
			_GUICtrlComboGetLBText($combo_no_brackets, $i, $s_text)
			$s_text = StringReplace(StringReplace(StringReplace($s_text, "[", ""), "]", ":"), "-", "")
			_GUICtrlComboInsertString($h_combobox, -1, $s_text)
		Next
		GUIDelete($gui_no_brackets)
		Return $v_ret
	Else
		If IsHWnd($h_combobox) Then
			$v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_combobox, "int", $CB_DIR, "int", $v_Attributes, "str", $s_file)
			Return $v_ret[0]
		Else
			Return GUICtrlSendMsg($h_combobox, $CB_DIR, $v_Attributes, $s_file)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlComboAddDir

;===============================================================================
;
; Description:			_GUICtrlComboAddString
; Parameter(s):		$h_combobox - controlID
;							$s_text - String to add
; Requirement:			None
; Return Value(s):	The return value is the zero-based index to the string in the list box of the combo box.
;							If an error occurs, the return value is $CB_ERR.
;							If insufficient space is available to store the new string, it is $CB_ERRSPACE.
; User CallTip:		_GUICtrlComboAddString($h_combobox, $s_text) Add a string to the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the combo box does not have the CBS_SORT style,
;							the string is added to the end of the list.
;							Otherwise, the string is inserted into the list, and the list is sorted.
;
;===============================================================================
Func _GUICtrlComboAddString($h_combobox, $s_text)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_ADDSTRING, 0, $s_text, 0, "int", "str")
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_ADDSTRING, 0, String($s_text))
	EndIf
EndFunc   ;==>_GUICtrlComboAddString

;===============================================================================
;
; Description:			_GUICtrlComboAutoComplete
; Parameter(s):		$h_combobox - controlID
;							$s_text - String for comparing against the combo's input box
; Requirement:			Misc
; Return Value(s):	None
; User CallTip:		_GUICtrlComboAutoComplete($h_combobox, ByRef $s_text) AutoComplete a combo box input(required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlComboAutoComplete($h_combobox, ByRef $s_text, $s_WTitle = "", $s_WText = "")
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, 0)
	Local $ret, $s_inputtext, $s_data
	If _IsPressed('08') Then ;backspace pressed
		$s_text = GUICtrlRead($h_combobox)
	Else
		If IsHWnd($h_combobox) Then
			If $s_text <> ControlGetText($s_WTitle, $s_WText, $h_combobox) Then
				$s_data = ControlGetText($s_WTitle, $s_WText, $h_combobox)
				$ret = _GUICtrlComboFindString($h_combobox, $s_data)
				If ($ret <> $CB_ERR) Then
					_GUICtrlComboGetLBText($h_combobox, $ret, $s_inputtext)
					ControlSetText($s_WTitle, $s_WText, $h_combobox, $s_inputtext)
					_GUICtrlComboSetEditSel($h_combobox, StringLen($s_data), StringLen(ControlGetText($s_WTitle, $s_WText, $h_combobox)))
				EndIf
				$s_text = ControlGetText(WinGetTitle(""), "", $h_combobox)
			EndIf
		Else
			If $s_text <> GUICtrlRead($h_combobox) Then
				$s_data = GUICtrlRead($h_combobox)
				$ret = _GUICtrlComboFindString($h_combobox, $s_data)
				If ($ret <> $CB_ERR) Then
					_GUICtrlComboGetLBText($h_combobox, $ret, $s_inputtext)
					GUICtrlSetData($h_combobox, $s_inputtext)
					_GUICtrlComboSetEditSel($h_combobox, StringLen($s_data), StringLen(GUICtrlRead($h_combobox)))
				EndIf
				$s_text = GUICtrlRead($h_combobox)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlComboAutoComplete

;===============================================================================
;
; Description:			_GUICtrlComboDeleteString
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the string
; Requirement:			None
; Return Value(s):	The return value is a count of the strings remaining in the list.
;							If the $i_index parameter specifies an index greater than the number
;							of items in the list, the return value is $CB_ERR.
; User CallTip:		_GUICtrlComboDeleteString($h_combobox, $i_index) Delete a string in the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboDeleteString($h_combobox, $i_index)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_DELETESTRING, $i_index)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_DELETESTRING, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboDeleteString

;===============================================================================
;
; Description:			_GUICtrlComboFindString
; Parameter(s):		$h_combobox - controlID
;							$s_search - String to search for
;							$i_exact - Optional: Exact match or not
; Requirement:			None
; Return Value(s):	The return value is the zero-based index of the matching item.
;							If the search is unsuccessful, it is $CB_ERR.
; User CallTip:		_GUICtrlComboFindString($h_combobox, $s_search[, $i_exact=0]) Return the index of matching item (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_exact = 0 Search the list box of a combo box for an item beginning with
;											 the characters in a specified string
;							$i_exact <> 0 Find the first list box string in a combo box that matches
;											  the string specified in the $s_search parameter
;
;===============================================================================
Func _GUICtrlComboFindString($h_combobox, $s_search, $i_exact = 0)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		If ($i_exact) Then
			Return _SendMessage($h_combobox, $CB_FINDSTRINGEXACT, -1, $s_search, 0, "int", "str")
		Else
			Return _SendMessage($h_combobox, $CB_FINDSTRING, -1, $s_search, 0, "int", "str")
		EndIf
	Else
		If ($i_exact) Then
			Return GUICtrlSendMsg($h_combobox, $CB_FINDSTRINGEXACT, -1, String($s_search))
		Else
			Return GUICtrlSendMsg($h_combobox, $CB_FINDSTRING, -1, String($s_search))
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlComboFindString

;===============================================================================
;
; Description:			_GUICtrlComboGetCount
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	The return value is the number of items in the list box.
;							If an error occurs, it is $CB_ERR
; User CallTip:		_GUICtrlComboGetCount($h_combobox) Retrieve the number of items in the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The index is zero-based, so the returned count is one greater
;							than the index value of the last item.
;
;===============================================================================
Func _GUICtrlComboGetCount($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETCOUNT)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetCount

;===============================================================================
;
; Description:			_GUICtrlComboGetCurSel
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	The return value is the zero-based index of the currently selected item.
;							If no item is selected, it is $CB_ERR
; User CallTip:		_GUICtrlComboGetCurSel($h_combobox) Retrieve the index of the currently selected item, if any, in the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboGetCurSel($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETCURSEL)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETCURSEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetCurSel

;===============================================================================
;
; Description:			_GUICtrlComboGetDroppedControlRect
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	Array containing the RECT, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $CB_ERR.
; User CallTip:		_GUICtrlComboGetDroppedControlRect($h_combobox) Retrieve the screen coordinates of a combo box in its dropped-down state. (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] - left
;							$array[2] - top
;							$array[3] - right
;							$array[4] - bottom
;
;===============================================================================
Func _GUICtrlComboGetDroppedControlRect($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
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
	Local $struct_RECT
	$struct_RECT = DllStructCreate($RECT)
	If @error Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		_SendMessage($h_combobox, $CB_GETDROPPEDCONTROLRECT, 0, DllStructGetPtr($struct_RECT), 0, "int", "ptr")
	Else
		GUICtrlSendMsg($h_combobox, $CB_GETDROPPEDCONTROLRECT, 0, DllStructGetPtr($struct_RECT))
	EndIf
	If @error Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $array = StringSplit(DllStructGetData($struct_RECT, $left) & "," & DllStructGetData($struct_RECT, $top) & "," & DllStructGetData($struct_RECT, $right) & "," & DllStructGetData($struct_RECT, $bottom), ",")
	;   DllStructDelete($p)
	Return $array
EndFunc   ;==>_GUICtrlComboGetDroppedControlRect

;===============================================================================
;
; Description:			_GUICtrlComboGetDroppedState
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	If the list box is visible, the return value is TRUE
; 							otherwise, it is FALSE
; User CallTip:		_GUICtrlComboGetDroppedState($h_combobox) Determine whether the list box of a combo box is dropped down (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboGetDroppedState($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, False)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETDROPPEDSTATE)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETDROPPEDSTATE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetDroppedState

;===============================================================================
;
; Description:			_GUICtrlComboGetDroppedWidth
; Parameter(s):		$h_combobox - controlID
; Requirement:			CBS_DROPDOWN or CBS_DROPDOWNLIST style
; Return Value(s):	If the message succeeds, the return value is the width, in pixels.
;							If the message fails, the return value is $CB_ERR
; User CallTip:		_GUICtrlComboGetDroppedWidth($h_combobox) Retrieve the minimum allowable width, of the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboGetDroppedWidth($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETDROPPEDWIDTH)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETDROPPEDWIDTH, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetDroppedWidth

;===============================================================================
;
; Description:			_GUICtrlComboGetEditSel
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	Array containing the starting and ending selected positions, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $CB_ERR.
; User CallTip:		_GUICtrlComboGetEditSel($h_combobox) Get the starting and ending character positions of the current selection in the edit control of a combo box. (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] - starting position
;							$array[2] - ending position
;
;===============================================================================
Func _GUICtrlComboGetEditSel($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $struct_start = "dword"
	Local $struct_end = "dword"
	Local $ret
	Local $ss = DllStructCreate($struct_start)
	If @error Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $se = DllStructCreate($struct_end)
	If @error Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		$ret = _SendMessage($h_combobox, $CB_GETEDITSEL, DllStructGetPtr($ss), DllStructGetPtr($se), "int", "ptr", "ptr")
	Else
		$ret = GUICtrlSendMsg($h_combobox, $CB_GETEDITSEL, DllStructGetPtr($ss), DllStructGetPtr($se))
	EndIf
	If (Not $ret) Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $s_start_end = DllStructGetData($ss, 1) & "," & DllStructGetData($se, 1)
	Return StringSplit($s_start_end, ",")
EndFunc   ;==>_GUICtrlComboGetEditSel

;===============================================================================
;
; Description:			_GUICtrlComboGetExtendedUI
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	If the combo box has the extended user interface,
;							the return value is TRUE; otherwise, it is FALSE
; User CallTip:		_GUICtrlComboGetExtendedUI($h_combobox) Determine whether a combo box has the default user interface or the extended user interface (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				By default, the F4 key opens or closes the list and the
;							DOWN ARROW changes the current selection.
;							In a combo box with the extended user interface, the F4
;							key is disabled and pressing the DOWN ARROW key opens the
;							drop-down list.
;
;===============================================================================
Func _GUICtrlComboGetExtendedUI($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, False)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETEXTENDEDUI)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETEXTENDEDUI, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetExtendedUI

;===============================================================================
;
; Description:			_GUICtrlComboGetHorizontalExtent
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	The return value is the scrollable width, in pixels.
; User CallTip:		_GUICtrlComboGetHorizontalExtent($h_combobox) Retrieve from a combo box the width, in pixels (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Retrieve from a combo box the width, in pixels, by which the
;							list box can be scrolled horizontally (the scrollable width).
;							This is applicable only if the list box has a horizontal scroll bar.
;
;===============================================================================
Func _GUICtrlComboGetHorizontalExtent($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETHORIZONTALEXTENT)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETHORIZONTALEXTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetHorizontalExtent

;===============================================================================
;
; Description:			_GUICtrlComboGetItemHeight
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the string
; Requirement:			None
; Return Value(s):	The return value is the height, in pixels, of the list items in a combo box.
;							If the combo box has the CBS_OWNERDRAWVARIABLE style, it is the height of the
;							item specified by the $i_index parameter. If $i_index is –1, the return value
;							is the height of the edit control (or static-text) portion of the combo box.
;							If an error occurs, the return value is $CB_ERR
; User CallTip:		_GUICtrlComboGetItemHeight($h_combobox[, $i_index=-1]) Determine the height of list items or the selection field in a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboGetItemHeight($h_combobox, $i_index = -1)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETITEMHEIGHT, $i_index)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETITEMHEIGHT, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetItemHeight

;===============================================================================
;
; Description:			_GUICtrlComboGetLBText
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the string to retrieve.
;							$s_text - Buffer that receives the string
; Requirement:			None
; Return Value(s):	The return value is the length of the string, in TCHARs,
;							excluding the terminating null character.
;							If $i_index does not specify a valid index, the return value is $CB_ERR.
; User CallTip:		_GUICtrlComboGetLBText($h_combobox, $i_index, ByRef $s_text) Retrieve a string from the list of a combo box. (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Must call _GUICtrlComboGetLBTextLen 1st and get the length
;
;===============================================================================
Func _GUICtrlComboGetLBText($h_combobox, $i_index, ByRef $s_text)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $len = _GUICtrlComboGetLBTextLen($h_combobox, $i_index)
	
	$s_text = ""
	Local $ret, $struct = DllStructCreate("char[" & $len + 1 & "]")
	If Not IsHWnd($h_combobox) Then $h_combobox = GUICtrlGetHandle($h_combobox)
	$ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_combobox, "int", $CB_GETLBTEXT, "int", $i_index, "ptr", DllStructGetPtr($struct))
	If ($ret[0] == $CB_ERR) Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	$s_text = DllStructGetData($struct, 1)
	Return $ret
EndFunc   ;==>_GUICtrlComboGetLBText

;===============================================================================
;
; Description:			_GUICtrlComboGetLBTextLen
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the string
; Requirement:			None
; Return Value(s):	The return value is the length of the string, in TCHARs,
;							excluding the terminating null character.
;							If an ANSI string this is the number of bytes, and if it
;							is a Unicode string this is the number of characters.
;							If the $i_index parameter does not specify a valid index,
;							the return value is $CB_ERR
; User CallTip:		_GUICtrlComboGetLBTextLen($h_combobox, $i_index) Retrieve the length, in characters, of a string in the list of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Under certain conditions, the return value is larger than the
;							actual length of the text. This occurs with certain mixtures of
;							ANSI and Unicode, and is due to the operating system allowing for
;							the possible existence of double-byte character set (DBCS) characters
;							within the text. The return value, however, will always be at least
;							as large as the actual length of the text; so you can always use it
;							to guide buffer allocation.
;							This behavior can occur when an application uses both ANSI functions
;							and common dialogs, which use Unicode.
;							To obtain the exact length of the text, use the WM_GETTEXT, LB_GETTEXT,
;							or CB_GETLBTEXT messages, or the GetWindowText function
;
;===============================================================================
Func _GUICtrlComboGetLBTextLen($h_combobox, $i_index)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETLBTEXTLEN, $i_index)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETLBTEXTLEN, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetLBTextLen

;===============================================================================
;
; Function Name:    _GUICtrlComboGetList()
; Description:      Retrieves all items from the list portion of a ComboBox control.
; Parameter(s):     $a_Array      - Array
;                   $idCombo - Control ID of the combo.
;                   $sDelimiter - Delimeter used to seperate each item (Defaults to |).
; Requirement(s):   _GUICtrlComboGetCount(), _GUICtrlComboGetLBText()
; Return Value(s):  Delimited string of all ComboBox items.
; Author(s):        Jason Boggs
;
;===============================================================================
Func _GUICtrlComboGetList($h_combobox, $sDelimiter = "|")
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, "")
	Local $sResult, $sItem
	For $i = 0 To _GUICtrlComboGetCount($h_combobox) - 1
		_GUICtrlComboGetLBText($h_combobox, $i, $sItem)
		$sResult &= $sItem & $sDelimiter
	Next
	$sResult = StringTrimRight($sResult, StringLen($sDelimiter))
	Return $sResult
EndFunc   ;==>_GUICtrlComboGetList

;===============================================================================
;
; Description:			_GUICtrlComboGetLocale
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	Returns the current Local of the combobox
; 							same as @OSLang unless changed
; User CallTip:		_GUICtrlComboGetLocale($h_combobox) Retrieve the current locale of the combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				"0409" for U.S. English
;							see @OSLang for string values
;
;===============================================================================
Func _GUICtrlComboGetLocale($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return Hex(_SendMessage($h_combobox, $CB_GETLOCALE), 4)
	Else
		Return Hex(GUICtrlSendMsg($h_combobox, $CB_GETLOCALE, 0, 0), 4)
	EndIf
EndFunc   ;==>_GUICtrlComboGetLocale

;===============================================================================
;
; Description:			_GUICtrlComboGetMinVisible
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	The return value is the minimum number of visible items
; User CallTip:		_GUICtrlComboGetMinVisible($h_combobox) Get the minimum number of visible items in the drop-down list of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				When the number of items in the drop-down list is greater
;							than the minimum, the combo box uses a scrollbar.
;							This message is ignored if the combo box control has style
;							CBS_NOINTEGRALHEIGHT.
;							To use CB_GETMINVISIBLE, the application must specify comctl32.dll
;							version 6 in the manifest. For more information, see
;							Using Windows XP Visual Styles
;
;===============================================================================
Func _GUICtrlComboGetMinVisible($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETMINVISIBLE)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETMINVISIBLE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetMinVisible

;===============================================================================
;
; Description:			_GUICtrlComboGetTopIndex
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	If the message is successful, the return value is the index of the first
;							visible item in the list box of the combo box.
;							If the message fails, the return value is $CB_ERR
; User CallTip:		_GUICtrlComboGetTopIndex($h_combobox) Retrieve the zero-based index of the first visible item in the list box portion of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Initially, the item with index 0 is at the top of the list box,
;							but if the list box contents have been scrolled, another item may be at the top
;
;===============================================================================
Func _GUICtrlComboGetTopIndex($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETTOPINDEX)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETTOPINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboGetTopIndex

;===============================================================================
;
; Description:			_GUICtrlComboInitStorage
; Parameter(s):		$h_combobox - controlID
;							$i_num - Specifies the number of items to add
;							$i_bytes - Specifies the amount of memory to allocate for item strings, in bytes
; Requirement:			None
; Return Value(s):	If the message is successful, the return value is the total number
;							of items for which memory has been pre-allocated, that is, the total
;							number of items added by all successful CB_INITSTORAGE messages.
;							If the message fails, the return value is $CB_ERRSPACE
; User CallTip:		_GUICtrlComboInitStorage($h_combobox, $i_num, $i_bytes) Allocates memory for storing list box items (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Windows NT 4.0: This message does not allocate the specified amount of memory
; 							however, it always returns the value specified in the $i_num parameter.
;							Windows 2000/XP: The message allocates memory and returns the success and error values described above
;
;							The CB_INITSTORAGE message helps speed up the initialization of combo boxes
;							that have a large number of items (over 100).
;							It reserves the specified amount of memory so that subsequent CB_ADDSTRING,
;							CB_INSERTSTRING, and CB_DIR messages take the shortest possible time.
;							You can use estimates for the $i_num and $i_bytes parameters.
;							If you overestimate, the extra memory is allocated,
;							if you underestimate, the normal allocation is used for items that exceed the requested amount
;
;===============================================================================
Func _GUICtrlComboInitStorage($h_combobox, $i_num, $i_bytes)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_INITSTORAGE, $i_num, $i_bytes)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_INITSTORAGE, $i_num, $i_bytes)
	EndIf
EndFunc   ;==>_GUICtrlComboInitStorage

;===============================================================================
;
; Description:			_GUICtrlComboInsertString
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the position at which to insert the string
;							$s_text - String to insert
; Requirement:			None
; Return Value(s):	The return value is the index of the position at which the string was inserted.
;							If an error occurs, the return value is $CB_ERR.
;							If there is insufficient space available to store the new string, it is $CB_ERRSPACE
; User CallTip:		_GUICtrlComboInsertString($h_combobox, $i_index , $s_text) Insert a string into the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the $i_index parameter is –1, the string is added to the end of the list
;							If the combo box has WS_HSCROLL style and you insert a string wider than the
;							combo box, you should send a LB_SETHORIZONTALEXTENT message to ensure the
;							horizontal scrollbar appears
;
;===============================================================================
Func _GUICtrlComboInsertString($h_combobox, $i_index, $s_text)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_INSERTSTRING, $i_index, $s_text, 0, "int", "str")
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_INSERTSTRING, $i_index, String($s_text))
	EndIf
EndFunc   ;==>_GUICtrlComboInsertString

;===============================================================================
;
; Description:			_GUICtrlComboLimitText
; Parameter(s):		$h_combobox - controlID
;							$i_limit - Optional: Specifies the maximum number of characters the user can enter
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlComboLimitText($h_combobox[, $i_limit=0]) Limit the length of the text the user may type into the edit control of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the $i_limit parameter is zero, the text length is limited to 0x7FFFFFFE characters
;							If the combo box does not have the CBS_AUTOHSCROLL style, setting the text limit to
;							be larger than the size of the edit control has no effect.
;							The CB_LIMITTEXT message limits only the text the user can enter.
;							It has no effect on any text already in the edit control when the message is sent,
;							nor does it affect the length of the text copied to the edit control when a string
;							in the list box is selected.
;							The default limit to the text a user can enter in the edit control is 30,000 characters
;
;===============================================================================
Func _GUICtrlComboLimitText($h_combobox, $i_limit = 0)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, 0)
	If IsHWnd($h_combobox) Then
		_SendMessage($h_combobox, $CB_LIMITTEXT, $i_limit)
	Else
		GUICtrlSendMsg($h_combobox, $CB_LIMITTEXT, $i_limit, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboLimitText

;===============================================================================
;
; Description:			_GUICtrlComboResetContent
; Parameter(s):		$h_combobox - controlID
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlComboResetContent($h_combobox) Remove all items from the list box and edit control of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlComboResetContent($h_combobox)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, 0)
	If IsHWnd($h_combobox) Then
		_SendMessage($h_combobox, $CB_RESETCONTENT)
	Else
		GUICtrlSendMsg($h_combobox, $CB_RESETCONTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboResetContent

;===============================================================================
;
; Description:			_GUICtrlComboSelectString
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the item preceding the first item to be searched
;							$s_search - String that contains the characters for which to search
; Requirement:			None
; Return Value(s):	If the string is found, the return value is the index of the selected item.
;							If the search is unsuccessful, the return value is $CB_ERR and the current selection is not changed
; User CallTip:		_GUICtrlComboSelectString($h_combobox, $i_index, $s_search) Search the list of a combo box for an item that begins with the characters in a specified string (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				When the search reaches the bottom of the list, it continues from the top
;							of the list back to the item specified by the wParam parameter.
;							If $i_index is –1, the entire list is searched from the beginning
;							A string is selected only if the characters from the starting point
;							match the characters in the prefix string
;
;===============================================================================
Func _GUICtrlComboSelectString($h_combobox, $i_index, $s_search)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SELECTSTRING, $i_index, $s_search, 0, "int", "str")
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SELECTSTRING, $i_index, String($s_search))
	EndIf
EndFunc   ;==>_GUICtrlComboSelectString

;===============================================================================
;
; Description:			_GUICtrlComboSetCurSel
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the string to select
; Requirement:			None
; Return Value(s):	If the message is successful, the return value is the index of the item selected.
;							If $i_index is greater than the number of items in the list or if $i_index is –1,
;							the return value is $CB_ERR and the selection is cleared
; User CallTip:		_GUICtrlComboSetCurSel($h_combobox, $i_index) Select a string in the list of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If this $i_index is –1, any current selection in the list is removed and the edit control is cleared
;
;===============================================================================
Func _GUICtrlComboSetCurSel($h_combobox, $i_index)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETCURSEL, $i_index)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETCURSEL, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetCurSel

;===============================================================================
;
; Description:			_GUICtrlComboSetDroppedWidth
; Parameter(s):		$h_combobox - controlID
;							$i_width - Specifies the width of the list box, in pixels
; Requirement:			CBS_DROPDOWN or CBS_DROPDOWNLIST style
; Return Value(s):	If the message is successful, The return value is the new width of the list box.
;							If the message fails, the return value is $CB_ERR
; User CallTip:		_GUICtrlComboSetDroppedWidth($h_combobox, $i_width) Set the maximum allowable width (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				By default, the minimum allowable width of the drop-down list box is zero.
;							The width of the list box is either the minimum allowable width or the
;							combo box width, whichever is larger
;
;===============================================================================
Func _GUICtrlComboSetDroppedWidth($h_combobox, $i_width)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETDROPPEDWIDTH, $i_width)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETDROPPEDWIDTH, $i_width, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetDroppedWidth

;===============================================================================
;
; Description:			_GUICtrlComboSetEditSel
; Parameter(s):		$h_combobox - controlID
;							$i_start - Starting position
;							$i_stop - Ending position
; Requirement:			None
; Return Value(s):	If the message succeeds, the return value is TRUE.
;							If the message is sent to a combo box with the CBS_DROPDOWNLIST style, it is $CB_ERR
; User CallTip:		_GUICtrlComboSetEditSel($h_combobox, $i_start, $i_stop) Select characters in the edit control of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The positions are zero-based.
;							The first character of the edit control is in the zero position.
;							The first character after the last selected character is in the ending position.
;							For example, to select the first four characters of the edit control,
;							use a starting position of 0 and an ending position of 4
;
;===============================================================================
Func _GUICtrlComboSetEditSel($h_combobox, $i_start, $i_stop)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETEDITSEL, 0, $i_stop * 65536 + $i_start)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETEDITSEL, 0, $i_stop * 65536 + $i_start)
	EndIf
EndFunc   ;==>_GUICtrlComboSetEditSel

;===============================================================================
;
; Description:			_GUICtrlComboSetExtendedUI
; Parameter(s):		$h_combobox - controlID
;							$i_bool - Specifies whether the combo box uses the extended user interface or the default user interface
; Requirement:			None
; Return Value(s):	If the operation succeeds, the return value is CB_OKAY.
;							If an error occurs, it is $CB_ERR
; User CallTip:		_GUICtrlComboSetExtendedUI($h_combobox, $i_bool) Select either the default user interface or the extended user interface (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				By default, the F4 key opens or closes the list and the
;							DOWN ARROW changes the current selection. In the extended
;							user interface, the F4 key is disabled and the DOWN ARROW
;							key opens the drop-down list
;							$i_bool specifies whether the combo box uses the extended
;							user interface or the default user interface.
;							A value of TRUE selects the extended user interface
; 							A value of FALSE selects the standard user interface
;
;===============================================================================
Func _GUICtrlComboSetExtendedUI($h_combobox, $i_bool)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETEXTENDEDUI, $i_bool)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETEXTENDEDUI, $i_bool, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetExtendedUI

;===============================================================================
;
; Description:			_GUICtrlComboSetHorizontalExtent
; Parameter(s):		$h_combobox - controlID
;							$i_width - Specifies the scrollable width of the list box, in pixels
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlComboSetHorizontalExtent($h_combobox, $i_width) Set the width, in pixels (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				An application sends the CB_SETHORIZONTALEXTENT message to set the width,
;							in pixels, by which a list box can be scrolled horizontally (the scrollable width).
;							If the width of the list box is smaller than this value, the horizontal scroll bar
;							horizontally scrolls items in the list box.
;							If the width of the list box is equal to or greater than this value, the horizontal
;							scroll bar is hidden or, if the combo box has the CBS_DISABLENOSCROLL style, disabled
;
;===============================================================================
Func _GUICtrlComboSetHorizontalExtent($h_combobox, $i_width)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		_SendMessage($h_combobox, $CB_SETHORIZONTALEXTENT, $i_width)
	Else
		GUICtrlSendMsg($h_combobox, $CB_SETHORIZONTALEXTENT, $i_width, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetHorizontalExtent

;===============================================================================
;
; Description:			_GUICtrlComboSetItemHeight
; Parameter(s):		$h_combobox - controlID
;							$i_component - Specifies the component of the combo box for which to set the height
;							$i_height - Specifies the height, in pixels, of the combo box component identified by $i_component
; Requirement:			None
; Return Value(s):	If the index or height is invalid, the return value is $CB_ERR
; User CallTip:		_GUICtrlComboSetItemHeight($h_combobox, $i_component, $i_height) Set the height of list items or the selection field in a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_component parameter must be –1 to set the height of the selection field.
;							It must be zero to set the height of list items, unless the combo box has
;							the CBS_OWNERDRAWVARIABLE style. In that case, the $i_component parameter
;							is the zero-based index of a specific list item
;
;===============================================================================
Func _GUICtrlComboSetItemHeight($h_combobox, $i_component, $i_height)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETITEMHEIGHT, $i_component, $i_height)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETITEMHEIGHT, $i_component, $i_height)
	EndIf
EndFunc   ;==>_GUICtrlComboSetItemHeight

;===============================================================================
;
; Description:			_GUICtrlComboSetMinVisible
; Parameter(s):		$h_combobox - controlID
;							$i_minimum - Specifies the minimum number of visible items
; Requirement:			None
; Return Value(s):	If the message is successful, the return value is TRUE.
;							Otherwise the return value is FALSE
; User CallTip:		_GUICtrlComboSetMinVisible($h_combobox, $i_minimum) Set the minimum number of visible items in the drop-down list of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				When the number of items in the drop-down list is greater than the minimum,
;							the combo box uses a scrollbar.
;							By default, 30 is the minimum number of visible items.
;							This message is ignored if the combo box control has style CBS_NOINTEGRALHEIGHT.
;							To use CB_SETMINVISIBLE, the application must specify comctl32.dll version 6 in the manifest
;
;===============================================================================
Func _GUICtrlComboSetMinVisible($h_combobox, $i_minimum)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, False)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETMINVISIBLE, $i_minimum)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETMINVISIBLE, $i_minimum, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetMinVisible

;===============================================================================
;
; Description:			_GUICtrlComboSetTopIndex
; Parameter(s):		$h_combobox - controlID
;							$i_index - Specifies the zero-based index of the list item
; Requirement:			None
; Return Value(s):	If the message is successful, the return value is zero.
;							If the message fails, the return value is $CB_ERR
; User CallTip:		_GUICtrlComboSetTopIndex($h_combobox, $i_index) Ensure that a particular item is visible (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The system scrolls the list box contents so that either the specified
;							item appears at the top of the list box or the maximum scroll range
;							has been reached
;
;===============================================================================
Func _GUICtrlComboSetTopIndex($h_combobox, $i_index)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETTOPINDEX, $i_index)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETTOPINDEX, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboSetTopIndex

;===============================================================================
;
; Description:			_GUICtrlComboShowDropDown
; Parameter(s):		$h_combobox - controlID
;							$i_bool - Specifies whether the drop-down list box is to be shown or hidden
; Requirement:			CBS_DROPDOWN or CBS_DROPDOWNLIST style
; Return Value(s):	None
; User CallTip:		_GUICtrlComboShowDropDown($h_combobox, $i_bool) Show or hide the list box of a combo box (required: <GuiCombo.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_bool = TRUE shows the list box
; 							$i_bool = FALSE hides it
;							This message has no effect on a combo box created with the CBS_SIMPLE style
;
;===============================================================================
Func _GUICtrlComboShowDropDown($h_combobox, $i_bool)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, 0)
	If IsHWnd($h_combobox) Then
		_SendMessage($h_combobox, $CB_SHOWDROPDOWN, $i_bool)
	Else
		GUICtrlSendMsg($h_combobox, $CB_SHOWDROPDOWN, $i_bool, 0)
	EndIf
EndFunc   ;==>_GUICtrlComboShowDropDown