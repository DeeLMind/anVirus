VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CFunc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com
'
' this class is part of the refactoring code. it can really make your brain hurt.

Public OrgName As String
Public NewName As String
Public OrgArgs As New Collection
Public ArgCount As Long
Public OrgText As String
Public CleanText As String
Public Index As Long
Public OrgVars As New Collection
Public ParentForm As frmRefactor
Public Saved As Boolean
Public OverRides As New Collection
Public IsGlobal As Boolean
Public OverRideScript As String
Public UseOriginalText As Boolean
Public debugout As Boolean
Public UseOriginalFuncName As Boolean
Public logger As ListBox
Public OverRideName As String

Private tokenizedScript As String
Private my_tokens As New Collection

    
Function ApplyOverrides() As String
    
    'ApplyOverrides = FinalReplace(tokenizedScript)
    
    OverRideScript = Me.CleanText
    
    For Each v In OverRides
        tmp = Split(v, "->")
        While InStr(OverRideScript, tmp(0)) > 0
            OverRideScript = Replace(OverRideScript, tmp(0), tmp(1))
        Wend
    Next
        
    ApplyOverrides = OverRideScript
        
End Function

Sub ResetParse()
        
    Set OrgArgs = New Collection
    Set OrgVars = New Collection
    Set my_tokens = New Collection
        
End Sub

Sub ParseName()
    
        x = Me.OrgText
        p1 = InStr(x, "(")
        p2 = InStr(x, ")")
        sp = InStrRev(x, " ", p1) 'first space (between fun name and agrs)
           
        Me.OrgName = Trim(Mid(x, sp, p1 - sp))
        Me.NewName = "func_" & SafeFuncIndex(Me.Index)
        If Not Me.logger Is Nothing Then logger.AddItem "Found Function " & Me.OrgName & " -> " & Me.NewName
        
End Sub

Sub ParseAsGlobal()
    
        Dim newVar As String
         
        
        x = Me.OrgText
         
        debugout = True
        
        'On Error GoTo hell
        
        body = x
        tmp = Split(body, vbCrLf)
        For Each y In tmp
             
            a = InStr(y, "var ")
            If a > 0 Then
                b1 = InStr(a + 4, y, "-") 'todo change to scan for next nontext
                b2 = InStr(a + 4, y, "+")
                b3 = InStr(a + 4, y, "^")
                b4 = InStr(a + 4, y, "=")
                'b5 = InStr(a + 4, y, " ")
                b = GetLowest(b1, b2, b3, b4)
                If b > 0 Then
                    newVar = Trim(Mid(y, a + 4, b - a - 4))
                    If Not tokenExists(newVar) Then
                        OrgVars.Add newVar
                        AddToken newVar
                        If debugout And Not Me.logger Is Nothing Then logger.AddItem "Adding g orgvar: " & Trim(Mid(y, a + 4, b - a - 4))
                    End If
                End If
            End If
        Next
        
        For i = 0 To UBound(tmp) 'now we replace tokens line by line by parsing each line
            tmp(i) = ReplaceTokens(tmp(i))
        Next
        
        tokenizedScript = Join(tmp, vbCrLf)
        
        For i = 0 To UBound(tmp)
            tmp(i) = FinalReplace(tmp(i))
        Next
     
        x = Join(tmp, vbCrLf)
        
 
hell:
        Me.CleanText = x
    
End Sub

Sub ParseSelf() 'as function w/prototype
    
        Dim newVar As String
        If Me.IsGlobal Then Exit Sub
        
        x = Me.OrgText
        debugout = True
        
        'On Error GoTo hell
        
        p1 = InStr(x, "(")
        p2 = InStr(x, ")")
        sp = InStrRev(x, " ", p1) 'first space (between fun name and agrs)
        
        n = Mid(x, p1 + 1, p2 - p1 - 1) 'args between parathensis
        tmp = Split(n, ",")
        If Not AryIsEmpty(tmp) Then
            For Each y In tmp
                If Trim(Len(y)) > 0 Then
                    OrgArgs.Add Trim(y)
                End If
            Next
        End If
        
        'now we parse the function body line by line to extract explicitly var declared variables
        body = Mid(x, p2 + 1) 'from first { to last } --> BUG CHECK: JUST ADDED THE +1 HERE !!
        tmp = Split(body, vbCrLf)
        For Each y In tmp
            DoEvents
            a = InStr(y, "var ")
            If a > 0 Then
                b1 = InStr(a + 4, y, "-") 'todo change to scan for next nontext
                b2 = InStr(a + 4, y, "+")
                b3 = InStr(a + 4, y, "^")
                b4 = InStr(a + 4, y, "=")
                b = GetLowest(b1, b2, b3, b4)
                If b > 0 Then
                    newVar = Trim(Mid(y, a + 4, b - a - 4))
                    If Not tokenExists(newVar) Then
                        OrgVars.Add newVar
                        AddToken newVar
                        If debugout And Not logger Is Nothing Then logger.AddItem Me.OrgName & " ParseSelf adding new token: " & newVar
                    End If
                End If
            End If
        Next
        
        
        'this is to general?
        head = Replace(Mid(x, 1, p2), OrgName, Me.NewName) 'clean function name first
        args = Mid(x, p1 + 1, p2 - p1 - 1)
        newargs = FinalReplace(ReplaceTokens(args))
        
        For i = 0 To UBound(tmp) 'now we replace tokens line by line by parsing each line
            tmp(i) = ReplaceTokens(tmp(i))
        Next
        
        tokenizedScript = Replace(head, args, newargs) & Join(tmp, vbCrLf)
        
        For i = 0 To UBound(tmp)
            tmp(i) = FinalReplace(tmp(i))
        Next
     
        x = Replace(head, args, newargs) & Join(tmp, vbCrLf)
        
 
hell:
        Me.CleanText = x
    
End Sub

Private Function FinalReplace(ByVal x)
    
    Dim overridden_varName
    Dim aIndex As Long
    Dim tmp As String
    
    For aIndex = 0 To 254
            
            tmp = SafeFuncIndex(aIndex)
            
            If InStr(x, "__arg_" & tmp) > 0 Then
                x = Replace(x, "__arg_" & tmp, "arg_" & tmp)
            End If
            
            If InStr(x, "__var_" & tmp) > 0 Then
                If IsGlobal Then
                    x = Replace(x, "__var_" & tmp, "gvar_" & tmp)
                Else
                    x = Replace(x, "__var_" & tmp, "v" & tmp)
                End If
            End If
            
            
            If InStr(x, "__func_" & SafeFuncIndex(aIndex)) > 0 Then
                x = Replace(x, "__func_" & SafeFuncIndex(aIndex), "func_" & SafeFuncIndex(aIndex))
            End If
            
         
    Next
            
    FinalReplace = x
    
End Function

Function OverrideExists(varIndex) As String
    
    Dim x
     
    For Each x In OverRides
        tmp = Split(x, "->")
        vnew = IIf(Me.IsGlobal, "gvar_" & SafeFuncIndex(CLng(varIndex)), "v" & SafeFuncIndex(CLng(varIndex)))
        If tmp(0) = vnew Then
            OverrideExists = tmp(1)
            Exit Function
        End If
    Next
    
End Function

Private Function ReplaceTokens(ByVal l, Optional startPos As Long = 1) 'l = a line of data
    
    Dim i As Long, j As Long
    Dim buf As String
    
    Dim tokenstart
    Dim tokenend
    Dim inQuotes As Boolean
    Dim outOfQuotes As Boolean
    Dim f As CFunc
    Dim debugout As Boolean
    
    debugout = False
    
    If debugout And startPos = 1 Then Debug.Print "In ReplaceTokens line: " & l
    
    'If InStr(l, "sc.replace(re, kc)") > 0 Then Stop
    
    If Len(l) = 0 Then Exit Function
    
    'special chars 5C=\ 27=' 22="
    i = startPos
    While i < Len(l) + 1 'extract & replace tokens as found
        DoEvents
        c = Mid(l, i, 1)
        c2 = Empty
        
        If outOfQuotes Then
            outOfQuotes = False
            inQuotes = False
        End If
        
        If i + 1 <= Len(l) + 1 Then
            c2 = Mid(l, i + 1, 1)
        End If
        
        If c = "'" Or c = """" Then
            If inQuotes = True Then
               If c2 <> "\" Then outOfQuotes = True
            Else
                inQuotes = True
            End If
        End If
               
        If Not inQuotes Then
            If isTextRange(Asc(c), IIf(Len(buf) = 0, False, True)) Then
                buf = buf & c
            Else
                'we have a complete token now
                If Len(buf) = 0 Or buf = "var" Then GoTo skip_token
                 
                
                'If buf = "replace" Then Stop
                If debugout Then Debug.Print "complete token: " & buf
                'If Me.IsGlobal And buf = s Then Stop
                
                j = 0
                For Each mvar In Me.OrgVars
                    If buf = mvar Then
                        a = Empty
                        b = Empty
                        newtoken = Empty
                        
                        If tokenstart > 1 Then
                            a = Mid(l, 1, tokenstart)
                        End If
                        If tokenstart + Len(buf) + 1 < Len(l) Then
                            b = Mid(l, tokenstart + Len(buf) + 1)
                        End If
                        newtoken = "__var_" & SafeFuncIndex(j)
                        l = a & newtoken & b
                        ReplaceTokens = ReplaceTokens(l, Len(a) + Len(newtoken))
                        Exit Function
                    End If
                    j = j + 1
                Next

                j = 0
                For Each mvar In Me.OrgArgs
                    If buf = mvar Then
                        a = Empty
                        b = Empty
                        newtoken = Empty
                        
                        If tokenstart > 1 Then a = Mid(l, 1, tokenstart)
                        
                        If tokenstart + Len(buf) + 1 < Len(l) Then
                            b = Mid(l, tokenstart + Len(buf) + 1)
                        End If
                       
                        newtoken = "__arg_" & SafeFuncIndex(j)
                        l = a & newtoken & b
                        ReplaceTokens = ReplaceTokens(l, Len(a) + Len(newtoken))
                        Exit Function
                         
                    End If
                    j = j + 1
                Next
                
                If Me.IsGlobal = False Then
                    j = 0
                    For Each mvar In Me.ParentForm.global_script.OrgVars
                        If buf = mvar Then
                            a = Empty
                            b = Empty
                            newtoken = Empty
                            
                            If tokenstart > 1 Then
                                a = Mid(l, 1, tokenstart)
                            End If
                            If tokenstart + Len(buf) + 1 < Len(l) Then
                                b = Mid(l, tokenstart + Len(buf) + 1)
                            End If
                            
                            newtoken = "__gvar_" & SafeFuncIndex(j)
                            l = a & newtoken & b
                            ReplaceTokens = ReplaceTokens(l, Len(a) + Len(newtoken))
                            Exit Function
                             
                        End If
                        j = j + 1
                    Next
                End If
                
                For Each f In Me.ParentForm.funcs
                    If buf = f.OrgName Then
                        a = Empty
                        b = Empty
                        newtoken = Empty
                        
                        If tokenstart > 1 Then
                            a = Mid(l, 1, tokenstart)
                        End If
                        If tokenstart + Len(buf) + 1 < Len(l) Then
                            b = Mid(l, tokenstart + Len(buf) + 1)
                        End If
                        
                        newtoken = "__func_" & SafeFuncIndex(f.Index)
                        l = a & newtoken & b
                        ReplaceTokens = ReplaceTokens(l, Len(a) + Len(newtoken))
                        Exit Function
                         
                    End If
                    
                Next
                
                
skip_token:
                buf = Empty
                tokenstart = i
            End If
        End If

        i = i + 1
    Wend
    
    'now do final replace
    For Each mvar In Me.OrgVars
        If buf = mvar Then
            a = Empty
            b = Empty
            newtoken = Empty
            
            If tokenstart > 1 Then
                a = Mid(l, 1, tokenstart)
            End If
            If tokenstart + Len(buf) + 1 < Len(l) Then
                b = Mid(l, tokenstart + Len(buf) + 1)
            Else
                 Debug.Print "?"
            End If
            
            l = a & "__var_" & SafeFuncIndex(j) & b
        End If
    Next

    j = 0
    For Each mvar In Me.OrgArgs
        If buf = mvar Then
            a = Empty
            b = Empty
            
            If tokenstart > 1 Then
                a = Mid(l, 1, tokenstart)
            End If
            If tokenstart + Len(buf) + 1 < Len(l) Then
                b = Mid(l, tokenstart + Len(buf) + 1)
            End If
            
            l = a & "__arg_" & SafeFuncIndex(j) & b
        End If
        j = j + 1
    Next
    
    If Me.IsGlobal = False Then
        j = 0
        For Each mvar In Me.ParentForm.global_script.OrgVars
            If buf = mvar Then
                a = Empty
                b = Empty
                If tokenstart > 1 Then
                    a = Mid(l, 1, tokenstart)
                End If
                If tokenstart + Len(buf) + 1 < Len(l) Then
                    b = Mid(l, tokenstart + Len(buf) + 1)
                End If
               
                l = a & "__gvar_" & SafeFuncIndex(j) & b
            End If
            j = j + 1
        Next
    End If
                
    For Each f In Me.ParentForm.funcs
        If buf = f.OrgName Then
            a = Empty
            b = Empty
            If tokenstart > 1 Then
                a = Mid(l, 1, tokenstart)
            End If
            If tokenstart + Len(buf) + 1 < Len(l) Then
                b = Mid(l, tokenstart + Len(buf) + 1)
            End If
            
            l = a & "__func_" & SafeFuncIndex(f.Index) & b
        End If
        
    Next
                
    If debugout Then Debug.Print "Ending ReplaceTOkens final line: " & l
    ReplaceTokens = l
    
    
    
End Function

Function SafeFuncIndex(x As Long) As String
    SafeFuncIndex = IIf(x < 10, "0" & x, x)
End Function

Function isTextRange(x As Integer, Optional includeNumeric As Boolean = False) As Boolean
    '61=a 7A=z 41=A 5A=Z 5F=_
    
    'variables an not start with numeric
    If includeNumeric Then If x >= &H30 And x <= &H39 Then isTextRange = True '0-9
    If x >= &H61 And x <= &H7A Then isTextRange = True 'a-z
    If x >= &H41 And x <= &H5A Then isTextRange = True 'A-Z
    If x = &H5F Then isTextRange = True '_
    
End Function



Function SortVars(ByVal c As Collection) As Collection
        
    Dim n As New Collection
    
    longest = 0
    longindex = 0
    
    i = 0
    While c.count > 0
        longest = 0
        For i = 1 To c.count
            x = Len(c(i))
            If x > longest Then
                longest = x
                longindex = i
            End If
        Next
        n.Add c(longindex)
        c.Remove longindex
    Wend
    
    Set SortVars = n
    
End Function

Function tokenExists(t As String) As Boolean
    On Error GoTo hell
    x = my_tokens("token:" & t)
    tokenExists = True
    Exit Function
hell:
End Function

Function AddToken(t As String) As Boolean
    On Error GoTo hell
    my_tokens.Add t, "token:" & t
    AddToken = True
    Exit Function
hell:
End Function

Function GetLowest(ParamArray args())
    Dim lowest As Long
    lowest = -1
    For Each y In args
        If y > 0 Then
            If lowest = -1 Then lowest = y
            If y < lowest Then lowest = y
        End If
    Next
    GetLowest = lowest
End Function

Function GetCount(s, c) As Long
    On Error Resume Next
    tmp = Split(s, c)
    GetCount = UBound(tmp)
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


