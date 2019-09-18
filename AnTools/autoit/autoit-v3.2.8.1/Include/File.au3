#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with files and directories.
;
; ------------------------------------------------------------------------------


;===============================================================================
;
; Description:      Returns the number of lines in the specified file.
; Syntax:           _FileCountLines( $sFilePath )
; Parameter(s):     $sFilePath - Path and filename of the file to be read
; Requirement(s):   None
; Return Value(s):  On Success - Returns number of lines in the file
;                   On Failure - Returns 0 and sets @error = 1
; Author(s):        Tylo <tylo at start dot no>
; Note(s):          It does not count a final @LF as a line.
;
;===============================================================================
Func _FileCountLines($sFilePath)
	Local $N = FileGetSize($sFilePath) - 1
	If @error Or $N = -1 Then Return 0
	Return StringLen(StringAddCR(FileRead($sFilePath, $N))) - $N + 1
EndFunc   ;==>_FileCountLines


;===============================================================================
;
; Description:      Creates or zero's out the length of the file specified.
; Syntax:           _FileCreate( $sFilePath )
; Parameter(s):     $sFilePath - Path and filename of the file to be created
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets:
;                                @error = 1: Error opening specified file
;                                @error = 2: File could not be written to
; Author(s):        Brian Keene <brian_keene at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _FileCreate($sFilePath)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $hOpenFile
	Local $hWriteFile

	$hOpenFile = FileOpen($sFilePath, 2)

	If $hOpenFile = -1 Then
		SetError(1)
		Return 0
	EndIf

	$hWriteFile = FileWrite($hOpenFile, "")

	If $hWriteFile = -1 Then
		SetError(2)
		Return 0
	EndIf

	FileClose($hOpenFile)
	Return 1
EndFunc   ;==>_FileCreate

;===============================================================================
;
; Description:      lists all files and folders in a specified path (Similar to using Dir with the /B Switch)
; Syntax:           _FileListToArray($sPath, $sFilter = "*", $iFlag = 0)
; Parameter(s):    	$sPath = Path to generate filelist for
;                   $iFlag = determines weather to return file or folders or both
;					$sFilter = The filter to use. Search the Autoit3 manual for the word "WildCards" For details
;						$iFlag=0(Default) Return both files and folders
;                       $iFlag=1 Return files Only
;						$iFlag=2 Return Folders Only
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array containing the list of files and folders in the specified path
;                        On Failure - Returns the an empty string "" if no files are found and sets @Error on errors
;						@Error=1 Path not found or invalid
;						@Error=2 Invalid $sFilter
;                       @Error=3 Invalid $iFlag
;                 @Error=4 No File(s) Found
;
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s):			The array returned is one-dimensional and is made up as follows:
;					$array[0] = Number of Files\Folders returned
;					$array[1] = 1st File\Folder
;					$array[2] = 2nd File\Folder
;					$array[3] = 3rd File\Folder
;					$array[n] = nth File\Folder
;
;					Special Thanks to Helge and Layer for help with the $iFlag update
;===============================================================================
Func _FileListToArray($sPath, $sFilter = "*", $iFlag = 0)
	Local $hSearch, $sFile, $asFileList[1]
	If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringInStr($sFilter, "|")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	If $hSearch = -1 Then Return SetError(4, 4, "")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			SetError(0)
			ExitLoop
		EndIf
		If $iFlag = 1 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
		If $iFlag = 2 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
		ReDim $asFileList[UBound($asFileList) + 1]
		$asFileList[0] = $asFileList[0] + 1
		$asFileList[UBound($asFileList) - 1] = $sFile
	WEnd
	FileClose($hSearch)
	Return $asFileList
EndFunc   ;==>_FileListToArray

;===============================================================================
; Function Name:   _FilePrint()
; Description:     Prints a plain text file.
; Syntax:          _FilePrint ( $s_File [, $i_Show] )
;
; Parameter(s):    $s_File     = The file to print.
;                  $i_Show     = The state of the window. (default = @SW_HIDE)
;
; Requirement(s):  External:   = shell32.dll (it's already in system32).
;                  Internal:   = None.
;
; Return Value(s): On Success: = Returns 1.
;                  On Failure: = Returns 0 and sets @error according to the global constants list.
;
; Author(s):       erifash <erifash [at] gmail [dot] com>
;
; Note(s):         Uses the ShellExecute function of shell32.dll.
;
; Example(s):
;   _FilePrint("C:\file.txt")
;===============================================================================
Func _FilePrint($s_File, $i_Show = @SW_HIDE)
	Local $a_Ret = DllCall("shell32.dll", "long", "ShellExecute", _
			"hwnd", 0, _
			"string", "print", _
			"string", $s_File, _
			"string", "", _
			"string", "", _
			"int", $i_Show)
	If $a_Ret[0] > 32 And Not @error Then
		Return 1
	Else
		SetError($a_Ret[0])
		Return 0
	EndIf
EndFunc   ;==>_FilePrint

;===============================================================================
;
; Description:      Reads the specified file into an array.
; Syntax:           _FileReadToArray( $sFilePath, $aArray )
; Parameter(s):     $sFilePath - Path and filename of the file to be read
;                   $aArray    - The array to store the contents of the file
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error = 1
; Author(s):        Jonathan Bennett <jon at hiddensoft dot com>
; Note(s):          None
;
;===============================================================================
Func _FileReadToArray($sFilePath, ByRef $aArray)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $hFile

	$hFile = FileOpen($sFilePath, 0)

	If $hFile = -1 Then
		SetError(1)
		Return 0
	EndIf

	$aArray = StringSplit(StringStripCR(FileRead($hFile, FileGetSize($sFilePath))), @LF)

	FileClose($hFile)
	Return 1
EndFunc   ;==>_FileReadToArray

;===============================================================================
;
; Description:      Write array to File.
; Syntax:           _FileWriteFromArray( $sFilePath, $aArray )
; Parameter(s):     $sFilePath - Path and filename of the file to be written
;                   $a_Array   - The array to retrieve the contents
;                   $i_Base    - Start reading at this Array entry.
;                   $I_Ubound  - End reading at this Array entry.
;                                Default UBound($a_Array) - 1
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error = 1
; Author(s):        Jos van der Zande <jdeb at autoitscript dot com>
; Note(s):          None
;
;===============================================================================
Func _FileWriteFromArray($sFilePath, $a_Array, $i_Base = 0, $i_UBound = 0)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $hFile
	; Check if we have a valid array as input
	If Not IsArray($a_Array) Then
		SetError(2)
		Return 0
	EndIf
	; determine last entry
	Local $last = UBound($a_Array) - 1
	If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
	If $i_Base < 0 Or $i_Base > $last Then $i_Base = 0
	; Open output file
	$hFile = FileOpen($sFilePath, 2)

	If $hFile = -1 Then
		SetError(1)
		Return 0
	EndIf
	;
	FileWrite($hFile, $a_Array[$i_Base])
	For $x = $i_Base + 1 To $i_UBound
		FileWrite($hFile, @CRLF & $a_Array[$x])
	Next

	FileClose($hFile)
	Return 1
EndFunc   ;==>_FileWriteFromArray

;===============================================================================
;
; Description:      Writes the specified text to a log file.
; Syntax:           _FileWriteLog( $sLogPath, $sLogMsg )
; Parameter(s):     $sLogPath - Path and filename to the log file
;                   $sLogMsg  - Message to be written to the log file
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets:
;                                @error = 1: Error opening specified file
;                                @error = 2: File could not be written to
; Author(s):        Jeremy Landes <jlandes at landeserve dot com>
; Note(s):          If the text to be appended does NOT end in @CR or @LF then
;                   a DOS linefeed (@CRLF) will be automatically added.
;
;===============================================================================
Func _FileWriteLog($sLogPath, $sLogMsg)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $sDateNow
	Local $sTimeNow
	Local $sMsg
	Local $hOpenFile
	Local $hWriteFile

	$sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
	$sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
	$sMsg = $sDateNow & " " & $sTimeNow & " : " & $sLogMsg

	$hOpenFile = FileOpen($sLogPath, 1)

	If $hOpenFile = -1 Then
		SetError(1)
		Return 0
	EndIf

	$hWriteFile = FileWriteLine($hOpenFile, $sMsg)

	If $hWriteFile = -1 Then
		SetError(2)
		Return 0
	EndIf

	FileClose($hOpenFile)
	Return 1
EndFunc   ;==>_FileWriteLog

;========================================
;Function name:       _FileWriteToLine
;Description:         Write text to specified line in a file
;Parameters:
;                     $sFile - The file to write to
;                     $iLine - The line number to write to
;                     $sText - The text to write
;                     $fOverWrite - if set to 1 will overwrite the old line
;                     if set to 0 will not overwrite
;Requirement(s):      None
;Return Value(s):     On success - 1
;                      On Failure - 0 And sets @ERROR
;                                @ERROR = 1 - File has less lines than $iLine
;                                @ERROR = 2 - File does not exist
;                                @ERROR = 3 - Error opening file
;                                @ERROR = 4 - $iLine is invalid
;                                @ERROR = 5 - $fOverWrite is invalid
;                                @ERROR = 6 - $sText is invalid
;Author(s):           cdkid
;Note(s):
;=========================================
Func _FileWriteToLine($sFile, $iLine, $sText, $fOverWrite = 0)
	If $iLine <= 0 Then
		SetError(4)
		Return 0
	EndIf
	If Not IsString($sText) Then
		SetError(6)
		Return 0
	EndIf
	If $fOverWrite <> 0 And $fOverWrite <> 1 Then
		SetError(5)
		Return 0
	EndIf
	If Not FileExists($sFile) Then
		SetError(2)
		Return 0
	EndIf
	Local $filtxt = FileRead($sFile, FileGetSize($sFile))
	$filtxt = StringSplit($filtxt, @CRLF, 1)
	If UBound($filtxt, 1) < $iLine Then
		SetError(1)
		Return 0
	EndIf
	Local $fil = FileOpen($sFile, 2)
	If $fil = -1 Then
		SetError(3)
		Return 0
	EndIf
	For $i = 1 To UBound($filtxt) - 1
		If $i = $iLine Then
			If $fOverWrite = 1 Then
				If $sText <> '' Then
					FileWrite($fil, $sText & @CRLF)
				Else
					FileWrite($fil, $sText)
				EndIf
			EndIf
			If $fOverWrite = 0 Then
				FileWrite($fil, $sText & @CRLF)
				FileWrite($fil, $filtxt[$i] & @CRLF)
			EndIf
		ElseIf $i < UBound($filtxt, 1) - 1 Then
			FileWrite($fil, $filtxt[$i] & @CRLF)
		ElseIf $i = UBound($filtxt, 1) - 1 Then
			FileWrite($fil, $filtxt[$i])
		EndIf
	Next
	FileClose($fil)
	Return 1
EndFunc   ;==>_FileWriteToLine

;===============================================================================
;
; Description:      Treats ..\ as Returns a path after processing the directory change operator .. to move the path up
;                                one level.
; Syntax:           _PathFull($sRelativePath, $sBasePath = @WorkingDir)
; Parameter(s):     $sRelativePath - The path to process.
;                            $sBasePath$sType - A base path to use if an absolute path is not provided.  This defaults to the
;                                current working directory.
; Requirement(s):   None
; Return Value(s):  The expanded path, the root drive or $sBasePath depending on how it's called.
; Author(s):        Valik (Original function and modification to rewrite)
;                        tittoproject (Rewrite)
; Note(s):          UNC paths are supported.
;                   Pass "\" to get the root drive of $sBasePath.
;                   Pass "" or "." to return $sBasePath.
;                   A relative path will be built relative to $sBasePath.  To bypass this behavior, use an absolute path.
;
;===============================================================================
Func _PathFull($sRelativePath, $sBasePath = @WorkingDir)
	If Not $sRelativePath Or $sRelativePath = "." Then Return $sBasePath

	; Normalize slash direction.
	Local $sFullPath = StringReplace($sRelativePath, "/", "\") ; Holds the full path (later, minus the root)
	Local $sPath	; Holds the root drive/server
	Local $bRootOnly = False	; Return only root information

	; Check to see if the path is all slashes and if so, set a flag so that
	; we only return the root path.
	StringReplace($sFullPath, "\", "")
	If @extended = StringLen($sFullPath) Then $bRootOnly = True

	; Check for UNC paths or local drives.  We run this twice at most.  The
	; first time, we check if the relative path is absolute.  If it's not, then
	; we use the base path which should be absolute.
	For $i = 1 To 2
		$sPath = StringLeft($sFullPath, 2)
		If $sPath = "\\" Then
			$sFullPath = StringTrimLeft($sFullPath, 2)
			$sPath &= StringLeft($sFullPath, StringInStr($sFullPath, "\") - 1)
			ExitLoop
		ElseIf StringRight($sPath, 1) = ":" Then
			$sFullPath = StringTrimLeft($sFullPath, 2)
			ExitLoop
		Else
			$sFullPath = $sBasePath & "\" & $sFullPath
		EndIf
	Next

	; If this happens, we've found a funky path and don't know what to do
	; except for get out as fast as possible.  We've also screwed up our
	; variables so we definitely need to quit.
	If $i = 3 Then Return ""

	; Build an array of the path parts we want to use.
	Local $aTemp = StringSplit($sFullPath, "\")
	Local $aPathParts[$aTemp[0]], $j = 0
	For $i = 2 To $aTemp[0]
		If $aTemp[$i] = ".." Then
			If $j Then $j -= 1
		ElseIf Not ($aTemp[$i] = "" And $i <> $aTemp[0]) And $aTemp[$i] <> "." Then
			$aPathParts[$j] = $aTemp[$i]
			$j += 1
		EndIf
	Next

	; Here we re-build the path from the parts above.  We skip the
	; loop if we are only returning the root.
	$sFullPath = $sPath
	If Not $bRootOnly Then
		For $i = 0 To $j - 1
			$sFullPath &= "\" & $aPathParts[$i]
		Next
	Else
		$sFullPath &= "\"
	EndIf

	; Clean up the path.
	While StringInStr($sFullPath, ".\")
		$sFullPath = StringReplace($sFullPath, ".\", "\")
	WEnd
	Return $sFullPath
EndFunc   ;==>_PathFull

; ===================================================================
; Author: Valik
;
; _PathMake($szDrive, $szDir, $szFName, $szExt)
;
; Creates a string containing the path from drive, directory, file name and file extension parts.  Not all parts must be
;	passed. The path will still be built with what is passed.  This doesn't check the validity of the path
;	created, it could contain characters which are invalid on your filesystem.
; Parameters:
; 	$szDrive - IN - Drive (Can be UNC).  If it's a drive letter, a : is automatically appended
; 	$szDir - IN - Directory.  A trailing slash is added if not found (No preceeding slash is added)
; 	$szFName - IN - The name of the file
; 	$szExt - IN - The file extension.  A period is supplied if not found in the extension
; Returns:
;	The string for the newly created path
; ===================================================================
Func _PathMake($szDrive, $szDir, $szFName, $szExt)
	; Format $szDrive, if it's not a UNC server name, then just get the drive letter and add a colon
	Local $szFullPath
	;
	If StringLen($szDrive) Then
		If Not (StringLeft($szDrive, 2) = "\\") Then $szDrive = StringLeft($szDrive, 1) & ":"
	EndIf

	; Format the directory by adding any necessary slashes
	If StringLen($szDir) Then
		If Not (StringRight($szDir, 1) = "\") And Not (StringRight($szDir, 1) = "/") Then $szDir = $szDir & "\"
	EndIf

	; Nothing to be done for the filename

	; Add the period to the extension if necessary
	If StringLen($szExt) Then
		If Not (StringLeft($szExt, 1) = ".") Then $szExt = "." & $szExt
	EndIf

	$szFullPath = $szDrive & $szDir & $szFName & $szExt
	Return $szFullPath
EndFunc   ;==>_PathMake

; ===================================================================
; Author: Valik
;
; _PathSplit($szPath, ByRef $szDrive, ByRef $szDir, ByRef $szFName, ByRef $szExt)
;
; Splits a path into the drive, directory, file name and file extension parts.  An empty string is set if a
;	part is missing.
; Parameters:
;	$szPath - IN - The path to be split (Can contain a UNC server or drive letter)
;	$szDrive - OUT - String to hold the drive
; 	$szDir - OUT - String to hold the directory
; 	$szFName - OUT - String to hold the file name
; 	$szExt - OUT - String to hold the file extension
; Returns:
;	Array with 5 elements where 0 = original path, 1 = drive, 2 = directory, 3 = filename, 4 = extension
; ===================================================================
Func _PathSplit($szPath, ByRef $szDrive, ByRef $szDir, ByRef $szFName, ByRef $szExt)
	; Set local strings to null (We use local strings in case one of the arguments is the same variable)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $pos

	; Create an array which will be filled and returned later
	Local $array[5]
	$array[0] = $szPath; $szPath can get destroyed, so it needs set now

	; Get drive letter if present (Can be a UNC server)
	If StringMid($szPath, 2, 1) = ":" Then
		$drive = StringLeft($szPath, 2)
		$szPath = StringTrimLeft($szPath, 2)
	ElseIf StringLeft($szPath, 2) = "\\" Then
		$szPath = StringTrimLeft($szPath, 2) ; Trim the \\
		$pos = StringInStr($szPath, "\")
		If $pos = 0 Then $pos = StringInStr($szPath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szPath; Prepend the \\ we stripped earlier
			$szPath = ""; Set to null because the whole path was just the UNC server name
		Else
			$drive = "\\" & StringLeft($szPath, $pos - 1) ; Prepend the \\ we stripped earlier
			$szPath = StringTrimLeft($szPath, $pos - 1)
		EndIf
	EndIf

	; Set the directory and file name if present
	Local $nPosForward = StringInStr($szPath, "/", 0, -1)
	Local $nPosBackward = StringInStr($szPath, "\", 0, -1)
	If $nPosForward >= $nPosBackward Then
		$pos = $nPosForward
	Else
		$pos = $nPosBackward
	EndIf
	$dir = StringLeft($szPath, $pos)
	$fname = StringRight($szPath, StringLen($szPath) - $pos)

	; If $szDir wasn't set, then the whole path must just be a file, so set the filename
	If StringLen($dir) = 0 Then $fname = $szPath

	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf

	; Set the strings and array to what we found
	$szDrive = $drive
	$szDir = $dir
	$szFName = $fname
	$szExt = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc   ;==>_PathSplit

; ===================================================================
; Author: Kurt (aka /dev/null) and JdeB
;
; _ReplaceStringInFile($szFileName, $szSearchString, $szReplaceString,$bCaseness = 0, $bOccurance = 0)
;
; Replaces a string ($szSearchString) with another string ($szReplaceString) the given TEXT file
; (via filename)
;
; Operation:
; The funnction opens the original file for reading and a temp file for writing. Then
; it reads in all lines and searches for the string. If it was found, the original line will be
; modified and written to the temp file. If the string was not found, the original line will be
; written to the temp file. At the end the original file will be deleted and the temp file will
; be renamed.
;
; Parameters:
; 	$szFileName 		name of the file to open.
;				ATTENTION !! Needs the FULL path, not just the name returned by eg. FileFindNextFile
; 	$szSearchString		The string we want to replace in the file
; 	$szReplaceString	The string we want as a replacement for $szSearchString
; 	$fCaseness		shall case matter?
;				0 = NO, case doe not matter (default), 1 = YES, case does matter
;	$fOccurance		shall we replace the string in every line or just the first occurance
;				0 = first only, 1 = ALL strings (default)
;
; Return Value(s):
;	On Success 		Returns the number of occurences of $szSearchString we found
;
;	On Failure 		Returns -1 sets @error
;					@error=1	Cannot open file
;					@error=2	Cannot open temp file
;					@error=3	Cannot write to temp file
;					@error=4	Cannot delete original file
;					@error=5	Cannot rename/move temp file
;					@error=6	File has read-only attribute
;
; ===================================================================
Func _ReplaceStringInFile($szFileName, $szSearchString, $szReplaceString, $fCaseness = 0, $fOccurance = 1)

	Local $iRetVal = 0
	Local $hWriteHandle, $aFileLines, $nCount, $sEndsWith, $hFile
	; Check if file is readonly ..
	If StringInstr(FileGetAttrib($szFileName),"R") then 
		SetError(6)
		Return -1
	EndIf
	;===============================================================================
	;== Read the file into an array
	;===============================================================================
	$hFile = FileOpen($szFileName, 0)
	If $hFile = -1 Then
		SetError(1)
		Return -1
	EndIf
	Local $s_TotFile = FileRead($hFile, FileGetSize($szFileName))
	If StringRight($s_TotFile, 2) = @CRLF Then
		$sEndsWith = @CRLF
	ElseIf StringRight($s_TotFile, 1) = @CR Then
		$sEndsWith = @CR
	ElseIf StringRight($s_TotFile, 1) = @LF Then
		$sEndsWith = @LF
	Else
		$sEndsWith = ""
	EndIf
	$aFileLines = StringSplit(StringStripCR($s_TotFile), @LF)
	FileClose($hFile)
	;===============================================================================
	;== Open the output file in write mode
	;===============================================================================
	$hWriteHandle = FileOpen($szFileName, 2)
	If $hWriteHandle = -1 Then
		SetError(2)
		Return -1
	EndIf
	;===============================================================================
	;== Loop through the array and search for $szSearchString
	;===============================================================================
	For $nCount = 1 To $aFileLines[0]
		If StringInStr($aFileLines[$nCount], $szSearchString, $fCaseness) Then
			$aFileLines[$nCount] = StringReplace($aFileLines[$nCount], $szSearchString, $szReplaceString, 1 - $fOccurance, $fCaseness)
			$iRetVal = $iRetVal + 1

			;======================================================================
			;== If we want just the first string replaced, copy the rest of the lines
			;== and stop
			;======================================================================
			If $fOccurance = 0 Then
				$iRetVal = 1
				ExitLoop
			EndIf
		EndIf
	Next
	;===============================================================================
	;== Write the lines back to original file.
	;===============================================================================
	For $nCount = 1 To $aFileLines[0] - 1
		If FileWriteLine($hWriteHandle, $aFileLines[$nCount]) = 0 Then
			SetError(3)
			FileClose($hWriteHandle)
			Return -1
		EndIf
	Next
	; Write the last record and ensure it ends with the same as the input file
	If $aFileLines[$nCount] <> "" Then FileWrite($hWriteHandle, $aFileLines[$nCount] & $sEndsWith)
	FileClose($hWriteHandle)

	Return $iRetVal
EndFunc   ;==>_ReplaceStringInFile

;========================================================================================================
;
; Function Name:    _TempFile([s_DirectoryName],[s_FilePrefix], [s_FileExtension], [i_RandomLength)
; Description:      Generate a name for a temporary file. The file is guaranteed not to already exist.
; Parameter(s):
;     $s_DirectoryName    optional  Name of directory for filename, defaults to @TempDir
;     $s_FilePrefix       optional  File prefixname, defaults to "~"
;     $s_FileExtension    optional  File extenstion, defaults to ".tmp"
;     $i_RandomLength     optional  Number of characters to use to generate a unique name, defaults to 7
; Requirement(s):   None.
; Return Value(s):  Filename of a temporary file which does not exist.
; Author(s):        Dale (Klaatu) Thompson
;                   Hans Harder - Added Optional parameters
; Notes:            None.
;
;========================================================================================================
Func _TempFile($s_DirectoryName = @TempDir, $s_FilePrefix = "~", $s_FileExtension = ".tmp", $i_RandomLength = 7)
	Local $s_TempName
	; Check parameters
	If Not FileExists($s_DirectoryName) Then $s_DirectoryName = @TempDir   ; First reset to default temp dir
	If Not FileExists($s_DirectoryName) Then $s_DirectoryName = @ScriptDir ; Still wrong then set to Scriptdir
	; add trailing \ for directory name
	If StringRight($s_DirectoryName, 1) <> "\" Then $s_DirectoryName = $s_DirectoryName & "\"
	;
	Do
		$s_TempName = ""
		While StringLen($s_TempName) < $i_RandomLength
			$s_TempName = $s_TempName & Chr(Random(97, 122, 1))
		WEnd
		$s_TempName = $s_DirectoryName & $s_FilePrefix & $s_TempName & $s_FileExtension
	Until Not FileExists($s_TempName)

	Return ($s_TempName)
EndFunc   ;==>_TempFile
