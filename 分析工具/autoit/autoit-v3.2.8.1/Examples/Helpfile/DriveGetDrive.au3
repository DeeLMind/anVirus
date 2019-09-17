$var = DriveGetDrive( "all" )
If NOT @error Then
	MsgBox(4096,"", "Found " & $var[0] & " drives")
	For $i = 1 to $var[0]
		MsgBox(4096,"Drive " & $i, $var[$i])
	Next
EndIf
