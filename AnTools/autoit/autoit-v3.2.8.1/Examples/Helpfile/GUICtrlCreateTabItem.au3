#include <GUIConstants.au3>
GUICreate("My GUI Tab",250,150); will create a dialog box that when displayed is centered

GUISetBkColor(0x00E0FFFF)
GUISetFont(9, 300)

$tab=GUICtrlCreateTab (10,10, 200,100)

$tab0=GUICtrlCreateTabitem ("tab0")
GUICtrlCreateLabel ("label0", 30,80,50,20)
$tab0OK=GUICtrlCreateButton ("OK0", 20,50,50,20)
$tab0input=GUICtrlCreateInput ("default", 80,50,70,20)

$tab1=GUICtrlCreateTabitem ( "tab----1")
GUICtrlCreateLabel ("label1", 30,80,50,20)
$tab1combo=GUICtrlCreateCombo ("", 20,50,60,120)
GUICtrlSetData(-1,"Trids|CyberSlug|Larry|Jon|Tylo", "Jon"); default Jon
$tab1OK=GUICtrlCreateButton ("OK1", 80,50,50,20)

$tab2=GUICtrlCreateTabitem ("tab2")
GUICtrlSetState(-1,$GUI_SHOW); will be display first
GUICtrlCreateLabel ("label2", 30,80,50,20)
$tab2OK=GUICtrlCreateButton ("OK2", 140,50,50)

GUICtrlCreateTabitem (""); end tabitem definition

GUICtrlCreateLabel ("Click on tab and see the title", 20,130,250,20)

GUISetState ()

; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg()

    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
    if $msg = $tab then
		; display the clicked tab
        if GUICtrlread ($tab) = 0 then WinSetTitle("My GUI Tab","","My GUI Tab0")
        if GUICtrlread ($tab) = 1 then WinSetTitle("My GUI Tab","","My GUI Tab1")
        if GUICtrlread ($tab) = 2 then WinSetTitle("My GUI Tab","","My GUI Tab2")
    EndIf
Wend
