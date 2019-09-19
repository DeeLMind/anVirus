VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CVirusTotal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Dim http As XMLHTTP

Const URL_API_BASIS = "https://www.virustotal.com/vtapi/v2/"
Const URL_SCAN_FILE = "file/scan"
Const URL_FILE_REPORT = "file/report"
Const URL_SCAN_URL = "url/scan"
Const URL_URL_REPORT = "url/report"
Const URL_MAKE_COMMENT = "comments/put"
Const API_KEY = "a949ea9c64e7145a065b0e562673a66216a132712e958168c8c00ee5f451485b"

Const report_cache_dir = ""

Public List1 As ListBox 'for logging...

Public WasCached As Boolean

Function GetVTReport(hash As String, ByRef output As String, ByRef detections As Long) As Boolean

    On Error Resume Next
    
    Dim pdf As String
   
    Dim my_json As String
    Dim sStatus As String
    Dim status As Long
    Dim d As Dictionary
    
    If List1 Is Nothing Then
        MsgBox "Set logging listbox first"
        Exit Function
    End If
    
    detections = 0
    WasCached = True
    
    List1.Clear
    Set http = New XMLHTTP
    
    If http Is Nothing Then
        List1.AddItem "Could not create XMLHTTP Object"
        Exit Function
    End If
       
    If FolderExists(report_cache_dir) Then
        If FileExists(report_cache_dir & "\" & hash & ".txt") Then
            List1.AddItem "Cached report found for" & hash
            my_json = ReadFile(report_cache_dir & "\" & hash & ".txt")
            GoTo parse_json
        End If
    End If
            
    List1.AddItem "Connecting to VirusTotal to query report for " & hash
    
    DoEvents
    
    WasCached = False 'need 4 second delay for next
    If Not Get_VT_Report(hash, my_json, sStatus, status) Then
        List1.AddItem "Could not get VirusTotal page, returned status code: " & status & " " & sStatus
        'output = List1.List(List1.ListCount)
        Exit Function
    End If
    
    List1.AddItem "Report found for md5: " & hash
         
parse_json:
    Set d = JSON.parse(my_json)
    If d Is Nothing Then
        List1.AddItem "An error occurred parsing the JSON returned from VT"
        'output = List1.List(List1.ListCount)
        Exit Function
    End If
    
    If JSON.GetParserErrors <> "" Then
        List1.AddItem "Json Parse Error: " & JSON.GetParserErrors
        'output = List1.List(List1.ListCount)
        Exit Function
    End If
      
    report = ParseVTJSON(d, detections)

    output = report
    GetVTReport = True
    
End Function

Function FileExists(p) As Boolean
    If Len(p) = 0 Then Exit Function
    If Dir(p, vbNormal Or vbHidden Or vbReadOnly Or vbSystem) <> "" Then FileExists = True
End Function

Private Function ParseVTJSON(d As Dictionary, ByRef detections As Long) As String
    Dim r As String
    Dim scans As Dictionary
    Dim scanner As Dictionary
    Dim entry, s
    
    If d.Item("response_code") <> 1 Then
        detections = -1
        r = "Not found in Virustotal"
        GoTo retnow
    End If
    
    
    If d.Item("positives") = 0 Then
        detections = 0
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
            detections = detections + 1
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


Private Function Get_VT_Report(hash, out_response As String, out_status As String, out_statusCode As Long) As Boolean
    
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

Function AddComment(hash, comment, out_response As String, out_status As String, out_statusCode As Long) As Boolean
    
    Err.Clear
    On Error GoTo hell
    
    Dim x As Variant
    out_status = Empty
    out_response = Empty
    
1    http.Open "POST", URL_API_BASIS & URL_MAKE_COMMENT, False
2    http.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
3    http.send "key=" & API_KEY & "&resource=" & hash & "&comment=" & comment
    
     DoEvents
     
5    out_status = http.statusText
6    out_statusCode = http.status
7    out_response = http.responseText
     If out_status = "OK" Then AddComment = True
    
hell:
    DoEvents
    If Err.Number <> 0 Then
        List1.AddItem "Error in AddComment Line: " & Erl & " desc: " & Err.Description
    End If
    
End Function

Function FolderExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbDirectory) <> "" Then FolderExists = True _
  Else FolderExists = False
End Function

Function ReadFile(filename) As String 'this one should be binary safe...
  On Error GoTo hell
  f = FreeFile
  Dim b() As Byte
  Open filename For Binary As #f
  ReDim b(LOF(f) - 1)
  Get f, , b()
  Close #f
  ReadFile = StrConv(b(), vbUnicode, LANG_US)
  Exit Function
hell:   ReadFile = ""
End Function
