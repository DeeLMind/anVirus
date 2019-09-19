VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmManualFilters 
   Caption         =   "Manual Filters"
   ClientHeight    =   7290
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14715
   LinkTopic       =   "Form3"
   ScaleHeight     =   7290
   ScaleWidth      =   14715
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraFaxDecode 
      Caption         =   "Fax Decode Parameters"
      Height          =   3075
      Left            =   2940
      TabIndex        =   23
      Top             =   1800
      Visible         =   0   'False
      Width           =   5535
      Begin VB.OptionButton optFaxCode 
         Caption         =   "C# decoder"
         Height          =   285
         Index           =   1
         Left            =   3030
         TabIndex        =   41
         Top             =   1320
         Value           =   -1  'True
         Width           =   1935
      End
      Begin VB.OptionButton optFaxCode 
         Caption         =   "Native muPdf decoder"
         Height          =   345
         Index           =   0
         Left            =   3030
         TabIndex        =   40
         Top             =   900
         Width           =   2205
      End
      Begin VB.CommandButton cmdCloseFaxParams 
         Caption         =   "Cancel"
         Height          =   435
         Left            =   3030
         TabIndex        =   39
         Top             =   2460
         Width           =   2355
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Run Decoder"
         Height          =   465
         Left            =   3030
         TabIndex        =   38
         Top             =   1800
         Width           =   2325
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   6
         Left            =   1710
         TabIndex        =   37
         Text            =   "0"
         Top             =   2550
         Width           =   1005
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   5
         Left            =   1710
         TabIndex        =   35
         Text            =   "1"
         Top             =   2190
         Width           =   1005
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   4
         Left            =   1710
         TabIndex        =   33
         Text            =   "0"
         Top             =   1800
         Width           =   1005
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   3
         Left            =   1710
         TabIndex        =   31
         Text            =   "0"
         Top             =   1380
         Width           =   1005
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   2
         Left            =   1710
         TabIndex        =   29
         Text            =   "0"
         Top             =   990
         Width           =   1005
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   1
         Left            =   1710
         TabIndex        =   27
         Text            =   "0"
         Top             =   630
         Width           =   1005
      End
      Begin VB.TextBox Text1 
         Height          =   285
         Index           =   0
         Left            =   1710
         TabIndex        =   25
         Text            =   "1728"
         Top             =   270
         Width           =   1005
      End
      Begin VB.Label Label1 
         Caption         =   "BlackIs1"
         Height          =   255
         Index           =   6
         Left            =   180
         TabIndex        =   36
         Top             =   2580
         Width           =   705
      End
      Begin VB.Label Label1 
         Caption         =   "EndOfBlock"
         Height          =   255
         Index           =   5
         Left            =   150
         TabIndex        =   34
         Top             =   2190
         Width           =   1335
      End
      Begin VB.Label Label1 
         Caption         =   "EncodedByteAlign"
         Height          =   255
         Index           =   4
         Left            =   150
         TabIndex        =   32
         Top             =   1800
         Width           =   1515
      End
      Begin VB.Label Label1 
         Caption         =   "End Of Line"
         Height          =   255
         Index           =   3
         Left            =   150
         TabIndex        =   30
         Top             =   1380
         Width           =   1395
      End
      Begin VB.Label Label1 
         Caption         =   "K"
         Height          =   255
         Index           =   2
         Left            =   150
         TabIndex        =   28
         Top             =   990
         Width           =   705
      End
      Begin VB.Label Label1 
         Caption         =   "Rows"
         Height          =   255
         Index           =   1
         Left            =   150
         TabIndex        =   26
         Top             =   630
         Width           =   705
      End
      Begin VB.Label Label1 
         Caption         =   "Columns"
         Height          =   255
         Index           =   0
         Left            =   150
         TabIndex        =   24
         Top             =   270
         Width           =   705
      End
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Load Stream From Clip"
      Height          =   285
      Left            =   120
      TabIndex        =   22
      Top             =   1920
      Width           =   1875
   End
   Begin VB.CommandButton cmdSaveCurBuffer 
      Caption         =   "Save Cur buffer to Disk"
      Height          =   285
      Left            =   120
      TabIndex        =   21
      Top             =   900
      Width           =   1845
   End
   Begin VB.CommandButton cmdZlibDeflate 
      Caption         =   "FlateDecode"
      Height          =   285
      Left            =   105
      TabIndex        =   20
      Top             =   3315
      Width           =   1770
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   9
      Left            =   105
      TabIndex        =   19
      Top             =   6915
      Width           =   1815
   End
   Begin VB.CheckBox chkDebug 
      Caption         =   "Debug iText.Decode"
      Height          =   255
      Left            =   90
      TabIndex        =   18
      Top             =   2970
      Width           =   1815
   End
   Begin VB.TextBox txtHeader 
      Height          =   1095
      Left            =   2040
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   15
      Top             =   360
      Width           =   12615
   End
   Begin VB.CommandButton cmdOriginal 
      Caption         =   "Original"
      Enabled         =   0   'False
      Height          =   255
      Left            =   90
      TabIndex        =   14
      Top             =   2310
      Width           =   1815
   End
   Begin VB.CheckBox chkHexdump 
      Caption         =   "Display as Hexdump"
      Height          =   255
      Left            =   90
      TabIndex        =   12
      Top             =   2610
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   8
      Left            =   90
      TabIndex        =   10
      Top             =   6570
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   7
      Left            =   90
      TabIndex        =   9
      Top             =   6210
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   6
      Left            =   90
      TabIndex        =   8
      Top             =   5850
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   5
      Left            =   90
      TabIndex        =   7
      Top             =   5490
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   4
      Left            =   90
      TabIndex        =   6
      Top             =   5130
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   3
      Left            =   90
      TabIndex        =   5
      Top             =   4770
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   2
      Left            =   90
      TabIndex        =   4
      Top             =   4410
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   1
      Left            =   90
      TabIndex        =   3
      Top             =   4050
      Width           =   1815
   End
   Begin VB.CommandButton cmdDecode 
      Caption         =   "Command3"
      Height          =   255
      Index           =   0
      Left            =   90
      TabIndex        =   2
      Top             =   3690
      Width           =   1815
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Load Stream From File"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1590
      Width           =   1815
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Load Active Stream"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   1260
      Width           =   1815
   End
   Begin RichTextLib.RichTextBox txtUncompressed 
      Height          =   5625
      Left            =   2040
      TabIndex        =   11
      Top             =   1560
      Width           =   12615
      _ExtentX        =   22251
      _ExtentY        =   9922
      _Version        =   393217
      Enabled         =   -1  'True
      HideSelection   =   0   'False
      ScrollBars      =   2
      TextRTF         =   $"frmManualFilters.frx":0000
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label lbliText 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   1320
      TabIndex        =   17
      Top             =   600
      Width           =   615
   End
   Begin VB.Label label2 
      Caption         =   "iText Enabled?"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   600
      Width           =   1095
   End
   Begin VB.Label lblBufLen 
      Caption         =   "Buffer Length: "
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   240
      Width           =   1695
   End
End
Attribute VB_Name = "frmManualFilters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim buf As String
Dim org As String

Private Sub cmdCloseFaxParams_Click()
    fraFaxDecode.Visible = False
End Sub

Private Sub cmdSaveCurBuffer_Click()
    
    On Error GoTo hell
    
    If Len(buf) = 0 Then
        MsgBox "Current buffer is empty nothing to save!"
        Exit Sub
    End If
    
    f = Form1.dlg.SaveDialog(AllFiles, , , , Me.hwnd, "buffer.bin")
    If Len(f) = 0 Then Exit Sub
    If fso.FileExists(f) Then fso.DeleteFile f
    
    Dim b() As Byte
    Dim fh As Long
    fh = FreeFile
    b() = StrConv(buf, vbFromUnicode, LANG_US)
    
    Open f For Binary As fh
    Put fh, , b()
    Close fh
    
    Exit Sub
hell:
    MsgBox Err.Description
    
End Sub

Private Sub chkHexdump_Click()
    DisplayData
End Sub

Private Function SetDecodePredictor() As Boolean
    On Error Resume Next
    x = InputBox("Enter following values seperated by commas:" & vbCrLf & vbCrLf & "predictor, columns, colors, bitsperscomponent", , "12,1,1,8")
    If Len(x) = 0 Then Exit Function
    x = Split(x, ",")
    If UBound(x) <> 3 Then
        MsgBox "not enough elements: " & UBound(x)
        Exit Function
    End If
    csharp.SetPredictorParams CInt(x(0)), x(1), x(2), x(3)
    SetDecodePredictor = True
End Function

Private Sub cmdDecode_Click(Index As Integer)
    
    On Error GoTo hell
    
    Dim dbugMode As Boolean
    Dim pos As Long
    
    Dim decode As Decoders
    If Len(buf) = 0 Then
        MsgBox "You have not loaded a stream yet", vbInformation
        Exit Sub
    End If
    
    If chkDebug.value = 1 Then dbugMode = True
    
    If Index = FlateDecode Then
        If NativeFlateDecompress(buf) Then
            DisplayData
        Else
            txtUncompressed.Text = "Zlib Flate Decode failed"
        End If
    ElseIf Index = AsciiHexDecode Then
        buf = Replace(buf, " ", Empty)
        buf = Replace(buf, vbCr, Empty)
        buf = Replace(buf, vbLf, Empty)
        buf = Replace(buf, vbTab, Empty)
        pos = InStr(buf, ">")
        If pos > 1 Then buf = Mid(buf, 1, pos - 1) 'koji pdf spec 3.3.1 > is end of data
        DisplayData
        If AsciiHexPreScreen(buf) Then
            buf = HexStringUnescape(buf, True)
            DisplayData
        End If
    ElseIf Index = JBIG2Decode Then
        buf = mupdf.muJBIG2Decode(buf)
        If Len(buf) = 0 Then
            txtUncompressed = "Failed to decode JBIG2 Stream possibly malformed?"
        Else
            DisplayData
        End If
    ElseIf Index = CCITTFaxDecode Then
        fraFaxDecode.Visible = True
    ElseIf csharp.Initilized Then
        If Index = DecodePredictor Then
            If Not SetDecodePredictor() Then Exit Sub
        End If
        If csharp.decode(buf, CLng(Index), False, dbugMode) Then
            buf = csharp.DecodedBuffer
            DisplayData
        Else
            txtUncompressed.Text = csharp.ErrorMessage
        End If
    Else
        
        MsgBox "This filter requires .NET 2.0 or greater installed"
        
    End If
    
    Exit Sub
hell:     MsgBox Err.Description
End Sub


'koji http://www.adobe.com/content/dam/Adobe/en/devnet/pdf/pdfs/pdf_reference_archives/PDFReference.pdf ]
'3.3.1 says "A right angle bracket character (>) is valid and indicates EOD

Private Function AsciiHexPreScreen(ByVal buf As String) As Boolean
    
    On Error GoTo hell
    Dim isOk As Boolean
    
    buf = LCase(buf)
    For i = 1 To Len(buf)
        isOk = False
        c = Mid(buf, i, 1)
        If Asc(c) >= Asc("a") And Asc(c) <= Asc("f") Then isOk = True
        If Not isOk Then
            If Asc(c) >= Asc("0") And Asc(c) <= Asc("9") Then isOk = True
            If c = ">" Then
                isOk = True
                Exit For
            End If
        End If
        If Not isOk Then
            MsgBox "Invalid input character for asciihexdecode at index " & i & " character: " & c
            txtUncompressed.SelStart = i
            txtUncompressed.SelLength = 1
            Exit Function
        End If
    Next
    
    AsciiHexPreScreen = True
    Exit Function
hell:
    AsciiHexPreScreen = False
End Function

Private Function DisplayData() As String
    On Error Resume Next
    
    If chkHexdump.value = 1 Then
        txtUncompressed.Text = HexDump(buf)
    Else
        txtUncompressed.Text = buf 'this can throw out of memory error sometimes on binary data? weird..
    End If
    
    If Err.Number <> 0 And chkHexdump.value = 0 Then
        chkHexdump.value = 1
        txtUncompressed.Text = HexDump(buf)
    End If
    
    lblBufLen.Caption = "BufLen: 0x" & Hex(Len(buf))
End Function

Private Function NativeFlateDecompress(ByVal s As String) As Boolean
    Dim b() As Byte
    Dim bOut() As Byte
    
    b = StrConv(s, vbFromUnicode, LANG_US)
                
    modZLIB.UncompressData b(), bOut()
    
    If Not AryIsEmpty(bOut) Then
        buf = StrConv(bOut, vbUnicode, LANG_US)
        NativeFlateDecompress = True
    End If
                
End Function

 



Private Sub cmdZlibDeflate_Click()
        On Error GoTo hell
        If NativeFlateDecompress(buf) Then
            DisplayData
        Else
            txtUncompressed.Text = "Zlib Flate Decode failed"
        End If
        Exit Sub
hell:         txtUncompressed = "Error: " & Err.Description
End Sub

Private Sub Command1_Click()
    
    If Form1.selli Is Nothing Then
        MsgBox "No stream selected in main form", vbInformation
        Exit Sub
    End If
    
    On Error Resume Next
    Dim s As CPDFStream
    Set s = Form1.selli.tag
    
    If s Is Nothing Then
        MsgBox "Could not get stream from " & Form1.selli.Text
        Exit Sub
    End If
    
    If Not s.ContainsStream Then
        MsgBox "Selected object does not contain a stream.", vbInformation
        Exit Sub
    End If
    
    buf = s.OriginalData
    txtHeader.Text = IIf(Form1.mnuAutoEscapeHeaders.Checked, s.escapedHeader, s.Header)
    org = buf
    cmdOriginal.enabled = True
    DisplayData
    
End Sub

Private Sub cmdOriginal_Click()
    buf = org
    DisplayData
End Sub

Private Sub Command2_Click()
    
    On Error Resume Next
    Dim f As String
    Dim dlg As New clsCmnDlg
    
    f = dlg.OpenDialog(AllFiles, , "Open raw stream file", Me.hwnd)
    If Len(f) = 0 Then Exit Sub
    
    txtHeader.Text = "No PDF Header preview available when loading raw streams"
    org = fso.ReadFile(f)
    buf = org
    cmdOriginal.enabled = True
    DisplayData
    
End Sub

Private Sub Command3_Click()
    On Error Resume Next
    f = Clipboard.GetText
    If Len(f) = 0 Then
        MsgBox "No data found in clipboard."
        Exit Sub
    End If
    
    txtHeader.Text = "No PDF Header preview available when loading raw streams"
    org = f
    buf = org
    cmdOriginal.enabled = True
    DisplayData
End Sub

Private Sub Command4_Click()
   On Error Resume Next
    
    Dim k As Long, endofline As Long, encodedbytealign As Long, columns As Long, rows As Long, endofblock As Long, blackis1 As Long
    
    columns = CLng(Text1(0))
    rows = CLng(Text1(1))
    k = CLng(Text1(2))
    endofline = CLng(Text1(3))
    encodedbytealign = CLng(Text1(4))
    endofblock = CLng(Text1(5))
    blackis1 = CLng(Text1(6))
    
    If Err.Number <> 0 Then
        MsgBox "Error loading values from textboxes. All values must be numeric base 10 values", vbInformation
        Exit Sub
    End If
    
    If optFaxCode(0).value = True Then
        buf = mupdf.muCCITTFaxDecode(buf, columns, rows, k, endofline, encodedbytealign, endofblock, blackis1)
        DisplayData
    Else
        csharp.SetFaxDecodeParams columns, rows, k, endofline, encodedbytealign, endofblock, blackis1
        If Not csharp.decode(buf, CCITTFaxDecode, False, False) Then
            txtUncompressed = csharp.ErrorMessage
        Else
            buf = csharp.DecodedBuffer
            DisplayData
        End If
    End If

    fraFaxDecode.Visible = False

End Sub

Private Sub Form_Load()
    Me.Icon = Form1.Icon
    Dim enabled As Boolean, i As Long
    
    optFaxCode(1).enabled = csharp.Initilized
    If Not csharp.Initilized Then optFaxCode(0).value = True
    
    For i = 0 To cmdDecode.count - 1
        cmdDecode(i).Caption = FilterNameFromIndex(i, enabled)
        cmdDecode(i).enabled = enabled
    Next
    
    lbliText.Caption = IIf(csharp.Initilized, "True", "False")
    
    txtHeader.Text = "This form lets you manually test filters (and filter chains), display the exact error message, and watch the data transforms at each step. First load a stream then decode it. If you are working on a decode chain, you can get back to the original at any time with the original button"
    
    
End Sub

'Private Sub Label1_Click()
'    MsgBox "The parent buffer you are decoding gets updated each call so you can chain filters. "
'End Sub

Private Sub lbliText_Click()

    MsgBox "For iText filters to be enabled you have to have: " & vbCrLf & vbCrLf & _
            "1) .NET runtime v2.0 or v3.5 installed" & vbCrLf & _
            "2) iTextFilters dll has be correctly registered (should be done by installer" & vbCrLf & _
            "3) pdfStreamDumper has to be able to find the dll" & vbCrLf & vbCrLf & _
            "Initilization error message (if any) is: " & vbCrLf & vbCrLf & csharp.ErrorMessage, vbInformation
            
End Sub
