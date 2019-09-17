; Double click at the current mouse pos
MouseClick("left")
MouseClick("left")

; Double click at 0,500
MouseClick("left", 0, 500, 2)


; SAFER VERSION of Double click at 0,500

Dim $primary
Dim $secondary
;Determine if user has swapped right and left mouse buttons
$k = RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "SwapMouseButtons")

; It's okay to NOT check the success of the RegRead operation
If $k = 1 Then
    $primary = "right"
    $secondary = "left"
Else ;normal (also case if could not read registry key)
    $primary = "left"
    $secondary = "right"
EndIf
MouseClick($primary, 0, 500, 2)
Exit
