VERSION 5.00
Object = "{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}#1.0#0"; "msscript.ocx"
Object = "{2668C1EA-1D34-42E2-B89F-6B92F3FF627B}#5.0#0"; "scivb2.ocx"
Begin VB.Form frmEvalSelection 
   Caption         =   "EvalSelection"
   ClientHeight    =   6255
   ClientLeft      =   15000
   ClientTop       =   7620
   ClientWidth     =   12435
   LinkTopic       =   "Form3"
   ScaleHeight     =   6255
   ScaleWidth      =   12435
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox chkIgnoreSelects 
      Caption         =   "Ignore Selects"
      Height          =   255
      Left            =   240
      TabIndex        =   15
      Top             =   2880
      Width           =   1325
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H8000000C&
      BorderStyle     =   0  'None
      Height          =   2175
      Left            =   0
      TabIndex        =   8
      Top             =   3960
      Width           =   12495
      Begin VB.TextBox txtEval 
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   855
         Left            =   1560
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   12
         Top             =   0
         Width           =   10695
      End
      Begin VB.CommandButton cmdEval 
         Caption         =   "Eval"
         Height          =   375
         Left            =   0
         TabIndex        =   11
         Top             =   360
         Width           =   1455
      End
      Begin VB.TextBox txtOutput 
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   855
         Left            =   1560
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   10
         Top             =   960
         Width           =   10695
      End
      Begin VB.CommandButton cmdInsert 
         Caption         =   "Replace Selection"
         Height          =   375
         Left            =   0
         TabIndex        =   9
         Top             =   1440
         Width           =   1455
      End
      Begin MSScriptControlCtl.ScriptControl sc 
         Left            =   240
         Top             =   1920
         _ExtentX        =   1005
         _ExtentY        =   1005
         Language        =   "jscript"
         UseSafeSubset   =   -1  'True
      End
      Begin VB.Label lblCopyUp 
         Caption         =   "^ move"
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
         Left            =   960
         TabIndex        =   16
         Top             =   120
         Width           =   615
      End
      Begin VB.Label Label1 
         Caption         =   "Selection"
         Height          =   255
         Left            =   0
         TabIndex        =   14
         Top             =   120
         Width           =   735
      End
      Begin VB.Label Label2 
         Caption         =   "Output"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   1080
         Width           =   855
      End
   End
   Begin VB.CheckBox chkAllowActX 
      Caption         =   "Allow ActiveX"
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   2520
      Width           =   1305
   End
   Begin sci2.SciSimple txtLibCode 
      Height          =   3615
      Left            =   1560
      TabIndex        =   6
      Top             =   240
      Width           =   10695
      _ExtentX        =   18865
      _ExtentY        =   6376
   End
   Begin VB.CommandButton cmdHelp 
      Caption         =   "?"
      Height          =   495
      Left            =   0
      TabIndex        =   5
      Top             =   3240
      Width           =   495
   End
   Begin VB.CheckBox chkQuoteResult 
      Caption         =   "Quote result"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   2160
      Width           =   1215
   End
   Begin VB.CheckBox chkAutoReplace 
      Caption         =   "Auto Replace (if no error)"
      Height          =   495
      Left            =   240
      TabIndex        =   1
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CheckBox chkAutoEval 
      Caption         =   "Auto Eval"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   1200
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.Label Label4 
      Caption         =   "Options"
      Height          =   255
      Left            =   0
      TabIndex        =   3
      Top             =   840
      Width           =   735
   End
   Begin VB.Label Label3 
      Caption         =   "Library Functions"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   240
      Width           =   1335
   End
End
Attribute VB_Name = "frmEvalSelection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim parent As Form2
Dim WithEvents txtJS As SciSimple
Attribute txtJS.VB_VarHelpID = -1

Private Sub cmdEval_Click()
    On Error Resume Next
    sc.Reset
    sc.UseSafeSubset = Not (chkAllowActX.value = 1)
    sc.AddObject "tb", parent.toolbox
    Me.Caption = Empty
    txtOutput.Text = Empty
    If Len(txtLibCode.Text) > 0 Then sc.AddCode txtLibCode.Text
    If sc.error.Number = 0 Then
        txtOutput.Text = sc.eval(txtEval.Text)
    Else
        Me.Caption = "Library code " & Me.Caption
    End If
End Sub

Private Sub cmdHelp_Click()
    MsgBox "Select a string in the main jsui code window. " & vbCrLf & _
            "It will be automatically copied to the eval box here." & vbCrLf & _
            "When you hit eval button it will be run as javascript" & vbCrLf & _
            "and the output saved to the lower textbox. " & vbCrLf & _
            "" & vbCrLf & _
            "if you need library functions such as a decoder or variables" & vbCrLf & _
            "add them to the top library code textbox." & vbCrLf & _
            "" & vbCrLf & _
            "when you click replace selection it will update the main code " & vbCrLf & _
            "window. you can also use the left/right arrow keys to grow/shrink" & vbCrLf & _
            "your selection to have it autoupdated." & vbCrLf & _
            "" & vbCrLf & _
            "the checkbox options can auto eval, auto insert, and auto quote" & vbCrLf & _
            "depending on your confidence/patience levels. do worry the code " & vbCrLf & _
            "window supports undo." & vbCrLf & _
            "" & vbCrLf & _
            "you know you are in for it when you have to use this form :(" & vbCrLf
End Sub

Private Sub cmdInsert_Click()
    Dim tmp As String
    
    If sc.error.Number <> 0 Then
        Me.Caption = "Had error can not insert"
        Exit Sub
    End If
    
    If Len(txtOutput) = 0 Then
        Me.Caption = "No output"
        Exit Sub
    End If
    
    tmp = txtOutput.Text
    If chkQuoteResult.value = 1 Then
            'If InStr(txtOutput.Text, "'") Then
                tmp = "'" & tmp & "'"
            'Else
    End If
    
    txtJS.SelText = tmp
    
End Sub

Private Sub Form_Load()
    topMost Me
    Dim f As Form
    For Each f In Forms
        If f.name = "Form2" Then
            Set parent = f
            Exit For
        End If
    Next
    If f Is Nothing Then
        Unload Me
        Exit Sub
    End If
    Me.Icon = Form1.Icon
    Frame1.BackColor = Me.BackColor
    Set txtJS = parent.txtJS
    Me.Caption = "Selection event hooked!"
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    txtLibCode.height = Me.height - txtLibCode.Top - Frame1.height - 400
    txtLibCode.Width = Me.Width - txtLibCode.left - 200
    Frame1.Top = Me.height - Frame1.height - 200
    Frame1.Width = Me.Width
    txtEval.Width = txtLibCode.Width
    txtOutput.Width = txtLibCode.Width
End Sub

Private Sub lblCopyUp_Click()
    txtLibCode.Text = txtEval.Text
    txtEval.Text = Empty
End Sub

Private Sub sc_Error()
    Me.Caption = "Error line: " & sc.error.line & " - " & sc.error.Description
End Sub

Private Sub txtJS_KeyUp(KeyCode As Long, Shift As Long)
    If KeyCode = vbKeyLeft Or KeyCode = vbKeyRight Then 'they used arrow left or right to grow selection fishing for end point..
        txtJs_MouseUp 0, 0, 0, 0
    End If
End Sub

Private Sub txtJs_MouseUp(Button As Integer, Shift As Integer, x As Long, y As Long)
    
    If chkIgnoreSelects.value = 1 Then Exit Sub
    
    If txtJS.SelLength > 0 Then
        txtEval.Text = txtJS.SelText
        
        If chkAutoEval.value = 1 Then cmdEval_Click
        
        If chkAutoReplace.value = 1 And sc.error.Number = 0 Then
            'how to handle embedded quotes?
            cmdInsert_Click
        End If
    End If

End Sub
