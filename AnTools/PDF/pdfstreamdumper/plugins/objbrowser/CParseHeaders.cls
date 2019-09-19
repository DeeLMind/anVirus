VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CParseHeaders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

Function GetInlineOrStreamDataForTagFromIndex(index, ByVal tagName)
    header = GetHeader(index)
    GetInlineOrStreamDataForTagFromIndex = GetInlineOrStreamDataForTag(header, tagName)
End Function


'ex: /JS (var a=1;) or /JS 7 0 R
Function GetInlineOrStreamDataForTag(ByVal header, ByVal tagName)
    
    On Error Resume Next
    Dim ret As String
    
    If VBA.Left(tagName, 1) = "/" Then tagName = Mid(tagName, 2)
    d = header
    If InStr(1, d, "/" & tagName, vbTextCompare) > 0 Then
        'MsgBox "instr"
        ret = GetParenthesisDataForTag(d, tagName) 'is the data inline with () or as a stream..
        'MsgBox "() " & ret
        If Len(ret) = 0 Then
            i = GetStreamIndexForTag(d, tagName)
            If i > 0 Then
                ret = GetStream(i)
            End If
        End If
    End If
    
    GetInlineOrStreamDataForTag = ret
    'MsgBox ret
    
End Function

Function NextNonWhiteSpaceChar(x, Optional pos As Long)
    
    On Error GoTo hell
    pos = 0
    For i = 1 To 20
        c = Mid(x, i, 1)
        Select Case c
            Case "": Exit Function  'error
            Case " ": DoEvents
            Case vbTab: DoEvents
            Case vbCr: DoEvents
            Case vbLf: DoEvents
            Case Else: Exit For
        End Select
    Next
    
    If i = 20 Then Exit Function 'no match
    NextNonWhiteSpaceChar = c
    pos = i
hell:
End Function


Function GetParenthesisDataForTag(ByVal header, ByVal tagName) As String
    On Error Resume Next
    If VBA.Left(tagName, 1) = "/" Then tagName = Mid(tagName, 2)
    'tmp = Split(LCase(header), "/") ' you cant split at the tags with () data which may contain a /
    
    Dim a As Long
    
    a = InStr(1, header, tagName, vbTextCompare)
    'MsgBox "a " & a
    If a < 1 Then Exit Function
    a = a + Len(tagName)
    remain = Trim(Mid(header, a))
    'MsgBox remain & " " & NextNonWhiteSpaceChar(remain)
    If NextNonWhiteSpaceChar(remain, a) = "(" Then 'we have () data
        'MsgBox "found () data"
        If a > 0 Then
            a = a + 1
            b = InStrRev(remain, ")") - 1 'how do we know there arent other tags at the end?, () can contain / unescaped..wth
            'MsgBox "found )" & a & " " & b
            If b > a Then
                GetParenthesisDataForTag = Mid(remain, a, b - a)
            End If
        End If
    End If
           
    
End Function


Function GetStreamIndexForTag(ByVal header, ByVal tagName) As Long
    
    On Error Resume Next
    If VBA.Left(tagName, 1) = "/" Then tagName = Mid(tagName, 2)
    
    tmp = Split(LCase(header), "/")
    For Each x In tmp
        If VBA.Left(x, Len(tagName)) = LCase(tagName) Then
            remain = Trim(Mid(x, Len(tagName) + 1))
            remain = Trim(Replace(remain, "0 R", Empty))
            GetStreamIndexForTag = ParseInt(remain)
            Exit Function
        End If
    Next
    
End Function

Public Function GetStream(index)
        
        On Error Resume Next
        Dim s As Object
        Dim li As ListItem
        
        For Each li In Form1.frmMain.lv.ListItems
            Set s = li.Tag
            If s.index = index Then
                If s.isCompressed Then
                    GetStream = s.DecompressedData
                Else
                    GetStream = s.OriginalData
                End If
                Exit Function
            End If
        Next
        
End Function

Public Function GetHeader(index)
        
        On Error Resume Next
        Dim s As Object
        Dim li As ListItem
        For Each li In Form1.frmMain.lv.ListItems
            Set s = li.Tag
            If s.index = index Then
                GetHeader = s.escapedheader
                Exit Function
            End If
        Next
        
End Function

Function ExtractFromParanthesisPageEncapsulation(Data)
    
    On Error Resume Next
    
    Dim ret As String
    
    t = Split(Data, "(")
    For Each x In t
        If Len(x) > 0 Then
            a = InStr(x, ")")
            If a > 1 Then
                ret = ret & Trim(Mid(x, 1, a - 1))
            End If
        End If
    Next
    
    ExtractFromParanthesisPageEncapsulation = ret
    
End Function


'Extract first chain of numeric vals from string
Function ParseInt(ByVal x) As Long
    Dim r
    On Error Resume Next
    x = Trim(x)
    x = Replace(x, vbTab, Empty)
    For i = 1 To Len(x)
        c = Mid(x, i, 1)
        If IsNumeric(c) Then
            r = r & c
        Else
            If Len(r) = 0 Then
                ParseInt = -1
                Exit Function
            Else
                Exit For
            End If
        End If
    Next
    
    ParseInt = CLng(r)
        
End Function
