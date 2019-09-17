#include-once

#include <EditConstants.au3> ; needed for _GuiCtrlEditFind
#include <GuiStatusBar.au3> ; needed for _GuiCtrlEditFind
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Memory.au3>
#include <Misc.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with Edit control.
;
; ------------------------------------------------------------------------------


; function list
;===============================================================================
; _GUICtrlEditCanUndo
; _GuiCtrlEditFind
; _GUICtrlEditEmptyUndoBuffer
; _GUICtrlEditGetFirstVisibleLine
; _GUICtrlEditGetLine
; _GUICtrlEditGetLineCount
; _GUICtrlEditGetModify
; _GUICtrlEditGetRECT
; _GUICtrlEditGetSel
; _GUICtrlEditLineFromChar
; _GUICtrlEditLineIndex
; _GUICtrlEditLineLength
; _GUICtrlEditLineScroll
; _GUICtrlEditReplaceSel
; _GUICtrlEditScroll
; _GUICtrlEditSetModify
; _GUICtrlEditSetRECT
; _GUICtrlEditSetSel
; _GUICtrlEditUndo
;===============================================================================
; Helper Function(s)
; _GuiCtrlEditFindText
;===============================================================================
;
; Description:			_GUICtrlEditCanUndo
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	If there are actions in the control's undo queue, the return value is nonzero.
;							If the undo queue is empty, the return value is zero.
; User CallTip:		_GUICtrlEditCanUndo($h_edit) Determines whether there are any actions in an edit control's undo queue. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the undo queue is not empty, you can call the _GUICtrlEditUndo
;							to undo the most recent operation.
;
;===============================================================================
Func _GUICtrlEditCanUndo($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_CANUNDO)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_CANUNDO, 0, 0)
	EndIf

EndFunc   ;==>_GUICtrlEditCanUndo

;===============================================================================
;
; Description:			_GUICtrlEditEmptyUndoBuffer
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlEditEmptyUndoBuffer($h_edit) Resets the undo flag of an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The undo flag is automatically reset whenever the edit control receives a WM_SETTEXT or EM_SETHANDLE message.
;							The control can only undo or redo the most recent operation.
;
;===============================================================================
Func _GUICtrlEditEmptyUndoBuffer($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	If IsHWnd($h_Edit) Then
		_SendMessage($h_Edit, $EM_EMPTYUNDOBUFFER)
	Else
		GUICtrlSendMsg($h_Edit, $EM_EMPTYUNDOBUFFER, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditEmptyUndoBuffer

;===============================================================================
;
; Description:			_GuiCtrlEditFind
; Parameter(s):		$h_gui - GUI ID/Window Handle (Handle only be used with external controls)
;							$h_edit - control ID/Control Handle (Handle only be used with external controls)
;							$b_replace - Optional: Boolean True/False show replace option (Default is False)
;							$s_WinTitle - Optional: Window Title (should only be used with external controls)
;							$s_WinText - Optional: Window Text (should only be used with external controls)
; Requirement:			$ES_NOHIDESEL style should be used with edit control
; Return Value(s):	None
; User CallTip:		_GuiCtrlEditFind(ByRef $h_gui, ByRef $h_edit[, $b_replace = False[, $s_WinTitle = ""[, $s_WinText = ""]]]) Find/Replace text in an Edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Be careful using the $s_WinText
;                    if you use text from the edit control and that text gets replaced
;                    the function will no longer function correctly
;
;===============================================================================
Func _GuiCtrlEditFind(ByRef $h_gui, ByRef $h_Edit, $b_replace = False, $s_WinTitle = "", $s_WinText = "")
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	Local $gui_Search, $Input_Search, $Input_Replace, $lbl_replace, $msg_find
	Local $pos = 0, $case, $occurance = 0, $Replacements = 0
	Local $chk_wholeonly, $chk_matchcase, $btn_FindNext, $btn_replace, $btn_close, $StatusBar1
	Local $s_text, $a_sel
	Local $a_PartsRightEdge[3] = [125, 225, -1]
	Local $a_PartsText[3] = ["", "", ""], $t_pos
	If $s_WinTitle <> "" Then
		$s_text = ControlGetText($s_WinTitle, $s_WinText, $h_Edit)
		$a_sel = _GUICtrlEditGetSel($h_Edit)
	Else
		$s_text = GUICtrlRead($h_Edit)
		$a_sel = _GUICtrlEditGetSel($h_Edit)
	EndIf

	$gui_Search = GUICreate("Find", 349, 177, -1, -1, BitOR($WS_CHILD, $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU), -1, $h_gui)
	$StatusBar1 = _GUICtrlStatusBarCreate($gui_Search, $a_PartsRightEdge, $a_PartsText)
	_GUICtrlStatusBarSetText($StatusBar1, "Find: ", 0)
	
	GUISetIcon(@SystemDir & "\shell32.dll", 22, $gui_Search)
	GUICtrlCreateLabel("Find what:", 9, 10, 53, 16, $SS_CENTER)
	$Input_Search = GUICtrlCreateInput("", 80, 8, 257, 21)
	If (IsArray($a_sel) And $a_sel <> $EC_ERR) Then
		GUICtrlSetData($Input_Search, StringMid($s_text, $a_sel[1] + 1, $a_sel[2] - $a_sel[1]))
		If $a_sel[1] <> $a_sel[2] Then ; text was selected when function was invoked
			$pos = $a_sel[1]
			If BitAND(GUICtrlRead($chk_matchcase), $GUI_CHECKED) = $GUI_CHECKED Then $case = 1
			$occurance = 1
			While 1 ; set the current occurance so search starts from here
				$t_pos = StringInStr($s_text, GUICtrlRead($Input_Search), $case, $occurance)
				If Not $t_pos Then ; this should never happen, but just in case
					$occurance = 0
					ExitLoop
				ElseIf $t_pos = $pos + 1 Then ; found the occurance
					ExitLoop
				EndIf
				$occurance += 1
			WEnd
		EndIf
		_GUICtrlStatusBarSetText($StatusBar1, "Find: " & GUICtrlRead($Input_Search), 0)
	EndIf
	$lbl_replace = GUICtrlCreateLabel("Replace with:", 9, 42, 69, 17, $SS_CENTER)
	$Input_Replace = GUICtrlCreateInput("", 80, 40, 257, 21)
	$chk_wholeonly = GUICtrlCreateCheckbox("Match whole word only", 9, 72, 145, 17)
	$chk_matchcase = GUICtrlCreateCheckbox("Match case", 9, 96, 145, 17)
	$btn_FindNext = GUICtrlCreateButton("Find Next", 168, 72, 161, 21, 0)
	$btn_replace = GUICtrlCreateButton("Replace", 168, 96, 161, 21, 0)
	$btn_close = GUICtrlCreateButton("Close", 104, 130, 161, 21, 0)
	
	If $b_replace = False Then
		GUICtrlSetState($lbl_replace, $GUI_HIDE)
		GUICtrlSetState($Input_Replace, $GUI_HIDE)
		GUICtrlSetState($btn_replace, $GUI_HIDE)
	Else
		_GUICtrlStatusBarSetText($StatusBar1, "Replacements: " & $Replacements, 1)
		_GUICtrlStatusBarSetText($StatusBar1, "With: ", 2)
	EndIf
	GUISetState(@SW_SHOW)

	While 1
		$msg_find = GUIGetMsg()
		Select
			Case $msg_find = $GUI_EVENT_CLOSE Or $msg_find = $btn_close
				ExitLoop
			Case $msg_find = $btn_FindNext
				GUICtrlSetState($btn_FindNext, $GUI_DISABLE)
				GUICtrlSetCursor($btn_FindNext, 15)
				Sleep(100)
				_GUICtrlStatusBarSetText($StatusBar1, "Find: " & GUICtrlRead($Input_Search), 0)
				If $b_replace = True Then
					_GUICtrlStatusBarSetText($StatusBar1, "Find: " & GUICtrlRead($Input_Search), 0)
					_GUICtrlStatusBarSetText($StatusBar1, "With: " & GUICtrlRead($Input_Replace), 2)
				EndIf
				_GuiCtrlEditFindText($h_Edit, $Input_Search, $chk_matchcase, $chk_wholeonly, $pos, $occurance, $Replacements, $s_WinTitle, $s_WinText)
				Sleep(100)
				GUICtrlSetState($btn_FindNext, $GUI_ENABLE)
				GUICtrlSetCursor($btn_FindNext, 2)
			Case $msg_find = $btn_replace
				GUICtrlSetState($btn_replace, $GUI_DISABLE)
				GUICtrlSetCursor($btn_replace, 15)
				Sleep(100)
				_GUICtrlStatusBarSetText($StatusBar1, "Find: " & GUICtrlRead($Input_Search), 0)
				_GUICtrlStatusBarSetText($StatusBar1, "With: " & GUICtrlRead($Input_Replace), 2)
				If $pos Then
					_GUICtrlEditReplaceSel($h_Edit, True, GUICtrlRead($Input_Replace))
					$Replacements += 1
					$occurance -= 1
					_GUICtrlStatusBarSetText($StatusBar1, "Replacements: " & $Replacements, 1)
				EndIf
				_GuiCtrlEditFindText($h_Edit, $Input_Search, $chk_matchcase, $chk_wholeonly, $pos, $occurance, $Replacements, $s_WinTitle, $s_WinText)
				Sleep(100)
				GUICtrlSetState($btn_replace, $GUI_ENABLE)
				GUICtrlSetCursor($btn_replace, 2)
		EndSelect
	WEnd
	GUIDelete($gui_Search)
EndFunc   ;==>_GuiCtrlEditFind

;===============================================================================
;
; Description:			_GuiCtrlEditFindText
; Parameter(s):		$h_edit - controlID
;							$Input_Search - controlID
;							$chk_matchcase - controlID
;							$chk_wholeonly - controlID
;							$pos - position of text found
;							$occurance - occurance to find
;							$Replacements - # of occurances replaced
;							$s_WinTitle - Optional: Window Title
;							$s_WinText - Optional: Window Text
; Requirement:			_GuiCtrlEditFind function
; Return Value(s):	None
; User CallTip:
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GuiCtrlEditFindText(ByRef $h_Edit, ByRef $Input_Search, ByRef $chk_matchcase, ByRef $chk_wholeonly, ByRef $pos, ByRef $occurance, ByRef $Replacements, $s_WinTitle = "", $s_WinText = "")
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	Local $case = 0, $whole = 0
	Local $s_text, $exact = False
	Local $s_find = GUICtrlRead($Input_Search)
	If $s_WinTitle <> "" Then
		$s_text = ControlGetText($s_WinTitle, $s_WinText, $h_Edit)
	Else
		$s_text = GUICtrlRead($h_Edit)
	EndIf

	If BitAND(GUICtrlRead($chk_matchcase), $GUI_CHECKED) = $GUI_CHECKED Then $case = 1
	If BitAND(GUICtrlRead($chk_wholeonly), $GUI_CHECKED) = $GUI_CHECKED Then $whole = 1
	If $s_find <> "" Then
		$occurance += 1
		$pos = StringInStr($s_text, $s_find, $case, $occurance)
		If $whole And $pos Then
			Local $c_compare2 = StringMid($s_text, $pos + StringLen($s_find), 1)
			If $pos = 1 Then
				If ($pos + StringLen($s_find)) - 1 = StringLen($s_text) Or _
						($c_compare2 = " " Or $c_compare2 = @LF Or $c_compare2 = @CR Or _
						$c_compare2 = @CRLF Or $c_compare2 = @TAB) Then $exact = True
			Else
				Local $c_compare1 = StringMid($s_text, $pos - 1, 1)
				If ($pos + StringLen($s_find)) - 1 = StringLen($s_text) Then
					If ($c_compare1 = " " Or $c_compare1 = @LF Or $c_compare1 = @CR Or _
							$c_compare1 = @CRLF Or $c_compare1 = @TAB) Then $exact = True
				Else
					If ($c_compare1 = " " Or $c_compare1 = @LF Or $c_compare1 = @CR Or _
							$c_compare1 = @CRLF Or $c_compare1 = @TAB) And _
							($c_compare2 = " " Or $c_compare2 = @LF Or $c_compare2 = @CR Or _
							$c_compare2 = @CRLF Or $c_compare2 = @TAB) Then $exact = True
				EndIf
			EndIf
			If $exact = False Then ; found word, but as part of another word, so search again
				_GuiCtrlEditFindText($h_Edit, $Input_Search, $chk_matchcase, $chk_wholeonly, $pos, $occurance, $Replacements, $s_WinTitle, $s_WinText)
			Else ; found it
				_GUICtrlEditSetSel($h_Edit, $pos - 1, ($pos + StringLen($s_find)) - 1)
				_GUICtrlEditScroll($h_Edit, $SB_SCROLLCARET)
			EndIf
		ElseIf $whole And Not $pos Then ; no more to find
			$occurance = 0
			MsgBox(48, "Find", "Reached End of document, Can not find the string '" & $s_find & "'")
		ElseIf Not $whole Then
			If Not $pos Then ; wrap around search and select
				$occurance = 1
				_GUICtrlEditSetSel($h_Edit, -1, 0)
				_GUICtrlEditScroll($h_Edit, $SB_SCROLLCARET)
				$pos = StringInStr($s_text, $s_find, $case, $occurance)
				If Not $pos Then ; no more to find
					$occurance = 0
					MsgBox(48, "Find", "Reached End of document, Can not find the string  '" & $s_find & "'")
				Else ; found it
					_GUICtrlEditSetSel($h_Edit, $pos - 1, ($pos + StringLen($s_find)) - 1)
					_GUICtrlEditScroll($h_Edit, $SB_SCROLLCARET)
				EndIf
			Else ; set selection
				_GUICtrlEditSetSel($h_Edit, $pos - 1, ($pos + StringLen($s_find)) - 1)
				_GUICtrlEditScroll($h_Edit, $SB_SCROLLCARET)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GuiCtrlEditFindText

;===============================================================================
;
; Description:			_GUICtrlEditGetFirstVisibleLine
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	The return value is the zero-based index of the uppermost visible line in a multiline edit control.
;							For single-line edit controls, the return value is the zero-based index of the first visible character.
; User CallTip:		_GUICtrlEditGetFirstVisibleLine($h_edit) Retrieves the zero-based index of the uppermost visible line in a multiline edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The number of lines and the length of the lines in an edit control
;							depend on the width of the control and the current Wordwrap setting.
;
;===============================================================================
Func _GUICtrlEditGetFirstVisibleLine($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_GETFIRSTVISIBLELINE)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_GETFIRSTVISIBLELINE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditGetFirstVisibleLine

;===============================================================================
;
; Description:			_GUICtrlEditGetLine
; Parameter(s):		$h_edit - controlID
;							$i_line - Specifies the line to be retrieved.
; Requirement:			None
; Return Value(s):	Returns the line from the multiline edit control.
;							If an error occurs, the return value is "" (empty string) and @error is set.
; User CallTip:		_GUICtrlEditGetLine($h_edit, $i_line) Copies a line of text from an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;							Jos van der Zande <jdeb at autoitscript com >
; Note(s):
;
;===============================================================================
Func _GUICtrlEditGetLine(ByRef $h_Edit, $i_line)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, "")
	Local $i_index = _GUICtrlEditLineIndex($h_Edit, $i_line)
	If @error Then Return SetError($EC_ERR, $EC_ERR, "")
	Local $length = _GUICtrlEditLineLength($h_Edit, $i_index)
	If @error Then Return SetError($EC_ERR, $EC_ERR, "")
	Local $struct_Buffer = DllStructCreate("short;char[" & $length + 2 & "]")
	If @error Then Return SetError($EC_ERR, $EC_ERR, "")
	DllStructSetData($struct_Buffer, 1, $length, 1)
	If Not IsHWnd($h_Edit) Then $h_Edit = GUICtrlGetHandle($h_Edit)
	Local $v_ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_Edit, "int", $EM_GETLINE, "int", $i_line - 1, "ptr", DllStructGetPtr($struct_Buffer))
	If $v_ret[0] = $EC_ERR Then Return SetError($EC_ERR, $EC_ERR, "")
	Local $struct_String = DllStructCreate("char[" & $length & "]", DllStructGetPtr($struct_Buffer))
	If @error Then Return SetError($EC_ERR, $EC_ERR, "")
	Return DllStructGetData($struct_String, 1)
EndFunc   ;==>_GUICtrlEditGetLine

;===============================================================================
;
; Description:			_GUICtrlEditGetLineCount
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	The return value is an integer specifying the total number of text lines in the multiline edit control.
; User CallTip:		_GUICtrlEditGetLineCount($h_edit) Retrieves the number of lines in a multiline edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the control has no text, the return value is 1.
;							The return value will never be less than 1.
;
;							The _GUICtrlEditGetLineCount retrieves the total number of text lines,
;							not just the number of lines that are currently visible.
;
;							If the Wordwrap feature is enabled, the number of lines can change when the dimensions of the editing window change.
;
;===============================================================================
Func _GUICtrlEditGetLineCount($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_GETLINECOUNT)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_GETLINECOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditGetLineCount

;===============================================================================
;
; Description:			_GUICtrlEditGetModify
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	If the contents of edit control have been modified, the return value is nonzero
;							otherwise, it is zero.
; User CallTip:		_GUICtrlEditGetModify($h_edit) Retrieves the state of an edit control's modification flag. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The system automatically clears the modification flag to zero when the control is created.
;							If the user changes the control's text, the system sets the flag to nonzero.
;							You can call _GUICtrlEditSetModify to set or clear the flag.
;
;===============================================================================
Func _GUICtrlEditGetModify($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_GETMODIFY)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_GETMODIFY, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditGetModify

;===============================================================================
;
; Description:			_GUICtrlEditGetRECT
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	Array containing the RECT, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $EC_ERR.
; User CallTip:		_GUICtrlEditGetRECT($h_edit) Retrieves the formatting rectangle of an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				You can modify the formatting rectangle of a multiline edit control by using the
;							_GUICtrlEditSetRECT.
;
;							Under certain conditions, _GUICtrlEditGetRECT might not return the exact values that
;							_GUICtrlEditSetRECT set—it will be approximately correct,
;							but it can be off by a few pixels.
;
;===============================================================================
Func _GUICtrlEditGetRECT($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	#cs
		typedef struct _RECT {
		LONG left;
		LONG top;
		LONG right;
		LONG bottom;
		} RECT, *PRECT;
	#ce
	Local $left = 1, $top = 2, $right = 3, $bottom = 4
	Local $struct_Rect = DllStructCreate("int;int;int;int")
	If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		_SendMessage($h_Edit, $EM_GETRECT, 0, DllStructGetPtr($struct_Rect))
		If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	Else
		GUICtrlSendMsg($h_Edit, $EM_GETRECT, 0, DllStructGetPtr($struct_Rect))
		If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	EndIf
	Return StringSplit(DllStructGetData($struct_Rect, $left) & "," & _
			DllStructGetData($struct_Rect, $top) & "," & _
			DllStructGetData($struct_Rect, $right) & "," & _
			DllStructGetData($struct_Rect, $bottom), ",")
EndFunc   ;==>_GUICtrlEditGetRECT

;===============================================================================
;
; Description:			_GUICtrlEditGetSel
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	Array containing the starting and ending selected positions, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $EC_ERR.
; User CallTip:		_GUICtrlEditGetSel($h_edit) Retrieves the starting and ending character positions of the current selection in an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] contains the starting position
;							$array[2] contains the ending position
;
;===============================================================================
Func _GUICtrlEditGetSel($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	Local $ptr1 = "int", $ptr2 = "int", $i_ret
	Local $wparam = DllStructCreate($ptr1)
	Local $a_sel
	If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	Local $lparam = DllStructCreate($ptr2)
	If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		$i_ret = _SendMessage($h_Edit, $EM_GETSEL, DllStructGetPtr($wparam), DllStructGetPtr($lparam))
	Else
		$i_ret = GUICtrlSendMsg($h_Edit, $EM_GETSEL, DllStructGetPtr($wparam), DllStructGetPtr($lparam))
	EndIf
	If ($i_ret == -1) Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	$a_sel = StringSplit(DllStructGetData($wparam, 1) & "," & DllStructGetData($lparam, 1), ",")
	Return $a_sel
EndFunc   ;==>_GUICtrlEditGetSel

;===============================================================================
;
; Description:			_GUICtrlEditLineFromChar
; Parameter(s):		$h_edit - controlID
;							$i_index - Optional: Specifies the character index of the character contained in the line whose number is to be retrieved.
; Requirement:			None
; Return Value(s):	The return value is the zero-based line number of the line containing the character index specified by $i_index.
; User CallTip:		_GUICtrlEditLineFromChar($h_edit[, $i_index = -1]) Retrieves the index of the line that contains the specified character index in a multiline edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If $i_index is –1, _GUICtrlEditLineFromChar retrieves either the line number of the current line
;							(the line containing the caret) or, if there is a selection, the line number of the line containing
;							the beginning of the selection.
;
;===============================================================================
Func _GUICtrlEditLineFromChar($h_Edit, $i_index = -1)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_LINEFROMCHAR, $i_index)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_LINEFROMCHAR, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditLineFromChar

;===============================================================================
;
; Description:			_GUICtrlEditLineIndex
; Parameter(s):		$h_edit - controlID
;							$i_line - Optional: Specifies the zero-based line number.
;										A value of –1 specifies the current line number (the line that contains the caret).
; Requirement:			None
; Return Value(s):	The return value is the character index of the line specified in the wParam parameter,
;							or it is $EC_ERR if the specified line number is greater than the number of lines in the edit control.
; User CallTip:		_GUICtrlEditLineIndex($h_edit[, $i_line = -1]) Retrieves the character index of the first character of a specified line in a multiline edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlEditLineIndex($h_Edit, $i_line = -1)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_LINEINDEX, $i_line)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_LINEINDEX, $i_line, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditLineIndex

;===============================================================================
;
; Description:			_GUICtrlEditLineLength
; Parameter(s):		$h_edit - controlID
;							$i_index - Optional: Specifies the character index of a character in the line whose length is to be retrieved.
; Requirement:			None
; Return Value(s):	For multiline edit controls, the return value is the length, in TCHARs, of the line specified by the $i_index parameter.
;							For single-line edit controls, the return value is the length, in TCHARs, of the text in the edit control.
; User CallTip:		_GUICtrlEditLineLength($h_edit[, $i_index = -1]) Retrieves the length, in characters, of a line in an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_index
;								For ANSI text, this is the number of bytes
;								For Unicode text, this is the number of characters.
;								It does not include the carriage-return character at the end of the line.
;								If $i_index is greater than the number of characters in the control, the return value is zero.
;
;===============================================================================
Func _GUICtrlEditLineLength($h_Edit, $i_index = -1)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_LINELENGTH, $i_index)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_LINELENGTH, $i_index, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditLineLength

;===============================================================================
;
; Description:			_GUICtrlEditLineScroll
; Parameter(s):		$h_edit - controlID
;							$i_horiz - Specifies the number of characters to scroll horizontally.
;							$i_vert - Specifies the number of lines to scroll vertically.
; Requirement:			None
; Return Value(s):	If the message is sent to a multiline edit control, the return value is TRUE.
;							If the message is sent to a single-line edit control, the return value is FALSE.
; User CallTip:		_GUICtrlEditLineScroll($h_edit, $i_horiz, $i_vert) Scrolls the text in a multiline edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The control does not scroll vertically past the last line of text in the edit control.
;							If the current line plus the number of lines specified by the $i_vert parameter exceeds the total number of lines in the edit control,
;							the value is adjusted so that the last line of the edit control is scrolled to the top of the edit-control window.
;
;							_GUICtrlEditLineScroll scrolls the text vertically or horizontally in a multiline edit control.
;							_GUICtrlEditLineScroll can be used to scroll horizontally past the last character of any line.
;
;===============================================================================
Func _GUICtrlEditLineScroll($h_Edit, $i_horiz, $i_vert)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, False)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_LINESCROLL, $i_horiz, $i_vert)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_LINESCROLL, $i_horiz, $i_vert)
	EndIf
EndFunc   ;==>_GUICtrlEditLineScroll

;===============================================================================
;
; Description:			_GUICtrlEditReplaceSel
; Parameter(s):		$h_edit - controlID
;                    $i_bool - Specifies whether the replacement operation can be undone.
;										If this is TRUE, the operation can be undone.
;										If this is FALSE , the operation cannot be undone.
;							$s_text - String containing the replacement text.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlEditReplaceSel($h_edit, $i_bool, $s_text) Replaces the current selection in an edit control with the specified text. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Use the _GUICtrlEditReplaceSel to replace only a portion of the text in an edit control.
;							If there is no current selection, the replacement text is inserted at the current location of the caret.
;
;===============================================================================
Func _GUICtrlEditReplaceSel($h_Edit, $i_bool, $s_text)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	If IsHWnd($h_Edit) Then
		Local $struct_MemMap
		Local $struct_String = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
		If @error Then Return SetError($EC_ERR, $EC_ERR, 0)
		Local $sBuffer_pointer = DllStructGetPtr($struct_String)
		DllStructSetData($struct_String, 1, $s_text)
		_MemInit ($h_Edit, StringLen($s_text) + 1, $struct_MemMap)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($EC_ERR, $EC_ERR, 0)
		EndIf
		_MemWrite ($struct_MemMap, $sBuffer_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($EC_ERR, $EC_ERR, 0)
		EndIf
		_SendMessage($h_Edit, $EM_REPLACESEL, $i_bool, $sBuffer_pointer)
		If @error Then
			_MemFree ($struct_MemMap)
			Return SetError($EC_ERR, $EC_ERR, 0)
		EndIf
		_MemFree ($struct_MemMap)
		If @error Then Return SetError($EC_ERR, $EC_ERR, 0)
;~ 		_SendMessage($h_Edit, $EM_REPLACESEL, $i_bool, $s_text)
	Else
		GUICtrlSendMsg($h_Edit, $EM_REPLACESEL, $i_bool,String( $s_text))
	EndIf
EndFunc   ;==>_GUICtrlEditReplaceSel

;===============================================================================
;
; Description:			_GUICtrlEditScroll
; Parameter(s):		$h_edit - controlID
;							$i_direct - Specifies the action the scroll bar is to take.
; Requirement:			None
; Return Value(s):	If successful, the high-order word of the return value is TRUE, and the low-order word is the number of lines that the command scrolls.
;							If the $i_direct parameter specifies an invalid value, the return value is FALSE.
; User CallTip:		_GUICtrlEditScroll($h_edit, $i_direct) Scrolls the text vertically in a multiline edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_direct
;								This parameter can be one of the following values.
;									$SB_LINEDOWN
;										Scrolls down one line.
;									$SB_LINEUP
;										Scrolls up one line.
;									$SB_PAGEDOWN
;										Scrolls down one page.
;									$SB_PAGEUP
;										Scrolls up one page.
;									$SB_SCROLLCARET
;										Scrolls the caret into view
;
;							To scroll to a specific line or character position, use the _GUICtrlEditLineSscroll.
;
;===============================================================================
Func _GUICtrlEditScroll($h_Edit, $i_direct)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, False)
	If IsHWnd($h_Edit) Then
		If $i_direct == $SB_SCROLLCARET Then
			Return _SendMessage($h_Edit, $EM_SCROLLCARET)
		Else
			Return _SendMessage($h_Edit, $EM_SCROLL, $i_direct)
		EndIf
	Else
		If $i_direct == $SB_SCROLLCARET Then
			Return GUICtrlSendMsg($h_Edit, $EM_SCROLLCARET, 0, 0)
		Else
			Return GUICtrlSendMsg($h_Edit, $EM_SCROLL, $i_direct, 0)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlEditScroll

;===============================================================================
;
; Description:			_GUICtrlEditSetModify
; Parameter(s):		$h_edit - controlID
;							$i_bool - Specifies the new value for the modification flag.
;										A value of TRUE indicates the text has been modified.
;										A value of FALSE indicates it has not been modified.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlEditSetModify($h_edit, $i_bool) Sets or clears the modification flag for an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The system automatically clears the modification flag to zero when the control is created.
;							If the user changes the control's text, the system sets the flag to nonzero.
;							You can use the _GUICtrlEditGetModify to retrieve the current state of the flag.
;
;===============================================================================
Func _GUICtrlEditSetModify($h_Edit, $i_bool)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, False)
	If IsHWnd($h_Edit) Then
		_SendMessage($h_Edit, $EM_SETMODIFY, $i_bool)
	Else
		GUICtrlSendMsg($h_Edit, $EM_SETMODIFY, $i_bool, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditSetModify

;===============================================================================
;
; Description:			_GUICtrlEditSetRECT
; Parameter(s):		$h_edit - controlID
;							$left - Specifies the x-coordinate of the upper-left corner of the rectangle.
;							$top - Specifies the y-coordinate of the upper-left corner of the rectangle.
;							$right - Specifies the x-coordinate of the lower-right corner of the rectangle.
;							$bottom - Specifies the y-coordinate of the lower-right corner of the rectangle.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlEditSetRECT(Byref $h_edit, $left, $top, $right, $bottom) Sets the formatting rectangle of an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlEditSetRECT(ByRef $h_Edit, $left, $top, $right, $bottom)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	Local Const $EM_SETRECT = 0xB3
	Local $struct = DllStructCreate("int;int;int;int")
	DllStructSetData($struct, 1, $left)
	DllStructSetData($struct, 2, $top)
	DllStructSetData($struct, 3, $right + 1)
	DllStructSetData($struct, 4, $bottom + 10)
	If IsHWnd($h_Edit) Then
		_SendMessage($h_Edit, $EM_SETRECT, 0, DllStructGetPtr($struct))
	Else
		GUICtrlSendMsg($h_Edit, $EM_SETRECT, 0, DllStructGetPtr($struct))
	EndIf
EndFunc   ;==>_GUICtrlEditSetRECT

;===============================================================================
;
; Description:			_GUICtrlEditSetSel
; Parameter(s):		$h_edit - controlID
;							$i_start - Specifies the starting character position of the selection.
;							$i_end - Specifies the ending character position of the selection.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlEditSetSel($h_edit, $i_start, $i_end) Selects a range of characters in an edit control. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The start value can be greater than the end value.
;							The lower of the two values specifies the character position of the first character in the selection.
;							The higher value specifies the position of the first character beyond the selection.
;
;							The start value is the anchor point of the selection, and the end value is the active end.
;							If the user uses the SHIFT key to adjust the size of the selection, the active end can move but the anchor point remains the same.
;
;							If the $i_start is 0 and the $i_end is –1, all the text in the edit control is selected.
;							If the $i_start is –1, any current selection is deselected.
;
;							The control displays a flashing caret at the $i_end position regardless of the relative values of $i_start and $i_end.
;
;===============================================================================
Func _GUICtrlEditSetSel($h_Edit, $i_start, $i_end)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	If IsHWnd($h_Edit) Then
		_SendMessage($h_Edit, $EM_SETSEL, $i_start, $i_end)
	Else
		GUICtrlSendMsg($h_Edit, $EM_SETSEL, $i_start, $i_end)
	EndIf
EndFunc   ;==>_GUICtrlEditSetSel

;===============================================================================
;
; Description:			_GUICtrlEditUndo
; Parameter(s):		$h_edit - controlID
; Requirement:			None
; Return Value(s):	For a single-line edit control, the return value is always TRUE.
;							For a multiline edit control, the return value is TRUE if the undo operation is successful,
;							or FALSE if the undo operation fails.
; User CallTip:		_GUICtrlEditUndo($h_edit) Undoes the last edit control operation in the control's undo queue. (required: <GuiEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				An undo operation can also be undone.
;							For example, you can restore deleted text with the first _GUICtrlEditUndo,
;							and remove the text again with a second _GUICtrlEditUndo as long as there
;							is no intervening edit operation.
;
;===============================================================================
Func _GUICtrlEditUndo($h_Edit)
	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, False)
	If IsHWnd($h_Edit) Then
		Return _SendMessage($h_Edit, $EM_UNDO)
	Else
		Return GUICtrlSendMsg($h_Edit, $EM_UNDO, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlEditUndo