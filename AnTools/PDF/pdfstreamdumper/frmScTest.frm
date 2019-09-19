VERSION 5.00
Begin VB.Form frmScTest 
   Caption         =   "scDbg - libemu Shellcode Logger Launch Interface"
   ClientHeight    =   7170
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10140
   LinkTopic       =   "Form3"
   ScaleHeight     =   7170
   ScaleWidth      =   10140
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4950
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   2175
      Width           =   9960
   End
   Begin VB.Frame Frame1 
      Caption         =   "Options"
      Height          =   2145
      Left            =   60
      TabIndex        =   0
      Top             =   0
      Width           =   10005
      Begin VB.CheckBox chkIgnoreRW 
         Caption         =   "Do not log RW"
         Height          =   195
         Left            =   5640
         TabIndex        =   29
         Top             =   480
         Width           =   1395
      End
      Begin VB.CommandButton cmdrowse 
         Caption         =   "..."
         Height          =   285
         Index           =   1
         Left            =   7860
         TabIndex        =   28
         Top             =   1080
         Width           =   465
      End
      Begin VB.TextBox txtTemp 
         Height          =   315
         Left            =   1050
         OLEDropMode     =   1  'Manual
         TabIndex        =   27
         Top             =   1080
         Width           =   6705
      End
      Begin VB.CheckBox chktemp 
         Caption         =   "temp"
         Height          =   315
         Left            =   210
         TabIndex        =   26
         Top             =   1080
         Width           =   795
      End
      Begin VB.TextBox txtManualArgs 
         Height          =   285
         Left            =   1800
         TabIndex        =   25
         Top             =   1440
         Width           =   5955
      End
      Begin VB.TextBox txtStartOffset 
         Height          =   285
         Left            =   9240
         TabIndex        =   22
         Text            =   "0"
         Top             =   180
         Width           =   675
      End
      Begin VB.CheckBox chkOffset 
         Caption         =   "Start Offset  0x"
         Height          =   255
         Left            =   7860
         TabIndex        =   23
         Top             =   180
         Width           =   1395
      End
      Begin VB.CommandButton cmdrowse 
         Caption         =   "..."
         Height          =   285
         Index           =   0
         Left            =   7860
         TabIndex        =   21
         Top             =   720
         Width           =   465
      End
      Begin VB.TextBox txtFopen 
         Height          =   285
         Left            =   1035
         OLEDropMode     =   1  'Manual
         TabIndex        =   20
         Top             =   720
         Width           =   6720
      End
      Begin VB.CheckBox chkfopen 
         Caption         =   "fopen"
         Height          =   240
         Left            =   225
         TabIndex        =   19
         Top             =   780
         Width           =   1230
      End
      Begin VB.CheckBox ChkMemMon 
         Caption         =   "Monitor DLL Read/Write"
         Height          =   195
         Left            =   7860
         TabIndex        =   18
         Top             =   480
         Width           =   2055
      End
      Begin VB.CheckBox chkFindSc 
         Caption         =   "FindSc"
         Height          =   255
         Left            =   5640
         TabIndex        =   17
         Top             =   180
         Width           =   1095
      End
      Begin VB.CheckBox chkDebugShell 
         Caption         =   "Debug Shell"
         Height          =   195
         Left            =   4080
         TabIndex        =   16
         Top             =   480
         Width           =   1455
      End
      Begin VB.CheckBox chkUnlimitedSteps 
         Caption         =   "Unlimited steps"
         Height          =   255
         Left            =   4080
         TabIndex        =   15
         Top             =   180
         Width           =   1635
      End
      Begin VB.CheckBox chkApiTable 
         Caption         =   "Scan for Api table"
         Height          =   195
         Left            =   1920
         TabIndex        =   9
         Top             =   180
         Width           =   1995
      End
      Begin VB.CheckBox chkInteractiveHooks 
         Caption         =   "Use Interactive Hooks"
         Height          =   255
         Left            =   1920
         TabIndex        =   8
         Top             =   420
         Width           =   1935
      End
      Begin VB.CheckBox chkCreateDump 
         Caption         =   "Create Dump"
         Height          =   255
         Left            =   240
         TabIndex        =   7
         Top             =   420
         Width           =   1455
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Launch"
         Height          =   375
         Left            =   8325
         TabIndex        =   2
         Top             =   1395
         Width           =   1575
      End
      Begin VB.CheckBox chkReport 
         Caption         =   "Report Mode"
         Height          =   255
         Left            =   240
         TabIndex        =   1
         Top             =   180
         Width           =   1695
      End
      Begin VB.Label Label1 
         Caption         =   "Manual  Arguments"
         Height          =   285
         Left            =   225
         TabIndex        =   24
         Top             =   1440
         Width           =   1410
      End
      Begin VB.Label Label6 
         Caption         =   "scdbg homepage"
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
         Index           =   8
         Left            =   3450
         TabIndex        =   14
         Top             =   1770
         Width           =   1335
      End
      Begin VB.Label Label6 
         Caption         =   "cmdline"
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
         Index           =   7
         Left            =   4830
         TabIndex        =   13
         Top             =   1770
         Width           =   675
      End
      Begin VB.Label Label6 
         Caption         =   "Save dump"
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
         Index           =   0
         Left            =   8160
         TabIndex        =   12
         Top             =   1770
         Width           =   855
      End
      Begin VB.Label Label6 
         Caption         =   "Video Demo"
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
         Index           =   2
         Left            =   5550
         TabIndex        =   11
         Top             =   1770
         Width           =   1035
      End
      Begin VB.Label Label6 
         Caption         =   "Help"
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
         Index           =   6
         Left            =   6630
         TabIndex        =   10
         Top             =   1770
         Width           =   375
      End
      Begin VB.Label Label6 
         Caption         =   "Libemu HomePage"
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
         Index           =   4
         Left            =   1830
         TabIndex        =   6
         Top             =   1770
         Width           =   1455
      End
      Begin VB.Label Label6 
         Caption         =   "Manually Load File"
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
         Index           =   3
         Left            =   210
         TabIndex        =   5
         Top             =   1770
         Width           =   1335
      End
      Begin VB.Label Label6 
         Caption         =   "Example"
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
         Index           =   5
         Left            =   7305
         TabIndex        =   4
         Top             =   1770
         Width           =   735
      End
   End
End
Attribute VB_Name = "frmScTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim b() As Byte
Dim dlg As New clsCmnDlg
Dim scfile As String
Dim sctest As String
Dim lastcmdline As String

'Private Declare Function WinExec Lib "kernel32" (ByVal lpCmdLine As String, ByVal nCmdShow As Long) As Long
'Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
'Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
'Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
'Private Const SYNCHRONIZE = &H100000
'Private Const INFINITE = &HFFFF

Const INFINITE = &HFFFF
Const STARTF_USESHOWWINDOW = &H1
Private Enum enSW
    SW_HIDE = 0
    SW_NORMAL = 1
    SW_MAXIMIZE = 3
    SW_MINIMIZE = 6
End Enum

Private Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessID As Long
    dwThreadID As Long
End Type

Private Type STARTUPINFO
    cb As Long
    lpReserved As String
    lpDesktop As String
    lpTitle As String
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Byte
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type

Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Private Enum enPriority_Class
    NORMAL_PRIORITY_CLASS = &H20
    IDLE_PRIORITY_CLASS = &H40
    HIGH_PRIORITY_CLASS = &H80
End Enum

Private Declare Function CreateProcess Lib "kernel32" Alias "CreateProcessA" (ByVal lpApplicationName As String, ByVal lpCommandLine As String, lpProcessAttributes As SECURITY_ATTRIBUTES, lpThreadAttributes As SECURITY_ATTRIBUTES, ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, lpEnvironment As Any, ByVal lpCurrentDriectory As String, lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
Private Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long

Private Function SuperShell(ByVal App As String, ByVal WorkDir As String, Optional wait As Boolean = False, Optional dwMilliseconds As Long = 0, Optional start_size As enSW = SW_NORMAL, Optional Priority_Class As enPriority_Class = NORMAL_PRIORITY_CLASS) As Boolean

        Dim pclass As Long
        Dim sinfo As STARTUPINFO
        Dim pinfo As PROCESS_INFORMATION
        Dim sec1 As SECURITY_ATTRIBUTES
        Dim sec2 As SECURITY_ATTRIBUTES
        sec1.nLength = Len(sec1)
        sec2.nLength = Len(sec2)
        sinfo.cb = Len(sinfo)
        sinfo.dwFlags = STARTF_USESHOWWINDOW
        sinfo.wShowWindow = start_size
        pclass = Priority_Class
        
        If CreateProcess(vbNullString, App, sec1, sec2, False, pclass, 0&, WorkDir, sinfo, pinfo) Then
            If wait Then WaitForSingleObject pinfo.hProcess, dwMilliseconds
            SuperShell = True
        Else
            SuperShell = False
        End If
        
End Function


'file msut exist for this to work which is stupid...
Public Function GetShortName(sFile As String) As String
    Dim sShortFile As String * 67
    Dim lResult As Long

    'Make a call to the GetShortPathName API
    lResult = GetShortPathName(sFile, sShortFile, _
    Len(sShortFile))

    'Trim out unused characters from the string.
    GetShortName = left$(sShortFile, lResult)

End Function

Public Function InitInterface(Optional Shellcode As String = Empty)
       
    scfile = Empty
    
    If Not checkFor_sctest() Then Command1.enabled = False
    
    If Len(Shellcode) = 0 Then
        Text1 = "No text selected! you can use demo link."
    Else
        Text1 = HexDump(Shellcode)
        b() = StrConv(Shellcode, vbFromUnicode, LANG_US)
    End If
    
    Me.Visible = True
    
    
End Function

Function checkFor_sctest() As Boolean
        
        sctest = App.path & "\libemu\scdbg.exe"
        If Not fso.FileExists(sctest) Then
            MsgBox "Can not find scdbg? Should be distributed with installer?"
        Else
            checkFor_sctest = True
        End If
        
End Function


Private Sub cmdrowse_Click(Index As Integer)
    Dim f As String
    f = dlg.OpenDialog(AllFiles)
    If Index = 0 Then txtFopen.Text = f Else txtTemp = f
    If Len(f) > 0 Then
        If Index = 0 Then chkfopen.value = 1 Else chktemp.value = 1
        If Index = 0 And Len(txtTemp) = 0 Then
            txtTemp = fso.GetParentFolder(txtFopen) & "\"
            chktemp.value = 1
        End If
    End If
End Sub

Private Sub Command1_Click()
    
    On Error Resume Next
    
    scfile = App.path & "\libemu\sample.sc"
    
    If fso.FileExists(scfile) Then Kill scfile
    fso.writeFile scfile, StrConv(b(), vbUnicode, LANG_US)

    sctest = App.path & "\libemu\scdbg.exe"
    If Not fso.FileExists(sctest) Then
        MsgBox "Can not find sctest in app.path exiting", vbCritical
        Exit Sub
    End If
   
    Dim cmdline As String
    Dim graphpth As String
    
    scfile = Trim(Replace(scfile, Chr(0), Empty))
    cmdline = GetShortName(sctest)
    libemu = GetShortName(App.path & "\libemu")
    
    If chkApiTable.value = 1 Then cmdline = cmdline & " -api"
    If chkInteractiveHooks.value = 1 Then cmdline = cmdline & " -i"
    If chkCreateDump.value = 1 Then cmdline = cmdline & " -d"
    If chkReport.value = 1 Then cmdline = cmdline & " -r"
    If chkUnlimitedSteps.value = 1 Then cmdline = cmdline & " -s -1"
    If chkDebugShell.value = 1 Then cmdline = cmdline & " -vvv"
    If chkFindSc.value = 1 Then cmdline = cmdline & " -findsc"
    If ChkMemMon.value = 1 Then cmdline = cmdline & " -mdll"
    If chktemp.value = 1 Then cmdline = cmdline & " -temp " & GetShortName(txtTemp)
    If chkIgnoreRW.value = 1 Then cmdline = cmdline & " -norw"
    
    If chkOffset.value = 1 Then
        If Not isHexNum(txtStartOffset) Then
            MsgBox "Start offset is not a valid hex number: " & txtStartOffset, vbInformation
            Exit Sub
        End If
        cmdline = cmdline & " -foff " & txtStartOffset
    End If
    
    If chkfopen.value = 1 Then
        If Not fso.FileExists(txtFopen.Text) Then
            MsgBox "You must specify a valid file to open", vbInformation
            Exit Sub
        End If
        cmdline = cmdline & " -fopen " & GetShortName(txtFopen)
    End If
                                
    cmdline = cmdline & " -f sample.sc" & " " & txtManualArgs
    
    cmdline = "cmd /k chdir /d " & libemu & "\ && " & cmdline
    lastcmdline = cmdline
    
    pid = Shell(cmdline, vbNormalFocus)
    
    'If chkGraph.Value = 1 And fso.FileExists("c:\sc_graph.dot") Then
    '    graphpth = dlg.SaveDialog(AllFiles, RecommendedPath(), "Save Graph as", , Me.hwnd, RecommendedName(".gv"))
    '    If Len(graphpth) <> 0 Then
    '        If fso.FileExists(graphpth) Then Kill graphpth
    '        x = fso.ReadFile("c:\sc_graph.dot")
    '        fso.WriteFile graphpth, x
    '    End If
    '    fso.DeleteFile "c:\sc_graph.dot"
    'End If
    
End Sub

Private Function RecommendedPath() As String
    On Error Resume Next
    RecommendedPath = fso.GetParentFolder(Form1.txtPDFPath)
End Function

Private Function RecommendedName(Optional ext = ".sc") As String
    
    On Error Resume Next
    Dim r As String
    
    If Form1.txtPDFPath <> "Drag and drop pdf file here" Then
        r = fso.GetBaseName(Form1.txtPDFPath)
    End If
    
    'old extension was .gv
    If Len(r) = 0 Then
        If ext = ".sc" Then r = "bytes.sc" Else r = "graph" & ext
    Else
        r = r & ext
    End If
    RecommendedName = r
    
End Function
    

Private Sub Form_Load()
    Me.Icon = Form1.Icon
    If fso.FileExists(Form1.txtPDFPath) Then
        txtFopen = Form1.txtPDFPath
        txtTemp = fso.GetParentFolder(txtFopen)
        chktemp.value = 1
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    On Error Resume Next
    Kill App.path & "\libemu\sample.unpack"
    Kill App.path & "\libemu\graph.dot"
End Sub


Private Sub Label6_Click(Index As Integer)
    On Error Resume Next
     
    cap = Label6(Index).Caption
    
    If InStr(cap, "Help") > 0 Then
        Shell "cmd /k mode con lines=45 cols=100 && """ & App.path & "\libemu\scdbg.exe"" -h", vbNormalFocus
    End If
    
    If InStr(cap, "Home") > 0 Then
        Shell "cmd /c start http://libemu.carnivore.it/"
    End If
    
    If InStr(cap, "Manual") > 0 Then
        f = dlg.OpenDialog(AllFiles, , "Manually load shellcode file", Me.hwnd)
        If Len(f) = 0 Then Exit Sub
        InitInterface fso.ReadFile(f)
    End If
    
    If InStr(cap, "Example") > 0 Then
        x = QuickDecode("ACACD13AD13FD4C3C5C5C5610BF38BDCBC49382A79DAC31BEA4E2B6A1A5226A36A26A35A3685A36A22C321A36A1EA56A56A36A16A3FA2B6A16A3E42B6252A3690AA3F42B71361BD71BE07F7FA3E42B263AA951244D5B5B695D2CA31BA9512B5E7E425C5D2CA313ABEA2EABEB2EADE05EF3ADD75EFF2BDC2BD47FC20D2A2A2A5E505E5A084D524D0A05410A1A081A081A081A0A4F4D5E0A5F4148495A411B1C084D524D2A442AC20B2A2A2A5D29EBC2252A2A2A5F4148495A411B1C084D524D2A442AC22F2A2A2A27AEC9D7D7D7EB7273757AABC67E1BEAA3D6A5626AA3FFDB849A6E837F7C79794402442979797D7BD700ABEE7EADEAEB683C793C203C683C0B3C0A3C093C103C0F3C0E3C")
        x = HexStringUnescape(x)
        Me.InitInterface CStr(x)
    End If
    
    If InStr(cap, "Demo") > 0 Then
        Shell "cmd /c start http://www.youtube.com/watch?v=jFkegwFasIw"
    End If
    
    If InStr(cap, "scdbg") > 0 Then
        Shell "cmd /c start http://sandsprite.com/blogs/index.php?uid=7^&pid=152"
    End If
    
    dump = App.path & "\libemu\sample.unpack"
    If InStr(1, cap, "dump", 1) > 0 Then
        If Not fso.FileExists(dump) Then
            MsgBox "No dump file found. Maybe no changes were detected.", vbInformation
        Else
            pth = dlg.SaveDialog(AllFiles, , "Save dump as", , Me.hwnd, RecommendedName())
            If Len(pth) = 0 Then Exit Sub
            FileCopy dump, pth
        End If
    End If
    
    graph = App.path & "\libemu\graph.dot"
    If InStr(1, cap, "graph", 1) > 0 Then
        If Not fso.FileExists(graph) Then
            MsgBox "No graph file found", vbInformation
        Else
            pth = dlg.SaveDialog(AllFiles, , "Save graph as", , Me.hwnd, RecommendedName(".dot"))
            If Len(pth) = 0 Then Exit Sub
            FileCopy graph, pth
        End If
    End If
    
    If InStr(1, cap, "cmdline", 1) > 0 Then
        Clipboard.Clear
        Clipboard.SetText lastcmdline
        MsgBox Len(lastcmdline) & " bytes copied to clipboard", vbInformation
    End If
    
    
End Sub

Private Sub txtFopen_OLEDragDrop(data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    On Error Resume Next
    txtFopen.Text = data.Files(1)
    chkfopen.value = 1
    If Len(txtTemp) = 0 Then
        txtTemp = fso.GetParentFolder(txtFopen) & "\"
        chktemp.value = 1
    End If
End Sub

Private Sub txtTemp_OLEDragDrop(data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    On Error Resume Next
    txtTemp.Text = data.Files(1)
    chktemp.value = 1
End Sub
