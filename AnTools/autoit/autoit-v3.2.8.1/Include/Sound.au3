;===============================================================================
;
; Function Name:   _SoundOpen
; Description::    Opens a sound file for use with other _Sound functions
; Parameter(s):    $hFile - The sound file, $sAlias[optianal] - a name such as sound1,
;				   if you do not specify one it is randomly generated
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): string(the sound id) - Success, 0 - Failure
;				   @extended <> 0 - open failed, @error = 2 - File doesn't exist,
;				   @error = 3 - alias contains whitespace
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundOpen($hFile, $sAlias = "")
	;Declare variables
	Local $sSnd_id, $iCurrentPos, $iRet, $asAlias
	;check for file
	If Not FileExists($hFile) Then Return SetError(2, 0, 0)
	;search for whitespace by character
	$asAlias = StringSplit($sAlias, "")
	For $iCurrentPos = 1 To $asAlias[0]
		If StringIsSpace($asAlias[$iCurrentPos]) Then Return SetError(3, 0, 0)
	Next
	;create random alias if one is not supplied
	If $sAlias = "" Then
		$sSnd_id = RandomStr(10)
	Else
		$sSnd_id = $sAlias
	EndIf
	;open file
	$iRet = mciSendString("open " & FileGetShortName($hFile) & " alias " & FileGetShortName($sSnd_id))
	Return SetError(0, $iRet, $sSnd_id)
EndFunc   ;==>_SoundOpen

;===============================================================================
;
; Function Name:   _SoundClose
; Description::    Closes a sound
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 and @error = 1 - Failure
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundClose($sSnd_id)
	If mciSendString("close " & FileGetShortName($sSnd_id)) = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundClose

;===============================================================================
;
; Function Name:   _SoundPlay
; Description::    Plays a sound from the current position (beginning is the default)
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file
;				   $fWait - If set to 1 the script will wait for the sound to finish before continuing
;						 - If set to 0 the script will continue while the sound is playing
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 - Failure
;				   @error = 2 - $fWait is invalid, @error = 1 - play failed
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundPlay($sSnd_id, $fWait = 0)
	;Declare variables
	Local $iRet
	;validate $fWait
	If $fWait <> 0 And $fWait <> 1 Then Return SetError(2, 0, 0)
	;if sound has finished, seek to start
	If _SoundPos($sSnd_id, 2) = _SoundLength($sSnd_id, 2) Then mciSendString("seek " & FileGetShortName($sSnd_id) & " to start")
	;If $fWait = 1 then pass wait to mci
	If $fWait = 1 Then
		$iRet = mciSendString("play " & FileGetShortName($sSnd_id) & " wait")
	Else
		$iRet = mciSendString("play " & FileGetShortName($sSnd_id))
	EndIf
	;return
	If $iRet = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundPlay

;===============================================================================
;
; Function Name: _SoundStop
; Description::    Stops the sound
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 and @error = 1 - Failure,
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundStop($sSnd_id)
	;Declare variables
	Local $iRet, $iRet2
	;seek to start
	$iRet = mciSendString("seek " & FileGetShortName($sSnd_id) & " to start")
	;stop
	$iRet2 = mciSendString("stop " & FileGetShortName($sSnd_id))
	;return
	If $iRet = 0 And $iRet2 = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundStop

;===============================================================================
;
; Function Name:   _SoundPause
; Description::    Pauses the sound
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 and @error = 1 - Failure,
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundPause($sSnd_id)
	;Declare variables
	Local $iRet
	;pause sound
	$iRet = mciSendString("pause " & FileGetShortName($sSnd_id))
	;return
	If $iRet = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundPause

;===============================================================================
;
; Function Name:   _SoundResume
; Description::    Resumes the sound after being paused
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 and @error = 1 - Failure,
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundResume($sSnd_id)
	;Declare variables
	Local $iRet
	;resume sound
	$iRet = mciSendString("resume " & FileGetShortName($sSnd_id))
	;return
	If $iRet = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundResume

;===============================================================================
;
; Function Name:   _SoundLength
; Description::    Returns the length of the sound in the format hh:mm:ss
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file,
;				   $iMode = 1 - hh:mm:ss, $iMode = 2 - milliseconds
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): Length of the sound - Success, 0 and @error = 1 - $iMode is invalid
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundLength($sSnd_id, $iMode = 1)
	;Declare variables
	Local $iSnd_len_ms, $iSnd_len_min, $iSnd_len_hour, $iSnd_len_sec, $sSnd_len_format
	;validate $iMode
	If $iMode <> 1 And $iMode <> 2 Then Return SetError(1, 0, 0)
	;tell mci to use time in milliseconds
	mciSendString("set " & FileGetShortName($sSnd_id) & " time format miliseconds")
	;recieve length of sound
	$iSnd_len_ms = mciSendString("status " & FileGetShortName($sSnd_id) & " length")
	;assign modified data to variables
	$iSnd_len_min = Int($iSnd_len_ms / 60000)
	$iSnd_len_hour = Int($iSnd_len_min / 60)
	$iSnd_len_sec = Int(Int($iSnd_len_ms / 1000) - ($iSnd_len_min * 60))
	;assign formatted data to $sSnd_len_format
	$sSnd_len_format = StringFormat("%02i:%02i:%02i", $iSnd_len_hour, $iSnd_len_min, $iSnd_len_sec)
	;return correct variable
	If $iMode = 1 Then Return $sSnd_len_format
	If $iMode = 2 Then Return $iSnd_len_ms
EndFunc   ;==>_SoundLength

;===============================================================================
;
; Function Name:   _SoundSeek
; Description::    Seeks the sound to a specified time
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen (must NOT be a file), $iHour, $iMin, $iSec
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): 1 - Success, 0 and @error = 1 - Failure,
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundSeek($sSnd_id, $iHour, $iMin, $iSec)
	;Declare variables
	Local $iMs = 0
	Local $iRet
	;prepare mci to recieve time in milliseconds
	mciSendString("set " & FileGetShortName($sSnd_id) & " time format miliseconds")
	;modify the $iHour, $iMin and $iSec parameters to be in milliseconds
	;and add to $iMs
	$iMs += $iSec * 1000
	$iMs += $iMin * 60 * 1000
	$iMs += $iHour * 60 * 60 * 1000
	; seek sound to time ($iMs)
	$iRet = mciSendString("seek " & FileGetShortName($sSnd_id) & " to " & $iMs)
	;return
	If $iRet = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundSeek

;===============================================================================
;
; Function Name:   _SoundStatus
; Description::    All devices can return the "not ready", "paused", "playing", and "stopped" values.
;				   Some devices can return the additional "open", "parked", "recording", and "seeking" values.(MSDN)
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): Sound Status
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundStatus($sSnd_id)
	;return status
	Return mciSendString("status " & FileGetShortName($sSnd_id) & " mode")
EndFunc   ;==>_SoundStatus

;===============================================================================
;
; Function Name:   _SoundPos
; Description::    Returns the current position of the song
; Parameter(s):    $sSnd_id - Sound ID returned by _SoundOpen or sound file,
;				   $iMode = 1 - hh:mm:ss, $iMode = 2 - milliseconds
; Requirement(s):  AutoIt 3.2 ++
; Return Value(s): Current Position - Success, @error = 1 - $iMode is invalid
; Author(s):       RazerM
;
;===============================================================================
;
Func _SoundPos($sSnd_id, $iMode = 1)
	;Declare variables
	Local $iSnd_pos_ms, $iSnd_pos_min, $iSnd_pos_hour, $iSnd_pos_sec, $sSnd_pos_format
	;validate $iMode
	If $iMode <> 1 And $iMode <> 2 Then Return SetError(1, 0, 0)
	;tell mci to use time in milliseconds
	mciSendString("set " & FileGetShortName($sSnd_id) & " time format miliseconds")
	;receive position of sound
	$iSnd_pos_ms = mciSendString("status " & FileGetShortName($sSnd_id) & " position")
	;modify data and assign to variables
	$iSnd_pos_min = Int($iSnd_pos_ms / 60000)
	$iSnd_pos_hour = Int($iSnd_pos_min / 60)
	$iSnd_pos_sec = Int(Int($iSnd_pos_ms / 1000) - ($iSnd_pos_min * 60))
	;assign formatted data to $sSnd_pos_format
	$sSnd_pos_format = StringFormat("%02i:%02i:%02i", $iSnd_pos_hour, $iSnd_pos_min, $iSnd_pos_sec)
	;return correct variable
	If $iMode = 1 Then Return $sSnd_pos_format
	If $iMode = 2 Then Return $iSnd_pos_ms
EndFunc   ;==>_SoundPos

;internal functions
Func mciSendString($string)
	Local $iRet
	$iRet = DllCall("winmm.dll", "int", "mciSendStringA", "str", $string, "str", "", "int", 65534, "hwnd", 0)
	If Not @error Then Return $iRet[2]
EndFunc   ;==>mciSendString

Func RandomStr($len)
	Local $string
	For $iCurrentPos = 1 To $len
		$string &= Chr(Random(97, 122, 1))
	Next
	Return $string
EndFunc   ;==>RandomStr