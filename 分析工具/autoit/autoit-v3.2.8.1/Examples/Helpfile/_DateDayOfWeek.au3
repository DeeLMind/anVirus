#include <Date.au3>

; Retrieve the long name
$sLongDayName = _DateDayOfWeek( @WDAY )

; Retrieve the abbreviated name
$sShortDayName = _DateDayOfWeek( @WDAY, 1 )

MsgBox( 4096, "Day of Week", "Today is: " & $sLongDayName & " (" & $sShortDayName & ")" )
