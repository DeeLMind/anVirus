; Demonstrates StdoutRead()
#include <Constants.au3>

$foo = Run(@ComSpec & " /c dir foo.bar", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)

While 1
    $line = StdoutRead($foo)
    If @error Then ExitLoop
    MsgBox(0, "STDOUT read:", $line)
Wend

While 1
    $line = StderrRead($foo)
    If @error Then ExitLoop
    MsgBox(0, "STDERR read:", $line)
Wend

MsgBox(0, "Debug", "Exiting...")
