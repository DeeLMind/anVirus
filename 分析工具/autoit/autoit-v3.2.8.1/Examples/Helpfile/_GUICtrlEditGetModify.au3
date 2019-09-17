#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $ret, $Status, $msg, $current

GUICreate("Edit Get Modify", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 140, 32, 121, 97, $ES_AUTOVSCROLL + $WS_VSCROLL)

$Status = GUICtrlCreateLabel("Un-Modified", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
   $ret = _GUICtrlEditGetModify ($myedit)
   If ($ret <> $current) Then
      If ($ret == 0) Then
         GUICtrlSetData($Status, "Un-Modified")
      Else
         GUICtrlSetData($Status, "Modified")
      EndIf
      $current = $ret
   EndIf
   If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd
