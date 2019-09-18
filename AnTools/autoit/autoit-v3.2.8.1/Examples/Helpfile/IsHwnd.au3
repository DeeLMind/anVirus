Run("notepad.exe")
Local $hWnd = WinGetHandle("Untitled - Notepad")
If IsHWnd($hWnd) Then
	MsgBox(4096, "", "It's a valid HWND")
Else
	MsgBox(4096, "", "It's not an HWND")
EndIf
