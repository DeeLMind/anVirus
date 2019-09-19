VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "AS3 Sorcerer Web Install"
   ClientHeight    =   3525
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7920
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3525
   ScaleWidth      =   7920
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command2 
      Caption         =   "No Thanks - Exit "
      Height          =   495
      Left            =   120
      TabIndex        =   3
      Top             =   3000
      Width           =   1575
   End
   Begin Project1.ucAsyncDownload ucAsyncDownload1 
      Height          =   255
      Left            =   7680
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   255
      _ExtentX        =   450
      _ExtentY        =   450
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Yes - Download and Install"
      Height          =   495
      Left            =   5700
      TabIndex        =   1
      Top             =   3000
      Width           =   2115
   End
   Begin MSComctlLib.ProgressBar pb 
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   2640
      Width           =   7695
      _ExtentX        =   13573
      _ExtentY        =   450
      _Version        =   393216
      Appearance      =   1
   End
   Begin VB.Label Label6 
      Caption         =   "Already Installed? "
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   1920
      TabIndex        =   9
      Top             =   3240
      Width           =   1815
   End
   Begin VB.Label Label5 
      Caption         =   "Manually set path"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   3840
      TabIndex        =   8
      Top             =   3240
      Width           =   1815
   End
   Begin VB.Label Label4 
      Caption         =   "Trial Details"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   5040
      TabIndex        =   7
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Homepage:"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   2280
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "http://www.as3sorcerer.com"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   1320
      TabIndex        =   5
      Top             =   2280
      Width           =   3015
   End
   Begin VB.Image Image1 
      Height          =   2565
      Left            =   5880
      Picture         =   "Form1.frx":0000
      Top             =   0
      Width           =   2085
   End
   Begin VB.Label Label1 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2055
      Left            =   240
      TabIndex        =   4
      Top             =   120
      Width           =   5415
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
        ucAsyncDownload1.StartDownload "http://www.as3sorcerer.com/as3sorcerer_setup.exe" ', vbAsyncReadForceUpdate
End Sub

Function isIde() As Boolean
    On Error GoTo hell
    Debug.Print 1 / 0
    isIde = False
    Exit Function
hell:
    isIde = True
End Function

Private Sub Command2_Click()
    ucAsyncDownload1.AbortDownload
    pb.Value = 0
    End
End Sub

Function isAS3Sorcerer_Installed(ByRef exe_path As String) As Boolean
    On Error Resume Next
    Dim p As String
    
    p = GetSetting("PDFStreamDumper", "3rdParty", "AS3Sorcerer", "") 'manually specified
    If FileExists(p) Then
        exe_path = p
        isAS3Sorcerer_Installed = True
        Exit Function
    End If
    
    p = Environ("ProgramFiles")
    
    If Len(p) = 0 Then
        'MsgBox "Using default %ProgramFiles% path", vbInformation
        p = "C:\Program Files\"
    End If
    
    If Not FolderExists(p) Then
        MsgBox "Could not locate  %ProgramFiles% Directory?", vbInformation
        Exit Function
    End If
    
    exe_path = p & "\AS3 Sorcerer\as3s.exe"
    
    If FileExists(exe_path) Then
        isAS3Sorcerer_Installed = True
    End If

End Function


Private Sub Form_Load()

    Dim exe_path As String
    
    If Not isIde() And Len(Command) = 0 Then
        If isAS3Sorcerer_Installed(exe_path) Then End
    End If
        
    Const tmp = "PdfStreamDumper can integrate with AS3 Sorcerer to decompile " & _
                "Flash ActionScript 3 to source form. This is very useful for " & _
                "analyzing embedded Flash files." & vbCrLf & vbCrLf & _
                "AS3 Sorcerer was not detected on your system." & vbCrLf & vbCrLf & _
                "Would you like to install a free trial that allows you to view " & _
                "the decompiled scripts?"
                
    Label1.Caption = tmp
    
    
End Sub


Private Sub Label2_Click()
    On Error Resume Next
    Shell "cmd /c start http://www.as3sorcerer.com/index.html"
End Sub

Private Sub Label4_Click()

    Const msg = "Trial is not time limited, it does display a nag. " & vbCrLf & vbCrLf & _
                "Viewing of decompiled source is very good, however " & _
                "copy and paste is disabled in the trial." & vbCrLf & vbCrLf & _
                "Application is programmed very well and is the only one I have found " & _
                "which is reliable to use on malformed files. " & vbCrLf & _
                "Also it does not load and execute the swf in anyway unlike others." & vbCrLf & vbCrLf & _
                "Decompilation results are exactly the same for trial and licensed modes." & vbCrLf & vbCrLf & _
                "Download size is 5mb" & vbCrLf & _
                "License cost is $22 US to buy." & vbCrLf & _
                "No adware or spyware, full uninstaller is included." & vbCrLf & vbCrLf & _
                "AS3 Sorcerer is developed by Manitu Group and is not affiliated with " & vbCrLf & _
                "Sandsprite in anyway. I include this because i find it to be good software."

    MsgBox msg, vbInformation, "Download details"
    
End Sub

Private Sub Label5_Click()
    On Error Resume Next
    Dim dlg As New clsCmnDlg
    Dim p As String
    p = dlg.OpenDialog(exeFiles, , "Manually Specify AS3 Sorcerer Executable Path", Me.hWnd)
    'If Len(p) = 0 Or Dir(p) = "" Then Exit Sub 'I want to be able to reset it to empty with this too..
    SaveSetting "PDFStreamDumper", "3rdParty", "AS3Sorcerer", p
    MsgBox "Installation path manually set!", vbInformation
    End
End Sub

Private Sub ucAsyncDownload1_DownloadComplete(fPath As String)

    On Error Resume Next
    
    Name fPath As fPath & ".exe"
    
    If Err.Number <> 0 Then
        MsgBox "Error renaming temp file to exe extension" & vbCrLf & vbCrLf & "Installer: " & fPath, vbInformation
        Exit Sub
    End If
    
    Shell fPath & ".exe", vbNormalFocus
    
    If Err.Number <> 0 Then
        MsgBox "Error executing installer?" & vbCrLf & vbCrLf & "Installer: " & fPath & ".exe", vbInformation
        Exit Sub
    End If
    
    DoEvents
    End
    
End Sub

Private Sub ucAsyncDownload1_Error(code As Long, msg As String)
    MsgBox "Error downloading file: " & vbCrLf & msg, vbInformation
End Sub

Private Sub ucAsyncDownload1_Progress(current As Long, total As Long)
    On Error Resume Next
    pb.Max = total + 1
    pb.Value = current
    DoEvents
End Sub

Function FolderExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbDirectory) <> "" Then FolderExists = True _
  Else FolderExists = False
End Function

Function FileExists(path) As Boolean
  On Error Resume Next
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbHidden Or vbNormal Or vbReadOnly Or vbSystem) <> "" Then
     If Err.Number <> 0 Then Exit Function
     FileExists = True
  End If
End Function
