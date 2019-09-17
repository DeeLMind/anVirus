#include-once
#include <GuiConstants.au3>
#include <GuiListView.au3>

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with array management.
;
; Apr 28, 2005 - Fixed _ArrayTrim(): $iTrimDirection test.
; ------------------------------------------------------------------------------




;===============================================================================
;
; Function Name:  _ArrayAdd()
; Description:    Adds a specified value at the end of an array, returning the
;                 adjusted array.
; Author(s):      Jos van der Zande <jdeb at autoitscript dot com>
;
;===============================================================================
Func _ArrayAdd(ByRef $avArray, $sValue)
	If IsArray($avArray) Then
		ReDim $avArray[UBound($avArray) + 1]
		$avArray[UBound($avArray) - 1] = $sValue
		SetError(0)
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_ArrayAdd


;===============================================================================
;
; Function Name:  _ArrayBinarySearch()
; Description:    Uses the binary search algorithm to search through a
;                 1-dimensional array.
; Author(s):      Jos van der Zande <jdeb at autoitscript dot com>
;
;===============================================================================
Func _ArrayBinarySearch(ByRef $avArray, $sKey, $i_Base = 0)
	Local $iLwrLimit = $i_Base
	Local $iUprLimit
	Local $iMidElement

	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf
	$iUprLimit = UBound($avArray) - 1
	$iMidElement = Int(($iUprLimit + $iLwrLimit) / 2)
	; sKey is smaller than the first entry
	If $avArray[$iLwrLimit] > $sKey Or $avArray[$iUprLimit] < $sKey Then
		SetError(2)
		Return ""
	EndIf

	While $iLwrLimit <= $iMidElement And $sKey <> $avArray[$iMidElement]
		If $sKey < $avArray[$iMidElement] Then
			$iUprLimit = $iMidElement - 1
		Else
			$iLwrLimit = $iMidElement + 1
		EndIf
		$iMidElement = Int(($iUprLimit + $iLwrLimit) / 2)
	WEnd
	If $iLwrLimit > $iUprLimit Then
		; Entry not found
		SetError(3)
		Return ""
	Else
		;Entry found , return the index
		SetError(0)
		Return $iMidElement
	EndIf
EndFunc   ;==>_ArrayBinarySearch

;===============================================================================
;
; Function Name:    _ArrayCreate()
; Description:      Create a small array and quickly assign values.
; Parameter(s):     $v_0  - The first element of the array.
;                   $v_1  - The second element of the array (optional).
;                   ...
;                   $v_20 - The twentyfirst element of the array (optional).
; Requirement(s):   None.
; Return Value(s):  The array with values.
; Author(s):        Dale (Klaatu) Thompson, rewritten JdeB to avoid Eval() errors in Obsufcator
; Note(s):          None.
;
;===============================================================================
Func _ArrayCreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_Array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_Array[@NumParams]
	Return $av_Array
	; Create fake usage for the variables to suppress Au3Check -w 6
EndFunc   ;==>_ArrayCreate


;===============================================================================
;
; Function Name:  _ArrayDelete()
; Description:    Deletes the specified element from the given array, returning
;                 the adjusted array.
; Author(s)       Cephas <cephas at clergy dot net>
; Modifications   Array is passed via Byref  - Jos van der zande
;===============================================================================
Func _ArrayDelete(ByRef $avArray, $iElement)
	Local $iCntr = 0, $iUpper = 0

	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf

	; We have to define this here so that we're sure that $avArray is an array
	; before we get it's size.
	$iUpper = UBound($avArray)    ; Size of original array

	; If the array is only 1 element in size then we can't delete the 1 element.
	If $iUpper = 1 Then
		SetError(2)
		Return ""
	EndIf

	Local $avNewArray[$iUpper - 1]
	If $iElement < 0 Then
		$iElement = 0
	EndIf
	If $iElement > ($iUpper - 1) Then
		$iElement = ($iUpper - 1)
	EndIf
	If $iElement > 0 Then
		For $iCntr = 0 To $iElement - 1
			$avNewArray[$iCntr] = $avArray[$iCntr]
		Next
	EndIf
	If $iElement < ($iUpper - 1) Then
		For $iCntr = ($iElement + 1) To ($iUpper - 1)
			$avNewArray[$iCntr - 1] = $avArray[$iCntr]
		Next
	EndIf
	$avArray = $avNewArray
	SetError(0)
	Return 1
EndFunc   ;==>_ArrayDelete


;===============================================================================
;
; Function Name:  _ArrayDisplay()
;
; Parameter(s):     $ar_2DArray      - Name of Array to display; 1 or 2 dimensional
;                   $sTitle          - [optional] The new title for Array Display ListView.
;                   $i_ShowOver4000  - [optional] 	0 = Limit number of rows displayed to 4000 for speed
;                                    - 				1 = (default) Display all rows [may slow down over 4000]
;                   $i_Transpose     - [optional] 	0 = (default) don't transpose view
;                                    - 				1 = transpose view
;                   $GUIDataSeparatorChar - [optional] 	(default="|") change option of character for ListView display [see Opt("GUIDataSeparatorChar", $GUIDataSeparatorChar)]
;                   $GUIDataReplace       - [optional] 	(default="~") change character to use in items of display if the item contains the separator character
; Requirement(s):   None
; Return Value(s):  On Success -  Returns 1
;                   On Failure -  0 , @error is set to 1.
; Author(s):        randallc
;
;=====================================================================
Func _ArrayDisplay($ar_2DArray, $sTitle = "ListView array 1D and 2D Display", $i_ShowOver4000 = 1, $i_Transpose = 0, $GUIDataSeparatorChar = "|", $GUIDataReplace = "~")
	Local $searchlistView, $hndButton_Close, $sTempHeader = 'Row', $i_Pos, $size, $ar_ExcelValueTrans[1][1], $s_NotDoneLine, $ret
	Local $ar_TempSingle[1], $msg, $hndButton_Array1Box_TextSelect, $searchGUI, $ar_2dCurrent[1][1], $GUICtrlCreateListViewItem
	If Not IsArray($ar_2DArray) Then Return SetError(1, 0, 0)
	; Create GUI and Buttons =========================================================================================
	$searchGUI = GUICreate($sTitle, 810, 623, (@DesktopWidth - 800) / 2, (@DesktopHeight - 600) / 2, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX)
	$hndButton_Array1Box_TextSelect = GUICtrlCreateButton('&Text' & 'Selected', 10, 550, 70, 24)
	GUICtrlSetResizing($hndButton_Array1Box_TextSelect, BitOR($GUI_DockRight, $GUI_DockBottom, $GUI_DockSize))
	$hndButton_Close = GUICtrlCreateButton('&Close', 190, 550, 70, 24)
	GUICtrlSetResizing($hndButton_Close, BitOR($GUI_DockRight, $GUI_DockBottom, $GUI_DockSize))
	GUICtrlSetState($hndButton_Array1Box_TextSelect, ($GUI_DefButton))
	; for 1D; add index column; change to 2D array==================================================================
	If UBound($ar_2DArray, 0) = 1 Then
		ReDim $ar_2dCurrent[UBound($ar_2DArray) ][1]
		For $i = 0 To UBound($ar_2DArray) - 1
			$ar_2dCurrent[$i][0] = $ar_2DArray[$i]
		Next
		$ar_2DArray = $ar_2dCurrent
	EndIf
	; transpose if requested==================================================================
	If $i_Transpose And IsArray($ar_2DArray) And UBound($ar_2DArray, 0) = 2 Then ; transpose if requested
		ReDim $ar_ExcelValueTrans[UBound($ar_2DArray, 2) ][UBound($ar_2DArray, 1) ]
		For $j = 0 To UBound($ar_2DArray, 2) - 1
			For $numb = 0 To UBound($ar_2DArray, 1) - 1
				If $numb > 250 Then ExitLoop  ; limit cols to about 250 as limitation  of GUICreatelistView?
				$ar_ExcelValueTrans[$j][$numb] = $ar_2DArray[$numb][$j]
			Next
		Next
		$ar_2DArray = $ar_ExcelValueTrans
	EndIf
	;Replace any array items containing the LV separator character =============================================
	Opt("GUIDataSeparatorChar", $GUIDataSeparatorChar) ;"|" is the default
	For $x = 0 To UBound($ar_2DArray) - 1 Step 1
		For $y = 0 To UBound($ar_2DArray, 2) - 1 Step 1
			$ar_2DArray[$x][$y] = StringReplace($ar_2DArray[$x][$y], $GUIDataSeparatorChar, $GUIDataReplace)
		Next
	Next
	;; make LV header==================================================================
	For $i = 1 To UBound($ar_2DArray, 2)
		$sTempHeader &= $GUIDataSeparatorChar & 'Col ' & $i - 1
	Next
	StringReplace($sTempHeader, $GUIDataSeparatorChar, "<")
	If @extended > 252 Then
		$i_Pos = StringInStr($sTempHeader, $GUIDataSeparatorChar, 0, 252)
		$sTempHeader = StringLeft($sTempHeader, $i_Pos - 1)
	EndIf
	$s_NotDoneLine = StringReplace($sTempHeader, "Col", "ND")
	;change 2D array to Array LV formatted rows==================================================================
	If UBound($ar_2DArray, 0) = 2 Then
		ReDim $ar_TempSingle[UBound($ar_2DArray) ]
		For $i = 0 To UBound($ar_2DArray) - 1
			$ar_TempSingle[$i] = "[" & $i & "]"
			For $c = 0 To UBound($ar_2DArray, 2) - 1 ;0 is base
				If $c < 251 Then
					$ar_TempSingle[$i] &= $GUIDataSeparatorChar & $ar_2DArray[$i][$c]
				Else
					ExitLoop;$c = UBound($ar_2DArray, 2) - 1
				EndIf
			Next
			$ar_TempSingle[$i] = StringMid($ar_TempSingle[$i], 1, StringLen($ar_TempSingle) - 1)
		Next
	Else
		$ar_TempSingle = $ar_2DArray
	EndIf
	;Create Listview==================================================================
	$size = WinGetClientSize($searchGUI)
	GUICtrlDelete($searchlistView)
	$searchlistView = GUICtrlCreateListView($sTempHeader, 0, 16, $size[0] - 10, $size[1] - 90, BitOR($LVS_SHOWSELALWAYS, $LVS_EDITLABELS), BitOR($LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP, $LVS_EX_FULLROWSELECT, $LVS_EX_REGIONAL))
	GUICtrlSetResizing($searchlistView, BitOR($GUI_DockLeft, $GUI_DockTop, $GUI_DockRight, $GUI_DockBottom))
	For $c = 0 To UBound($ar_TempSingle) - 1
		If ($c < 3999) Or $i_ShowOver4000 Then
			If $c < 3999 Then
				$GUICtrlCreateListViewItem = GUICtrlCreateListViewItem($ar_TempSingle[$c], $searchlistView)
				If Not $GUICtrlCreateListViewItem Then GUICtrlCreateListViewItem($s_NotDoneLine, $searchlistView)
			Else
				$ret = _GUICtrlListViewInsertItem($searchlistView, -1, $ar_TempSingle[$c])
				If ($ret = $LV_ERR) Then _GUICtrlListViewInsertItem($searchlistView, -1, $s_NotDoneLine)
			EndIf
		ElseIf ($c >= 3999) Then
			ExitLoop
		EndIf
	Next
	_GUICtrlListViewSetColumnWidth($searchlistView, 2, $LVSCW_AUTOSIZE)
	If UBound($ar_2DArray, 2) = 1 Then _GUICtrlListViewSetColumnWidth($searchlistView, 1, $LVSCW_AUTOSIZE)
	GUISetState()
	Local $SaveEventMode = Opt("GUIOnEventMode",0) 
	Do ; LOOP
		$msg = GUIGetMsg(1)
		Select
			;Copy all to clipboard(default); or multiple selected rows===============================================================)
			Case $msg[0] = $hndButton_Array1Box_TextSelect
				Local $a_indices[1], $s_CopyLines = ""
				If _GUICtrlListViewGetItemCount($searchlistView) Then $a_indices = _GUICtrlListViewGetSelectedIndices($searchlistView, 1)
				If (IsArray($a_indices)) Then
					ClipPut("")
					For $i = 1 To $a_indices[0]
						$s_CopyLines &= $ar_TempSingle[ $a_indices[$i]] & @LF
					Next
				Else
					For $i = 0 To UBound($ar_TempSingle) - 1
						$s_CopyLines &= $ar_TempSingle[$i] & @LF
					Next
				EndIf
				ClipPut($s_CopyLines)
		EndSelect
	Until $msg[0] = $GUI_EVENT_CLOSE Or $msg[0] = $hndButton_Close
	GUIDelete($searchGUI)
	Opt("GUIOnEventMode",$SaveEventMode) 
	Return SetError(0, 0, 1)
EndFunc   ;==>_ArrayDisplay

;===============================================================================
;
; Function Name:  _ArrayInsert()
; Description:    Add a new value at the specified position.
;
; Author(s):      Jos van der Zande <jdeb at autoitscript dot com>
;
;===============================================================================
Func _ArrayInsert(ByRef $avArray, $iElement, $sValue = "")
	Local $iCntr = 0

	If Not IsArray($avArray) Then
		SetError(1)
		Return 0
	EndIf
	; Add 1 to the Array
	ReDim $avArray[UBound($avArray) + 1]
	; Move all entries one up till the specified Element
	For $iCntr = UBound($avArray) - 1 To $iElement + 1 Step - 1
		$avArray[$iCntr] = $avArray[$iCntr - 1]
	Next
	; add the value in the specified element
	$avArray[$iCntr] = $sValue
	Return 1
EndFunc   ;==>_ArrayInsert


;===============================================================================
;
; Function Name:  _ArrayMax()
; Description:    Returns the highest value held in an array.
; Author(s):      Cephas <cephas at clergy dot net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMax(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	If IsArray($avArray) Then
		Return $avArray[_ArrayMaxIndex($avArray, $iCompNumeric, $i_Base) ]
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_ArrayMax


;===============================================================================
;
; Function Name:  _ArrayMaxIndex()
; Description:    Returns the index where the highest value occurs in the array.
; Author(s):      Cephas <cephas at clergy dot net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMaxIndex(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	Local $iCntr, $iMaxIndex = $i_Base

	If Not IsArray($avArray) Then
		SetError(1)
		Return ""
	EndIf

	Local $iUpper = UBound($avArray)
	For $iCntr = $i_Base To ($iUpper - 1)
		If $iCompNumeric = 1 Then
			If Number($avArray[$iMaxIndex]) < Number($avArray[$iCntr]) Then
				$iMaxIndex = $iCntr
			EndIf
		Else
			If $avArray[$iMaxIndex] < $avArray[$iCntr] Then
				$iMaxIndex = $iCntr
			EndIf
		EndIf
	Next
	SetError(0)
	Return $iMaxIndex
EndFunc   ;==>_ArrayMaxIndex


;===============================================================================
;
; Function Name:  _ArrayMin()
; Description:    Returns the lowest value held in an array.
; Author(s):      Cephas <cephas ay clergy dot net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMin(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	If IsArray($avArray) Then
		Return $avArray[_ArrayMinIndex($avArray, $iCompNumeric, $i_Base) ]
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_ArrayMin


;===============================================================================
;
; Function Name:  _ArrayMinIndex()
; Description:    Returns the index where the lowest value occurs in the array.
; Author(s):      Cephas <cephas at clergy dot net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMinIndex(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	Local $iCntr = 0, $iMinIndex = $i_Base

	If Not IsArray($avArray) Then
		SetError(1)
		Return ""
	EndIf

	Local $iUpper = UBound($avArray)
	For $iCntr = $i_Base To ($iUpper - 1)
		If $iCompNumeric = 1 Then
			If Number($avArray[$iMinIndex]) > Number($avArray[$iCntr]) Then
				$iMinIndex = $iCntr
			EndIf
		Else
			If $avArray[$iMinIndex] > $avArray[$iCntr] Then
				$iMinIndex = $iCntr
			EndIf
		EndIf
	Next
	SetError(0)
	Return $iMinIndex
EndFunc   ;==>_ArrayMinIndex


;===============================================================================
;
; Function Name:  _ArrayPop()
; Description:    Returns the last element of an array, deleting that element
;                 from the array at the same time.
; Author(s):      Cephas <cephas at clergy dot net>
; Modified:       Use Redim to remove last entry.
;===============================================================================
Func _ArrayPop(ByRef $avArray)
	Local $sLastVal
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf
	$sLastVal = $avArray[UBound($avArray) - 1]
	; remove the last value
	If UBound($avArray) = 1 Then
		$avArray = ""
	Else
		ReDim $avArray[UBound($avArray) - 1]
	EndIf
	; return last value
	Return $sLastVal
EndFunc   ;==>_ArrayPop

;=====================================================================================
;
; Function Name:    _ArrayPush
; Description:      Add new values without increasing array size.Either by inserting
;                   at the end the new value and deleting the first one or vice versa.
; Parameter(s):     $avArray      - Array
;                   $sValue       - The new value.It can be an array too.
;                   $i_Direction  - 0 = Leftwise slide (adding at the end) (default)
;                                   1 = Rightwise slide (adding at the start)
; Requirement(s):   None
; Return Value(s):  On Success -  Returns 1
;                   On Failure -  0 if $avArray is not an array.
;								 -1 if $sValue array size is greater than $avArray size.
;								 In both cases @error is set to 1.
; Author(s):        Helias Gerassimou(hgeras)
;
;======================================================================================
Func _ArrayPush(ByRef $avArray, $sValue, $i_Direction = 0)
	Local $i, $j

	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	;
	If (Not IsArray($sValue)) Then
		If $i_Direction = 1 Then
			For $i = (UBound($avArray) - 1) To 1 Step - 1
				$avArray[$i] = $avArray[$i - 1]
			Next
			$avArray[0] = $sValue
		Else
			For $i = 0 To (UBound($avArray) - 2)
				$avArray[$i] = $avArray[$i + 1]
			Next
			$i = (UBound($avArray) - 1)
			$avArray[$i] = $sValue
		EndIf
		;
		SetError(0)
		Return 1
	Else
		If UBound($sValue) > UBound($avArray) Then
			SetError(1)
			Return -1
		Else
			For $j = 0 To (UBound($sValue) - 1)
				If $i_Direction = 1 Then
					For $i = (UBound($avArray) - 1) To 1
						$avArray[$i] = $avArray[$i - 1]
					Next
					$avArray[$j] = $sValue[$j]
				Else
					For $i = 0 To (UBound($avArray) - 2)
						$avArray[$i] = $avArray[$i + 1]
					Next
					$i = (UBound($avArray) - 1)
					$avArray[$i] = $sValue[$j]
				EndIf
			Next
		EndIf
	EndIf
	;
	SetError(0)
	Return 1
	;
EndFunc   ;==>_ArrayPush

;===============================================================================
;
; Function Name:  _ArrayReverse()
; Description:    Takes the given array and reverses the order in which the
;                 elements appear in the array.
; Author(s):      Brian Keene <brian_keene at yahoo dot com>
;
; Modified:       Added $i_Base parameter and logic (Jos van der Zande)
;                 Added $i_UBound parameter and rewrote it for speed. (Tylo)
;===============================================================================

Func _ArrayReverse(ByRef $avArray, $i_Base = 0, $i_UBound = 0)
	If Not IsArray($avArray) Then
		SetError(1)
		Return 0
	EndIf
	Local $tmp, $last = UBound($avArray) - 1
	If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
	For $i = $i_Base To $i_Base + Int(($i_UBound - $i_Base - 1) / 2)
		$tmp = $avArray[$i]
		$avArray[$i] = $avArray[$i_UBound]
		$avArray[$i_UBound] = $tmp
		$i_UBound = $i_UBound - 1
	Next
	Return 1
EndFunc   ;==>_ArrayReverse

;===============================================================================
;
; Function Name:    _ArraySearch()
; Description:      Finds an entry within a one-dimensional array. (Similar to _ArrayBinarySearch() except the array does not need to be sorted.)
; Syntax:           _ArraySearch($avArray, $vWhat2Find, $iStart = 0, $iEnd = 0,$iCaseSense=0, $fPartialSearch = False)
;
; Parameter(s):     $avArray           = The array to search
;                   $vWhat2Find        = What to search $avArray for
;                   $iStart (Optional) = Start array index for search, normally set to 0 or 1. If omitted it is set to 0
;                   $iEnd  (Optional)  = End array index for search. If omitted or set to 0 it is set to Ubound($AvArray)-
;					$iCaseSense (Optional) = If set to 1 then search is case sensitive
;					$fPartialSearch (Optional) = If set to True then executes a partial search. If omitted it is set to False
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns the position of an item in an array.
;                   On Failure - Returns an -1 if $vWhat2Find is not found
;                        @Error=1 $avArray is not an array
;                        @Error=2 $iStart is greater than UBound($AvArray)-1
;                        @Error=3 $iEnd is greater than UBound($AvArray)-1
;                        @Error=4 $iStart is greater than $iEnd
;						 @Error=5 $iCaseSense was invalid. (Must be 0 or 1)
;						 @Error=6 $vWhat2Find was not found in $avArray
;
; Author(s):        SolidSnake <MetalGX91 at GMail dot com> - updated by gcriaco <gcriaco at gmail dot com>
; Note(s):          This might be slower than _ArrayBinarySearch() but is useful when the array's order can't be altered.
;===============================================================================
Func _ArraySearch(Const ByRef $avArray, $vWhat2Find, $iStart = 0, $iEnd = 0, $iCaseSense = 0, $fPartialSearch = False)
	Local $iCurrentPos, $iUBound, $iResult
	If Not IsArray($avArray) Then
		SetError(1)
		Return -1
	EndIf
	$iUBound = UBound($avArray) - 1
	If $iEnd = 0 Then $iEnd = $iUBound
	If $iStart > $iUBound Then
		SetError(2)
		Return -1
	EndIf
	If $iEnd > $iUBound Then
		SetError(3)
		Return -1
	EndIf
	If $iStart > $iEnd Then
		SetError(4)
		Return -1
	EndIf
	If Not ($iCaseSense = 0 Or $iCaseSense = 1) Then
		SetError(5)
		Return -1
	EndIf
	For $iCurrentPos = $iStart To $iEnd
		Select
			Case $iCaseSense = 0
				If $fPartialSearch = False Then
					If $avArray[$iCurrentPos] = $vWhat2Find Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				Else
					$iResult = StringInStr($avArray[$iCurrentPos], $vWhat2Find, $iCaseSense)
					If $iResult > 0 Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				EndIf
			Case $iCaseSense = 1
				If $fPartialSearch = False Then
					If $avArray[$iCurrentPos] == $vWhat2Find Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				Else
					$iResult = StringInStr($avArray[$iCurrentPos], $vWhat2Find, $iCaseSense)
					If $iResult > 0 Then
						SetError(0)
						Return $iCurrentPos
					EndIf
				EndIf
		EndSelect
	Next
	SetError(6)
	Return -1
EndFunc   ;==>_ArraySearch

;===============================================================================
;
; Function Name:    _ArraySort()
; Description:      Sort an 1 or 2 dimensional Array on a specific index
;                   using the quicksort/insertsort algorithms.
; Parameter(s):     $a_Array      - Array
;                   $i_Descending - Sort Descending when 1
;                   $i_Base       - Start sorting at this Array entry.
;                   $I_Ubound     - End sorting at this Array entry.
;                                   Default UBound($a_Array) - 1
;                   $i_Dim        - Elements to sort in second dimension
;                   $i_SortIndex  - The Index to Sort the Array on.
;                                   (for 2-dimensional arrays only)
; Requirement(s):   None
; Return Value(s):  On Success - 1 and the sorted array is set
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jos van der Zande <jdeb at autoitscript dot com>
;                   LazyCoder - added $i_SortIndex option
;                   Tylo - implemented stable QuickSort algo
;                   Jos - Changed logic to correctly Sort arrays with mixed Values and Strings
;
;===============================================================================
;
Func _ArraySort(ByRef $a_Array, $i_Decending = 0, $i_Base = 0, $i_UBound = 0, $i_Dim = 1, $i_SortIndex = 0)
	; Set to ubound when not specified
	If Not IsArray($a_Array) Then
		SetError(1)
		Return 0
	EndIf
	Local $last = UBound($a_Array) - 1
	If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last

	If $i_Dim = 1 Then
		__ArrayQSort1($a_Array, $i_Base, $i_UBound)
		If $i_Decending Then _ArrayReverse($a_Array, $i_Base, $i_UBound)
	Else
		__ArrayQSort2($a_Array, $i_Base, $i_UBound, $i_Dim, $i_SortIndex, $i_Decending)
	EndIf
	Return 1
EndFunc   ;==>_ArraySort

; Private
Func __ArrayQSort1(ByRef $array, ByRef $left, ByRef $right)
	Local $i, $j, $t
	If $right - $left < 10 Then
		; InsertSort - fastest on small segments (= 25% total speedup)
		For $i = $left + 1 To $right
			$t = $array[$i]
			$j = $i
			While $j > $left _
					And ((IsNumber($array[$j - 1]) = IsNumber($t) And $array[$j - 1] > $t) _
					Or (IsNumber($array[$j - 1]) <> IsNumber($t) And String($array[$j - 1]) > String($t)))
				$array[$j] = $array[$j - 1]
				$j = $j - 1
			WEnd
			$array[$j] = $t
		Next
		Return
	EndIf

	; QuickSort - fastest on large segments
	Local $pivot = $array[Int(($left + $right) / 2) ]
	Local $L = $left
	Local $R = $right
	Do
		While ((IsNumber($array[$L]) = IsNumber($pivot) And $array[$L] < $pivot) _
				Or (IsNumber($array[$L]) <> IsNumber($pivot) And String($array[$L]) < String($pivot)))
			;While $array[$L] < $pivot
			$L = $L + 1
		WEnd
		While ((IsNumber($array[$R]) = IsNumber($pivot) And $array[$R] > $pivot) _
				Or (IsNumber($array[$R]) <> IsNumber($pivot) And String($array[$R]) > String($pivot)))
			;	While $array[$R] > $pivot
			$R = $R - 1
		WEnd
		; Swap
		If $L <= $R Then
			$t = $array[$L]
			$array[$L] = $array[$R]
			$array[$R] = $t
			$L = $L + 1
			$R = $R - 1
		EndIf
	Until $L > $R

	__ArrayQSort1($array, $left, $R)
	__ArrayQSort1($array, $L, $right)
EndFunc   ;==>__ArrayQSort1

; Private
Func __ArrayQSort2(ByRef $array, ByRef $left, ByRef $right, ByRef $dim2, ByRef $sortIdx, ByRef $decend)
	If $left >= $right Then Return
	Local $t, $d2 = $dim2 - 1
	Local $pivot = $array[Int(($left + $right) / 2) ][$sortIdx]
	Local $L = $left
	Local $R = $right
	Do
		If $decend Then
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] > $pivot) _
					Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) > String($pivot)))
				;While $array[$L][$sortIdx] > $pivot
				$L = $L + 1
			WEnd
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] < $pivot) _
					Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) < String($pivot)))
				;While $array[$R][$sortIdx] < $pivot
				$R = $R - 1
			WEnd
		Else
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] < $pivot) _
					Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) < String($pivot)))
				;While $array[$L][$sortIdx] < $pivot
				$L = $L + 1
			WEnd
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] > $pivot) _
					Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) > String($pivot)))
				;While $array[$R][$sortIdx] > $pivot
				$R = $R - 1
			WEnd
		EndIf
		If $L <= $R Then
			For $x = 0 To $d2
				$t = $array[$L][$x]
				$array[$L][$x] = $array[$R][$x]
				$array[$R][$x] = $t
			Next
			$L = $L + 1
			$R = $R - 1
		EndIf
	Until $L > $R

	__ArrayQSort2($array, $left, $R, $dim2, $sortIdx, $decend)
	__ArrayQSort2($array, $L, $right, $dim2, $sortIdx, $decend)
EndFunc   ;==>__ArrayQSort2



;===============================================================================
;
; Function Name:  _ArraySwap()
; Description:    Swaps two elements of an array.
; Author(s):      David Nuttall <danuttall at rocketmail dot com>
;
;===============================================================================
Func _ArraySwap(ByRef $svector1, ByRef $svector2)
	Local $sTemp = $svector1

	$svector1 = $svector2
	$svector2 = $sTemp

	SetError(0)
EndFunc   ;==>_ArraySwap


;===============================================================================
;
; Function Name:  _ArrayToClip()
; Description:    Sends the contents of an array to the clipboard.
; Author(s):      Cephas <cephas at clergy dot net>
;
;                 Jos van der Zande
; Modified:       Added $i_Base parameter and logic
;===============================================================================
Func _ArrayToClip(Const ByRef $avArray, $i_Base = 0)
	Local $iCntr, $iRetVal = 0, $sCr = "", $sText = ""

	If (IsArray($avArray)) Then
		For $iCntr = $i_Base To (UBound($avArray) - 1)
			$iRetVal = 1
			If $iCntr > $i_Base Then
				$sCr = @CR
			EndIf
			$sText = $sText & $sCr & $avArray[$iCntr]
		Next
	EndIf
	ClipPut($sText)
	Return $iRetVal
EndFunc   ;==>_ArrayToClip


;===============================================================================
;
; Function Name:  _ArrayToString()
; Description:    Places the elements of an array into a single string,
;                 separated by the specified delimiter.
; Author(s):      Brian Keene <brian_keene at yahoo dot com>
;						Rewritten by: Valik
;
;===============================================================================
Func _ArrayToString(Const ByRef $avArray, $sDelim, $iStart = Default, $iEnd = Default)
	; Declare local variables.
	Local $iUBound = UBound($avArray) - 1

	; Validate the array
	If ($iUBound + 1) < 1 Or UBound($avArray, 0) > 1 Then Return SetError(1, 0, "")

	; Expand Default parameters
	If $iStart = Default Or $iStart = -1 Then $iStart = 0
	If $iEnd = Default Or $iEnd = -1 Then $iEnd = $iUBound

	; Validate that the start and end indices are valid.
	If ($iStart < 0) Or ($iEnd < 0) Or ($iStart > $iEnd) Then Return SetError(2, 0, "")

	; Make sure that $iEnd <= to the size of the array.
	If ($iEnd > $iUBound) Then
		$iEnd = $iUBound
	EndIf

	Local $sResult
	; Combine the elements into the string.
	For $i = $iStart To $iEnd
		$sResult &= $avArray[$i] & $sDelim
	Next

	Return StringTrimRight($sResult, StringLen($sDelim))
EndFunc   ;==>_ArrayToString

;===============================================================================
;
; FunctionName:     _ArrayTrim()
; Description:      Trims all elements in an array a certain number of characters.
; Syntax:           _ArrayTrim( $aArray, $iTrimNum , [$iTrimDirection] , [$iBase] , [$iUbound] )
; Parameter(s):     $aArray              - The array to trim the items of
;                   $iTrimNum            - The amount of characters to trim
;                    $iTrimDirection     - 0 to trim left, 1 to trim right
;                                            [Optional] : Default = 0
;                   $iBase               - Start trimming at this element in the array
;                                            [Optional] : Default = 0
;                   $iUbound             - End trimming at this element in the array
;                                            [Optional] : Default = Full Array
; Requirement(s):   None
; Return Value(s):  1 - If invalid array
;                   2 - Invalid base boundry parameter
;                   3 - Invalid end boundry parameter
;                   4 - If $iTrimDirection is not a zero or a one
;                    Otherwise it returns the new trimmed array
; Author(s):        Adam Moore (redndahead)
; Note(s):          None
;
;===============================================================================
Func _ArrayTrim($aArray, $iTrimNum, $iTrimDirection = 0, $iBase = 0, $iUBound = 0)
	Local $i

	;Validate array and options given
	If UBound($aArray) = 0 Then
		SetError(1)
		Return $aArray
	EndIf

	If $iBase < 0 Or Not IsNumber($iBase) Then
		SetError(2)
		Return $aArray
	EndIf

	If UBound($aArray) <= $iUBound Or Not IsNumber($iUBound) Then
		SetError(3)
		Return $aArray
	EndIf

	; Set to ubound when not specified
	If $iUBound < 1 Then $iUBound = UBound($aArray) - 1

	If $iTrimDirection < 0 Or $iTrimDirection > 1 Then
		SetError(4)
		Return
	EndIf
	;Trim it off
	For $i = $iBase To $iUBound
		If $iTrimDirection = 0 Then
			$aArray[$i] = StringTrimLeft($aArray[$i], $iTrimNum)
		Else
			$aArray[$i] = StringTrimRight($aArray[$i], $iTrimNum)
		EndIf
	Next
	Return $aArray
EndFunc   ;==>_ArrayTrim