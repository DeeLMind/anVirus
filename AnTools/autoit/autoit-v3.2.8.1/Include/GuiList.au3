#include-once
#include <ListBoxConstants.au3>
#include <Misc.au3>
#include <Memory.au3>

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with Listbox.
;
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; These functions use some code developed by Paul Campbell (PaulIA) for the Auto3Lib project
; particularly the _Mem* function calls which can be found in Memory.au3
; ------------------------------------------------------------------------------

; function list
;===============================================================================
; _GUICtrlListAddDir
; _GUICtrlListAddItem
; _GUICtrlListClear
; _GUICtrlListCount
; _GUICtrlListDeleteItem
; _GUICtrlListFindString
; _GUICtrlListGetAnchorIndex
; _GUICtrlListGetCaretIndex
; _GUICtrlListGetHorizontalExtent
; _GUICtrlListGetInfo
; _GUICtrlListGetLocale
; _GUICtrlListGetSelCount
; _GUICtrlListGetSelItems
; _GUICtrlListGetSelItemsText
; _GUICtrlListGetSelState
; _GUICtrlListGetText
; _GUICtrlListGetTextLen
; _GUICtrlListGetTopIndex
; _GUICtrlListInsertItem
; _GUICtrlListReplaceString
; _GUICtrlListSelectedIndex
; _GUICtrlListSelectString
; _GUICtrlListSelItemRange
; _GUICtrlListSelItemRangeEx
; _GUICtrlListSetAnchorIndex
; _GUICtrlListSetCaretIndex
; _GUICtrlListSetHorizontalExtent
; _GUICtrlListSetLocale
; _GUICtrlListSetSel
; _GUICtrlListSetTopIndex
; _GUICtrlListSort
; _GUICtrlListSwapString
;
; ************** TODO ******************
; _GUICtrlListAddFile
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlListAddDir
; Parameter(s):		$h_listbox - controlID
;							$s_Attributes - Comma-delimited string
;							$s_file - Optional for "Drives" only: what to get i.e *.*
; Requirement:			None
; Return Value(s):	zero-based index of the last name added to the list
;							If an error occurs, the return value is $LB_ERR.
;							If there is insufficient space to store the new strings, the return value is $LB_ERRSPACE
; User CallTip:		_GUICtrlListAddDir($h_listbox, $s_Attributes[, $s_file=""]) Add names to the list displayed by the list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
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
Func _GUICtrlListAddDir($h_listbox, $s_Attributes, $s_file = "")
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $i, $v_Attributes = "", $i_drives = 0, $no_brackets = 0, $v_ret
	Local $a_Attributes = StringSplit($s_Attributes, ",")
	For $i = 1 To $a_Attributes[0]
		Select
			Case StringUpper($a_Attributes[$i]) = "A"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_ARCHIVE
				Else
					$v_Attributes = $DDL_ARCHIVE
				EndIf
			Case StringUpper($a_Attributes[$i]) = "D"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_DIRECTORY
				Else
					$v_Attributes = $DDL_DIRECTORY
				EndIf
			Case StringUpper($a_Attributes[$i]) = "H"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_HIDDEN
				Else
					$v_Attributes = $DDL_HIDDEN
				EndIf
			Case StringUpper($a_Attributes[$i]) = "RO"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_READONLY
				Else
					$v_Attributes = $DDL_READONLY
				EndIf
			Case StringUpper($a_Attributes[$i]) = "RW"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_READWRITE
				Else
					$v_Attributes = $DDL_READWRITE
				EndIf
			Case StringUpper($a_Attributes[$i]) = "S"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_SYSTEM
				Else
					$v_Attributes = $DDL_SYSTEM
				EndIf
			Case StringUpper($a_Attributes[$i]) = "DRIVES"
				$i_drives = 1
				$s_file = ""
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_DRIVES
				Else
					$v_Attributes = $DDL_DRIVES
				EndIf
			Case StringUpper($a_Attributes[$i]) = "E"
				If (StringLen($v_Attributes) > 0) Then
					$v_Attributes = $v_Attributes + $DDL_EXCLUSIVE
				Else
					$v_Attributes = $DDL_EXCLUSIVE
				EndIf

			Case StringUpper($a_Attributes[$i]) = "NB"
				If (StringLen($v_Attributes) > 0) And StringInStr($s_Attributes, "DRIVES") Then
					$no_brackets = 1
				Else
					$no_brackets = 0
				EndIf
			Case Else
				; invalid attribute
				Return $LB_ERRATTRIBUTE
		EndSelect
	Next
	If (Not $i_drives And StringLen($s_file) == 0) Then
		Return $LB_ERRREQUIRED
	EndIf
	If $i_drives And $no_brackets Then
		Local $s_text
		Local $gui_no_brackets = GUICreate("no brackets")
		Local $list_no_brackets = GUICtrlCreateList("", 240, 40, 120, 120)
		$v_ret = GUICtrlSendMsg($list_no_brackets, $LB_DIR, $v_Attributes, $s_file)
		For $i = 0 To _GUICtrlListCount($list_no_brackets) - 1
			$s_text = _GUICtrlListGetText($list_no_brackets, $i)
			$s_text = StringReplace(StringReplace(StringReplace($s_text, "[", ""), "]", ":"), "-", "")
			_GUICtrlListInsertItem($h_listbox, $s_text)
		Next
		GUIDelete($gui_no_brackets)
		Return $v_ret
	Else
		If IsHWnd($h_listbox) Then
			Return _SendMessage($h_listbox, $LB_DIR, $v_Attributes, $s_file, 0, "int", "str")
		Else
			Return GUICtrlSendMsg($h_listbox, $LB_DIR, $v_Attributes, $s_file)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListAddDir

;===============================================================================
;
; Description:			_GUICtrlListAddItem
; Parameter(s):		$h_listbox - controlID
;							$s_text - string to add
; Requirement:			None
; Return Value(s):	The return value is the zero-based index of the string in
;							the list box. If an error occurs, the return value is $LB_ERR.
;							If there is insufficient space to store the new string,
;							the return value is $LB_ERRSPACE.
; User CallTip:		_GUICtrlListAddItem($h_listbox, $s_text) Add an item to the List (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the list box does not have the LBS_SORT style, the string is added to the
; 							end of the list. Otherwise, the string is inserted into the list and the list
; 							is sorted.
;
;===============================================================================
Func _GUICtrlListAddItem($h_listbox, $s_text)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_ADDSTRING, 0, $s_text, 0, "int", "str")
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_ADDSTRING, 0, String($s_text))
	EndIf
EndFunc   ;==>_GUICtrlListAddItem

;===============================================================================
;
; Description:			_GUICtrlListClear
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlListClear($h_listbox) remove all items from the list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListClear($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, 0)
	If IsHWnd($h_listbox) Then
		_SendMessage($h_listbox, $LB_RESETCONTENT)
	Else
		GUICtrlSendMsg($h_listbox, $LB_RESETCONTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListClear

;===============================================================================
;
; Description:			_GUICtrlListCount
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	The return value is the number of items in the list box
;							or $LB_ERR if an error occurs
; User CallTip:		_GUICtrlListCount($h_listbox) return the number of items in the list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListCount($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETCOUNT)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListCount

;===============================================================================
;
; Description:			_GUICtrlListDeleteItem
; Parameter(s):		$h_listbox - controlID
;							$i_index - index of item to delete
; Requirement:			None
; Return Value(s):	The return value is a count of the strings remaining in the list.
;							The return value is $LB_ERR if the $i_index parameter specifies an
;							index greater than the number of items in the list.
; User CallTip:		_GUICtrlListDeleteItem($h_listbox, $i_index) Delete an Item from the List (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListDeleteItem($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_DELETESTRING, $i_index)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_DELETESTRING, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListDeleteItem

;===============================================================================
;
; Description:			_GUICtrlListFindString
; Parameter(s):		$h_listbox - controlID
;							$s_search - string to search for
;							$i_exact - exact match or not
; Requirement:			None
; Return Value(s):	The return value is the index of the matching item,
;							or $LB_ERR if the search was unsuccessful.
; User CallTip:		_GUICtrlListFind($h_listbox, $s_search[, $i_exact=0]) return the index of matching item (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				find the first string in a list box that begins with the specified string.
;							if exact is specified find the first list box string that exactly matches
;                    the specified string, except that the search is not case sensitive
;===============================================================================
Func _GUICtrlListFindString($h_listbox, $s_search, $i_exact = 0)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		If ($i_exact) Then
			Return _SendMessage($h_listbox, $LB_FINDSTRINGEXACT, -1, $s_search, 0, "int", "str")
		Else
			Return _SendMessage($h_listbox, $LB_FINDSTRING, -1, $s_search, 0, "int", "str")
		EndIf
	Else
		If ($i_exact) Then
			Return GUICtrlSendMsg($h_listbox, $LB_FINDSTRINGEXACT, -1, String($s_search))
		Else
			Return GUICtrlSendMsg($h_listbox, $LB_FINDSTRING, -1, String($s_search))
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListFindString

;===============================================================================
;
; Description:			_GUICtrlListGetAnchorIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	The return value is the index of the anchor item.
;							If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListGetAnchorIndex($h_listbox) Get the Anchor Idex (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;         				This might not always be the first selected item--especially
;  						if you select every other item via Ctrl+Click...
;
;===============================================================================
Func _GUICtrlListGetAnchorIndex($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETANCHORINDEX)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETANCHORINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetAnchorIndex

;===============================================================================
;
; Description:			_GUICtrlListGetCaretIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	The return value is the zero-based index of the selected list box item.
;							If nothing is selected $LB_ERR can be returned.
; User CallTip:		_GUICtrlListGetCaretIndex($h_listbox) Return index of item that has the focus rectangle (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				To determine the index of the item that has the focus rectangle in a
;							multiple-selection list box. The item may or may not be selected
;
;===============================================================================
Func _GUICtrlListGetCaretIndex($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETCARETINDEX)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETCARETINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetCaretIndex

;===============================================================================
;
; Description:			_GUICtrlListGetHorizontalExtent
; Parameter(s):		$h_listbox - controlID
; Requirement:			None.
; Return Value(s):	The return value is the scrollable width, in pixels, of the list box.
; User CallTip:		_GUICtrlListGetHorizontalExtent($h_listbox) Retrieve from a list box the the scrollable width (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				To respond to the $LB_GETHORIZONTALEXTENT message,
;							the list box must have been defined with the $WS_HSCROLL style.
;
;===============================================================================
Func _GUICtrlListGetHorizontalExtent($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETHORIZONTALEXTENT)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETHORIZONTALEXTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetHorizontalExtent

;===============================================================================
;
; Description:			_GUICtrlListGetInfo
; Parameter(s):		$h_listbox - controlID
; Requirement:			None.
; Return Value(s):	The return value is the number of items per column.
; User CallTip:		_GUICtrlListGetInfo($h_listbox) Retrieve the number of items per column in a specified list box. (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListGetInfo($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETLISTBOXINFO)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETLISTBOXINFO, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetInfo

;===============================================================================
;
; Description:			_GUICtrlListGetItemRect
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the item.
; Requirement:			Array containing the RECT, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $LB_ERR.
; Return Value(s):	The return value is the number of items per column.
; User CallTip:		_GUICtrlListGetItemRect($h_listbox, $i_index) Retrieve the dimensions of the rectangle that bounds a list box item. (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] - left
;							$array[2] - top
;							$array[3] - right
;							$array[4] - bottom
;
;===============================================================================
Func _GUICtrlListGetItemRect($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	#cs
		typedef struct _RECT {
		LONG left;
		LONG top;
		LONG right;
		LONG bottom;
		} RECT, *PRECT;
	#ce
	Local $RECT = "int;int;int;int"
	Local $left = 1, $top = 2, $right = 3, $bottom = 4
	Local $p = DllStructCreate($RECT)
	If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		If _SendMessage($h_listbox, $LB_GETITEMRECT, $i_index, DllStructGetPtr($p), 0, "int", "ptr") == $LB_ERR Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Else
		If GUICtrlSendMsg($h_listbox, $LB_GETITEMRECT, $i_index, DllStructGetPtr($p)) == $LB_ERR Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	EndIf
	Return StringSplit(DllStructGetData($p, $left) & "," & DllStructGetData($p, $top) & "," & DllStructGetData($p, $right) & "," & DllStructGetData($p, $bottom), ",")
EndFunc   ;==>_GUICtrlListGetItemRect

;===============================================================================
;
; Description:			_GUICtrlListGetLocale
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	Returns the current Local of the listbox
; 							same as @OSLang unless changed
; User CallTip:		_GUICtrlListGetLocale($h_listbox) current Local of the listbox (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				"0409" for U.S. English
;
;===============================================================================
Func _GUICtrlListGetLocale($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return Hex(_SendMessage($h_listbox, $LB_GETLOCALE), 4)
	Else
		Return Hex(GUICtrlSendMsg($h_listbox, $LB_GETLOCALE, 0, 0), 4)
	EndIf
EndFunc   ;==>_GUICtrlListGetLocale

;===============================================================================
;
; Description:			_GUICtrlListGetSelCount
; Parameter(s):		$h_listbox - controlID
; Requirement:			multiple-selection list box
; Return Value(s):	The return value is the count of selected items in the list box.
;							If the list box is a single-selection list box, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelCount($h_listbox) Get the number of items selected (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				Retrieve the total number of selected items in a multiple-selection list box.
; 							Number of selected items (for a control with multi-select style)
;
;===============================================================================
Func _GUICtrlListGetSelCount($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETSELCOUNT)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETSELCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetSelCount

;===============================================================================
;
; Description:			_GUICtrlListGetSelItems
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	Array of selected items indices, first element ($array[0]) contains the number indices returned
;							If the list box is a single-selection list box, the return value is $LB_ERR.
;							If no items are selected, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelItems($h_listbox) Get item indices of selected items (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListGetSelItems($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $num = _GUICtrlListGetSelCount($h_listbox)
	Local $i, $struct, $i_ret
	For $i = 1 To $num
		$struct &= "int;"
	Next
	$struct = StringTrimRight($struct, 1)
	Local $p = DllStructCreate($struct)
	If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		$i_ret = _SendMessage($h_listbox, $LB_GETSELITEMS, $num, DllStructGetPtr($p), 0, "int", "ptr")
	Else
		$i_ret = GUICtrlSendMsg($h_listbox, $LB_GETSELITEMS, $num, DllStructGetPtr($p))
	EndIf
	If ($i_ret == $LB_ERR Or $i_ret == 0) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $array
	For $i = 1 To $num
		$array &= DllStructGetData($p, $i) & ","
	Next
	$array = StringTrimRight($array, 1)
	Local $a_items = StringSplit($array, ",")
	For $i = 1 To $a_items[0]
		$a_items[$i] = Int($a_items[$i])
	Next
	Return $a_items
EndFunc   ;==>_GUICtrlListGetSelItems

;===============================================================================
;
; Description:			_GUICtrlListGetSelItemsText
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	array of selected items text, first element ($array[0]) contains the number items returned
;							If the list box is a single-selection list box, the return value is $LB_ERR.
;							If no items are selected, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelItemsText($h_listbox) Get the text of selected items (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):
;
;===============================================================================
Func _GUICtrlListGetSelItemsText($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $i, $i_ret, $a_text
	For $i = 0 To _GUICtrlListCount($h_listbox) - 1
		$i_ret = _GUICtrlListGetSelState($h_listbox, $i)
		If ($i_ret > 0) Then
			If IsArray($a_text) Then
				ReDim $a_text[UBound($a_text) + 1]
			Else
				Local $a_text[2]
			EndIf
			$a_text[0] += 1
			$a_text[UBound($a_text) - 1] = _GUICtrlListGetText($h_listbox, $i)
		ElseIf ($i_ret == $LB_ERR) Then
			Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
		EndIf
	Next
	Return $a_text
EndFunc   ;==>_GUICtrlListGetSelItemsText

;===============================================================================
;
; Description:			_GUICtrlListGetSelState
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the item
; Requirement:			None
; Return Value(s):	If an item is selected, the return value is greater than zero
; 							otherwise, it is zero. If an error occurs, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelState($h_listbox, $i_index) Get the selection state of item (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListGetSelState($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETSEL, $i_index)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETSEL, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetSelState

;===============================================================================
;
; Description:			_GUICtrlListGetText
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the string to retrieve
; Requirement:			None
; Return Value(s):	The return value is the item string.
;							If $i_index does not specify a valid index, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetText($h_listbox, $i_index) Returns the item (string) at the specified index (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListGetText($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $v_ret
	Local $struct = DllStructCreate("char[4096]")
	If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)

	If Not IsHWnd($h_listbox) Then $h_listbox = GUICtrlGetHandle($h_listbox)
	$v_ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_listbox, "int", $LB_GETTEXT, "int", $i_index, "ptr", DllStructGetPtr($struct))
	If $v_ret[0] == $LB_ERR Or @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Return DllStructGetData($struct, 1)
EndFunc   ;==>_GUICtrlListGetText

;===============================================================================
;
; Description:			_GUICtrlListGetTextLen
; Parameter(s):		$h_listbox - controlID
;							$i_index - Zero-based index of item
; Requirement:			None
; Return Value(s):	The return value is the length of the string
;							If the wParam parameter does not specify a valid index, the return value is $LB_ERR
; User CallTip:		_GUICtrlListGetTextLen($h_listbox, $i_index) alternative to StringLen (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListGetTextLen($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETTEXTLEN, $i_index)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETTEXTLEN, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetTextLen

;===============================================================================
;
; Description:			_GUICtrlListGetTopIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	The return value is the index of the first visible item in the list box.
;							If the list is empty then $LB_ERR is returned.
; User CallTip:		_GUICtrlListGetTopIndex($h_listbox) retrieve the index of the first visible item in a list (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				Initially the item with index 0 is at the top of the list box, but if
; 							the list box contents have been scrolled another item may be at the top.
; 							Returns index of the first visible item in the list box
; 							useful since contents for a long list will scroll
;
;===============================================================================
Func _GUICtrlListGetTopIndex($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (Not _GUICtrlListCount($h_listbox)) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETTOPINDEX)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETTOPINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListGetTopIndex

;===============================================================================
;
; Description:			_GUICtrlListInsertItem
; Parameter(s):		$h_listbox - controlID
;							$s_text - String to insert
;							$i_index - Optional: index to insert at
; Requirement:			None
; Return Value(s):	The return value is the index of the position at which the string was inserted.
;							If an error occurs, the return value is $LB_ERR. If there is insufficient space
;							to store the new string, the return value is $LB_ERRSPACE.
; User CallTip:		_GUICtrlListInsertItem($h_listbox, $s_text[, $i_index=-1]) insert a string into the list (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If this parameter is –1, the string is added to the end of the list.
; 							Unlike the _GUICtrlListAddItem, this function does not cause a list
; 							with the LBS_SORT style to be sorted.
;
;===============================================================================
Func _GUICtrlListInsertItem($h_listbox, $s_text, $i_index = -1)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Local $struct_String = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
		Local $sBuffer_pointer = DllStructGetPtr($struct_String)
		DllStructSetData($struct_String, 1, $s_text)
		Local $rMemMap
		_MemInit ($h_listbox, StringLen($s_text) + 1, $rMemMap)
		If @error Then
			_MemFree ($rMemMap)
			Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
		EndIf
		_MemWrite ($rMemMap, $sBuffer_pointer)
		If @error Then
			_MemFree ($rMemMap)
			Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
		EndIf
		Local $iResult = _SendMessage($h_listbox, $LB_INSERTSTRING, $i_index, $sBuffer_pointer)
		If @error Then
			_MemFree ($rMemMap)
			Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
		EndIf
		_MemFree ($rMemMap)
		If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
		Return $iResult
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_INSERTSTRING, $i_index, String($s_text))
	EndIf
EndFunc   ;==>_GUICtrlListInsertItem

;===============================================================================
;
; Description:			_GUICtrlListReplaceString
; Parameter(s):		$h_listbox - controlID
;							$i_index - Zero-based index of the item to replace
;							$s_newString - String to replace old string
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListReplaceString($h_listbox, $i_index, $s_newString) Replaces the text of an item at index (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListReplaceString($h_listbox, $i_index, $s_newString)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (_GUICtrlListDeleteItem($h_listbox, $i_index) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (_GUICtrlListInsertItem($h_listbox, $s_newString, $i_index) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
EndFunc   ;==>_GUICtrlListReplaceString

;===============================================================================
;
; Description:			_GUICtrlListSelectIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the list box item
; Requirement:
; Return Value(s):	If an error occurs, the return value is $LB_ERR.
;							If the $i_index parameter is –1, the return value is $LB_ERR even though no error occurred.
; User CallTip:		_GUICtrlListSelectIndex($h_listbox, $i_index) Select a string and scroll it into view, if necessary (required: <GuiList.au3>)
; Author(s):			Sokko, Documented and Added To UDFs (Gary Frost (custompcs at charter dot net))
; Note(s):				Use this message only with single-selection list boxes.
;							You cannot use it to set or remove a selection in a multiple-selection list box.
;
;===============================================================================
Func _GUICtrlListSelectIndex($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SETCURSEL, $i_index)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SETCURSEL, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListSelectIndex

;===============================================================================
;
; Description:			_GUICtrlListSelectedIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	In a single-selection list box, the return value is the zero-based
;							index of the currently selected item. If there is no selection,
;							the return value is $LB_ERR
; User CallTip:		_GUICtrlListSelectedIndex($h_listbox) return the index of selected item (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Do not use this with a multiple-selection list box.
;
;===============================================================================
Func _GUICtrlListSelectedIndex($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_GETCURSEL)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_GETCURSEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListSelectedIndex

;===============================================================================
;
; Description:			_GUICtrlListSelectString
; Parameter(s):		$h_listbox - controlID
;							$s_text - String to select
;							$i_index - Optional: Zero-based index of the item before the first item to be searched
; Requirement:			None
; Return Value(s):	If the search is successful, the return value is the index of the selected item.
;							If the search is unsuccessful, the return value is $LB_ERR and the current selection is not changed.
; User CallTip:		_GUICtrlListSelectString($h_listbox, $s_text[, $i_index=-1]) select item using search string (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If $i_index is –1, the entire list box is searched from the beginning
;
;===============================================================================
Func _GUICtrlListSelectString($h_listbox, $s_search, $i_index = -1)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SELECTSTRING, $i_index, $s_search, 0, "int", "str")
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SELECTSTRING, $i_index, String($s_search))
	EndIf
EndFunc   ;==>_GUICtrlListSelectString

;===============================================================================
;
; Description:			_GUICtrlListSelItemRange
; Parameter(s):		$h_listbox - controlID
;							$i_flag - Set/Remove select
;							$i_start - Zero-based index of the first item to select
;							$i_stop - Zero-based index of the last item to select
; Requirement:			multi-select style
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSelItemRange($h_listbox, $i_flag, $i_start, $i_stop) Select range by index in a multiple-selection list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
; 							Select items from $i_start to $stop indices (inclusive)
;							Can select a range only within the first 65,536 items
; 							$i_flag == 1 selects
; 							$i_flag == 0 removes select
;
;===============================================================================
Func _GUICtrlListSelItemRange($h_listbox, $i_flag, $i_start, $i_stop)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SELITEMRANGE, $i_flag, $i_stop * 65536 + $i_start)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SELITEMRANGE, $i_flag, $i_stop * 65536 + $i_start)
	EndIf
EndFunc   ;==>_GUICtrlListSelItemRange

;===============================================================================
;
; Description:			_GUICtrlListSelItemRangeEx
; Parameter(s):		$h_listbox - controlID
;							$i_start - Zero-based index of the first item to select
;							$i_stop - Zero-based index of the last item to select
; Requirement:			multi-select style
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSelItemRangeEx($h_listbox, $i_start, $i_stop) Selects items from $i_start to $i_stop (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;  						If $i_start > $i_stop Then items are un-selected
;
;===============================================================================
Func _GUICtrlListSelItemRangeEx($h_listbox, $i_start, $i_stop)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SELITEMRANGEEX, $i_start, $i_stop)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SELITEMRANGEEX, $i_start, $i_stop)
	EndIf
EndFunc   ;==>_GUICtrlListSelItemRangeEx

;===============================================================================
;
; Description:			_GUICtrlListSetAnchorIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the index of the new anchor item.
; Requirement:			multi-select style
; Return Value(s):	If the message succeeds, the return value is zero.
;							If the message fails, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListSetAnchorIndex($h_listbox, $i_index) Set the Anchor Idex (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;
;===============================================================================
Func _GUICtrlListSetAnchorIndex($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SETANCHORINDEX, $i_index)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SETANCHORINDEX, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListSetAnchorIndex

;===============================================================================
;
; Description:			_GUICtrlListGetCaretIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the list box item that is to receive the focus rectangle.
;							$i_bool - Optional: If this value is FALSE, the item is scrolled until it is fully visible; if it is TRUE, the item is scrolled until it is at least partially visible.
; Requirement:			multi-select style
; Return Value(s):	The return value is the zero-based index of the selected list box item.
;							If nothing is selected $LB_ERR can be returned.
; User CallTip:		_GUICtrlListSetCaretIndex($h_listbox, $i_index[, $i_bool=1]) Set the focus rectangle to the item at the specified index (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;
;===============================================================================
Func _GUICtrlListSetCaretIndex($h_listbox, $i_index, $i_bool = 1)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SETCARETINDEX, $i_index, $i_bool)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SETCARETINDEX, $i_index, $i_bool)
	EndIf
EndFunc   ;==>_GUICtrlListSetCaretIndex

;===============================================================================
;
; Description:			_GUICtrlListSetHorizontalExtent
; Parameter(s):		$h_listbox - controlID
;							$i_pixels - Specifies the number of pixels by which the list box can be scrolled.
; Requirement:			None.
; Return Value(s):	None.
; User CallTip:		_GUICtrlListSetHorizontalExtent($h_listbox, $i_num) Set the width, in pixels, by which a list box can be scrolled horizontally (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				To respond to the $LB_SETHORIZONTALEXTENT message,
;							the list box must have been defined with the $WS_HSCROLL style.
;
;===============================================================================
Func _GUICtrlListSetHorizontalExtent($h_listbox, $i_pixels)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		_SendMessage($h_listbox, $LB_SETHORIZONTALEXTENT, $i_pixels)
	Else
		GUICtrlSendMsg($h_listbox, $LB_SETHORIZONTALEXTENT, $i_pixels, 0)
	EndIf
EndFunc   ;==>_GUICtrlListSetHorizontalExtent

;===============================================================================
;
; Description:			_GUICtrlListSetLocale
; Parameter(s):		$h_listbox - controlID
;							$s_locale - locale
; Requirement:			None
; Return Value(s):	Returns previous locale or $LB_ERR
; User CallTip:		_GUICtrlListSetLocale($h_listbox, $s_locale) Set the locale (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				"0409" for U.S. English
;							see @OSLang for string values
;
;===============================================================================
Func _GUICtrlListSetLocale($h_listbox, $s_locale)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return Hex(_SendMessage($h_listbox, $LB_SETLOCALE, Dec($s_locale)), 4)
	Else
		Return Hex(GUICtrlSendMsg($h_listbox, $LB_SETLOCALE, Dec($s_locale), 0), 4)
	EndIf
EndFunc   ;==>_GUICtrlListSetLocale

;===============================================================================
;
; Description:			_GUICtrlListSetSel
; Parameter(s):		$h_listbox - controlID
;							$i_flag - Optional: Select/UnSelect
;							$i_index - Optional: Specifies the zero-based index of the item
; Requirement:			multi-select style
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSetSel($h_listbox [, $i_flag] , $i_index]]) Select string(s) in a multiple-selection list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
; 							$i_flag == 0 means unselect
; 							$i_flag == 1 means select
;							$i_flag == -1 means toggle select/unselect of item
; 							An $i_index of -1 means to toggle select/unselect of all items (ignores the $i_flag).
;
;===============================================================================
Func _GUICtrlListSetSel($h_listbox, $i_flag = -1, $i_index = -1)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $i_ret
	If IsHWnd($h_listbox) Then
		If $i_index == -1 Then ; toggle all
			For $i_index = 0 To _GUICtrlListCount($h_listbox) - 1
				$i_ret = _GUICtrlListGetSelState($h_listbox, $i_index)
				If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
				If ($i_ret > 0) Then ;If Selected Then
					$i_ret = _SendMessage($h_listbox, $LB_SETSEL, 0, $i_index)
				Else
					$i_ret = _SendMessage($h_listbox, $LB_SETSEL, 1, $i_index)
				EndIf
				If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
			Next
		ElseIf $i_flag == -1 Then ; toggle state of index
			If _GUICtrlListGetSelState($h_listbox, $i_index) Then ;If Selected Then
				Return _SendMessage($h_listbox, $LB_SETSEL, 0, $i_index)
			Else
				Return _SendMessage($h_listbox, $LB_SETSEL, 1, $i_index)
			EndIf
		Else
			Return _SendMessage($h_listbox, $LB_SETSEL, $i_flag, $i_index)
		EndIf
	Else
		If $i_index == -1 Then ; toggle all
			For $i_index = 0 To _GUICtrlListCount($h_listbox) - 1
				$i_ret = _GUICtrlListGetSelState($h_listbox, $i_index)
				If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
				If ($i_ret > 0) Then ;If Selected Then
					$i_ret = GUICtrlSendMsg($h_listbox, $LB_SETSEL, 0, $i_index)
				Else
					$i_ret = GUICtrlSendMsg($h_listbox, $LB_SETSEL, 1, $i_index)
				EndIf
				If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
			Next
		ElseIf $i_flag == -1 Then ; toggle state of index
			If _GUICtrlListGetSelState($h_listbox, $i_index) Then ;If Selected Then
				Return GUICtrlSendMsg($h_listbox, $LB_SETSEL, 0, $i_index)
			Else
				Return GUICtrlSendMsg($h_listbox, $LB_SETSEL, 1, $i_index)
			EndIf
		Else
			Return GUICtrlSendMsg($h_listbox, $LB_SETSEL, $i_flag, $i_index)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListSetSel

;===============================================================================
;
; Description:			_GUICtrlListSetTopIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the item
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSetTopIndex($h_listbox, $i_index) ensure that a particular item in a list box is visible (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListSetTopIndex($h_listbox, $i_index)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If IsHWnd($h_listbox) Then
		Return _SendMessage($h_listbox, $LB_SETTOPINDEX, $i_index)
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SETTOPINDEX, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListSetTopIndex

;===============================================================================
;
; Description:			_GUICtrlListSort
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSort($h_listbox) Re-sorts list box if it has the LBS_SORT style (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				Re-sorts list box if it has the LBS_SORT style
;  						Might be useful if you use InsertString
;
;===============================================================================
Func _GUICtrlListSort($h_listbox)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $bak = _GUICtrlListGetText($h_listbox, 0)
	If ($bak == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (_GUICtrlListDeleteItem($h_listbox, 0) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Return _GUICtrlListAddItem($h_listbox, $bak)
EndFunc   ;==>_GUICtrlListSort

;===============================================================================
;
; Description:			_GUICtrlListSwapString
; Parameter(s):		$h_listbox - controlID
;							$i_indexA - Zero-based index item to swap
;							$i_indexB - Zero-based index item to swap
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSwapString($h_listbox, $i_indexA, $i_indexB) Swaps the text of two items at the specified indices (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListSwapString($h_listbox, $i_indexA, $i_indexB)
	If Not _IsClassName ($h_listbox, "ListBox") Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	Local $itemA = _GUICtrlListGetText($h_listbox, $i_indexA)
	Local $itemB = _GUICtrlListGetText($h_listbox, $i_indexB)
	If ($itemA == $LB_ERR Or $itemB == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (_GUICtrlListDeleteItem($h_listbox, $i_indexA) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (_GUICtrlListInsertItem($h_listbox, $itemB, $i_indexA) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)

	If (_GUICtrlListDeleteItem($h_listbox, $i_indexB) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
	If (_GUICtrlListInsertItem($h_listbox, $itemA, $i_indexB) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
EndFunc   ;==>_GUICtrlListSwapString