VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CPdfParser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com

'remember this was written specifically for malware which is almost always less than 1mb in size..
'optimizations you could do for larger files:
'
'  1) use a string builder class
'  2) write large data blocks to a disk cache and load on demand instead of holding in memory always



Event NewStream(stream As CPDFStream)
Event DebugMessage(msg As String)
Event SetObjectCount(cnt As Long)
Event Complete()

Public abort As Boolean
Public BreakAtStream As Long

Private Declare Function GetTickCount Lib "kernel32" () As Long

Private Function GetCount(marker, blob)
    On Error Resume Next
    GetCount = UBound(Split(blob, marker, , vbTextCompare))
    If Err.Number <> 0 Then GetCount = 0
End Function


'this is as optimized as we can get i think..800k -> 6sec, 300k -> .4sec
'loads the file as a byte array in chunks, converts to string, defrags string on demand
'as it searchs for markers..dont make chunks to small or else large blobs take forever..
Function ParseFile(fpath As String) As String
        
   ' On Error GoTo hell
    
    Dim stream As CPDFStream
    Dim sStr As String
    Dim objStart As Long
    Dim objEnd As Long
    Dim endObj As Long
    Dim lastObjEnd As Long
    Dim globalOffset As Long
    
    Dim decryptor As String
    Dim dFile As String
    Dim fSize As Long
    Dim starttick As Long
    
    Form1.isEncrypted = False
    
    If Not fso.FileExists(fpath) Then
        MsgBox "File not found: " & fpath, vbInformation
        Exit Function
    End If
        
    abort = False
    sStr = LoadFile(fpath) 'this is kind of wasteful but...
    fSize = Len(sStr)
    
    RaiseEvent SetObjectCount(GetCount("endobj", sStr))
    
    If InStr(sStr, "/Encrypt") > 0 Then
        Form1.isEncrypted = True
        If Form1.mnuDisableDecryption.Checked = False Then 'this modal dialog sucks for automation runs...
            If csharp.Decrypt(fpath, dFile) Then
                sStr = LoadFile(dFile)
                Form1.txtPDFPath = dFile
            Else
                If Len(dFile) > 0 Then MsgBox "Decrypt failed output: " & dFile, vbInformation
            End If
        End If
    End If
     
    Dim parts()  As String
    Dim defragLevel As Long
    
    sStr = Empty
    parts() = load_fragmented(fpath)
    sStr = parts(0)
    defragLevel = 1
    globalOffset = 0
    starttick = GetTickCount()
    
    objStart = InStr(1, sStr, "obj", vbTextCompare)
    
    Do While objStart < 1 And defragLevel <= UBound(parts) 'this loop should never really happen but jut in case..
        DoEvents: Form1.Refresh
        sStr = sStr & parts(defragLevel)
        defragLevel = defragLevel + 1
        objStart = InStr(1, sStr, "obj", vbTextCompare)
    Loop
    
    Do While objStart > 0
    
        If abort Then
            RaiseEvent DebugMessage("User abort triggered")
            Exit Do
        End If
        
        Set stream = New CPDFStream
        
retry:
        objEnd = InStr(objStart, sStr, "endobj", vbTextCompare) 'must be case insensitive
        endObj = InStr(objStart, sStr, "objend", vbTextCompare) 'this works too (found in sample 1df9249930f1f26edf367aceb614c603.pdf)
        
        If objEnd < 1 And endObj < 1 Then
            If defragLevel <= UBound(parts) Then
                DoEvents: Form1.Refresh
                sStr = sStr & parts(defragLevel)
                defragLevel = defragLevel + 1
                GoTo retry
            End If
            RaiseEvent DebugMessage("Missing endstream marker objStart = 0x" & Hex(objStart))
            Exit Do
        End If
    
        If objEnd > endObj And endObj <> 0 Then objEnd = endObj 'use which ever comes first.
        
        stream.ObjectStartOffset = globalOffset + objStart - 1
        stream.ObjectEndOffset = globalOffset + objEnd + Len("endobj") - 2
        stream.Index = GetStreamIndex(sStr, objStart)
        stream.RawObject = Mid(sStr, objStart, objEnd - objStart)
        
        If BreakAtStream > 0 And stream.Index = BreakAtStream Then Stop
        
        stream.ParseSelf
        
        RaiseEvent NewStream(stream)
        If stream.ObjectEndOffset > lastObjEnd Then lastObjEnd = stream.ObjectEndOffset
        
        sStr = Mid(sStr, objEnd + Len("endobj"))  ' we keep reducing the size so it gets faster as we go..
        globalOffset = globalOffset + objEnd + Len("endobj") - 1
        objStart = InStr(1, sStr, "obj", vbTextCompare)
        
        If objStart < 1 Then
            Do While objStart < 1 And defragLevel <= UBound(parts)
                DoEvents: Form1.Refresh
                sStr = sStr & parts(defragLevel)
                defragLevel = defragLevel + 1
                objStart = InStr(1, sStr, "obj", vbTextCompare)
            Loop
        End If
        
    Loop
    
    If Len(sStr) > 0 Then
        Set stream = New CPDFStream
        stream.ObjectStartOffset = globalOffset
        stream.ObjectEndOffset = globalOffset + Len(sStr)
        stream.Index = 0
        stream.RawObject = sStr
        stream.Header = stream.RawObject
        stream.OriginalData = stream.RawObject
        RaiseEvent NewStream(stream)
        stream.Message = "Holds data found after end of last object."
    End If
     
    RaiseEvent DebugMessage("Parsing Complete Objects: " & Form1.lv.ListItems.Count + Form1.lv2.ListItems.Count & "  Elapsed Time: " & ((GetTickCount() - starttick) / 1000) & " seconds")
    RaiseEvent DebugMessage("0x" & Hex(fSize - lastObjEnd) & " bytes after end of last object @ offset 0x" & Hex(lastObjEnd))
    RaiseEvent Complete
    
End Function


Private Function load_fragmented(fpath As String, Optional ByRef totSize As Long) As String()
    Dim ret() As String
    Dim max_sz As Long
    Dim sz As Long
    Dim pointer As Long
    Dim f As Long
    Dim b() As Byte
    Dim blocks As Long
    Dim last_chunk As Long
    
    max_sz = 99000
    ReDim b(1 To max_sz)
    f = FreeFile
    
    Open fpath For Binary As f
    sz = LOF(f)
    totSize = sz
    'Debug.Print "Total size is " & sz
    
    If sz < max_sz Then
        'Debug.Print "Min chunk size not met, loading all at once."
        ReDim b(sz)
        Get f, , b()
        string_push ret, StrConv(b(), vbUnicode, LANG_US)
        load_fragmented = ret()
        Close f
        Exit Function
    End If
    
    blocks = CLng(sz \ max_sz)
    last_chunk = sz - (blocks * max_sz)
    'Debug.Print "Breaking into " & blocks & " of " & max_sz & " - " & last_chunk & " bytes remaining"
    For i = 1 To blocks
        Get f, , b()
        string_push ret, StrConv(b(), vbUnicode, LANG_US)
    Next
    
    If last_chunk <> 0 Then
        ReDim b(1 To last_chunk)
        Get f, , b()
        push ret, StrConv(b(), vbUnicode, LANG_US)
    End If
    
    load_fragmented = ret()
    Close f
    
End Function

Private Sub string_push(ary() As String, Value As String)  'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = Value
    Exit Sub
init: ReDim ary(0): ary(0) = Value
End Sub


'uses string halving and string shrinking.. 800k - 9.5sec.. 300k -> .8sec
'Function ParseFile(fpath As String) As String
'
'   ' On Error GoTo hell
'
'    Dim stream As CPDFStream
'    Dim sStr As String
'    Dim objStart As Long
'    Dim objEnd As Long
'    Dim endObj As Long
'    Dim lastObjEnd As Long
'    Dim globalOffset As Long
'
'    Dim decryptor As String
'    Dim dFile As String
'    Dim fSize As Long
'    Dim starttick As Long
'
'    If Not fso.FileExists(fpath) Then
'        MsgBox "File not found: " & fpath, vbInformation
'        Exit Function
'    End If
'
'    ABORT = False
'    sStr = LoadFile(fpath)
'    fSize = Len(sStr)
'
'    RaiseEvent SetObjectCount(GetCount("endobj", sStr))
'
'    If InStr(sStr, "/Encrypt") > 0 Then
'        If csharp.Decrypt(fpath, dFile) Then
'            sStr = LoadFile(dFile)
'            Form1.txtPDFPath = dFile
'        Else
'            If Len(dFile) > 0 Then MsgBox "Decrypt failed output: " & dFile, vbInformation
'        End If
'    End If
'
'    Dim part2 As String, part3 As String, part4 As String
'    Dim defragLevel As Long
'
'    HalveString sStr, part3 'divide the input file up into 4 parts for quicker parsing..(smaller strings)
'    HalveString sStr, part2
'    HalveString part3, part4
'
'    defragLevel = 0
'    globalOffset = 0
'    starttick = GetTickCount()
'
'    objStart = InStr(1, sStr, "obj", vbTextCompare)
'    Do While objStart > 0
'
'        If ABORT Then
'            RaiseEvent DebugMessage("User abort triggered")
'            Exit Do
'        End If
'
'        Set stream = New CPDFStream
'
'retry:
'        objEnd = InStr(objStart, sStr, "endobj", vbTextCompare) 'must be case insensitive
'        endObj = InStr(objStart, sStr, "objend", vbTextCompare) 'this works too (found in sample 1df9249930f1f26edf367aceb614c603.pdf)
'
'        If objEnd < 1 And endObj < 1 Then
'            If defragLevel < 3 Then
'                If defragLevel = 0 Then sStr = sStr & part2
'                If defragLevel = 1 Then sStr = sStr & part3
'                If defragLevel = 2 Then sStr = sStr & part4
'                defragLevel = defragLevel + 1
'                GoTo retry
'            End If
'            RaiseEvent DebugMessage("Missing endstream marker objStart = 0x" & Hex(objStart))
'            Exit Do
'        End If
'
'        If objEnd > endObj And endObj <> 0 Then objEnd = endObj 'use which ever comes first.
'
'        stream.ObjectStartOffset = globalOffset + objStart - 1
'        stream.ObjectEndOffset = globalOffset + objEnd + Len("endobj") - 2
'        stream.Index = GetStreamIndex(sStr, objStart)
'        stream.RawObject = Mid(sStr, objStart, objEnd - objStart)
'        stream.ParseSelf
'
'        RaiseEvent NewStream(stream)
'        If stream.ObjectEndOffset > lastObjEnd Then lastObjEnd = stream.ObjectEndOffset
'
'        sStr = Mid(sStr, objEnd + Len("endobj"))  ' we keep reducing the size so it gets faster as we go..
'        globalOffset = globalOffset + objEnd + Len("endobj") - 1
'        objStart = InStr(1, sStr, "obj", vbTextCompare)
'
'        If objStart < 1 Then
'            If defragLevel < 3 Then
'                If defragLevel = 0 Then sStr = sStr & part2
'                If defragLevel = 1 Then sStr = sStr & part3
'                If defragLevel = 2 Then sStr = sStr & part4
'                defragLevel = defragLevel + 1
'                objStart = InStr(1, sStr, "obj", vbTextCompare)
'            End If
'        End If
'
'    Loop
'
'    If Len(sStr) > 0 Then
'        Set stream = New CPDFStream
'        stream.ObjectStartOffset = globalOffset
'        stream.ObjectEndOffset = globalOffset + Len(sStr)
'        stream.Index = 0
'        stream.RawObject = sStr
'        stream.Header = stream.RawObject
'        stream.OriginalData = stream.RawObject
'        RaiseEvent NewStream(stream)
'        stream.Message = "Holds data found after end of last object."
'    End If
'
'    RaiseEvent DebugMessage("Parsing Complete Objects: " & Form1.lv.ListItems.Count + Form1.lv2.ListItems.Count & "  Elapsed Time: " & ((GetTickCount() - starttick) / 1000) & " seconds")
'    RaiseEvent DebugMessage("0x" & Hex(fSize - lastObjEnd) & " bytes after end of last object @ offset 0x" & Hex(lastObjEnd))
'    RaiseEvent Complete
'
'End Function


Private Function HalveString(strin As String, secondPart As String)
    Dim x As Long
    x = Len(strin) / 2
    secondPart = Mid(strin, x)
    strin = Mid(strin, 1, x - 1)
End Function


'original parser...800k -> 130 seconds
Function Orginal_ParseFile(fpath As String) As String
        
   ' On Error GoTo hell
    
    Dim stream As CPDFStream
    Dim sStr As String
    Dim objStart As Long
    Dim objEnd As Long
    Dim endObj As Long
    Dim lastObjEnd As Long
    Dim starttick As Long
    
    Dim decryptor As String
    Dim dFile As String
    
    If Not fso.FileExists(fpath) Then
        MsgBox "File not found: " & fpath, vbInformation
        Exit Function
    End If
    
    sStr = LoadFile(fpath)
    
    RaiseEvent SetObjectCount(GetCount("endobj", sStr))
    
    If InStr(sStr, "/Encrypt") > 0 Then
        If csharp.Decrypt(fpath, dFile) Then
            sStr = LoadFile(dFile)
            Form1.txtPDFPath = dFile
        Else
            If Len(dFile) > 0 Then MsgBox "Decrypt failed output: " & dFile, vbInformation
        End If
    End If
        
    starttick = GetTickCount()
    objStart = InStr(1, sStr, "obj", vbTextCompare)
    Do While objStart > 0
        Set stream = New CPDFStream
        
        objEnd = InStr(objStart, sStr, "endobj", vbTextCompare) 'must be case insensitive
        endObj = InStr(objStart, sStr, "objend", vbTextCompare) 'this works too (found in sample 1df9249930f1f26edf367aceb614c603.pdf)
        
        If objEnd < 1 And endObj < 1 Then
            RaiseEvent DebugMessage("Missing endstream marker objStart = 0x" & Hex(objStart))
            Exit Do
        End If
    
        If objEnd > endObj And endObj <> 0 Then objEnd = endObj 'use which ever comes first.
        
        stream.ObjectStartOffset = objStart - 1
        stream.ObjectEndOffset = objEnd + Len("endobj") - 2
        stream.Index = GetStreamIndex(sStr, objStart)
        stream.RawObject = Mid(sStr, objStart, objEnd - objStart)
        stream.ParseSelf
        
        RaiseEvent NewStream(stream)
        If stream.ObjectEndOffset > lastObjEnd Then lastObjEnd = stream.ObjectEndOffset
        
        objStart = InStr(stream.ObjectEndOffset, sStr, "obj", vbTextCompare)
    Loop
    
    RaiseEvent DebugMessage("Parsing Complete Objects: " & Form1.lv.ListItems.Count + Form1.lv2.ListItems.Count & "  Elapsed Time: " & ((GetTickCount() - starttick) / 1000) & " seconds")
    RaiseEvent DebugMessage("Parsing complete 0x" & Hex(Len(sStr) - lastObjEnd) & " bytes after end of last object @ 0x" & Hex(lastObjEnd))
    RaiseEvent Complete
    
End Function


Private Function LoadFile(fpath As String) As String

    Dim b() As Byte

    f = FreeFile
    Open fpath For Binary Access Read As f
    ReDim b(LOF(f))
    Get f, , b()
    Close f
    
    LoadFile = StrConv(b, vbUnicode, LANG_US)
    
End Function


Private Function GetStreamIndex(s, ByVal startPos As Long)
    
    Dim a As Long
    Dim b As Long
    Dim ss As String
    Dim so As Long
    
    If startPos - 10 < 1 Then
        ss = Mid(s, 1, startPos - 1)
    Else
        startPos = startPos - 10
        ss = Mid(s, startPos, 10)
    End If
    
    'can be either take last one found
    a = InStrRev(ss, Chr(&HA))
    b = InStrRev(ss, Chr(&HD))
    If b > a Then a = b
    
    If a > 0 Then
        ss = Mid(ss, a + 1)
        b = InStr(ss, " ")
        If b > 0 Then
            GetStreamIndex = Trim(Mid(ss, 1, b - 1))
        End If
    End If
    
    
End Function
