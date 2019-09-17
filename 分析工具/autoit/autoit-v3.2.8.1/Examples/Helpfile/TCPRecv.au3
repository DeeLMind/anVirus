;SERVER!! Start Me First !!!!!!!!!!!!!!!
#include <GUIConstants.au3>

; Set Some reusable info
; Set your Public IP address (@IPAddress1) here.
Dim $szIPADDRESS = @IPAddress1
Dim $nPORT = 33891


; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET".
;   Using your IP Address and Port 33891.
;==============================================
$MainSocket = TCPListen($szIPADDRESS, $nPORT)

; If the Socket creation fails, exit.
If $MainSocket = -1 Then Exit


; Create a GUI for messages
;==============================================
Dim $GOOEY = GUICreate("My Server (IP: " & $szIPADDRESS & ")",300,200)
Dim $edit = GUICtrlCreateEdit("",10,10,280,180)
GUISetState()


; Initialize a variable to represent a connection
;==============================================
Dim $ConnectedSocket = -1


;Wait for and Accept a connection
;==============================================
Do
    $ConnectedSocket = TCPAccept($MainSocket)
Until $ConnectedSocket <> -1


; Get IP of client connecting
Dim $szIP_Accepted = SocketToIP($ConnectedSocket)

Dim $msg, $recv
; GUI Message Loop
;==============================================
While 1
   $msg = GUIGetMsg()

; GUI Closed
;--------------------
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop

; Try to receive (up to) 2048 bytes
;----------------------------------------------------------------
    $recv = TCPRecv( $ConnectedSocket, 2048 )
    
; If the receive failed with @error then the socket has disconnected
;----------------------------------------------------------------
    If @error Then ExitLoop

; Update the edit control with what we have received
;----------------------------------------------------------------
    If $recv <> "" Then GUICtrlSetData($edit, _
            $szIP_Accepted & " > " & $recv & @CRLF & GUICtrlRead($edit))
WEnd


If $ConnectedSocket <> -1 Then TCPCloseSocket( $ConnectedSocket )

TCPShutDown()


; Function to return IP Address from a connected socket.
;----------------------------------------------------------------------
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc