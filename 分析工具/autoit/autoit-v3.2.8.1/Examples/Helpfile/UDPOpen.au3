;CLIENT!!!!!!!! Start SERVER First... dummy!!
$g_IP = "127.0.0.1"

; Start The UDP Services
;==============================================
UDPStartUp()

; Connect to a Listening "SOCKET"
;==============================================
$socket = UDPOpen( $g_IP, 65432 )
If @error <> 0 Then Exit
