#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars', 1)

Dim $a_check[10], $msg, $ret, $s_attr
Dim $input, $group, $a_attr, $listbox, $button, $btn_exit

GUICreate("ListBox Add Item Demo", 400, 250, -1, -1)
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

$listbox = GUICtrlCreateList("", 240, 40, 120, 120)
$button = GUICtrlCreateButton("Get Names", 240, 160, 120, 40)
$btn_exit = GUICtrlCreateButton("Exit", 240, 205, 120, 40)

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
         _GUICtrlListClear ($listbox)
         $ret = _GUICtrlListAddDir ($listbox, $s_attr, GUICtrlRead($input))
         If ($ret < 0) Then
            If ($ret == $LB_ERRATTRIBUTE) Then
               MsgBox(16, "Error", "Invalid Attribute sent to _GUICtrlListAddDir")
            ElseIf ($ret == $LB_ERRSPACE) Then
               MsgBox(16, "Error", "insufficient space to store the new strings from calling _GUICtrlListAddDir")
            ElseIf ($ret == $LB_ERRREQUIRED) Then
               MsgBox(16, "Error", "Argument required for file search in call to _GUICtrlListAddDir")
            ElseIf ($ret == $LB_ERR) Then
               MsgBox(16, "Error", "Unknown error from _GUICtrlListAddDir" & @CRLF & "Possibly no files/folders found")
            EndIf
         EndIf
   EndSelect
WEnd
