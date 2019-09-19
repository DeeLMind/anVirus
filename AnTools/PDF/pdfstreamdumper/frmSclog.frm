VERSION 5.00
Begin VB.Form frmSclog 
   Caption         =   "sclog - Shellcode Logger Launch Interface"
   ClientHeight    =   6825
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10680
   LinkTopic       =   "Form3"
   ScaleHeight     =   6825
   ScaleWidth      =   10680
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
      Height          =   4695
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   9
      Text            =   "frmSclog.frx":0000
      Top             =   2040
      Width           =   10575
   End
   Begin VB.Frame Frame1 
      Caption         =   "Options"
      Height          =   1935
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   10635
      Begin VB.TextBox txtStartOffset 
         Height          =   285
         Left            =   9240
         TabIndex        =   26
         Text            =   "0"
         Top             =   585
         Width           =   675
      End
      Begin VB.CheckBox chkOffset 
         Caption         =   "Start Offset  0x"
         Height          =   255
         Left            =   7860
         TabIndex        =   25
         Top             =   600
         Width           =   1515
      End
      Begin VB.CheckBox chkAlloc 
         Caption         =   "Alloc Logging"
         Height          =   195
         Left            =   7875
         TabIndex        =   23
         Top             =   270
         Width           =   1275
      End
      Begin VB.CommandButton Command3 
         Caption         =   "Open"
         Height          =   255
         Left            =   9780
         TabIndex        =   21
         Top             =   1200
         Width           =   735
      End
      Begin VB.CheckBox chkShowAddr 
         Caption         =   "Show All Addresses"
         Height          =   255
         Left            =   5880
         TabIndex        =   20
         Top             =   600
         Width           =   1695
      End
      Begin VB.CommandButton cmdLogFile 
         Caption         =   "..."
         Height          =   255
         Left            =   9120
         TabIndex        =   19
         Top             =   1200
         Width           =   495
      End
      Begin VB.TextBox txtLogFile 
         Height          =   285
         Left            =   1500
         OLEDropMode     =   1  'Manual
         TabIndex        =   18
         Top             =   1200
         Width           =   7455
      End
      Begin VB.CheckBox chkLogFile 
         Caption         =   "Log file"
         Height          =   255
         Left            =   240
         TabIndex        =   17
         Top             =   1260
         Width           =   1035
      End
      Begin VB.CommandButton Command2 
         Caption         =   "..."
         Height          =   255
         Left            =   9090
         TabIndex        =   16
         Top             =   900
         Width           =   495
      End
      Begin VB.TextBox txtFhand 
         Height          =   285
         Left            =   1500
         OLEDropMode     =   1  'Manual
         TabIndex        =   15
         Top             =   900
         Width           =   7455
      End
      Begin VB.CheckBox chkOpenFile 
         Caption         =   "Open File"
         Height          =   195
         Left            =   240
         TabIndex        =   14
         Top             =   960
         Width           =   1095
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Launch"
         Height          =   315
         Left            =   9180
         TabIndex        =   8
         Top             =   1500
         Width           =   1455
      End
      Begin VB.CheckBox chkNoHex 
         Caption         =   "Show Data Hex Dumps"
         Height          =   255
         Left            =   5880
         TabIndex        =   7
         Top             =   240
         Width           =   2025
      End
      Begin VB.CheckBox chkDll 
         Caption         =   "Allow Any DLL 2 Load"
         Height          =   255
         Left            =   3720
         TabIndex        =   6
         Top             =   240
         Width           =   2055
      End
      Begin VB.CheckBox chkStep 
         Caption         =   "Single Step API"
         Height          =   255
         Left            =   1920
         TabIndex        =   5
         Top             =   600
         Width           =   1455
      End
      Begin VB.CheckBox chkDump 
         Caption         =   "Memory Dump"
         Height          =   255
         Left            =   240
         TabIndex        =   4
         Top             =   600
         Width           =   1575
      End
      Begin VB.CheckBox chkNoNet 
         Caption         =   "No Safety Net"
         Height          =   255
         Left            =   1920
         TabIndex        =   3
         Top             =   240
         Width           =   1455
      End
      Begin VB.CheckBox chkRedir 
         Caption         =   "Net Redirect"
         Height          =   255
         Left            =   3720
         TabIndex        =   2
         Top             =   600
         Width           =   1575
      End
      Begin VB.CheckBox chkBreak 
         Caption         =   "Add Breakpoint"
         Height          =   255
         Left            =   240
         TabIndex        =   1
         Top             =   240
         Width           =   1695
      End
      Begin VB.Label cmdMemDump 
         Caption         =   "Save Dump"
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
         Left            =   7920
         TabIndex        =   24
         Top             =   1620
         Width           =   1095
      End
      Begin VB.Label Label5 
         Caption         =   "Copy Last cmd line"
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
         Left            =   2160
         TabIndex        =   22
         Top             =   1620
         Width           =   1455
      End
      Begin VB.Label Label4 
         Caption         =   "Help Screen"
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
         Left            =   4080
         TabIndex        =   13
         Top             =   1620
         Width           =   975
      End
      Begin VB.Label Label3 
         Caption         =   "Training Video"
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
         Left            =   5340
         TabIndex        =   12
         Top             =   1620
         Width           =   1095
      End
      Begin VB.Label Label2 
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
         Left            =   180
         TabIndex        =   11
         Top             =   1620
         Width           =   1335
      End
      Begin VB.Label Label1 
         Caption         =   "Safe Example"
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
         Left            =   6720
         MousePointer    =   14  'Arrow and Question
         TabIndex        =   10
         Top             =   1620
         Width           =   975
      End
   End
End
Attribute VB_Name = "frmSclog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com

'
'           Generic Shellcode Logger v0.1 BETA
' Author David Zimmer <david@idefense.com, dzzie@yahoo.com>
' Uses the GPL Asm/Dsm Engines from OllyDbg (C) 2001 Oleh Yuschuk
'
' Usage: sclog file [/addbpx /redir /nonet /nofilt /dump /step /anydll /nohex]
'
'    file        shellcode file to execute and log
'    /addbpx     Adds a breakpoint to beginning of shellcode buffer
'    /redir      Changes IP specified in Connect() to localhost
'    /nonet      no safety net - if set we dont block any dangerous apis
'    /nofilt     no api filtering - show all hook messages
'    /dump       dump (probably decoded) shellcode at first api call
'    /step       ask user before each hooked api to continue
'    /anydll     Do not halt on unknown dlls
'    /nohex      Do not display hexdumps
'
'Note that many interesting apis are logged, but not all.
'Shellcode is allowed to run within a minimal sandbox..
'and only known safe (hooked) dlls are allowed to load
'
'It is advised to only run this in VM enviroments as not
'all paths are blocked that could lead to system subversion.
'As it runs, API hooks will be used to log actions skipping
'many dangerous functions.
'
'Use at your own risk!

'mode con cols=x
'mode con lines=x


Dim b() As Byte
Dim dlg As New clsCmnDlg
Dim scfile As String
Dim sclog As String
Dim wsh As New WshShell
Dim ts As TextStream
Dim dump_saved As Boolean

'Const def_path As String = "c:\shellcode.sc"
'Const def_dump As String = "c:\SHELLC~1.SC.dmp"
Dim def_path As String 'koji ando uac compatability - 11.27.16
Dim def_dump As String


Dim last_cmdline As String

Private Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long
Private Declare Function URLDownloadToFile Lib "urlmon" Alias "URLDownloadToFileA" (ByVal pCaller As Long, ByVal szURL As String, ByVal szFileName As String, ByVal dwReserved As Long, ByVal lpfnCB As Long) As Long

Private Function DownloadFile(url As String, saveAs As String) As Boolean
    If URLDownloadToFile(0, url, saveAs, 0, 0) = 0 Then DownloadFile = True
End Function

Public Function GetShortName(sFile As String) As String
    Dim sShortFile As String * 67
    Dim lResult As Long
    Dim iCreated As Boolean
    
    'the path must actually exist to get the short path name !!
    If Not fso.FileExists(sFile) Then
        fso.writeFile sFile, ""
        iCreated = True
    End If
    
    'Make a call to the GetShortPathName API
    lResult = GetShortPathName(sFile, sShortFile, Len(sShortFile))

    'Trim out unused characters from the string.
    GetShortName = left$(sShortFile, lResult)
    
    If Len(GetShortName) = 0 Then GetShortName = sFile
    
    If iCreated Then fso.DeleteFile sFile

End Function

Public Function InitInterface(Optional Shellcode As String = Empty)
       
    scfile = Empty
    
    If Not checkForMap() Then Command1.enabled = False
    
    If Len(Shellcode) = 0 Then
        Text1 = "No text selected! you can use demo link."
    Else
        Text1 = HexDump(Shellcode)
        b() = StrConv(Shellcode, vbFromUnicode, LANG_US)
    End If
    
    Me.Visible = True
    
    
End Function

Function checkForMap() As Boolean
        Dim url As String
        Dim msg As String
        
        msg = "Because some AV complain about shellcode analysis tools, sclog has not yet been installed." & _
               vbCrLf & vbCrLf & "Do you want to download the latest version?"
        
        url = "https://github.com/dzzie/sclog/raw/master/bin/sclog.exe"
        sclog = App.path & "\sclog.exe"
        
        If Not fso.FileExists(sclog) Then
            If MsgBox(msg, vbYesNo) = vbYes Then
                    If DownloadFile(url, sclog) Then
                        If fso.FileExists(sclog) Then
                            sclog = GetShortName(sclog) 'must come after file exists checks for it creates the file if need be..
                            checkForMap = True
                            Exit Function
                        End If
                    End If
                    MsgBox "Download failed.."
            End If
        Else
            sclog = GetShortName(sclog) 'must come after file exists checks for it creates the file if need be..
            checkForMap = True
        End If
        
End Function

Private Sub cmdLogFile_Click()
    Dim f As String
    f = dlg.SaveDialog(AllFiles, RecommendedPath(), "Save log file as", , Me.hwnd, RecommendedName("_sclog.txt"))
    If Len(f) = 0 Then Exit Sub
    txtLogFile = f
End Sub

Private Sub cmdMemDump_Click()
    On Error Resume Next
    
    If Not fso.FileExists(def_dump) Then
        MsgBox "No dump file found have you run sclog yet? Default output path is: " & def_dump, vbInformation
        Exit Sub
    End If
    
    Dim p As String
    p = dlg.SaveDialog(AllFiles, , "Save dump as", , Me.hwnd, "sc.dump")
    If Len(p) = 0 Then Exit Sub
    
    If fso.FileExists(p) Then Kill p
    FileCopy def_dump, p
    
    If Err.Number <> 0 Then
        MsgBox Err.Description
    Else
        dump_saved = True
    End If
    
End Sub

Private Sub Command1_Click()
    
    On Error Resume Next
    
    Const msg = "Warning!\n\nYou are about to try to EXECUTE LIVE the raw byte buffer below which IS PROBABLY MALICIOUS.\n\nUSE THIS ON A TEST MACHINE ONLY!"
    If MsgBox(Replace(msg, "\n", vbCrLf), vbOKCancel) = vbCancel Then Exit Sub
    
    scfile = def_path
    
    'If Len(scfile) = 0 Then
    '    scfile = dlg.SaveDialog(AllFiles, RecommendedPath(), "Save shellcode as", , Me.hwnd, RecommendedName())
    '    If Len(scfile) = 0 Then Exit Sub
        
        If fso.FileExists(scfile) Then Kill scfile
        fso.writeFile scfile, StrConv(b(), vbUnicode, LANG_US)
        
    'End If
    
    If Not checkForMap() Then Exit Sub
    Dim cmdline As String
    Dim f As String
    
    scfile = GetShortName((Replace(scfile, Chr(0), Empty)))
    cmdline = sclog & " """ & scfile & """ "
    
    If chkBreak.value = 1 Then cmdline = cmdline & " /addbpx"
    If chkDll.value = 1 Then cmdline = cmdline & " /anydll"
    If chkDump.value = 1 Then cmdline = cmdline & " /dump"
    If chkNoHex.value = 1 Then cmdline = cmdline & " /hex"
    If chkNoNet.value = 1 Then cmdline = cmdline & " /nonet"
    If chkRedir.value = 1 Then cmdline = cmdline & " /redir"
    If chkStep.value = 1 Then cmdline = cmdline & " /step"
    If chkAlloc.value = 1 Then cmdline = cmdline & " /alloc"
    If chkShowAddr.value = 1 Then cmdline = cmdline & " /showadr"
    If chkOffset.value = 1 Then
        If Not isHexNum(txtStartOffset) Then
            MsgBox "Start offset is not a valid hex number: " & txtStartOffset, vbInformation
            Exit Sub
        End If
        cmdline = cmdline & " /foff " & txtStartOffset
    End If
    
    
    
    If chkLogFile.value = 1 Then
        cmdline = cmdline & " /log " & GetShortName(txtLogFile.Text)
    End If
    
    If chkOpenFile.value = 1 Then
        If Not fso.FileExists(txtFhand) Then
            MsgBox "The file to open a handle to does not exist.", vbCritical
            Exit Sub
        End If
        cmdline = cmdline & " /fopen " & GetShortName(txtFhand.Text)
    End If
    
    'If scfile = GetShortName(txtLogFile.Text) Then
    '    MsgBox "The shellcode file can not be the same as the Log file!"
    '    Exit Sub
    'End If
    
    'If chkOpenFile.Value = 1 Then
    '    If scfile = GetShortName(txtFhand.Text) Then
    '        MsgBox "The shellcode file can not be the same as the open file!"
    '        Exit Sub
    '    End If
    'End If
    
    'If FileLen(scfile) <> UBound(b) Then 'just in case somethign screwy happened...
    '    fso.WriteFile scfile, StrConv(b(), vbUnicode)
    'End If
    
    last_cmdline = cmdline
    'Shell "cmd.exe /k mode con lines=45 && " & cmdline, vbNormalFocus
    Shell "cmd.exe /k " & cmdline, vbNormalFocus

End Sub

Private Function RecommendedPath() As String
    On Error Resume Next
    If Len(Form1.txtPDFPath) = 0 Or Form1.txtPDFPath = "Drag and drop pdf file here" Then Exit Function
    RecommendedPath = fso.GetParentFolder(Form1.txtPDFPath)
End Function

Private Function RecommendedName(Optional ext = ".sc") As String
    
    On Error Resume Next
    Dim r As String
    
    If Form1.txtPDFPath = "Drag and drop pdf file here" Or Len(Form1.txtPDFPath) = 0 Then
        If ext = ".gv" Then r = "graph.gv" Else r = "bytes.sc"
        Exit Function
    End If
    
    r = fso.GetBaseName(Form1.txtPDFPath)
    If Len(r) = 0 Then
        If ext = ".gv" Then r = "graph.gv" Else r = "bytes.sc"
    Else
        r = r & ext
    End If
    RecommendedName = r
    
    
    
End Function

Private Sub Command2_Click()
    Dim f As String
    f = dlg.OpenDialog(AllFiles, RecommendedPath(), , Me.hwnd)
    If Len(f) = 0 Then Exit Sub
    txtFhand.Text = f
End Sub

Private Sub Command3_Click()
    On Error Resume Next
    Shell "notepad.exe " & GetShortName(txtLogFile.Text), vbNormalFocus
End Sub

Private Sub Form_Load()
        
    On Error Resume Next
    Me.Icon = Form1.Icon
    f = Form1.txtPDFPath
    
    def_path = GetShortName(Environ("temp") & "\shellcode.sc")
    def_dump = GetShortName(Environ("temp") & "\SHELLC~1.SC.dmp")
    
    If Len(f) = 0 Or f = "Drag and drop pdf file here" Then Exit Sub
    pf = fso.GetParentFolder(f)
    bn = fso.GetBaseName(f)
    
    txtFhand.Text = f
    txtLogFile.Text = pf & "\" & bn & "_sclog.txt"
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    On Error Resume Next
    If fso.FileExists(def_path) Then Kill def_path
    If fso.FileExists(def_dump) Then
        If Not dump_saved Then
            If MsgBox("Memory dump was not saved. Would you like ot save it now?", vbYesNo) = vbYes Then
                cmdMemDump_Click
            End If
        End If
        Kill def_dump
    End If
End Sub

Private Sub Label1_Click()
    
    x = HexStringUnescape(QuickDecode("C8D4B33C3C3C5CB3DF0BEA60B16A0CB16A38B16A30B14A14358D721E0BC50BFC98085B483A181CFBF5373BFDDACC6A6DB16A2CB17A083BECB17C44BFFC50723BEC6CB17424B1641C3BE9D90873B110B13BEE0BC50BFC98FBF5373BFD04DC4FD03947C40147204FDA64B164203BE95EB13871B164283BE9B140B13BECB380202061615B63626BC5DC646562B12AD1BE67B7BF813B3C3C6C54C53C3C3C540CC973E0C5EFB7A7813B3C3C3BE45416595557B53C523CB7BF813B3C3C6C5418613EDAC5EFB3FE54983C3C3CB7A7353B3C3C696C54CE65B6D3C5EFB3CC6C5498C5B7CFC5EF523BB7BF813B3C3C6C540BB155BDC5EF54EC3D3C3C5480CC0FDCC5EFB7A7813B3C3C6954ED16E729C5EF523C54CC8F9A6EC5EF8C29F72C09FC858C3B833C47C99182F439D67AC6F3BCC108493FBCF940D134BCC5084939BCFD40B2F9D6B2FDD60AFCD6DAD98BF4BB3E983BD35ABC3E983B5ABB2E963B230E9B963B09EA817C3BCDC9B1CAC6B84C47DAE786CB3A858B468B5A82063BB2A8FCC6B280C539E4B2803B39E4B2C07C3B39E4FBD13AB4277E7D724FDA7E7E7D7DDAE3868A46858A3B8346066B6DC99F66543C9C3D853A4763C99F263D903BF72E50B884393CF72CF9"))
    Me.InitInterface CStr(x)
    
End Sub

Private Sub Label2_Click()
    On Error Resume Next
    f = dlg.OpenDialog(AllFiles, , "Manually load shellcode file", Me.hwnd)
    If Len(f) = 0 Then Exit Sub
    InitInterface fso.ReadFile(f)
    dump_saved = False
End Sub

Private Sub Label3_Click()
    
    On Error Resume Next
    Shell "cmd /c start http://www.youtube.com/watch?v=XBcmC4jYiRI"
    
End Sub

Private Sub Label4_Click()
    On Error Resume Next
    If checkForMap() Then
        Shell "cmd /k mode con lines=45 && " & sclog, vbNormalFocus
    End If
End Sub

Private Sub Label5_Click()
    Clipboard.Clear
    Clipboard.SetText last_cmdline
    MsgBox "Last command line copied to clipboard: " & vbCrLf & vbCrLf & last_cmdline, vbInformation
End Sub

Private Sub txtFhand_OLEDragDrop(data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    On Error Resume Next
    txtFhand.Text = data.Files(1)
End Sub

Private Sub txtLogFile_OLEDragDrop(data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
     On Error Resume Next
     txtLogFile.Text = data.Files(1)
End Sub
