Attribute VB_Name = "fso"
'Revision 3 <- Incompatiable with all previous..simplified & streamlined
'
'Info:     These are basically macros for VB's built in file processes
'            this should streamline your code quite a bit and hopefully
'            remove alot of redundant coding.
'
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com
    
'Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpDest As Any, lpSource As Any, ByVal cLength As Long)

'also contains a bunch of other functions now cause i didnt want to add a new module to this project :P

Global Const LANG_US = &H409

Dim DebugMessages As Boolean

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Sub dbg(source, ParamArray x())
    On Error Resume Next
    If DebugMessages Then MsgBox Join(x, " "), , "Debug Message from function " & source
End Sub

Function unescape(x) '%uxxxx and %xx
    
    On Error GoTo hell
    
    Dim tmp() As String
    Dim b1, b2
    Dim i As Long
    
    'if instr(x, "%") < 1 then
    tmp = Split(x, "%")
    
    For i = 1 To UBound(tmp)
        t = tmp(i)
        
        If LCase(VBA.Left(t, 1)) = "u" Then
            If Len(t) >= 5 Then
                decode = Mid(t, 1, 5)
                b1 = Mid(decode, 2, 2)
                b2 = Mid(decode, 4, 2)
                tmp(i) = cHex(b2) & cHex(b1)
                If Len(t) > 5 Then tmp(i) = tmp(i) & Mid(t, 6)
            End If
        Else
            If Len(t) >= 2 Then
                decode = Mid(t, 1, 2)
                'If isHex(decode) Then
                    tmp(i) = cHex(decode)
                    If Len(t) > 2 Then tmp(i) = tmp(i) & Mid(t, 3)
                'Else
                '    tmp(i) = "%" & tmp(i)
                'End If
            'Else
            '    tmp(i) = "%" & tmp(i)
            End If
        End If
        
    Next
            
hell:
    unescape = Join(tmp, "")
     
     If Err.Number <> 0 Then
        MsgBox "Error in unescape:( " & Err.Description
     End If
     
End Function

Public Function cHex(v) As String
    On Error Resume Next
    cHex = Chr(CLng("&h" & v))
    If Err.Number <> 0 Then cHex = v
    Err.Clear
End Function

Public Function isHex(v) As Boolean
    On Error Resume Next
    x = Chr(CLng("&h" & v))
    If Err.Number = 0 Then isHex = True
    Err.Clear
End Function
Function HexDump(ByVal str, Optional hexOnly = 0) As String
    Dim s() As String, chars As String, tmp As String
    On Error Resume Next
    Dim ary() As Byte
    Dim offset As Long
    
    offset = 0
    str = " " & str
    ary = StrConv(str, vbFromUnicode, LANG_US)
    
    chars = "   "
    For i = 1 To UBound(ary)
        tt = Hex(ary(i))
        If Len(tt) = 1 Then tt = "0" & tt
        tmp = tmp & tt & " "
        x = ary(i)
        chars = chars & IIf((x > 32 And x < 127) Or x > 191, Chr(x), ".")
        If i > 1 And i Mod 16 = 0 Then
            h = Hex(offset)
            While Len(h) < 6: h = "0" & h: Wend
            If hexOnly = 0 Then
                push s, h & "   " & tmp & chars
            Else
                push s, tmp
            End If
            offset = offset + 16
            tmp = Empty
            chars = "   "
        End If
    Next
    'if read length was not mod 16=0 then
    'we have part of line to account for
    If tmp <> Empty Then
        If hexOnly = 0 Then
            h = Hex(offset)
            While Len(h) < 6: h = "0" & h: Wend
            h = h & "   " & tmp
            While Len(h) <= 56: h = h & " ": Wend
            push s, h & chars
        Else
            push s, tmp
        End If
    End If
    
    HexDump = Join(s, vbCrLf)
    
    If hexOnly <> 0 Then
        HexDump = Replace(HexDump, " ", "")
        HexDump = Replace(HexDump, vbCrLf, "")
    End If
    
End Function


    

Sub SaveMySetting(key, value)
    SaveSetting app.EXEName, "Settings", key, value
End Sub

Function GetMySetting(key, Optional defaultval = "")
    GetMySetting = GetSetting(app.EXEName, "Settings", key, defaultval)
End Function

Function GetFileSize(path) As Long
    On Error Resume Next
    Dim f As Long
    f = FreeFile
    Open path For Binary Access Read As f
    GetFileSize = LOF(f)
    Close f
End Function

Function GetFolderFiles(folder, Optional filter = ".*") As String()
   Dim fnames() As String
   
   If Not FolderExists(folder) Then
        'returns empty array if fails
        GetFolderFiles = fnames()
        Exit Function
   End If
   
   folder = IIf(Right(folder, 1) = "\", folder, folder & "\")
   If Left(filter, 1) = "*" Then extension = Mid(filter, 2, Len(filter))
   If Left(filter, 1) <> "." Then filter = "." & filter
   
   fs = Dir(folder & "*" & filter, vbHidden Or vbNormal Or vbReadOnly Or vbSystem)
   While fs <> ""
     If fs <> "" Then push fnames(), fs
     fs = Dir()
   Wend
   
   GetFolderFiles = fnames()
End Function

Function GetSubFolders(folder) As String()
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

Function GetParentFolder(path) As String
    tmp = Split(path, "\")
    ub = tmp(UBound(tmp))
    GetParentFolder = Replace(Join(tmp, "\"), "\" & ub, "")
End Function

Sub CreateFolder(path)
   If FolderExists(path) Then Exit Sub
   MkDir path
End Sub

Function FileNameFromPath(fullpath) As String
    On Error Resume Next
    If InStr(fullpath, "\") > 0 Then
        tmp = Split(fullpath, "\")
        FileNameFromPath = CStr(tmp(UBound(tmp)))
    End If
End Function

Function WebFileNameFromPath(fullpath)
    If InStr(fullpath, "/") > 0 Then
        tmp = Split(fullpath, "/")
        WebFileNameFromPath = CStr(tmp(UBound(tmp)))
    End If
End Function

Sub Move(fpath, toFolder)
    Copy fpath, toFolder
    Kill fpath
End Sub

Sub DeleteFile(fpath)
    Kill fpath
End Sub

Sub Rename(fullpath, NewName)
  pf = fso.GetParentFolder(fullpath)
  Name fullpath As pf & "\" & NewName
End Sub

Sub SetAttribute(fpath, it As VbFileAttribute)
   SetAttr fpath, it
End Sub

Function GetExtension(path) As String
    tmp = Split(path, "\")
    ub = tmp(UBound(tmp))
    If InStr(1, ub, ".") > 0 Then
       GetExtension = Mid(ub, InStrRev(ub, "."), Len(ub))
    Else
       GetExtension = ""
    End If
End Function

Function GetBaseName(path) As String
    tmp = Split(path, "\")
    ub = tmp(UBound(tmp))
    If InStr(1, ub, ".") > 0 Then
       GetBaseName = Mid(ub, 1, InStrRev(ub, ".") - 1)
    Else
       GetBaseName = ub
    End If
End Function

Function GetFileName(path) As String
    On Error Resume Next
    tmp = Split(path, "\")
    ub = tmp(UBound(tmp))
    GetFileName = ub
End Function

Function ChangeExt(path, ext)
    ext = IIf(Left(ext, 1) = ".", ext, "." & ext)
    If fso.FileExists(path) Then
        fso.Rename path, fso.GetBaseName(path) & ext
    Else
        'hack to just accept a file name might not be worth supporting
        bn = Mid(path, 1, InStr(1, path, ".") - 1)
        ChangeExt = bn & ext
    End If
End Function

Function SafeFileName(proposed) As String
  badChars = ">,<,&,/,\,:,|,?,*,"""
  bad = Split(badChars, ",")
  For i = 0 To UBound(bad)
    proposed = Replace(proposed, bad(i), "")
  Next
  SafeFileName = CStr(proposed)
End Function

Function RandomNum()
    Randomize
    tmp = Round(Timer * Now * Rnd(), 0)
    RandomNum = tmp
End Function

Function GetFreeFileName(folder, Optional extension = ".txt") As String
    
    If Not fso.FolderExists(folder) Then Exit Function
    If Right(folder, 1) <> "\" Then folder = folder & "\"
    If Left(extension, 1) <> "." Then extension = "." & extension
    
    Dim tmp As String
    Do
      tmp = folder & RandomNum() & extension
    Loop Until Not fso.FileExists(tmp)
    
    GetFreeFileName = tmp
End Function

Function buildPath(folderpath) As Boolean
    On Error GoTo oops
    
    If FolderExists(folderpath) Then buildPath = True: Exit Function
    
    tmp = Split(folderpath, "\")
    build = tmp(0)
    For i = 1 To UBound(tmp)
        build = build & "\" & tmp(i)
        If InStr(tmp(i), ".") < 1 Then
            If Not FolderExists(build) Then CreateFolder (build)
        End If
    Next
    buildPath = True
    Exit Function
oops: buildPath = False
End Function


Function ReadFile(FileName)
  f = FreeFile
  Temp = ""
   Open FileName For Binary As #f        ' Open file.(can be text or image)
     Temp = Input(FileLen(FileName), #f) ' Get entire Files data
   Close #f
   ReadFile = Temp
End Function

Sub WriteFile(path, it)
    f = FreeFile
    Open path For Output As #f
    Print #f, it
    Close f
End Sub

Sub AppendFile(path, it)
    f = FreeFile
    Open path For Append As #f
    Print #f, it
    Close f
End Sub


Sub Copy(fpath, toFolder)
   If FolderExists(toFolder) Then
       baseName = fso.FileNameFromPath(fpath)
       toFolder = IIf(Right(toFolder, 1) = "\", toFolder, toFolder & "\")
       FileCopy fpath, toFolder & baseName
   Else 'assume tofolder is actually new desired file path
       FileCopy fpath, toFolder
   End If
End Sub

Sub CreateFile(fpath)
    f = FreeFile
    If fso.FileExists(fpath) Then Exit Sub
    Open fpath For Binary As f
    Close f
End Sub


Function DeleteFolder(folderpath, force As Boolean) As Boolean
 On Error GoTo failed
   Call delTree(folderpath, force)
   DeleteFolder = True
 Exit Function
failed:  DeleteFolder = False
End Function

Private Sub delTree(folderpath, force As Boolean)
   Dim sfi() As String, sfo() As String
   sfi() = fso.GetFolderFiles(folderpath)
   sfo() = fso.GetSubFolders(folderpath)
   If Not AryIsEmpty(sfi) And force = True Then
        For i = 0 To UBound(sfi)
            Kill sfi(i)
        Next
   End If
   
   If Not AryIsEmpty(sfo) And force = True Then
        For i = 0 To UBound(sfo)
            Call delTree(sfo(i), True)
        Next
   End If
   
   Call RmDir(folderpath)
End Sub

Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init: ReDim ary(0): ary(0) = value
End Sub

Function AryIsEmpty(ary) As Boolean
  On Error GoTo oops
    x = UBound(ary)
    AryIsEmpty = False
  Exit Function
oops: AryIsEmpty = True
End Function

Function keyExists(t As String, c As Collection) As Boolean
    On Error GoTo hell
    Dim x As Object
    Set x = c("key:" & t)
    keyExists = True
    Exit Function
hell:
End Function

Function GetObjFromKey(t As String, c As Collection) As Object
    On Error GoTo hell
    Set GetObjFromKey = c("key:" & t)
    Exit Function
hell:
End Function

Function AddKey(t As String, c As Collection, value As Object) As Boolean
    On Error GoTo hell
    c.Add value, "key:" & t
    AddKey = True
    Exit Function
hell:
End Function

Function AnyofTheseInstr(Data, match, Optional compare As VbCompareMethod = vbTextCompare) As Boolean
    Dim tmp() As String
    Dim x
    tmp = Split(match, ",")
    For Each x In tmp
        If InStr(1, Data, x, compare) > 0 Then
            AnyofTheseInstr = True
            Exit Function
        End If
    Next
End Function
