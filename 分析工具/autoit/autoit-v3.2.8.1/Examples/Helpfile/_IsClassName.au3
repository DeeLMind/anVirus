#include <Misc.au3>
Run("Notepad")
WinWaitActive("[CLASS:Notepad]")
$hWnd = WinGetHandle("[LAST]")
If _IsClassName($hWnd,"Notepad") Then
	Msgbox(0,"Classname","Active window is an Notepad classname")
EndIf
