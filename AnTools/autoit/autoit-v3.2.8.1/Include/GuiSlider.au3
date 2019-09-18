#include-once
#include <SliderConstants.au3>
#include <Misc.au3>

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with Slider Control "Trackbar".
;
; ------------------------------------------------------------------------------

; function list
;===============================================================================
; _GUICtrlSliderClearTics
; _GUICtrlSliderGetLineSize
; _GUICtrlSliderGetNumTics
; _GUICtrlSliderGetPageSize
; _GUICtrlSliderGetPos
; _GUICtrlSliderGetRangeMax
; _GUICtrlSliderGetRangeMin
; _GUICtrlSliderSetLineSize
; _GUICtrlSliderSetPageSize
; _GUICtrlSliderSetPos
; _GUICtrlSliderSetTicFreq
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlSliderClearTics
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlSliderClearTics($h_slider) Removes the current tick marks from a slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				This does not remove the first and last tick marks, which are created automatically
;
;===============================================================================
Func _GUICtrlSliderClearTics($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, 0)
	_SendMessage($h_slider, $TBM_CLEARTICS, 1)
EndFunc   ;==>_GUICtrlSliderClearTics

;===============================================================================
;
; Description:			_GUICtrlSliderGetLineSize
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	Returns value that specifies the line size for the slider.
; User CallTip:		_GUICtrlSliderGetLineSize($h_slider) Retrieves the number of logical positions the slider moves. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Retrieves the number of logical positions the slider moves in response to keyboard input from the arrow keys.
;							The logical positions are the integer increments in the slider's range of minimum to maximum slider positions.
;
;===============================================================================
Func _GUICtrlSliderGetLineSize($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, 0)
	Return _SendMessage($h_slider, $TBM_GETLINESIZE)
EndFunc   ;==>_GUICtrlSliderGetLineSize

;===============================================================================
;
; Description:			_GUICtrlSliderGetNumTics
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	If no tick flag is set, it returns 2 for the beginning and ending ticks.
;							If $TBS_NOTICKS is set, it returns zero.
;							Otherwise, it takes the difference between the range minimum and maximum, divides by the tick frequency, and adds 2.
; User CallTip:		_GUICtrlSliderGetNumTics($h_slider) Retrieves the number of tick marks from a slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlSliderGetNumTics($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_GETNUMTICS)
EndFunc   ;==>_GUICtrlSliderGetNumTics

;===============================================================================
;
; Description:			_GUICtrlSliderGetPageSize
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	Returns a value that specifies the page size for the slider.
; User CallTip:		_GUICtrlSliderGetPageSize($h_slider) Retrieves the number of logical positions the slider moves. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Retrieves the number of logical positions the slider moves in response to keyboard input,
;							or mouse input, such as clicks in the sliders's channel.
;							The logical positions are the integer increments in the slider's range of minimum to maximum slider positions.
;
;===============================================================================
Func _GUICtrlSliderGetPageSize($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_GETPAGESIZE)
EndFunc   ;==>_GUICtrlSliderGetPageSize

;===============================================================================
;
; Description:			_GUICtrlSliderGetPos
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	Returns a value that specifies the logical position of the slider.
; User CallTip:		_GUICtrlSliderGetPos($h_slider) Retrieves the logical position the slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlSliderGetPos($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_GETPOS)
EndFunc   ;==>_GUICtrlSliderGetPos

;===============================================================================
;
; Description:			_GUICtrlSliderGetRangeMax
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	Returns a value that specifies the maximum position in the slider's range of minimum to maximum slider positions.
; User CallTip:		_GUICtrlSliderGetRangeMax($h_slider) Retrieves the maximum position for the slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlSliderGetRangeMax($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_GETRANGEMAX)
EndFunc   ;==>_GUICtrlSliderGetRangeMax

;===============================================================================
;
; Description:			_GUICtrlSliderGetRangeMin
; Parameter(s):		$h_slider - handle of the control
; Requirement:			None
; Return Value(s):	Returns a value that specifies the minimum position in the slider's range of minimum to maximum slider positions.
; User CallTip:		_GUICtrlSliderGetRangeMin($h_slider) Retrieves the minimum position for the slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlSliderGetRangeMin($h_slider)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_GETRANGEMIN)
EndFunc   ;==>_GUICtrlSliderGetRangeMin

;===============================================================================
;
; Description:			_GUICtrlSliderSetLineSize
; Parameter(s):		$h_slider - handle of the control
;							$i_linesize - New line size.
; Requirement:			None
; Return Value(s):	Returns a value that specifies the previous line size.
; User CallTip:		_GUICtrlSliderSetLineSize($h_slider, $i_linesize) Sets the number of logical positions the slider moves. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Sets the number of logical positions the slider moves in response to keyboard input from the arrow keys.
;							The logical positions are the integer increments in the slider's range of minimum to maximum slider positions.
;
;===============================================================================
Func _GUICtrlSliderSetLineSize($h_slider, $i_linesize)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_SETLINESIZE, 0, $i_linesize)
EndFunc   ;==>_GUICtrlSliderSetLineSize

;===============================================================================
;
; Description:			_GUICtrlSliderSetPageSize
; Parameter(s):		$h_slider - handle of the control
;							$i_pagesize - New page size.
; Requirement:			None
; Return Value(s):	Returns a value that specifies the previous page size.
; User CallTip:		_GUICtrlSliderSetPageSize($h_slider, $i_pagesize) Sets the number of logical positions the slider moves. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Sets the number of logical positions the slider moves in response to keyboard input,
;							or mouse input, such as clicks in the slider's channel.
;							The logical positions are the integer increments in the slider's range of minimum to maximum slider positions.
;
;===============================================================================
Func _GUICtrlSliderSetPageSize($h_slider, $i_pagesize)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	Return _SendMessage($h_slider, $TBM_SETPAGESIZE, 0, $i_pagesize)
EndFunc   ;==>_GUICtrlSliderSetPageSize

;===============================================================================
;
; Description:			_GUICtrlSliderSetPos
; Parameter(s):		$h_slider - handle of the control
;							$i_pos - New logical position of the slider.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlSliderSetPos($h_slider, $i_pos) Sets the current logical position of the slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlSliderSetPos($h_slider, $i_pos)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	_SendMessage($h_slider, $TBM_SETPOS, 1, $i_pos)
EndFunc   ;==>_GUICtrlSliderSetPos

;===============================================================================
;
; Description:			_GUICtrlSliderSetTicFreq
; Parameter(s):		$h_slider - handle of the control
;							$i_freq - Frequency of the tick marks.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlSliderSetTicFreq($h_slider, $i_freq) Sets the interval frequency for tick marks in a slider. (required: <GuiSlider.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The slider must have the $TBS_AUTOTICKS style to use this.
;
;===============================================================================
Func _GUICtrlSliderSetTicFreq($h_slider, $i_freq)
	If Not _IsClassName ($h_slider, "msctls_trackbar32") Then Return SetError(-1, -1, -1)
	_SendMessage($h_slider, $TBM_SETTICFREQ, $i_freq)
EndFunc   ;==>_GUICtrlSliderSetTicFreq