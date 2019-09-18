;===============================================================================
;
; Description:      Show all icons in the given file
; Requirement(s):   Autoit 3.2.5+ and Dllcallback.au3 UDF
; Author(s):        YDY (Lazycat)
; Version:          2.0
; Date:             02.08.2007
;
;===============================================================================
#include <GUIConstants.au3>
#include "DllCallBack.au3"

; Setting variables
Global $BTN_STYLE = BitOR($BS_CHECKBOX, $BS_PUSHLIKE, $BS_FLAT)
Global $ahIcons[30], $ahLabels[30]
Global $iStartIndex = 1, $iCntRow, $iCntCol, $iCurIndex
Global $glFilename = @SystemDir & "\shell32.dll"; Default file is "shell32.dll"
Global $bOrdinal = true
Global $glNames[1]
Global $hSelected

; Creating GUI and controls
$hGui=GUICreate("Icon Selector by Ordinal value", 385, 435, -1, -1, -1, $WS_EX_ACCEPTFILES)
GUICtrlCreateGroup("", 5, 1, 375, 40)
GUICtrlCreateGroup("", 5, 50, 375, 380)
$hFile = GUICtrlCreateInput($glFilename, 12,  15, 325, 16, -1, $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
GUICtrlSetTip(-1, "You can drop files from shell here...")
$hStatus = GUICtrlCreateInput("", 155, 49, 125, 16, $ES_READONLY, $WS_EX_STATICEDGE)
$hFileSel = GUICtrlCreateButton("...", 345,  14, 26, 18)
$hPrev = GUICtrlCreateButton("Previous", 10,  45, 60, 24, $BTN_STYLE)
GUICtrlSetState(-1, $GUI_DISABLE)
$hNext = GUICtrlCreateButton("Next", 75,  45, 60, 24, $BTN_STYLE)
$hToggle = GUICtrlCreateButton("by Name", 300,  45, 60, 24, $BTN_STYLE)
$hOverlay = GUICtrlCreateLabel("", -99, -99 , 60, 62, $SS_GRAYFRAME)
$hContext = GUICtrlCreateContextMenu($hOverlay)
$hCopyIndex = GUICtrlCreateMenuItem("Copy Ordinal Value", $hContext)
$hCopyName = GUICtrlCreateMenuItem("Copy Resource Name", $hContext)

; This code build two arrays of ID's of icons and labels for easily update
For $iCntRow = 0 to 4
    For $iCntCol = 0 to 5
        $iCurIndex = $iCntRow * 6 + $iCntCol
        $ahIcons[$iCurIndex]  = GUICtrlCreateIcon($glFilename, 0, 60 * $iCntCol + 25, 70 * $iCntRow + 80)
        $ahLabels[$iCurIndex] = GUICtrlCreateLabel("", 60 * $iCntCol+12, 70 * $iCntRow + 115, 58, 20, $SS_CENTER)
    Next
Next

_NewFileLoad($glFilename)
_GUIUpdate()

GUISetState()

While 1
    $aInfo = GUIGetCursorInfo()
    If IsArray($aInfo) Then
        If ($aInfo[4] >= $ahIcons[0] and $aInfo[4] <= $ahLabels[29]) Then
            If $hSelected = $aInfo[4] Then ContinueLoop
            $pos = ControlGetPos($hGUI, "", $aInfo[4])
            If $pos[2] = 58 Then ; Label
                GuiCtrlSetPos($hOverlay, $pos[0] - 1, $pos[1] + $pos[3] - 60)
            Else ; Icon
                GuiCtrlSetPos($hOverlay, $pos[0] - 14, $pos[1] - 5)
            EndIf
            $hSelected = $aInfo[4]
        EndIf
    EndIf
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $hCopyName, $hCopyIndex
            For $i = 0 To 29
                If ($ahIcons[$i] = $hSelected or $ahLabels[$i] = $hSelected) and ($i + $iStartIndex <= $glNames[0]) Then
                    If $nMsg = $hCopyName Then
                        ClipPut($glNames[$i + $iStartIndex])
                    Else
                        ClipPut(-($i + $iStartIndex))
                    EndIf
                EndIf
            Next
        Case $GUI_EVENT_DROPPED
            $glFileName = @GUI_DragFile
            GUICtrlSetData($hFile, $glFileName)
            _NewFileLoad($glFileName)
            _GUIUpdate()
        Case $hFileSel
            $sTmpFile = FileOpenDialog("Select file:", GUICtrlRead($hFile), "Executables & dll's (*.exe;*.dll;*.ocx;*.icl)")
            If @error Then ContinueLoop
            $glFileName = $sTmpFile
            GUICtrlSetData($hFile, $glFileName)
            _NewFileLoad($glFileName)
            _GUIUpdate()
        Case $hPrev
            $iStartIndex = $iStartIndex - 30
            _GUIUpdate()
        Case $hNext
            $iStartIndex = $iStartIndex + 30
            _GUIUpdate()
        Case $hToggle
        	$bOrdinal = not $bOrdinal
            _SetMode()
            _GUIUpdate()
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
Wend

; Updates GUI icons, labels and state of navigate buttons
Func _GUIUpdate()
    For $iCntRow = 0 to 4
        For $iCntCol = 0 to 5
            $iCurIndex = $iCntRow * 6 + $iCntCol
            If ($iCurIndex + $iStartIndex) > $glNames[0] Then
                GUICtrlSetState($ahIcons[$iCurIndex], $GUI_HIDE)
                GUICtrlSetState($ahLabels[$iCurIndex], $GUI_HIDE)
            Else
                GUICtrlSetState($ahIcons[$iCurIndex], $GUI_SHOW)
                GUICtrlSetState($ahLabels[$iCurIndex], $GUI_SHOW)
                If $bOrdinal then
                    GUICtrlSetImage($ahIcons[$iCurIndex], $glFileName, -($iStartIndex + $iCurIndex))
                    GUICtrlSetData($ahLabels[$iCurIndex], -($iStartIndex + $iCurIndex))
                Else
                    GUICtrlSetImage($ahIcons[$iCurIndex], $glFileName, $glNames[$iStartIndex + $iCurIndex])
                    GUICtrlSetData($ahLabels[$iCurIndex], '"' & $glNames[$iStartIndex + $iCurIndex] & '"')
                EndIf
            EndIf
        Next
    Next

    ; Keep icons in bounds
    If $iStartIndex = 1 Then
        GUICtrlSetState($hPrev, $GUI_DISABLE)
    Else
        GUICtrlSetState($hPrev, $GUI_ENABLE)
    Endif
    If $iStartIndex + 30 > $glNames[0] Then
        GUICtrlSetState($hNext, $GUI_DISABLE)
    Else
        GUICtrlSetState($hNext, $GUI_ENABLE)
    Endif
    $iToNumber = $iStartIndex + 29
    If $iToNumber > $glNames[0] Then $iToNumber = $iToNumber - ($iToNumber - $glNames[0])
    GUICtrlSetData($hStatus, " " & $iStartIndex & " - " & $iToNumber & " from " & $glNames[0])
EndFunc

Func _SetMode()
    If $bOrdinal Then
        GUICtrlSetData($hToggle, "by Name")
        WinSetTitle($hGui,"","Icon Selector by Ordinal value")
    Else
        GUICtrlSetData($hToggle, "by Ordinal")
        WinSetTitle($hGui,"","Icon Selector by Name value")
    EndIf
EndFunc

Func _NewFileLoad($sFilename)
    GuiCtrlSetPos($hOverlay, -99, -99)
    $iStartIndex = 1
    ReDim $glNames[1]
    ; ICL is 16-bit library, we can't load it with LoadLibrary... maybe any other good way?
    If StringRight($sFilename, 4) = ".icl" Then
        $glNames[0] =  _GetIconCount($sFilename)
        $bOrdinal = True
        GUICtrlSetState($hToggle, $GUI_DISABLE)
        GUICtrlSetState($hCopyName, $GUI_DISABLE)
        _SetMode()
        Return 1
    EndIf
    GUICtrlSetState($hToggle, $GUI_ENABLE)
    GUICtrlSetState($hCopyName, $GUI_ENABLE)
    $glNames[0] = 0
    Local $hMod = DllCall("Kernel32.dll", "int", "LoadLibraryEx", "str", $sFilename, "int", 0, "int", 0x22)
    If $hMod[0] = 0 Then
        MsgBox (48, "Error", "Not a library or can't load library.")
        Return 0
    EndIf
    $hMod = $hMod[0]
    Local $hStub_EnumResNames = _DllCallBack("_EnumResNames", "int;ptr;ptr;ptr")
    DllCall("kernel32.dll", "int:stdcall", "EnumResourceNames", "int", $hMod, "ptr", 14, "ptr", $hStub_EnumResNames, "long_ptr", 0)
    _DllCallBack_Free ($hStub_EnumResNames)
    DllCall("Kernel32.dll", "int", "FreeLibrary", "int", $hMod)
EndFunc

Func _EnumResNames($hModule, $lpType, $lpName, $lParam)
    $glNames[0] += 1
    ReDim $glNames[$glNames[0]+1]
    If BitAND($lpName, 0xFFFF0000) Then
        Local $s = DllStructCreate("char[256]", $lpName)
        $glNames[$glNames[0]] = DllStructGetData($s, 1)
    Else
        $glNames[$glNames[0]] = $lpName
    EndIf
	Return 1
EndFunc

Func _GetIconCount($sFilename)
    Local $iCount= DllCall("Shell32", "int", "ExtractIconEx", "str", $sFilename, "int", -1, "ptr", 0, "ptr", 0, "int", 1)
    If not @error Then Return $iCount[0]
    Return 0
EndFunc