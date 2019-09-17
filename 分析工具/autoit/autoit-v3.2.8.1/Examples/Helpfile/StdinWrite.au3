; Demonstrates the use of StdinWrite()
#include <Constants.au3>

$foo = Run("sort.exe", @SystemDir, @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)
; Write string to be sorted to child sort.exe's STDIN
StdinWrite($foo, "rat" & @CRLF & "cat" & @CRLF & "bat" & @CRLF)
; Calling with no 2nd arg closes stream
StdinWrite($foo)

; Read from child's STDOUT and show
MsgBox(0, "Debug", StdoutRead($foo))
