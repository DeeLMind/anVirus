; *******************************************************
; Example 1 - calling the MessageBox API directly
; *******************************************************

$result = DllCall("user32.dll", "int", "MessageBox", "hwnd", 0, "str", "Some text", "str", "Some title", "int", 0)


; *******************************************************
; Example 2 - calling a function that modifies parameters
; *******************************************************

$hwnd = WinGetHandle("Untitled - Notepad")
$result = DllCall("user32.dll", "int", "GetWindowText", "hwnd", $hwnd, "str", "", "int", 32768)
msgbox(0, "", $result[0])	; number of chars returned
msgbox(0, "", $result[2])	; Text returned in param 2


; *******************************************************
; Example 3 - Show the Windows PickIconDlg
; *******************************************************

$sFileName	= @SystemDir & '\shell32.dll'

; Create a strcuture to store the icon index
$stIcon		=  DllStructCreate("int")

If @OSType = "WIN32_NT" Then
	; Convert and store the filename as a wide char string
	$nBuffersize	= DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $sFileName, "int", -1, "ptr", 0, "int", 0)
	$stString		= DLLStructCreate("byte[" & 2 * $nBuffersize[0] & "]")
	DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $sFileName, "int", -1, "ptr", DllStructGetPtr($stString), "int", $nBuffersize[0])
Else
	; Win'9x
	$stString		= DLLStructCreate("char[260]")
	DllStructSetData($stString, 1, $sFileName)
EndIf

; Run the PickIconDlg - '62' is the ordinal value for this function
DllCall("shell32.dll", "none", 62, "hwnd", 0, "ptr", DllStructGetPtr($stString), "int", DllStructGetSize($stString), "ptr", DllStructGetPtr($stIcon))

If @OSType = "WIN32_NT" Then
	; Convert the new selected filename back from a wide char string
	$nBuffersize	= DllCall("kernel32.dll", "int", "WideCharToMultiByte", "int", 0, "int", 0x00000200, "ptr", DllStructGetPtr($stString), "int", -1, "ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
	$stFile			= DLLStructCreate("char[" & $nBuffersize[0] & "]")
	DllCall("kernel32.dll", "int", "WideCharToMultiByte", "int", 0, "int", 0x00000200, "ptr", DllStructGetPtr($stString), "int", -1, "ptr", DllStructGetPtr($stFile), "int", $nBuffersize[0], "ptr", 0, "ptr", 0)
	$sFileName		= DllStructGetData($stFile, 1)
Else
	$sFileName		= DllStructGetData($stString, 1)
EndIf

$nIconIndex			= DllStructGetData($stIcon, 1)

; Show the new filename and icon index
Msgbox(0, "Info", "Last selected file: " & $sFileName & @LF & "Icon-Index: " & $nIconIndex)

$stBuffer	= 0
$stFile		= 0
$stIcon		= 0