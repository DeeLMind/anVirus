; *******************************************************
; Example 1 - Display the frameset example, get frame collection,
;				check number of frames, display number of frames or iFrames present
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("frameset")
$oFrames = _IEFrameGetCollection ($oIE)
$iNumFrames = @extended
If $iNumFrames > 0 Then
	If _IEIsFrameSet ($oIE) Then
		MsgBox(0, "Frame Info", "Page contains " & $iNumFrames & " frames in a FrameSet")
	Else
		MsgBox(0, "Frame Info", "Page contains " & $iNumFrames & " iFrames")
	EndIf
Else
	MsgBox(0, "Frame Info", "Page contains no frames")
EndIf