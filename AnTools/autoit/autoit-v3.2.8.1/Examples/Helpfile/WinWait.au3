;Wait for the window "Untitled" to exist

Run("notepad")
WinWait("Untitled")

;Wait a maximum of 5 seconds for "Untitled" to exist
WinWait("Untitled", "", 5)
