VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form Form1 
   Caption         =   "Xor Brute Forcer"
   ClientHeight    =   6435
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   13125
   LinkTopic       =   "Form1"
   ScaleHeight     =   6435
   ScaleWidth      =   13125
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ProgressBar pb 
      Height          =   780
      Left            =   675
      TabIndex        =   8
      Top             =   2385
      Visible         =   0   'False
      Width           =   12165
      _ExtentX        =   21458
      _ExtentY        =   1376
      _Version        =   393216
      Appearance      =   1
   End
   Begin VB.CheckBox chkShowAll 
      Caption         =   "Show All"
      Height          =   330
      Left            =   10125
      TabIndex        =   7
      Top             =   90
      Width           =   960
   End
   Begin VB.TextBox Text4 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1935
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   6
      Top             =   3840
      Width           =   2895
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Send Selected to scsigs"
      Height          =   495
      Left            =   240
      TabIndex        =   5
      Top             =   5880
      Width           =   2655
   End
   Begin VB.TextBox Text3 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2040
      Left            =   3060
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   495
      Width           =   9960
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
      Height          =   3750
      Left            =   3105
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   2565
      Width           =   9960
   End
   Begin MSComctlLib.ListView ListView1 
      Height          =   3300
      Left            =   105
      TabIndex        =   2
      Top             =   495
      Width           =   2835
      _ExtentX        =   5001
      _ExtentY        =   5821
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
      NumItems        =   2
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "Key"
         Object.Width           =   1764
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "Match"
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Xor BruteForcer"
      Height          =   330
      Left            =   11115
      TabIndex        =   1
      Top             =   90
      Width           =   1905
   End
   Begin VB.TextBox Text1 
      Height          =   330
      Left            =   225
      OLEDropMode     =   1  'Manual
      TabIndex        =   0
      Top             =   90
      Width           =   9825
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Const LANG_US = &H409

Dim matches() As String
Dim selli As ListItem
Dim fbuf() As Byte
Dim hashs As New Collection

'should i have this do a couple of hash scans too? might help detect the xor key if no strings.

Function GetKeyFromLi(li As ListItem) As Byte
    On Error Resume Next
    k = Replace(li.Text, "Key: 0x", Empty)
    GetKeyFromLi = CByte(CLng("&h" & k))
End Function

Private Sub Command2_Click()
    On Error Resume Next
    If selli Is Nothing Then Exit Sub
    Dim b As Byte
    Dim tmp() As Byte
    Dim f As Long
    
    
    b = GetKeyFromLi(selli)
    tmp = fbuf()
    
    For i = 0 To UBound(tmp)
        tmp(i) = tmp(i) Xor b
    Next
    
    pth = App.path & "\..\libemu"
    If Not FolderExists(pth) Then
        MsgBox "Path not found: " & pth
        Exit Sub
    End If
    
    scsigs = pth & "\scsigs.exe"
    If Not FileExists(scsigs) Then
        MsgBox "Scsigs not found: " & scsigs
        Exit Sub
    End If
    
    sample = pth & "\sample.sc"
    f = FreeFile
    Open sample For Binary As f
    Put f, , tmp
    Close f
    
    Shell scsigs & " """ & sample & """", vbNormalFocus
    
End Sub

'should i add support for 2 and 4 byte keys? 4 would take waaaayy longer.

Private Sub Form_Load()

    s = "LoadLibrary,GetProcAddress,CreateProcessCreateFile,WinExec,http,exe,Urldownload"
    
    hh = "0x0C917432 ; ror7.LoadLibraryA" & vbCrLf & _
         "0xBBAFDF85 ; ror7.GetProcAddress" & vbCrLf & _
         "0x01A22F51 ; ror7.WinExec" & vbCrLf & _
         "0x9AAFD680 ; ror7.URLDownloadToFileA" & vbCrLf & _
         "0xEC0E4E8E ; rorD.LoadLibraryA" & vbCrLf & _
         "0x7C0DFCAA ; rorD.GetProcAddress" & vbCrLf & _
         "0x0E8AFE98 ; rorD.WinExec" & vbCrLf & _
         "0x702F1A36 ; rorD.URLDownloadToFileA" & vbCrLf & _
         "0x321C2188 ; harmony.UrlDownloadToFileA" & vbCrLf & _
         "0x876F8B31 ; harmony.WinExec" & vbCrLf & _
         "0x7802F749 ; harmony.GetProcAddress" & vbCrLf & _
         "0x0726774C ; harmony.LoadLibraryA"
    
    Dim h As CAPIHash
    On Error Resume Next
    
    Me.Visible = True
    Me.Refresh
    DoEvents
    
    tmp = Split(hh, vbCrLf)
    
    For Each X1 In tmp
        Set h = New CAPIHash
        If Len(X1) > 0 And InStr(X1, ";") > 0 And VBA.Left(X1, 1) <> "#" Then
            X = Split(X1, ";")
            h.hConst = Trim(X(0))
            h.hName = Trim(X(1))
            h.SetLilEndian
            hashs.Add h, h.hName 'key ensures unique only, prefix api by something to say where came from like msf. = metasploit
        End If
    Next
    
    matches() = Split(s, ",")
    
    If Len(Command) > 0 Then
        Text1 = Replace(Command, """", Empty)
        If FileExists(Text1) Then
            Command1_Click
        Else
            End
        End If
    End If
    
End Sub

Private Sub Command1_Click()

    Dim X() As Byte
    Dim b As Byte
    Dim i As Byte
    Dim li As ListItem
    Dim f As Long
    Dim tmp
    
    Set selli = Nothing
    If Not FileExists(Text1) Then Exit Sub
    
    ListView1.ListItems.Clear
    Text2 = Empty
    
    f = FreeFile
    Open Text1 For Binary As f
    ReDim X(LOF(f))
    Get f, , X()
    Close f
    
    fbuf() = X() 'save a copy for latter
    Dim found As String
    pb.Visible = True
    pb.Max = 255
    pb.value = 1
    
    For i = 1 To 254
        pb.value = i
        DoEvents
        pb.Refresh
        tmp = d(X(), i)
        sc_hex = UCase(HexDump(tmp, 1))
        If FindMatches(tmp, sc_hex, found) Or chkShowAll.value = 1 Then
            Set li = ListView1.ListItems.Add(, , "Key: 0x" & Hex(i))
            li.SubItems(1) = found
            li.Tag = tmp
        End If
    Next
    
    If ListView1.ListItems.Count > 0 Then
        
        If ListView1.ListItems.Count = 2 Then
            Dim b1 As Byte, b2 As Byte
            b1 = GetKeyFromLi(ListView1.ListItems(1))
            b2 = GetKeyFromLi(ListView1.ListItems(2))
            xX = b2 - b1
            If Abs(xX) = &H20 Then 'its the upper/lower case double match see if we can trim
                l1 = Len(ListView1.ListItems(1).SubItems(1))
                l2 = Len(ListView1.ListItems(2).SubItems(1)) 'number of matches
                If l1 > l2 Then ListView1.ListItems.Remove 2
                If l2 > l1 Then ListView1.ListItems.Remove 1
            End If
        End If
                
        ListView1_ItemClick ListView1.ListItems(1)
    Else
        Text3 = "No results found."
    End If
    
    pb.Visible = False

End Sub



Function d(b() As Byte, k As Byte) As String
    
    Dim s As String
    
    For i = 0 To UBound(b)
        s = s & Chr(b(i) Xor k)
    Next
    
    d = Replace(s, Chr(0), ".")
    
End Function




Function FindMatches(sIn, sc_hex, matches_out) As Boolean
    Dim i As Integer
    Dim h As CAPIHash
    
    matches_out = Empty
    
    For Each m In matches
        If Len(m) > 0 And InStr(1, sIn, m, vbTextCompare) > 0 Then
            'If Asc(VBA.Left(m, 1)) = &H90 Then m = "NOPNOP" 'to many false positives and not really in decoded part of payload anyway.
            matches_out = matches_out & m & ","
            FindMatches = True
        End If
    Next
    
    For Each h In hashs 'checks for hash as both little endian and big endian
        m = InStr(sc_hex, h.hSwapped)
        m2 = InStr(sc_hex, h.hRegular)
        If m > 0 Or m2 > 0 Then
            matches_out = matches_out & h.hName & ","
        End If
    Next
    
    If Right(matches_out, 1) = "," Then matches_out = Mid(matches_out, 1, Len(matches_out) - 1)
    
End Function

Function ReadFile(filename)
  f = FreeFile
  temp = ""
   Open filename For Binary As #f        ' Open file.(can be text or image)
     temp = Input(FileLen(filename), #f) ' Get entire Files data
   Close #f
   ReadFile = temp
End Function

Function FileExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbHidden Or vbNormal Or vbReadOnly Or vbSystem) <> "" Then FileExists = True _
  Else FileExists = False
End Function



Function HexDump(ByVal str, Optional hexOnly = 0) As String
    Dim s() As String, chars As String, tmp As String
    On Error Resume Next
    Dim ary() As Byte
    Dim offset As Long
    
    offset = 0
    str = " " & str
    ary = StrConv(str, vbFromUnicode, LANG_US)
    
    chars = "   "
    For i = 1 To UBound(ary)
        tt = Hex(ary(i))
        If Len(tt) = 1 Then tt = "0" & tt
        tmp = tmp & tt & " "
        X = ary(i)
        chars = chars & IIf((X > 32 And X < 127) Or X > 191, Chr(X), ".")
        If i > 1 And i Mod 16 = 0 Then
            h = Hex(offset)
            While Len(h) < 6: h = "0" & h: Wend
            If hexOnly = 0 Then
                push s, h & "   " & tmp & chars
            Else
                push s, tmp
            End If
            offset = offset + 16
            tmp = Empty
            chars = "   "
        End If
    Next
    'if read length was not mod 16=0 then
    'we have part of line to account for
    If tmp <> Empty Then
        If hexOnly = 0 Then
            h = Hex(offset)
            While Len(h) < 6: h = "0" & h: Wend
            h = h & "   " & tmp
            While Len(h) <= 56: h = h & " ": Wend
            push s, h & chars
        Else
            push s, tmp
        End If
    End If
    
    HexDump = Join(s, vbCrLf)
    
    If hexOnly <> 0 Then
        HexDump = Replace(HexDump, " ", "")
        HexDump = Replace(HexDump, vbCrLf, "")
    End If
    
End Function



Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    Dim X As Long
    X = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init:     ReDim ary(0): ary(0) = value
End Sub

Private Sub ListView1_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    Text2 = HexDump(Item.Tag)
    Text3 = "Strings:" & vbCrLf & Join(AsciiStrings(Item.Tag), vbCrLf)
    Text4 = Replace(Item.SubItems(1), ",", vbCrLf)
    Set selli = Item
End Sub

Private Sub Text1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    On Error Resume Next
    Text1 = Data.Files(1)
    Command1_Click
End Sub

Function AsciiStrings(buf As String) As String()
    
    On Error Resume Next
    Dim d As New RegExp
    Dim mc As MatchCollection
    Dim m As Match
    Dim ret() As String

    Const minStrLen = 4
    'd.Pattern = "[a-z,A-Z,0-9 /?.\-_=+$\\@!*\(\)#]{4,}" 'ascii string search
    d.Pattern = "[\w0-9 /?.\-_=+$\\@!*\(\)#%~`\^&\|\{\}\[\]:;'""<>\,]{" & minStrLen & ",}"
    d.Global = True
        
    Set mc = d.Execute(buf)
    
    For Each m In mc
        push ret(), Replace(m.value, Chr(0), Empty)
    Next
    
    AsciiStrings = ret()
    
End Function



Function FolderExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbDirectory) <> "" Then FolderExists = True _
  Else FolderExists = False
End Function

Sub WriteFile(path, it)
    f = FreeFile
    Open path For Output As #f
    Print #f, it
    Close f
End Sub
