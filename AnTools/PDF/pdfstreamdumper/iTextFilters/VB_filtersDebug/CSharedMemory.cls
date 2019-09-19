VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSharedMemory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Sub CopyToMem Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As Long, source As Any, ByVal Length As Long)
Private Declare Sub CopyFromMem Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, ByVal source As Long, ByVal Length As Long)

Private Declare Function CreateFileMapping Lib "kernel32" Alias "CreateFileMappingA" (ByVal hFile As Long, lpFileMappigAttributes As SECURITY_ATTRIBUTES, ByVal flProtect As Long, ByVal dwMaximumSizeHigh As Long, ByVal dwMaximumSizeLow As Long, ByVal lpName As String) As Long
Private Declare Function OpenFileMapping Lib "kernel32" Alias "OpenFileMappingA" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal lpName As String) As Long
Private Declare Function MapViewOfFile Lib "kernel32" (ByVal hFileMappingObject As Long, ByVal dwDesiredAccess As Long, ByVal dwFileOffsetHigh As Long, ByVal dwFileOffsetLow As Long, ByVal dwNumberOfBytesToMap As Long) As Long
Private Declare Function UnmapViewOfFile Lib "kernel32" (lpBaseAddress As Any) As Long
Private Declare Function FlushViewOfFile Lib "kernel32" (lpBaseAddress As Any, ByVal dwNumberOfBytesToFlush As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Private Const PAGE_READWRITE = &H4
Private Const FILE_MAP_ALL_ACCESS As Long = &HF001F

Private Type SECURITY_ATTRIBUTES
        nLength As Long
        lpSecurityDescriptor As Long
        bInheritHandle As Long
End Type

Dim hFile As Long
Dim Max As Long
Dim vFName As String
Dim gAddr As Long

Public DebugMode As Boolean
Public ErrorMessage As String

Public Property Get filename() As String
   filename = vFName
End Property

Public Property Get MaxSize() As Long
   MaxSize = Max
End Property

Private Function RandomNum()
    On Error GoTo hell
    Dim tmp As Long
    Randomize
    tmp = Round(Timer * Now * Rnd(), 0)
    RandomNum = tmp
    Exit Function
hell: RandomNum = RandomNum() 'once in a great while this fucks me
End Function

'dont use both of these at once in same class..
'---------------------------------------------------
'returns the created memfilename
Function ShareData(Data As String) As String
        Dim i As Integer
        
        Dim memFIleName As String
        
        For i = 0 To 10
            memFIleName = "memFile_" & RandomNum()
            If CreateMemMapFile(memFIleName, Len(Data)) Then Exit For
        Next
               
        If hFile = 0 Then Exit Function  'we failed errormessage already set
        If Not WriteFile(Data, , True) Then Exit Function
        ShareData = memFIleName
    
End Function

Function GetSharedData(memFIleName As String, fSize As Long) As String
        
        Dim tmp As String
        If Not CreateMemMapFile(memFIleName, fSize) Then Exit Function
        If Not ReadAll(tmp) Then Exit Function
        GetSharedData = tmp
        
End Function
'--------------------------------------------------


Private Function CreateMemMapFile(fName As String, mSize As Long, Optional initilize As Boolean = False) As Boolean

    Dim T As SECURITY_ATTRIBUTES
    vFName = UCase(fName)
    Max = mSize
    T.nLength = Len(T)
    T.bInheritHandle = 1
    
    If hFile <> 0 Then
        ErrorMessage = "Cannot open multiple virtural files with one class"
        Exit Function
    End If
    
    hFile = CreateFileMapping(0, T, PAGE_READWRITE, 0, mSize, vFName)
    
    If hFile = 0 Then
        ErrorMessage = "Unable to create virtual file"
        Exit Function
    End If
    
    If hFile <> 0 Then
        Dim b() As Byte
        ReDim b(mSize)
        gAddr = MapViewOfFile(hFile, FILE_MAP_ALL_ACCESS, 0, 0, mSize)
        
        If DebugMode Then Debug.Print "Write Address: " & Hex(gAddr) & " b(0) = " & Hex(VarPtr(b(0)))
        
        If initilize Then CopyToMem gAddr, b(0), mSize
        CreateMemMapFile = True
    End If
    
End Function

Private Function ReadAll(strOut As String) As Boolean
       
    If hFile = 0 Then
        ErrorMessage = "Virtual File or Virtual File Interface not initialized"
        Exit Function
    End If
    
    ReadAll = ReadLength(strOut, Max)
    
End Function

Private Function ReadLength(strOut As String, nBytes As Long, Optional offset As Long = 0) As Boolean

    If hFile = 0 Then
        ErrorMessage = "Virtual File or Virtual File Interface not initialized"
        Exit Function
    End If
    
    If (offset + nBytes) > Max Then
        ErrorMessage = "Invalid size and offset combination"
        Exit Function
    End If
   
    Dim b() As Byte
    ReDim b(nBytes)
    
    If DebugMode Then Debug.Print "Reading Address: " & Hex(gAddr) & " b(0) = " & Hex(VarPtr(b(0)))
    
    CopyFromMem b(0), gAddr + offset, nBytes
    strOut = StrConv(b(), vbUnicode)
    ReadLength = True
    
End Function

Private Function WriteFile(bData As String, Optional offset As Long = 0, Optional ErasePrevData As Boolean = False) As Boolean

    If bData = "" Then Exit Function
    
    If hFile = 0 Then
        ErrorMessage = "Virtual File or Virtual File Interface not initialized"
        Exit Function
    End If

    If (offset + Len(bData)) > Max Then
        ErrorMessage = "Invalid data chunk size and offset combination"
        Exit Function
    End If
    
    Dim b() As Byte
    b() = StrConv(bData, vbFromUnicode)
    
    If DebugMode Then Debug.Print "Write Address: " & Hex(gAddr + offset) & " b(0) = " & Hex(VarPtr(b(0)))
    
    CopyToMem gAddr + offset, b(0), UBound(b)
    
    WriteFile = True
    
End Function

Private Function ReMap() As Boolean
    If gAddr <> 0 Then UnMap
    gAddr = MapViewOfFile(hFile, FILE_MAP_ALL_ACCESS, 0, 0, Max)
    If gAddr <> 0 Then ReMap = True
End Function

Private Function UnMap()
        UnmapViewOfFile gAddr
        gAddr = 0
End Function

Sub CloseFile()

    If hFile = 0 Then
        Exit Sub
    End If
    
    UnMap
    CloseHandle hFile
    hFile = 0
    Max = 0
    vFName = ""
    
End Sub

Private Sub Class_Terminate()
    UnMap
    CloseFile
End Sub

