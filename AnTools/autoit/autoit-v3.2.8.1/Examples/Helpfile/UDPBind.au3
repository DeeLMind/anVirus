;SERVER!! Start Me First !!!!!!!!!!!!!!!
$g_IP = "127.0.0.1"

; Start The UDP Services
;==============================================
UDPStartUp()

; Create a Listening "SOCKET"
;==============================================
$socket = UDPBind($g_IP, 65432)
If @error <> 0 Then Exit

