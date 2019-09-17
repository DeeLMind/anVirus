#include <String.au3>
$nAmount = 89996.31
$sDelimted = _StringAddComma($nAmount)
MsgBox(64, 'Info', $sDelimted)

$nAmt = '38849230'
$sDelim = _StringAddComma($nAmt)
MsgBox(64, 'Info', $sDelim)