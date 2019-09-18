#include <Process.au3>

Run("notepad.exe")
WinWaitActive("Untitled - Notepad", "")
$pid = WinGetProcess("Untitled - Notepad", "")
$name = _ProcessGetName($pid)

MsgBox(0, "Notepad - " & $pid, $name)