; AutoIt 3.0.103 example
; 17 Jan 2005 - CyberSlug
; This script shows manual positioning of all controls;
;   there are much better methods of positioning...
#include <GuiConstants.au3>

; GUI
GuiCreate("Sample GUI", 400, 400)
GuiSetIcon(@SystemDir & "\mspaint.exe", 0)


; MENU 
GuiCtrlCreateMenu("Menu&One")
GuiCtrlCreateMenu("Menu&Two")
GuiCtrlCreateMenu("MenuTh&ree")
GuiCtrlCreateMenu("Menu&Four")

; CONTEXT MENU
$contextMenu = GuiCtrlCreateContextMenu()
GuiCtrlCreateMenuItem("Context Menu", $contextMenu)
GuiCtrlCreateMenuItem("", $contextMenu) ;separator
GuiCtrlCreateMenuItem("&Properties", $contextMenu)

; PIC
GuiCtrlCreatePic("logo4.gif",0,0, 169,68)
GuiCtrlCreateLabel("Sample pic", 75, 1, 53, 15)
GuiCtrlSetColor(-1,0xffffff)


; AVI
GuiCtrlCreateAvi("sampleAVI.avi",0, 180, 10, 32, 32, $ACS_AUTOPLAY)
GuiCtrlCreateLabel("Sample avi", 170, 50)


; TAB
GuiCtrlCreateTab(240, 0, 150, 70)
GuiCtrlCreateTabItem("One")
GuiCtrlCreateLabel("Sample Tab with tabItems", 250, 40)
GuiCtrlCreateTabItem("Two")
GuiCtrlCreateTabItem("Three")
GuiCtrlCreateTabItem("")

; COMBO
GuiCtrlCreatecombo("Sample Combo", 250, 80, 120, 100)

; PROGRESS
GuiCtrlCreateProgress(60, 80, 150, 20)
GuiCtrlSetData(-1, 60)
GuiCtrlCreateLabel("Progress:", 5, 82)

; EDIT
GuiCtrlCreateEdit(@CRLF & "  Sample Edit Control", 10, 110, 150, 70)

; LIST
GuiCtrlCreateList("", 5, 190, 100, 90)
GuiCtrlSetData(-1, "a.Sample|b.List|c.Control|d.Here", "b.List")

; ICON
GuiCtrlCreateIcon("shell32.dll", 1, 175, 120)
GuiCtrlCreateLabel("Icon", 180, 160, 50, 20)

; LIST VIEW
$listView = GuiCtrlCreateListView("Sample|ListView|", 110, 190, 110, 80)
GuiCtrlCreateListViewItem("A|One", $listView)
GuiCtrlCreateListViewItem("B|Two", $listView)
GuiCtrlCreateListViewItem("C|Three", $listView)

; GROUP WITH RADIO BUTTONS
GuiCtrlCreateGroup("Sample Group", 230, 120)
GuiCtrlCreateRadio("Radio One", 250, 140, 80)
GuiCtrlSetState(-1, $GUI_CHECKED)
GuiCtrlCreateRadio("Radio Two", 250, 165, 80)
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

; UPDOWN
GuiCtrlCreateLabel("UpDown", 350, 115)
GuiCtrlCreateInput("42", 350, 130, 40, 20)
GuiCtrlCreateUpDown(-1)

; LABEL
GuiCtrlCreateLabel("Green" & @CRLF & "Label", 350, 165, 40, 40)
GuiCtrlSetBkColor(-1, 0x00FF00)

; SLIDER
GuiCtrlCreateLabel("Slider:", 235, 215)
GuiCtrlCreateSlider(270, 210, 120, 30)
GuiCtrlSetData(-1, 30)

; INPUT
GuiCtrlCreateInput("Sample Input Box", 235, 255, 130, 20)

; DATE
GuiCtrlCreateDate("", 5, 280, 200, 20)
GuiCtrlCreateLabel("(Date control expands into a calendar)", 10, 305, 200, 20)

; BUTTON
GuiCtrlCreateButton("Sample Button", 10, 330, 100, 30)

; CHECKBOX
GuiCtrlCreateCheckbox("Checkbox", 130, 335, 80, 20)
GuiCtrlSetState(-1, $GUI_CHECKED)

; TREEVIEW ONE
$treeOne = GuiCtrlCreateTreeView(210, 290, 80, 80)
$treeItem = GuiCtrlCreateTreeViewItem("TreeView", $treeOne)
GuiCtrlCreateTreeViewItem("Item1", $treeItem)
GuiCtrlCreateTreeViewItem("Item2", $treeItem)
GuiCtrlCreateTreeViewItem("Foo", -1)
GuiCtrlSetState($treeItem, $GUI_EXPAND)

; TREEVIEW TWO
$treeTwo = GuiCtrlCreateTreeView(295, 290, 103, 80, $TVS_CHECKBOXES)
GuiCtrlCreateTreeViewItem("TreeView", $treeTwo)
GuiCtrlCreateTreeViewItem("With", $treeTwo)
GuiCtrlCreateTreeViewItem("tvs_checkboxes", $treeTwo)
GuiCtrlSetState(-1, $GUI_CHECKED)
GuiCtrlCreateTreeViewItem("Style", $treeTwo)


; GUI MESSAGE LOOP
GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd