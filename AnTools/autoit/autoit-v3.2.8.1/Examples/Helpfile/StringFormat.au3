$String = "string"
$Float = 12.3
$Int = 345
$S =StringFormat ( "$String = %s" & @CRLF & "$Float = %.2f" & @CRLF & "$Int = %d" ,$String, $Float, $Int )

MsgBox(0, "Result", $S)

; Will output         "$String=string $Float=12.30 $Int=345"
; Notice the 12.30 done with the %.2f which force's 2 digits after the decimal point
