VERSION 5.00
Begin VB.Form frmAryReplace 
   Caption         =   "Array Element String Replacement"
   ClientHeight    =   7290
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8940
   LinkTopic       =   "Form3"
   ScaleHeight     =   7290
   ScaleWidth      =   8940
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdReplace 
      Caption         =   "Replace"
      Height          =   330
      Left            =   5400
      TabIndex        =   12
      Top             =   630
      Width           =   1005
   End
   Begin VB.TextBox txtReplace 
      Height          =   330
      Left            =   4095
      TabIndex        =   11
      Top             =   630
      Width           =   1185
   End
   Begin VB.TextBox txtFind 
      Height          =   330
      Left            =   2700
      TabIndex        =   10
      Top             =   630
      Width           =   1140
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Example"
      Height          =   375
      Left            =   7470
      TabIndex        =   8
      Top             =   90
      Width           =   1365
   End
   Begin VB.TextBox txtSeperator 
      Height          =   285
      Left            =   4095
      TabIndex        =   6
      Text            =   "\r\n"
      Top             =   45
      Width           =   1185
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Update Parent Script"
      Height          =   375
      Left            =   6885
      TabIndex        =   4
      Top             =   6795
      Width           =   1860
   End
   Begin VB.TextBox txtElements 
      Height          =   5595
      Left            =   1035
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   1080
      Width           =   7755
   End
   Begin VB.TextBox txtAName 
      Height          =   330
      Left            =   1080
      TabIndex        =   1
      Top             =   45
      Width           =   1410
   End
   Begin VB.Label Label5 
      Caption         =   "Find                                                                                       (supports \r\n)"
      Height          =   330
      Left            =   2250
      TabIndex        =   9
      Top             =   675
      Width           =   5325
   End
   Begin VB.Label Label4 
      Caption         =   "?"
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
      Height          =   195
      Left            =   5715
      TabIndex        =   7
      Top             =   90
      Width           =   240
   End
   Begin VB.Label Label3 
      Caption         =   "Seperator"
      Height          =   240
      Left            =   3240
      TabIndex        =   5
      Top             =   90
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "Array Elements"
      Height          =   240
      Left            =   90
      TabIndex        =   2
      Top             =   765
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Array Name"
      Height          =   240
      Left            =   90
      TabIndex        =   0
      Top             =   90
      Width           =   870
   End
End
Attribute VB_Name = "frmAryReplace"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdReplace_Click()
    Dim x
    x = Replace(txtReplace, "\r", vbCr)
    x = Replace(x, "\n", vbLf)
    txtElements = Replace(txtElements, txtFind, x)
End Sub

Private Sub Command1_Click()
    
    'Dim topLine As Long
    'topLine = Form2.txtJS.FirstVisibleLine
    
    tmp = Form2.txtJS.Text
    txtAName = Trim(txtAName)
    
    If Len(txtElements) = 0 Then
        MsgBox "No elements provided"
        Exit Sub
    End If
    
    If Len(txtSeperator) = 0 Then
        MsgBox "No seperator provided"
        Exit Sub
    End If
    
    If Len(txtAName) = 0 Then
        MsgBox "No array variable name provided"
        Exit Sub
    End If
    
    If InStr(tmp, txtAName) < 1 Then
         MsgBox "Array variable not found in js text?"
         Exit Sub
    End If
    
    Dim elems() As String
    
    s = Replace(txtSeperator, "\r", vbCr)
    s = Replace(s, "\n", vbLf)
    s = Replace(s, "\t", vbTab)
     
    elems = Split(txtElements, s)
    If UBound(elems) < 1 Then
         MsgBox "Split at " & txtElements & " was unsuccessful expecting many elements"
         Exit Sub
    End If
    
    Form2.SaveToListView Form2.txtJS.Text, "Before AryReplace" 'save a copy of the original
    
    For i = 0 To UBound(elems)
        If InStr(elems(i), """") > 0 Then elems(i) = Replace(elems(i), """", "\x22") 'so we dont break js quoted strings..
        tmp = Replace(tmp, txtAName & "[" & i & "]", """" & elems(i) & """")
    Next
    
    Form2.txtJS.Text = tmp
    'Form2.txtJS.FirstVisibleLine = topLine
    
End Sub

Private Sub Command2_Click()
    txtSeperator = "\r\n"
    Form2.txtJS.Text = "//Array replace example" & vbCrLf & "document[ary[0]][ary[1]] = ary[2]" & vbCrLf & "//" & String(50, "-") & vbCrLf & vbCrLf & Form2.txtJS.Text
    txtAName = "ary"
    txtElements = Join(Array("location", "href", "http://sandsprite.com"), vbCrLf)
    Me.SetFocus
End Sub

Private Sub Label4_Click()
    MsgBox "This tool is designed to update the parent script where a bunch " & vbCrLf & _
            "of strings have been decoded and are being held in an array." & vbCrLf & _
            "" & vbCrLf & _
            "provide the array variable name, element list and seperator" & vbCrLf & _
            "and this will update the parent script."
End Sub

