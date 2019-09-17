Run("notepad.exe")
WinWait("Untitled - Notepad")
Local $hWnd = WinGetHandle("Untitled - Notepad")
Local $sHWND = String($hWnd)	; Convert to a string
WinSetState(HWnd($sHWND), "", @SW_MINIMIZE)
Sleep(5000)	; Notepad should be minimized
WinClose(HWnd($sHWND))
