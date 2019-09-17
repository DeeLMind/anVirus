; This example will rerun itself with admin rights on using a local account
; Note on Vista this may not work as even though the user is admin it may 
; not be elevated even after the RunAs call.  In that case use #RequireAdmin
; at the top of the script.

; Are we already admin?
If Not IsAdmin() Then
	RunAsSet('USER', @Computername, 'PASSWORD')
	Run('"' & @AutoItExe & '"' & ' "' & @ScriptFullPath & '"', @WorkingDir)
	Exit
EndIf

MsgBox(0, 'Message', 'Now running with admin rights.')
