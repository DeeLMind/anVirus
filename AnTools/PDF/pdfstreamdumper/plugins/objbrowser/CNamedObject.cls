VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CNamedObject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Enum DataTypes
    dtName = 0
    dtInfo = 1
    dtPage = 2
    dtAnnot = 3
    dtContents = 4
End Enum

Public Name As String
Public index As Long
Public Data As String
Public Configured As Boolean
Public DataType As DataTypes
Public SubItems As New Collection
Public header As String

Function Report()
    
    Dim r()
    push r, "Name: " & Name
    push r, "Index: " & index
    push r, "DataType: " & TypeToString()
    push r, "SubItems Count: " & SubItems.Count
    push r, "Header: " & header
    push r, "DataLen: " & Len(Data)
    
    Report = Join(r, vbCrLf)
    
End Function

Function TypeToString()
    
    Select Case DataType
        Case dtName: TypeToString = "Name"
        Case dtInfo: TypeToString = "Info"
        Case dtPage: TypeToString = "Page"
        Case dtAnnot: TypeToString = "Annot"
        Case dtContents: TypeToString = "Page Contents"
    End Select
        
End Function

Private Sub Class_Initialize()
    index = -1
End Sub

