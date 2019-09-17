Opt("MustDeclareVars", 1)
#include <GUIConstants.au3>
#include <GuiEdit.au3>

; *******************************************************
; Example 1 - Using with an AutoIt Created Edit control
; *******************************************************

_UseAutoItControl()

Func _UseAutoItControl()
	Local $s_texttest = "this is a test" & @CRLF & _
		"this is only a test" & @CRLF & _
		"this testing should work for you as well as it does for me"
   Local $GuiCtrlEditSearch, $myEdit, $Button1, $Button2, $msg
	
   $GuiCtrlEditSearch = GUICreate('Find And Replace Example with AutoIt ' & FileGetVersion(@AutoItExe), 622, 448, 192, 125)
   $myEdit = GUICtrlCreateEdit($s_texttest, 64, 24, 505, 233, _
		BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE, $WS_HSCROLL, $ES_NOHIDESEL))
   $Button1 = GUICtrlCreateButton("Find", 176, 288, 121, 33, 0)
   $Button2 = GUICtrlCreateButton("Find And Replace", 368, 288, 121, 33, 0)
   GUISetState(@SW_SHOW)
   While 1
      $msg = GUIGetMsg()
      Select
         Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
         Case $msg = $Button1
            _GUICtrlEditFind ($GuiCtrlEditSearch, $myEdit)
         Case $msg = $Button2
            _GUICtrlEditFind ($GuiCtrlEditSearch, $myEdit, True)
         Case Else
            ;;;;;;;
      EndSelect
   WEnd
	GUIDelete()
EndFunc   ;==>_UseAutoItControl

; *******************************************************
; Example 2 - Using with an external Edit control
; *******************************************************

_UseExternalControl()

Func _UseExternalControl()
	Local $s_texttest = 'Find And Replace Example with AutoIt ' & FileGetVersion(@AutoItExe) & @LF & _
	   "this is a test" & @LF & _
		"this is only a test" & @LF & _
		"this testing should work for you as well as it does for me"
	Local $whandle, $handle
	Local $Title = "Untitled - Notepad"
	
	Run("notepad", "", @SW_MAXIMIZE)
	;Wait for the window "Untitled" to exist
	WinWait($Title)
	
	; Get the handle of a notepad window
	$whandle = WinGetHandle($Title)
	If @error Then
		MsgBox(4096, "Error", "Could not find the correct window")
	Else
		$handle = ControlGetHandle($whandle, "", "Edit1")
		If @error Then
			MsgBox(4096, "Error", "Could not find the correct control")
		Else
			; Send some text directly to this window's edit control
			ControlSend($whandle, "", "Edit1", $s_texttest)
			_GUICtrlEditFind ($whandle, $handle, True, $Title)
		EndIf
	EndIf
EndFunc   ;==>_UseExternalControl