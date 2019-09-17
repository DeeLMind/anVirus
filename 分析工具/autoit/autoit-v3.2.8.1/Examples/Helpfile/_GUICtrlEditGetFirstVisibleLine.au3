#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $Status, $msg, $Btn_get

GUICreate("Edit Get First Visible Line", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 140, 32, 121, 97, $ES_AUTOVSCROLL + $WS_VSCROLL)
$Btn_get = GUICtrlCreateButton("Get", 150, 150)
$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

; will be append dont' forget 3rd parameter
GUICtrlSetData($myedit, "2nd line" & @CRLF & "3rd line" & @CRLF & "4th line" & @CRLF & _
      "5th line" & @CRLF & "6th line" & @CRLF & "7th line" & @CRLF & "8th line" & @CRLF & "9th line", 1)

GUISetState()

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $Btn_get
         GUICtrlSetData($Status, "First Visible Line: " & _GUICtrlEditGetFirstVisibleLine ($myedit))
   EndSelect
WEnd
