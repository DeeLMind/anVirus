#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $ret, $Status, $msg, $current, $Btn_Empty

GUICreate("Edit Empty Undo Buffer", 392, 254)

$myedit = GUICtrlCreateEdit("First line" & @CRLF, 140, 32, 121, 97, $ES_AUTOVSCROLL + $WS_VSCROLL)
$Btn_Empty = GUICtrlCreateButton("Emtpy Buffer", 150, 150)
$Status = GUICtrlCreateLabel("Nothing to Undo", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
   $ret = _GUICtrlEditCanUndo ($myedit)
   If ($ret <> $current) Then
      If ($ret == 0) Then
         GUICtrlSetData($Status, "Nothing to Undo")
      Else
         GUICtrlSetData($Status, "Undo Available")
      EndIf
      $current = $ret
   EndIf
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $Btn_Empty
         _GUICtrlEditEmptyUndoBuffer ($myedit)
   EndSelect
WEnd
