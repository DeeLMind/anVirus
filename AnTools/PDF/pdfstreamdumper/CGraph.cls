VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CGraph"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public nodes As New Collection 'of CNode
Public dot As New WINGRAPHVIZLib.dot
Public lastGraph As String

Public Function AddNode(Optional label As String) As CNode
    Dim n As New CNode
    n.id = "node_" & nodes.count
    n.label = IIf(Len(label) > 0, label, n.id)
    nodes.Add n, n.id
    Set AddNode = n
End Function

Public Function AddXNodes(count As Long) As Collection
    Dim c As New Collection
    For i = 0 To count
        c.Add AddNode()
    Next
    Set AddXNodes = c
End Function

'labels must be unique in this scenario..
Public Function NodeExists(label As String) As CNode
    Dim n As CNode
    For Each n In nodes
        If n.label = label Then
            Set NodeExists = n
            Exit Function
        End If
    Next
End Function


'accept either a node object, or node ID?
'Public Sub ConnectNodes(ParamArray children())'
'
'End Sub

Public Function GenerateGraph() As Boolean
    Dim n As CNode
    Dim x() As String
    
    push x, "digraph G {"
    
    For Each n In nodes
        push x, n.getAttributes
    
    Next
    
    For Each n In nodes
        push x, n.getConnections
    Next
    
    push x, "}"
    lastGraph = Join(x, vbCrLf)
    GenerateGraph = True
    
End Function



Private Sub push(ary, value, Optional noEmpties As Boolean = True)  'this modifies parent ary object
    On Error GoTo init
    If noEmpties And Len(value) = 0 Then Exit Sub
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init:     ReDim ary(0): ary(0) = value
End Sub

