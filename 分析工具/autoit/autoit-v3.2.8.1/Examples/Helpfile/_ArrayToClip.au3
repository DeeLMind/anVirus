#include <Array.au3>
$asArray = StringSplit("a,b,c,d,e,f,g,h,i",",")
$iRetCode = _ArrayToClip( $asArray, 1 )
MsgBox( 4096, "_ArrayToClip() Test", ClipGet() )
Exit
