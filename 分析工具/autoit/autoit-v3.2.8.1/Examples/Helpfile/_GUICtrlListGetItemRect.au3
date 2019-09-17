#include <GUIConstants.au3>
#include <GuiList.au3>

opt('MustDeclareVars', 1)

Dim $listbox, $s_rect, $label_rect, $Btn_GETRECT, $Btn_Exit, $msg

GUICreate("ListBox Get Item RECT", 400, 250, -1, -1)

$listbox = GUICtrlCreateList("", 50, 40, 180, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $LBS_MULTIPLESEL))
GUICtrlSetData($listbox, "test1|more testing|even more testing|demo|")

$s_rect = "Left:" & @LF & "Top:" & @LF & "Right:" & @LF & "Bottom:"
$label_rect = GUICtrlCreateLabel($s_rect, 270, 40, 100, 55, $SS_SUNKEN)

$Btn_GETRECT = GUICtrlCreateButton("Get Item Rect", 270, 120, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 150, 180, 90, 30)

GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
      Case $msg = $Btn_GETRECT
         Local $rect_array = _GUICtrlListGetItemRect($listbox, 3)
         If (IsArray($rect_array)) Then
            $s_rect = "Left:" & $rect_array[1] & @LF & "Top:" & $rect_array[2] & @LF & "Right:" & $rect_array[3] & @LF & "Bottom:" & $rect_array[4]
            GUICtrlSetData($label_rect, $s_rect)
         EndIf
   EndSelect
WEnd
