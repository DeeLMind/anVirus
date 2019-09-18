#RequireAdmin
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Author:         Ejoc
;
; Script Function:
;	Toggle AutoIt beta.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#cs
vi:ts=4 sw=4:
DefaultAutoItToggle.au3
Ejoc
correction _(JPM)
#ce
Opt("MustDeclareVars",1)
Local $InstallDir = RegRead("HKLM\Software\AutoIt v3\AutoIt","InstallDir")
If $InstallDir = "" Then $InstallDir = RegRead("HKLM\Software\Wow6432Node\AutoIt v3\AutoIt","InstallDir")
If $InstallDir = "" Then
	MsgBox(0,'Error', 'Cannot find AutoIt Installation directory')
	Exit
EndIf

If StringInStr(RegRead("HKLM\Software\Classes\AutoIt3Script\Shell\Run\Command",""),"beta") Then; already using beta switch back
    RegWrite("HKLM\Software\Classes\AutoIt3Script\Shell\Compile\Command","", _
            "REG_SZ", _
            $InstallDir & '\Aut2Exe\Aut2Exe.exe /in "%l"')
    RegWrite("HKLM\Software\Classes\AutoIt3Script\Shell\Run\Command","", _
            "REG_SZ", _
            $InstallDir & '\AutoIt3.exe "%1" %*')
    RegWrite("HKLM\Software\Classes\AutoIt3Script\DefaultIcon","", _
            "REG_SZ", _
            $InstallDir & '\Icons\filetype1.ico')
    RegWrite("HKLM\Software\Classes\AutoIt3XScript\Shell\Run\Command","", _
            "REG_SZ", _
            $InstallDir & '\AutoIt3.exe "%1" %*')
    RegWrite("HKLM\Software\Classes\AutoIt3XScript\DefaultIcon","", _
            "REG_SZ", _
            $InstallDir & '\Icons\filetype3.ico')
; make sure that the right AutoItX.dll is installed
	RunWait('regsvr32 /s "' & $installDir & '\AutoItX\AutoItX3.dll"')
    MsgBox(0,"Using","Using Release " & FileGetVersion($InstallDir & '\AutoIt3.exe') & " Version of AutoIt",2)
Else; change to beta
    RegWrite("HKLM\Software\Classes\AutoIt3Script\Shell\Compile\Command","", _
            "REG_SZ", _
            $InstallDir & '\beta\Aut2Exe\Aut2Exe.exe /in "%l"')
    RegWrite("HKLM\Software\Classes\AutoIt3Script\Shell\Run\Command","", _
            "REG_SZ", _
            $InstallDir & '\beta\AutoIt3.exe "%1" %*')
    RegWrite("HKLM\Software\Classes\AutoIt3Script\DefaultIcon","", _
            "REG_SZ", _
            $InstallDir & '\beta\Icons\filetype1.ico')
    RegWrite("HKLM\Software\Classes\AutoIt3XScript\Shell\Run\Command","", _
            "REG_SZ", _
            $InstallDir & '\beta\AutoIt3.exe "%1" %*')
    RegWrite("HKLM\Software\Classes\AutoIt3XScript\DefaultIcon","", _
            "REG_SZ", _
            $InstallDir & '\beta\Icons\filetype3.ico')
; make sure that the right AutoItX.dll is installed
	RunWait('regsvr32 /s "' & $installDir & '\beta\AutoItX\AutoItX3.dll"')
    MsgBox(0,"Using","Using beta " & FileGetVersion($InstallDir & '\beta\AutoIt3.exe') & " Version of AutoIt",2)
EndIf