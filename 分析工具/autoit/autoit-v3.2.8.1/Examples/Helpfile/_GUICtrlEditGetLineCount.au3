#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $Status, $msg

GUICreate("Edit Get Line Count", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 140, 32, 121, 97, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE))
GUICtrlSetLimit($myedit, 1500)
$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

; will be append dont' forget 3rd parameter
GUICtrlSetData($myedit, "2nd line" & @CRLF & "3rd line" & @CRLF & "4th line" & @CRLF & _
      "5th line" & @CRLF & "6th line" & @CRLF & "7th line" & @CRLF & "8th line" & @CRLF & "9th line", 1)

GUISetState()
GUICtrlSetData($Status, "Line Count: " & _GUICtrlEditGetLineCount ($myedit))

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
   EndSelect
WEnd
