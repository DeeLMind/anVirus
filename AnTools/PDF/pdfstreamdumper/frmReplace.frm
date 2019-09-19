VERSION 5.00
Begin VB.Form frmReplace 
   Caption         =   "Find/Replace"
   ClientHeight    =   2640
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5340
   LinkTopic       =   "Form3"
   ScaleHeight     =   2640
   ScaleWidth      =   5340
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdFindAll 
      Caption         =   "Find All"
      Height          =   375
      Left            =   3960
      TabIndex        =   16
      Top             =   1800
      Visible         =   0   'False
      Width           =   1335
   End
   Begin VB.CheckBox chkUnescape 
      Caption         =   "Use %xx for hex character values"
      Height          =   240
      Left            =   1035
      TabIndex        =   15
      Top             =   945
      Width           =   2685
   End
   Begin VB.CommandButton cmdFindNext 
      Caption         =   "Find Next"
      Height          =   375
      Left            =   3960
      TabIndex        =   14
      Top             =   1350
      Width           =   1335
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "Find First"
      Height          =   375
      Left            =   3960
      TabIndex        =   13
      Top             =   900
      Width           =   1335
   End
   Begin VB.CheckBox chkCaseSensitive 
      Caption         =   "Case Sensitive"
      Height          =   255
      Left            =   2040
      TabIndex        =   11
      Top             =   2160
      Width           =   1695
   End
   Begin VB.OptionButton Option2 
      Caption         =   "Selection"
      Height          =   255
      Left            =   2040
      TabIndex        =   10
      Top             =   1440
      Width           =   1815
   End
   Begin VB.OptionButton Option1 
      Caption         =   "Whole Text"
      Height          =   255
      Left            =   2040
      TabIndex        =   9
      Top             =   1800
      Value           =   -1  'True
      Width           =   1695
   End
   Begin VB.TextBox Text4 
      Height          =   285
      Left            =   600
      TabIndex        =   7
      Top             =   1920
      Width           =   975
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   600
      TabIndex        =   6
      Top             =   1440
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Replace"
      Height          =   375
      Left            =   3960
      TabIndex        =   4
      Top             =   2250
      Width           =   1335
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
      Height          =   375
      Left            =   960
      TabIndex        =   3
      Top             =   480
      Width           =   4335
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
      Height          =   375
      Left            =   960
      TabIndex        =   1
      Top             =   0
      Width           =   4335
   End
   Begin VB.Label lblSelSize 
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   1200
      Width           =   2415
   End
   Begin VB.Label Label5 
      Caption         =   "Hex"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1920
      Width           =   615
   End
   Begin VB.Label Label4 
      Caption         =   "Char"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1440
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "Replace"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "Find"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuCopyAll 
         Caption         =   "Copy All"
      End
   End
End
Attribute VB_Name = "frmReplace"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com
'this form is no longer used universally, scivb_lite has a copy of this form built in use that for txtjs


Public active_object As RichTextBox
Dim lastkey As Integer
Dim lastIndex As Long
Dim lastsearch As String

Private Declare Sub SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long)
Private Const HWND_TOPMOST = -1
Private Const HWND_NOTOPMOST = -2
Private Const SWP_SHOWWINDOW = &H40

Dim selli As ListItem



Private Sub cmdFind_Click()
    
    On Error Resume Next
    
    If chkUnescape.value = 1 Then
        f = unescape(Text1)
    Else
        f = Text1
    End If
    
    lastsearch = f
    
    Dim compare As VbCompareMethod
    
    If chkCaseSensitive.value = 1 Then
        compare = vbBinaryCompare
    Else
        compare = vbTextCompare
    End If
    
    x = InStr(1, active_object.Text, lastsearch, compare)
    If x > 0 Then
        lastIndex = x + 2
        active_object.SelStart = x - 1
        active_object.SelLength = Len(lastsearch)
    Else
        lastIndex = 1
    End If
    
End Sub

Private Sub cmdFindNext_Click()
    
    On Error Resume Next
    
    If chkUnescape.value = 1 Then
        f = unescape(Text1)
    Else
        f = Text1
    End If
    
    If lastsearch <> f Then
        cmdFind_Click
        Exit Sub
    End If
    
    If lastIndex >= Len(active_object.Text) Then
        MsgBox "Reached End of text no more matches", vbInformation
        Exit Sub
    End If
    
    Dim compare As VbCompareMethod
    
    If chkCaseSensitive.value = 1 Then
        compare = vbBinaryCompare
    Else
        compare = vbTextCompare
    End If
    
    x = InStr(lastIndex, active_object.Text, lastsearch, compare)
    
    If x + 2 = lastIndex Or x < 1 Then
        MsgBox "No more matches found", vbInformation
        Exit Sub
    Else
        lastIndex = x + 2
        active_object.SelStart = x - 1
        active_object.SelLength = Len(lastsearch)
    End If
    
    
End Sub

Private Sub Command1_Click()
    
    On Error Resume Next
    
    If chkUnescape.value = 1 Then
        f = unescape(Text1)
    Else
        f = Text1
    End If
    
    If chkUnescape.value = 1 Then
        r = unescape(Text2)
    Else
        r = Text2
    End If
    
    Dim compare As VbCompareMethod
    
    If chkCaseSensitive.value = 1 Then
        compare = vbBinaryCompare
    Else
        compare = vbTextCompare
    End If
    
    Dim curLine As Long
    
    If Option1.value Then 'whole selection
        active_object.Text = Replace(active_object.Text, f, r, , , compare)
    Else
        sl = active_object.SelStart
        nt = Replace(active_object.SelText, f, r, , , compare)
        active_object.SelText = nt
        active_object.SelStart = sl
        active_object.SelLength = Len(nt)
    End If
    
    lblSelSize = "Selection Size: " & Len(active_object.SelText)
    
End Sub

Public Sub LaunchReplaceForm(txtObj As RichTextBox)
    
    Set active_object = txtObj
    
    If Len(txtObj.SelText) > 1 Then
        lblSelSize = "Selection Size: " & Len(txtObj.SelText)
        'Option2.Value = True 'since we auto load selection into txtFind, and autoload last search type, this was a conflict of interest..
    End If
    
    Me.Show
    
End Sub




Private Sub Form_Load()
    Me.Icon = Form1.Icon
    FormPos Me, False
    SetWindowPos Me.hwnd, HWND_TOPMOST, Me.left / 15, Me.Top / 15, Me.Width / 15, Me.height / 15, SWP_SHOWWINDOW
    Text1 = GetMySetting("lastFind")
    Text2 = GetMySetting("lastReplace")
    If GetMySetting("wholeText", "1") = "1" Then Option1.value = True Else Option2.value = True
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    lv.Width = Me.Width - lv.left - 200
    lv.height = Me.height - lv.Top - 300
    lv.ColumnHeaders(2).Width = lv.Width - lv.ColumnHeaders(2).left - 200
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormPos Me, False, True
    SaveMySetting "lastFind", Text1
    SaveMySetting "lastReplace", Text2
    SaveMySetting "wholeText", IIf(Option1.value, "1", "0")
    
'    Dim f As Form, f2 As Form2
'    For Each f In Me.Forms
'        If f.name = "Form2" Then 'jsui
'            Set f2 = f
'            Set f2.activeReplaceForm = Nothing
'            Exit For
'        End If
'    Next
    
End Sub

Private Sub Text3_KeyPress(KeyAscii As Integer)
    lastkey = KeyAscii
End Sub

Private Sub Text3_KeyUp(KeyAscii As Integer, Shift As Integer)
    Dim x As String
    x = Hex(lastkey)
    If Len(x) = 1 Then x = "0" & x
    Text4 = x
    Text3 = Chr(lastkey)
End Sub
