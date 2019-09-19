VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form Form2 
   Caption         =   "Bulk Hash Lookup"
   ClientHeight    =   7770
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9285
   LinkTopic       =   "Form2"
   ScaleHeight     =   7770
   ScaleWidth      =   9285
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command1 
      Caption         =   "Load Files Embedded in PDF"
      Height          =   405
      Left            =   3270
      TabIndex        =   7
      Top             =   60
      Width           =   2655
   End
   Begin VB.Timer tmrDelay 
      Enabled         =   0   'False
      Interval        =   17000
      Left            =   3360
      Top             =   630
   End
   Begin VB.CommandButton cmdAbort 
      Caption         =   "Abort"
      Height          =   405
      Left            =   7650
      TabIndex        =   6
      Top             =   60
      Width           =   1455
   End
   Begin MSComctlLib.ProgressBar pb 
      Height          =   285
      Left            =   60
      TabIndex        =   5
      Top             =   1740
      Width           =   9105
      _ExtentX        =   16060
      _ExtentY        =   503
      _Version        =   393216
      Appearance      =   1
   End
   Begin VB.CommandButton cmdQuery 
      Caption         =   "Begin Query"
      Height          =   405
      Left            =   6000
      TabIndex        =   4
      Top             =   60
      Width           =   1605
   End
   Begin VB.TextBox Text2 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3165
      Left            =   30
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   4530
      Width           =   9165
   End
   Begin VB.CommandButton cmdLoadHashs 
      Caption         =   "Load Hashs one per line from clipboard"
      Height          =   405
      Left            =   60
      TabIndex        =   2
      Top             =   60
      Width           =   3165
   End
   Begin MSComctlLib.ListView lv 
      Height          =   2445
      Left            =   30
      TabIndex        =   1
      Top             =   2040
      Width           =   9135
      _ExtentX        =   16113
      _ExtentY        =   4313
      View            =   3
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   0   'False
      HideSelection   =   0   'False
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   3
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "hash"
         Object.Width           =   7056
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "detections"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   2
         Text            =   "Description"
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1230
      Left            =   30
      TabIndex        =   0
      Top             =   510
      Width           =   9135
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuCopyTable 
         Caption         =   "Copy Table"
      End
      Begin VB.Menu mnuCopyResult 
         Caption         =   "Copy Result"
      End
      Begin VB.Menu mnuCopyAll 
         Caption         =   "Copy All Results"
      End
      Begin VB.Menu mnuDivider 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRemoveSelected 
         Caption         =   "Remove Selected"
      End
      Begin VB.Menu mnuClearList 
         Caption         =   "Remove All"
      End
      Begin VB.Menu mnuDivider2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAddStream 
         Caption         =   "Manuallly Add PDF Stream"
      End
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public frmMain As Object
Dim vt As New CVirusTotal
Dim md5 As New MD5Hash
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Dim selli As ListItem
Dim abort As Boolean

Private Sub cmdAbort_Click()
    abort = True
End Sub

Private Sub cmdClear_Click()
    List1.Clear
    lv.ListItems.Clear
    Text2 = Empty
    Set selli = Nothing
End Sub

Private Sub cmdQuery_Click()
    
    Dim report As String
    Dim detections As Long
    Dim li As ListItem
    
    On Error Resume Next
    
    If lv.ListItems.Count = 0 Then
        MsgBox "Load hashs first!"
        Exit Sub
    End If
    
    abort = False
    
    pb.Max = lv.ListItems.Count
    
    For Each li In lv.ListItems
    
        If abort Then Exit For
        
        If Len(Trim(li.Text)) = 0 Then GoTo nextone
        
        If vt.GetVTReport(li.Text, report, detections) Then
            li.SubItems(1) = detections
            If Len(report) > 0 Then
                li.Tag = report
            End If
            tmp = Split(report, vbCrLf)
            For Each x In tmp
                List1.AddItem x
            Next
        Else
            li.SubItems(1) = "Failure"
        End If
        
        li.EnsureVisible
        DoEvents
        Me.Refresh
        pb.Value = pb.Value + 1
        
        If pb.Value = lv.ListItems.Count Then GoTo nextone
        
        If Not vt.WasCached Then
            tmrDelay.Enabled = True
            While tmrDelay.Enabled
                DoEvents
                Sleep 200
            Wend
        End If
        
        
nextone:
    Next
    
    pb.Value = 0
    MsgBox "Complete Click on an item to view report.", vbInformation
 
 
End Sub



Private Sub Command2_Click()
'    Dim m_json As String
'    Dim b As String
'    Dim c As Long
'    Dim d As Dictionary
'
'    If AddComment(txtHash, Text2, m_json, b, c) Then
'        Set d = JSON.parse(m_json)
'        If d Is Nothing Then
'            List1.AddItem "AddComment JSON parsing error"
'            Exit Sub
'        End If
'
'        If JSON.GetParserErrors <> "" Then
'            List1.AddItem "AddComment Json Parse Error: " & JSON.GetParserErrors
'            Exit Sub
'        End If
'
'        If d.Item("response") <> 1 Then
'            MsgBox d.Item("verbose_msg")
'            Exit Sub
'        End If
'
'        MsgBox "Comment was added successfully", vbInformation
'
'    Else
'        MsgBox "Add Comment Failed Status code: " & c & " " & b
'    End If
        
   
    
End Sub

Private Sub cmdLoadHashs_Click()
    x = Clipboard.GetText
    tmp = Split(x, vbCrLf)
    For Each x In tmp
        If Len(Trim(x)) > 0 Then lv.ListItems.Add , , Trim(x)
    Next
End Sub

Private Sub Command1_Click()

    On Error Resume Next
    
    Dim lvMain As Object 'MSComctlLib.ListView <-- wtf does this give type mismatch error...exact same library and guid and version..
    Dim li As ListItem
    Dim li2 As ListItem
    Dim stream As Object 'CPdfStream
    Dim data As String
    Dim hash As String
    
    Set lvMain = frmMain.lv
    
    cmdClear_Click
    
    If lvMain Is Nothing Then
        MsgBox "Could not get a reference to the main form listview? Err:" & Err.Description
        MsgBox "TypeName(frmMain) = " & TypeName(frmMain)
        MsgBox "TypeName(frmMain.lv) = " & TypeName(frmMain.lv)
        MsgBox "Objptr(lvMain) = " & ObjPtr(lvMain)
        MsgBox frmMain.lv.ListItems.Count
        If frmMain Is Nothing Then MsgBox "FrmMain was nothing!?", vbInformation
        Exit Sub
    End If
    
    If lvMain.ListItems.Count = 0 Then
        MsgBox "No pdf was loaded or no streams found"
        Exit Sub
    End If
    
    Dim scanIt As Boolean
    
    scanLV lvMain
    scanLV frmMain.lv2
   
    If lv.ListItems.Count = 0 Then
        MsgBox "No embedded file types found such as swf, prc, u3d, ttf etc..", vbInformation
    Else
        MsgBox lv.ListItems.Count & " stream objects found!", vbInformation
    End If
        
End Sub

Private Sub scanLV(lvMain As Object)
    
    On Error Resume Next
    
    Dim li As ListItem
    Dim li2 As ListItem
    Dim stream As Object 'CPdfStream
    Dim data As String
    Dim hash As String
    Dim scanIt As Boolean
    Dim filters As String
    Dim fileType As String

     'GetActiveData(Item As ListItem, Optional load_ui As Boolean = False, Optional ret_Stream As CPDFStream) As String
    For Each li In lvMain.ListItems
        data = frmMain.GetActiveData(li, False, stream)
        If Not stream Is Nothing And Len(data) > 0 Then
            ext = stream.FileExtension
            filters = stream.StreamDecompressor.GetActiveFiltersAsString()
            fileType = stream.fileType
            
            scanIt = False
            If Len(ext) > 0 And ext <> ".xml" And ext <> ".unk" Then scanIt = True
            If InStr(1, filters, "JBIG2Decode", vbTextCompare) > 0 Then
                scanIt = True
                fileType = " JBIG2Stream"
            End If
            
            If scanIt Then
                hash = md5.HashString(data)
                Set li2 = lv.ListItems.Add(, , hash)
                i = stream.index
                li2.SubItems(2) = "Stream: " & i & " - " & fileType
            End If
            
        End If
    Next
    
End Sub


Private Sub Form_Load()
    
    Set vt.List1 = List1
    lv.ColumnHeaders(3).Width = lv.Width - lv.ColumnHeaders(3).Left - 150
    
End Sub


Private Sub lv_ItemClick(ByVal Item As MSComctlLib.ListItem)
    Text2 = Item.Tag
    Set selli = Item
End Sub

Private Sub lv_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuPopup
End Sub

Private Sub mnuAddStream_Click()
    
    On Error Resume Next
    
    Dim lvMain As ListView
    Dim li As ListItem
    Dim li2 As ListItem
    Dim stream As Object 'CPdfStream
    Dim data As String
    Dim hash As String
    
    Set lvMain = frmMain.lv
     
    If lvMain Is Nothing Then
        MsgBox "Could not get a reference to the main form listview?"
        Exit Sub
    End If
    
    If lvMain.ListItems.Count = 0 Then
        MsgBox "No pdf was loaded or no streams found"
        Exit Sub
    End If
    
    'GetActiveData(Item As ListItem, Optional load_ui As Boolean = False, Optional ret_Stream As CPDFStream) As String
    
    index = InputBox("Enter the streams index you want to load the hash for.")
    If Len(index) = 0 Then Exit Sub
    
    index = CLng(index)
    If index = 0 Then
        MsgBox "Invalid number entered"
        Exit Sub
    End If
    
    For Each li In lvMain.ListItems
        data = frmMain.GetActiveData(li, False, stream)
        If stream Is Nothing Then GoTo nextone
        
        If stream.index = index Then
            If Len(data) = 0 Then
                MsgBox "Specified index did not contain a stream?"
                Exit Sub
            End If
            
            ext = stream.FileExtension
            hash = md5.HashString(data)
            Set li2 = lv.ListItems.Add(, , hash)
            i = stream.index
            ft = " - " & stream.fileType
            If Len(ft) = 3 Then ft = ""
            li2.SubItems(2) = "Stream: " & i & ft & " - Manual Load"
            
            Exit Sub
        End If
        
nextone:
    Next
    
End Sub

Private Sub mnuClearList_Click()
    cmdClear_Click
End Sub

Private Sub mnuCopyAll_Click()
    Dim li As ListItem
    Dim r
    
    For Each li In lv.ListItems
        r = r & li.Text & "  Detections: " & li.SubItems(1) & vbCrLf
    Next
    
    r = r & vbCrLf & vbCrLf
    
    For Each li In lv.ListItems
        r = r & li.Text & vbCrLf & li.Tag & vbCrLf & String(50, "-") & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText r
    MsgBox Len(r) & " bytes copied to clipboard"
    
End Sub

Private Sub mnuCopyResult_Click()

    If selli Is Nothing Then
        MsgBox "Nothing selected"
        Exit Sub
    End If
    
    Dim r As String
    r = selli.Text & "  Detections: " & selli.SubItems(1) & vbCrLf & String(50, "-") & vbCrLf & selli.Tag
    Clipboard.Clear
    Clipboard.SetText r
    MsgBox Len(r) & " bytes copied to clipboard"
    
End Sub

Private Sub mnuCopyTable_Click()

    Dim li As ListItem
    Dim r
    
    For Each li In lv.ListItems
        r = r & li.Text & "  Detections: " & li.SubItems(1) & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText r
    MsgBox Len(r) & " bytes copied to clipboard"
    
End Sub

Private Sub mnuRemoveSelected_Click()
    On Error Resume Next
    
    For i = lv.ListItems.Count To 1 Step -1
        If lv.ListItems(i).Selected Then lv.ListItems.Remove i
    Next
    
End Sub

Private Sub tmrDelay_Timer()
    tmrDelay.Enabled = False
End Sub



