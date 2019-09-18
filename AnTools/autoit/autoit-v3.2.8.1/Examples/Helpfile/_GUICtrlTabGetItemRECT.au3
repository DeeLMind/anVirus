#include <GUIConstants.au3>
#include <GuiTab.au3>

opt('MustDeclareVars', 1)

Dim $tab, $tab0, $tab0OK, $tab0input, $tab1, $tab1combo, $tab1OK, $tab2, $tab2OK, $tab3, $tab4
Dim $msg, $button, $label_rect, $s_rect

GUICreate("Tab Get Item RECT", 400, 200)  ; will create a dialog box that when displayed is centered

GUISetBkColor(0x00E0FFFF)
GUISetFont(9, 300)

$tab = GUICtrlCreateTab(10, 10, 200, 100, BitOR($TCS_FLATBUTTONS, $TCS_MULTILINE), $TCS_EX_FLATSEPARATORS)

$tab0 = GUICtrlCreateTabItem("tab0")
GUICtrlCreateLabel("label0", 30, 80, 50, 20)
$tab0OK = GUICtrlCreateButton("OK0", 20, 60, 50, 20)
$tab0input = GUICtrlCreateInput("default", 80, 60, 70, 20)
GUICtrlCreateTabItem("") ; end tabitem definition

$tab1 = GUICtrlCreateTabItem("tab----1")
GUICtrlCreateLabel("label1", 30, 80, 50, 20)
$tab1combo = GUICtrlCreateCombo("", 20, 60, 60, 40)
GUICtrlSetData(-1, "Trids|CyberSlug|Larry|Jon|Tylo", "Jon") ; default Jon
$tab1OK = GUICtrlCreateButton("OK1", 80, 60, 50, 20)
GUICtrlCreateTabItem("") ; end tabitem definition

$tab2 = GUICtrlCreateTabItem("tab2")
GUICtrlSetState(-1, $GUI_SHOW) ; will be display first
GUICtrlCreateLabel("label2", 30, 80, 50, 20)
$tab2OK = GUICtrlCreateButton("OK2", 140, 60, 50)
GUICtrlCreateTabItem("") ; end tabitem definition

$tab3 = GUICtrlCreateTabItem("tab3")
GUICtrlCreateTabItem("") ; end tabitem definition

$tab4 = GUICtrlCreateTabItem("tab4")
GUICtrlCreateTabItem("") ; end tabitem definition

GUICtrlCreateLabel("label3", 20, 130, 50, 20)
$button = GUICtrlCreateButton("Get RECT", 200, 130, 90, 30)

$s_rect = "Left:" & @LF & "Top:" & @LF & "Right:" & @LF & "Bottom:"
$label_rect = GUICtrlCreateLabel($s_rect, 250, 20, 100, 65, $SS_SUNKEN)

GUISetState()

; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			Local $rect_array = _GUICtrlTabGetItemRECT ($tab, 0)
			If (IsArray($rect_array)) Then
				$s_rect = "Left:" & $rect_array[1] & @LF & "Top:" & $rect_array[2] & @LF & "Right:" & $rect_array[3] & @LF & "Bottom:" & $rect_array[4]
				GUICtrlSetData($label_rect, $s_rect)
			EndIf
	EndSelect
WEnd

