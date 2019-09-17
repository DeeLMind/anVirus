#include <Misc.au3>

$version1="3.2.3.7"
$version2="3.2.3.10"
If _CompareVersion($version1, $version2) < 0 Then
	Msgbox(0,"version1 < version2", $version1 & " " & $version2)
EndIf
