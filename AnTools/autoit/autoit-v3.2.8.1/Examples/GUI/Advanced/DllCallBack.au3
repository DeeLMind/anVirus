Global Const $gi_DllCallBack_uiMsg = 0x7FFF ; WM_USER + 0x7BFF
Global Const $gi_DllCallBack_MaxStubs = 64

Global $gp_DllCallBack_SendMessage = 0
Global $gh_DllCallBack_hUser32 = 0
Global $gi_DllCallBack_StubCount = 0
Global $gh_DllCallBack_hWnd = GUICreate("au3_Callback")
Global $ga_DllCallBack_sParameters[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_nParameters[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_sFunctions[$gi_DllCallBack_MaxStubs + 1]
Global $ga_DllCallBack_hGlobals[$gi_DllCallBack_MaxStubs + 1]

;===============================================================================
;
; Function Name:   	_DllCallBack
; Description:		Allocates executeable memory and creates a procedure
;					which forwards a pointer to its arguments to a Window
; Parameter(s):    	$sFunction - Name of handler function
;					$sParameters - DllStruct like parameter definition
;					$fCedecl, Optional - use cdecl calling convention (default is stdcall)
; Requirement(s):
; Return Value(s):	Pointer to created stub or NULL on error
; @error Value(s):	1 = Error allocating memory
;					2 = Error Loading User32.dll
;					3 = Failed to get the address of SendMessage
;					4 = Too many callbacks
;					5 = GUIRegisterMsg() Failed
;					6 = $sParameters Fromat wrong
;
; Author(s): 		Florian Fida
; Notes:			The number of coexistent callback stubs is limited to 64.
;					Windows message WM_USER + 0x7BFF is used by this function.
;
;===============================================================================
;
Func _DllCallBack($sFunction, $sParameters = "", $fcdecl = False)
	Local $hGlobal, $hUser32, $pSendMessage_RelAddr, $vStub, $i, $nParameters, $vParameters, $wParam = -1, $nParameters_struct = -1
    If $sParameters = "" Or $sParameters = Default Then
	   $nParameters = 0
    Else
	   $vParameters = DllStructCreate($sParameters)
	   If @error Then Return SetError(6,0,0)
	   $nParameters = DllStructGetSize($vParameters) / 4
	   If $nParameters <> Int($nParameters) Or @error Then Return SetError(6, 0, 0)
	   For $i = 1 To 256
		  DllStructGetData($vParameters,$i)
		  If @error Then 
			 $nParameters_struct = $i - 1
			 ExitLoop
		  EndIf
	   Next
	   If $nParameters_struct < 0 Then SetError(6, 0, 0)
    EndIf
	For $i = 0 To $gi_DllCallBack_MaxStubs
		If Not $ga_DllCallBack_hGlobals[$i] Then
			$wParam = $i
			ExitLoop
		EndIf
	Next
	If $wParam = -1 Then Return SetError(4, 0, 0)
	If Not GUIRegisterMsg($gi_DllCallBack_uiMsg, "__DllCallBack_MsgHandler") Then Return SetError(5, 0, 0)
	$hGlobal = DllCall("kernel32.dll", "ptr", "GlobalAlloc", "uint", 0, "dword", 87) ; 87 = Size of stub
	If @error Then Return SetError(1, 0, 0)
	If $hGlobal[0] = 0 Then Return SetError(1, 0, 0)
	$hGlobal = $hGlobal[0]
	If $gp_DllCallBack_SendMessage = 0 Then
		$hUser32 = DllCall("kernel32.dll", "ptr", "LoadLibrary", "str", "user32.dll")
		If @error Then Return SetError(2, 0, 0)
		If $hUser32[0] = 0 Then SetError(2, 0, 0)
		$gh_DllCallBack_hUser32 = $hUser32[0]
		$pSendMessage = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $gh_DllCallBack_hUser32, "str", "SendMessageA")
		If @error Then Return SetError(3, 0, 0)
		If $pSendMessage = 0 Then Return SetError(3, 0, 0)
		$gp_DllCallBack_SendMessage = $pSendMessage[0]
	EndIf
	$pSendMessage_RelAddr = $gp_DllCallBack_SendMessage - ($hGlobal + 0x22)
	$vStub = DllStructCreate("ubyte[30];" _ ; 1 Stub Part 1
			 & "ptr;" _ ; 2 Address of SendMessage relative to $+22 (pTo - $+22)
			 & "ubyte[9];" _ ; 3 Stub Part 2
			 & "byte[6];" _ ; 4 6 bytes nothing
			 & "long;" _ ; 5 nParams
			 & "hwnd;" _ ; 6 hwnd
			 & "uint;" _ ; 7 msg
			 & "uint;", $hGlobal) ; 8 wparam
	#cs Stub Part 1
	  $-1      > CC               INT3									   ; Breakpoint (Optional)
	  $ ==>    > E8 00000000      CALL 0015F056                            ; CALL next instruction
	  $+5      > 58               POP EAX                                  ; Get return address from last CALL
	  $+6      > 8D90 2B000000    LEA EDX,DWORD PTR DS:[EAX+2B]            ; Load address for parameters
	  $+C      > 8D4424 04        LEA EAX,DWORD PTR SS:[ESP+4]             ; Load stack pointer
	  $+10     > FF32             PUSH DWORD PTR DS:[EDX]                  ; Push nr. of parameters (for later ESP correction)
	  $+12     > 50               PUSH EAX                                 ; Push lParam - Stack pointer
	  $+13     > FF72 0C          PUSH DWORD PTR DS:[EDX+C]                ; Push wParam
	  $+16     > FF72 08          PUSH DWORD PTR DS:[EDX+8]                ; Push Msg
	  $+19     > FF72 04          PUSH DWORD PTR DS:[EDX+4]                ; Push hWnd
	  $+1C     > E8 39F2BB77      CALL USER32.77D1E2AB                     ; Call SendMessageA
	#ce
	DllStructSetData($vStub, 1, Binary("0x90E800000000588D902B0000008D442404FF3250FF720CFF7208FF7204E8"))
	DllStructSetData($vStub, 2, $pSendMessage_RelAddr)
	If $fcdecl <> False Then
		#cs Stub Part 2 - cdecl
			$+21     > 90               NOP
			$+22     > 5A               POP EDX
			$+23     > 59               POP ECX
			$+24     > 90               NOP
			$+25     > 90               NOP
			$+26     > 90               NOP
			$+27     > FFE1             JMP ECX
			$+29     > 90               NOP
		#ce
		DllStructSetData($vStub, 3, Binary("0x905A59909090FFE190"))
	Else
		#cs Stub Part 2 - stdcall
			$+21     > 90               NOP
			$+22     > 5A               POP EDX
			$+23     > 59               POP ECX
			$+24     > 8D2494           LEA ESP,DWORD PTR SS:[ESP+EDX*4]
			$+27     > FFE1             JMP ECX
			$+29     > 90               NOP
		#ce
		DllStructSetData($vStub, 3, Binary("0x905A598D2494FFE190"))
	EndIf
;~    $+2A     > 000000000000
	DllStructSetData($vStub, 4, Binary("0x000000000000"))
;~    $+30     > 00000000
	DllStructSetData($vStub, 5, $nParameters)
;~    $+34     > 00000000
	DllStructSetData($vStub, 6, $gh_DllCallBack_hWnd)
;~    $+38     > 00000000
	DllStructSetData($vStub, 7, $gi_DllCallBack_uiMsg)
;~    $+3C     > 00000000
	DllStructSetData($vStub, 8, $wParam)
	$gi_DllCallBack_StubCount += 1
	$ga_DllCallBack_hGlobals[$wParam] = $hGlobal
	$ga_DllCallBack_sFunctions[$wParam] = $sFunction
	$ga_DllCallBack_sParameters[$wParam] = $sParameters
	$ga_DllCallBack_nParameters[$wParam] = $nParameters_struct
	Return $hGlobal
EndFunc   ;==>_DllCallBack


;===============================================================================
;
; Function Name:	_DllCallBack_Free
; Description:		Frees memory from global heap allocated by _DllCallBackAlloc
; Parameter(s):    	$hStub - Pointer to stub
; Requirement(s):
; Return Value(s):	On Success: True
;					On Failure: False
; @error Value(s):	1 - Error freeing memory
;					2 - Error freeing User32.dll
; Author(s):		Florian Fida
;
;===============================================================================
;
Func _DllCallBack_Free(ByRef $hStub)
	Local $aTmp, $i
	If $hStub > 0 Then
		$aTmp = DllCall("kernel32.dll", "ptr", "GlobalFree", "ptr", $hStub)
		If @error Then Return SetError(1, 0, False)
		If $aTmp[0] = $hStub Then Return SetError(1, 0, False)
		If $aTmp[0] = 0 Then
			For $i = 0 To 255
				If $ga_DllCallBack_hGlobals[$i] = $hStub Then
					$ga_DllCallBack_hGlobals[$i] = ""
					$ga_DllCallBack_sParameters[$i] = ""
					$ga_DllCallBack_nParameters[$i] = ""
					$ga_DllCallBack_sFunctions[$i] = ""
					ExitLoop
				EndIf
			Next
			$hStub = 0
			$gi_DllCallBack_StubCount -= 1
			If $gi_DllCallBack_StubCount < 1 Then
				$gi_DllCallBack_StubCount = 0
				$aTmp = DllCall("kernel32.dll", "int", "FreeLibrary", "ptr", $gh_DllCallBack_hUser32)
				If @error Then Return SetError(2, 0, False)
				If $aTmp[0] = 0 Then Return SetError(2, 0, False)
				$gh_DllCallBack_hUser32 = 0
			EndIf
			Return True
		EndIf
		Return False
	EndIf
	Return True
EndFunc   ;==>_DllCallBack_Free

Func __DllCallBack_MsgHandler($hWnd_Callback, $uiMsg, $wParam, $lParam)
	Local $vParameters, $i
	$vParameters = DllStructCreate($ga_DllCallBack_sParameters[$wParam], $lParam)
	If $ga_DllCallBack_nParameters[$wParam] > 0 Then
		Local $aCallArgs[$ga_DllCallBack_nParameters[$wParam] + 1]
		$aCallArgs[0] = "CallArgArray"
		For $i = 1 To $ga_DllCallBack_nParameters[$wParam]
			$aCallArgs[$i] = DllStructGetData($vParameters, $i)
		Next
		Return Call($ga_DllCallBack_sFunctions[$wParam], $aCallArgs)
	EndIf
	Return Call($ga_DllCallBack_sFunctions[$wParam])
EndFunc   ;==>__DllCallBack_MsgHandler