; Identify the Notepad window that contains the text "this one" and get a handle to it

; Change into the WinTitleMatchMode that supports classnames and handles
AutoItSetOption("WinTitleMatchMode", 4)

; Get the handle of a notepad window that contains "this one"
$handle = WinGetHandle("classname=Notepad", "this one")
If @error Then
	MsgBox(4096, "Error", "Could not find the correct window")
Else
	; Send some text directly to this window's edit control
	ControlSend($handle, "", "Edit1", "AbCdE")
EndIf
