#include <GuiConstants.au3>
#include <GuiCombo.au3>

opt('MustDeclareVars', 1)

Dim $Combo, $Btn_Exit, $Status, $msg, $Btn_Get, $Input_item

GUICreate("ComboBox Get LB Text", 392, 254)

$Combo = GUICtrlCreateCombo("", 70, 10, 270, 120)
GUICtrlSetData($Combo, "AutoIt|v3|is|freeware|BASIC-like|scripting|language|designed|for|automating|the Windows GUI.")

GUICtrlCreateLabel("Enter index number of item:", 65, 112, 130, 20, $SS_RIGHT)
$Input_item = GUICtrlCreateInput("0", 200, 110, 50, 20, $ES_NUMBER)
GUICtrlSetLimit($Input_item, 2)

$Btn_Get = GUICtrlCreateButton("Get Text", 150, 140, 90, 30)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)
$Status = GUICtrlCreateLabel("", 0, 234, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
GUICtrlSetData($Status, "Items: " & _GUICtrlComboGetCount ($Combo))

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Btn_Get
         Local $s_text
         Local $i_count = _GUICtrlComboGetLBText ($Combo, Int(GUICtrlRead($Input_item)), $s_text)
         If ($i_count == $CB_ERR) Then
            GUICtrlSetData($Status, "Invalid Index: " & GUICtrlRead($Input_item))
         Else
            GUICtrlSetData($Status, "Len: " & $i_count & ", Index: " & GUICtrlRead($Input_item) & " = " & $s_text)
         EndIf
   EndSelect
WEnd
Exit
