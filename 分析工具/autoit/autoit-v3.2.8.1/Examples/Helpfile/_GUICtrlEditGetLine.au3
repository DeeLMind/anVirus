#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $Status, $msg, $Btn_GET
Dim $s_text = "AutoIt v3 is a freeware BASIC-like scripting language" & @CRLF & _
		  "designed for automating the Windows GUI." & @CRLF & _
		  "It uses a combination of simulated keystrokes," & @CRLF & _
		  "mouse movement and window/control manipulation" & @CRLF & _
		  "in order to automate tasks in a way not possible" & @CRLF & _
		  "or reliable with other languages (e.g. VBScript and SendKeys)."

;================================================================
; Example 1 - Get Line using AutoIt Control
;================================================================
GUICreate("Edit Get Line", 392, 254)

$myedit = GUICtrlCreateEdit($s_text, 140, 32, 121, 97, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $WS_VSCROLL, $WS_HSCROLL, $ES_MULTILINE))
GUICtrlSetLimit($myedit, 1500)
$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$Btn_GET = GUICtrlCreateButton("Get Line 3", 150, 130, 90, 40, $BS_MULTILINE)

GUISetState()

; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $Btn_GET
            Local $line = _GUICtrlEditGetLine($myedit, 3)
				If @error == $EC_ERR Then
                GUICtrlSetData($Status, "Line: Invalid")
            Else
                GUICtrlSetData($Status, "Line: " & $line)
            EndIf
    EndSelect
WEnd
GUIDelete()

;================================================================
; Example 2 - Get Line using external Control
;================================================================
Run("Notepad")
WinWait("Untitled - Notepad")
$myedit = ControlGetHandle("Untitled - Notepad", "", "Edit1")
ControlSetText("Untitled - Notepad","", "Edit1", $s_Text)
MsgBox(0,"Line 4", _GUICtrlEditGetLine($myedit, 4))
