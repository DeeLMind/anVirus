VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CApiHash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public hName As String
Public hConst As String
Public hSwapped As String
Public hRegular As String

Function SetLilEndian()
    On Error Resume Next
    Dim r(4) As String
    x = Me.hConst
    x = Replace(x, "0x", "")
    If Len(x) <> 8 Then
        'MsgBox "Invalid hash: " & x & " len " & Len(x) & " != 8"
        Exit Function
    End If
    r(0) = Mid(x, 7)
    r(1) = Mid(x, 5, 2)
    r(2) = Mid(x, 3, 2)
    r(3) = Mid(x, 1, 2)
    hSwapped = Join(r, Empty)
    
    hSwapped = UCase(hSwapped)
    hConst = UCase(hConst)
    hRegular = UCase(x)
    
End Function
