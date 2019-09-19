VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmBruteZLib 
   Caption         =   "Zlib Brute Forcer - find zlib compressed sections of file"
   ClientHeight    =   8055
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14175
   LinkTopic       =   "Form1"
   ScaleHeight     =   8055
   ScaleWidth      =   14175
   StartUpPosition =   2  'CenterScreen
   Begin VB.OptionButton optLZW 
      Caption         =   "lzw"
      Height          =   255
      Left            =   10140
      TabIndex        =   24
      Top             =   120
      Width           =   735
   End
   Begin VB.OptionButton optZlib 
      Caption         =   "zlib"
      Height          =   255
      Left            =   9300
      TabIndex        =   23
      Top             =   120
      Value           =   -1  'True
      Width           =   675
   End
   Begin VB.Frame fraReplaceStream 
      Caption         =   "Replace Stream "
      Height          =   2490
      Left            =   3735
      TabIndex        =   10
      Top             =   2250
      Visible         =   0   'False
      Width           =   8430
      Begin VB.OptionButton Option1 
         Caption         =   "after recompression"
         Height          =   285
         Index           =   1
         Left            =   3510
         TabIndex        =   20
         Top             =   2025
         Width           =   1860
      End
      Begin VB.OptionButton Option1 
         Caption         =   "before recompression"
         Height          =   285
         Index           =   0
         Left            =   1440
         TabIndex        =   19
         Top             =   2025
         Value           =   -1  'True
         Width           =   1860
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Update Stream"
         Height          =   330
         Left            =   6930
         TabIndex        =   18
         Top             =   2025
         Width           =   1410
      End
      Begin VB.TextBox txtPadChar 
         Height          =   285
         Left            =   4860
         TabIndex        =   17
         Text            =   "20"
         Top             =   1665
         Width           =   690
      End
      Begin VB.CheckBox chkPadifSmaller 
         Caption         =   "if replacment stream is smaller pad with hex char"
         Height          =   285
         Left            =   1080
         TabIndex        =   16
         Top             =   1665
         Width           =   3750
      End
      Begin VB.CommandButton cmdLoadNewStream 
         Caption         =   "..."
         Height          =   285
         Left            =   7650
         TabIndex        =   15
         Top             =   630
         Width           =   645
      End
      Begin VB.TextBox txtNewStream 
         Height          =   285
         Left            =   1080
         TabIndex        =   14
         Top             =   630
         Width           =   6450
      End
      Begin VB.Label lblNewStatsLine2 
         Height          =   285
         Left            =   1035
         TabIndex        =   22
         Top             =   1305
         Width           =   7170
      End
      Begin VB.Label lblNewStream 
         Height          =   330
         Left            =   1080
         TabIndex        =   21
         Top             =   990
         Width           =   6495
      End
      Begin VB.Label Label2 
         Caption         =   "New Stream;"
         Height          =   285
         Left            =   90
         TabIndex        =   13
         Top             =   630
         Width           =   1095
      End
      Begin VB.Label lblReplaceStats 
         Caption         =   "Label2"
         Height          =   375
         Left            =   180
         TabIndex        =   12
         Top             =   225
         Width           =   4020
      End
      Begin VB.Label lblClose 
         BackColor       =   &H00FFFFFF&
         Caption         =   "  X "
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   13.5
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   7830
         TabIndex        =   11
         Top             =   45
         Width           =   465
      End
   End
   Begin VB.CommandButton cmdStop 
      Caption         =   "Stop"
      Height          =   330
      Left            =   13230
      TabIndex        =   9
      Top             =   45
      Width           =   825
   End
   Begin MSComctlLib.ProgressBar pb 
      Height          =   240
      Left            =   90
      TabIndex        =   8
      Top             =   450
      Width           =   13920
      _ExtentX        =   24553
      _ExtentY        =   423
      _Version        =   393216
      Appearance      =   0
   End
   Begin VB.CommandButton Command3 
      Caption         =   "?"
      Height          =   330
      Left            =   11565
      TabIndex        =   7
      Top             =   45
      Width           =   465
   End
   Begin RichTextLib.RichTextBox rtf 
      Height          =   5280
      Left            =   3150
      TabIndex        =   6
      Top             =   2565
      Width           =   10905
      _ExtentX        =   19235
      _ExtentY        =   9313
      _Version        =   393217
      ScrollBars      =   2
      TextRTF         =   $"frmBruteZLib.frx":0000
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.CommandButton Command2 
      Caption         =   "..."
      Height          =   330
      Left            =   11025
      TabIndex        =   5
      Top             =   45
      Width           =   465
   End
   Begin VB.TextBox txtDetails 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1725
      Left            =   3150
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   720
      Width           =   10905
   End
   Begin MSComctlLib.ListView lv 
      Height          =   7125
      Left            =   90
      TabIndex        =   3
      Top             =   720
      Width           =   2985
      _ExtentX        =   5265
      _ExtentY        =   12568
      View            =   3
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   1
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Zlib Brute"
      Height          =   330
      Left            =   12060
      TabIndex        =   2
      Top             =   45
      Width           =   1140
   End
   Begin VB.TextBox txtFile 
      Height          =   330
      Left            =   810
      OLEDropMode     =   1  'Manual
      TabIndex        =   1
      Text            =   "Drag And Drop file here"
      Top             =   45
      Width           =   8100
   End
   Begin VB.Label Label1 
      Caption         =   "Load File"
      Height          =   285
      Left            =   45
      TabIndex        =   0
      Top             =   45
      Width           =   870
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuStrings 
         Caption         =   "Strings"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuSearchStreams 
         Caption         =   "Search Streams"
      End
      Begin VB.Menu mnuSaveToFile 
         Caption         =   "Save Stream"
      End
      Begin VB.Menu mnuSaveAll 
         Caption         =   "Save All"
      End
      Begin VB.Menu mnuSpacer 
         Caption         =   "-"
      End
      Begin VB.Menu mnuReplaceStream 
         Caption         =   "Replace Stream"
      End
      Begin VB.Menu mnuCopyAllStats 
         Caption         =   "Copy Stats for all Streams"
      End
      Begin VB.Menu mnuCompareWithMain 
         Caption         =   "Compare to Streams in Main UI"
      End
   End
End
Attribute VB_Name = "frmBruteZLib"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim selli As ListItem
Dim abort As Boolean
Dim replacementStream As CPDFStream

Private Sub cmdLoadNewStream_Click()
    Dim f As Long
    Dim b() As Byte
    Dim c As CPDFStream
    
    On Error Resume Next
    Set c = selli.tag
    If c Is Nothing Then
        fraReplaceStream.Visible = False
        Exit Sub
    End If
    
    txtNewStream.Text = Form1.dlg.OpenDialog(AllFiles, , , Me.hwnd)
    If fso.FileExists(txtNewStream) Then
        Set replacementStream = New CPDFStream
        f = FreeFile
        Open txtNewStream For Binary As f
        ReDim b(LOF(f))
        Get f, , b()
        Close f
        With replacementStream
            .DecompressedData = StrConv(b(), vbUnicode, LANG_US)
            .DecompressedSize = Len(.DecompressedData)
            .OriginalData = SimpleCompress(.DecompressedData)
            .CompressedSize = Len(.OriginalData)
            lblNewStream = "RawSize: " & Hex(.DecompressedSize) & " Compressed: " & Hex(.CompressedSize)
            lblNewStatsLine2 = "Replacement stream is " & Abs(c.CompressedSize - .CompressedSize) & _
                                " " & IIf(c.CompressedSize > .CompressedSize, "SMALLER", "BIGGER") & _
                                " than original"
            If .CompressedSize > c.CompressedSize Then
                chkPadifSmaller.value = 0
                chkPadifSmaller.enabled = False
            End If
        End With
    End If
        
End Sub

Private Sub cmdStop_Click()
    abort = True
End Sub

Private Sub Command1_Click()
    
    If Not fso.FileExists(txtFile) Then Exit Sub
    
    On Error Resume Next
    
    If Not csharp.Initilized Then
        MsgBox csharp.ErrorMessage, vbExclamation
        Exit Sub
    End If
    
    Dim f As Long
    Dim b() As Byte
    Dim bOut() As Byte
    Dim tmp() As Byte
    Dim d As String
    
    Dim c As CPDFStream
    
    Dim li As ListItem
    Dim i As Long
    
    abort = False
    lv.ListItems.Clear
    pb.value = 0
    rtf.Text = Empty
    txtDetails = Empty
    
    f = FreeFile
    Open txtFile For Binary As f
    ReDim b(LOF(f))
    Get f, , b()
    Close f
    
    For i = 0 To UBound(b)
    
        setPB i, UBound(b)
        DoEvents
        Me.Refresh
        DoEvents
        If abort Then Exit For
        
        If csharp.QuickDeflate(b(), bOut(), i, optZlib.value) Then
        
            modZLIB.CompressData bOut, tmp 'figure out how big compressed block was
            Set c = New CPDFStream
            c.startOffset = i - 1
            
            If Not AryIsEmpty(tmp) Then
                c.EndOffset = i + UBound(tmp) - 1
                Erase tmp
            Else
                c.EndOffset = 0
            End If
            
            c.DecompressedSize = UBound(bOut)
            c.DecompressedData = StrConv(bOut, vbUnicode, LANG_US)
            c.DecompressedDataCRC = CRC32(c.DecompressedData)
            c.CompressedSize = c.EndOffset - c.startOffset
            
            Set li = lv.ListItems.Add(, , "offset: 0x" & Hex(c.startOffset) & " sz: 0x" & Hex(c.DecompressedSize))
            Set li.tag = c
            
            If c.EndOffset <> 0 Then i = c.EndOffset  'advance file pointer to after this chunk
            csharp.DecodedBuffer = Empty
            
        End If
    Next
    
    pb.value = 0
    MsgBox lv.ListItems.count & " Streams found!", vbInformation
            
        
End Sub

'Private Sub Command1_Click()
'
'    If Not fso.FileExists(txtFile) Then Exit Sub
'
'    On Error Resume Next
'
'    If Not csharp.Initilized Then
'        MsgBox csharp.ErrorMessage, vbExclamation
'        Exit Sub
'    End If
'
'    Dim f As Long
'    Dim b() As Byte
'    Dim bOut() As Byte
'    Dim tmp() As Byte
'    Dim d As String
'
'    Dim c As CPDFStream
'
'    Dim li As ListItem
'    Dim i As Long
'
'    abort = False
'    lv.ListItems.Clear
'    pb.Value = 0
'    rtf.Text = Empty
'    txtDetails = Empty
'
'    f = FreeFile
'    Open txtFile For Binary As f
'    ReDim b(LOF(f))
'    Get f, , b()
'    Close f
'
'    'this can be horrbily slow on large byte buffers since we are doing it all as string
'    'manipulations and then converting back and forth ALLOT..I should optimize this to make it faster
'    'but this is just an add on right now using existing code, this can be much improved..but for now
'    'it is what it is...the native zlib class didnt work for this for some reason. would be way faster
'
'    d = StrConv(b, vbUnicode, LANG_US)
'
'    For i = 0 To UBound(b)
'
'        csharp.decode Mid(d, i), FlateDecode
'
'        'modzlib.UncompressData b, bout, i
'        setPB i, UBound(b)
'        DoEvents
'        Me.Refresh
'        DoEvents
'        If abort Then Exit For
'
'        'If Not AryIsEmpty(bout) Then
'        If Len(csharp.DecodedBuffer) > 0 Then
'            bOut = StrConv(csharp.DecodedBuffer, vbFromUnicode, LANG_US)
'            modzlib.CompressData bOut, tmp 'figure out how big compressed block was
'            Set c = New CPDFStream
'            c.startOffset = i - 1
'
'            If Not AryIsEmpty(tmp) Then
'                c.EndOffset = i + UBound(tmp) - 1
'                Erase tmp
'            Else
'                c.EndOffset = 0
'            End If
'
'            c.DecompressedSize = UBound(bOut)
'            c.DecompressedData = StrConv(bOut, vbUnicode, LANG_US)
'            c.DecompressedDataCRC = CRC32(c.DecompressedData)
'
'            Set li = lv.ListItems.Add(, , "offset: 0x" & Hex(c.startOffset) & " sz: 0x" & Hex(c.DecompressedSize))
'            Set li.tag = c
'
'            If c.EndOffset <> 0 Then i = c.EndOffset  'advance file pointer to after this chunk
'            csharp.DecodedBuffer = Empty
'
'        End If
'    Next
'
'    pb.Value = 0
'    MsgBox lv.ListItems.Count & " Streams found!", vbInformation
'
'
'End Sub

Function AryIsEmpty(ary) As Boolean
    On Error Resume Next
    x = UBound(ary)
    If x = -1 Or Err.Number <> 0 Then AryIsEmpty = True
End Function

Sub setPB(i, tot)
    On Error Resume Next
    pcent = CInt((i / tot) * 100)
    If pcent >= 100 Then pb.value = 0 Else pb.value = pcent
End Sub

Private Sub Command2_Click()
    f = Form1.dlg.OpenDialog(AllFiles, , , Me.hwnd)
    If Len(f) = 0 Then Exit Sub
    txtFile = f
    Command1_Click
End Sub

Private Sub Command3_Click()
    Const msg = "This interface will go through a file byte by byte trying to\n" & _
                " find sections compressed with ZLIB. Found offsets will be added to \n" & _
                "the list on the left, details on top, hexdump on bottom. Right click on \n" & _
                "listview to save data to file.\n\n" & _
                "This can be slow on large files, progress can jump quickly however as it \n" & _
                "skips past compressed blocks it finds"
    MsgBox Replace(msg, "\n", vbCrLf), vbInformation
End Sub

Private Sub Command4_Click()
    If replacementStream Is Nothing Then
        MsgBox "No replacement stream loaded yet.", vbInformation
        Exit Sub
    End If
    On Error Resume Next
    Dim c As CPDFStream
    Set c = selli.tag
    
    Dim f As String
    Dim fNew As Long, fBase As Long
    Dim b() As Byte, new_bytes() As Byte
    
    txtNew = Form1.dlg.SaveDialog(AllFiles, fso.GetParentFolder(txtFile), , , Me.hwnd, _
                "mod_" & fso.GetBaseName(txtFile) & "." & fso.GetExtension(txtFile))
                
    If Len(txtNew) = 0 Then Exit Sub
    
    With replacementStream
        If .CompressedSize < c.CompressedSize And chkPadifSmaller.value = 1 Then
            If Option1(0).value = True Then 'pad before recompression...
                MsgBox "do stuff here"
                Exit Sub
            Else
                diff = c.CompressedSize - .CompressedSize
                .OriginalData = .OriginalData & String(diff, Chr(CLng("&h" & txtPadChar)))
                .CompressedSize = Len(.OriginalData)
                If .CompressedSize <> c.CompressedSize Then Stop
            End If
        End If
        
        new_bytes() = StrConv(replacementStream.OriginalData, vbFromUnicode, LANG_US)
        
        fBase = FreeFile
        Open txtFile For Binary As fBase
        
        fNew = FreeFile
        Open txtNew For Binary As fNew
        
        ReDim b(c.startOffset)
        Get fBase, , b() 'load the file up to the original stream
        Put fNew, , b() 'save it to the new file
        
        Put fNew, , new_bytes() 'save our new stream to new file
        
        'ReDim b(stream.CompressedSize)
        'Get f, , b() 'advance file pointer size of orginal compressed data
        
        ReDim b(LOF(fBase) - c.EndOffset)
        Get fBase, c.EndOffset + 1, b() 'load teh rest of the original file
        Put fNew, , b() 'save rest of file to new file
        
        Close fBase
        Close fNew
        
    End With
    
    If Err.Number <> 0 Then
        MsgBox "Error: " & Err.Description, vbExclamation
    Else
        MsgBox "File successfully created.", vbInformation
        fraReplaceStream.Visible = False
        lv.enabled = True
    End If
    
    
End Sub

Private Sub Form_Load()
    Me.Icon = Form1.Icon
    pb.value = 0
    lv.ColumnHeaders(1).Width = lv.Width - 100
    txtFile = Form1.txtPDFPath
    optLZW.Visible = isIde()
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    abort = True
End Sub

Private Sub lblClose_Click()
    fraReplaceStream.Visible = False
    lv.enabled = True
End Sub

Private Sub lv_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    Dim c As CPDFStream
    
    Set selli = Nothing
    Set c = Item.tag
    
    If c Is Nothing Then Exit Sub
    
    rtf.Text = Empty
    Set selli = Item
    
    r = "Start Offset: 0x" & Hex(c.startOffset) & " (" & c.startOffset & ")" & vbCrLf
    r = r & "End Offset: 0x" & Hex(c.EndOffset) & " (" & c.EndOffset & ")" & vbCrLf
    r = r & "DecompressedSize: 0x" & Hex(c.DecompressedSize) & " (" & c.DecompressedSize & ")" & vbCrLf
    r = r & "DecompressedDataCRC: " & c.DecompressedDataCRC & vbCrLf
    txtDetails = r
    
    rtf.Text = HexDump(c.DecompressedData)
    
End Sub

Private Sub lv_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
    If Button = 2 Then PopupMenu mnuPopup
End Sub

Private Sub mnuCompareWithMain_Click()
    On Error Resume Next
    Dim c As CPDFStream
    Dim li As ListItem
    Dim matches As Long
    
    If lv.ListItems.count = 0 Then
        MsgBox "No streams loaded in zlib brute. This feature will compare streams found by bruting with streams found by pdf parsing and remove all common streams from this form to see if any were hidden.", vbInformation
        Exit Sub
    End If
    
    If Form1.lv.ListItems.count = 0 Then
        MsgBox "No streams loaded in main UI listview nothing to do", vbInformation
        Exit Sub
    End If
    
    For i = lv.ListItems.count To 1 Step -1
        Set li = lv.ListItems(i)
        Set c = li.tag
        If FindStreamInMain(c) Then
            lv.ListItems.Remove i
            matches = matches + 1
        End If
    Next
    
    MsgBox matches & " made - " & lv.ListItems.count & " hidden streams identified!"
    
End Sub

Function FindStreamInMain(c As CPDFStream) As Boolean
    Dim m As CPDFStream
    For Each li In Form1.lv.ListItems
        Set m = li.tag
        If m.isCompressed Then
            If m.startOffset = c.startOffset + 1 Then
                FindStreamInMain = True
                Exit Function
            End If
        End If
    Next
End Function


Private Sub mnuCopyAllStats_Click()
    On Error Resume Next
    Dim c As CPDFStream
    Dim li As ListItem
    
    If lv.ListItems.count = 0 Then Exit Sub
    
    For Each li In lv.ListItems
        Set c = li.tag
        r = r & "Start Offset: 0x" & Hex(c.startOffset) & " (" & c.startOffset & ")" & vbCrLf
        r = r & "End Offset: 0x" & Hex(c.EndOffset) & " (" & c.EndOffset & ")" & vbCrLf
        r = r & "DecompressedSize: 0x" & Hex(c.DecompressedSize) & " (" & c.DecompressedSize & ")" & vbCrLf
        r = r & "DecompressedDataCRC: " & c.DecompressedDataCRC & vbCrLf & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText r
    
    MsgBox Len(r) & " bytes saved to clipboard", vbInformation
    

End Sub

Private Sub mnuReplaceStream_Click()
    If selli Is Nothing Then Exit Sub
    
    If InStr(1, App.path, "ftp_root", vbTextCompare) < 1 Then
        MsgBox "Not quite debugged yet..", vbInformation
        Exit Sub
    End If
    
    Dim c As CPDFStream
    Set c = selli.tag
    lblReplaceStats = "Start Offsest: " & Hex(c.startOffset) & " Compressed Size: " & Hex(c.CompressedSize)
    lv.enabled = False 'dont want selli to be updated...
    Set replacementStream = Nothing
    fraReplaceStream.Visible = True
    
End Sub

Private Sub mnuSaveAll_Click()
    On Error Resume Next
    Dim c As CPDFStream
    Dim li As ListItem
    Dim d As String
    Dim f As String
    Dim ok As Long
    
    If lv.ListItems.count = 0 Then Exit Sub
    
    d = Form1.dlg.FolderDialog(, Me.hwnd)
    If Len(d) = 0 Then Exit Sub
    
    For Each li In lv.ListItems
        Set c = li.tag
        f = d & "\zbrute_" & Hex(c.startOffset) & ".dat"
        If fso.FileExists(f) Then Kill f
        If SaveStream(c, f) Then ok = ok + 1
    Next
    
    MsgBox ok & "/" & lv.ListItems.count & " Streams saved successfully!", vbInformation
    
End Sub

Private Sub mnuSaveToFile_Click()
    On Error Resume Next
    Dim c As CPDFStream
    
    If selli.tag Is Nothing Then Exit Sub
    Set c = selli.tag
    f = Form1.dlg.SaveDialog(AllFiles, , "Save file as", , Me.hwnd, "zbrute_" & Hex(c.startOffset) & ".dat")
    If Len(f) = 0 Then Exit Sub
    
    MsgBox "Saved to file: " & SaveStream(c, f)
    
End Sub

Function SaveStream(c As CPDFStream, fPath) As Boolean
    On Error Resume Next
    Dim b() As Byte
    Dim f As Long
    
    b() = StrConv(c.DecompressedData, vbFromUnicode, LANG_US)
    f = FreeFile
    Open fPath For Binary As f
    Put f, , b()
    Close f
    
    SaveStream = IIf(Err.Number = 0, True, False)
    
End Function



Private Sub mnuSearchStreams_Click()
    On Error Resume Next
    Dim c As CPDFStream
    Dim li As ListItem
    Dim d As String
    Dim f As String
    Dim ok As Long
    
    If lv.ListItems.count = 0 Then Exit Sub
    
    d = InputBox("Search for:")
    If Len(d) = 0 Then Exit Sub
    
    For Each li In lv.ListItems
        Set c = li.tag
        ok = InStr(1, c.DecompressedData, d, vbTextCompare)
        If ok > 0 Then
            f = f & li.Text & " offset: 0x" & Hex(ok) & vbCrLf
        End If
    Next
    
    If Len(f) > 0 Then
        MsgBox "Found " & d & " in: " & vbCrLf & vbCrLf & f
    Else
        MsgBox "String fragment not found in any streams", vbInformation
    End If
    
        
End Sub

Private Sub txtFile_OLEDragDrop(data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    On Error Resume Next
    txtFile = data.Files(1)
    Command1_Click
End Sub
