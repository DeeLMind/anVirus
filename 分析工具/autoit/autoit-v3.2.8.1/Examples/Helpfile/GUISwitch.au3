#include <GUIConstants.au3>

$parent1= GUICreate("Parent1")
GUICtrlCreateTab(10,10)
$tabitem = GUICtrlCreateTabItem("tab1")
GUICtrlCreateTabItem("tab2")
GUICtrlCreateTabItem("")

$parent2= GUICreate("Parent2", -1, -1, 100, 100)

GUISwitch($parent2)
GUISetState()
Do
$msg=GUIGetMsg()
until $msg = $GUI_EVENT_CLOSE
GuiSwitch($parent1,$tabitem)
GUICtrlCreateButton("OK",50,50,50)
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW,$parent1)
Do
$msg=GUIGetMsg()
until $msg = $GUI_EVENT_CLOSE
