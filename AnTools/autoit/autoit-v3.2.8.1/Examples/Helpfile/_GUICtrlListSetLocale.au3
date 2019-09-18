#include <GUIConstants.au3>
#include <GuiList.au3>

Opt('MustDeclareVars',1)

Dim $msg, $ret,$listbox,$button,$button2

GUICreate("ListBox Get Locale Demo",400,250,-1,-1)
$listbox = GUICtrlCreateList("",125,40,180,120)
GUICtrlSetData($listbox,"test1|more testing|even more testing|demo|test2|test3|test4|test5|test6|test7|test8|test9|test10")
$button = GUICtrlCreateButton('Set Locale English',85,160,120,40)
$button2 = GUICtrlCreateButton('Set Locale Spanish',210,160,120,40)

GUISetState ()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button
			$ret = _GUICtrlListSetLocale($listbox,"0409") ; U.S. English
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSetLocale")
			Else
				MsgBox(0,"Previous Locale",$ret)
			EndIf
		Case $msg = $button2
			$ret = _GUICtrlListSetLocale($listbox,"040a")	;Spanish_Traditional_Sort
			If($ret == $LB_ERR) Then
				MsgBox(16,"Error","Unknown error from _GUICtrlListSetLocale")
			Else
				MsgBox(0,"Previous Locale",$ret)
			EndIf
	EndSelect
Wend
