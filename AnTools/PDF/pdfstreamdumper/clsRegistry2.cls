VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsRegistry2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Boolean
End Type

Enum hKey
    HKEY_CLASSES_ROOT = &H80000000
    HKEY_CURRENT_USER = &H80000001
    HKEY_LOCAL_MACHINE = &H80000002
    HKEY_USERS = &H80000003
    HKEY_PERFORMANCE_DATA = &H80000004
    HKEY_CURRENT_CONFIG = &H80000005
    HKEY_DYN_DATA = &H80000006
End Enum

Enum dataType
    REG_BINARY = 3                     ' Free form binary
    REG_DWORD = 4                      ' 32-bit number
    REG_DWORD_BIG_ENDIAN = 5           ' 32-bit number
    REG_DWORD_LITTLE_ENDIAN = 4        ' 32-bit number (same as REG_DWORD)
    REG_EXPAND_SZ = 2                  ' Unicode nul terminated string
    REG_MULTI_SZ = 7                   ' Multiple Unicode strings
    REG_SZ = 1                         ' Unicode nul terminated string
End Enum

Private Const REG_OPTION_BACKUP_RESTORE = 4     ' open for backup or restore
Private Const REG_OPTION_VOLATILE = 1           ' Key is not preserved when system is rebooted
Private Const REG_OPTION_NON_VOLATILE = 0       ' Key is preserved when system is rebooted


Private Const STANDARD_RIGHTS_ALL = &H1F0000
Private Const SYNCHRONIZE = &H100000
Private Const READ_CONTROL = &H20000
Private Const STANDARD_RIGHTS_READ = (READ_CONTROL)
Private Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)
Private Const KEY_CREATE_LINK = &H20
Private Const KEY_CREATE_SUB_KEY = &H4
Private Const KEY_ENUMERATE_SUB_KEYS = &H8
Private Const KEY_NOTIFY = &H10
Private Const KEY_QUERY_VALUE = &H1
Private Const KEY_SET_VALUE = &H2
Private Const KEY_READ = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
Private Const KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))
Private Const KEY_EXECUTE = (KEY_READ)
Private Const KEY_ALL_ACCESS = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))

Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Private Declare Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, lpSecurityAttributes As SECURITY_ATTRIBUTES, phkResult As Long, lpdwDisposition As Long) As Long
Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Private Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long
Private Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long
Private Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
Private Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long
Private Declare Function RegEnumKeyEx Lib "advapi32.dll" Alias "RegEnumKeyExA" (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpName As String, lpcbName As Long, ByVal lpReserved As Long, ByVal lpClass As String, lpcbClass As Long, lpftLastWriteTime As Any) As Long
Private Declare Function RegEnumValue Lib "advapi32.dll" Alias "RegEnumValueA" (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpValueName As String, lpcbValueName As Long, ByVal lpReserved As Long, lpType As Long, lpData As Byte, lpcbData As Long) As Long

Private Handle As Long

Public hive As hKey


Function keyExists(path) As Boolean
  Dim x As Long
  Dim p As String
  
  p = stdPath(path)
  x = RegOpenKeyEx(hive, p, 0, KEY_QUERY_VALUE, Handle)
  keyExists = IIf(x = 0, True, False)
  
End Function

Function DeleteValue(path, ValueName) As Boolean
  On Error GoTo failed
  Dim p As String
  
  p = stdPath(path)
  RegOpenKeyEx hive, p, 0, KEY_ALL_ACCESS, Handle
  If Handle <> 0 Then
        RegDeleteValue Handle, CStr(ValueName)
        RegCloseKey Handle
  End If
  
  DeleteValue = True
  
  Exit Function
failed: RegCloseKey Handle: DeleteValue = False
End Function

Function DeleteKey(path) As Boolean
   Dim p As String, ret As Long
  
   p = stdPath(path)
   ret = RegDeleteKey(hive, p)
   DeleteKey = IIf(ret = 0, True, False)
End Function

Function CreateKey(path) As Boolean
    Dim sec As SECURITY_ATTRIBUTES, result As Long, ret As Long
    Dim p As String
  
    p = stdPath(path)
    RegCreateKeyEx hive, p, 0, "REG_DWORD", REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, sec, result, ret
    CreateKey = IIf(result = 0, False, True)
End Function

Function SetValue(path, KeyName, data, dType As dataType) As Boolean
    Dim p As String, ret As Long
  
    p = stdPath(path)
    RegOpenKeyEx hive, p, 0, KEY_ALL_ACCESS, Handle
    Select Case dType
        Case REG_SZ
            ret = RegSetValueEx(Handle, CStr(KeyName), 0, dType, ByVal CStr(data), Len(data))
        Case REG_BINARY
            ret = RegSetValueEx(Handle, CStr(KeyName), 0, dType, ByVal CStr(data), Len(data))
        Case REG_DWORD
            ret = RegSetValueEx(Handle, CStr(KeyName), 0, dType, CLng(data), 4)
    End Select
    RegCloseKey Handle
    SetValue = IIf(ret = 0, True, False)
End Function

Function ReadValue(path, ByVal KeyName)
     
    Dim lResult As Long, lValueType As Long, strBuf As String, lDataBufSize As Long
    Dim ret As Long
    'retrieve nformation about the key
    Dim p As String
  
    p = stdPath(path)
    RegOpenKeyEx hive, p, 0, KEY_READ, Handle
    lResult = RegQueryValueEx(Handle, CStr(KeyName), 0, lValueType, ByVal 0, lDataBufSize)
    If lResult = 0 Then
        If lValueType = REG_SZ Then
            strBuf = String(lDataBufSize, Chr$(0))
            lResult = RegQueryValueEx(Handle, CStr(KeyName), 0, 0, ByVal strBuf, lDataBufSize)
            If lResult = 0 Then ReadValue = Replace(strBuf, Chr$(0), "")
        ElseIf lValueType = REG_BINARY Then
            Dim strData As Integer
            lResult = RegQueryValueEx(Handle, CStr(KeyName), 0, 0, strData, lDataBufSize)
            If lResult = 0 Then ReadValue = strData
        ElseIf lValueType = REG_DWORD Then
            Dim x As Long
            lResult = RegQueryValueEx(Handle, CStr(KeyName), 0, 0, x, lDataBufSize)
            ReadValue = x
        ElseIf lValueType = REG_EXPAND_SZ Then
            strBuf = String(lDataBufSize, Chr$(0))
            lResult = RegQueryValueEx(Handle, CStr(KeyName), 0, 0, ByVal strBuf, lDataBufSize)
            If lResult = 0 Then ReadValue = Replace(strBuf, Chr$(0), "")

        'Else
        '    MsgBox "UnSupported Type " & lValueType
        End If
    End If
    RegCloseKey Handle
    
End Function

Function EnumKeys(path) As String()
    Dim p As String, tmp() As String, sSave As String, cnt As Long
  
    p = stdPath(path)
    
    RegOpenKeyEx hive, p, 0, KEY_READ, Handle
    
    Do
        sSave = String(255, 0)
        If RegEnumKeyEx(Handle, cnt, sSave, 255, 0, vbNullString, ByVal 0&, ByVal 0&) <> 0 Then Exit Do
        push tmp(), StripTerminator(sSave)
        cnt = cnt + 1
    Loop
    
    RegCloseKey Handle
    EnumKeys = tmp()
End Function

Function EnumValues(path) As String()
    Dim p As String, cnt As Long
    Dim tmp() As String, sSave As String
    
    p = stdPath(path)
    RegOpenKeyEx hive, p, 0, KEY_READ, Handle
    
    Do
        sSave = String(255, 0)
        If RegEnumValue(Handle, cnt, sSave, 255, 0, ByVal 0&, ByVal 0&, ByVal 0&) <> 0 Then Exit Do
        push tmp(), StripTerminator(sSave)
        cnt = cnt + 1
    Loop
    
    RegCloseKey Handle
    EnumValues = tmp()
End Function

Private Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    Dim x As Long
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init:     ReDim ary(0): ary(0) = value
End Sub

Private Function StripTerminator(sInput As String) As String
    Dim ZeroPos As Integer
    'Search the first chr$(0)
    ZeroPos = InStr(1, sInput, vbNullChar)
    StripTerminator = sInput
    If ZeroPos > 0 Then StripTerminator = left$(sInput, ZeroPos - 1)
End Function

Private Function stdPath(sIn) As String
    
    stdPath = Replace(sIn, "/", "\")
    If left(stdPath, 1) = "\" Then stdPath = Mid(stdPath, 2, Len(stdPath))
    If right(stdPath, 1) <> "\" Then stdPath = stdPath & "\"
End Function

Private Sub Class_Initialize()
    ' If Not isRegistered And Not isInitalized Then TellThemAllAboutIt
End Sub
