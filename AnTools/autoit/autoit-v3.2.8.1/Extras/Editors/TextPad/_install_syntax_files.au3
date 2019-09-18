;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Jonathan Bennett <jon at hiddensoft com>
;
; Script Function:
;	Syntax highlighting files installation.
;

; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(4, "TextPad v4", "This script will attempt to automatically install syntax highlighting and clip library files for TextPad v4.  Run?")
If $answer = 7 Then Exit

; Find an verify the installation directory
$installdir = @ProgramFilesDir & "\TextPad 4\"

; Check that the directory exists
If Not FileExists($installdir) Then Error()

If Not FileCopy("autoit_v3.syn", $installdir & "\system", 1) Then Error()
If Not FileCopy("autoit_v3.tcl", $installdir & "\samples", 1) Then Error()


; Now write the reg keys
RegWrite("HKEY_CURRENT_USER\Software\Helios\TextPad 4\Document Classes\AutoIt v3", "Type", "REG_DWORD", 2)
RegWrite("HKEY_CURRENT_USER\Software\Helios\TextPad 4\Document Classes\AutoIt v3", "Members", "REG_MULTI_SZ", "*.au3")
RegWrite("HKEY_CURRENT_USER\Software\Helios\TextPad 4\Document Classes\AutoIt v3", "Properties", "REG_BINARY", "2a002e0061007500330000000000")
RegWrite("HKEY_CURRENT_USER\Software\Helios\TextPad 4\Document Classes\AutoIt v3", "SyntaxProps", "REG_BINARY", "01000000")
RegWrite("HKEY_CURRENT_USER\Software\Helios\TextPad 4\Document Classes\AutoIt v3", "SyntaxFile", "REG_SZ", "autoit_v3.syn")
RegWrite("HKEY_CURRENT_USER\Software\Helios\TextPad 4\Document Classes\AutoIt v3", "WordChars", "REG_SZ", "_$")

$answer = MsgBox(4096+4, "TextPad v4", "Installation complete!" & @LF & @LF & "Do you want to make it the default editor for AutoItV3 scripts ?")
If $answer = 7 Then Exit
RegWrite("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Edit\Command", "", "REG_SZ", '"' & $installdir & 'TextPad.exe" "%1"')

; End of script


Func Error()
	MsgBox(4096, "Error", "Unable to find TextPad or error installing the syntax files.  Please try a manual installation.")
	Exit
EndFunc



