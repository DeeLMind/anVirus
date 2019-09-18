#include <GuiConstants.au3>
#include <GuiCombo.au3>
#Include <GuiStatusBar.au3>

Opt('MustDeclareVars', 1)

Dim $a_check[10], $msg, $ret, $s_attr, $allocated, $Status, $GUI
Dim $input, $group, $a_attr, $Combo, $button, $btn_exit

$GUI = GUICreate("ComboBox Add Dir", 400, 280)

GUICtrlCreateLabel("Enter files to find", 25, 15)
$input = GUICtrlCreateInput("", 125, 10, 180, 25)
$group = GUICtrlCreateGroup("Atrributes", 10, 40, -1, 200)
$a_attr = StringSplit("A,D,H,RO,RW,S,E,Drives,NB", ",")
$a_check[0] = 9
$a_check[1] = GUICtrlCreateCheckbox("Archive", 15, 55, 170, 20)
$a_check[2] = GUICtrlCreateCheckbox("Directory", 15, 75, 170, 20)
$a_check[3] = GUICtrlCreateCheckbox("Hidden", 15, 95, 170, 20)
$a_check[4] = GUICtrlCreateCheckbox("Read-Only", 15, 115, 170, 20)
$a_check[5] = GUICtrlCreateCheckbox("Read-Write", 15, 135, 95, 20)
$a_check[6] = GUICtrlCreateCheckbox("System", 15, 155, 170, 20)
$a_check[7] = GUICtrlCreateCheckbox("Exclusive", 15, 175, 170, 20)
$a_check[8] = GUICtrlCreateCheckbox("Drives", 15, 195, 170, 20)
$a_check[9] = GUICtrlCreateCheckbox("No Brackets (Drives Only)", 15, 215, 170, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

$Combo = GUICtrlCreateCombo("", 240, 40, 120, 120, $CBS_SIMPLE)
$allocated = _GUICtrlComboInitStorage ($Combo, 26, 50)

$button = GUICtrlCreateButton("Get Names", 240, 160, 120, 40)
$btn_exit = GUICtrlCreateButton("Exit", 240, 205, 120, 40)

$Status = _GUICtrlStatusBarCreate ($GUI, -1, "")
_GUICtrlStatusBarSetSimple ($Status)
_GUICtrlStatusBarSetText ($Status, "Pre-Allocated Memory For: " & $allocated & _
      " Items Added To ComboBox: " & _GUICtrlComboGetCount ($Combo), 255)
GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $btn_exit
         ExitLoop
      Case $msg = $button
         $s_attr = ""
         For $i = 1 To $a_check[0]
            If (BitAND(GUICtrlRead($a_check[$i]), $GUI_CHECKED)) Then
               If (StringLen($s_attr) > 0) Then
                  $s_attr &= "," & $a_attr[$i]
               Else
                  $s_attr = $a_attr[$i]
               EndIf
            EndIf
         Next
         _GUICtrlComboResetContent ($Combo)
         $ret = _GUICtrlComboAddDir ($Combo, $s_attr, GUICtrlRead($input))
         If ($ret < 0) Then
            If ($ret == $CB_ERRATTRIBUTE) Then
               MsgBox(16, "Error", "Invalid Attribute sent to _GUICtrlComboAddDir")
            ElseIf ($ret == $CB_ERRSPACE) Then
               MsgBox(16, "Error", "insufficient space to store the new strings from calling _GUICtrlComboAddDir")
            ElseIf ($ret == $CB_ERRREQUIRED) Then
               MsgBox(16, "Error", "Argument required for file search in call to _GUICtrlComboAddDir")
            ElseIf ($ret == $CB_ERR) Then
               MsgBox(16, "Error", "Unknown error from _GUICtrlComboAddDir" & @CRLF & "Possibly no files/folders found")
            EndIf
         EndIf
         _GUICtrlStatusBarSetText ($Status, "Pre-Allocated Memory For: " & $allocated & _
               " Items Added To ComboBox: " & _GUICtrlComboGetCount ($Combo), 255)
   EndSelect
WEnd
Exit
