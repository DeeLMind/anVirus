VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmRefactor 
   Caption         =   "Auto-Refactor Obsfuscated Scripts"
   ClientHeight    =   7050
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14715
   LinkTopic       =   "Form3"
   ScaleHeight     =   7050
   ScaleWidth      =   14715
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdHelp 
      Caption         =   "?"
      Height          =   375
      Left            =   7200
      TabIndex        =   21
      Top             =   480
      Width           =   495
   End
   Begin VB.Frame fraButtons 
      BorderStyle     =   0  'None
      Height          =   435
      Left            =   8100
      TabIndex        =   15
      Top             =   360
      Width           =   6735
      Begin VB.CommandButton Command2 
         Caption         =   "Apply OverRides"
         Height          =   375
         Left            =   1320
         TabIndex        =   20
         Top             =   0
         Width           =   1695
      End
      Begin VB.CommandButton Command3 
         Caption         =   "Clear OverRides"
         Height          =   375
         Left            =   3060
         TabIndex        =   19
         Top             =   0
         Width           =   1335
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Save && Exit"
         Height          =   375
         Left            =   4920
         TabIndex        =   18
         Top             =   0
         Width           =   1575
      End
      Begin VB.CommandButton cmdScroll 
         Caption         =   "Ú"
         BeginProperty Font 
            Name            =   "Wingdings"
            Size            =   8.25
            Charset         =   2
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   0
         Left            =   120
         TabIndex        =   17
         Top             =   180
         Width           =   375
      End
      Begin VB.CommandButton cmdScroll 
         Appearance      =   0  'Flat
         Caption         =   "Ù"
         BeginProperty Font 
            Name            =   "Wingdings"
            Size            =   8.25
            Charset         =   2
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   1
         Left            =   480
         TabIndex        =   16
         Top             =   180
         Width           =   375
      End
   End
   Begin VB.Frame fraStatus 
      Caption         =   "Parsing Status"
      Height          =   6195
      Left            =   2160
      TabIndex        =   9
      Top             =   2400
      Width           =   12495
      Begin VB.ListBox List1 
         Height          =   4545
         Left            =   240
         TabIndex        =   12
         Top             =   1260
         Width           =   11955
      End
      Begin MSComctlLib.ProgressBar pb 
         Height          =   435
         Left            =   240
         TabIndex        =   11
         Top             =   600
         Width           =   12015
         _ExtentX        =   21193
         _ExtentY        =   767
         _Version        =   393216
         Appearance      =   1
      End
      Begin VB.Label lblCloseStatus 
         BackColor       =   &H00FFFFFF&
         Caption         =   "  X  "
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   13.5
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   11820
         TabIndex        =   13
         Top             =   180
         Width           =   555
      End
      Begin VB.Label lblParsingStatus 
         Caption         =   "Loading..."
         Height          =   375
         Left            =   240
         TabIndex        =   10
         Top             =   300
         Width           =   4395
      End
   End
   Begin VB.CheckBox chkKeepAllOrigFuncNames 
      Caption         =   "Keep ALL Original Function Names"
      Height          =   255
      Left            =   4260
      TabIndex        =   8
      Top             =   60
      Width           =   2835
   End
   Begin VB.CheckBox chkUseOrigFuncName 
      Caption         =   "Keep original function name"
      Height          =   255
      Left            =   4260
      TabIndex        =   7
      Top             =   480
      Width           =   2295
   End
   Begin VB.CommandButton cmdCopyRenameMap 
      Caption         =   "Copy Rename Map"
      Height          =   375
      Left            =   2160
      TabIndex        =   6
      Top             =   0
      Width           =   1935
   End
   Begin VB.CheckBox chkUseOriginalText 
      Caption         =   "Use Original Text"
      Height          =   315
      Left            =   7140
      TabIndex        =   5
      Top             =   60
      Width           =   1635
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Manually Refactor Again"
      Height          =   375
      Left            =   2160
      TabIndex        =   3
      Top             =   420
      Width           =   1935
   End
   Begin VB.TextBox Text2 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6135
      Left            =   8640
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Top             =   840
      Width           =   6015
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
      Height          =   6135
      Left            =   2160
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   1
      Top             =   840
      Width           =   6375
   End
   Begin MSComctlLib.ListView lv 
      Height          =   3495
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   6165
      View            =   3
      LabelEdit       =   1
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
         Text            =   "Functions"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Object.Width           =   2540
      EndProperty
   End
   Begin MSComctlLib.ListView lvArgs 
      Height          =   3495
      Left            =   0
      TabIndex        =   4
      Top             =   3480
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   6165
      View            =   3
      LabelEdit       =   1
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
         Text            =   "LocalArgs"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "NewName"
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.Label lblShowStatus 
      Caption         =   "View Status Pane"
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
      Left            =   9120
      TabIndex        =   14
      Top             =   60
      Width           =   1395
   End
End
Attribute VB_Name = "frmRefactor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com

Public funcs As Collection
Dim selli As ListItem
Public global_script  As CFunc
Private Declare Function GetTickCount Lib "kernel32" () As Long

'----------------------------------------[ textbox scrolling stuff... ]------------------------------
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function SendMessageStr Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As String) As Long
Private Declare Function GetTextMetrics Lib "gdi32" Alias "GetTextMetricsA" (ByVal hdc As Long, lpMetrics As TEXTMETRIC) As Long
Private Declare Function SetMapMode Lib "gdi32" (ByVal hdc As Long, ByVal nMapMode As Long) As Long
Private Declare Function GetWindowDC Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Private Declare Function Rectangle Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function CreateCaret Lib "user32" (ByVal hwnd As Long, ByVal hBitmap As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function ShowCaret Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function GetFocus Lib "user32" () As Long
Private Declare Function SetCaretBlinkTime Lib "user32" (ByVal wMSeconds As Long) As Long
Private Declare Function GetCaretBlinkTime Lib "user32" () As Long

Private Type Rect
    left As Long
    Top As Long
    right As Long
    Bottom As Long
End Type

Private Type TEXTMETRIC
    tmHeight As Long
    tmAscent As Long
    tmDescent As Long
    tmInternalLeading As Long
    tmExternalLeading As Long
    tmAveCharWidth As Long
    tmMaxCharWidth As Long
    tmWeight As Long
    tmOverhang As Long
    tmDigitizedAspectX As Long
    tmDigitizedAspectY As Long
    tmFirstChar As Byte
    tmLastChar As Byte
    tmDefaultChar As Byte
    tmBreakChar As Byte
    tmItalic As Byte
    tmUnderlined As Byte
    tmStruckOut As Byte
    tmPitchAndFamily As Byte
    tmCharSet As Byte
End Type

Public Enum tmMsgs
        EM_UNDO = &HC7
        EM_CANUNDO = &HC6
        EM_SETWORDBREAKPROC = &HD0
        EM_SETTABSTOPS = &HCB
        EM_SETSEL = &HB1
        EM_SETRECTNP = &HB4
        EM_SETRECT = &HB3
        EM_SETREADONLY = &HCF
        EM_SETPASSWORDCHAR = &HCC
        EM_SETMODIFY = &HB9
        EM_SCROLLCARET = &HB7
        EM_SETHANDLE = &HBC
        EM_SCROLL = &HB5
        EM_REPLACESEL = &HC2
        EM_LINESCROLL = &HB6
        EM_LINELENGTH = &HC1
        EM_LINEINDEX = &HBB
        EM_LINEFROMCHAR = &HC9
        EM_LIMITTEXT = &HC5
        EM_GETWORDBREAKPROC = &HD1
        EM_GETTHUMB = &HBE
        EM_GETRECT = &HB2
        EM_GETSEL = &HB0
        EM_GETPASSWORDCHAR = &HD2
        EM_GETMODIFY = &HB8
        EM_GETLINECOUNT = &HBA
        EM_GETLINE = &HC4
        EM_GETHANDLE = &HBD
        EM_GETFIRSTVISIBLELINE = &HCE
        EM_FMTLINES = &HC8
        EM_EMPTYUNDOBUFFER = &HCD
        EM_SETMARGINS = &HD3
End Enum

Private Const WM_VScroll = &H115
Private Const WM_CHAR = &H102
Private Const EC_LEFTMARGIN = &H1
Private Const EC_RIGHTMARGIN = &H2

Private myTopLine As Long
Private TrackingScroll As Boolean
Private OverRidingTabs As Boolean
Private OverrideTabNow As Boolean

Sub ScrollPage(txtA As TextBox, txtB As TextBox, Optional up As Boolean = False)
        
    Dim cnt As Long, topA As Long, topB As Long
    cnt = VisibleLines(txtA) - 1
    
    topA = TopLineIndex(txtA)
    topB = TopLineIndex(txtB)
    
    ScrollToLine txtA, topA + IIf(up, cnt, -cnt)
    ScrollToLine txtB, topB + IIf(up, cnt, -cnt)
    
End Sub

Function TopLineIndex(x As TextBox) As Long
    TopLineIndex = SendMessage(x.hwnd, EM_GETFIRSTVISIBLELINE, 0, ByVal 0&)
End Function

Function VisibleLines(x As TextBox) As Long
    Dim udtRect As Rect, tm As TEXTMETRIC
    Dim hdc As Long, lFont As Long, lOrgFont As Long
    Const WM_GETFONT As Long = &H31
    
    SendMessage x.hwnd, EM_GETRECT, 0, udtRect

    lFont = SendMessage(x.hwnd, WM_GETFONT, 0, 0)
    hdc = GetDC(x.hwnd)

    If lFont <> 0 Then
        lOrgFont = SelectObject(hdc, lFont)
    End If

    GetTextMetrics hdc, tm
    
    If lFont <> 0 Then
        lFont = SelectObject(hdc, lOrgFont)
    End If

    VisibleLines = (udtRect.Bottom - udtRect.Top) \ tm.tmHeight

    ReleaseDC x.hwnd, hdc

End Function

Sub ScrollToLine(t As TextBox, x As Integer)
     x = x - TopLineIndex(t)
     ScrollIncremental t, , x
End Sub

Sub ScrollIncremental(t As TextBox, Optional horz As Integer = 0, Optional vert As Integer = 0)
    'lParam&  The low-order 2 bytes specify the number of vertical
    '          lines to scroll. The high-order 2 bytes specify the
    '          number of horizontal columns to scroll. A positive
    '          value for lParam& causes text to scroll upward or to the
    '          left. A negative value causes text to scroll downward or
    '          to the right.
    ' r&       Indicates the number of lines actually scrolled.
    
    Dim r As Long
    r = CLng(&H10000 * horz) + vert
    r = SendMessage(t.hwnd, EM_LINESCROLL, 0, ByVal r)

End Sub

'----------------------------------------[ /textbox scrolling stuff... ]------------------------------


Private Sub chkKeepAllOrigFuncNames_Click()
'    chkUseOrigFuncName.enabled = Not chkKeepAllOrigFuncNames.Value
End Sub

Private Sub chkUseOrigFuncName_Click()
    
    If selli Is Nothing Then
        MsgBox "No function selected in listview"
        Exit Sub
    End If
    
    Dim f As CFunc
    Set f = selli.tag
    
    f.UseOriginalFuncName = IIf(chkUseOrigFuncName.value = 1, True, False)
    
End Sub

Private Sub chkUseOriginalText_Click()
    
    If selli Is Nothing Then
        MsgBox "No function selected in listview"
        Exit Sub
    End If
    
    Dim f As CFunc
    Set f = selli.tag
    
    f.UseOriginalText = IIf(chkUseOriginalText.value = 1, True, False)
    selli.ForeColor = IIf(f.UseOriginalText, vbBlue, vbBlack)
    
End Sub


Private Sub cmdCopyRenameMap_Click()
    Dim tmp
    Dim li As ListItem
    
    tmp = "Functions: " & vbCrLf & String(40, "-") & vbCrLf
    For Each li In lv.ListItems
        tmp = tmp & li.Text & vbCrLf
    Next
    
    lv_ItemClick lv.ListItems(lv.ListItems.count)
    
    tmp = tmp & vbCrLf & "Global vars: " & vbCrLf & String(40, "-") & vbCrLf
    For Each li In lvArgs.ListItems
        tmp = tmp & li.Text & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText tmp
    
    MsgBox Len(tmp) & " bytes copied", vbInformation
    
End Sub

Private Sub cmdHelp_Click()
   MsgBox "Couple guidelines for this to work right." & vbCrLf & _
            "" & vbCrLf & _
            "No functions nested within other functions." & vbCrLf & _
            "use function x() type instead of var x = function(){" & vbCrLf & _
            "make sure to run code formatter before use" & vbCrLf & _
            "double click on function list to override an items default name" & vbCrLf & _
            "once you select a function, its vars are listed. click once to override name" & vbCrLf & _
            "if you override a var name, click apply overrides before moving on to next function." & vbCrLf & _
            "you can clear overrides for selected functions as well" & vbCrLf & _
            "seems to be a bug right now with overriding global variables" & vbCrLf & _
            "" & vbCrLf & _
            "this is a really complex task, but if you follow these guidelines it" & vbCrLf & _
            "works pretty well." & vbCrLf & _
            "" & vbCrLf
End Sub

Private Sub cmdScroll_Click(Index As Integer)
    ScrollPage Text1, Text2, Not CBool(Index)
End Sub

Private Sub Command4_Click()
    'save and exit
    
    Dim f As CFunc
    
    If global_script.UseOriginalText Then
        Complete = global_script.OrgText
    ElseIf global_script.OverRides.count > 0 Then
        Complete = global_script.OverRideScript
    Else
        Complete = global_script.CleanText
    End If
    
    For Each f In funcs
        If f.UseOriginalText Then
            'ok so they dont want to use the refactored code..but the function name must change.
            tmp = Split(f.OrgText, vbCrLf)
            p1 = InStr(1, tmp(0), "(")
            fxname = Mid(tmp(0), 1, p1 - 1)
            rest = Mid(tmp(0), p1)
            tmp(0) = "function " & f.NewName & rest
            UpdatedOrg = Join(tmp, vbCrLf)
            Complete = Replace(Complete, "__function_" & f.Index & "_placeholder", UpdatedOrg)
        ElseIf f.OverRides.count > 0 Then
            Complete = Replace(Complete, "__function_" & f.Index & "_placeholder", f.OverRideScript)
        Else
            Complete = Replace(Complete, "__function_" & f.Index & "_placeholder", f.CleanText)
        End If
    Next
    
    'another cheapshot addition..
    For Each f In funcs
        If f.UseOriginalFuncName Or chkKeepAllOrigFuncNames.value Then
            Complete = Replace(Complete, f.NewName, f.OrgName)
        End If
        If Len(f.OverRideName) > 0 Then
            Complete = Replace(Complete, f.NewName, f.OverRideName)
        End If
    Next
    
    Complete = Replace(Complete, "__gvar_", "gvar_") 'cheap shot bug fix...
    
    Form2.SaveToListView Form2.txtJS.Text, "Before Refactor" 'save a copy of the original
    Form2.txtJS.Text = Complete
    Form2.mnuFunctionScan_Click
    Unload Me
    
End Sub

Private Sub Command1_Click()
    
    'manually refactor
    
    If selli Is Nothing Then
        MsgBox "No function selected in listview"
        Exit Sub
    End If
    
    Dim f As CFunc
    Set f = selli.tag

    Text1 = f.OrgText
    
    f.debugout = True
    f.ResetParse
    f.ParseSelf
    
    LoadArgsLv f
    
    Text2 = f.CleanText
    
    
End Sub

Function LoadArgsLv(f As CFunc)
    
    Dim li As ListItem
    Dim tmp As String
    
    lvArgs.ListItems.Clear
    i = 0
    
    For Each v In f.OrgVars
        tmp = i
        If Len(tmp) = 1 Then tmp = "0" & tmp
        vnew = IIf(f.IsGlobal, "gvar_" & tmp, "v" & tmp)
        overRide = f.OverrideExists(i)

        Set li = lvArgs.ListItems.Add(, , vnew & " = " & v)
        If Len(overRide) > 0 Then li.SubItems(1) = overRide
        
        i = i + 1
    Next
    
End Function

Private Function setPB(cur As Long, max As Long)
    On Error Resume Next
    pb.value = CInt((cur / max) * 100)
    DoEvents
    Me.Refresh
    List1.ListIndex = List1.ListCount - 1
End Function

Function LoadFunctions(scriptIn As String, Optional debugMode As Boolean = False) As String
    'assumes we are receiving js beautified text
    
    Dim j As Long
    Dim jj As Long
    Dim b() As String
    Dim x
    Dim f As CFunc
    Dim li As ListItem
    Dim startAt As Long, endAt As Long
    
    marker = vbCrLf & "};" & vbCrLf
    If InStr(scriptIn, marker) > 0 Then
        scriptIn = Replace(scriptIn, marker, vbCrLf & "}" & vbCrLf)
    End If
    
    startAt = GetTickCount()
    
    Me.Visible = True
    pb.value = 0
    Set funcs = New Collection

    a = vbCrLf & scriptIn
    
    a = Replace(a, vbCrLf, " " & vbCrLf) 'add a space to end of each line
    
    lblParsingStatus = "Extracting functions..."
    
    fstart = InStr(a, vbCrLf & "function") 'first we parse out all the function names
    While fstart > 0
        setPB CLng(fstart), Len(a)
        fstart = fstart + 2
        fend = InStr(fstart, a, vbCrLf & "} " & vbCrLf)
        If fend > 0 Then
            Set f = New CFunc
            Set f.ParentForm = Me
            Set f.logger = List1
            f.OrgText = Mid(a, fstart, fend - fstart + 3)
            funcs.Add f
            f.Index = funcs.count
            f.ParseName
            Set li = lv.ListItems.Add(, , f.NewName & " = " & f.OrgName)
            Set li.tag = f
        End If
        fstart = InStr(fstart + 10, a, vbCrLf & "function")
    Wend
        
    Set global_script = New CFunc
    
    For Each li In lv.ListItems 'remove all function blocks from global script block
        Set f = li.tag
        a = Replace(a, f.OrgText, "__function_" & f.Index & "_placeholder")
    Next
    
    lblParsingStatus = "Parsing global script.."
    
    global_script.IsGlobal = True
    Set global_script.ParentForm = Me
    Set global_script.logger = List1
    global_script.OrgText = a
    global_script.ParseAsGlobal
    Set li = lv.ListItems.Add(, , "global_script")
    Set li.tag = global_script
    
    Dim xx As Long
    Dim totalVars As Long
    
    pb.value = 0
    lblParsingStatus = "Parsing function bodies..."
    
    For Each li In lv.ListItems 'this has to be last in case functions use global variables
        setPB xx, lv.ListItems.count
        Set f = li.tag
        f.ParseSelf
        totalVars = totalVars + f.OrgVars.count
        xx = xx + 1
    Next
    
    endAt = GetTickCount()
    
    Me.Caption = "Parsing took: " & (endAt - startAt) / 1000 & " secs - Found: " & _
                    lv.ListItems.count - 1 & " functions - " & _
                    global_script.OrgVars.count & " global vars - " & _
                    totalVars & " func level variables"
    
    If debugMode Then
        Me.Visible = True
    End If
    
    pb.value = 0
    fraStatus.Visible = False
    
    If lv.ListItems.count > 0 Then
        lv_ItemClick lv.ListItems(1)
    End If
    
     
    
End Function

 

Private Sub Command2_Click()
    
    Dim li As ListItem
    Dim didSomething As Boolean
    
    If selli Is Nothing Then
        MsgBox "No function selected in listview"
        Exit Sub
    End If
    
    Dim f As CFunc
    Set f = selli.tag

    Set f.OverRides = New Collection
    
    For Each li In lvArgs.ListItems
        If Len(li.tag) > 0 Then
            didSomething = True
            tmp = Split(li.Text, " = ")
            f.OverRides.Add tmp(0) & "->" & li.tag
        End If
    Next
    
    If Not didSomething Then
        MsgBox "You havent set any overrides yet. double click on the var you want to change in lower listbox"
    Else
        Text2 = f.ApplyOverrides
    End If
    
End Sub

Private Sub Command3_Click()
    
    If selli Is Nothing Then
        MsgBox "No function selected in listview"
        Exit Sub
    End If
    
    Dim f As CFunc
    Set f = selli.tag
    f.OverRideName = Empty
    
    Set f.OverRides = New Collection
    Text2 = f.CleanText
    
End Sub



Private Sub Form_Load()
    Me.Icon = Form1.Icon
    fraStatus.Top = Text1.Top
    FormPos Me, True
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    fraStatus.Width = Me.Width - fraStatus.left - 200
    w = fraStatus.Width / 2
    Text2.left = fraStatus.left + w + 100
    Text1.Width = w - 100
    Text2.Width = Text1.Width
    
    fraStatus.height = Me.height - fraStatus.Top - 600
    Text1.height = fraStatus.height
    Text2.height = fraStatus.height
    
    lvArgs.height = Me.height - lvArgs.Top - 600
    
    pb.Width = fraStatus.Width - pb.left - 200
    List1.Width = fraStatus.Width - List1.left - 200
    List1.height = fraStatus.height - List1.Top - 200
    lblCloseStatus.left = fraStatus.Width - lblCloseStatus.Width - 200
    
    fraButtons.left = Text2.left - 575
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FormPos Me, True, True
End Sub

Private Sub lblCloseStatus_Click()
    fraStatus.Visible = False
End Sub

Private Sub lblShowStatus_Click()
    fraStatus.Visible = True
End Sub

Private Sub lv_DblClick()
    On Error Resume Next
    Dim f As CFunc
    If selli Is Nothing Then Exit Sub
    Set f = selli.tag
    tmp = Trim(Split(selli.Text, "=")(1))
    x = InputBox("Override default function name with your own?", , tmp)
    If Len(x) = 0 Then
        f.OverRideName = Empty
        Exit Sub
    End If
    selli.SubItems(1) = x
    f.OverRideName = x
End Sub

Private Sub lv_ItemClick(ByVal Item As MSComctlLib.ListItem)

    Dim f As CFunc
    Set selli = Item
    Set f = Item.tag
    Text1 = f.OrgText
    
    If f.OverRides.count > 0 Then
        Text2 = f.OverRideScript
    Else
        Text2 = f.CleanText
    End If
    
    If f.IsGlobal Then
        chkUseOriginalText.enabled = False 'if you dont want to refactor main script whats the point to much would break
        chkUseOriginalText.value = 0
        chkUseOrigFuncName.enabled = False
        chkUseOrigFuncName.value = 0
    Else
        chkUseOriginalText.enabled = True
        chkUseOriginalText.value = IIf(f.UseOriginalText, 1, 0)
        chkUseOrigFuncName.enabled = True
        chkUseOrigFuncName.value = IIf(f.UseOriginalFuncName, 1, 0)
    End If
    
    LoadArgsLv f
    
End Sub

Private Sub lvArgs_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    tmp = Trim(Split(Item.Text, "=")(1))
    x = InputBox("Override default variable name with your own?", , tmp)
    If Len(x) = 0 Then Exit Sub
    Item.tag = x
    Item.SubItems(1) = x
End Sub
