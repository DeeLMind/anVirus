Attribute VB_Name = "modEscapes"
'just had major rework done in escapes to try to support correct results on non US systems...
'--> still a couple more to go

'Public Function cHex(v, Optional ByRef eCount As Long) As String
'    On Error Resume Next
'    cHex = Chr(CLng("&h" & v))
'    If Err.Number <> 0 Then
'        eCount = eCount + 1
'        cHex = v
'    End If
'    Err.Clear
'End Function

Function ExtractValidHex(x, Optional assumeUnicode As Boolean = False)
    
    On Error Resume Next
    Dim b() As Byte
    Dim r() As Byte
    
    b() = StrConv(x, vbFromUnicode, LANG_US)
    
    For i = 0 To UBound(b)
       
        If b(i) >= &H30 And b(i) <= &H39 Then 'isnumeric
            bpush r(), b(i)
        Else
            If b(i) >= Asc("a") And b(i) <= Asc("f") Then
                bpush r(), b(i)
            ElseIf b(i) >= Asc("A") And b(i) <= Asc("F") Then
                 bpush r(), b(i)
            End If
            
            If assumeUnicode = True Then
                If b(i) = Asc("U") Or b(i) = Asc("u") Then s_bpush r(), "%u"  'sure we will assume it was meant to be this..
            End If
            
        End If
    Next
    
    ExtractValidHex = StrConv(r(), vbUnicode, LANG_US)
        
End Function

Function AddPercentToHexString(x, Optional noNulls As Boolean = False)
    On Error Resume Next 'x = 9090EB05 -> %90%90%EB%05
    Dim ret
    
    For i = 1 To Len(x) Step 2
        t = Mid(x, i, 2)
        ret = ret & "%" & t
    Next
    
    AddPercentToHexString = ret
    If noNulls Then
        AddPercentToHexString = Replace(ret, Chr(0), Empty)
    End If
    
End Function

Function MultiEscape(x)

    On Error Resume Next
    
    If InStr(x, "%") > 0 Then
        x = unescape(x)
    End If
    
    If InStr(x, "#") > 0 Then
        x = pound_unescape(x)
    End If
    
    If InStr(x, "\x") > 0 Then
        x = js_unescape(x)
    End If
    
    If InStr(x, "\n") > 0 Then
        x = nl_unescape(x)
    End If
    
    MultiEscape = x
    
End Function

Function EscapeHexString(hexstr)
    
    Dim b() As Byte
    Dim h As String
    Dim c As String
    Dim tmp As String
    On Error Resume Next
    
    h = HexStringUnescape(hexstr)
    b() = StrConv(h, vbFromUnicode, LANG_US)
    
    For i = 0 To UBound(b)
        c = Hex(b(i))
        If Len(c) = 1 Then c = "0" & c
        tmp = tmp & "%" & c
    Next
    
    EscapeHexString = tmp
    
End Function

'this should now be unicode safe on foreign systems..
Function unescape(x) As String '%uxxxx and %xx
    
    'On Error GoTo hell
    
    Dim tmp() As String
    Dim b1 As String, b2 As String
    Dim i As Long
    Dim r() As Byte
    Dim elems As Long
    
    tmp = Split(x, "%")
    
    s_bpush r(), tmp(0) 'any prefix before encoded part..
    
    For i = 1 To UBound(tmp)
        t = tmp(i)
        
        If LCase(VBA.left(t, 1)) = "u" Then
        
            If Len(t) < 5 Then '%u21 -> %u0021
                t = "u" & String(5 - Len(t), "0") & Mid(t, 2)
            End If

            b1 = Mid(t, 2, 2)
            b2 = Mid(t, 4, 2)
            
            If isHexChar(b1) And isHexChar(b2) Then
                hex_bpush r(), b2
                hex_bpush r(), b1
            Else
                s_bpush r(), "%u" & b1 & b2
            End If
            
            If Len(t) > 5 Then s_bpush r(), Mid(t, 6)
             
        Else
               b1 = Mid(t, 1, 2)
               If Not hex_bpush(r(), b1) Then s_bpush r(), "%" & b1
               If Len(t) > 2 Then s_bpush r(), Mid(t, 3)
        End If
        
    Next
            
hell:
    unescape = StrConv(r(), vbUnicode, LANG_US)
     
     If Err.Number <> 0 Then
        MsgBox "Error in unescape: " & Err.Description
     End If
     
End Function


'should be safe for unicode
Function pound_unescape(x) '#xx
    
    On Error GoTo hell
    
    Dim tmp() As String
    Dim b1, b2
    Dim i As Long
    Dim r() As Byte
    Dim decode As String
    
    tmp = Split(x, "#")
    
        s_bpush r(), tmp(0)
        For i = 1 To UBound(tmp)
            t = tmp(i)
            
            If Len(t) >= 2 Then
                decode = Mid(t, 1, 2)
                If isHexChar(decode) Then 'bug fix added 12.5.10 others need it too!
                    hex_bpush r(), decode
                    If Len(t) > 2 Then s_bpush r(), Mid(t, 3)
                Else
                    s_bpush r(), "#" & tmp(i)
                End If
            Else
                s_bpush r(), "#" & tmp(i) 'bf
            End If
            
        Next

            
hell:
    pound_unescape = StrConv(r(), vbUnicode, LANG_US)
     
     If Err.Number <> 0 Then
        MsgBox "Error in pound unescape:( " & Err.Description
     End If
     
End Function

'should be safe for unicode
Function octal_unescape(ByVal strin)
    
    On Error Resume Next
    Dim tmp() As String
    Dim i As Long
    Dim v As Long
    Dim nextThree As String
    Dim rest As String
    Dim r() As Byte
    
    tmp = Split(strin, "\")
    
    s_bpush r(), tmp(0)
    
    For i = 1 To UBound(tmp)
        If Len(tmp(i)) < 4 And IsNumeric(tmp(i)) Then
            v = CLng("&O" & tmp(i))
            If v < 255 Then
                bpush r(), CByte(v)
            Else
                If Len(tmp(i)) > 0 And i <> 0 Then s_bpush r(), "\" & tmp(i) 'cause we join with ""
            End If
        Else
            rest = ""
            nextThree = Mid(tmp(i), 1, 3)
            rest = Mid(tmp(i), 4)
            If IsNumeric(nextThree) Then
                v = CLng("&O" & nextThree)
                If v < 255 Then
                    bpush r(), CByte(v)
                    If Len(rest) > 0 Then s_bpush r(), rest
                Else
                    If Len(tmp(i)) > 0 And i <> 0 Then s_bpush r(), "\" & tmp(i) 'cause we join with ""
                End If
            Else
                If Len(tmp(i)) > 0 And i <> 0 Then s_bpush r(), "\" & tmp(i) 'cause we join with ""
            End If
        End If
    Next
            
    octal_unescape = StrConv(r(), vbUnicode, LANG_US)
        
End Function


'should be safe now for unicode
Function js_unescape(x)
    
    On Error GoTo hell
    
    Dim tmp() As String
    Dim b1, b2
    Dim i As Long
    Dim r() As Byte
    Dim decode As String
    
    tmp = Split(x, "\x")
    
    s_bpush r(), tmp(0)
    
    For i = 1 To UBound(tmp)
        t = tmp(i)
        
        '\x9 is not expanded to \x09 throws error...
        
        If Len(t) >= 2 Then
            decode = Mid(t, 1, 2)
            If isHexChar(decode) Then
                hex_bpush r(), decode
                If Len(t) > 2 Then s_bpush r(), Mid(t, 3)
            Else
                s_bpush r(), "\x" & tmp(i)
            End If
        Else
            s_bpush r(), "\x" & tmp(i)
        End If
        
    Next
     
            
hell:
     js_unescape = StrConv(r(), vbUnicode, LANG_US)
     
     'If Err.Number <> 0 Then
     '   MsgBox "Error in unescape:( " & Err.Description
     'End If
     
End Function

Function nl_unescape(ByVal x)
    
    x = Replace(x, "\r\n", vbCrLf)
    x = Replace(x, "\n", vbCrLf)
    x = Replace(x, "\r", vbCrLf)
    x = Replace(x, "\t", vbTab)
    x = Replace(x, "\(", "(")
    x = Replace(x, "\)", ")")
    x = Replace(x, "\" & vbCrLf, Empty)
    
    nl_unescape = x
    
End Function

Public Function HexStringUnescape(str, Optional stripWhite As Boolean = False, Optional noNulls As Boolean = False, Optional bailOnManyErrors As Boolean = False)

    Dim ret As String
    Dim x As String
    Dim errCount As Long
    Dim r() As Byte
    Dim b As Byte
    
    On Error Resume Next

    If stripWhite Then
        str = Replace(str, " ", Empty)
        str = Replace(str, vbCrLf, Empty)
        str = Replace(str, vbCr, Empty)
        str = Replace(str, vbLf, Empty)
        str = Replace(str, vbTab, Empty)
        str = Replace(str, Chr(0), Empty)
    End If

    For i = 1 To Len(str) Step 2 'this is to agressive for headers...
        x = Mid(str, i, 2)
        If isHexChar(x, b) Then
            bpush r(), b
        Else
            errCount = errCount + 1
            s_bpush r(), x
        End If
    Next

    ret = StrConv(r(), vbUnicode, LANG_US)
    
    If noNulls Then ret = Replace(ret, Chr(0), Empty)
    
    If bailOnManyErrors And (errCount > 5) Then
        HexStringUnescape = str
    Else
        HexStringUnescape = ret
    End If
    
End Function

Function ExtractFromParanthesisPageEncapsulation(data)
    
    On Error Resume Next
    
    Dim ret As String
    
    t = Split(data, "(")
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

Function EscapeHeader(ByVal raw As String) As String
    
    '#xx hex encoding
    '"\" & vbcrlf line continuations..(CR, LF or CRLF)
    '\xxx octal encodings
    '<9090eb> hex encodings
    '<90 90 eb> hex encodings (any amount of whitespace is ok in hex string like this...
    
    On Error GoTo hell
    Dim original As String
    Dim mods() As String
    Dim placeholders() As String
    Dim rchar As Byte
    Dim hadLeftOpen As Boolean
    Dim hadRightClose As Boolean
    
    original = raw
    
    raw = Replace(raw, vbCr, Chr(2))
    raw = Replace(raw, vbLf, Chr(2))
    raw = Replace(raw, Chr(2), vbCrLf)
    raw = Replace(raw, vbCrLf & vbCrLf, vbCrLf)
    
    raw = nl_unescape(raw)
    
    While IsWhitespace(raw): raw = Mid(raw, 2): Wend
    If VBA.left(raw, 2) = "<<" Then
        raw = Mid(raw, 3)
        hadLeftOpen = True
    End If
    While VBA.left(raw, 1) = "<": raw = Mid(raw, 2): Wend
    
    While IsWhitespace(raw, False): raw = Mid(raw, 1, Len(raw) - 1): Wend
    If VBA.right(raw, 2) = ">>" Then
        raw = Mid(raw, 1, Len(raw) - 2)
        hadRightClose = True
    End If
    While IsWhitespace(raw, False): raw = Mid(raw, 1, Len(raw) - 1): Wend
    
    
    'nested markers are temporarily replaced while we go after <> hex strings
    raw = Replace(raw, "<<", Chr(2))
    raw = Replace(raw, ">>", Chr(3))
    
    offset = InStr(raw, "<")
    rchar = &H41
    
    'handle JS headers extra lightly may have embedded < > which below routine is to harsh for...
    isJSHeader = IIf(LCase(raw) Like "*/js*(*", True, False)
    
    'If InStr(raw, "/JS(") > 0 Then Stop
    
    Do While offset > 0 And Not isJSHeader
        b = InStr(offset, raw, ">") 'bug: if header has JS and > is embedded in quoted string bug...
        If b > 0 Then
            hexstring = Trim(Mid(raw, offset + 1, b - 1 - offset))
            
            If InStr(hexstring, " ") < 1 Then
                decoded = HexStringUnescape(hexstring, True, False, True) 'to agressive for generic use...
            Else
                decoded = hexstring
            End If
            
            push mods(), decoded
            
            'this style of replace could cause overlap with user data (a string of AAA?)
            'push placeholders(), String(Len(hexstring), Chr(rchar))
            'replace our hexstring with an equal length unique placeholder
            'raw = Replace(raw, hexstring, String(Len(hexstring), Chr(rchar)))
            'rchar = rchar + 1
            
            place = "__myVar_" & Chr(rchar)
            push placeholders(), place
            rchar = rchar + 1
            
            raw = Replace(raw, hexstring, place)
            If Len(place) > Len(hexstring) Then 'my original buffer just got longer by
                diff = Len(place) - Len(hexstring)
            Else
                diff = Len(hexstring) - Len(place)
            End If
            
            offset = offset + diff
            
        Else
            Exit Do
        End If
        If offset + 1 > Len(raw) Then Exit Do
        offset = InStr(offset + 1, raw, "<")
    Loop
        
    If isJSHeader Then
            raw = Replace(raw, "/(", "(")
            raw = Replace(raw, "/)", ")")
    End If
    
    raw = pound_unescape(raw)
    raw = octal_unescape(raw)
        
    If Not AryIsEmpty(mods) Then
        For i = 0 To UBound(mods)
            raw = Replace(raw, "<" & placeholders(i) & ">", mods(i))
        Next
    End If
    
    raw = Replace(raw, Chr(2), "<<")
    raw = Replace(raw, Chr(3), ">>")
    
    If hadLeftOpen Then raw = "<<" & raw
    If hadRightClose Then raw = raw & ">>"
    
    EscapeHeader = raw
            
    
    
Exit Function
hell:
    EscapeHeader = original

End Function

Function IsWhitespace(strin As String, Optional onLeft As Boolean = True) As Boolean
    
    Dim c As Byte
    
    If onLeft Then
        c = Asc(VBA.left(strin, 1))
    Else
         c = Asc(VBA.right(strin, 1))
    End If
    
     If c = 0 Or c = 9 Or c = 10 Or c = 12 Or c = 13 Or c = 32 Then IsWhitespace = True
    
End Function

Private Sub push(ary, Value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = Value
    Exit Sub
init: ReDim ary(0): ary(0) = Value
End Sub

Private Function AryIsEmpty(ary) As Boolean
  On Error GoTo oops
    x = UBound(ary)
    AryIsEmpty = False
  Exit Function
oops: AryIsEmpty = True
End Function

Private Sub s_bpush(bAry() As Byte, sValue As String)
    Dim tmp() As Byte
    Dim i As Long
    tmp() = StrConv(sValue, vbFromUnicode, LANG_US)
    For i = 0 To UBound(tmp)
        bpush bAry, tmp(i)
    Next
End Sub

Private Sub bpush(bAry() As Byte, b As Byte) 'this modifies parent ary object
    On Error GoTo init
    Dim x As Long
    
    x = UBound(bAry) '<-throws Error If Not initalized
    ReDim Preserve bAry(UBound(bAry) + 1)
    bAry(UBound(bAry)) = b
    
    Exit Sub

init:
    ReDim bAry(0)
    bAry(0) = b
    
End Sub

'Public Function isHex(v) As Boolean
'    isHex = isHexChar(CStr(v))
'End Function

Public Function isHexNum(v) As Boolean
    On Error Resume Next
    x = CLng("&h" & v)
    If Err.Number = 0 Then isHexNum = True
    Err.Clear
End Function

Public Function isHexChar(hexValue As String, Optional b As Byte) As Boolean
    On Error Resume Next
    Dim v As Long
    
    
    If Len(hexValue) = 0 Then GoTo nope
    If Len(hexValue) > 2 Then GoTo nope 'expecting hex char code like FF or 90
    
    v = CLng("&h" & hexValue)
    If Err.Number <> 0 Then GoTo nope 'invalid hex code
    
    b = CByte(v)
    If Err.Number <> 0 Then GoTo nope  'shouldnt happen.. > 255 cant be with len() <=2 ?

    isHexChar = True
    
    Exit Function
nope:
    Err.Clear
    isHexChar = False
End Function

Private Function hex_bpush(bAry() As Byte, hexValue As String) As Boolean   'this modifies parent ary object
    On Error Resume Next
    Dim b As Byte
    If Not isHexChar(hexValue, b) Then Exit Function
    bpush bAry, b
    hex_bpush = True
End Function


'this is kind of BS but so are AV detections for shellcode...
Function QuickEncode(ByVal hexstring) As String
    
    Dim b() As Byte
    Dim s As String
    
    s = HexStringUnescape(hexstring)
    b() = StrConv(s, vbFromUnicode, LANG_US)
    For i = 0 To UBound(b)
        b(i) = b(i) Xor 59
        If b(i) = 255 Then
            b(i) = 0
        Else
            b(i) = b(i) + 1
        End If
    Next
    s = StrConv(b(), vbUnicode, LANG_US)
    QuickEncode = HexDump(s, 1)
    
End Function

Function QuickDecode(ByVal hexstring) As String
    
    Dim b() As Byte
    Dim s As String
    
    s = HexStringUnescape(hexstring)
    b() = StrConv(s, vbFromUnicode, LANG_US)
    For i = 0 To UBound(b)
        If b(i) = 0 Then
            b(i) = 255
        Else
            b(i) = b(i) - 1
        End If
        b(i) = b(i) Xor 59
    Next
    s = StrConv(b(), vbUnicode, LANG_US)
    QuickDecode = HexDump(s, 1)
    
End Function

