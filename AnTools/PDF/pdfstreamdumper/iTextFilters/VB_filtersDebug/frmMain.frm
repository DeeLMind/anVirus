VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5595
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14085
   LinkTopic       =   "Form1"
   ScaleHeight     =   5595
   ScaleWidth      =   14085
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "Load Raw"
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   5310
      Width           =   1455
   End
   Begin VB.ListBox List1 
      Height          =   4935
      Left            =   0
      TabIndex        =   6
      Top             =   120
      Width           =   3135
   End
   Begin VB.CommandButton Command1 
      Caption         =   "LZWDecode"
      Height          =   255
      Index           =   4
      Left            =   4200
      TabIndex        =   5
      Top             =   5280
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "ASCII85Decode"
      Height          =   255
      Index           =   3
      Left            =   5520
      TabIndex        =   4
      Top             =   5280
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "ASCIIHexDecode"
      Height          =   255
      Index           =   2
      Left            =   2040
      TabIndex        =   3
      Top             =   5280
      Width           =   2055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "FlateDecode"
      Height          =   255
      Index           =   1
      Left            =   9000
      TabIndex        =   2
      Top             =   5280
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "RunLengthD"
      Height          =   255
      Index           =   0
      Left            =   7680
      TabIndex        =   1
      Top             =   5280
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5055
      Left            =   3240
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   120
      Width           =   10695
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim filters As New CSharpFilters
Dim buf As String

Private Sub Command1_Click(Index As Integer)
    
    Dim hadErr As Boolean
    If filters.Decode(buf, CLng(Index), False) Then
        buf = filters.DecodedBuffer
        Text1 = Hexdump(buf)
        List1.AddItem filters.ErrorMessage & " Buf: 0x" & Hex(Len(buf))
    Else
        MsgBox filters.ErrorMessage
    End If
    
End Sub

Function ReadFile(filename)
  f = FreeFile
  Temp = ""
   Open filename For Binary As #f        ' Open file.(can be text or image)
     Temp = Input(FileLen(filename), #f) ' Get entire Files data
   Close #f
   ReadFile = Temp
End Function

Private Sub Command2_Click()
    buf = ReadFile(App.path & "\..\raw.dat")
    Text1 = Hexdump(buf)
    List1.Clear
End Sub

Private Sub Form_Load()
    Command2_Click
End Sub


Function Hexdump(ByVal str, Optional hexOnly = 0) As String
    Dim s() As String, chars As String, tmp As String
    On Error Resume Next
    Dim ary() As Byte
    Dim offset As Long
    
    offset = 0
    str = " " & str
    ary = StrConv(str, vbFromUnicode)
    
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
    
    Hexdump = Join(s, vbCrLf)
    
    If hexOnly <> 0 Then
        Hexdump = Replace(Hexdump, " ", "")
        Hexdump = Replace(Hexdump, vbCrLf, "")
    End If
    
End Function

Private Sub push(ary, Value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = Value
    Exit Sub
init: ReDim ary(0): ary(0) = Value
End Sub
