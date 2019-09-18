#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $ret, $Status, $msg, $current, $Btn_Set, $i_bool = 0

GUICreate("Edit Set Modify", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 140, 32, 121, 97, $ES_AUTOVSCROLL + $WS_VSCROLL)
$Btn_Set = GUICtrlCreateButton("Set", 150, 140, 90, 30)

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
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $Btn_Set
         $i_bool = Not $i_bool
         _GUICtrlEditSetModify ($myedit, $i_bool)
   EndSelect
WEnd
