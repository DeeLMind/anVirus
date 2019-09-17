#include <GUIConstants.au3>

GUICreate("listview items",220,250, 100,200,-1,$WS_EX_ACCEPTFILES)
GUISetBkColor (0x00E0FFFF)  ; will change background color

$listview = GuiCtrlCreateListView ("col1  |col2|col3  ",10,10,200,150);,$LVS_SORTDESCENDING)
$button = GuiCtrlCreateButton ("Value?",75,170,70,20)
$item1=GuiCtrlCreateListViewItem("item2|col22|col23",$listview)
$item2=GuiCtrlCreateListViewItem("............item1|col12|col13",$listview)
$item3=GuiCtrlCreateListViewItem("item3|col32|col33",$listview)
$input1=GuiCtrlCreateInput("",20,200, 150)
GuiCtrlSetState(-1,$GUI_DROPACCEPTED)   ; to allow drag and dropping
GuiSetState()
GUICtrlSetData($item2,"|ITEM1")
GUICtrlSetData($item3,"||COL33")
GUICtrlDelete($item1)

Do
  $msg = GuiGetMsg ()
 	 
   Select
      Case $msg = $button
         MsgBox(0,"listview item",GUICtrlRead(GUICtrlRead($listview)),2)
      Case $msg = $listview
         MsgBox(0,"listview", "clicked="& GuiCtrlGetState($listview),2)
   EndSelect
Until $msg = $GUI_EVENT_CLOSE