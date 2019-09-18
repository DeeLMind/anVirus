#NoTrayIcon
Global Const $tagrect = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagrebarbandinfo = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" & ((@OSVersion = "WIN_XP") ? "" : ";" & $tagrect & ";uint uChevronState")

Func _versioncompare($sversion1, $sversion2)
	If $sversion1 = $sversion2 Then Return 0
	Local $ssubversion1 = "", $ssubversion2 = ""
	If StringIsAlpha(StringRight($sversion1, 1)) Then
		$ssubversion1 = StringRight($sversion1, 1)
		$sversion1 = StringTrimRight($sversion1, 1)
	EndIf
	If StringIsAlpha(StringRight($sversion2, 1)) Then
		$ssubversion2 = StringRight($sversion2, 1)
		$sversion2 = StringTrimRight($sversion2, 1)
	EndIf
	Local $aversion1 = StringSplit($sversion1, ".,"), $aversion2 = StringSplit($sversion2, ".,")
	Local $ipartdifference = ($aversion1[0] - $aversion2[0])
	If $ipartdifference < 0 Then
		ReDim $aversion1[UBound($aversion2)]
		$aversion1[0] = UBound($aversion1) - 1
		For $i = (UBound($aversion1) - Abs($ipartdifference)) To $aversion1[0]
			$aversion1[$i] = "0"
		Next
	ElseIf $ipartdifference > 0 Then
		ReDim $aversion2[UBound($aversion1)]
		$aversion2[0] = UBound($aversion2) - 1
		For $i = (UBound($aversion2) - Abs($ipartdifference)) To $aversion2[0]
			$aversion2[$i] = "0"
		Next
	EndIf
	For $i = 1 To $aversion1[0]
		If StringIsDigit($aversion1[$i]) AND StringIsDigit($aversion2[$i]) Then
			If Number($aversion1[$i]) > Number($aversion2[$i]) Then
				Return SetExtended(2, 1)
			ElseIf Number($aversion1[$i]) < Number($aversion2[$i]) Then
				Return SetExtended(2, -1)
			ElseIf $i = $aversion1[0] Then
				If $ssubversion1 > $ssubversion2 Then
					Return SetExtended(3, 1)
				ElseIf $ssubversion1 < $ssubversion2 Then
					Return SetExtended(3, -1)
				EndIf
			EndIf
		Else
			If $aversion1[$i] > $aversion2[$i] Then
				Return SetExtended(1, 1)
			ElseIf $aversion1[$i] < $aversion2[$i] Then
				Return SetExtended(1, -1)
			EndIf
		EndIf
	Next
	Return SetExtended(Abs($ipartdifference), 0)
EndFunc

Opt("MustDeclareVars", 1)
_easydrv7_getupdate__main()
Exit

Func _easydrv7_getupdate__main()
	If $cmdline[0] = 0 Then Exit
	Local $curver = "", $os = "", $drvtype = "", $language = ""
	Local $i
	If $cmdline[0] > 0 Then
		For $i = 1 To $cmdline[0]
			If $curver = "" AND StringRegExp($cmdline[$i], "(?i)^/curver:\d{1,2}\.\d{1,4}\.\d{1,4}\.\d{1,4}$") Then
				$curver = StringReplace($cmdline[$i], "/curver:", "")
			EndIf
			If $os = "" AND StringRegExp($cmdline[$i], "(?i)^/os:win.*\.(x86|x64)$") Then
				$os = StringReplace($cmdline[$i], "/os:", "")
			EndIf
			If $drvtype = "" AND StringRegExp($cmdline[$i], "(?i)^/drvtype:(Chipset|Video|Audio|Network|Camera).*$") Then
				$drvtype = StringReplace($cmdline[$i], "/drvtype:", "")
			EndIf
			If $language = "" AND StringRegExp($cmdline[$i], "(?i)^/lng:(chs|cht|eng)$") Then
				$language = StringReplace($cmdline[$i], "/lng:", "")
			EndIf
		Next
	EndIf
	If $curver = "" OR $os = "" Then Exit
	Local $weburl = "www.itsk.com"
	Local $verfile = @ScriptDir & "\~easydrv.update"
	Local $vefileurl = "http://" & $weburl & "/update/easydrv.version.txt"
	InetGet($vefileurl, $verfile, 1, 0)
	If NOT (@error) Then
		Local $ver = ""
		If FileExists($verfile) Then
			If $drvtype = "" Then
				$ver = IniRead($verfile, $os, "@", "")
			Else
				$ver = IniRead($verfile, $os, $drvtype, "")
				If $ver = "" Then $ver = IniRead($verfile, $os, "@", "")
			EndIf
			FileDelete($verfile)
		EndIf
		If $ver <> "" Then
			If _versioncompare($curver, $ver) < 0 Then
				Local $a_lng = _easydrv7_getupdate__language($language)
				Local $r = MsgBox(4 + 64 + 262144, $a_lng[1], $a_lng[2] & $curver & @CRLF & $a_lng[3] & $ver & @CRLF & @CRLF & $a_lng[4], 10)
				If $r = 6 Then
					Local $updateurl
					If $drvtype = "" Then
						$updateurl = "http://" & $weburl & "/redirect.php?id=easydrv&page=detail&index=1"
					Else
						$updateurl = "http://" & $weburl & "/redirect.php?id=easydrv&page=detail&index=2"
					EndIf
					Run(@ComSpec & " /c start " & StringReplace($updateurl, "&", "^&"), "", @SW_HIDE)
					Return 1
				EndIf
			EndIf
		EndIf
	EndIf
	Return 0
EndFunc

Func _easydrv7_getupdate__language($language)
	Local $a_lng[5]
	Switch $language
		Case "cht"
			$a_lng[1] = BinaryToString(Binary("0xE8B387E8A88A"), 4)
			$a_lng[2] = BinaryToString(Binary("0xE795B6E5898DE78988E69CACE782BAEFBC9A"), 4)
			$a_lng[3] = BinaryToString(Binary("0xE799BCE78FBEE696B0E78988E69CACEFBC9A"), 4)
			$a_lng[4] = BinaryToString(Binary("0xE99C80E8A681E69FA5E79C8BE69BB4E696B0E5978EEFBC9F"), 4)
		Case "eng"
			$a_lng[1] = "Infomation"
			$a_lng[2] = "The current version is: "
			$a_lng[3] = "Found a new version of: "
			$a_lng[4] = "Check for updates ?"
		Case Else
			$a_lng[1] = BinaryToString(Binary("0xE4BFA1E681AF"), 4)
			$a_lng[2] = BinaryToString(Binary("0xE5BD93E5898DE78988E69CACE4B8BAEFBC9A"), 4)
			$a_lng[3] = BinaryToString(Binary("0xE58F91E78EB0E696B0E78988E69CACEFBC9A"), 4)
			$a_lng[4] = BinaryToString(Binary("0xE99C80E8A681E69FA5E79C8BE69BB4E696B0E59097EFBC9F"), 4)
	EndSwitch
	Return $a_lng
EndFunc
