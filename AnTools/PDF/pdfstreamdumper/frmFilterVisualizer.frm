VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmFilterVisualizer 
   Caption         =   "Filter Visualizer"
   ClientHeight    =   3885
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3585
   LinkTopic       =   "Form3"
   ScaleHeight     =   3885
   ScaleWidth      =   3585
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.TreeView tv 
      Height          =   3795
      Left            =   30
      TabIndex        =   0
      Top             =   0
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   6694
      _Version        =   393217
      LabelEdit       =   1
      Style           =   7
      Appearance      =   1
   End
End
Attribute VB_Name = "frmFilterVisualizer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()

    Dim li As ListItem
    Dim n As Node
    Dim n2 As Node
    Dim n0 As Node
    Dim size As Long
    Dim Text As String
    
    Dim s As CPDFStream
    Dim filter As String
    
    Dim chains As New Collection
    Dim errors As New Collection
    
    On Error Resume Next
    
    Me.Icon = Form1.Icon
    FormPos Me, True, False
    
    Set n0 = tv.Nodes.Add(, , "top", "Filters")
    
    'first loop through and add all the unique, single filters...
    For Each li In Form1.lv.ListItems
        Set s = li.tag
        If s.ContainsStream Then
            If s.StreamDecompressor.GetActiveFiltersCount > 1 Then
                chains.Add li
            Else
                filter = s.StreamDecompressor.GetActiveFiltersAsString()
                
                If Len(filter) = 0 Then
                    filter = "None"
                    size = s.CompressedSize
                Else
                    size = s.DecompressedSize
                End If
                
                'text = IIf(s.ContentType <> Unknown, " - " & s.FileType, "")
                Text = " - " & s.FileType
                
                If size > 0 Then
                    If nodeExists(filter, n) Then
                        Set n2 = tv.Nodes.Add(n, tvwChild, , s.Index & Text & " - sz: 0x" & Hex(size))
                        Set n2.tag = li
                    Else
                        Set n = tv.Nodes.Add(n0, tvwChild, filter, filter)
                        Set n2 = tv.Nodes.Add(n, tvwChild, , s.Index & Text & " - sz: 0x" & Hex(size))
                        Set n2.tag = li
                    End If
                End If
                
            End If
        End If
    Next
            
    For Each li In Form1.lv2.ListItems
        Set s = li.tag
        If s.ContainsStream And s.StreamDecompressor.DecompressionError Then
             errors.Add li
        End If
    Next
    
    If errors.Count > 0 Then
        Set n = tv.Nodes.Add(n0, tvwChild, "Errors", "Errors")
        For Each li In errors
            Set s = li.tag
            Set n2 = tv.Nodes.Add(n, tvwChild, , s.Index & " - err: " & s.StreamDecompressor.DecompErrorMessage)
            Set n2.tag = li
        Next
        Set errors = Nothing
    End If
    
    If chains.Count > 0 Then
        Set n = tv.Nodes.Add(n0, tvwChild, "Chains", "Chains")
        For Each li In chains
            Set s = li.tag
            Set n2 = tv.Nodes.Add(n, tvwChild, , s.Index & " - " & s.StreamDecompressor.GetActiveFiltersAsString())
            Set n2.tag = li
        Next
        Set chains = Nothing
    End If
    
    For Each n In tv.Nodes
        n.Expanded = True
    Next

End Sub

Private Function AddItem(li As ListItem)

End Function
Private Function nodeExists(key, outNode As Node) As Boolean
    On Error Resume Next
    Dim n As Node
    
    For Each n In tv.Nodes
        If n.key = key Then
            Set outNode = n
            nodeExists = True
            Exit For
        End If
    Next
    
End Function

Private Sub Form_Resize()
    On Error Resume Next
    tv.Width = Me.Width - tv.Left - 150
    tv.Height = Me.Height - tv.Top - 150
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormPos Me, True, True
End Sub

Private Sub tv_NodeClick(ByVal Node As MSComctlLib.Node)
    On Error Resume Next
    Dim li As ListItem, liMain As ListItem
    
    Set li = Node.tag
    If li Is Nothing Then Exit Sub
    
    For Each liMain In Form1.lv.ListItems
        If li Is liMain Then
            DeselectAllOthers Form1.lv, liMain
            Form1.lv_ItemClick li
            Exit Sub
        End If
    Next
    
    For Each liMain In Form1.lv2.ListItems
        If li Is liMain Then
            DeselectAllOthers Form1.lv2, liMain
            Form1.lv2_ItemClick li
            Exit Sub
        End If
    Next
                
End Sub

Private Function DeselectAllOthers(lv As ListView, except As ListItem)
    Dim li As ListItem
    For Each li In lv.ListItems
        li.Selected = False
        If li Is except Then
            li.Selected = True
            li.EnsureVisible
        End If
    Next
End Function






