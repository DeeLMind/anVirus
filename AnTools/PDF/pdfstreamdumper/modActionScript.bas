Attribute VB_Name = "modActionScript"

'quick and dirty processor..
Function ProcessActionScript(buffer As String) As String

    
    tmp = Replace(buffer, "public", Empty, , , vbTextCompare)
    tmp = Replace(tmp, "private", Empty, , , vbTextCompare)
    tmp = Replace(tmp, "static", Empty, , , vbTextCompare)
    tmp = Replace(tmp, Chr(&HEF) & Chr(&HBB) & Chr(&HBF), Empty)
    
    'i dont want to loose this info..but it screws with the formatter which then
    'screws with the function scan feature..
    
'    tmp = Replace(tmp, ":ByteArray", " /*:ByteArray*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":String", " /*:String*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":Boolean", " /*:Boolean*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":uint", " /*:uint*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":int", " /*:int*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":Number", " /*:Number*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":Event", " /*:Event*/ ", , , vbTextCompare)
'    tmp = Replace(tmp, ":void", " /*:void*/ ", , , vbTextCompare)
    
    tmp = Replace(tmp, ":ByteArray", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":String", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":Boolean", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":uint", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":int", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":Number", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":Event", Empty, , , vbTextCompare)
    tmp = Replace(tmp, ":void", Empty, , , vbTextCompare)
    
    'Vector.<
    t = Split(tmp, vbCrLf)
    Dim w
    
    'first we strip all indenting..
    For i = 0 To UBound(t)
        t(i) = Trim(mltrim(t(i)))
    Next
    
    Dim hasPackage As Boolean
    Dim hasClass As Boolean
    Dim inFuncs As Boolean
    
    Dim gvars() As String
    Dim funcs() As String
    Dim Index As String
    
    push gvars, Empty 'never empty
    push funcs, Empty
    
    For i = 0 To UBound(t)
        If i < UBound(t) - 1 Then
            If t(i) = "package" And t(i + 1) = "{" Then
                t(i) = "//package"
                t(i + 1) = "//{"
                i = i + 1
                hasPackage = True
                GoTo nextone
            End If
        End If
        
        w = getWord(t(i), 0)
        If w = "import" Or w = "class" Then
            t(i) = "//" & t(i)
            If w = "class" And t(i + 1) = "{" Then
                t(i + 1) = "//{"
                i = i + 1
                hasClass = True
                GoTo nextone
            End If
        End If
        
        If w = "function" Then inFuncs = True
        
        If Not inFuncs Or w = "function" Then
            a = InStr(1, t(i), "_SafeStr", vbTextCompare)
            If a > 0 Then
                ss = extractSafeStr(t(i), a)
                If Len(ss) > 0 Then
                    If Not inFuncs Then 'global variables
                        Index = UBound(gvars)
                        If Len(Index) = 1 Then Index = "0" & Index
                        push gvars, ss & "->" & "g_var" & Index
                    Else
                        Index = UBound(funcs)
                        If Len(Index) = 1 Then Index = "0" & Index
                        push funcs, ss & "->" & "func_" & Index
                    End If
                End If
            End If
        End If
                    
            
        
nextone:
    Next
     
   
   trimTrailingBrace = 0
   If hasPackage Then trimTrailingBrace = trimTrailingBrace + 1
   If hasClass Then trimTrailingBrace = trimTrailingBrace + 1
   
   If trimTrailingBrace > 0 Then
        For i = UBound(t) To 0 Step -1
            If trimTrailingBrace = 0 Then Exit For
            If left(t(i), 1) = "}" Then
                t(i) = "//" & t(i)
                trimTrailingBrace = trimTrailingBrace - 1
            End If
        Next
   End If
   
   tmp = Join(t, vbCrLf)
   
   For Each x In funcs
      If Len(x) > 0 Then
         Y = Split(x, "->")
         tmp = Replace(tmp, Y(0) & "(", Y(1) & "(")
      End If
   Next

   For Each x In gvars
      If Len(x) > 0 Then
         Y = Split(x, "->")
         tmp = Replace(tmp, Y(0), Y(1))
      End If
   Next
   
   Dim map As String
   map = vbCrLf & _
         "/*" & vbCrLf & vbTab & _
            Join(gvars, vbCrLf & vbTab) & vbCrLf & vbTab & _
            Join(funcs, vbCrLf & vbTab) & vbCrLf & _
         "*/"
         
   ProcessActionScript = tmp & Replace(map, "->", " -> ")
    
End Function

Function extractSafeStr(line, start) As String
     tmp = Mid(line, start)
     
     Dim a(8) As Long
     Dim lowest As Long
     lowest = 9999
     
     a(0) = InStr(tmp, ":")
     a(1) = InStr(tmp, "(")
     a(2) = InStr(tmp, ";")
     a(3) = InStr(tmp, vbCr)
     a(4) = InStr(tmp, vbLf)
     a(5) = InStr(tmp, " ")
     a(6) = InStr(tmp, "/")
     a(7) = InStr(tmp, "=")
     
     For i = 0 To UBound(a)
        If a(i) > 0 And a(i) < lowest Then lowest = a(i)
     Next
     
     If lowest <> 9999 Then
        extractSafeStr = Trim(Mid(tmp, 1, lowest - 1))
     End If
     
End Function


Private Function AryIsEmpty(ary) As Boolean
  On Error GoTo oops
    i = UBound(ary)  '<- throws error if not initalized
    AryIsEmpty = False
  Exit Function
oops: AryIsEmpty = True
End Function

Private Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init:     ReDim ary(0): ary(0) = value
End Sub

Private Function getWord(str, i) As String
    On Error Resume Next
    tmp = Split(str, " ")
    getWord = tmp(i)
End Function

Private Function mltrim(ByVal x) As String

    Do While VBA.left(x, 1) = " " Or VBA.left(x, 1) = vbTab
       If Len(x) = 1 Then Exit Function 'empty line
       x = Mid(x, 2)
    Loop
    
    mltrim = x
    
End Function

'this is a quick and dirty scan as a cheap shot..just to check basics..
Function flash_as_cveScan(asScript As String) As String

    Dim cves() As String
    Dim hits As Long
    Dim ret() As String
    
    'https://www.fireeye.com/blog/threat-research/2015/07/cve-2015-5122_-_seco.html
    
    push cves, "CVE-2015-5122:.opaqueBackground"
    push cves, "CVE-2015-3113:play,info,code,video,attachNetStream"
    push cves, "CVE-2015-0556:copyPixelsToByteArray"
    push cves, "CVE-2015-0313:createMessageChannel,createWorker"
    push cves, "CVE-2015-0310 or CVE-2013-0634:new RegExp"
    push cves, "CVE-2015-0311:domainMemory,uncompress"
    push cves, "CVE-2014-9163:parseFloat"
    push cves, "CVE-2014-0515 (if in while loop):byteCode,Shader"
    push cves, "CVE-2014-0502:setSharedProperty,createWorker,.start,SharedObject"
    push cves, "CVE-2014-0497:writeUTFBytes,domainMemory"
    push cves, "CVE-2012-0779:defaultObjectEncoding,AMF0,NetConnection"
    push cves, "CVE-2012-0754:NetStream,NetConnection,attachNetStream,play"
    push cves, "CVE-2012-5054:Matrix3D"
    push cves, "CVE-2012-0779:Responder,NetConnection,AMF0"
    push cves, "CVE-2012-1535:FontDescription,FontLookup"
    push cves, "CVE-2011-0609:MovieClip,TimelineMax,TweenMax"
    push cves, "CVE-2011-2110:Number(_args["
    push cves, "Loads embedded flash object:loadbytes"
    
    If asScript = "cvelist" Then
        flash_as_cveScan = ";there are more than this, these are some I had on hand" & vbCrLf & _
                            ";that were agreeable to script level detections. " & vbCrLf & _
                            vbCrLf & Join(cves, vbCrLf)
        Exit Function
    End If
    
    If FileExists(asScript) Then
        dat = ReadFile(fPath)
    Else
        dat = asScript
    End If
    
    For Each CVE In cves
        c = Split(CVE, ":")
        checks = Split(c(1), ",")
        hits = 0
        For Each k In checks
            If InStr(1, dat, k, vbTextCompare) > 0 Then hits = hits + 1
        Next
        If hits = UBound(checks) + 1 Then push ret, CVE
    Next
    
    flash_as_cveScan = Join(ret, vbCrLf)
    
End Function




