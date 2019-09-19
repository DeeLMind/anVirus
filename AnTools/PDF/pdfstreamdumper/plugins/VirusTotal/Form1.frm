VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Virus Total Sample Lookup"
   ClientHeight    =   6345
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9210
   LinkTopic       =   "Form1"
   ScaleHeight     =   6345
   ScaleWidth      =   9210
   StartUpPosition =   2  'CenterScreen
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
      Height          =   4155
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   5
      Top             =   2100
      Width           =   9165
   End
   Begin VB.TextBox txtFile 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   870
      TabIndex        =   4
      Top             =   60
      Width           =   8265
   End
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1230
      Left            =   0
      TabIndex        =   2
      Top             =   810
      Width           =   9165
   End
   Begin VB.TextBox txtHash 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   840
      TabIndex        =   1
      Top             =   480
      Width           =   4635
   End
   Begin VB.Label Label2 
      Caption         =   "File: "
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   60
      TabIndex        =   3
      Top             =   60
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "MD5"
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   120
      TabIndex        =   0
      Top             =   510
      Width           =   615
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuCopyLine 
         Caption         =   "Copy Line"
      End
      Begin VB.Menu mnuCopyTable 
         Caption         =   "Copy Table"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public frmMain As Object

Dim http As XMLHTTP
Dim md5 As New MD5Hash

Const URL_API_BASIS = "https://www.virustotal.com/vtapi/v2/"
Const URL_SCAN_FILE = "file/scan"
Const URL_FILE_REPORT = "file/report"
Const URL_SCAN_URL = "url/scan"
Const URL_URL_REPORT = "url/report"
Const API_KEY = "a949ea9c64e7145a065b0e562673a66216a132712e958168c8c00ee5f451485b"

Public Sub Form_Load()

    On Error Resume Next
    
    Dim pdf As String
    Dim hash As String
    Dim my_json As String
    Dim sStatus As String
    Dim status As Long
    Dim d As Dictionary
    
    Me.Show
    
    Set http = New XMLHTTP
    
    If http Is Nothing Then
        List1.AddItem "Could not create XMLHTTP Object"
        Exit Sub
    End If
    
    pdf = frmMain.txtPDFPath.Text
    txtFile = pdf
    
    If Not FileExists(pdf) Then
        List1.AddItem "Load a file in PDF StreamDumper first"
        Exit Sub
    End If
    
    hash = md5.HashFile(pdf)
    txtHash = hash
    
    List1.AddItem "Connecting to VirusTotal to query report for " & hash
    
    Me.Refresh
    DoEvents
    
    If Not Get_VT_Report(hash, my_json, sStatus, status) Then
        List1.AddItem "Could not get VirusTotal page, returned status code: " & status & " " & sStatus
        Exit Sub
    End If
    
    List1.AddItem "Report found for md5: " & hash
         
    Set d = JSON.parse(my_json)
    If d Is Nothing Then
        List1.AddItem "An error occurred parsing the JSON returned from VT"
        Exit Sub
    End If
    
    If JSON.GetParserErrors <> "" Then
        List1.AddItem "Json Parse Error: " & JSON.GetParserErrors
        Exit Sub
    End If
      
    report = ParseVTJSON(d)

    Text1 = report

End Sub

Private Function FileExists(p) As Boolean
    If Len(p) = 0 Then Exit Function
    If Dir(p, vbNormal Or vbHidden Or vbReadOnly Or vbSystem) <> "" Then FileExists = True
End Function

Function ParseVTJSON(d As Dictionary) As String
    Dim r As String
    Dim scans As Dictionary
    Dim scanner As Dictionary
    Dim entry, s
    
    If d.Item("response_code") <> 1 Then
        r = "Not found in Virustotal"
        GoTo retnow
    End If
    
    
    If d.Item("positives") = 0 Then
        r = "This sample had no detections."
        GoTo retnow
    End If
        
    r = pad("scan_date: ") & d.Item("scan_date") & vbCrLf
    r = r & pad("positives: ") & d.Item("positives") & "/" & d.Item("total") & vbCrLf
    r = r & pad("MD5: ") & d.Item("md5") & vbCrLf
    r = r & String(45, "-") & vbCrLf

    Set scans = d.Item("scans")
    For Each s In scans.keys
        Set scanner = scans.Item(s)
        If scanner.Item("detected") = True Then
            r = r & pad(s & ": ") & scanner.Item("result") & vbCrLf
        End If
    Next
    

retnow:
    ParseVTJSON = r
    
End Function

Function pad(ByVal x, Optional sz As Long = 25)
    While Len(x) < sz
        x = x & " "
    Wend
    pad = x
End Function


Function Get_VT_Report(hash, out_response As String, out_status As String, out_statusCode As Long) As Boolean
    
    Err.Clear
    On Error GoTo hell
    
    Dim x As Variant
    out_status = Empty
    out_response = Empty
    
1    http.Open "POST", URL_API_BASIS & URL_FILE_REPORT, False
2    http.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
3    http.send "key=" & API_KEY & "&resource=" & hash
    
     DoEvents
     
5    out_status = http.statusText
6    out_statusCode = http.status
7    out_response = http.responseText
     If out_status = "OK" Then Get_VT_Report = True
    
hell:
    DoEvents
    If Err.Number <> 0 Then
        List1.AddItem "Error in Get_VT Report Line: " & Erl & " desc: " & Err.Description
    End If
    
End Function
