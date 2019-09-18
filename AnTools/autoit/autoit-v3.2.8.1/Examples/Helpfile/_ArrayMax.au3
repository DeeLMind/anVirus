#include <Array.au3>
;
$avArray = StringSplit("4,2,06,8,12,5",",")
;
MsgBox(0,'Max Index String value',_ArrayMaxIndex( $avArray, 0, 1))
MsgBox(0,'Max Index Numeric value',_ArrayMaxIndex( $avArray, 1, 1))
;
MsgBox(0,'Max String value',_ArrayMax( $avArray, 0, 1))
MsgBox(0,'Max Numeric value',_ArrayMax( $avArray, 1, 1))
;
MsgBox(0,'Min Index String value',_ArrayMinIndex( $avArray , 0, 1))
MsgBox(0,'Min Index Numeric value',_ArrayMinIndex( $avArray, 1, 1))
;
MsgBox(0,'Min String value',_ArrayMin( $avArray, 0, 1))
MsgBox(0,'Min Numeric value',_ArrayMin( $avArray, 1, 0))

Exit
