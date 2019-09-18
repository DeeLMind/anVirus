#include-once
#include <TreeViewConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with TreeView.
;
; ------------------------------------------------------------------------------



; Default treeview item extended structure
; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/treeview/structures/tvitemex.asp
; Min.OS: 2K, NT4 with IE 4.0, 98, 95 with IE 4.0
Global Const $s_TVITEMEX = "uint;uint;uint;uint;ptr;int;int;int;int;uint;int"

; function list
;===============================================================================
; _GUICtrlTreeViewDeleteAllItems
; _GUICtrlTreeViewDeleteItem
; _GUICtrlTreeViewExpand
; _GUICtrlTreeViewGetBkColor
; _GUICtrlTreeViewGetCount
; _GUICtrlTreeViewGetIndent
; _GUICtrlTreeViewGetLineColor
; _GUICtrlTreeViewGetParentHandle
; _GUICtrlTreeViewGetParentID
; _GUICtrlTreeViewGetState
; _GUICtrlTreeViewGetText
; _GUICtrlTreeViewGetTextColor
; _GUICtrlTreeViewGetTree
; _GUICtrlTreeViewInsertItem
; _GUICtrlTreeViewSelectItem
; _GUICtrlTreeViewSetBkColor
; _GUICtrlTreeViewSetIcon
; _GUICtrlTreeViewSetIndent
; _GUICtrlTreeViewSetLineColor
; _GUICtrlTreeViewSetState
; _GUICtrlTreeViewSetText
; _GUICtrlTreeViewSetTextColor
; _GUICtrlTreeViewSort
;===============================================================================


;===============================================================================
;
; Description:			_GUICtrlTreeViewDeleteAllItems
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	Returns TRUE if successfull or FALSE otherwise.
; User CallTip:		_GUICtrlTreeViewDeleteAllItems($i_treeview) Removes all items from a tree-view control. (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewDeleteAllItems($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, False)
	Return GUICtrlSendMsg($i_treeview, $TVM_DELETEITEM, 0, $TVI_ROOT)
EndFunc   ;==>_GUICtrlTreeViewDeleteAllItems


;===============================================================================
;
; Description:			_GUICtrlTreeViewDeleteItem
; Parameter(s):		$h_wnd - GUI ID
;					$i_treeview - controlID
;					$h_item - Optional: item ID/handle
; Requirement:			None
; Return Value(s):	Returns TRUE if successfull or FALSE otherwise.
; User CallTip:		_GUICtrlTreeViewDeleteItem($h_wnd, $i_treeview[, $h_item = 0]) Removes an item and all its children from a tree-view control. (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):			Rewritten by Holger Kotsch
;
;===============================================================================
Func _GUICtrlTreeViewDeleteItem($h_wnd, $i_treeview, $h_item = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, False)
	Local $ret, $h_item_tmp
	
	If $h_item = 0 Then
		$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
	Else
		$h_item_tmp = GUICtrlGetHandle($h_item)
		If $h_item_tmp <> 0 Then
			GUISetState(@SW_LOCK, $h_wnd)
			$ret = GUICtrlDelete($h_item)
			GUISetState(@SW_UNLOCK, $h_wnd)
			Return $ret
		EndIf
	EndIf
	
	If $h_item > 0 Then
		Return GUICtrlSendMsg($i_treeview, $TVM_DELETEITEM, 0, $h_item)
	Else
		Return 0
	EndIf
EndFunc   ;==>_GUICtrlTreeViewDeleteItem

;===============================================================================
;
; Description:			_GUICtrlTreeViewExpand
; Parameter(s):		$i_treeview	- controlID
;					$i_expand	- Optional: 0 = collapse items / 1 = expand items (default)
;					$h_item		- Optional: item ID or item handle (default 0)
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlTreeViewExpand($i_treeview[, $i_expand = 1[, $h_item = 0]]) Expands or collapses the list of child items associated with the specified parent item, if any. (required: <GuiTreeView.au3>)
; Author(s):		Holger Kotsch
; Note(s):			Completely rewritten (old routine by Gary Frost)
;
;===============================================================================
Func _GUICtrlTreeViewExpand($i_treeview, $b_Expand = 1, $h_item = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, 0)
	Local $h_item_tmp
	
	If $h_item = 0 Then
		$h_item = $TVI_ROOT
	Else
		$h_item_tmp = GUICtrlGetHandle($h_item)
		If $h_item_tmp <> 0 Then $h_item = $h_item_tmp
	EndIf
	
	If $b_Expand Then
		_TreeViewExpandTree($i_treeview, $TVE_EXPAND, $h_item)
	Else
		_TreeViewExpandTree($i_treeview, $TVE_COLLAPSE, $h_item)
	EndIf
EndFunc   ;==>_GUICtrlTreeViewExpand

; Callback function for _GUICtrlTreeViewExpand()
Func _TreeViewExpandTree($i_treeview, $i_expand, $h_item)
	Local $h_child
	
	GUICtrlSendMsg($i_treeview, $TVM_EXPAND, $i_expand, $h_item)
	
	If $i_expand = $TVE_EXPAND And $h_item > 0 Then GUICtrlSendMsg($i_treeview, $TVM_ENSUREVISIBLE, 0, $h_item)
	
	$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $h_item)
	
	While $h_item > 0
		$h_child = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $h_item)
		If $h_child > 0 Then _TreeViewExpandTree($i_treeview, $i_expand, $h_item)
		$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $h_item)
	WEnd
EndFunc   ;==>_TreeViewExpandTree

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetBkColor
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	Returns Hex RGB Back Color of TreeView
; User CallTip:		_GUICtrlTreeViewGetBkColor($i_treeview) Gets the text back color of a Tree-View control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetBkColor($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, 0)
	Local $tc = Hex(String(GUICtrlSendMsg($i_treeview, $TVM_GETBKCOLOR, 0, 0)), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_GUICtrlTreeViewGetBkColor

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetCount
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	Returns the count of items.
; User CallTip:		_GUICtrlTreeViewGetCount($i_treeview) Retrieves a count of the items in a tree-view control. (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetCount($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Return GUICtrlSendMsg($i_treeview, $TVM_GETCOUNT, 0, 0)
EndFunc   ;==>_GUICtrlTreeViewGetCount

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetIndent
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	Returns the amount of indentation.
; User CallTip:		_GUICtrlTreeViewGetIndent($i_treeview) Retrieves the amount, in pixels, that child items are indented relative to their parent items. (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetIndent($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Return GUICtrlSendMsg($i_treeview, $TVM_GETINDENT, 0, 0)
EndFunc   ;==>_GUICtrlTreeViewGetIndent

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetLineColor
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	Returns Hex RGB Line Color of TreeView
; User CallTip:		_GUICtrlTreeViewGetLineColor($i_treeview) Gets the line color of a Tree-View control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetLineColor($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Local $tc = Hex(String(GUICtrlSendMsg($i_treeview, $TVM_GETLINECOLOR, 0, 0)), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_GUICtrlTreeViewGetLineColor

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetParentHandle
; Parameter(s):		$i_treeview - controlID
;					$h_item - Optional: item ID/handle to get the state of
; Requirement:			None
; Return Value(s):	Returns the parent handle
; User CallTip:		_GUICtrlTreeViewGetParentHandle($i_treeview) Gets the parent handle of item (selected) in Tree-View control (required: <GuiTreeView.au3>)
; Author(s):			Holger
;							Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetParentHandle($i_treeview, $h_item = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	If $h_item = 0 Then ; get the handle to item selected
		$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
	Else
		Local $h_itemTmp = GUICtrlGetHandle($h_item)
		If $h_itemTmp <> 0 Then $h_item = $h_itemTmp
	EndIf
	
	If $h_item = 0 Then Return 0
	
	; get the handle of the parent item
	Local $h_parent = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_PARENT, $h_item)
	
	Return $h_parent
EndFunc   ;==>_GUICtrlTreeViewGetParentHandle

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetParentID
; Parameter(s):		$i_treeview - controlID
;					$h_item - Optional: item ID/handle to get the state of
; Requirement:			None
; Return Value(s):	Returns the parent control ID
; User CallTip:		_GUICtrlTreeViewGetParentID($i_treeview) Gets the parent control ID of item (selected) in Tree-View control (required: <GuiTreeView.au3>)
; Author(s):		Original by Gary Frost (custompcs at charter dot net)
;					Rewritten by Holger
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetParentID($i_treeview, $h_item = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	If $h_item = 0 Then ; get the handle to item selected
		$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
	Else
		Local $h_itemTmp = GUICtrlGetHandle($h_item)
		If $h_itemTmp <> 0 Then $h_item = $h_itemTmp
	EndIf
	
	If $h_item = 0 Then Return 0
	
	; get the handle of the parent item
	Local $h_parent = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_PARENT, $h_item)

	Local $st_TVITEM = DllStructCreate("uint;dword;uint;uint;ptr;int;int;int;int;dword")
	DllStructSetData($st_TVITEM, 1, $TVIF_PARAM)
	DllStructSetData($st_TVITEM, 2, $h_parent)
	DllStructSetData($st_TVITEM, 10, 0)
	
	; get the item properties
	If GUICtrlSendMsg($i_treeview, $TVM_GETITEM, 0, DllStructGetPtr($st_TVITEM)) = 0 Then Return 0
	
	Return DllStructGetData($st_TVITEM, 10)
EndFunc   ;==>_GUICtrlTreeViewGetParentID

;===============================================================================
;
; Description:			_GUICtrlTreeViewGetTextColor
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	Returns Hex RGB Text Color of TreeView
; User CallTip:		_GUICtrlTreeViewGetTextColor($i_treeview) Gets the text color of a Tree-View control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetTextColor($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Local $tc = Hex(String(GUICtrlSendMsg($i_treeview, $TVM_GETTEXTCOLOR, 0, 0)), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_GUICtrlTreeViewGetTextColor

;===============================================================================
;
; Description:		_GUICtrlTreeViewGetTree
; Parameter(s):		$i_treeview - controlID
;							$s_sep_char - character used for path seperator
; Requirement:			None
; Return Value(s):	Returns Tree Path of Item
; User CallTip:		_GUICtrlTreeViewGetTree($h_wnd, $i_treeview, $s_sep_char) Get all items text beginning by the current selected item from the Tree-View control (required: <GuiTreeView.au3>)
; Author(s):			Holger
;							Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetTree($i_treeview, $s_sep_char)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, "")
	Local $szPath = "", $hParent, $h_item
	
	$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
	If $h_item > 0 Then
		$szPath = _GUICtrlTreeViewGetText($i_treeview, $h_item)
		
		Do; Get now the parent item handle if there is one
			$hParent = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_PARENT, $h_item)
			If $hParent > 0 Then $szPath = _GUICtrlTreeViewGetText($i_treeview, $hParent) & $s_sep_char & $szPath
			$h_item = $hParent
		Until $h_item <= 0
	EndIf
	
	Return $szPath
EndFunc   ;==>_GUICtrlTreeViewGetTree

;===============================================================================
;
; Description:			_GUICtrlTreeViewSetBkColor
; Parameter(s):		$i_treeview - controlID
;							$v_RGBcolor - New Hex text color
; Requirement:			None
; Return Value(s):	Returns the previous Hex RGB Back Color of TreeView
; User CallTip:		_GUICtrlTreeViewSetBkColor($i_treeview, $v_RGBcolor) Sets the back color of a tree-view control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewSetBkColor($i_treeview, $v_RGBcolor)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Return _TreeViewReverseColorOder(GUICtrlSendMsg($i_treeview, $TVM_SETBKCOLOR, 0, Int(_TreeViewReverseColorOder($v_RGBcolor))))
EndFunc   ;==>_GUICtrlTreeViewSetBkColor

;===============================================================================
;
; Description:			_GUICtrlTreeViewSetIndent
; Parameter(s):		$i_treeview - controlID
;							$i_indent - Width, in pixels, of the indentation.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlTreeViewSetIndent($i_treeview, $i_indent) Sets the width of indentation for a tree-view control and redraws the control to reflect the new width. (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_indent
;								If this parameter is less than the system-defined minimum width,
;								the new width is set to the system-defined minimum.
;
;===============================================================================
Func _GUICtrlTreeViewSetIndent($i_treeview, $i_indent)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, 0)
	GUICtrlSendMsg($i_treeview, $TVM_SETINDENT, $i_indent, 0)
EndFunc   ;==>_GUICtrlTreeViewSetIndent

;===============================================================================
;
; Description:			_GUICtrlTreeViewSetLineColor
; Parameter(s):		$i_treeview - controlID
;							$v_RGBcolor - New Hex text color
; Requirement:			None
; Return Value(s):	Returns the previous Hex RGB Line Color of TreeView
; User CallTip:		_GUICtrlTreeViewSetLineColor($i_treeview, $v_RGBcolor) Sets the line color of a tree-view control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewSetLineColor($i_treeview, $v_RGBcolor)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Return _TreeViewReverseColorOder(GUICtrlSendMsg($i_treeview, $TVM_SETLINECOLOR, 0, Int(_TreeViewReverseColorOder($v_RGBcolor))))
EndFunc   ;==>_GUICtrlTreeViewSetLineColor

;===============================================================================
;
; Description:			_GUICtrlTreeViewSetTextColor
; Parameter(s):		$i_treeview - controlID
;							$v_RGBcolor - New Hex text color
; Requirement:			None
; Return Value(s):	Returns the previous Hex RGB Text Color of TreeView
; User CallTip:		_GUICtrlTreeViewSetTextColor($i_treeview, $v_RGBcolor) Sets the text color of a tree-view control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewSetTextColor($i_treeview, $v_RGBcolor)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, -1)
	Return _TreeViewReverseColorOder(GUICtrlSendMsg($i_treeview, $TVM_SETTEXTCOLOR, 0, Int(_TreeViewReverseColorOder($v_RGBcolor))))
EndFunc   ;==>_GUICtrlTreeViewSetTextColor

;===============================================================================
;
; Description:			_GUICtrlTreeViewSort
; Parameter(s):		$i_treeview - controlID
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlTreeViewSort($i_treeview) Sorts the items of a Tree-View control (required: <GuiTreeView.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewSort($i_treeview)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, 0)
	Local $h_item, $i, $hChild, $i_Recursive = 1
	Local $a_tree
	For $i = 0 To _GUICtrlTreeViewGetCount($i_treeview)
		If $i == 0 Then
			$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $TVI_ROOT)
		Else
			$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $h_item)
		EndIf
		If IsArray($a_tree) Then
			ReDim $a_tree[UBound($a_tree) + 1]
		Else
			Dim $a_tree[1]
		EndIf
		$a_tree[UBound($a_tree) - 1] = $h_item
	Next
	If IsArray($a_tree) Then
		For $i = 0 To UBound($a_tree) - 1
			GUICtrlSendMsg($i_treeview, $TVM_SORTCHILDREN, $i_Recursive, $a_tree[$i]) ; sort the items in root
			Do ; sort all the children
				$hChild = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $h_item)
				If $hChild > 0 Then
					GUICtrlSendMsg($i_treeview, $TVM_SORTCHILDREN, $i_Recursive, $hChild)
				EndIf
				$h_item = $hChild
			Until $h_item <= 0
		Next
	EndIf
EndFunc   ;==>_GUICtrlTreeViewSort

;===============================================================================
;
; Description:		_GUITreeViewInsertItem
; Parameter(s):		$i_treeview		- controlID
;					$s_itemtext		- item text
;					$h_item			- Optional: parent item ID/handle
;					$h_item_after	- Optional: item ID to insert new item after
; Requirement:		<GuiTreeView.au3>
; Return Value(s):	Return the new item handle if successfull or 0 otherwise
; User CallTip:		_GUITreeViewInsertItem($i_treeview, $s_itemtext [, $h_item_parent = 0 [, $h_item_after = 0]])
; Author(s):		Holger Kotsch
; Note(s):			Insert an item into a treeview control
;
;===============================================================================
Func _GUICtrlTreeViewInsertItem($i_treeview, $s_itemtext, $h_item_parent = 0, $h_item_after = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, 0)
	Local $h_item_tmp
	Local $st_TVI = DllStructCreate("uint;uint;" & $s_TVITEMEX)
	If @error Then Return SetError(@error, @error, 0)
	
	Local $st_text = DllStructCreate("char[" & StringLen($s_itemtext) + 1 & "]")
	If @error Then Return SetError(@error, @error, 0)
	
	If $h_item_parent = 0 Then
		$h_item_parent = $TVI_ROOT
	Else
		$h_item_tmp = GUICtrlGetHandle($h_item_parent)
		If $h_item_tmp <> 0 Then $h_item_parent = $h_item_tmp
	EndIf
	
	If $h_item_after = 0 Or _
			($h_item_after <> $TVI_ROOT And _
			$h_item_after <> $TVI_FIRST And _
			$h_item_after <> $TVI_LAST And _
			$h_item_after <> $TVI_SORT) Then
		$h_item_after = $TVI_LAST
	EndIf
	
	DllStructSetData($st_text, 1, $s_itemtext)
	
	Local $u_mask = $TVIF_TEXT
	
	Local $h_icon = _TreeViewGetImageListIconHandle($i_treeview, 0)
	If $h_icon <> 0 Then
		$u_mask = BitOR($u_mask, $TVIF_IMAGE)
		DllStructSetData($st_TVI, 9, 0)
		DllCall("user32.dll", "int", "DestroyIcon", "hwnd", $h_icon)
	EndIf
	
	$h_icon = _TreeViewGetImageListIconHandle($i_treeview, 1)
	If $h_icon <> 0 Then
		$u_mask = BitOR($u_mask, $TVIF_SELECTEDIMAGE)
		DllStructSetData($st_TVI, 10, 0)
		DllCall("user32.dll", "int", "DestroyIcon", "hwnd", $h_icon)
	EndIf
	
	DllStructSetData($st_TVI, 1, $h_item_parent)
	DllStructSetData($st_TVI, 2, $h_item_after)
	DllStructSetData($st_TVI, 3, $u_mask)
	DllStructSetData($st_TVI, 7, DllStructGetPtr($st_text))
	
	Return GUICtrlSendMsg($i_treeview, $TVM_INSERTITEM, 0, DllStructGetPtr($st_TVI))
EndFunc   ;==>_GUICtrlTreeViewInsertItem

;===============================================================================
;
; Description:		_GUICtrlTreeViewSetIcon
; Parameter(s):		$i_treeview		- controlID
;					$h_item			- item ID/handle to set the icon
;					$s_iconfile		- the file to extract the icon of
;					$i_iconID		- the iconID to extract of the file
;					$u_imagemode	- Optional: 2=normal image / 4=seletected image to set (default 6)
; Requirement:		None
; Return Value(s):	Returns TRUE if successfull or FALSE otherwise
; User CallTip:		_GUITreeViewSetIcon($i_treeview, $h_item = 0, $s_iconfile = ""[, $i_iconID = 0[, $u_imagemode = 6]])
; Author(s):		Holger Kotsch
; Note(s):			Change/set an item icon
;
;===============================================================================
Func _GUICtrlTreeViewSetIcon($i_treeview, $h_item = 0, $s_iconfile = "", $i_iconID = 0, $u_imagemode = 6)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, False)
	$h_item = _TreeViewGetItemHandle($i_treeview, $h_item)
	If $h_item = 0 Or $s_iconfile = "" Then Return SetError(1, 1, False)
	
	Local $st_TVITEM = DllStructCreate($s_TVITEMEX)
	If @error Then Return SetError(1, 1, False)
	
	Local $st_icon = DllStructCreate("int")
	Local $i_count = DllCall("shell32.dll", "int", "ExtractIconEx", _
			"str", $s_iconfile, _
			"int", $i_iconID, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($st_icon), _
			"int", 1)
	If $i_count[0] = 0 Then Return 0
	
	Local $h_imagelist = GUICtrlSendMsg($i_treeview, $TVM_GETIMAGELIST, 0, 0)
	If $h_imagelist = 0 Then
		$h_imagelist = DllCall("comctl32.dll", "hwnd", "ImageList_Create", _
				"int", 16, _
				"int", 16, _
				"int", 0x0021, _
				"int", 0, _
				"int", 1)
		$h_imagelist = $h_imagelist[0]
		If $h_imagelist = 0 Then Return SetError(1, 1, False)
		
		GUICtrlSendMsg($i_treeview, $TVM_SETIMAGELIST, 0, $h_imagelist)
	EndIf
	
	Local $h_icon = DllStructGetData($st_icon, 1)
	Local $i_icon = DllCall("comctl32.dll", "int", "ImageList_AddIcon", _
			"hwnd", $h_imagelist, _
			"hwnd", $h_icon)
	$i_icon = $i_icon[0]
	
	DllCall("user32.dll", "int", "DestroyIcon", "hwnd", $h_icon)
	
	Local $u_mask = BitOR($TVIF_IMAGE, $TVIF_SELECTEDIMAGE)
	
	If BitAND($u_imagemode, 2) Then
		DllStructSetData($st_TVITEM, 7, $i_icon)
		If Not BitAND($u_imagemode, 4) Then $u_mask = $TVIF_IMAGE
	EndIf
	
	If BitAND($u_imagemode, 4) Then
		DllStructSetData($st_TVITEM, 8, $i_icon)
		If Not BitAND($u_imagemode, 2) Then
			$u_mask = $TVIF_SELECTEDIMAGE
		Else
			$u_mask = BitOR($TVIF_IMAGE, $TVIF_SELECTEDIMAGE)
		EndIf
	EndIf

	DllStructSetData($st_TVITEM, 1, $u_mask)
	DllStructSetData($st_TVITEM, 2, $h_item)

	Return GUICtrlSendMsg($i_treeview, $TVM_SETITEM, 0, DllStructGetPtr($st_TVITEM))
EndFunc   ;==>_GUICtrlTreeViewSetIcon

;===============================================================================
;
; Description:		_GUICtrlTreeViewGetState
; Parameter(s):		$i_treeview		- controlID
;					$h_item			- item ID/handle to get the state of
; Requirement:		None
; Return Value(s):	Returns the item state if successfull or 0 otherwise
; User CallTip:		_GUITreeViewSetState($i_treeview, $h_item = 0, $s_itemtext)
; Author(s):		Holger Kotsch
; Note(s):			Change/set the state of an item
;
;===============================================================================
Func _GUICtrlTreeViewGetState($i_treeview, $h_item = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, 0)
	$h_item = _TreeViewGetItemHandle($i_treeview, $h_item)
	If $h_item = 0 Then Return SetError(1, 1, 0)
	
	Local $st_TVITEM = DllStructCreate($s_TVITEMEX)
	If @error Then Return SetError(1, 1, 0)
	
	DllStructSetData($st_TVITEM, 1, $TVIF_STATE)
	DllStructSetData($st_TVITEM, 2, $h_item)
	
	If GUICtrlSendMsg($i_treeview, $TVM_GETITEM, 0, DllStructGetPtr($st_TVITEM)) = 0 Then Return 0
	
	Return DllStructGetData($st_TVITEM, 3)
EndFunc   ;==>_GUICtrlTreeViewGetState


;===============================================================================
;
; Description:		_GUICtrlTreeViewSetState
; Parameter(s):		$i_treeview		- controlID
;					$h_item			- item ID/handle to set the icon
;					$i_state			- Optional: the new item state (default 0 - no change) (See Remarks).
;					$i_stateRemove	- Optional: Remove state from item (Default 0 - no state to remove) (See Remarks)
; Requirement:		None
; Return Value(s):	Returns TRUE if successfull or FALSE otherwise
; User CallTip:		_GUITreeViewSetState($i_treeview, $h_item[, $i_state = 0[, $i_stateRemove = 0]) Set the state of the specified treeview item. (required: <GuiTreeView.au3>)
; Author(s):		Holger Kotsch
;						Modified By: Gary Frost (custompcs at charter dot net)
; Note(s):			Change/set the state of an item
;
;===============================================================================
Func _GUICtrlTreeViewSetState($i_treeview, $h_item, $i_state = 0, $i_stateRemove = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, False)
	$h_item = _TreeViewGetItemHandle($i_treeview, $h_item)
	If $h_item = 0 Or ($i_state = 0 And $i_stateRemove = 0) Then Return 0
	
	Local $st_TVITEM = DllStructCreate($s_TVITEMEX)
	If @error Then Return SetError(1, 1, 0)
	DllStructSetData($st_TVITEM, 1, $TVIF_STATE)
	DllStructSetData($st_TVITEM, 2, $h_item)
	DllStructSetData($st_TVITEM, 3, $i_state)
	DllStructSetData($st_TVITEM, 4, $i_state)
	If $i_stateRemove Then DllStructSetData($st_TVITEM, 4, BitOR($i_stateRemove, $i_state))
	Return GUICtrlSendMsg($i_treeview, $TVM_SETITEM, 0, DllStructGetPtr($st_TVITEM))
EndFunc   ;==>_GUICtrlTreeViewSetState


;===============================================================================
;
; Description:		_GUITreeViewSetText
; Parameter(s):		$i_treeview		- controlID
;					$h_item			- item ID to set the icon
;					$s_itemtext		- the new item text
; Requirement:		None
; Return Value(s):	Returns TRUE if successfull or FALSE otherwise
; User CallTip:		_GUITreeViewSetText($i_treeview, $h_item = 0, $s_itemtext)
; Author(s):		Holger Kotsch
; Note(s):			Change/set the text of an item
;
;===============================================================================
Func _GUICtrlTreeViewSetText($i_treeview, $h_item = 0, $s_text = "")
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, False)
	$h_item = _TreeViewGetItemHandle($i_treeview, $h_item)
	If $h_item = 0 Or $s_text = "" Then Return SetError(1, 1, 0)
	
	Local $st_TVITEM = DllStructCreate($s_TVITEMEX)
	If @error Then Return SetError(@error, @error, 0)
	
	Local $st_text = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then Return SetError(@error, @error, 0)
	
	DllStructSetData($st_text, 1, $s_text)
	
	DllStructSetData($st_TVITEM, 1, $TVIF_TEXT)
	DllStructSetData($st_TVITEM, 2, $h_item)
	DllStructSetData($st_TVITEM, 5, DllStructGetPtr($st_text))
	
	Return GUICtrlSendMsg($i_treeview, $TVM_SETITEM, 0, DllStructGetPtr($st_TVITEM))
EndFunc   ;==>_GUICtrlTreeViewSetText


; _GUICtrlTreeViewSelectItem is an depreciated  function
;
; Use GUICtrlSetState($h_itemID, $GUI_FOCUS)
;===============================================================================
;
; Description:		_GUICtrlTreeViewSelectItem
; Parameter(s):		$i_itemID	- item ID
; Requirement:		None
; Return Value(s):	Returns TRUE if successfull or FALSE otherwise.
; User CallTip:		_GUICtrlTreeViewSelectItem($h_itemID) Selects the specified tree-view item, scrolls the item into view)
; Author(s):		Gary Frost (custompcs at charter dot net)
; Note(s):			:
;
;===============================================================================
Func _GUICtrlTreeViewSelectItem($i_itemID)
	GUICtrlSetState($i_itemID, $GUI_FOCUS)
EndFunc   ;==>_GUICtrlTreeViewSelectItem


;===============================================================================
;
; Description:		_GUICtrlTreeViewGetText
; Parameter(s):		$i_treeview	- controlID
; Parameter(s):		$h_item		- item ID or item handle
; Requirement:			None
; Return Value(s):	Returns text of item
;							Returns empty string if it fails
; User CallTip:		_GUICtrlTreeViewGetText($i_treeview, $h_item) Retrieve the item text by sending a right item handle (required: <GuiTreeView.au3>)
; Author(s):			Holger
;							Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlTreeViewGetText($i_treeview, $h_item = 0)
	If Not _IsClassName ($i_treeview, "SysTreeView32") Then Return SetError(-1, -1, "")
	Local $s_text = ""
	
	$h_item = _TreeViewGetItemHandle($i_treeview, $h_item)
	If $h_item = 0 Then Return SetError(1, 1, "")
	
	Local $st_text = DllStructCreate("char[4096]"); create a text 'area' for receiving the text
	If @error Then Return SetError(@error, @error, "")
	
	Local $st_TVITEM = DllStructCreate($s_TVITEMEX)
	If @error Then Return SetError(@error, @error, "")
	
	DllStructSetData($st_TVITEM, 1, $TVIF_TEXT)
	DllStructSetData($st_TVITEM, 2, $h_item)
	DllStructSetData($st_TVITEM, 5, DllStructGetPtr($st_text))
	DllStructSetData($st_TVITEM, 6, DllStructGetSize($st_text))
	
	If GUICtrlSendMsg($i_treeview, $TVM_GETITEM, 0, DllStructGetPtr($st_TVITEM)) Then $s_text = DllStructGetData($st_text, 1)
	
	Return $s_text
EndFunc   ;==>_GUICtrlTreeViewGetText

;===============================================================================
; Description:		Some other helper functions
;===============================================================================


Func _TreeViewDeleteItem($i_treeview, $hChild, $szPath, $szFind)
	Local $t_hchild, $t_child
	$t_hchild = $hChild
	If $szPath = $szFind Then
		Return GUICtrlSendMsg($i_treeview, $TVM_SELECTITEM, $TVGN_CARET, $hChild)
	Else
		Do; Get now the child item handle if there is one
			$t_hchild = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $t_hchild)
			If $t_hchild > 0 Then
				$szPath = _GUICtrlTreeViewGetText($i_treeview, $t_hchild)
				If $szPath = $szFind Then
					Return GUICtrlSendMsg($i_treeview, $TVM_DELETEITEM, 0, $t_hchild)
				Else
					$t_child = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $t_hchild)
					If $t_child > 0 Then
						$szPath = _GUICtrlTreeViewGetText($i_treeview, $t_hchild)
						If $szPath = $szFind Then
							Return GUICtrlSendMsg($i_treeview, $TVM_DELETEITEM, 0, $t_hchild)
						Else
							_TreeViewDeleteItem($i_treeview, $t_hchild, _GUICtrlTreeViewGetText($i_treeview, $t_hchild), $szFind)
						EndIf
					EndIf
				EndIf
			EndIf
		Until $t_hchild <= 0
		$t_hchild = $hChild
		Do; Get now the child item handle if there is one
			$t_hchild = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $t_hchild)
			If $t_hchild > 0 Then
				$szPath = _GUICtrlTreeViewGetText($i_treeview, $t_hchild)
				If $szPath = $szFind Then
					Return GUICtrlSendMsg($i_treeview, $TVM_DELETEITEM, 0, $t_hchild)
				Else
					$t_child = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $t_hchild)
					If $t_child > 0 Then
						_TreeViewDeleteItem($i_treeview, $t_child, _GUICtrlTreeViewGetText($i_treeview, $t_child), $szFind)
						$t_hchild = 0
					EndIf
				EndIf
			EndIf
		Until $t_hchild <= 0
	EndIf
EndFunc   ;==>_TreeViewDeleteItem

Func _TreeViewSelectItem($i_treeview, $hChild, $szPath, $szFind)
	Local $t_hchild, $t_child
	$t_hchild = $hChild
	If $szPath = $szFind Then
		Return GUICtrlSendMsg($i_treeview, $TVM_SELECTITEM, $TVGN_CARET, $hChild)
	Else
		Do; Get now the child item handle if there is one
			$t_hchild = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $t_hchild)
			If $t_hchild > 0 Then
				$szPath = _GUICtrlTreeViewGetText($i_treeview, $t_hchild)
				If $szPath = $szFind Then
					Return GUICtrlSendMsg($i_treeview, $TVM_SELECTITEM, $TVGN_CARET, $t_hchild)
				Else
					$t_child = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $t_hchild)
					If $t_child > 0 Then
						$szPath = _GUICtrlTreeViewGetText($i_treeview, $t_hchild)
						If $szPath = $szFind Then
							Return GUICtrlSendMsg($i_treeview, $TVM_SELECTITEM, $TVGN_CARET, $t_hchild)
						Else
							_TreeViewSelectItem($i_treeview, $t_hchild, _GUICtrlTreeViewGetText($i_treeview, $t_hchild), $szFind)
						EndIf
					EndIf
				EndIf
			EndIf
		Until $t_hchild <= 0
		$t_hchild = $hChild
		Do; Get now the child item handle if there is one
			$t_hchild = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $t_hchild)
			If $t_hchild > 0 Then
				$szPath = _GUICtrlTreeViewGetText($i_treeview, $t_hchild)
				If $szPath = $szFind Then
					Return GUICtrlSendMsg($i_treeview, $TVM_SELECTITEM, $TVGN_CARET, $t_hchild)
				Else
					$t_child = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $t_hchild)
					If $t_child > 0 Then
						_TreeViewSelectItem($i_treeview, $t_child, _GUICtrlTreeViewGetText($i_treeview, $t_child), $szFind)
						$t_hchild = 0
					EndIf
				EndIf
			EndIf
		Until $t_hchild <= 0
	EndIf
EndFunc   ;==>_TreeViewSelectItem

;===============================================================================
;
; Description:			_TreeViewReverseColorOder
; Parameter(s):		$v_color - Hex Color
; Requirement:			None
; Return Value(s):	Return Hex RGB or BGR Color
; User CallTip:		_TreeViewReverseColorOder($v_color) Convert Hex RGB or BGR Color to Hex RGB or BGR Color
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Used for getting/setting view colors
;
;===============================================================================
Func _TreeViewReverseColorOder($v_color)
	Local $tc = Hex(String($v_color), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_TreeViewReverseColorOder

Func _TreeViewGetItemHandle($i_treeview, $h_item)
	If $h_item = 0 Then
		$h_item = GUICtrlSendMsg($i_treeview, $TVM_GETNEXTITEM, $TVGN_ROOT, 0)
	Else
		Local $h_item_tmp = GUICtrlGetHandle($h_item)
		If $h_item_tmp <> 0 Then $h_item = $h_item_tmp
	EndIf
	
	Return $h_item
EndFunc   ;==>_TreeViewGetItemHandle

Func _TreeViewGetImageListIconHandle($i_treeview, $u_index)
	Local $h_imagelist = GUICtrlSendMsg($i_treeview, $TVM_GETIMAGELIST, 0, 0)
	Local $h_icon = DllCall("comctl32.dll", "hwnd", "ImageList_GetIcon", _
			"hwnd", $h_imagelist, _
			"int", $u_index, _
			"int", 0)
	Return $h_icon[0]
EndFunc   ;==>_TreeViewGetImageListIconHandle