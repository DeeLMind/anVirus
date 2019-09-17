#include<Array.au3>
#include<File.au3>
Dim $a_Test
; Read file into array
_FileReadToArray("test.txt",$a_Test)
; reverse records
_ArrayReverse($a_Test,1)
; write reversed array to file
_FileWriteFromArray("test2.txt",$a_Test,1)