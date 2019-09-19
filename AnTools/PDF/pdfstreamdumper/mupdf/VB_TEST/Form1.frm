VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5130
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10125
   LinkTopic       =   "Form1"
   ScaleHeight     =   5130
   ScaleWidth      =   10125
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command4 
      Caption         =   "JBIg Exploit"
      Height          =   555
      Left            =   8730
      TabIndex        =   4
      Top             =   1380
      Width           =   1275
   End
   Begin VB.CommandButton Command3 
      Caption         =   "FaxDecode"
      Height          =   525
      Left            =   8730
      TabIndex        =   3
      Top             =   2220
      Width           =   1245
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4695
      Left            =   150
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   2
      Text            =   "Form1.frx":0000
      Top             =   150
      Width           =   8445
   End
   Begin VB.CommandButton Command2 
      Caption         =   "JBIG2"
      Height          =   525
      Left            =   8730
      TabIndex        =   1
      Top             =   750
      Width           =   1245
   End
   Begin VB.CommandButton Command1 
      Caption         =   "AsciiHex"
      Height          =   525
      Left            =   8760
      TabIndex        =   0
      Top             =   90
      Width           =   1245
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'int __stdcall AsciiHexDecode(char* buf, unsigned char** bufOut)
Private Declare Function AsciiHexDecode Lib "mupdf.dll" (ByRef buf As Byte, ByRef bufOut As Long) As Long

'int __stdcall JBIG2Decode(unsigned char* buf, int sz, unsigned char** bufOut){
Private Declare Function JBIG2Decode_Native Lib "mupdf.dll" Alias "JBIG2Decode" (ByRef buf As Byte, ByVal sz As Long, ByRef bufOut As Long) As Long

Private Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
    (ByRef dest As Byte, ByVal src As Long, ByVal Length As Long)

Private Declare Sub FreeBuffer Lib "mupdf.dll" (ByRef handle As Long)

Const LANG_US = &H409

'int __stdcall FaxDecode(unsigned char* buf, int sz, unsigned char** bufOut,
'              int cols=1728, int rows=0, int k=0, int end_of_line=0, int encoded_byte_align=0,
'              int end_of_block=1, int black_is_1=0)
Private Declare Function FaxDecode_Native Lib "mupdf.dll" Alias "FaxDecode" _
        (ByRef buf As Byte, ByVal sz As Long, ByRef bufOut As Long, ByVal cols As Long, ByVal rows As Long, _
        ByVal k As Long, ByVal eol As Long, ByVal eba As Long, ByVal eob As Long, ByVal isblk As Long _
        ) As Long

Function CCTIFaxDecode(data As String, Optional cols As Long = 1728, Optional rows As Long = 0, _
    Optional k As Long = 0, Optional end_of_line As Long = 0, Optional encoded_byte_align As Long = 0, _
    Optional end_of_block As Long = 1, Optional black_is1 As Long = 0)
    
    Dim pBufOut As Long
    Dim outSize As Long
    Dim bin() As Byte
    Dim b() As Byte
       
    pBufOut = &HDEADBEEF
    bin = StrConv(data, vbFromUnicode, LANG_US)
    outSize = FaxDecode_Native(bin(0), UBound(bin) + 1, pBufOut, cols, rows, k, end_of_line, encoded_byte_align, end_of_block, black_is1)
    
    f = "SizeIn: " & Hex(UBound(bin)) & vbCrLf & _
           "OutSize: " & Hex(outSize) & vbCrLf & _
           "*bufOut: " & Hex(pBufOut) & vbCrLf
           
    'MsgBox f
    
    If outSize = 0 Then Exit Function
   
    ReDim b(outSize - 1)
    CopyMemory b(0), pBufOut, outSize
    CCTIFaxDecode = StrConv(b(), vbUnicode, LANG_US)
    FreeBuffer pBufOut
    
End Function

Function JBIG2Decode(data As String) As String
    
    Dim pBufOut As Long
    Dim outSize As Long
    Dim bin() As Byte
    Dim b() As Byte
       
    pBufOut = &HDEADBEEF
    bin = StrConv(data, vbFromUnicode, LANG_US)
    outSize = JBIG2Decode_Native(bin(0), UBound(bin) + 1, pBufOut)
    
    f = "SizeIn: " & Hex(UBound(bin)) & vbCrLf & _
           "OutSize: " & Hex(outSize) & vbCrLf & _
           "*bufOut: " & Hex(pBufOut) & vbCrLf
           
    'MsgBox f
    If outSize = 0 Then Exit Function
   
    ReDim b(1 To outSize)
    CopyMemory b(1), pBufOut, outSize
    JBIG2Decode = StrConv(b(), vbUnicode, LANG_US)
    FreeBuffer pBufOut
    
End Function


Private Sub Command1_Click()
    
    Const data = "6D796D6573736167650041"
    
    Dim pBufOut As Long
    Dim outSize As Long
    Dim bin() As Byte
    Dim b() As Byte
       
    pBufOut = &HDEADBEEF
    bin = StrConv(data, vbFromUnicode, LANG_US)
    outSize = AsciiHexDecode(bin(0), pBufOut)
    
    f = "SizeIn: 0x" & Hex(UBound(bin)) & vbCrLf & _
           "OutSize: 0x" & Hex(outSize) & vbCrLf & _
           "*bufOut: 0x" & Hex(pBufOut) & vbCrLf
           
    MsgBox f
    If outSize = 0 Then Exit Sub
   
    ReDim b(outSize - 1)
    CopyMemory b(0), pBufOut, outSize
    Text1 = StrConv(b(), vbUnicode, LANG_US)
    FreeBuffer pBufOut
    
    MsgBox HexDump(StrConv(b(), vbUnicode, LANG_US))
    
End Sub


Private Sub Command2_Click()
    Dim f As String
    
    f = App.path & "\..\sample_data\js.jb2"
    If Not FileExists(f) Then
        MsgBox "Sample data not found!", vbInformation
        Exit Sub
    End If
    
    f = ReadFile(f)
    
    For i = 0 To 1000
        Me.Caption = i
        Text1 = JBIG2Decode(f)
        DoEvents
    Next
    
    
End Sub


Private Sub Command3_Click()

    Dim f As String
    
    f = App.path & "\..\sample_data\ccit_data.bin"
    If Not FileExists(f) Then
        MsgBox "Sample data not found!", vbInformation
        Exit Sub
    End If
    
    f = ReadFile(f)
    Text1 = CCTIFaxDecode(f, 26128, 2)
    
End Sub

Private Sub Command4_Click()
    
    Dim f As String
    
    f = App.path & "\..\sample_data\malformed.jb2"
    If Not FileExists(f) Then
        MsgBox "Sample data not found!", vbInformation
        Exit Sub
    End If
    
    f = ReadFile(f)
    Text1 = JBIG2Decode(f)
    If Len(Text1) = 0 Then Text1 = "Failed to decode JBIG2 stream. Malformed?"
    
End Sub

Private Sub Form_Load()
    Dim dll As String
    Dim hDll As Long
    dll = App.path & "\..\..\mupdf.dll"
    If Not FileExists(dll) Then
        MsgBox "Dll not found!"
    Else
        hDll = LoadLibrary(dll)
        If hDll = 0 Then
            MsgBox "Dll failed to load!"
        End If
    End If
End Sub


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
        'chars = chars & IIf((x > 32 And x < 127) Or x > 191, Chr(x), ".") 'x > 191 causes \x0 problems on non us systems... asc(chr(x)) = 0
        chars = chars & IIf((x > 32 And x < 127), Chr(x), ".")
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

Function ReadFile(filename) As String 'this one should be binary safe...
  On Error GoTo hell
  f = FreeFile
  Dim b() As Byte
  Open filename For Binary As #f
  ReDim b(LOF(f) - 1)
  Get f, , b()
  Close #f
  ReadFile = StrConv(b(), vbUnicode, LANG_US)
  Exit Function
hell:   ReadFile = ""
End Function

Function FileExists(path) As Boolean
  On Error Resume Next
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbHidden Or vbNormal Or vbReadOnly Or vbSystem) <> "" Then
     If Err.Number <> 0 Then Exit Function
     FileExists = True
  End If
End Function

Public Function isIde() As Boolean
    On Error GoTo hell
    Debug.Print 1 / 0
    isIde = False
    Exit Function
hell:
    isIde = True
End Function

