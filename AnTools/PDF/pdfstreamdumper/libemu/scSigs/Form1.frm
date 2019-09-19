VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "scSigs - Shellcode Signature Scanner - also uses libemu based unpacker"
   ClientHeight    =   8265
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   13485
   LinkTopic       =   "Form1"
   ScaleHeight     =   8265
   ScaleWidth      =   13485
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtHexString 
      Height          =   600
      Left            =   1260
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   14
      Top             =   7650
      Width           =   12165
   End
   Begin VB.TextBox txtStrings 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2400
      Left            =   7560
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   12
      Top             =   540
      Width           =   5775
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
      Height          =   1950
      Left            =   1305
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   3015
      Width           =   12120
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
      Height          =   2535
      Left            =   1260
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   5040
      Width           =   12210
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
      Height          =   2400
      Left            =   1305
      TabIndex        =   2
      Top             =   540
      Width           =   5595
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Scan File"
      Height          =   330
      Left            =   11880
      TabIndex        =   1
      Top             =   180
      Width           =   1545
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   1260
      OLEDropMode     =   1  'Manual
      TabIndex        =   0
      Text            =   "Drag n Drop shellcode file here"
      Top             =   135
      Width           =   10545
   End
   Begin VB.Label lblSaveUnpack 
      Caption         =   "Save Unpackd"
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
      Height          =   285
      Left            =   120
      TabIndex        =   18
      Top             =   1440
      Width           =   1245
   End
   Begin VB.Label Label7 
      Caption         =   "Code Sigs"
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
      Height          =   285
      Index           =   2
      Left            =   90
      TabIndex        =   17
      Top             =   2520
      Width           =   1005
   End
   Begin VB.Label Label7 
      Caption         =   "Hash Sigs"
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
      Height          =   285
      Index           =   1
      Left            =   90
      TabIndex        =   16
      Top             =   2280
      Width           =   1005
   End
   Begin VB.Label Label7 
      Caption         =   "String Sigs"
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
      Height          =   285
      Index           =   0
      Left            =   90
      TabIndex        =   15
      Top             =   2040
      Width           =   1005
   End
   Begin VB.Label Label4 
      Caption         =   "Unpack Hex String"
      Height          =   465
      Index           =   1
      Left            =   45
      TabIndex        =   13
      Top             =   7695
      Width           =   1095
   End
   Begin VB.Label Label6 
      Caption         =   "Strings"
      Height          =   285
      Left            =   6975
      TabIndex        =   11
      Top             =   585
      Width           =   1050
   End
   Begin VB.Label Command2 
      Caption         =   "Copy All"
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
      Height          =   285
      Left            =   135
      TabIndex        =   10
      Top             =   1170
      Width           =   1005
   End
   Begin VB.Label Label5 
      Caption         =   "About"
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
      Height          =   285
      Left            =   135
      TabIndex        =   9
      Top             =   855
      Width           =   1005
   End
   Begin VB.Label Label4 
      Caption         =   "Unpack HexDump"
      Height          =   555
      Index           =   0
      Left            =   90
      TabIndex        =   8
      Top             =   5085
      Width           =   1095
   End
   Begin VB.Label Label3 
      Caption         =   "Unpack Log"
      Height          =   240
      Left            =   135
      TabIndex        =   7
      Top             =   3060
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "Scan Results"
      Height          =   240
      Left            =   45
      TabIndex        =   6
      Top             =   585
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Shellcode File"
      Height          =   240
      Left            =   45
      TabIndex        =   5
      Top             =   180
      Width           =   1140
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim hashs As New Collection
Dim Strings As New Collection
Dim encoders As New Collection
Const LANG_US = &H409
Dim ap As String 'iside aware app.path

Private Declare Sub SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal _
    hWndInsertAfter As Long, ByVal x As Long, ByVal Y As Long, ByVal cx _
    As Long, ByVal cy As Long, ByVal wFlags As Long)
    
Private Const HWND_TOPMOST = -1
Private Const HWND_NOTOPMOST = -2

Dim SAVE_REPORT As Boolean 'assumes autorun no ui
Dim report_path As String

Dim unpacked() As Byte

'todo: scan for push 41414141 type strings and extract to AAAA

Function TopMost(f As Form, Optional ontop As Boolean = True)
    s = IIf(ontop, HWND_TOPMOST, HWND_NOTOPMOST)
    SetWindowPos f.hwnd, s, f.Left / 15, f.Top / 15, f.Width / 15, f.Height / 15, 0
End Function


Private Sub Command1_Click()
    On Error Resume Next
    Dim h As CApiHash
    Dim sc As String
    Dim ts As TextStream
    Dim wsh As New WshShell
    
    List1.Clear
    Text2 = Empty
    Text3 = Empty
    txtStrings = Empty
    txtHexString = Empty
    Erase unpacked
    Dim f As Long
    
    c = hashs.Count + Strings.Count + encoders.Count
    
    List1.AddItem "Scanning " & Text1 & " for " & c & " signatures"
    
    sc_hex = UCase(HexDump(ReadFile(Text1), 1))
    sc_byte = ReadFile(Text1)
    
    DoScans sc_hex, sc_byte
    txtStrings = Join(AsciiStrings(CStr(sc_byte)), vbCrLf)
    
    List1.AddItem "Running sample through libemu unpack routine..."
    
    WriteFile ap & "\tmp.sc", sc_byte
    
    If Not SAVE_REPORT Then TopMost Me
    Output = wsh.Exec(ap & "\scdbg.exe -nc -mm -d -f " & ap & "\tmp.sc").StdOut.ReadAll
    Output = Replace(Output, ap, ".")
    
    If FileExists(ap & "\tmp.unpack") Then
        List1.AddItem "Unpack found differences running scans again"
        sc_byte = ReadFile(ap & "\tmp.unpack")
        unpacked = GetFileBytes(ap & "\tmp.unpack")
        sc_hex = UCase(HexDump(sc_byte, 1))
        Text2 = HexDump(sc_byte)
        txtHexString = sc_hex
        DoScans sc_hex, sc_byte
        Kill ap & "\tmp.unpack"
        unpack_strings = Join(AsciiStrings(CStr(sc_byte)), vbCrLf)
        If Len(unpack_strings) > 0 Then
            txtStrings = "------[Initial Strings]------ " & vbCrLf & txtStrings & vbCrLf & vbCrLf & _
                         "------[Unpacked Strings]-----" & vbCrLf & unpack_strings
        End If
    Else
        List1.AddItem "Unpack found no changes"
    End If
    
    'TopMost Me, False
    Text3 = Replace(Output, vbLf, vbCrLf)
    Kill ap & "\tmp.sc"
    
    If SAVE_REPORT Then
        If FileExists(report_path) Then Kill report_path
        WriteFile report_path, GetReport()
        End
    End If
    
End Sub

Function DoScans(sc_hex, sc_byte)
    
    a = InStr(1, sc_byte, "http://", vbTextCompare)
    If a > 0 Then
        b = InStr(a, sc_byte, Chr(0))
        If b < 1 Then b = Len(sc_byte)
        List1.AddItem "Extracted URL: " & Mid(sc_byte, a, b - a)
    End If
    
    For Each h In hashs 'checks for hash as both little endian and big endian
        m = InStr(sc_hex, h.hSwapped) / 2
        If m > 0 Then
            List1.AddItem "0x" & Hex(m) & vbTab & h.hName & " (hash match)"
        End If
        m = InStr(sc_hex, h.hRegular) / 2
        If m > 0 Then
            List1.AddItem "0x" & Hex(m) & vbTab & h.hName & " (hash match (Rev))"
        End If
    Next
    
    For Each s In Strings
        If InStr(s, ";") > 0 Then
            s = Split(s, ";") 'there is a display comment embedded
            m = InStr(1, sc_byte, s(0), vbTextCompare)
            If m > 0 Then
                List1.AddItem "0x" & Hex(m) & vbTab & s(0) & " Comment: " & s(1) & " (string match)"
            End If
        Else
            m = InStr(1, sc_byte, s, vbTextCompare)
            If m > 0 Then
                List1.AddItem "0x" & Hex(m) & vbTab & s & " (string match)"
            End If
        End If
    Next
    
    For Each e In encoders
        If InStr(e, ":") > 0 Then
            s = Split(e, ":") 'format: name:<tab or space>hexstring
            n = s(0)
            s = Replace(s(1), vbTab, Empty)
            s = Trim(Replace(s, " ", Empty))
            m = InStr(1, sc_hex, s, vbTextCompare)
            If m > 0 Then
                List1.AddItem "0x" & Hex(m) & vbTab & n & " (signature)"
            End If
        End If
    Next
End Function

Private Sub Command2_Click()
    tmp = GetReport()
    Clipboard.Clear
    Clipboard.SetText tmp
    MsgBox Len(tmp) & " bytes copied", vbInformation
End Sub

Private Function GetReport()
    On Error Resume Next
    div = vbCrLf & String(50, "-") & vbCrLf
    
    tmp = "Sigs Log:" & div
    For i = 0 To List1.ListCount
        tmp = tmp & List1.List(i) & vbCrLf
    Next
    tmp = tmp & vbCrLf & "Unpack Log:" & div & Text3
    If Len(txtStrings) > 0 Then tmp = tmp & vbCrLf & vbCrLf & "Strings: " & div & txtStrings
    If Len(Text2) > 0 Then tmp = tmp & vbCrLf & vbCrLf & "Unpacked HexDump: " & div & Text2
    If Len(txtHexString) > 0 Then tmp = tmp & vbCrLf & vbCrLf & "Unpacked HexString: " & div & txtHexString
    
    GetReport = tmp
    
End Function
Private Sub Form_Load()
    
    
    ap = IIf(isIde(), App.path & "\..\", App.path)
    
    tmp = ReadFile(ap & "\shellcode_hashs.txt")
    tmp = Split(tmp, vbCrLf)
    Dim h As CApiHash
    On Error Resume Next
    
    For Each X1 In tmp
        Set h = New CApiHash
        If Len(X1) > 0 And InStr(X1, ";") > 0 And VBA.Left(X1, 1) <> "#" Then
            x = Split(X1, ";")
            h.hConst = Trim(x(0))
            h.hName = Trim(x(1))
            h.SetLilEndian
            hashs.Add h, h.hName 'key ensures unique only, prefix api by something to say where came from like msf. = metasploit
        End If
    Next
    
    tmp = ReadFile(ap & "\string_matches.txt")
    tmp = Split(tmp, vbCrLf)
    For Each x In tmp
        If Len(x) > 0 And VBA.Left(x, 1) <> "#" Then Strings.Add x, x
    Next
    
    tmp = ReadFile(ap & "\encoders.txt")
    tmp = Split(tmp, vbCrLf)
    For Each x In tmp
        If Len(x) > 0 And VBA.Left(x, 1) <> "#" Then encoders.Add x, x
    Next
    
    If Len(Command) > 0 Then
        a = InStr(1, Command, "/SAVE_REPORT:", vbTextCompare)
        If a > 0 Then
            SAVE_REPORT = True
            Text1 = Trim(Mid(Command, 1, a - 1))
            Text1 = Replace(Text1, """", Empty)
            report_path = Mid(Command, a + Len("/SAVE_REPORT:"))
            report_path = Replace(report_path, """", Empty)
            Me.Visible = False 'assumes autorun no ui
        Else
            Text1 = Replace(Command, """", Empty)
        End If
        Command1_Click
    End If
    
End Sub

Function isIde() As Boolean
    On Error GoTo hell
    Debug.Print 1 / 0
    isIde = False
    Exit Function
hell:
    isIde = True
End Function

Private Sub Label5_Click()
    MsgBox "Scans shellcode for static signatures. Also tries to run shellcode through " & _
           "libemu based unpacker and then rescans for signatures " & _
           "use /save_report:[path] option if doing an automation run." & vbCrLf & vbCrLf & _
           "You can drop a sc file on icon to run it, or drop file in top textbox"
End Sub

Private Sub Label7_Click(Index As Integer)
    On Error Resume Next
    Select Case Index
        Case 0: p = ap & "\string_matches.txt"
        Case 1: p = ap & "\shellcode_hashs.txt"
        Case 2: p = ap & "\encoders.txt"
    End Select
    
    If FileExists(p) Then
        Shell "notepad.exe """ & p & """", vbNormalFocus
    Else
        MsgBox "Signature file not found: " & p, vbInformation
    End If
    
End Sub

Private Sub lblSaveUnpack_Click()
    On Error Resume Next
    x = UBound(unpacked)
    If x > 0 Then
        pth = Text1 & ".unpack"
        Dim f As Long
        f = FreeFile
        If FileExists(pth) Then Kill pth
        Open pth For Binary As f
        Put f, , unpacked()
        Close f
        MsgBox UBound(unpacked) & " bytes saved to: " & vbCrLf & vbCrLf & pth, vbInformation
    Else
        MsgBox "Unpack buffer does not appear to have been loaded yet.", vbInformation
    End If
End Sub

Private Sub Text1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
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
        push ret(), Replace(m.Value, Chr(0), Empty)
    Next
    
    AsciiStrings = ret()
    
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
        x = ary(i)
        chars = chars & IIf((x > 32 And x < 127) Or x > 191, Chr(x), ".")
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

Sub push(ary, Value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = Value
    Exit Sub
init: ReDim ary(0): ary(0) = Value
End Sub

Function GetFileBytes(filename) As Byte()
    Dim b() As Byte
    f = FreeFile
    Open filename For Binary As #f        ' Open file.(can be text or image)
    ReDim b(LOF(f))
    Get f, , b()
    Close #f
    GetFileBytes = b()
End Function

Function ReadFile(filename)
  f = FreeFile
  temp = ""
   Open filename For Binary As #f        ' Open file.(can be text or image)
     temp = Input(FileLen(filename), #f) ' Get entire Files data
   Close #f
   ReadFile = temp
End Function

Sub WriteFile(path, it)
    f = FreeFile
    Open path For Output As #f
    Print #f, it
    Close f
End Sub

Function FileExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbHidden Or vbNormal Or vbReadOnly Or vbSystem) <> "" Then FileExists = True _
  Else FileExists = False
End Function

Function GetParentFolder(path) As String
    tmp = Split(path, "\")
    ub = tmp(UBound(tmp))
    GetParentFolder = Replace(Join(tmp, "\"), "\" & ub, "")
End Function

