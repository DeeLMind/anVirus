VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CScriptFunctions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:     http://sandsprite.com

Dim dsm As New CDisassembler
Public Collab As Object
Public lv As Object
Public media As Object

Dim alertCount As Long
Dim showingAlerts As Boolean
Dim alertCycles As Long

Dim oBrowser As Object

Property Get Text()
    Text = Form2.txtOut.Text
End Property

Property Let Text(v)
    t v
End Property

Function GetListviewData(Index As Long)
    On Error Resume Next
    GetListviewData = lv.ListItems(Index).tag
End Function

Function ResetAlertCount()
    alertCount = 0
    alertCycles = 0
    showingAlerts = True
    Form2.sc.Timeout = 10000
End Function

Function collectEmailInfo(ParamArray agrs())
    DebugLog "collab.collectEmailInfo() called - CVE-2007-5659"
End Function

Function getIcon(ParamArray args())
    DebugLog "this.getIcon() called - CVE-2009-0927"
End Function

Function printf(ParamArray args())
    DebugLog "util.printf() called - CVE-2008-2992"
End Function

Function printd(ParamArray args())
    DebugLog "util.printd() called"
End Function

Function newPlayer(ParamArray args())
    DebugLog "media.newPlayer called - CVE-2009-4324"
End Function

Function printSeps()
    DebugLog "this.printSeps called - CVE-2010-4091"
End Function

Function customDictionaryOpen(ParamArray args())
    DebugLog "customDictionaryOpen called - CVE-2009-1493"
End Function

Function DebugLog(msg, Optional data)
    On Error Resume Next
    Dim li As ListItem
    Set li = Form2.lv2.ListItems.Add(, , msg)
    If LCase(msg) = "exploit" Then li.ForeColor = vbRed
    If Len(data) > 0 Then li.SubItems(1) = data
End Function

Function GetPageNum()
    GetPageNum = Form2.txtPageNum
    'DebugLog "this.PageNum(" & Form2.txtPageNum & ") accessed"
End Function

Public Function GetPageNumWords(Optional page = 0) As Long
    On Error Resume Next
    GetPageNumWords = oBrowser.GetPageNumWords(page)
    DebugLog "this.GetPageNumWords(" & page & ") accessed"
End Function

Public Function GetPageNthWord(Optional page = 0, Optional word = 0, Optional strip = 0)
    On Error Resume Next
    GetPageNthWord = oBrowser.GetPageNthWord(page, word)
End Function

Public Function GetInfoFields() As String
    On Error Resume Next
    GetInfoFields = oBrowser.GetInfoFields()
End Function
 
Function GetInfoField(field)
    On Error Resume Next
    GetInfoField = oBrowser.GetInfoField(field)
End Function

Function GetNumPages()
    On Error Resume Next
    GetNumPages = oBrowser.GetNumPages()
End Function

Function GetAnnotCountForPage(page)
    On Error Resume Next
    GetAnnotCountForPage = oBrowser.GetAnnotCountForPage(page)
End Function

Function GetSubjectForAnnot(page, Index)
    'MsgBox "GetSubjectForAnnot(" & page & " , " & index & ")"
    'GetSubjectForAnnot = "page: " & page & " index: " & Index
    On Error Resume Next
    GetSubjectForAnnot = oBrowser.GetAnnot(page, Index)
End Function

Function GetViewerVersion()
    On Error Resume Next
    GetViewerVersion = Form2.cboVersion.Text
    'DebugLog "GetViewerVersion(" & Form2.cboVersion.Text & ")" 'always called from userlib.js
End Function

Public Function CRC(s)
    On Error Resume Next
    CRC = CRC32(CStr(s))
End Function

Public Function GetStream(Index)
        
        On Error Resume Next
        Dim s As CPDFStream
        Dim li As ListItem
        For Each li In Form1.lv.ListItems
            Set s = li.tag
            If s.Index = Index Then
                If s.isCompressed Then
                    GetStream = s.DecompressedData
                Else
                    GetStream = s.OriginalData
                End If
                Exit Function
            End If
        Next
        
End Function

Public Function disasm(bytes)
    
    MsgBox "olly.dll removed due to av alert, I didnt use this much anyway...", vbInformation
    Exit Function
    
    Dim d As Collection
    Dim ci As CInstruction
    Dim op() As Byte
    Dim ret As String
    Dim offset As String
    
    On Error Resume Next
    
    op() = StrConv(bytes, vbFromUnicode, LANG_US)
    
    Set d = dsm.DisasmBlock(op, 0)
    For Each ci In d
        offset = pad(ci.offset, 8)
        dump = pad(ci.dump, 12, " ", False)
        ret = ret & offset & "    " & dump & vbTab & ci.command & vbCrLf
    Next

    disasm = ret
    
    If Err.Number <> 0 Then MsgBox Err.Description
    
End Function

Function pad(ByVal str, cnt, Optional char = "0", Optional padleft As Boolean = True)
    
    On Error Resume Next
    
    While Len(str) < cnt
        If padleft Then
            str = char & str
        Else
            str = str & char
        End If
    Wend
    pad = str
    
End Function

Public Sub alertType(x)
    On Error Resume Next
    MsgBox TypeName(x)
End Sub
    
Public Sub alert(x)
    On Error Resume Next
    Err.Clear
    alertCount = alertCount + 1
    If showingAlerts And alertCount > 20 Then
        If MsgBox("Disable alert? (chance " & alertCycles & ")", vbYesNo) = vbYes Then
            showingAlerts = False
        End If
        alertCount = 0
        alertCycles = alertCycles + 1
        'If alertCycles > 5 Then
        '    MsgBox "More than 100 alerts have been shown setting timeout to 1"
        '    set Form2.sc =
        'End If
    End If
    If showingAlerts Then MsgBox x, , "Alert " & alertCount & " (can disable at 20)"
    If Err.Number <> 0 Then alertType x
End Sub



Public Function eval(x)
    t x
    DebugLog "eval", x
End Function

Public Function t(x)
    On Error Resume Next
    'If Len(Form2.txtOut.Text) > 0 Then
    '    DebugLog "txtOut", Form2.txtOut.Text
    'End If
    Form2.txtOut.Text = x
    DebugLog "txtOut", Form2.txtOut.Text
End Function

Public Function Save2Clipboard(x)
    
    If InStr(x, Chr(0)) > 0 Then
        MsgBox "Can not copy binary data", vbInformation
        Exit Function
    End If
    
    Clipboard.Clear
    Clipboard.SetText x

End Function


Public Function GetClipboard()
    GetClipboard = Clipboard.GetText
End Function

Public Sub writeFile(path, data)
    Dim f As Long
    Dim b() As Byte
    
    If MsgBox("You are about to write " & Hex(Len(data)) & " bytes to " & vbCrLf & path & vbCrLf & vbCrLf & "Allow?", vbYesNo) = vbNo Then
        Exit Sub
    End If
    
    On Error Resume Next
    
    f = FreeFile
    b() = StrConv(data, vbFromUnicode, LANG_US)
    Open path For Binary As f
    Put f, , b()
    Close f
    
   If Err.Number <> 0 Then MsgBox "Error: " & Err.Description
   
End Sub

Public Function HexDump(str, Optional hexOnly = 0)
    On Error Resume Next
    HexDump = fso.HexDump(str, hexOnly)
End Function

Public Function ReadFile(path)
    On Error Resume Next
    ReadFile = fso.ReadFile(path)
End Function

Public Function unescape(x)
Attribute unescape.VB_UserMemId = 0
    On Error Resume Next
    unescape = modEscapes.unescape(x)
End Function

Public Function pound_unescape(x)
    On Error Resume Next
    pound_unescape = modEscapes.pound_unescape(x)
End Function

Public Function HexString2Bytes(str)
    On Error Resume Next
    HexString2Bytes = modEscapes.HexStringUnescape(str)
        
End Function

Public Function EscapeHexString(hexstr)
    
    EscapeHexString = modEscapes.EscapeHexString(hexstr)
    
End Function

Public Function ObjectPointer(x)
    On Error Resume Next
    ObjectPointer = Hex(ObjPtr(x))
End Function

Public Function Help()
    On Error Resume Next
    p = App.path & "\JS_UI_Readme.txt"
    If fso.FileExists(p) Then
        Shell "notepad.exe """ & p & """", vbNormalFocus
    Else
        MsgBox "File not found: " & p
    End If
End Function

Function RefreshObjBrowserData()
    On Error Resume Next
    Set oBrowser = GetObject("", "obj_Browser.plugin") 'CreateObject("obj_Browser.plugin")
    oBrowser.initasLib Form1
End Function

Function b64Decode(data)
   On Error Resume Next
   org = data
   data = Replace(data, "ByVal", Empty, , , vbTextCompare)
   b64Decode = b64.b64DecodeString(data)
   If Err.Number <> 0 Or Len(b64Decode) = 0 Then
        b64Decode = org
   End If
   If InStr(b64Decode, Chr(0)) > 0 Then
        b64Decode = Replace(b64Decode, Chr(0), "\x00")
   End If
End Function


Private Sub Class_Initialize()
    On Error Resume Next
    Set Collab = Me
    Set lv = Form2.lv
    Set media = Me
End Sub
