#include-once
#include <TabConstants.au3>
#include <Misc.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with the Tab Control.
;
; ------------------------------------------------------------------------------

; function list
;===============================================================================
; _GUICtrlTabDeleteAllItems
; _GUICtrlTabDeleteItem
; _GUICtrlTabDeselectAll
; _GUICtrlTabGetCurFocus
; _GUICtrlTabGetCurSel
; _GUICtrlTabGetExtendedStyle
; _GUICtrlTabGetItemCount
; _GUICtrlTabGetItemRECT
; _GUICtrlTabGetRowCount
; _GUICtrlTabGetUnicodeFormat
; _GUICtrlTabHighlightItem
; _GUICtrlTabSetCurFocus
; _GUICtrlTabSetCurSel
; _GUICtrlTabSetMinTabWidth
; _GUICtrlTabSetUnicodeFormat
;
; ************** TODO ******************
; _GUICtrlTabAdjustRECT ?
; _GUICtrlTabGetImageList
; _GUICtrlTabGetItem
; _GUICtrlTabInsertItem
; _GUICtrlTabRemoveImage
; _GUICtrlTabSetExtendedStyle
; _GUICtrlTabSetImageList
; _GUICtrlTabSetItem
; _GUICtrlTabSetItemExtra
; _GUICtrlTabSetItemSize
; _GUICtrlTabSetPadding ?
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlTabDeleteAllItems
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise.
; User CallTip:		_GUICtrlTabDeleteAllItems($h_tabcontrol) Removes all items from a tab control. (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				This does not delete the controls on the tabitems
;
;===============================================================================
Func _GUICtrlTabDeleteAllItems($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, False)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_DELETEALLITEMS)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_DELETEALLITEMS, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabDeleteAllItems

;===============================================================================
;
; Description:			_GUICtrlTabDeleteItem
; Parameter(s):		$h_tabcontrol - controlID
;							$i_item - Index of the item to delete.
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise.
; User CallTip:		_GUICtrlTabDeleteItem($h_tabcontrol, $i_item) Removes an item from a tab control. (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				This does not delete the controls on the tabitem
;
;===============================================================================
Func _GUICtrlTabDeleteItem($h_tabcontrol, $i_item)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, False)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_DELETEITEM, $i_item)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_DELETEITEM, $i_item, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabDeleteItem

;===============================================================================
;
; Description:			_GUICtrlTabDeselectAll
; Parameter(s):		$h_tabcontrol - controlID
;							$i_bool - Flag that specifies the scope of the item deselection.
;										If this parameter is set to FALSE, all tab items will be reset.
;										If it is set to TRUE, then all tab items except for the one currently selected will be reset.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlTabDeselectAll($h_tabcontrol, $i_bool) Resets items in a tab control. (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				This only works if $TCS_BUTTONS style flag has been set.
;
;===============================================================================
Func _GUICtrlTabDeselectAll($h_tabcontrol, $i_bool)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, 0)
	If IsHWnd($h_tabcontrol) Then
		_SendMessage($h_tabcontrol, $TCM_DESELECTALL, $i_bool)
	Else
		GUICtrlSendMsg($h_tabcontrol, $TCM_DESELECTALL, $i_bool, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabDeselectAll

;===============================================================================
;
; Description:			_GUICtrlTabGetCurFocus
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns the index of the tab item that has the focus.
; User CallTip:		_GUICtrlTabGetCurFocus($h_tabcontrol) Returns the index of the item that has the focus in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The item that has the focus may be different than the selected item.
;
;===============================================================================
Func _GUICtrlTabGetCurFocus($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_GETCURFOCUS)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_GETCURFOCUS, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabGetCurFocus

;===============================================================================
;
; Description:			_GUICtrlTabGetCurSel
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns the index of the selected tab if successful, or $TC_ERR if no tab is selected.
; User CallTip:		_GUICtrlTabGetCurSel($h_tabcontrol) Determines the currently selected tab in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabGetCurSel($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_GETCURSEL)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_GETCURSEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabGetCurSel

;===============================================================================
;
; Description:			_GUICtrlTabGetExtendedStyle
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns a DWORD value that represents the extended styles currently
;							in use for the tab control.
;							This value is a combination of tab control extended styles.
; User CallTip:		_GUICtrlTabGetExtendedStyle($h_tabcontrol) Retrieves the extended styles that are currently in use for the tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabGetExtendedStyle($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_GETEXTENDEDSTYLE)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_GETEXTENDEDSTYLE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabGetExtendedStyle
;===============================================================================
;
; Description:			_GUICtrlTabGetItemCount
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns the number of items if successful, or zero otherwise.
; User CallTip:		_GUICtrlTabGetItemCount($h_tabcontrol) Retrieves the number of tabs in the tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabGetItemCount($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, 0)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_GETITEMCOUNT)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_GETITEMCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabGetItemCount

;===============================================================================
;
; Description:			_GUICtrlTabGetItemRECT
; Parameter(s):		$h_tabcontrol - controlID
;							$i_item - Zero-based index of a tab control item.
; Requirement:			None
; Return Value(s):	Array containing the RECT, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $TC_ERR.
; User CallTip:		_GUICtrlTabGetItemRECT($h_tabcontrol, $i_item) Retrieves the bounding rectangle for a tab in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabGetItemRECT($h_tabcontrol, $i_item)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
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
	If @error Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		$v_ret = _SendMessage($h_tabcontrol, $TCM_GETITEMRECT, $i_item, DllStructGetPtr($struct_RECT), 0, "int", "ptr")
	Else
		$v_ret = GUICtrlSendMsg($h_tabcontrol, $TCM_GETITEMRECT, $i_item, DllStructGetPtr($struct_RECT))
	EndIf
	If (Not $v_ret) Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	Local $array = StringSplit(DllStructGetData($struct_RECT, $left) & "," & DllStructGetData($struct_RECT, $top) & "," & DllStructGetData($struct_RECT, $right) & "," & DllStructGetData($struct_RECT, $bottom), ",")
	Return $array
EndFunc   ;==>_GUICtrlTabGetItemRECT

;===============================================================================
;
; Description:			_GUICtrlTabGetRowCount
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns the number of rows of tabs.
; User CallTip:		_GUICtrlTabGetRowCount($h_tabcontrol) Retrieves the current number of rows of tabs in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Only tab controls that have the $TCS_MULTILINE style can have multiple rows of tabs.
;
;===============================================================================
Func _GUICtrlTabGetRowCount($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_GETROWCOUNT)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_GETROWCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabGetRowCount

;===============================================================================
;
; Description:			_GUICtrlTabGetUnicodeFormat
; Parameter(s):		$h_tabcontrol - controlID
; Requirement:			None
; Return Value(s):	Returns the Unicode format flag for the control.
;							If this value is nonzero, the control is using Unicode characters.
;							If this value is zero, the control is using ANSI characters.
; User CallTip:		_GUICtrlTabGetUnicodeFormat($h_tabcontrol) Retrieves the Unicode character format flag for the control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabGetUnicodeFormat($h_tabcontrol)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, 0)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_GETUNICODEFORMAT)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_GETUNICODEFORMAT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabGetUnicodeFormat
;===============================================================================
;
; Description:			_GUICtrlTabHighlightItem
; Parameter(s):		$h_tabcontrol - controlID
;							$i_item - Zero-based index of a tab control item.
;							$i_bool - Value specifying the highlight state to be set.
;										If this value is TRUE, the tab is highlighted
;										If FALSE, the tab is set to its default state.
; Requirement:			None
; Return Value(s):	Returns nonzero if successful, or zero otherwise.
; User CallTip:		_GUICtrlTabHighlightItem($h_tabcontrol, $i_item, $i_bool) Sets the highlight state of a tab item.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabHighlightItem($h_tabcontrol, $i_item, $i_bool)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, 0)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_HIGHLIGHTITEM, $i_item, $i_bool)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_HIGHLIGHTITEM, $i_item, $i_bool)
	EndIf
EndFunc   ;==>_GUICtrlTabHighlightItem

;===============================================================================
;
; Description:			_GUICtrlTabSetCurFocus
; Parameter(s):		$h_tabcontrol - controlID
;							$i_item - Zero-based index of a tab control item.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlTabSetCurFocus($h_tabcontrol, $i_item) Sets the focus to a specified tab in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the tab control has the $TCS_BUTTONS style (button mode),
;							the tab with the focus may be different from the selected tab.
;							For example, when a tab is selected, the user can press the arrow
;							keys to set the focus to a different tab without changing the selected tab.
;							In button mode, $TCM_SETCURFOCUS sets the input focus to the button associated
;							with the specified tab, but it does not change the selected tab.
;
;							If the tab control does not have the $TCS_BUTTONS style, changing the focus
;							also changes the selected tab.
;
;===============================================================================
Func _GUICtrlTabSetCurFocus($h_tabcontrol, $i_item)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, 0)
	If IsHWnd($h_tabcontrol) Then
		_SendMessage($h_tabcontrol, $TCM_SETCURFOCUS, $i_item)
	Else
		GUICtrlSendMsg($h_tabcontrol, $TCM_SETCURFOCUS, $i_item, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabSetCurFocus

;===============================================================================
;
; Description:			_GUICtrlTabSetCurSel
; Parameter(s):		$h_tabcontrol - controlID
;							$i_item - Zero-based index of a tab control item.
; Requirement:			None
; Return Value(s):	Returns the index of the previously selected tab if successful, or $TC_ERR otherwise.
; User CallTip:		_GUICtrlTabSetCurSel($h_tabcontrol, $i_item) Selects a tab in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				A tab control does not send a $TCN_SELCHANGING or $TCN_SELCHANGE
;							notification message when a tab is selected using this message.
;
;===============================================================================
Func _GUICtrlTabSetCurSel($h_tabcontrol, $i_item)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_SETCURSEL, $i_item)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_SETCURSEL, $i_item, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabSetCurSel

;===============================================================================
;
; Description:			_GUICtrlTabSetMinTabWidth
; Parameter(s):		$h_tabcontrol - controlID
;							$i_width - Minimum width to be set for a tab control item.
;										If this parameter is set to -1, the control will use the default tab width.
; Requirement:			None
; Return Value(s):	Returns an INT value that represents the previous minimum tab width.
; User CallTip:		_GUICtrlTabSetMinTabWidth($h_tabcontrol, $i_width) Sets the minimum width of items in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabSetMinTabWidth($h_tabcontrol, $i_width)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, $TC_ERR)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_SETMINTABWIDTH, 0, $i_width)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_SETMINTABWIDTH, 0, $i_width)
	EndIf
EndFunc   ;==>_GUICtrlTabSetMinTabWidth

;===============================================================================
;
; Description:			_GUICtrlTabSetPadding
; Parameter(s):		$h_tabcontrol - controlID
;							$i_cx
;							$i_cy
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlTabSetPadding($h_tabcontrol, $i_cx, $i_cy) Sets the amount of space (padding) around each tab's icon and label in a tab control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
; not sure if this ones working
;===============================================================================
;~ Func _GUICtrlTabSetPadding($h_tabcontrol, $i_cx, $i_cy)
;~    If IsHWnd($h_tabcontrol) Then
;~       DllCall("user32.dll", "none", "SendMessage", "hwnd", $h_tabcontrol, "int", $TCM_SETPADDING, "int", 0, "int", $i_cy * 65535 + $i_cx)
;~    Else
;~ 		GUICtrlSendMsg($h_tabcontrol, $TCM_SETPADDING, 0, $i_cy * 65535 + $i_cx)
;~ 	EndIf
;~ EndFunc   ;==>_GUICtrlTabSetPadding

;===============================================================================
;
; Description:			_GUICtrlTabSetUnicodeFormat
; Parameter(s):		$h_tabcontrol - controlID
;							$i_bool - Determines the character set that is used by the control.
;										If this value is nonzero, the control will use Unicode characters.
;										If this value is zero, the control will use ANSI characters.
; Requirement:			None
; Return Value(s):	Returns the previous Unicode format flag for the control.
;							If this value is nonzero, the control is using Unicode characters.
;							If this value is zero, the control is using ANSI characters.
; User CallTip:		_GUICtrlTabSetUnicodeFormat($h_tabcontrol, $i_bool) Sets the Unicode character format flag for the control.  (required: <GuiTab.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTabSetUnicodeFormat($h_tabcontrol, $i_bool)
	If Not _IsClassName ($h_tabcontrol, "SysTabControl32") Then Return SetError($TC_ERR, $TC_ERR, 0)
	If IsHWnd($h_tabcontrol) Then
		Return _SendMessage($h_tabcontrol, $TCM_SETUNICODEFORMAT, $i_bool)
	Else
		Return GUICtrlSendMsg($h_tabcontrol, $TCM_SETUNICODEFORMAT, $i_bool, 0)
	EndIf
EndFunc   ;==>_GUICtrlTabSetUnicodeFormat