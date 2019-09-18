#include <GUIConstants.au3>
#include <GuiEdit.au3>

opt('MustDeclareVars', 1)

Dim $myedit, $msg, $Btn_Scrollv, $Btn_Scrollh

GUICreate("Edit Line Scroll", 392, 254)

$myedit = GUICtrlCreateEdit("AutoIt v3 is a freeware BASIC-like scripting language designed for automating the Windows GUI." & @CRLF, 140, 32, 121, 97, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE, $WS_HSCROLL))
GUICtrlSetLimit($myedit, 1500)
$Btn_Scrollh = GUICtrlCreateButton("Scroll Horiz", 75, 140, 90, 30)
$Btn_Scrollv = GUICtrlCreateButton("Scroll Vert", 190, 140, 90, 30)

; will be append dont' forget 3rd parameter
GUICtrlSetData($myedit, "It uses a combination of simulated keystrokes, mouse movement and window/control manipulation" & @CRLF & _
      "in order to automate tasks in a way not possible or reliable with other languages (e.g. VBScript" & @CRLF & _ 
      "and SendKeys)." & @CRLF & _ 
      'AutoIt was initially designed for PC "roll out" situations to configure thousands of PCs, but with the' & @CRLF & _ 
      "arrival of v3 it is also well suited to performing home automation and the scripting of repetitive" & @CRLF & _ 
      "tasks." & @CRLF & @CRLF & "AutoIt can:" & @CRLF & @CRLF & "Execute Windows and DOS executables", 1)

GUISetState()

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $Btn_Scrollv
         _GUICtrlEditLineScroll ($myedit, 0, 1)
      Case $msg = $Btn_Scrollh
         _GUICtrlEditLineScroll ($myedit, 10, 0)
   EndSelect
WEnd
