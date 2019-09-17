#include-once

#include <ListViewConstants.au3>
#include <Array.au3>
#include <Misc.au3>
#include <Memory.au3>

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with ListView.
;
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; These functions use some code developed by Paul Campbell (PaulIA) for the Auto3Lib project
; particularly the _Mem* function calls which can be found in Memory.au3
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; These Will need to be added to the ListViewConstants.au3 when we are finished
; From A3LConstants.au3
Global Const $LVITEM = "int;int;int;int;int;ptr;int;int;int;int"
; converted from constants to Enum
Global Enum $LVI_MASK = 1, $LVI_IITEM, $LVI_ISUBITEM, $LVI_STATE, $LVI_STATEMASK, $LVI_PSZTEXT, _
		$LVI_CCHTEXTMAX, $LVI_IIMAGE, $LVI_LPARAM, $LVI_IINDENT

;~ Global Const $LVCOLUMN                          = "int;int;int;ptr;int;int;int;int"
Global $LVCOLUMN = "uint;int;int;ptr;int;int;int;int"
; converted from constants to Enum
Global Enum $LVC_MASK = 1, $LVC_FMT, $LVC_CX, $LVC_PSZTEXT, $LVC_CCHTEXTMAX, $LVC_ISUBITEM, $LVC_IIMAGE, $LVC_IORDER

; What I was using
;~ Global Const $LVITEM                            = "int;int;int;int;int;ptr;int;int;int;int;int;ptr"
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------


; function list
;===============================================================================
; _GUICtrlListViewCopyItems
; _GUICtrlListViewDeleteAllItems
; _GUICtrlListViewDeleteColumn
; _GUICtrlListViewDeleteItem
; _GUICtrlListViewDeleteItemsSelected
; _GUICtrlListViewEnsureVisible
; _GUICtrlListViewGetBackColor
; _GUICtrlListViewGetCallBackMask
; _GUICtrlListViewGetCheckedState
; _GUICtrlListViewGetColumnOrder
; _GUICtrlListViewGetColumnWidth
; _GUICtrlListViewGetCounterPage
; _GUICtrlListViewGetCurSel
; _GUICtrlListViewGetExtendedListViewStyle
; _GUICtrlListViewGetHeader
; _GUICtrlListViewGetHotCursor
; _GUICtrlListViewGetHotItem
; _GUICtrlListViewGetHoverTime
; _GUICtrlListViewGetItemCount
; _GUICtrlListViewGetItemText
; _GUICtrlListViewGetItemTextArray
; _GUICtrlListViewGetNextItem
; _GUICtrlListViewGetSelectedCount
; _GUICtrlListViewGetSelectedIndices
; _GUICtrlListViewGetSubItemsCount
; _GUICtrlListViewGetTopIndex
; _GUICtrlListViewGetUnicodeFormat
; _GUICtrlListViewHideColumn
; _GUICtrlListViewInsertColumn
; _GUICtrlListViewInsertItem
; _GUICtrlListViewJustifyColumn
; _GUICtrlListViewScroll
; _GUICtrlListViewSetCheckState
; _GUICtrlListViewSetColumnHeaderText
; _GUICtrlListViewSetColumnOrder
; _GUICtrlListViewSetColumnWidth
; _GUICtrlListViewSetHotItem
; _GUICtrlListViewSetHoverTime
; _GUICtrlListViewSetItemCount
; _GUICtrlListViewSetItemSelState
; _GUICtrlListViewSetItemText
; _GUICtrlListViewSort
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlListViewCopyItems
; Parameter(s):		$h_Source_listview - controlID
;							$h_Destination_listview - control ID
;							$i_DelFlag - Delete after copying (Default: 0)
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlListViewCopyItems($h_Source_listview, $h_Destination_listview[, $i_DelFlag = 0]) Copy Items between 2 list-view controls (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewCopyItems($h_Source_listview, $h_Destination_listview, $i_DelFlag = 0)
	If Not _IsClassName ($h_Source_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	If Not _IsClassName ($h_Destination_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	Local $a_indices, $i, $s_item, $items
	$items = _GUICtrlListViewGetItemCount($h_Source_listview)
	
	If BitAND(_GUICtrlListViewGetExtendedListViewStyle($h_Source_listview), $LVS_EX_CHECKBOXES) == $LVS_EX_CHECKBOXES Then
		For $i = 0 To $items - 1
			If (_GUICtrlListViewGetCheckedState($h_Source_listview, $i)) Then
				If IsArray($a_indices) Then
					ReDim $a_indices[UBound($a_indices) + 1]
				Else
					Local $a_indices[2]
				EndIf
				$a_indices[0] = $a_indices[0] + 1
				$a_indices[UBound($a_indices) - 1] = $i
			EndIf
		Next
		
		If (IsArray($a_indices)) Then
			For $i = 1 To $a_indices[0]
				$s_item = _GUICtrlListViewGetItemText($h_Source_listview, $a_indices[$i])
				_GUICtrlListViewSetCheckState($h_Source_listview, $a_indices[$i], 0)
				_GUICtrlListViewInsertItem($h_Destination_listview, _GUICtrlListViewGetItemCount($h_Destination_listview), $s_item)
			Next
			If $i_DelFlag Then
				For $i = $a_indices[0] To 1 Step - 1
					_GUICtrlListViewSetItemSelState($h_Source_listview, $a_indices[$i])
					_GUICtrlListViewDeleteItem($h_Source_listview, $a_indices[$i])
				Next
			EndIf
		EndIf
	EndIf
	If (_GUICtrlListViewGetSelectedCount($h_Source_listview)) Then
		$a_indices = _GUICtrlListViewGetSelectedIndices($h_Source_listview, 1)
		For $i = 1 To $a_indices[0]
			$s_item = _GUICtrlListViewGetItemText($h_Source_listview, $a_indices[$i])
			_GUICtrlListViewInsertItem($h_Destination_listview, _GUICtrlListViewGetItemCount($h_Destination_listview), $s_item)
		Next
		_GUICtrlListViewSetItemSelState($h_Source_listview, -1, 0)
		If $i_DelFlag Then
			For $i = $a_indices[0] To 1 Step - 1
				_GUICtrlListViewSetItemSelState($h_Source_listview, $a_indices[$i])
				_GUICtrlListViewDeleteItem($h_Source_listview, $a_indices[$i])
			Next
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewCopyItems

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteAllItems
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewDeleteAllItems($h_listview) Removes all items from a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewDeleteAllItems($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $i_index, $control_ID
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_DELETEALLITEMS)
	Else
		For $i_index = _GUICtrlListViewGetItemCount($h_listview) - 1 To 0 Step - 1
			_GUICtrlListViewSetItemSelState($h_listview, $i_index, 1)
			$control_ID = GUICtrlRead($h_listview)
			If $control_ID Then GUICtrlDelete($control_ID)
		Next
		If _GUICtrlListViewGetItemCount($h_listview) == 0 Then
			Return 1
		Else
			Return GUICtrlSendMsg($h_listview, $LVM_DELETEALLITEMS, 0, 0)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteAllItems

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteColumn
; Parameter(s):		$h_listview - controlID
;							$i_col - Index of the column to delete
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewDeleteColumn($h_listview, $i_col) Removes a column from a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Column zero of the list-view control cannot be deleted.
;							If you must delete column zero, insert a zero length dummy
;							column zero and delete column one and above
;
;===============================================================================
Func _GUICtrlListViewDeleteColumn($h_listview, $i_col)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_DELETECOLUMN, $i_col)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_DELETECOLUMN, $i_col, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteColumn

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteItem
; Parameter(s):		$h_listview - controlID
;							$i_index - Index of the list-view item to delete
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewDeleteItem($h_listview, $i_index) Removes an item from a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewDeleteItem($h_listview, $i_index)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $control_ID, $ID_Check
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_DELETEITEM, $i_index)
	Else
		_GUICtrlListViewSetItemSelState($h_listview, -1, 0)
		_GUICtrlListViewSetItemSelState($h_listview, $i_index)
		$control_ID = GUICtrlRead($h_listview)
		If $control_ID Then
			GUICtrlDelete($control_ID)
			_GUICtrlListViewSetItemSelState($h_listview, $i_index)
			$ID_Check = GUICtrlRead($h_listview)
			_GUICtrlListViewSetItemSelState($h_listview, $i_index, 0)
			If $control_ID <> $ID_Check Then
				Return 1
			Else
				Return GUICtrlSendMsg($h_listview, $LVM_DELETEITEM, $i_index, 0)
			EndIf
		Else
			If Not GUICtrlSendMsg($h_listview, $LVM_DELETEITEM, $i_index, 0) Then
				Return _SendMessage($h_listview, $LVM_DELETEITEM, $i_index)
			Else
				Return 1
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteItem

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteItemsSelected
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlListViewDeleteItemsSelected($h_listview) Deletes item(s) selected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Idea from Holger
;
;===============================================================================
Func _GUICtrlListViewDeleteItemsSelected($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	Local $i, $ItemCount
	
	$ItemCount = _GUICtrlListViewGetItemCount($h_listview)
	If (_GUICtrlListViewGetSelectedCount($h_listview) == $ItemCount) Then
		_GUICtrlListViewDeleteAllItems($h_listview)
	Else
		Local $items = _GUICtrlListViewGetSelectedIndices($h_listview, 1)
		If Not IsArray($items) Then Return SetError($LV_ERR, $LV_ERR, 0)
		_GUICtrlListViewSetItemSelState($h_listview, -1, 0)
		For $i = $items[0] To 1 Step - 1
			_GUICtrlListViewDeleteItem($h_listview, $items[$i])
		Next
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteItemsSelected

;===============================================================================
;
; Description:			_GUICtrlListViewEnsureVisible
; Parameter(s):		$h_listview - controlID
;							$i_index - Index of the list-view item
;							$i_bool - Value specifying whether the item must be entirely visible
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewEnsureVisible($h_listview, $i_index, $i_bool) Ensures that a list-view item is either entirely or partially visible (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If $i_bool parameter is TRUE, no scrolling occurs if the item is at least partially visible
;
;===============================================================================
Func _GUICtrlListViewEnsureVisible($h_listview, $i_index, $i_bool)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_ENSUREVISIBLE, $i_index, $i_bool)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_ENSUREVISIBLE, $i_index, $i_bool)
	EndIf
EndFunc   ;==>_GUICtrlListViewEnsureVisible

;===============================================================================
;
; Description:			_GUICtrlListViewFindItem
; Parameter(s):		$h_listview 	- controlID
;							$v_find			- Text/Item Id to find (See Notes)
;							$i_Start			- Index of the item to begin the search with or -1 to start from the beginning.
;													The specified item is itself excluded from the search. (Optional: Default -1)
;							$v_SearchType	- Type of search to perform (See Notes)
;							$v_direction	- Virtual key code that specifies the direction to search (See Notes)
; Requirement:			None
; Return Value(s):	Returns index if successful, or -1 otherwise
; User CallTip:		_GUICtrlListViewFindItem($h_listview, $v_find[, $i_Start = -1[, $v_SearchType = 0x8[, $v_direction = 0x28]]]) Searches for a list-view item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;	$v_SearchType:
;		$LVFI_PARAM
;			Search by Item Id
;		$LVFI_PARTIAL (Default)
;			Checks to see if the item text begins with the string pointed to by the psz member.
;			This value implies use of $LVFI_STRING.
;		$LVFI_STRING
;			Searches based on the item text.
;			Unless additional values are specified, the item text of the matching item must exactly
;			match the string pointed to by the psz member. However, the search is case-insensitive.
;		$LVFI_WRAP
;			Continues the search at the beginning if no match is found
;
;	$v_direction
;		$VK_LEFT
;		$VK_RIGHT
;		$VK_UP
;		$VK_DOWN
;		$VK_HOME
;		$VK_END
;===============================================================================
Func _GUICtrlListViewFindItem($h_listview, $v_find, $i_Start = -1, $v_SearchType = 0x8, $v_direction = 0x28)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $struct_String, $struct_LVFINDINFO, $iResult
	Local $i_Size, $struct_LVFINDINFO_pointer, $struct_MemMap, $Memory_pointer, $string_Memory_pointer, $sBuffer_pointer
	
	$struct_LVFINDINFO = DllStructCreate("uint;ptr;int;int[2];int")
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_LVFINDINFO, 1, $v_SearchType)
	If BitAND($v_SearchType, $LVFI_PARAM) = $LVFI_PARAM Then
		DllStructSetData($struct_LVFINDINFO, 3, $v_find)
	Else
		If StringLen($v_find) = 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		$struct_String = DllStructCreate("char[" & StringLen($v_find) + 1 & "]")
		$sBuffer_pointer = DllStructGetPtr($struct_String)
		DllStructSetData($struct_String, 1, $v_find)
	EndIf
	DllStructSetData($struct_LVFINDINFO, 6, $v_direction)

	If IsHWnd($h_listview) Then
		$i_Size = DllStructGetSize($struct_LVFINDINFO)
		$struct_LVFINDINFO_pointer = DllStructGetPtr($struct_LVFINDINFO)
		If BitAND($v_SearchType, $LVFI_PARAM) = $LVFI_PARAM Then
			$Memory_pointer = _MemInit ($h_listview, $i_Size, $struct_MemMap)
			If @error Then
				_MemFree ($struct_MemMap)
				Return SetError($LV_ERR, $LV_ERR, 0)
			EndIf
			_MemWrite ($struct_MemMap, $struct_LVFINDINFO_pointer)
		Else
			$Memory_pointer = _MemInit ($h_listview, $i_Size + StringLen($v_find) + 1, $struct_MemMap)
			If @error Then
				_MemFree ($struct_MemMap)
				Return SetError($LV_ERR, $LV_ERR, 0)
			EndIf
			$string_Memory_pointer = $Memory_pointer + $i_Size
			DllStructSetData($struct_LVFINDINFO, 2, $string_Memory_pointer)
			_MemWrite ($struct_MemMap, $struct_LVFINDINFO_pointer)
			_MemWrite ($struct_MemMap, $sBuffer_pointer, $string_Memory_pointer, 4096)

		EndIf
		$iResult = _SendMessage($h_listview, $LVM_FINDITEM, $i_Start, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, 0)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, 0)
		Return $iResult
	Else
		If BitAND($v_SearchType, $LVFI_PARAM) <> $LVFI_PARAM Then
			DllStructSetData($struct_LVFINDINFO, 2, DllStructGetPtr($struct_String))
		EndIf
		Return GUICtrlSendMsg($h_listview, $LVM_FINDITEM, $i_Start, DllStructGetPtr($struct_LVFINDINFO))
	EndIf
EndFunc   ;==>_GUICtrlListViewFindItem

;===============================================================================
;
; Description:			_GUICtrlListViewGetBackColor
; Parameter(s):		$h_listview - controlID
; Requirement:			_ReverseColorOrder
; Return Value(s):	Returns the Hex RGB background color of the list-view control
; User CallTip:		_GUICtrlListViewGetBackColor($h_listview) Retrieves the background color of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetBackColor($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $v_color
	If IsHWnd($h_listview) Then
		$v_color = _SendMessage($h_listview, $LVM_GETBKCOLOR)
	Else
		$v_color = GUICtrlSendMsg($h_listview, $LVM_GETBKCOLOR, 0, 0)
	EndIf
	Return _ReverseColorOrder($v_color)
EndFunc   ;==>_GUICtrlListViewGetBackColor

;===============================================================================
;
; Description:			_GUICtrlListViewGetCallBackMask
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the callback mask
; User CallTip:		_GUICtrlListViewGetCallBackMask($h_listview) Retrieves the callback mask for a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCallBackMask($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETCALLBACKMASK)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETCALLBACKMASK, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetCallBackMask

;===============================================================================
;
; Description:			_GUICtrlListViewGetCheckedState
; Parameter(s):		$h_listview - controlID
;							$i_index - zero-based index to retrieve item check state from
; Requirement:			$LVS_EX_CHECKBOXES used in extended style when creating listview
; Return Value(s):	Returns 1 if checked
;							Returns 0 if not checked
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewGetCheckedState($h_listview, $i_index) Returns the check state for a list-view control item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCheckedState($h_listview, $i_index)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $isChecked = 0, $ret
	If IsHWnd($h_listview) Then
		$ret = _SendMessage($h_listview, $LVM_GETITEMSTATE, $i_index, $LVIS_STATEIMAGEMASK)
	Else
		$ret = GUICtrlSendMsg($h_listview, $LVM_GETITEMSTATE, $i_index, $LVIS_STATEIMAGEMASK)
	EndIf
	If (Not $ret) Then
		$ret = _SendMessage($h_listview, $LVM_GETITEMSTATE, $i_index, $LVIS_STATEIMAGEMASK)
		If ($ret == -1) Then
			Return $LV_ERR
		Else
			If (BitAND($ret, 0x3000) == 0x3000) Then
				$isChecked = 0
			Else
				$isChecked = 1
			EndIf
		EndIf
	Else
		If (BitAND($ret, 0x2000) == 0x2000) Then $isChecked = 1
	EndIf
	Return $isChecked
EndFunc   ;==>_GUICtrlListViewGetCheckedState

;===============================================================================
;
; Description:			_GUICtrlListViewGetColumnOrder
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	"|" delimited string
;							If an error occurs, the return value is $LV_ERR.
; User CallTip:		_GUICtrlListViewGetColumnOrder($h_listview) Retrieves the current left-to-right order of columns in a list-view control. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListViewGetColumnOrder($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $i_cols = _GUICtrlListViewGetSubItemsCount($h_listview)
	Local $i, $ret
	Local $struct = ""
	For $i = 1 To $i_cols
		$struct &= "int;"
	Next
	$struct = StringTrimRight($struct, 1)
	Local $column_struct = DllStructCreate($struct)
	If @error Then Return $LV_ERR
	If IsHWnd($h_listview) Then
		Local $struct_MemMap, $sBuffer_pointer
		$sBuffer_pointer = DllStructGetPtr($column_struct)
		Local $i_Size = DllStructGetSize($column_struct)
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, 0)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_GETCOLUMNORDERARRAY, $i_cols, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, 0)
		EndIf
		_MemRead ($struct_MemMap, $Memory_pointer, $sBuffer_pointer, $i_Size)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, 0)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, 0)
	Else
		$ret = GUICtrlSendMsg($h_listview, $LVM_GETCOLUMNORDERARRAY, $i_cols, DllStructGetPtr($column_struct))
	EndIf
	If (Not $ret) Then Return $LV_ERR
	Local $s_cols
	For $i = 1 To $i_cols
		$s_cols &= DllStructGetData($column_struct, $i) & "|"
	Next
	$s_cols = StringTrimRight($s_cols, 1)
	Return $s_cols
EndFunc   ;==>_GUICtrlListViewGetColumnOrder

;===============================================================================
;
; Description:			_GUICtrlListViewGetColumnWidth
; Parameter(s):		$h_listview - controlID
;							$i_col - Index of the column. This parameter is ignored in list view
; Requirement:			None
; Return Value(s):	Returns the column width if successful, or zero otherwise
; User CallTip:		_GUICtrlListViewGetColumnWidth($h_listview, $i_col) Retrieves the width of a column in report or list view (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If this message is sent to a list-view control with the LVS_REPORT style
;							and the specified column doesn't exist, the return value is undefined
;
;===============================================================================
Func _GUICtrlListViewGetColumnWidth($h_listview, $i_col)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETCOLUMNWIDTH, $i_col)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETCOLUMNWIDTH, $i_col, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetColumnWidth

;===============================================================================
;
; Description:			_GUICtrlListViewGetCounterPage
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the number of fully visible items if successful.
;							If the current view is icon or small icon view, the return value
;							is the total number of items in the list-view control.
; User CallTip:		_GUICtrlListViewGetCounterPage($h_listview) Calculates the number of items that can fit vertically in the visible area of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCounterPage($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETCOUNTPERPAGE)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETCOUNTPERPAGE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetCounterPage

;===============================================================================
;
; Description:			_GUICtrlListViewGetCurSel
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Index of current selection (zero-based index)
;							returns $LV_ERR if error
; User CallTip:		_GUICtrlListViewGetCurSel($h_listview) Retrieve the index of current selection (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCurSel($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If _GUICtrlListViewGetSelectedCount($h_listview) > 0 Then
		Return Int(_GUICtrlListViewGetSelectedIndices($h_listview))
	Else
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetCurSel

;===============================================================================
;
; Description:			_GUICtrlListViewGetExtendedListViewStyle
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns a DWORD that represents the styles currently in use for a given list-view control.
;							This value can be a combination of Extended List-View Styles
; User CallTip:		_GUICtrlListViewGetExtendedListViewStyle($h_listview) Retrieves the extended styles that are currently in use for a given list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetExtendedListViewStyle($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETEXTENDEDLISTVIEWSTYLE)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetExtendedListViewStyle

;===============================================================================
;
; Description:			_GUICtrlListViewGetHeader
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the handle to the header control.
; User CallTip:		_GUICtrlListViewGetHeader($h_listview) Retrieves the handle to the header control used by the list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetHeader($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETHEADER)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETHEADER, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetHeader

;===============================================================================
;
; Description:			_GUICtrlListViewGetHotCursor
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns an HCURSOR value that is the handle to the cursor that
;							the list-view control uses when hot tracking is enabled.
; User CallTip:		_GUICtrlListViewGetHotCursor($h_listview) Retrieves the HCURSOR value used when the pointer is over an item while hot tracking is enabled (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				A list-view control uses hot tracking and hover selection when
;							the LVS_EX_TRACKSELECT style is set.
;
;===============================================================================
Func _GUICtrlListViewGetHotCursor($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETHOTCURSOR)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETHOTCURSOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetHotCursor

;===============================================================================
;
; Description:			_GUICtrlListViewGetHotItem
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the index of the item that is hot.
; User CallTip:		_GUICtrlListViewGetHotItem($h_listview) Retrieves the index of the hot item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetHotItem($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETHOTITEM)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETHOTITEM, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetHotItem

;===============================================================================
;
; Description:			_GUICtrlListViewGetHoverTime
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the amount of time, in milliseconds,
;							that the mouse cursor must hover over an item
;							before it is selected.
;							If the return value is -1, then the hover
;							time is the default hover time.
; User CallTip:		_GUICtrlListViewGetHoverTime($h_listview) Retrieves the amount of time that the mouse cursor must hover over an item before it is selected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The hover time only affects list-view controls that have the
;							LVS_EX_TRACKSELECT, LVS_EX_ONECLICKACTIVATE, or
;							LVS_EX_TWOCLICKACTIVATE extended list-view style.
;
;===============================================================================
Func _GUICtrlListViewGetHoverTime($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETHOVERTIME)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETHOVERTIME, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetHoverTime

;===============================================================================
;
; Description:			_GUICtrlListViewGetItemCount
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the number of items.
; User CallTip:		_GUICtrlListViewGetItemCount($h_listview) Retrieves the number of items in a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetItemCount($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETITEMCOUNT)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETITEMCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetItemCount

;===============================================================================
;
; Description:			_GUICtrlListViewGetItemText
; Parameter(s):		$h_listview - controlID
;							$i_Item - index of item to retrieve from (zero-based index)
;							$i_SubItem - column of item to retrieve from (zero-based index)
; Requirement:			None
; Return Value(s):	If $i_SubItem = -1 then row is returned pipe delimited
;							else text from $i_SubItem position is returned
;							If error $LV_ERR is returned
; User CallTip:		_GUICtrlListViewGetItemText($h_listview[, $i_Item=-1[, $i_SubItem=-1]]) Retrieves some or all of a list-view item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetItemText($h_listview, $i_Item = -1, $i_SubItem = -1)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $sBuffer_pointer
	Local $LVITEM_pointer
	Local $Memory_pointer, $struct_MemMap
	Local $i_Size, $string_Memory_pointer
	Local $struct_LVITEM, $struct_String

	$struct_LVITEM = DllStructCreate($LVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, "")
	$struct_String = DllStructCreate("char[4096]")
	If @error Then Return SetError($LV_ERR, $LV_ERR, "")
	If $i_Item = -1 Then $i_Item = Int(_GUICtrlListViewGetSelectedIndices($h_listview))
	If $i_Item = -1 Then Return SetError($LV_ERR, $LV_ERR, "")

	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)

	Local $x_indice, $count, $str = ""

	$count = _GUICtrlListViewGetSubItemsCount($h_listview)
	If Not $count Then $count = 1

	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_Item)
	If ($i_SubItem == -1) Then; return all the subitems in the item
		For $x_indice = 0 To $count - 1 Step 1
			If IsHWnd($h_listview) Then

				$sBuffer_pointer = DllStructGetPtr($struct_String)
				$LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
				$i_Size = DllStructGetSize($struct_LVITEM)
				$Memory_pointer = _MemInit ($h_listview, $i_Size + 4096, $struct_MemMap)
				If @error Then
					_MemFree ($struct_MemMap)
					Return SetError($LV_ERR, $LV_ERR, "")
				EndIf
				$string_Memory_pointer = $Memory_pointer + 4096
				DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $x_indice)
				DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $string_Memory_pointer)
				_MemWrite ($struct_MemMap, $LVITEM_pointer)
				If @error Then
					_MemFree ($struct_MemMap)
					Return SetError($LV_ERR, $LV_ERR, "")
				EndIf
				_SendMessage($h_listview, $LVM_GETITEMA, 0, $Memory_pointer)
				If @error Then
					_MemFree ($struct_MemMap)
					Return SetError($LV_ERR, $LV_ERR, "")
				EndIf
				_MemRead ($struct_MemMap, $string_Memory_pointer, $sBuffer_pointer, 4096)
				If @error Then
					_MemFree ($struct_MemMap)
					Return SetError($LV_ERR, $LV_ERR, "")
				EndIf
				_MemFree ($struct_MemMap)
				If @error Then Return SetError($LV_ERR, $LV_ERR, "")
			Else
				DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, DllStructGetPtr($struct_String))
				DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $x_indice)
				If Not GUICtrlSendMsg($h_listview, $LVM_GETITEMA, 0, DllStructGetPtr($struct_LVITEM)) Then
					SetError($LV_ERR)
				EndIf
			EndIf
			If Not @error Then
				If $x_indice Then
					$str = $str & "|" & DllStructGetData($struct_String, 1)
				Else
					$str = DllStructGetData($struct_String, 1)
				EndIf
			Else
				If StringLen($str) Then
					$str = $str & "|"
				EndIf
			EndIf
		Next
		Return $str
	ElseIf ($i_SubItem < $count) Then; return the subitem in the item
		If IsHWnd($h_listview) Then
			$sBuffer_pointer = DllStructGetPtr($struct_String)
			$LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
			$i_Size = DllStructGetSize($struct_LVITEM)
			$Memory_pointer = _MemInit ($h_listview, $i_Size + 4096, $struct_MemMap)
			If @error Then
				_MemFree ($struct_MemMap)
				Return SetError($LV_ERR, $LV_ERR, "")
			EndIf
			$string_Memory_pointer = $Memory_pointer + 4096
			DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $i_SubItem)
			DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $string_Memory_pointer)
			_MemWrite ($struct_MemMap, $LVITEM_pointer)
			If @error Then
				_MemFree ($struct_MemMap)
				Return SetError($LV_ERR, $LV_ERR, "")
			EndIf
			_SendMessage($h_listview, $LVM_GETITEMA, 0, $Memory_pointer)
			If @error Then
				_MemFree ($struct_MemMap)
				Return SetError($LV_ERR, $LV_ERR, "")
			EndIf
			_MemRead ($struct_MemMap, $string_Memory_pointer, $sBuffer_pointer, 4096)
			If @error Then
				_MemFree ($struct_MemMap)
				Return SetError($LV_ERR, $LV_ERR, "")
			EndIf
			_MemFree ($struct_MemMap)
			If @error Then Return SetError($LV_ERR, $LV_ERR, "")
		Else
			DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, DllStructGetPtr($struct_String))
			DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $i_SubItem)
			If Not GUICtrlSendMsg($h_listview, $LVM_GETITEMA, 0, DllStructGetPtr($struct_LVITEM)) Then Return SetError($LV_ERR, $LV_ERR, "")
		EndIf
		Return DllStructGetData($struct_String, 1)
	Else
		; subitem is out of range
		Return SetError($LV_ERR, $LV_ERR, "")
	EndIf
EndFunc   ;==>_GUICtrlListViewGetItemText

;===============================================================================
;
; Description:			_GUICtrlListViewGetItemTextArray
; Parameter(s):		$h_listview - controlID/handle
;							$i_Item - index of item to retrieve from (zero-based index)
; Requirement:			None
; Return Value(s):	Returns an array of the subitems
;							If $i_Item = -1 current selection is used
;							If error $LV_ERR is returned
; User CallTip:		_GUICtrlListViewGetItemTextA($h_listview[, $i_Item=-1]) Retrieves all of a list-view item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetItemTextArray($h_listview, $i_Item = -1)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $v_ret = _GUICtrlListViewGetItemText($h_listview, $i_Item)
	If @error Or $v_ret = "" Then Return SetError($LV_ERR, $LV_ERR, "")
	Return StringSplit($v_ret, "|")
EndFunc   ;==>_GUICtrlListViewGetItemTextArray

;===============================================================================
;
; Description:			_GUICtrlListViewGetNextItem
; Parameter(s):		$h_GUI - GUI Window handle
;							$h_listview - controlID
;							$i_index - Index of the item to begin the search with
;							$i_direction - Specifies the relationship to the item specified in $i_index
; Requirement:			None
; Return Value(s):	Returns the index of the next item if successful, or $LV_ERR otherwise.
; User CallTip:		_GUICtrlListViewGetNextItem($h_GUI, $h_listview[, $i_index=-1[, $i_direction=0x0]]) Returns the index of the next item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If $i_index = -1 then find the first item that matches the specified $i_direction.
;							The specified item itself is excluded from the search.
;
;							$i_direction
;								Searches by index.
;									$LVNI_ALL
;										Searches for a subsequent item by index, the default value.
;								Searches by physical relationship to the index of the item where the search is to begin.
;									$LVNI_ABOVE
;										Searches for an item that is above the specified item.
;									$LVNI_BELOW
;										Searches for an item that is below the specified item.
;									$LVNI_TOLEFT
;										Searches for an item to the left of the specified item.
;									$LVNI_TORIGHT
;										Searches for an item to the right of the specified item.
;
;===============================================================================
Func _GUICtrlListViewGetNextItem($h_GUI, $h_listview, $i_index = -1, $i_direction = 0x0)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $h_lv
	If IsHWnd($h_listview) Then
		$h_lv = $h_listview
	Else
		$h_lv = ControlGetHandle($h_GUI, "", $h_listview)
	EndIf
	If ($i_direction == $LVNI_ALL Or $i_direction == $LVNI_ABOVE Or _
			$i_direction == $LVNI_BELOW Or $i_direction == $LVNI_TOLEFT Or _
			$i_direction == $LVNI_TORIGHT) Then
		Return _SendMessage($h_lv, $LVM_GETNEXTITEM, $i_index, $i_direction)
	Else
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetNextItem

;===============================================================================
;
; Description:			_GUICtrlListViewGetSelectedCount
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the number of selected items
; User CallTip:		_GUICtrlListViewGetSelectedCount($h_listview) Determines the number of selected items in a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetSelectedCount($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETSELECTEDCOUNT)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETSELECTEDCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetSelectedCount

;===============================================================================
;
; Description:			_GUICtrlListViewGetSelectedIndices
; Parameter(s):		$h_listview - controlID
;							$i_ReturnType - Optional: return a string or array
; Requirement:			None
; Return Value(s):	If $i_ReturnType = 0 then Return pipe delimited string of indices of selected item(s)
;							If $i_ReturnType = 1 then Return array of indices of selected item(s)
;							If no items selected return $LV_ERR
; User CallTip:		_GUICtrlListViewGetSelectedIndices($h_listview[, $i_ReturnType=0]) Retrieve indices of selected item(s) in a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetSelectedIndices($h_listview, $i_ReturnType = 0)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $v_indices
	Local $x_indice, $v_ret
	For $x_indice = 0 To _GUICtrlListViewGetItemCount($h_listview)
		If IsHWnd($h_listview) Then
			$v_ret = _SendMessage($h_listview, $LVM_GETITEMSTATE, $x_indice, $LVIS_SELECTED)
			If $v_ret Then
				If (Not $i_ReturnType) Then
					If StringLen($v_indices) Then
						$v_indices = $v_indices & "|" & $x_indice
					Else
						$v_indices = $x_indice
					EndIf
				Else
					If Not IsArray($v_indices) Then
						Dim $v_indices[2]
					Else
						ReDim $v_indices[UBound($v_indices) + 1]
					EndIf
					$v_indices[0] = UBound($v_indices) - 1
					$v_indices[UBound($v_indices) - 1] = $x_indice
				EndIf
			EndIf
		Else
			$v_ret = GUICtrlSendMsg($h_listview, $LVM_GETITEMSTATE, $x_indice, $LVIS_SELECTED)
			If $v_ret Then
				If (Not $i_ReturnType) Then
					If StringLen($v_indices) Then
						$v_indices = $v_indices & "|" & $x_indice
					Else
						$v_indices = $x_indice
					EndIf
				Else
					If Not IsArray($v_indices) Then
						Dim $v_indices[2]
					Else
						ReDim $v_indices[UBound($v_indices) + 1]
					EndIf
					$v_indices[0] = UBound($v_indices) - 1
					$v_indices[UBound($v_indices) - 1] = $x_indice
				EndIf
			EndIf
		EndIf
	Next
	If (StringLen($v_indices) > 0 Or IsArray($v_indices)) Then
		Return $v_indices
	Else
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetSelectedIndices

;===============================================================================
;
; Description:			_GUICtrlListViewGetSubItemsCount
; Parameter(s):		$h_listview - controlID/handle
; Requirement:			None
; Return Value(s):	Number of columns
; User CallTip:		_GUICtrlListViewGetSubItemsCount(ByRef $h_listview) Retrieve the number of columns (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetSubItemsCount($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
;~ 	Local Const $HDM_GETITEMCOUNT = 0x1200
	Return _SendMessage(_GUICtrlListViewGetHeader($h_listview), 0x1200, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetSubItemsCount

;===============================================================================
;
; Description:			_GUICtrlListViewGetTopIndex
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the index of the item if successful
;							zero if the list-view control is in icon or small icon view.
; User CallTip:		_GUICtrlListViewGetTopIndex($h_listview) Retrieves the index of the topmost visible item when in list or report view (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetTopIndex($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETTOPINDEX)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETTOPINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetTopIndex

;===============================================================================
;
; Description:			_GUICtrlListViewGetUnicodeFormat
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	If this value is nonzero, the control is using Unicode characters.
;							If this value is zero, the control is using ANSI characters.
; User CallTip:		_GUICtrlListViewGetUnicodeFormat($h_listview) Retrieves the UNICODE character format flag for the control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The Unicode format flag is used by Microsoft Windows NT systems
;							with version 4.71 of Comctl32.dll or later. This message is, thus,
;							supported by Windows 2000 and later, and by Windows NT 4 with Microsoft
;							Internet Explorer 4.0 or later. It is only useful on Windows 95 or Windows 98
;							systems with version 5.80 or later of Comctl32.dll.
;
;							This means that they must have Internet Explorer 5 or later installed.
;							Windows 95 and Windows 98 systems with earlier versions of Internet Explorer
;							ignore the Unicode format flag, and its value has no bearing on whether a control
;							supports Unicode. With these systems, you will instead need to test something that
;							requires Unicode support.
;
;===============================================================================
Func _GUICtrlListViewGetUnicodeFormat($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETUNICODEFORMAT)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETUNICODEFORMAT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetUnicodeFormat

;===============================================================================
;
; Description:			_GUICtrlListViewGetView
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns a DWORD that specifies the current view
; User CallTip:		_GUICtrlListViewGetView($h_listview) Retrieves the current view of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Following are the values for views.
;								$LV_VIEW_DETAILS
;								$LV_VIEW_ICON
;								$LV_VIEW_LIST
;								$LV_VIEW_SMALLICON
;								$LV_VIEW_TILE
;
;===============================================================================
Func _GUICtrlListViewGetView($h_listview)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_GETVIEW)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_GETVIEW, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewGetView

;===============================================================================
;
; Description:				_GUICtrlListViewHideColumn
; Parameter(s):			$h_listview - controlID
;								$i_col - column to hide (set width to zero)
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
; User CallTip:			_GUICtrlListViewHideColumn($h_listview,$i_col) Hides the column "sets column width to zero" (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs at charter dot net)
; Note(s):              Idea from Holger
;
;===============================================================================
Func _GUICtrlListViewHideColumn($h_listview, $i_col)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETCOLUMNWIDTH, $i_col)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNWIDTH, $i_col, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewHideColumn

;===============================================================================
;
; Description:				_GUICtrlListViewInsertColumn
; Parameter(s):			$h_listview - controlID
;								$i_col - Zero based index of column position to insert
;								$s_text - Header Text for column
;								$i_justification - Optional: type of justification for column
;								$i_width - Optional: width of the new column
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
;								if error then $LV_ERR is returned
; User CallTip:			_GUICtrlListViewInsertColumn($h_listview, $i_col, $s_text[, $i_justification=0[, $i_width=25]]) Inserts a column into a list-view control (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs at charter dot net)
; Note(s):              $i_justification
;									0 = Left (default)
;									1 = Right
;									2 = Center
;
;===============================================================================
Func _GUICtrlListViewInsertColumn($h_listview, $i_col, $s_text, $i_justification = 0, $i_width = 25)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $struct_LVCOLUMN, $struct_String, $ret

	$struct_LVCOLUMN = DllStructCreate($LVCOLUMN)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	$struct_String = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_String, 1, $s_text)
	DllStructSetData($struct_LVCOLUMN, $LVC_MASK, BitOR($LVCF_WIDTH, $LVCF_FMT, $LVCF_TEXT))
	If ($i_justification == 1) Then
		DllStructSetData($struct_LVCOLUMN, $LVC_FMT, $LVCFMT_RIGHT)
	ElseIf ($i_justification == 2) Then
		DllStructSetData($struct_LVCOLUMN, $LVC_FMT, $LVCFMT_CENTER)
	Else
		DllStructSetData($struct_LVCOLUMN, $LVC_FMT, $LVCFMT_LEFT)
	EndIf
	DllStructSetData($struct_LVCOLUMN, $LVC_CX, $i_width)
	
	If IsHWnd($h_listview) Then
		Local $sBuffer_pointer = DllStructGetPtr($struct_String)
		Local $column_struct_pointer = DllStructGetPtr($struct_LVCOLUMN)
		Local $i_Size = DllStructGetSize($struct_LVCOLUMN)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size + StringLen($s_text) + 1, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		Local $string_Memory_pointer = $Memory_pointer + $i_Size
		DllStructSetData($struct_LVCOLUMN, $LVC_PSZTEXT, $string_Memory_pointer)
		_MemWrite ($struct_MemMap, $column_struct_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer, $string_Memory_pointer, StringLen($s_text) + 1)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_INSERTCOLUMNA, $i_col, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		Return $ret
	Else
		DllStructSetData($struct_LVCOLUMN, $LVC_PSZTEXT, DllStructGetPtr($struct_String))
		$ret = GUICtrlSendMsg($h_listview, $LVM_INSERTCOLUMNA, $i_col, DllStructGetPtr($struct_LVCOLUMN))
	EndIf
	Return $ret
EndFunc   ;==>_GUICtrlListViewInsertColumn

;===============================================================================
;
; Description:				_GUICtrlListViewInsertItem
; Parameter(s):			$h_listview - controlID
;								$i_index - Zero based index of position to insert
;											if -1 the item will append to the end
;								$s_text - text for the new item
; Requirement:				None
; Return Value(s):		Returns the index of the new item if successful, or $LV_ERR otherwise
; User CallTip:			_GUICtrlListViewInsertItem($h_listview, $i_index, $s_text) Inserts a new item in a list-view control. (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs at charter dot net)
; Note(s):              $s_text is "|" delimited text
;
;===============================================================================
Func _GUICtrlListViewInsertItem($h_listview, $i_index, $s_text)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $struct_LVITEM, $struct_String, $ret, $a_text

	$struct_LVITEM = DllStructCreate($LVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	$struct_String = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	$a_text = StringSplit($s_text, "|")
	DllStructSetData($struct_String, 1, $a_text[1])
	If $i_index = -1 Then $i_index = _GUICtrlListViewGetItemCount($h_listview)
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_index)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, StringLen($s_text) + 1)
;~ 	DllStructSetData($struct_LVITEM  , $LVI_IIMAGE    , -1  )
;~ 	DllStructSetData($struct_LVITEM  , $LVI_LPARAM    , 0 )
;~ 	DllStructSetData($struct_LVITEM  , $LVI_IINDENT   , 0 )
	If IsHWnd($h_listview) Then
		Local $sBuffer_pointer = DllStructGetPtr($struct_String)
		Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
		Local $i_Size = DllStructGetSize($struct_LVITEM)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size + StringLen($s_text) + 1, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		Local $string_Memory_pointer = $Memory_pointer + $i_Size
		DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $string_Memory_pointer)
		_MemWrite ($struct_MemMap, $LVITEM_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer, $string_Memory_pointer, StringLen($s_text) + 1)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_INSERTITEMA, 0, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, DllStructGetPtr($struct_String))
		$ret = GUICtrlSendMsg($h_listview, $LVM_INSERTITEMA, 0, DllStructGetPtr($struct_LVITEM))
	EndIf
	Local $i
	For $i = 2 To $a_text[0]
		_GUICtrlListViewSetItemText($h_listview, $i_index, $i - 1, $a_text[$i])
	Next
	Return $ret
EndFunc   ;==>_GUICtrlListViewInsertItem

;===============================================================================
;
; Description:				_GUICtrlListViewJustifyColumn
; Parameter(s):			$h_listview - controlID
;								$i_col - Zero based index of column Justify
;								$i_justification - Optional: type of justification for column
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
;								if error then $LV_ERR is returned
; User CallTip:			_GUICtrlListViewJustifyColumn($h_listview, $i_col[, $i_justification=0]) Set Justification of a column for a list-view control (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs at charter dot net)
; Note(s):              $i_justification
;									0 = Left (default)
;									1 = Right
;									2 = Center
;
;===============================================================================
Func _GUICtrlListViewJustifyColumn($h_listview, $i_col, $i_justification = 0)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $struct_LVCOLUMN, $ret

	$struct_LVCOLUMN = DllStructCreate($LVCOLUMN)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_LVCOLUMN, $LVC_MASK, $LVCF_FMT)
	If ($i_justification == 1) Then
		DllStructSetData($struct_LVCOLUMN, $LVC_FMT, $LVCFMT_RIGHT)
	ElseIf ($i_justification == 2) Then
		DllStructSetData($struct_LVCOLUMN, $LVC_FMT, $LVCFMT_CENTER)
	Else
		DllStructSetData($struct_LVCOLUMN, $LVC_FMT, $LVCFMT_LEFT)
	EndIf
	If IsHWnd($h_listview) Then
		Local $column_struct_pointer = DllStructGetPtr($struct_LVCOLUMN)
		Local $i_Size = DllStructGetSize($struct_LVCOLUMN)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $column_struct_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_SETCOLUMNA, $i_col, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		$ret = GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNA, $i_col, DllStructGetPtr($struct_LVCOLUMN))
	EndIf
	Return $ret
EndFunc   ;==>_GUICtrlListViewJustifyColumn

;===============================================================================
;
; Description:			_GUICtrlListViewScroll
; Parameter(s):		$h_listview - controlID
;							$i_dx - Value of type int that specifies the amount of horizontal scrolling in pixels.
;									  If the list-view control is in list-view, this value specifies the number of columns to scroll
;							$i_dy - Value of type int that specifies the amount of vertical scrolling in pixels
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewScroll($h_listview, $i_dx, $i_dy) Scrolls the content of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				When the list-view control is in report view, the control can
;							only be scrolled vertically in whole line increments.
;
;							Therefore, the $i_dy parameter will be rounded to the nearest number
;							of pixels that form a whole line increment.
;
;							For example, if the height of a line is 16 pixels and 8 is passed for $i_dy,
;							the list will be scrolled by 16 pixels (1 line). If 7 is passed for $i_dy,
;							the list will be scrolled 0 pixels (0 lines).
;
;===============================================================================
Func _GUICtrlListViewScroll($h_listview, $i_dx, $i_dy)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SCROLL, $i_dx, $i_dy)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SCROLL, $i_dx, $i_dy)
	EndIf
EndFunc   ;==>_GUICtrlListViewScroll

;===============================================================================
;
; Description:			_GUICtrlListViewSetCheckState
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero-based index of the item
;							$i_check - Optional: value to set checked state to (1 = checked, 0 = not checked)
; Requirement:			None.
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewSetCheckState($h_listview, $i_index[, $i_check = 1]) Sets the checked state of a list-view control item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_index = -1 sets all items
;							$i_check = 1 (default)
;
;===============================================================================
Func _GUICtrlListViewSetCheckState($h_listview, $i_index, $i_check = 1)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $ret
	Local $struct_LVITEM = DllStructCreate($LVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_index)
	If ($i_check) Then
		DllStructSetData($struct_LVITEM, $LVI_STATE, 0x2000)
	Else
		DllStructSetData($struct_LVITEM, $LVI_STATE, 0x1000)
	EndIf
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	If IsHWnd($h_listview) Then
		Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
		Local $i_Size = DllStructGetSize($struct_LVITEM)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size + 4096, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $LVITEM_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_SETITEMSTATE, $i_index, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		$ret = GUICtrlSendMsg($h_listview, $LVM_SETITEMSTATE, $i_index, DllStructGetPtr($struct_LVITEM))
	EndIf
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetCheckState

;===============================================================================
;
; Description:				_GUICtrlListViewSetColumnHeaderText
; Parameter(s):			$h_listview - controlID
;								$i_col - Zero based index of column Justify
;								$s_text - New text for column header
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
;								if error then $LV_ERR is returned
; User CallTip:			_GUICtrlListViewSetColumnHeaderText($h_listview, $i_col, $s_text) Change the text of a column header for a list-view control (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListViewSetColumnHeaderText($h_listview, $i_col, $s_text)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $struct_LVCOLUMN, $ret, $struct_String

	$struct_String = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_String, 1, $s_text)
	$struct_LVCOLUMN = DllStructCreate($LVCOLUMN)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_LVCOLUMN, $LVC_MASK, $LVCF_TEXT)
	If IsHWnd($h_listview) Then
		Local $sBuffer_pointer = DllStructGetPtr($struct_String)
		Local $column_struct_pointer = DllStructGetPtr($struct_LVCOLUMN)
		Local $i_Size = DllStructGetSize($struct_LVCOLUMN)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size + StringLen($s_text) + 1, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		Local $string_Memory_pointer = $Memory_pointer + $i_Size
		DllStructSetData($struct_LVCOLUMN, $LVC_PSZTEXT, $string_Memory_pointer)
		_MemWrite ($struct_MemMap, $column_struct_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer, $string_Memory_pointer, StringLen($s_text) + 1)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_SETCOLUMNA, $i_col, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		DllStructSetData($struct_LVCOLUMN, $LVC_PSZTEXT, DllStructGetPtr($struct_String))
		$ret = GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNA, $i_col, DllStructGetPtr($struct_LVCOLUMN))
	EndIf
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetColumnHeaderText

;===============================================================================
;
; Description:			_GUICtrlListViewSetColumnOrder
; Parameter(s):		$h_listview - controlID
;							$s_order - "|" delimited column order .i.e "2|0|3|1"
; Requirement:			None
; Return Value(s):	Returns nonzero if successful, or zero otherwise.
;							If an error occurs, the return value is $LV_ERR.
; User CallTip:		_GUICtrlListViewSetColumnOrder($h_listview, $s_order) Sets the left-to-right order of columns in a list-view control. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):           Columns are zero-based
;
;===============================================================================
Func _GUICtrlListViewSetColumnOrder($h_listview, $s_order)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $i, $ret
	Local $struct = ""
	Local $a_order = StringSplit($s_order, "|")
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	For $i = 1 To $a_order[0]
		$struct &= "int;"
	Next
	$struct = StringTrimRight($struct, 1)
	Local $struct_LVCOLUMN = DllStructCreate($struct)
	For $i = 1 To $a_order[0]
		DllStructSetData($struct_LVCOLUMN, $i, $a_order[$i])
	Next
	If IsHWnd($h_listview) Then
		Local $sBuffer_pointer = DllStructGetPtr($struct_LVCOLUMN)
		Local $i_Size = DllStructGetSize($struct_LVCOLUMN)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_SETCOLUMNORDERARRAY, $a_order[0], $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		$ret = GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNORDERARRAY, $a_order[0], DllStructGetPtr($struct_LVCOLUMN))
	EndIf
	If (Not $ret) Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetColumnOrder

;===============================================================================
;
; Description:			_GUICtrlListViewSetColumnWidth
; Parameter(s):		$h_listview - controlID
;							$i_col - Zero-based index of a valid column. For list-view mode, this parameter must be set to zero
;							$i_width - New width of the column, in pixels.
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewSetColumnWidth($h_listview, $i_col, $i_width) Changes the width of a column (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				For list-view mode, this parameter must be set to zero
;
;							$i_width
;								New width of the column, in pixels. For report-view mode, the following special values are supported:
;									$LVSCW_AUTOSIZE
;										Automatically sizes the column.
;									$LVSCW_AUTOSIZE_USEHEADER
;										Automatically sizes the column to fit the header text.
;										If you use this value with the last column, its width
;										is set to fill the remaining width of the list-view control
;
;===============================================================================
Func _GUICtrlListViewSetColumnWidth($h_listview, $i_col, $i_width)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETCOLUMNWIDTH, $i_col, $i_width)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNWIDTH, $i_col, $i_width)
	EndIf
EndFunc   ;==>_GUICtrlListViewSetColumnWidth

;===============================================================================
;
; Description:			_GUICtrlListViewSetHotItem
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero-based index of the item to be set as the hot item
; Requirement:			None
; Return Value(s):	Returns the index of the item that was previously hot
;							$LV_ERR is returned if no item previously hot
; User CallTip:		_GUICtrlListViewSetHotItem($h_listview, $i_index) Sets the hot item for a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewSetHotItem($h_listview, $i_index)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETHOTITEM, $i_index)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETHOTITEM, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewSetHotItem

;===============================================================================
;
; Description:			_GUICtrlListViewSetHoverTime
; Parameter(s):		$h_listview - controlID
;							$i_time - The new amount of time, in milliseconds
; Requirement:			None
; Return Value(s):	Returns the previous hover time
; User CallTip:		_GUICtrlListViewSetHoverTime($h_listview, $i_time) Sets the amount of time which the mouse cursor must hover over an item before it is selected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_time
;								If this value is -1, then the hover time is set to the default hover time
;
;							The hover time only affects list-view controls that have the
;							LVS_EX_TRACKSELECT, LVS_EX_ONECLICKACTIVATE, or
;							LVS_EX_TWOCLICKACTIVATE extended list-view style
;
;===============================================================================
Func _GUICtrlListViewSetHoverTime($h_listview, $i_time)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETHOVERTIME, 0, $i_time)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETHOVERTIME, 0, $i_time)
	EndIf
EndFunc   ;==>_GUICtrlListViewSetHoverTime

;===============================================================================
;
; Description:			_GUICtrlListViewSetItemCount
; Parameter(s):		$h_listview - controlID
;							$i_items - Number of items that the list-view control will ultimately contain.
; Requirement:			None
; Return Value(s):	Returns nonzero if successful, or zero otherwise.
; User CallTip:		_GuiCtrlListViewSetItemCount($h_listview, $i_items) Causes the list-view control to allocate memory for the specified number of items. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Causes the control to allocate its internal data structures for the specified number of items.
;							This prevents the control from having to allocate the data structures every time an item is added.
;
;===============================================================================
Func _GUICtrlListViewSetItemCount($h_listview, $i_items)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETITEMCOUNT, $i_items, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL))
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETITEMCOUNT, $i_items, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL))
	EndIf
EndFunc   ;==>_GUICtrlListViewSetItemCount

;===============================================================================
;
; Description:			_GUICtrlListViewSetItemSelState
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero based index of the item
;							$i_selected - Optional: set the state of the item (1 = selected, 0 = not selected)
;                    $i_focused - Optional: set the state of the item (1 = focused, 0 = not focused) (default = 0)
; Requirement:			None
; Return Value(s):	1 if successful, 0 otherwise
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewSetItemSelState($h_listview, $i_index[, $i_selected = 1[, $i_focused = 0]]) Sets the Item Selected/UnSelected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_index = -1 sets all items for MultiSelect ListView
;
;===============================================================================
Func _GUICtrlListViewSetItemSelState($h_listview, $i_index, $i_selected = 1, $i_focused = 0)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $ret
	Local $struct_LVITEM = DllStructCreate($LVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If ($i_selected == 1) Then
		$i_selected = $LVNI_SELECTED
	Else
		$i_selected = 0
	EndIf
	If ($i_focused == 1) Then
		$i_focused = $LVNI_FOCUSED
	Else
		$i_focused = 0
	EndIf
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_index)
	DllStructSetData($struct_LVITEM, $LVI_STATE, BitOR($i_selected, $i_focused))
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, BitOR($LVIS_SELECTED, $i_focused))
	If IsHWnd($h_listview) Then
		Local $sBuffer_pointer = DllStructGetPtr($struct_LVITEM)
		Local $i_Size = DllStructGetSize($struct_LVITEM)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_SETITEMSTATE, $i_index, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		$ret = GUICtrlSendMsg($h_listview, $LVM_SETITEMSTATE, $i_index, DllStructGetPtr($struct_LVITEM))
	EndIf
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetItemSelState

;===============================================================================
;
; Description:			_GUICtrlListViewSetItemText
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero based index of the item
;							$i_subitem - Index of the subitem, or it can be zero to set the item label.
;							$s_text - String containing the new text
; Requirement:			None
; Return Value(s):	1 if successful, 0 if not
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewSetItemText($h_listview, $i_index, $i_subitem, $s_text) Changes the text of a list-view item or subitem. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListViewSetItemText($h_listview, $i_index, $i_SubItem, $s_text)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $ret
	Local $struct_LVITEM = DllStructCreate($LVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $struct_String = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	DllStructSetData($struct_String, 1, $s_text)
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_index)
	DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $i_SubItem)
	If IsHWnd($h_listview) Then
		Local $sBuffer_pointer = DllStructGetPtr($struct_String)
		Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
		Local $i_Size = DllStructGetSize($struct_LVITEM)
		Local $struct_MemMap
		Local $Memory_pointer = _MemInit ($h_listview, $i_Size + StringLen($s_text) + 1, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		Local $string_Memory_pointer = $Memory_pointer + $i_Size
		DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $string_Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $LVITEM_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer, $string_Memory_pointer, StringLen($s_text) + 1)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		$ret = _SendMessage($h_listview, $LVM_SETITEMTEXTA, 0, $Memory_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Else
		DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, DllStructGetPtr($struct_String))
		$ret = GUICtrlSendMsg($h_listview, $LVM_SETITEMTEXTA, $i_index, DllStructGetPtr($struct_LVITEM))
	EndIf
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetItemText

;===============================================================================
;
; Description:			_GUICtrlListViewSetSelectedColumn
; Parameter(s):		$h_listview - controlID
;							$i_col - Value of type int that specifies the column index
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewSetSelectedColumn($h_listview, $i_col) Sets the index of the selected column (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The column indices are stored in an int array
;
;===============================================================================
Func _GUICtrlListViewSetSelectedColumn($h_listview, $i_col)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETSELECTEDCOLUMN, $i_col)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETSELECTEDCOLUMN, $i_col, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewSetSelectedColumn

;===============================================================================
;
; Description:			_GUICtrlListViewSort
; Parameter(s):		$h_listview - controlID
;                   	$v_descending	- boolean value, can be a single value or array
;                   	$i_sortcol		- column to sort on
; Requirement:			Array.au3
; Return Value(s):	None
; User CallTip:		_GUICtrlListViewSort(ByRef $h_listview, ByRef $v_descending, $i_sortcol) Sorts a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewSort($h_listview, ByRef $v_descending, $i_sortcol)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	Local $X, $Y, $Z, $b_desc, $columns, $items, $v_item, $temp_item
	If _GUICtrlListViewGetItemCount($h_listview) Then
		If (IsArray($v_descending)) Then
			$b_desc = $v_descending[$i_sortcol]
		Else
			$b_desc = $v_descending
		EndIf
		$columns = _GUICtrlListViewGetSubItemsCount($h_listview)
		$items = _GUICtrlListViewGetItemCount($h_listview)
		For $X = 1 To $columns
			$temp_item = $temp_item & " |"
		Next
		$temp_item = StringTrimRight($temp_item, 1)
		Local $a_lv[$items][$columns + 1], $i_selected
		$i_selected = StringSplit(_GUICtrlListViewGetSelectedIndices($h_listview), "|")
		For $X = 0 To UBound($a_lv) - 1 Step 1
			For $Y = 0 To UBound($a_lv, 2) - 2 Step 1
				$v_item = StringStripWS(_GUICtrlListViewGetItemText($h_listview, $X, $Y), 2)
				If (StringIsFloat($v_item) Or StringIsInt($v_item)) Then
					$a_lv[$X][$Y] = Number($v_item)
				Else
					$a_lv[$X][$Y] = $v_item
				EndIf
			Next
			$a_lv[$X][$Y] = $X
		Next
		_ArraySort($a_lv, $b_desc, 0, 0, $columns + 1, $i_sortcol)
		_GUICtrlListViewSetItemSelState($h_listview, -1, 0)
		For $X = 0 To UBound($a_lv) - 1 Step 1
			For $Y = 0 To UBound($a_lv, 2) - 2 Step 1
				_GUICtrlListViewSetItemText($h_listview, $X, $Y, $a_lv[$X][$Y])
			Next
			For $Z = 1 To $i_selected[0]
				If $a_lv[$X][UBound($a_lv, 2) - 1] = $i_selected[$Z]Then
					_GUICtrlListViewSetItemSelState($h_listview, $X, 1, 1)
					ExitLoop
				EndIf
			Next
		Next
		If (IsArray($v_descending)) Then
			$v_descending[$i_sortcol] = Not $b_desc
		Else
			$v_descending = Not $b_desc
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewSort

;===============================================================================
; the following functions are for internal use or possibly new functions as
; of yet not released
;===============================================================================

;===============================================================================
;
; Description:			_ReverseColorOrder
; Parameter(s):		$v_color - Hex Color
; Requirement:			None
; Return Value(s):	Return Hex RGB or BGR Color
; User CallTip:		_ReverseColorOder($v_color) Convert Hex RGB or BGR Color to Hex RGB or BGR Color
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Used for getting List view colors
;
;===============================================================================
Func _ReverseColorOrder($v_color)
	Local $tc = Hex(String($v_color), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_ReverseColorOrder

;===============================================================================
; ====================================================================================================
; Description ..: Arranges items in icon view
; Parameters ...: $h_listview        - Handle to control
;                 $i_arrange        - Alignment. This can be one of the following values:
;                   $LVA_ALIGNLEFT  - Aligns items along the left edge of the window
;                   $LVA_ALIGNTOP   - Aligns items along the top edge of the window
;                   $LVA_DEFAULT    - Aligns items according to the listview controls current alignment
;                     styles (the default value).
;                   $LVA_SNAPTOGRID - Snaps all icons to the nearest grid position.
; Return values : Success - True
;                 Failure - False
; ====================================================================================================
;===============================================================================
Func _GUICtrlListViewArrange($h_listview, $i_arrange)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If $i_arrange <> $LVA_ALIGNLEFT And $i_arrange <> $LVA_ALIGNTOP And _
			$i_arrange <> $LVA_DEFAULT And $i_arrange <> $LVA_SNAPTOGRID Then Return SetError(-1, -1, 0)
	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_ARRANGE, $i_arrange)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_ARRANGE, $i_arrange, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewArrange

; ====================================================================================================
; Description ..: Sets the spacing between icons in listview controls that have the LVS_ICON style
; Parameters ...: $h_listview        - Handle to control
;                 $i_cx          - Distance, in pixels, to set between icons on the x-axis
;                 $i_cy          - Distance, in pixels, to set between icons on the y-axis
; Return values : Returns a DWORD value that contains the previous cx in the low word and the previous
;                 cy in the high word.
; Notes ........: Values for cx and cy are relative to the upper-left corner of an icon bitmap. To set
;                 spacing between icons that do not overlap, the cx or cy values must include the size
;                 of the icon, plus the amount of empty space desired between icons.   Values that  do
;                 not include the width of the icon will result in overlaps.
; ====================================================================================================
Func _GUICtrlListViewSetIconSpacing($h_listview, $i_cx, $i_cy)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If IsHWnd($h_listview) Then
;~ 		Return _SendMessage ($h_listview, $LVM_SETICONSPACING, 0, $i_cx * 65536 + $i_cy)
		Return _SendMessage($h_listview, $LVM_SETICONSPACING, 0, BitOR(BitShift($i_cy, -16), BitAND($i_cx, 0xFFFF)))
	Else
;~ 		Return GUICtrlSendMsg($h_listview, $LVM_SETICONSPACING, 0, $i_cx * 65536 + $i_cy)
		Return GUICtrlSendMsg($h_listview, $LVM_SETICONSPACING, 0, BitOR(BitShift($i_cy, -16), BitAND($i_cx, 0xFFFF)))
	EndIf
EndFunc   ;==>_GUICtrlListViewSetIconSpacing

;===============================================================================
; ====================================================================================================
; Description ..: Moves an item to a specified position in a listview control.  The control must be in
;                 icon or small icon view.
; Parameters ...: $h_listview        - Handle to control
;                 $i_index       - Zero based index of the item
;                 $i_x          - New x-position of the item's upper-left corner, in view coordinates
;                 $i_y          - New y-position of the item's upper-left corner, in view coordinates
; Return values : Success - True
;                 Failure - False
; Notes ........: If the listview control has the $LVS_AUTOARRANGE style, the  items  in  the  listview
;                 control are arranged after the position of the item is set.
; ====================================================================================================
Func _GUICtrlListViewSetItemPosition($h_listview, $i_index, $i_x, $i_y)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, False)
	If IsHWnd($h_listview) Then
;~ 		Return _SendMessage ($h_listview, $LVM_SETITEMPOSITION, $i_index, $i_x * 65536 + $i_y)
		Return _SendMessage($h_listview, $LVM_SETITEMPOSITION, $i_index, BitOR(BitShift($i_y, -16), BitAND($i_x, 0xFFFF)))
	Else
;~ 		Return GUICtrlSendMsg($h_listview, $LVM_SETITEMPOSITION, $i_index, $i_x * 65536 + $i_y)
		Return GUICtrlSendMsg($h_listview, $LVM_SETITEMPOSITION, $i_index, BitOR(BitShift($i_y, -16), BitAND($i_x, 0xFFFF)))
	EndIf
EndFunc   ;==>_GUICtrlListViewSetItemPosition

; ====================================================================================================
; Description ..: Sets the view of a listview control
; Parameters ...: $h_listview        - Handle to control
;                 $i_View        - View state for the control:
;                   $LV_VIEW_DETAILS
;                   $LV_VIEW_ICON
;                   $LV_VIEW_LIST
;                   $LV_VIEW_SMALLICON
;                   $LV_VIEW_TILE
; Return values : Only available for Windows XP
; ====================================================================================================
Func _GUICtrlListViewSetView($h_listview, $i_View)
	If Not _IsClassName ($h_listview, "SysListView32") Then Return SetError($LV_ERR, $LV_ERR, 0)
	If $i_View <> $LV_VIEW_DETAILS And $i_View <> $LV_VIEW_ICON And $i_View <> $LV_VIEW_LIST And _
			$i_View <> $LV_VIEW_SMALLICON And $i_View <> $LV_VIEW_TILE Then Return SetError($LV_ERR, $LV_ERR, 0)

	If IsHWnd($h_listview) Then
		Return _SendMessage($h_listview, $LVM_SETVIEW, $i_View)
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_SETVIEW, $i_View, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewSetView