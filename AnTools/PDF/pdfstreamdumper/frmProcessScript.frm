VERSION 5.00
Object = "{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}#1.0#0"; "msscript.ocx"
Object = "{2668C1EA-1D34-42E2-B89F-6B92F3FF627B}#5.0#0"; "scivb2.ocx"
Begin VB.Form frmProcessScript 
   Caption         =   "Utility Scripts"
   ClientHeight    =   5265
   ClientLeft      =   6900
   ClientTop       =   1980
   ClientWidth     =   10590
   LinkTopic       =   "Form3"
   ScaleHeight     =   5265
   ScaleWidth      =   10590
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      Caption         =   "Frame1"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   4800
      Width           =   10455
      Begin VB.CommandButton cmdHelp 
         Caption         =   "?"
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   0
         Width           =   495
      End
      Begin VB.CommandButton cmdRun 
         Caption         =   "Run"
         Height          =   375
         Left            =   9120
         TabIndex        =   2
         Top             =   0
         Width           =   1215
      End
   End
   Begin MSScriptControlCtl.ScriptControl sc 
      Left            =   0
      Top             =   4320
      _ExtentX        =   1005
      _ExtentY        =   1005
      Language        =   "jscript"
      UseSafeSubset   =   -1  'True
   End
   Begin sci2.SciSimple txtJS 
      Height          =   4575
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   10575
      _ExtentX        =   18653
      _ExtentY        =   8070
   End
End
Attribute VB_Name = "frmProcessScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim parent As Form2

Private Sub cmdHelp_Click()
    MsgBox "This lets you run scripts to process the main code window as data" & vbCrLf & _
            "or run script fragments without disturbing your other work." & vbCrLf & _
            "" & vbCrLf & _
            "you can access the main code window through js.text and the lower" & vbCrLf & _
            "textbox as out.text The tb toolbox class is also available."
End Sub

Private Sub Form_Load()
    topMost Me
    Me.Icon = Form1.Icon
    Frame1.BackColor = Me.BackColor
    Dim f As Form
    For Each f In Forms
        If f.name = "Form2" Then
            Set parent = f
            Exit For
        End If
    Next
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    txtJS.Width = Me.Width - txtJS.left - 200
    txtJS.height = Me.height - txtJS.Top - Frame1.height - 500
    Frame1.Top = Me.height - Frame1.height - 400
    Frame1.Width = Me.Width - Frame1.left
    cmdRun.left = Me.Width - cmdRun.Width - 400
End Sub

Private Sub txtJs_AutoCompleteEvent(className As String)
    Dim prev As String
    
    prev = txtJS.PreviousWord
    
    If className = "tb" Or prev = "tb" Then
        txtJS.ShowAutoComplete "save2Clipboard getClipboard t eval unescape alert " & _
                               "hexdump writeFile readFile hexString2Bytes pad " & _
                               "escapeHexString getStream crc getPageNumWords getPageNthWord"
    End If
    
End Sub

Private Sub txtJS_DoubleClick()
    Dim word As String
    Dim li As ListItem
    
    word = txtJS.CurrentWord
    If Len(word) < 20 Then
        Me.Caption = "  " & txtJS.hilightWord(word, , vbBinaryCompare) & " instances of '" & word & " ' found"
    End If
    
End Sub

Private Sub txtJs_MouseUp(Button As Integer, Shift As Integer, x As Long, y As Long)
    
    On Error Resume Next
    
    Dim sel As String
    Dim word As String 'word mouse is currently over..
    Dim isFuncName As Boolean
 
    
    sel = txtJS.SelText
    
    If Len(sel) > 0 And Len(sel) < 20 Then
        Me.Caption = "  " & txtJS.hilightWord(sel, , vbBinaryCompare) & " instances of '" & sel & " ' found"
    End If
    
End Sub

Private Sub cmdRun_Click()
    On Error Resume Next
    
    parent.txtOut.Text = Empty
    parent.lv2.ListItems.Clear
    parent.toolbox.ResetAlertCount
    
    Const helper = "function alert(x){tb.alert(x)}"
    
    sc.Reset
    sc.AddObject "tb", parent.toolbox
    sc.AddObject "out", parent.txtOut
    sc.AddObject "js", parent.txtJS
    sc.AddCode txtJS.Text & vbCrLf & helper
    
End Sub

Private Sub sc_Error()
        
    On Error Resume Next
    Dim tmp() As String
    Dim cCount As Long
    Dim adjustedLine As Long
    Dim curLine As Long
    
    With sc.error
    
        curLine = txtJS.CurrentLine
        adjustedLine = .line - 0
        
        parent.txtOut.Text = "Time: " & Now & vbCrLf & "Error: " & .Description & vbCrLf & "Line: " & adjustedLine
        parent.txtOut.Text = txtOut.Text & vbCrLf & "Source: " & txtJS.GetLineText(adjustedLine - 1) 'vbsci specific
        
        tmp = Split(txtJS.Text, vbCrLf)
        For i = 0 To adjustedLine - 1
            If i = (adjustedLine - 1) Then
                If curLine > i And (adjustedLine - 5 > 0) Then
                    txtJS.GotoLine adjustedLine - 5 'display bug
                Else
                    txtJS.GotoLine adjustedLine
                End If
                txtJS.SelStart = cCount
                txtJS.SelLength = Len(tmp(i))
                Exit For
            Else
                cCount = cCount + Len(tmp(i)) + 2 'for the crlf
            End If
        Next
    
    End With
    
End Sub



