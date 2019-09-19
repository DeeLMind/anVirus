VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form Form1 
   Caption         =   "PDF Object Browser"
   ClientHeight    =   5025
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   12675
   LinkTopic       =   "Form1"
   ScaleHeight     =   5025
   ScaleWidth      =   12675
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtData 
      Height          =   2670
      Left            =   4050
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   1800
      Width           =   8430
   End
   Begin VB.TextBox Text1 
      Height          =   1635
      Left            =   4050
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Top             =   135
      Width           =   8430
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Copy Data"
      Height          =   240
      Left            =   11475
      TabIndex        =   5
      Top             =   4680
      Width           =   1050
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Load Another File"
      Height          =   240
      Left            =   9585
      TabIndex        =   6
      Top             =   4680
      Width           =   1725
   End
   Begin VB.ListBox List1 
      Height          =   4350
      Left            =   4050
      TabIndex        =   0
      Top             =   135
      Width           =   8430
   End
   Begin MSComctlLib.TabStrip TabStrip1 
      Height          =   4875
      Left            =   3960
      TabIndex        =   7
      Top             =   45
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   8599
      Placement       =   1
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   2
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Data"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Debug Info"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lv2 
      Height          =   1185
      Left            =   450
      TabIndex        =   1
      Top             =   3330
      Visible         =   0   'False
      Width           =   1545
      _ExtentX        =   2725
      _ExtentY        =   2090
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   4
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Key             =   "Type"
         Text            =   "Type"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Key             =   "Name"
         Text            =   "Name"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   2
         Text            =   "Index"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   3
         Key             =   "Value"
         Text            =   "Data"
         Object.Width           =   2540
      EndProperty
   End
   Begin MSComctlLib.TreeView tv 
      Height          =   4830
      Left            =   180
      TabIndex        =   3
      Top             =   45
      Width           =   3660
      _ExtentX        =   6456
      _ExtentY        =   8520
      _Version        =   393217
      HideSelection   =   0   'False
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   6
      FullRowSelect   =   -1  'True
      Appearance      =   1
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuCopyLine 
         Caption         =   "Copy Line"
      End
      Begin VB.Menu mnuCopyTable 
         Caption         =   "Copy Table"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public frmMain As Object
Dim selLi As ListItem
Dim WithEvents tb As CMiniToolBox
Attribute tb.VB_VarHelpID = -1
'Function FolderDialog(Optional initDir As String, Optional pHwnd As Long = 0) As String
'p = frmMain.dlg.FolderDialog()

'Function OpenDialog(filt As FilterTypes, Optional initDir As String, Optional title As String, Optional pHwnd As Long = 0) As String
'f = frmMain.dlg.OpenDialog(4)


'note to self: this code is a pure pile of shit but i am jimmy crack corn

Public objects As New Collection
Public pages As New Collection
Public parse As New CParseHeaders

Private Sub Command2_Click()
    On Error Resume Next
    f = frmMain.dlg.OpenDialog(4)
    If Len(f) = 0 Then Exit Sub
    LoadFile f
    Form_Load
End Sub

Function LoadFile(fpath)
    On Error Resume Next
    List1.AddItem "Processing sample: " & fpath
    frmMain.txtPdfPath = fpath
    frmMain.cmdDecode_click
    While frmMain.Status = 1
        DoEvents
        Sleep 20
    Wend
End Function

Private Sub sc_Error()
    List1.AddItem "Script control error: " & sc.Error.Description & " Line: " & sc.Error.Line
End Sub



Private Sub Command1_Click()
    Clipboard.Clear
    Clipboard.SetText txtData.Text
    MsgBox Len(txtData.Text) & " characters copied to clipboard"
End Sub


Private Sub lv_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    Dim o As CNamedObject
    Set o = Item.Tag
    txtData = o.Data
    Text1 = o.Report
    Set selLi = Item
End Sub

Private Sub lv_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuPopup
End Sub

Private Sub mnuCopyLine_Click()
    On Error Resume Next
    If selLi Is Nothing Then Exit Sub
    r = lv.ColumnHeaders(1) & ": " & selLi.Text & vbCrLf
    For i = 2 To lv.ColumnHeaders.Count
        r = r & lv.ColumnHeaders(i) & ": " & selLi.SubItems(i) & vbCrLf
    Next
    Clipboard.Clear
    Clipboard.SetText r
    MsgBox Len(r) & " characters copied", vbInformation
End Sub

Private Sub mnuCopyTable_Click()
    
    On Error Resume Next
    Dim li As ListItem
    
    For Each li In lv.ListItems
        r = r & lv.ColumnHeaders(1) & ": " & li.Text & vbCrLf
        For i = 2 To lv.ColumnHeaders.Count
            r = r & lv.ColumnHeaders(i) & ": " & li.SubItems(i) & vbCrLf
        Next
        r = r & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText r
    MsgBox Len(r) & " characters copied", vbInformation
    
End Sub

Private Sub TabStrip1_Click()
    
    On Error Resume Next
    If TabStrip1.Tabs(2).Selected Then
        txtData.Visible = False
        Text1.Visible = False
        List1.Visible = True
    Else
        txtData.Visible = True
        Text1.Visible = True
        List1.Visible = False
    End If
    
End Sub

Private Sub tb_RanEval(x As Variant)
    List1.AddItem "Eval ran: " & x
    waitForEval = False
End Sub

Public Sub Form_Load()

    On Error Resume Next
    
    Set tb = New CMiniToolBox
    Dim s As Object
    Dim li As ListItem
    Dim o As CNamedObject
    Dim i As Long
    
    TabStrip1.Tabs(1).Selected = True
    Set pages = New Collection
    Set objects = New Collection
    tv.Nodes.Clear
    lv.ListItems.Clear
    List1.Clear
    Text1 = Empty
    txtData = Empty
    
    List1.AddItem "Current PDF has " & frmMain.lv.ListItems.Count & " objects"
    For Each li In frmMain.lv.ListItems
        Set s = li.Tag
        h = s.escapedheader
        If AnyofTheseInstr(h, "/Creator,/Author,/CreationDate") Then
            List1.AddItem "Parsing Info for stream: " & s.index
            ParseInfo h
            If Err.Number <> 0 Then List1.AddItem "Had error: " & Err.Description
            Err.Clear
        End If
        
        If InStr(1, h, "/Names", vbTextCompare) > 0 Then
            List1.AddItem "Parsing Names from stream: " & s.index
            ParseNames h
            If Err.Number <> 0 Then List1.AddItem "Had error: " & Err.Description
            Err.Clear
        End If
        
        If InStr(1, h, "/Type", vbTextCompare) > 0 And _
            ( _
              InStr(1, h, "/Page ", vbTextCompare) > 0 Or InStr(1, h, "/Page ", vbTextCompare) > 0 Or _
              InStr(1, h, "/Page" & vbCrLf, vbTextCompare) > 0 Or InStr(1, h, "/Page" & vbTab, vbTextCompare) > 0 Or _
              InStr(1, h, "/Page>", vbTextCompare) > 0 _
             ) _
        Then
            
            Set o = New CNamedObject
            o.index = s.index
            List1.AddItem "Found a new Page in obj index " & o.index
            o.DataType = dtPage
            o.Name = "Page " & pages.Count
            o.header = h
            ParseContents o, h
            ParseAnnots o, h
            pages.Add o
        End If
        
    Next
    
    Dim pc As Long 'pageContents
    For Each o In pages
        i = i + o.SubItems.Count
        If Len(o.Data) > 0 Then pc = pc + 1
    Next
    
    List1.AddItem "Parsing complete Pages: " & pages.Count & " PageContents: " & pc & " Annots: " & i & " Names: " & objects.Count
    
    Dim n As Node
    Dim nn As Node
    Dim oo As CNamedObject
    
    If pages.Count = 0 Then
        tv.Nodes.Add , , , "<< No Pages Found >>"
    Else
        For Each o In pages
            a = 0
            Set n = tv.Nodes.Add(, , , o.Name)
            Set n.Tag = o
            For Each oo In o.SubItems
                sName = oo.TypeToString() & " " & IIf(oo.DataType = dtAnnot, a, "")
                Set nn = tv.Nodes.Add(n, tvwChild, , sName)
                Set nn.Tag = oo
                If oo.DataType = dtAnnot Then a = a + 1
            Next
        Next
    End If
    
    If objects.Count = 0 Then
        tv.Nodes.Add , , , "<< No Info or Name Objects Found >>"
    Else
        Set n = Nothing
        For Each o In objects
            If o.DataType = dtInfo Then
                Set n = tv.Nodes.Add(, , , "Info Object")
                Exit For
            End If
        Next
        
        If Not n Is Nothing Then
            For Each o In objects
                If o.DataType = dtInfo Then
                    Set nn = tv.Nodes.Add(n, tvwChild, , o.Name)
                    Set nn.Tag = o
                End If
            Next
        End If
        
        Set n = Nothing
        For Each o In objects
            If o.DataType = dtName Then
                Set n = tv.Nodes.Add(, , , "Named Objects")
                Exit For
            End If
        Next
        
        If Not n Is Nothing Then
            For Each o In objects
                If o.DataType = dtName Then
                    Set nn = tv.Nodes.Add(n, tvwChild, , o.Name)
                    Set nn.Tag = o
                End If
            Next
        End If
    End If
        
    For Each n In tv.Nodes
        n.Expanded = True
    Next
       
End Sub

Sub ParseContents(o As CNamedObject, ByVal h)
'<<
'    /Type /Page
'    /Parent 1 0 R
'    /Resources 2 0 R
'    /Contents 4 0 R
'>>
    Const m = "contents"
    Dim oo As CNamedObject
    
    h = Replace(h, "0 R", Empty)
    tmp = Split(LCase(h), "/")
    For Each x In tmp
        If VBA.Left(x, Len(m)) = m Then
            Set oo = New CNamedObject
            oo.DataType = dtContents
            x = Mid(x, Len(m) + 1)
            x = parse.ParseInt(Trim(x))
            List1.AddItem "Found Contents marker for page contents stream is: " & x
            If x > 0 Then
                oo.index = x
                oo.Data = parse.GetStream(x)
                oo.Data = parse.ExtractFromParanthesisPageEncapsulation(oo.Data)
                If Len(oo.Data) = 0 Then oo.Data = parse.GetStream(x)
                oo.header = parse.GetHeader(x)
            End If
            o.SubItems.Add oo
            Exit Sub
        End If
    Next
            
        
End Sub

Sub ParseAnnots(o As CNamedObject, ByVal h)

    On Error Resume Next
    '<<
    '    /Type/Page /Annots[ 5 0 R ]/Parent 3 0 R/MediaBox [0 0 612 792]
    '>>
    '
    'Stream 5:
    '<<
    '    /Type/Annot /Subtype /Text /Name /Comment/Rect[25 100 60 115] /Subj 8 0 R
    '>>
    
    
    '------------------------------
    'variant 2
   '
   ' <<
   '      /Type /Page /MediaBox [ 0 0 612 792 ] /Annots [ 6 0 R 8 0 R ] /Parent 2 0 R
   ' >>
   '
   '
   ' Stream 6
   '
   ' <<
   '      /Type /Annot /Subtype /Text /Name /Comment /Rect [ 200 250 300 320 ] /Subj 7 0 R
   ' >>
   '
   ' Stream 8
   '
   ' <<
   '      /Type /Annot /Subtype /Text /Name /Comment /Rect [100 180 300 210 ] /Subj 9 0 R
   ' >>

    a1 = InStr(1, h, "/Annots", vbTextCompare)
    If a1 < 1 Then Exit Sub
    
    a1 = a1 + 1
    a = InStr(a1, h, "[")
    b = InStr(a1, h, "/")
    If b < a Then Exit Sub ' [ ] related to some other tag
    
    a = a + 1
    b = InStr(a, h, "]") - 1
    s = Mid(h, a, b - a) ' [ 6 0 R 8 0 R ] or [ 5 0 R ] etc..
    s = Trim(Replace(s, " 0 R", Empty)) '[6 8]
    
    Dim oo As CNamedObject
    
    tmp = Split(s, " ")
    List1.AddItem "Page should have " & UBound(tmp) + 1 & " annots"
    
    For Each x In tmp
        x = Trim(x)
        If Len(x) > 0 Then
            If IsNumeric(x) Then
                List1.AddItem "Adding Annot stream " & x
                Set oo = New CNamedObject
                oo.index = x
                GetAnnot oo
                o.SubItems.Add oo
            End If
        End If
    Next
    

End Sub

Sub GetAnnot(oo As CNamedObject)
    
    On Error Resume Next
    '<<
    '     /Type /Annot /Subtype /Text /Name /Comment /Rect [ 200 250 300 320 ] /Subj 7 0 R
    '>>
    h = tb.GetHeader(oo.index)
    oo.header = h
    If Len(h) = 0 Then Exit Sub
    
    If InStr(1, h, "/Type", vbTextCompare) > 0 And InStr(1, h, "/Annot", vbTextCompare) > 0 Then
        List1.AddItem "Looking in stream " & oo.index & " found /Type/Annot"
    Else
        Exit Sub
    End If
    
    i = parse.GetStreamIndexForTag(h, "Subj") 'can subjects be inline with () ?
    If i > 0 Then
        oo.Name = "Subject"
        oo.DataType = dtAnnot
        oo.index = i
        oo.Data = parse.GetStream(i)
    End If
    
End Sub



Sub ParseNames(ByVal x)
    On Error Resume Next
    '<<
    '     /Names [(fsdjkl) 31 0 R (rwelr) 33 0 R (fsdklu) 35 0 R (fsdf)]
    '>>
    'i would guess that  [ ] denotes an array of names so not always there
    
    Dim o As CNamedObject
    
    a = InStr(1, x, "/Names", vbTextCompare)
    If a < 1 Then Exit Sub
    
    b = InStr(x, "[") 'get data between [ ]
    If b > 0 Then
        b = b + 1
        c = InStr(b, x, "]")
        If c > 0 Then
            s = Mid(x, b, c - b)
        End If
    End If
    
    If Len(s) = 0 Then Exit Sub
    
    tmp = Split(s, "(")
    For Each a In tmp
        Set o = New CNamedObject
        o.header = x
        o.DataType = dtName
        b = InStrRev(a, ")")
        If b > 1 Then
            o.Name = Mid(a, 1, b - 1)
            remain = Trim(Mid(a, b + 1))
            b = InStr(remain, " ")
            If b > 0 Then
                remain = Trim(Mid(remain, 1, b))
                If IsNumeric(remain) Then
                    o.index = remain
                    ParseNameSubHeader o, o.index
                End If
            End If
            objects.Add o
        End If
    Next
    
End Sub

Sub ParseNameSubHeader(o As CNamedObject, index)
    
    On Error Resume Next
    d = tb.GetStream(index)
    If Len(d) > 0 Then
        o.Data = d
        Exit Sub
    End If
    
    o.Data = parse.GetInlineOrStreamDataForTagFromIndex(index, "JS")
    
'    d = tb.GetHeader(index)
'    If InStr(1, d, "/JS", vbTextCompare) > 0 Then
'        'o.Data = GetParenthesisDataForTag(d, "JS") 'is the data inline with () or as a stream..
'        b = parse.GetParenthesisDataForTag(d, "JS")
'        If Len(b) = 0 Then
'            i = parse.GetStreamIndexForTag(d, "JS")
'            If i > 0 Then
'                'o.Data = tb.GetStream(i)
'                b = parse.GetStream(i)
'            End If
'        End If
'    End If

End Sub





Sub ParseInfo(ByVal x1)
    
    Dim o As CNamedObject
    On Error Resume Next
    
    If InStr(x1, vbCrLf) Then
        x = Split(x1, vbCrLf)
    Else
        x = Split(x1, "/")    'this was just added, untested
        For i = 0 To UBound(x)
            x(i) = "/" & x(i)
        Next
    End If
            
    For Each y In x
        
        Set o = New CNamedObject
        o.DataType = dtInfo
        o.header = x1
        
        y = Trim(y)
        
        While VBA.Left(y, 1) = vbTab
            y = Mid(y, 2)
        Wend
        
        a = InStr(1, y, "/") 'its a name tag
        If a > 0 Then
            a = a + 1
            b = InStr(a, y, " ")
            o.Name = Trim(Mid(y, a, b - a))
            remain = Trim(Mid(y, b))
            If VBA.Left(remain, 1) = "(" Then 'is it a name value in ()
                o.Data = Mid(remain, 2)
                b = InStrRev(o.Data, ")")
                If b > 0 Then
                    o.Data = Mid(o.Data, 1, b - 1)
                End If
            Else 'is it a numeric stream index
                o.index = parse.GetStreamIndexForTag(x1, o.Name)
                'MsgBox o.index & " " & o.Name & " " & x1
                If o.index > 0 Then
                    o.Data = parse.GetStream(o.index)
                End If
                
                'b = InStr(remain, " ")
                'If b > 0 Then
                '    b = Mid(remain, 1, b)
                '    If IsNumeric(b) Then
                '        o.index = b
                '        o.Data = tb.GetStream(b)
                '    End If
                'End If
            End If
            objects.Add o
        End If
    
    Next

'<<
'    /Creator (Adobe)
'    /Title 995 0 R
'    /EYrf 51 0 R
'    /Author 914 0 R
'    /CreationDate (D:20090135621226)
'>>
End Sub

Private Sub tv_NodeClick(ByVal Node As MSComctlLib.Node)
    On Error Resume Next
    Dim o As CNamedObject
    Set o = Node.Tag
    Text1.Text = o.Report
    txtData.Text = o.Data
End Sub
