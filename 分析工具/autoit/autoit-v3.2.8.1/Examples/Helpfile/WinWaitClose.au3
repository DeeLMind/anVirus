;Wait for the window "Untitled" to not exist
WinWaitClose("Untitled")

;Wait a maximum of 5 seconds for "Untitled" to not exist
WinWaitClose("Untitled", "", 5)
