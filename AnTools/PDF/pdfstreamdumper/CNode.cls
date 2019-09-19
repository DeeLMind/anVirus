VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CNode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public label As String
Public id As String
Public connections As New Collection
Public shape As String
Public style As String
Public color As String
Public fontcolor As String


Public Sub ConnectTo(n As CNode)
    'If id = "node_3" And n.id = "node_4" Then Stop
    connections.Add n.id
End Sub

Friend Function getAttributes() As String
    Dim x As String
    x = vbTab & id & "[ "
    If Len(label) > 0 Then x = x & "label=""" & safe_label() & """ "
    If Len(shape) > 0 Then x = x & "shape=""" & shape & """ "
    If Len(style) > 0 Then x = x & "style=""" & style & """ "
    If Len(color) > 0 Then x = x & "color=""" & color & """ "
    If Len(fontcolor) > 0 Then x = x & "fontcolor=""" & fontcolor & """ "
    
    x = x & "];"
    getAttributes = x
End Function

Friend Function getConnections() As String
    Dim x As String, n
    
    If connections.count = 0 Then Exit Function
    
    For Each n In connections
        x = x & vbTab & id & " -> " & n & ";" & vbCrLf
    Next
    
    getConnections = Mid(x, 1, Len(x) - 2)
    
End Function

Private Function safe_label() As String
    Dim x As String
    x = Replace(label, vbCrLf, "\n")
    x = Replace(x, """", "\""")
    safe_label = x
End Function
