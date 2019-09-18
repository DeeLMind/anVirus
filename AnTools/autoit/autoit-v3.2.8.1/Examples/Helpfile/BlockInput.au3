If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then
	BlockInput(1)
EndIf

Run("notepad")
WinWaitActive("Untitled - Notepad")
Send("{F5}")  ;pastes time and date

BlockInput(0)
