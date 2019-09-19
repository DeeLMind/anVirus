VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CMiniToolBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com

Public app As Object
Public doc As Object
Public Collab As Object

Event RanEval(x)

Public Function GetStream(index)
      GetStream = Form1.parse.GetStream(index)
End Function

Public Function GetHeader(index)
    GetHeader = Form1.parse.GetHeader(index)
End Function

Function ExtractFromParanthesisPageEncapsulation(Data)
    ExtractFromParanthesisPageEncapsulation = Form1.parse.ExtractFromParanthesisPageEncapsulation(Data)
End Function

Public Function eval(x)
    RaiseEvent RanEval(x)
End Function

Public Function HexDump(str, Optional hexOnly = 0)
    On Error Resume Next
    HexDump = fso.HexDump(str, hexOnly)
End Function

Private Sub Class_Initialize()
    Set app = Me
    Set doc = Me
    Set Collab = Me
End Sub

