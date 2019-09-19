VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSharpFilters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Dim iTextFilters As Object

Public Initilized As Boolean
Public ErrorMessage As String

Private Sub Class_Initialize()
    
    If Not DetectDotNet() Then
        ErrorMessage = ".Net v2.0 Not found on this machine"
        Exit Sub
    End If
    
    On Error Resume Next
    Set iTextFilters = CreateObject("iText_Filters.StringDecoder")
    
    If Err.Number <> 0 Or iTextFilters Is Nothing Then
        ErrorMessage = "Could not create CreateObject(iText_Filters.StringDecoder) " & vbCrLf & Err.Description
        Exit Sub
    End If
    
    Initilized = True
    
End Sub

Public Function DetectDotNet() As Boolean
    Dim wsh As New WshShell
    On Error GoTo hell
    Dim folders() As String, f
    
    installroot = wsh.RegRead("HKLM\SOFTWARE\Microsoft\.NETFramework\InstallRoot")
    
    If Not fso.FolderExists(installroot) Then GoTo hell
    
    folders = fso.GetSubFolders(installroot)
    
    For Each f In folders
        If VBA.Left(f, 2) = "v2" Then
            DetectDotNet = True
            Exit Function
        End If
    Next
    
    Exit Function
hell:
End Function

Function RunLengthDecode(data As String, Optional hadError As Boolean, Optional surpressErrorMsg As Boolean = True) As String
    If Not Initilized Then Exit Function
    On Error GoTo hell
    RunLengthDecode = iTextFilters.RunLengthDecode(data)
    Exit Function
hell:   ErrorMessage = "Error in RunLengthDecode: " & Err.Description
        hadError = True
        If Not surpressErrorMsg Then MsgBox ErrorMessage, vbInformation
End Function

Function LzwDecode(data As String, Optional hadError As Boolean, Optional surpressErrorMsg As Boolean = True) As String
    If Not Initilized Then Exit Function
    On Error GoTo hell
    LzwDecode = iTextFilters.LzwDecode(data)
    Exit Function
hell: ErrorMessage = "Error in LzwDecode: " & Err.Description
        hadError = True
        If Not surpressErrorMsg Then MsgBox ErrorMessage, vbInformation
End Function

Function ASCII85Decode(data As String, Optional hadError As Boolean, Optional surpressErrorMsg As Boolean = True) As String
    If Not Initilized Then Exit Function
    On Error GoTo hell
    ASCII85Decode = iTextFilters.ASCII85Decode(data)
    Exit Function
hell: ErrorMessage = "Error in ASCII85Decode: " & Err.Description
        hadError = True
        If Not surpressErrorMsg Then MsgBox ErrorMessage, vbInformation
End Function

Function ASCIIHexDecode(data As String, Optional hadError As Boolean, Optional surpressErrorMsg As Boolean = True) As String
    If Not Initilized Then Exit Function
    On Error GoTo hell
    ASCIIHexDecode = iTextFilters.ASCIIHexDecode(data)
    Exit Function
hell: ErrorMessage = "Error in ASCIIHexDecode: " & Err.Description
        hadError = True
        If Not surpressErrorMsg Then MsgBox ErrorMessage, vbInformation
End Function

