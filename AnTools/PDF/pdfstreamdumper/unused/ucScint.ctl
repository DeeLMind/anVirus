VERSION 5.00
Object = "{3232B1EB-33A0-4C34-8630-0BE048BB46F2}#1.0#0"; "SCIVBX.ocx"
Begin VB.UserControl ucScint 
   ClientHeight    =   4800
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7755
   KeyPreview      =   -1  'True
   ScaleHeight     =   4800
   ScaleWidth      =   7755
   Begin SCIVBX.SCIHighlighter hlMain 
      Left            =   1485
      Top             =   585
      _ExtentX        =   847
      _ExtentY        =   847
   End
   Begin SCIVBX.SCIVB sciMain 
      Left            =   2430
      Top             =   675
      _ExtentX        =   847
      _ExtentY        =   847
      EndAtLastLine   =   -1  'True
      EdgeMode        =   1
      Gutter0Width    =   20
      WordWrap        =   1
      FoldMarker      =   1
      AutoShowAutoComplete=   -1  'True
      LineNumbers     =   -1  'True
      FoldCompact     =   -1  'True
      IndentationGuide=   0   'False
   End
End
Attribute VB_Name = "ucScint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'we wrap this control so that its interchangable with the rtf box
'i used to use just in case i want to switch back!
Private Declare Function GetTickCount Lib "kernel32" () As Long
Private lastPaste As Long

Event AutoCompleteEvent(className As String)
Event CtrlH()

Property Get SCI() As SCIVB
    Set SCI = sciMain
End Property

Sub GotoLineCentered(ByVal line As Long, Optional selected As Boolean = True)
        
        mline = line - CInt(sciMain.DirectSCI.LinesOnScreen / 2)
        FirstVisibleLine = mline
        GotoLine line
        If selected Then SelectLine
        
End Sub

Property Get FirstVisibleLine() As Long
    FirstVisibleLine = sciMain.DirectSCI.GetFirstVisibleLine
End Property

Property Let FirstVisibleLine(topLine As Long)

    GotoLine topLine + sciMain.DirectSCI.LinesOnScreen + 5 'go past it
    GotoLine topLine 'now go to it and it will be topmost line..
    
'   'Const SCI_SETFIRSTVISIBLELINE = 2613
'   'sciMain.DirectSCI.SendEditor(SCI_SETFIRSTVISIBLELINE, v, 0)
'
'     topLine = topLine - 1
'     GotoLine topLine
'     x = sciMain.DirectSCI.GetFirstVisibleLine 'this fucks up when code folding is on or topline > 5900...
'
'     If Abs(x - topLine) > sciMain.DirectSCI.LinesOnScreen + 2 Then
'        'stupid bug in control? cant seem to handle topline > 5900 or so..
'        Exit Property
'     End If
'
'     If x < 2 Then Exit Property
'
'     For i = 0 To sciMain.DirectSCI.LinesOnScreen
'        If x = topLine Then Exit For
'        If x < topLine Then
'            sciMain.DirectSCI.LineScrollDown
'        Else
'            sciMain.DirectSCI.LineScrollUp
'        End If
'        x = sciMain.DirectSCI.GetFirstVisibleLine
'     Next
'
End Property

Property Get VisibleLines() As Long
    VisibleLines = sciMain.DirectSCI.LinesOnScreen
End Property

Property Let AutoCompleteString(x As String)
    sciMain.AutoCompleteString = x
End Property

Sub ShowAutoComplete(api As String)
    sciMain.ShowAutoComplete api
End Sub

Sub ShowOptions()
    On Error Resume Next
    hlMain.DoOptions App.path & "\highlighters"
    hlMain.SetStylesAndOptions sciMain, "CPP"
    sciMain.SetFocus
End Sub

Sub SelectLine()
    On Error Resume Next
    sciMain.SelectLine
End Sub

Public Sub SelectAll()
    sciMain.SelectAll
End Sub

Property Get Text()
    On Error Resume Next
    Text = sciMain.Text
End Property

Property Let SelColor(x)
    On Error Resume Next
    DoEvents 'no way to change font color?
End Property

Property Let SelBold(x)
    DoEvents 'not available
End Property

Property Get CurrentLine()
    CurrentLine = sciMain.GetCurrentLine + 1
End Property

Property Let Text(x)
    On Error Resume Next
    sciMain.Text = x
    sciMain.GotoLine 0
End Property

Property Get SelText()
    On Error Resume Next
    SelText = sciMain.SelText
    If Len(SelText) = 1 And Asc(SelText) = 0 Then SelText = Empty
End Property

Property Let SelText(x)
    On Error Resume Next
    sciMain.SelText = x
End Property

Public Property Get SelLength() As Variant
    On Error Resume Next
    SelLength = Len(sciMain.SelText)
End Property

Public Property Let SelLength(vNewValue)
    On Error Resume Next
    sciMain.SelEnd = sciMain.SelStart + vNewValue
End Property

Public Property Get SelStart() As Variant
    On Error Resume Next
    SelStart = sciMain.SelStart
End Property

Public Property Let SelStart(ByVal vNewValue As Variant)
    On Error Resume Next
    sciMain.SelStart = vNewValue
End Property

Function GotoLine(x)
    On Error Resume Next
    sciMain.GotoLine CLng(x)
End Function

Function GetLineText(lIndex)
    On Error Resume Next
    GetLineText = sciMain.GetLineText(CLng(lIndex) - 1)
End Function
 

Sub LoadFile(x)
    On Error Resume Next
    sciMain.LoadFile CStr(x)
End Sub

 
Private Sub sciMain_KeyDown(KeyCode As Long, Shift As Long)
    On Error Resume Next
    If Shift = 4 Then 'ctrl
        Select Case KeyCode
            Case 65: sciMain.SelectAll 'a
            Case 88: sciMain.Cut 'x
            Case 67: sciMain.Copy 'c
            Case 86:
                    Dim x As Long
                    x = GetTickCount
                    If x - lastPaste < 100 Then Exit Sub
                    lastPaste = x
                    sciMain.Paste 'v
        End Select
    End If
End Sub

Private Sub sciMain_KeyUp(KeyCode As Long, Shift As Long)
    'Debug.Print KeyCode & " " & Shift
    On Error Resume Next
    
    If KeyCode = 190 Then
        RaiseEvent AutoCompleteEvent(sciMain.GetCurrentWord)
    End If
    
    If Shift = 4 Then 'ctrl
        Select Case KeyCode
            Case 72: RaiseEvent CtrlH
            Case 65: sciMain.SelectAll 'a
            Case 88: sciMain.Cut 'x
            Case 67: sciMain.Copy 'c
            'Case 86: sciMain.Paste 'v causes bug leave disabled...
            Case 32: 'ctrl space show auto complete - little messy but it correctly supports multiple objects.
                     Dim x As Long
                     x = sciMain.SelStart - 1
                     sciMain.SetCurrentPosition x
                     sciMain.SelStart = x
                     RaiseEvent AutoCompleteEvent(sciMain.GetCurrentWord)
        End Select
    End If
End Sub

Private Sub UserControl_Initialize()

        On Error Resume Next
        
        App.StartLogging "", vbLogOff
        
        Dim f As String
        f = App.path & "\highlighters"
        If Not FolderExists(f) Then
            MsgBox "Highlighter folder not found"
        End If
        
        
        sciMain.InitScintilla UserControl.hwnd
        sciMain.LoadAPIFile App.path & "\api.api"
               
        hlMain.LoadHighlighters f
        hlMain.ReadSettings "PDFStreamDumper"
        n = hlMain.SetStylesAndOptions(sciMain, "CPP")
                
        sciMain.AutoCompleteOnCTRLSpace = True
        'sciMain.AutoCompleteString = "Save2Clipboard GetClipboard t eval unescape alert Hexdump WriteFile ReadFile HexString2Bytes Disasm pad EscapeHexString GetStream CRC getPageNumWords GetPageNthWord"
        sciMain.AutoShowAutoComplete = False

        sciMain.EndAtLastLine = True
        sciMain.ShowCallTips = True
        sciMain.Folding = False
        sciMain.LineNumbers = True
        sciMain.WordWrap = wrap
        sciMain.HighlightBraces = True
        sciMain.EdgeColor = vbWhite
        sciMain.IndentationGuide = False
        sciMain.Gutter0Width = 40
        sciMain.Gutter1Width = 40
        sciMain.FoldAtElse = True
        
        hlMain.SetHighlighterExt sciMain, "bs.js"
        sciMain.SetFocus
  
End Sub

Property Let LineIndentGuide(x As Boolean)
    sciMain.IndentationGuide = x
End Property
Property Let WordWrap(x As Boolean)
    sciMain.WordWrap = IIf(x, wrap, noWrap)
End Property
Property Let Folding(x As Boolean)
    sciMain.Folding = x
End Property
Property Let AutoCompleteOnCTRLSpace(x As Boolean)
    sciMain.AutoCompleteOnCTRLSpace = x
End Property


Private Function FolderExists(path) As Boolean
  If Dir(path, vbDirectory) <> "" Then FolderExists = True _
  Else FolderExists = False
End Function

Private Sub UserControl_Resize()
    On Error Resume Next
    sciMain.MoveSCI 0, 0, UserControl.ScaleWidth, UserControl.ScaleHeight
End Sub

 
Private Sub UserControl_Terminate()
    hlMain.WriteSettings "PDFStreamDumper"
End Sub
