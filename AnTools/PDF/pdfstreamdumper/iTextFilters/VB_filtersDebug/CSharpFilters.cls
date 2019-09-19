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
Private Declare Sub CopyFromMem Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, ByVal source As Long, ByVal Length As Long)

Dim iTextFilters As Object
Public Initilized As Boolean
Public ErrorMessage As String
Public DecodedBuffer As String

Enum Decoders 'these align to the values used in the Csharp enum so we can pass directly
    RunLengthDecode = 0
    FlateDecode = 1
    ASCIIHexDecode = 2
    ASCII85Decode = 3
    LzwDecode = 4
End Enum

Private Sub Class_Initialize()
    
    If Not DetectDotNet() Then
        ErrorMessage = ".Net v2.0 Not found on this machine"
        Exit Sub
    End If
    
    On Error Resume Next
    Set iTextFilters = CreateObject("iText_Filters.MemDecoder")
    
    If Err.Number <> 0 Or iTextFilters Is Nothing Then
        ErrorMessage = "Could not create CreateObject(iText_Filters.StringDecoder) " & vbCrLf & Err.Description
        Exit Sub
    End If
    
    Initilized = True
    
End Sub

Public Function DetectDotNet() As Boolean

    On Error GoTo hell
    
    Dim folders() As String, f, installroot As String
    Dim wsh As New WshShell
    
    installroot = wsh.RegRead("HKLM\SOFTWARE\Microsoft\.NETFramework\InstallRoot")
    
    If Not FolderExists(installroot) Then GoTo hell
    
    folders = GetSubFolders(installroot)
    
    For Each f In folders
        If VBA.Left(f, 2) = "v2" Then
            DetectDotNet = True
            Exit Function
        End If
    Next
    
    Exit Function
hell: ErrorMessage = Err.Description
End Function

'public interface ICDecoder
'{
'        string ErrorMessage { get; }
'        bool Debug { get; set; }
'        void ReleaseMem();
'        bool Decode(ref int address, ref int bufSize, mDecoders method);
'}
    
Function Decode(Data As String, decoder As Decoders, Optional surpressErrorMsg As Boolean = True) As Boolean
    
    On Error GoTo hell
        
    If Not Initilized Then Exit Function
    
    Dim b() As Byte
    Dim addr As Long
    Dim bufsize As Long
    
    b() = StrConv(Data, vbFromUnicode)
    addr = VarPtr(b(0))
    bufsize = UBound(b)
    
    'iTextFilters.Debug = true
    
    If iTextFilters.Decode(addr, bufsize, decoder) Then
        ReDim b(bufsize) 'addr, bufsize - these were set byref in csharp to describe response buffer
        CopyFromMem b(0), addr, bufsize
        DecodedBuffer = StrConv(b(), vbUnicode)
        Decode = True
    Else
        ErrorMessage = iTextFilters.ErrorMessage
        Exit Function
    End If
    
    iTextFilters.ReleaseMem
    
    Exit Function
    'hell is only for vb errors, .net errors get caught with output
hell:   ErrorMessage = "Error in " & method & " : " & Err.Description
        If Not surpressErrorMsg Then MsgBox ErrorMessage, vbInformation
End Function


Private Function GetSubFolders(folder) As String()
    Dim fnames() As String
    
    If Not FolderExists(folder) Then
        'returns empty array if fails
        GetSubFolders = fnames()
        Exit Function
    End If
    
   If Right(folder, 1) <> "\" Then folder = folder & "\"

   fd = Dir(folder, vbDirectory)
   While fd <> ""
     If Left(fd, 1) <> "." Then
        If (GetAttr(folder & fd) And vbDirectory) = vbDirectory Then
           push fnames(), fd
        End If
     End If
     fd = Dir()
   Wend
   
   GetSubFolders = fnames()
End Function

Private Function FolderExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbDirectory) <> "" Then FolderExists = True _
  Else FolderExists = False
End Function

Private Sub push(ary, Value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = Value
    Exit Sub
init: ReDim ary(0): ary(0) = Value
End Sub

