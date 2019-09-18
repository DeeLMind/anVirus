; *******************************************************
; Example 1 - sorting 3 column's different
; *******************************************************

#include <GUIConstants.au3>

;Global Const $LVFI_PARAM			= 0x0001
;Global Const $LVIF_TEXT			= 0x0001
;Global Const $LVM_FIRST			= 0x1000
;Global Const $LVM_GETITEM			= $LVM_FIRST + 5
;Global Const $LVM_FINDITEM			= $LVM_FIRST + 13
;Global Const $LVM_SETSELECTEDCOLUMN= $LVM_FIRST + 140

Dim $nCurCol	= -1
Dim $nSortDir	= 1
Dim $bSet		= 0
Dim $nCol		= -1

$hGUI	= GUICreate("Test", 300, 200)

$lv		= GUICtrlCreateListView("Column1|Col2|Col3", 10, 10, 280, 180)
GUICtrlRegisterListViewSort(-1, "LVSort") ; Register the function "SortLV" for the sorting callback

$lvi1	= GUICtrlCreateListViewItem("ABC|666|10.05.2004", $lv)
GUICtrlSetImage(-1, "shell32.dll", 7)
$lvi2	= GUICtrlCreateListViewItem("DEF|444|11.05.2005", $lv)
GUICtrlSetImage(-1, "shell32.dll", 12)
$lvi3	= GUICtrlCreateListViewItem("CDE|444|12.05.2004", $lv)
GUICtrlSetImage(-1, "shell32.dll", 3)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $lv
			$bSet = 0
			$nCurCol = $nCol
			GUICtrlSendMsg($lv, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($lv), 0)
			DllCall("user32.dll", "int", "InvalidateRect", "hwnd", GUICtrlGetHandle($lv), "int", 0, "int", 1)
	EndSwitch
WEnd

Exit


; Our sorting callback funtion
Func LVSort($hWnd, $nItem1, $nItem2, $nColumn)
	Local $nSort
	
	; Switch the sorting direction
	If $nColumn = $nCurCol Then
		If Not $bSet Then
			$nSortDir = $nSortDir * -1
			$bSet = 1
		EndIf
	Else
		$nSortDir = 1
	EndIf
	$nCol = $nColumn
		
	$val1	= GetSubItemText($lv, $nItem1, $nColumn)
	$val2	= GetSubItemText($lv, $nItem2, $nColumn)
	
	; If it is the 3rd colum (column starts with 0) then compare the dates
	If $nColumn = 2 Then
		$val1 = StringRight($val1, 4) & StringMid($val1, 4, 2) & StringLeft($val1, 2)
		$val2 = StringRight($val2, 4) & StringMid($val2, 4, 2) & StringLeft($val2, 2)
	EndIf
		
	$nResult = 0		; No change of item1 and item2 positions
	
	If $val1 < $val2 Then
		$nResult = -1	; Put item2 before item1
	ElseIf  $val1 > $val2 Then
		$nResult = 1	; Put item2 behind item1
	EndIf

	$nResult = $nResult * $nSortDir
	
	Return $nResult
EndFunc


; Retrieve the text of a listview item in a specified column
Func GetSubItemText($nCtrlID, $nItemID, $nColumn)
	Local $stLvfi		= DllStructCreate("uint;ptr;int;int[2];int")
	DllStructSetData($stLvfi, 1, $LVFI_PARAM)
	DllStructSetData($stLvfi, 3, $nItemID)

	Local $stBuffer		= DllStructCreate("char[260]")
	
	$nIndex = GUICtrlSendMsg($nCtrlID, $LVM_FINDITEM, -1, DllStructGetPtr($stLvfi));
	
	Local $stLvi		= DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int")
	
	DllStructSetData($stLvi, 1, $LVIF_TEXT)
	DllStructSetData($stLvi, 2, $nIndex)
	DllStructSetData($stLvi, 3, $nColumn)
	DllStructSetData($stLvi, 6, DllStructGetPtr($stBuffer))
	DllStructSetData($stLvi, 7, 260)

	GUICtrlSendMsg($nCtrlID, $LVM_GETITEM, 0, DllStructGetPtr($stLvi));

	$sItemText	= DllStructGetData($stBuffer, 1)

	$stLvi		= 0
	$stLvfi		= 0
	$stBuffer	= 0
	
	Return $sItemText
EndFunc


; *******************************************************
; Example 2 - sorting with selfcreated items by DllCall
; *******************************************************

#include <GUIConstants.au3>

;Global Const $LVFI_PARAM			= 0x0001

;Global Const $LVIF_TEXT				= 0x0001
Global Const $LVIF_PARAM			= 0x0004 ; Important for finding/sorting listview item

;Global Const $LVM_FIRST				= 0x1000
;Global Const $LVM_GETITEMCOUNT		= $LVM_FIRST + 4
Global Const $LVM_GETITEM			= $LVM_FIRST + 5
Global Const $LVM_INSERTITEM		= $LVM_FIRST + 7
;Global Const $LVM_FINDITEM			= $LVM_FIRST + 13
;Global Const $LVM_SETCOLUMNWIDTH	= $LVM_FIRST + 30
Global Const $LVM_SETITEMTEXT		= $LVM_FIRST + 46
;Global Const $LVM_SETSELECTEDCOLUMN	= $LVM_FIRST + 140

Dim $nCurCol	= -1
Dim $nSortDir	= 1
Dim $bSet		= 0
Dim $nCol		= -1

$hGUI	= GUICreate("Test", 300, 200)

$lv		= GUICtrlCreateListView("Column1|Col2|Col3", 10, 10, 280, 180)
GUICtrlRegisterListViewSort(-1, "LVSort") ; Register the function "SortLV" for the sorting callback

MyGUICtrlCreateListViewItem("ABC|666|10.05.2004", $lv, -1)
MyGUICtrlCreateListViewItem("DEF|444|11.05.2005", $lv, -1)
MyGUICtrlCreateListViewItem("CDE|444|12.05.2004", $lv, -1)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $lv
			$bSet = 0
			$nCurCol = $nCol
			GUICtrlSendMsg($lv, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($lv), 0)
			DllCall("user32.dll", "int", "InvalidateRect", "hwnd", ControlGetHandle($hGUI, "", $lv), "int", 0, "int", 1)
	EndSwitch
WEnd

Exit


; Our sorting callback funtion
Func LVSort($hWnd, $nItem1, $nItem2, $nColumn)
	Local $nSort
	
	; Switch the sorting direction
	If $nColumn = $nCurCol Then
		If Not $bSet Then
			$nSortDir = $nSortDir * -1
			$bSet = 1
		EndIf
	Else
		$nSortDir = 1
	EndIf
	$nCol = $nColumn
		
	$val1	= GetSubItemText($lv, $nItem1, $nColumn)
	$val2	= GetSubItemText($lv, $nItem2, $nColumn)

	; If it is the 3rd colum (column starts with 0) then compare the dates
	If $nColumn = 2 Then
		$val1 = StringRight($val1, 4) & StringMid($val1, 4, 2) & StringLeft($val1, 2)
		$val2 = StringRight($val2, 4) & StringMid($val2, 4, 2) & StringLeft($val2, 2)
	EndIf
	
	$nResult = 0		; No change of item1 and item2 positions
	
	If $val1 < $val2 Then
		$nResult = -1	; Put item2 before item1
	ElseIf  $val1 > $val2 Then
		$nResult = 1	; Put item2 behind item1
	EndIf

	$nResult = $nResult * $nSortDir
	
	Return $nResult
EndFunc


; Retrieve the text of a listview item in a specified column
Func GetSubItemText($nCtrlID, $nItemID, $nColumn)
	Local $stLvfi		= DllStructCreate("uint;ptr;int;int[2];int")
	DllStructSetData($stLvfi, 1, $LVFI_PARAM) ; Find the item by our saved index
	DllStructSetData($stLvfi, 3, $nItemID)
	
	Local $stBuffer		= DllStructCreate("char[260]")
	
	$nIndex = GUICtrlSendMsg($nCtrlID, $LVM_FINDITEM, -1, DllStructGetPtr($stLvfi));

	Local $stLvi		= DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int")
	
	DllStructSetData($stLvi, 1, $LVIF_TEXT)
	DllStructSetData($stLvi, 2, $nIndex)
	DllStructSetData($stLvi, 3, $nColumn)
	DllStructSetData($stLvi, 6, DllStructGetPtr($stBuffer))
	DllStructSetData($stLvi, 7, 260)

	GUICtrlSendMsg($nCtrlID, $LVM_GETITEM, 0, DllStructGetPtr($stLvi));

	$sItemText	= DllStructGetData($stBuffer, 1)

	$stLvi		= 0
	$stLvfi		= 0
	$stBuffer	= 0
	
	Return $sItemText
EndFunc


; Create and insert items directly into the listview
Func MyGUICtrlCreateListViewItem($sText, $nCtrlID, $nIndex)
	Local $stLvItem	= DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int;")
	Local $stText	= DllStructCreate("char[260]")
	Local $arText	= StringSplit($sText, "|")
	
	If $nIndex = -1 Then $nIndex = GUICtrlSendMsg($nCtrlID, $LVM_GETITEMCOUNT, 0, 0)
	
	DllStructSetData($stText, 1, $arText[1]) ; Save the item text in the struct
		
	DllStructSetData($stLvItem, 1, BitOr($LVIF_TEXT, $LVIF_PARAM))
	DllStructSetData($stLvItem, 2, $nIndex)
	DllStructSetData($stLvItem, 6, DllStructGetPtr($stText))
	; Set the lParam of the struct to the line index - unique within the listview
	DllStructSetData($stLvItem, 9, $nIndex)
	
	$nIndex = GUICtrlSendMsg($nCtrlID, $LVM_INSERTITEM, 0, DllStructGetPtr($stLvItem))

	If $nIndex > -1 Then
		; Insert now the rest of the column text
		For $i = 2 To $arText[0]
			DllStructSetData($stText, 1, $arText[$i])
			DllStructSetData($stLvItem, 3, $i - 1) ; Store the subitem index
			
			GUICtrlSendMsg($nCtrlID, $LVM_SETITEMTEXT, $nIndex, DllStructGetPtr($stLvItem))
		Next
	EndIf

	$stText		= 0
	$stLvItem	= 0

	; Change the column width to fit the item text
	For $i = 0 To 2
		GUICtrlSendMsg($nCtrlID, $LVM_SETCOLUMNWIDTH, $i, -1)
		GUICtrlSendMsg($nCtrlID, $LVM_SETCOLUMNWIDTH, $i, -2)
	Next
EndFunc
