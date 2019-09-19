VERSION 5.00
Begin VB.Form frmFuncGraph 
   Caption         =   "Function Graph"
   ClientHeight    =   5580
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7020
   LinkTopic       =   "Form3"
   ScaleHeight     =   5580
   ScaleWidth      =   7020
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox Check1 
      Caption         =   "Top Most"
      Height          =   285
      Left            =   5490
      TabIndex        =   7
      Top             =   90
      Width           =   1140
   End
   Begin VB.CommandButton cmdSource 
      Caption         =   "View Source"
      Height          =   375
      Left            =   1395
      TabIndex        =   6
      Top             =   45
      Width           =   1545
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   255
      Left            =   90
      Max             =   100
      TabIndex        =   4
      Top             =   5130
      Width           =   6540
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   4710
      Left            =   6660
      Max             =   100
      TabIndex        =   3
      Top             =   450
      Width           =   255
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Save Image"
      Height          =   375
      Left            =   3600
      TabIndex        =   1
      Top             =   45
      Width           =   1455
   End
   Begin VB.PictureBox pictParent 
      BackColor       =   &H00FFFFFF&
      Height          =   4605
      Left            =   90
      ScaleHeight     =   4545
      ScaleWidth      =   6435
      TabIndex        =   0
      Top             =   495
      Width           =   6495
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2040
         Left            =   315
         MultiLine       =   -1  'True
         TabIndex        =   2
         Text            =   "frmFuncGraph.frx":0000
         Top             =   315
         Width           =   4110
      End
      Begin VB.PictureBox Picture1 
         AutoSize        =   -1  'True
         Height          =   1725
         Left            =   1305
         ScaleHeight     =   1665
         ScaleWidth      =   1620
         TabIndex        =   5
         Top             =   2520
         Width           =   1680
      End
   End
End
Attribute VB_Name = "frmFuncGraph"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim img As BinaryImage
Dim pGraph As CGraph
Dim loaded As Boolean
Dim dlg As New clsCmnDlg2
Dim defName As String

Private Declare Sub SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long)
Const HWND_TOPMOST = -1
Const HWND_NOTOPMOST = -2

Sub SetWindowTopMost(f As Form, Optional topMost As Integer = 0)
   SetWindowPos f.hwnd, _
        IIf(topMost = 0, HWND_NOTOPMOST, HWND_TOPMOST), _
        f.left / 15, f.Top / 15, f.Width / 15, f.height / 15, Empty
End Sub

'note using instr funcName as only indication of function being called withint another is not
'enough to be safe (func1, func11 etc) this should help...
Function Basic_Safetify(ByVal data As String) As String
        data = Replace(data, vbLf, vbLf & " ")
        data = Replace(data, "(", "( ") 'func11(func1(
        data = Replace(data, "{", "{ ")
        data = Replace(data, "[", "[ ")
        data = Replace(data, "!", "! ")
        data = Replace(data, "this.", " ")
        data = Replace(data, vbTab, " ")
        Basic_Safetify = data
End Function


Private Sub Check1_Click()
    SetWindowTopMost Me, Check1.value
    SaveMySetting "graphTopMost", Check1.value
End Sub

Private Sub cmdSource_Click()
    If InStr(cmdSource.Caption, "View") > 0 Then
        Text1.Visible = True
        cmdSource.Caption = "Hide Source"
    Else
        Text1.Visible = False
        cmdSource.Caption = "View Source"
    End If
End Sub

Private Sub Command2_Click()

   If img Is Nothing Then Exit Sub
   
   Dim pth As String
   pth = dlg.SaveDialog(AllFiles, , , , Me.hwnd, defName)
   If Len(pth) = 0 Then Exit Sub

   If img.Save(pth) Then
        MsgBox "Saved to " & pth, vbInformation
   Else
        MsgBox "Save failed", vbExclamation
   End If
   
   'or SavePicture Picture1, App.Path & "\sample.bmp"
    
End Sub

Function GraphFrom(startfunc As String, Optional pNode As CNode)
    
    'On Error Resume Next
    
    Dim li As ListItem
    Dim data As String
    Dim foundEnd As Boolean
    Dim func() As String
    Dim n As CNode
    Dim existingNode As CNode
    Dim startLine As Long
    Dim topLevel As Boolean
    
    'If startfunc = "fix_it" Then Stop
    
    If pNode Is Nothing Then 'top level call..
        Me.Caption = Me.Caption & " from " & startfunc
    End If


    If Not loaded Then Form_Load
    If pGraph Is Nothing Then Set pGraph = New CGraph
    
    If pNode Is Nothing Then
        defName = "from_" & startfunc & ".gif"
        Set pNode = pGraph.AddNode(startfunc)
        topLevel = True
    End If

    For Each li In Form2.lvFunc.ListItems
        If li.Text = startfunc Then
            startLine = CLng(li.tag)
            Exit For
        End If
    Next
    
    data = Form2.ExtractFunction(startLine, foundEnd)
    
    'now we trim off the function xx(){ part..
    a = InStr(data, "{")
    If a > 0 Then data = Mid(data, a)
    data = Basic_Safetify(data)
    
    For Each li In Form2.lvFunc.ListItems
        'If InStr(data, " " & li.Text & "(") > 0 Then
        If InStr(data, li.Text & "(") > 0 Then
            Set existingNode = pGraph.NodeExists(li.Text)
            If Not existingNode Is Nothing Then
                pNode.ConnectTo existingNode
            Else
                Set n = pGraph.AddNode(li.Text)
                pNode.ConnectTo n
                GraphFrom li.Text, n
            End If
        End If
    Next
    
    If Not topLevel Then Exit Function
    
    pGraph.GenerateGraph

    Set img = pGraph.dot.ToGIF(pGraph.lastGraph)
    
    If img Is Nothing Then
        Text1.Visible = True
        Text1.Text = "Graph generation failed?" & vbCrLf & vbCrLf & pGraph.lastGraph
    Else
        Text1.Text = pGraph.lastGraph
        Set Picture1.Picture = img.Picture
        If Picture1.Width < pictParent.Width Then HScroll1.value = 50
    End If

End Function

Function GraphTo(startfunc As String, Optional pNode As CNode)
    
 'On Error Resume Next

    Dim li As ListItem
    Dim data As String
    Dim foundEnd As Boolean
    Dim func() As String
    Dim n As CNode
    Dim existingNode As CNode
    Dim startLine As Long
    Dim topLevel As Boolean

    If Not loaded Then Form_Load
    If pGraph Is Nothing Then Set pGraph = New CGraph

    
    If pNode Is Nothing Then 'top level call..
        Me.Caption = Me.Caption & " to " & startfunc
    End If
    
    If pNode Is Nothing Then
        defName = "to_" & startfunc & ".gif"
        Set pNode = pGraph.AddNode(startfunc)
        topLevel = True
    End If

    For Each li In Form2.lvFunc.ListItems
        
        If li.Text <> startfunc Then
            startLine = CLng(li.tag)
            data = Form2.ExtractFunction(startLine, foundEnd)
    
            'now we trim off the function xx(){ part..
            a = InStr(data, "{")
            If a > 0 Then data = Mid(data, a)
            data = Basic_Safetify(data)
            
            'If InStr(data, " " & startfunc & "(") > 0 Then
            If InStr(data, startfunc & "(") > 0 Then
                Set existingNode = pGraph.NodeExists(li.Text)
                If Not existingNode Is Nothing Then
                    existingNode.ConnectTo pNode
                Else
                    Set n = pGraph.AddNode(li.Text)
                    n.ConnectTo pNode
                    GraphTo li.Text, n
                End If
            End If
            
        End If
         
    Next

    If Not topLevel Then Exit Function

    pGraph.GenerateGraph

    Set img = pGraph.dot.ToGIF(pGraph.lastGraph)

    If img Is Nothing Then
        Text1.Visible = True
        Text1.Text = "Graph generation failed?" & vbCrLf & vbCrLf & pGraph.lastGraph
    Else
        Text1.Text = pGraph.lastGraph
        Set Picture1.Picture = img.Picture
        If Picture1.Width < pictParent.Width Then HScroll1.value = 50
    End If

End Function



Private Sub Form_Load()
    Picture1.Appearance = 0
    Text1.Visible = False
    With pictParent
        Text1.Move 0, 0, .Width, .height
        Picture1.Move 0, 0, .Width, .height
    End With
    Me.Visible = True
    loaded = True
    Check1.value = GetMySetting("graphTopMost", 1)
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    With pictParent
        VScroll1.left = Me.Width - VScroll1.Width - 100
        .Width = Me.Width - .left - VScroll1.Width - 100
        .height = Me.height - .Top - 200 - HScroll1.height - 250
        VScroll1.height = .height
        HScroll1.Top = .height + .Top + 50
        HScroll1.Width = Me.Width - 200
        Text1.Move 0, 0, .Width, .height
    End With
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set pGraph = Nothing
    Set img = Nothing
    loaded = False
End Sub


'''''''''''''''''''''''''''''''''''
'Author: Zelimir Ikovic [photo_map@yahoo.com]
'http://www.activexy.com
'''''''''''''''''''''''''''''''''''
Private Sub VScroll1_Change()
   Call tp
End Sub

Private Sub VScroll1_Scroll()
   Call tp
End Sub
Private Sub HScroll1_Change()
   Call lft
End Sub

Private Sub HScroll1_Scroll()
   Call lft
End Sub

Private Sub tp()
   Dim xx As Double
   Dim a As Double
   Dim x As Double
   
   x = VScroll1.value
   a = Picture1.height - pictParent.height
   xx = (a * x) / 100
   Picture1.Top = -xx

End Sub

Private Sub lft()
   Dim xx As Double
   Dim a As Double
   Dim x As Double
   
   x = HScroll1.value
   a = Picture1.Width - pictParent.Width
   xx = (a * x) / 100
   Picture1.left = -xx

End Sub




'example
'Dim g As New CGraph
'   Dim n0 As CNode, n1 As CNode, n2 As CNode, n3 As CNode, n4 As CNode, n5 As CNode
'
'   Set n0 = g.AddNode("this is my" & vbCrLf & "multiline\nnode")
'   n0.shape = "box"
'   n0.style = "filled"
'   n0.color = "lightyellow"
'   n0.fontcolor = "#c0c0c0"
'
'   Set n1 = g.AddNode
'   Set n2 = g.AddNode
'   Set n3 = g.AddNode
'   Set n4 = g.AddNode
'   Set n5 = g.AddNode
'
'   n0.ConnectTo n2
'   n1.ConnectTo n2
'   n2.ConnectTo n3
'   n1.ConnectTo n4
'   n0.ConnectTo n5
'
'   Call g.GenerateGraph
'   Text1.Text = g.lastGraph
'
'   Set img = g.dot.ToGIF(g.lastGraph)
'   If img Is Nothing Then Exit Sub
'
'   Set Picture1.Picture = img.Picture


