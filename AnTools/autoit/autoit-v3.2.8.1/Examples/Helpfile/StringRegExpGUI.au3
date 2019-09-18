#include <GuiConstants.au3>
opt("RunErrorsFatal", 0)
Dim $initialDir = "C:\"
Global $s_Pattern = "(.*)"
Readini()
GUICreate("StringRegExp Original Design GUI -by w0uter, modified Steve8tch", 550, 570, (@DesktopWidth - 550) / 2, (@DesktopHeight - 570) / 2)
GUICtrlCreateGroup("The pattern   -  $ptn", 10, 210, 530, 60)
GUICtrlCreateGroup("Output", 140, 280, 400, 280)
GUICtrlCreateGroup("Return", 10, 280, 120, 100)
GUICtrlCreateGroup("@Error   @Extended", 10, 390, 120, 50)
GUICtrlCreateGroup("StringRegExp Help", 10, 450, 120, 50)
$h_Radio_0 = GUICtrlCreateRadio("True/False", 20, 300, 100, 20)
$h_Radio_1 = GUICtrlCreateRadio("Array with the text", 20, 321, 100, 27)
$h_Radio_3 = GUICtrlCreateRadio("Array of all results", 20, 350, 100, 20)
GUICtrlSetState($h_Radio_3, $GUI_CHECKED)
$h_Indummy = GUICtrlCreateEdit("", 1020, 1040, 510, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
$h_tab = GUICtrlCreateTab(10, 10, 530, 190)
$h_tabitem1 = GUICtrlCreateTabItem("Copy and Paste the text to check - $str")
$h_In1 = GUICtrlCreateEdit("", 20, 40, 510, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))

$h_tabitem2 = GUICtrlCreateTabItem("Load text from File")
$h_Brwse = GUICtrlCreateButton("Browse for file", 20, 40, 100, 20)
$h_fileIn = GUICtrlCreateEdit("", 130, 40, 400, 20, BitOR($ES_WANTRETURN, $WS_HSCROLL, $ES_AUTOHSCROLL))
$h_In2 = GUICtrlCreateEdit("", 20, 70, 510, 120, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))

GUICtrlCreateTabItem("");
$h_Out = GUICtrlCreateEdit("", 150, 296, 380, 262, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
$h_Pattern = GUICtrlCreateCombo("", 70, 230, 430, 30)
GUICtrlSetFont($h_Pattern, 14)
GUICtrlSetData($h_Pattern, $s_Pattern, "(.*)")
$h_Pattern_add = GUICtrlCreateButton("Add", 504, 225, 30, 18)
$h_Pattern_del = GUICtrlCreateButton("Del", 504, 245, 30, 18)
$h_test = GUICtrlCreateButton("Test", 20, 235, 40, 20)
$h_Err = GUICtrlCreateInput("", 20, 410, 40, 20, $ES_READONLY)
$h_Ext = GUICtrlCreateInput("", 70, 410, 50, 20, $ES_READONLY)
$h_Help = GUICtrlCreateButton("HELP", 20, 468, 100, 24)
$h_Exit = GUICtrlCreateButton("Exit", 10, 510, 120, 50)
$v_Reg_Old = 0
Global $h_In = $h_In1
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $h_test
			_Valid()
		Case $msg = $h_Exit
			Exit
		Case $msg = $h_Brwse
			$filepath = FileOpenDialog("Select text file to test", $initialDir, "Text files (*.*)", 1)
			$initialDir = StringTrimRight($filepath, StringInStr($filepath, "\", "-1"))
			GUICtrlSetData($h_fileIn, $filepath)
			WaitMessage("Loading file..")
			$str2 = FileRead($filepath)
			WaitMessage("File loaded.." & @CRLF & "updating display")
			GUICtrlSetData($h_In2, $str2)
			WaitMessageOff()
		Case $msg = $h_tab
			If GUICtrlRead($h_tab) = 0 Then
				$h_In = $h_In1
			Else
				$h_In = $h_In2
			EndIf
		Case $msg = $h_Pattern_add
			Pattern_Add()
			
		Case $msg = $h_Pattern_del
			Pattern_del()
			
		Case $msg = $h_Help
			$helppath = StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", 0, -1))
			Run($helppath & "Autoit3Help.exe StringRegExp")
			If @error = 1 Then MsgBox(0, "error", "Cannot fing help file - sorry")
		Case Else
			;;
	EndSelect
WEnd

Func _Valid()
	WaitMessage("Performing test..")
	$v_Reg = StringRegExp(GUICtrlRead($h_In), GUICtrlRead($h_Pattern), _Option())
	Dim $v_EE[2] = [@error, @extended]
	If $v_EE[0] = 2 Then
		GUICtrlSetColor($h_Pattern, 0xFF0000)
		GUICtrlSetData($h_Err, $v_EE[0])
		GUICtrlSetData($h_Out, "")
	Else
		GUICtrlSetColor($h_Pattern, 0)
		GUICtrlSetData($h_Err, $v_EE[0])
	EndIf
	GUICtrlSetData($h_Ext, $v_EE[1])
	WaitMessage("Test complete.." & @CRLF & "updating display")
	If $v_EE[0] <> 2 Then
		$v_Check = 0
		If UBound($v_Reg) <> UBound($v_Reg_Old) Then
			$v_Check = 1
		Else
			For $i = 0 To UBound($v_Reg) - 1
				If $v_Reg[$i] <> $v_Reg_Old[$i] Then $v_Check = 1
			Next
		EndIf
		If $v_Check = 1 Then
			GUICtrlSetData($h_Out, "")
			$h_output = ""
			$x = UBound($v_Reg)
			If $x < 10 Then
				$s_lgth = 1
			ElseIf $x < 100 Then
				$s_lgth = 2
			ElseIf $x < 1000 Then
				$s_lgth = 3
			ElseIf $x < 10000 Then
				$s_lgth = 4
			ElseIf $x < 10000 Then
				$s_lgth = 5
			Else
				$s_lgth = 6
			EndIf
			If UBound($v_Reg) Then
				For $i = 0 To UBound($v_Reg) - 1
					$h_output &= StringFormat("%0" & $s_lgth & "i", $i) & ' => ' & $v_Reg[$i] & @CRLF
				Next
				GUICtrlSetData($h_Out, $h_output)
			Else
				GUICtrlSetData($h_Out, $v_Reg)
			EndIf
		EndIf
	EndIf
	WaitMessageOff()
	$v_Reg_Old = $v_Reg
	StringRegExp('', Random(0x80000000, 0x7FFFFFFF), 1)
EndFunc   ;==>_Valid
Func _Option()
	Switch $GUI_CHECKED
		Case GUICtrlRead($h_Radio_0)
			Return 0
		Case GUICtrlRead($h_Radio_1)
			Return 1
		Case GUICtrlRead($h_Radio_3)
			Return 3
	EndSwitch
EndFunc   ;==>_Option
Func Readini()
	If FileExists(@ScriptDir & "\StringRegExpGUIPattern.ini") = 0 Then
		$h_x = FileOpen(@ScriptDir & "\StringRegExpGUIPattern.ini", 1)
		FileWriteLine($h_x, "[do not delete the file - Patterns are listed below]")
		FileWriteLine($h_x, "(.*)##~##")
		FileClose($h_x)
	Else
		$s_Pattern = FileRead(@ScriptDir & "\StringRegExpGUIPattern.ini")
		$s_Pattern = StringTrimLeft($s_Pattern, StringInStr($s_Pattern, @CRLF) + 1)
		$s_Pattern = StringReplace($s_Pattern, "##~##" & @CRLF, "|")
	EndIf
EndFunc   ;==>Readini
Func Pattern_del()
	$s_ini = FileRead(@ScriptDir & "\StringRegExpGUIPattern.ini")
	$h_x = FileOpen(@ScriptDir & "\StringRegExpGUIPattern.ini", 2)
	If GUICtrlRead($h_Pattern) = "" Then
		$s_ini = StringReplace($s_ini, "##~##" & @CRLF & "##~##", "##~##")
		$s_ini = StringReplace($s_ini, @CRLF & @CRLF, @CRLF)
	Else
		$s_ini = StringReplace($s_ini, GUICtrlRead($h_Pattern) & "##~##", "")
		$s_ini = StringReplace($s_ini, @CRLF & @CRLF, @CRLF)
	EndIf
	FileWrite($h_x, $s_ini)
	FileClose($h_x)
	Readini()
	GUICtrlSetData($h_Pattern, "|" & $s_Pattern, "(.*)")
EndFunc   ;==>Pattern_del
Func Pattern_Add()
	$h_x = FileOpen(@ScriptDir & "\StringRegExpGUIPattern.ini", 1)
	FileWriteLine($h_x, GUICtrlRead($h_Pattern) & "##~##")
	FileClose($h_x)
	Readini()
	GUICtrlSetData($h_Pattern, "|" & $s_Pattern, GUICtrlRead($h_Pattern))
EndFunc   ;==>Pattern_Add
Func WaitMessage($s_txt)
	$a_pos = WinGetPos("StringRegExp Original Design GUI -by w0uter, modified Steve8tch")
	SplashTextOn("Please wait", $s_txt, 120, 40, $a_pos[0] + 215, $a_pos[1] + 200)
	
EndFunc   ;==>WaitMessage
Func WaitMessageOff()
	SplashOff()
EndFunc   ;==>WaitMessageOff