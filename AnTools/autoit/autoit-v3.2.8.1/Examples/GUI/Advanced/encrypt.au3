;====================================================
;============= Encryption Tool With GUI ============= 
;====================================================
; AutoIt version: 3.0.103
; Language:       English
; Author:         "Wolvereness"
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------
#include <guiconstants.au3>
#include <string.au3>
;#include files for encryption and GUI constants
;~~
$WinMain = GuiCreate('Encryption tool', 400, 400)
; Creates window
;~~
$EditText = GuiCtrlCreateEdit('',5,5,380,350)
; Creates main edit
;~~
$InputPass = GuiCtrlCreateInput('',5,360,100,20, 0x21)
; Creates the password box with blured/centered input
;~~
$InputLevel = GuiCtrlCreateInput(1, 110, 360, 50, 20, 0x2001)
$UpDownLevel = GUICtrlSetLimit(GuiCtrlCreateUpDown($inputlevel),10,1)
; These two make the level input with the Up|Down ability
;~~
$EncryptButton = GuiCtrlCreateButton('Encrypt', 170, 360, 105, 35)
$DecryptButton = GuiCtrlCreateButton('Decrypt', 285, 360, 105, 35)
; Encryption/Decryption buttons
;~~
GUICtrlCreateLabel('Password', 5, 385)
GuiCtrlCreateLabel('Level',110,385)
; Simple text labels so you know what is what
;~~
GuiSetState()
; Shows window
;~~

Do
   $Msg = GuiGetMsg()
   If $msg = $EncryptButton Then
     ; When you press Encrypt
     ;~~
      GuiSetState(@SW_DISABLE,$WinMain)
     ; Stops you from changing anything
     ;~~
      $string = GuiCtrlRead($EditText)
     ; Saves the editbox for later
     ;~~
      GUICtrlSetData($EditText,'Please wait while the text is Encrypted/Decrypted.')
     ; Friendly message
     ;~~
      GuiCtrlSetData($EditText,_StringEncrypt(1,$string,GuiCtrlRead($InputPass),GuiCtrlRead($InputLevel)))
     ; Calls the encryption. Sets the data of editbox with the encrypted string
     ;~~
      GuiSetState(@SW_ENABLE,$WinMain)
     ; This turns the window back on
     ;~~
   EndIf
   If $msg = $DecryptButton Then
     ; When you press Decrypt
     ;~~
      GuiSetState(@SW_DISABLE,$WinMain)
     ; Stops you from changing anything
     ;~~
      $string = GuiCtrlRead($EditText)
     ; Saves the editbox for later
     ;~~
      GUICtrlSetData($EditText,'Please wait while the text is Encrypted/Decrypted.')
     ; Friendly message
     ;~~
      GuiCtrlSetData($EditText,_StringEncrypt(0,$string,GuiCtrlRead($InputPass),GuiCtrlRead($InputLevel)))
     ; Calls the encryption. Sets the data of editbox with the encrypted string
     ;~~
      GuiSetState(@SW_ENABLE,$WinMain)
     ; This turns the window back on
     ;~~
   EndIf
Until $msg = $GUI_EVENT_CLOSE; Continue loop untill window is closed