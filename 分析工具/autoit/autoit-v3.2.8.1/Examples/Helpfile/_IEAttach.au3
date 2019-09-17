; *******************************************************
; Example 1 - Attach to a browser with "AutoIt" in its title, display the URL
; *******************************************************
;
#include <IE.au3>
$oIE = _IEAttach ("AutoIt")
MsgBox(0, "The URL", _IEPropertyGet ($oIE, "locationurl"))

; *******************************************************
; Example 2 - Attach to a browser with "The quick brown fox"
;				in the text of it's top-level document
; *******************************************************
;
#include <IE.au3>
$oIE = _IEAttach ("The quick brown fox", "text")

; *******************************************************
; Example 3 - ; Attach to a browser control embedded in another window
; *******************************************************
;
#include <IE.au3>
$oIE = _IEAttach ("A Window Title", "embedded")