VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CApplyFilters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public UnsupportedFilter As Boolean
Public DecompressionError As Boolean
Public DecompErrorMessage As String

Private parent As CPDFStream
Private Const unsptFilters = "DCTDecode,JPXDecode"

Private hasDecodeParams As Boolean
Private predictor As Integer
Private columns As Integer
Private colors As Integer
Private bitspercomponent As Integer

Dim filters() As Decoders

Property Get GetActiveFiltersCount() As Long
    
    If AryIsEmpty(filters) Then
        GetActiveFiltersCount = 0
    Else
        GetActiveFiltersCount = UBound(filters) + 1
    End If
    
End Property
    
Sub ApplyFilters()
    
    Dim d As Decoders
    Dim buf As String
    Dim pos As Long
    
    If Form1.mnuDisableDecomp.Checked = True Then Exit Sub
    If UnsupportedFilter Then Exit Sub
    
    buf = parent.OriginalData
    
    If GetActiveFiltersCount() > 0 Then
    
        For Each x In filters
            d = x
            
            If DecompressionError = True Then Exit For
            
            If d = FlateDecode Then 'And Not csharp.Initilized Then
                
                buf = NativeDecompress(buf) 'always use native zlib...
                
            ElseIf d = AsciiHexDecode Then
                
                pos = InStr(buf, ">")
                If pos > 1 Then buf = Mid(buf, 1, pos - 1) 'koji pdf spec 3.3.1 > is end of data
                buf = HexStringUnescape(buf, True) 'always use my vb implementation
            
            ElseIf d = CCITTFaxDecode Then
                
                buf = HandleFaxDecode(buf, True)
                
            ElseIf d = JBIG2Decode Then
                
                If Form1.mnuEnableJBIG2.Checked Then
                    buf = mupdf.muJBIG2Decode(buf)
                    If Len(buf) = 0 Then
                        DecompressionError = True
                        DecompErrorMessage = "Failed to decode JBIG2 Stream possibly malformed?"
                    End If
                Else
                    DecompressionError = True
                    DecompErrorMessage = "Native JBIG2 Filter is not enabled in options."
                End If
                
            'all the rest of the decoders are handled in C# code...
            ElseIf csharp.Initilized Then 'And Form1.mnuDisableiText.Checked = False Then  'send everything through the iTextDecode
                
                'default is now to use mupdf version for CCITTFaxDecode
                If d = CCITTFaxDecode Then HandleFaxDecode buf, False  'set decode parameters
                If d = DecodePredictor Then ParsePredictor
                
                'If parent.Index = 19 Then Stop
                
                If Not csharp.decode(buf, d) Then
                    DecompressionError = True
                    DecompErrorMessage = csharp.ErrorMessage
                    Exit For
                Else
                    buf = csharp.DecodedBuffer
                End If
                
            Else
                DecompressionError = True
                If csharp.DetectDotNet = True Then
                    DecompErrorMessage = csharp.ErrorMessage
                Else
                    DecompErrorMessage = "This filter requires .NET 2.0 or greater installed"
                End If
                Exit For
            End If
        Next
    
        If Not DecompressionError Then
            parent.DecompressedData = buf
            parent.DecompressedSize = Len(buf)
        End If
        
    End If
    
            
    
End Sub

Private Function NativeDecompress(ByVal s As String)
    Dim b() As Byte
    Dim bOut() As Byte
    
    b = StrConv(s, vbFromUnicode, LANG_US)
                
    modZLIB.UncompressData b(), bOut()
    
    If AryIsEmpty(bOut) Then
        parent.Message = "FlateDecode Decompression Error. Input data length = 0x" & Hex(Len(s))
        DecompErrorMessage = parent.Message
        DecompressionError = True
    Else
        NativeDecompress = StrConv(bOut, vbUnicode, LANG_US)
    End If
                
End Function

Private Function ExtractNextValue(tag As String, Optional defVal = "")
    On Error Resume Next
    Dim es As String
    es = LCase(parent.escapedHeader)
    a = InStr(1, es, LCase(tag), vbTextCompare)
    If a > 0 Then
        b = InStr(a, es, "/")
        c = InStr(a, es, "]")
        d = InStr(a, es, ">>")
        b = lowest(b, c, d)
        If b > 0 Then
            a = a + Len(tag) + 1
            ExtractNextValue = Trim(Mid(es, a, b - a))
            Exit Function
        End If
    End If
    ExtractNextValue = defVal
End Function

Private Function lowest(ParamArray x())
    On Error Resume Next
    Dim l As Long
    For i = 0 To UBound(x)
        If l = 0 And x(i) > 0 Then l = x(i)
        If x(i) < l And x(i) >= 1 Then l = x(i)
    Next
    lowest = l
End Function

Function HandleFaxDecode(buf As String, Optional use_MuPdf As Boolean = True)

    On Error Resume Next
    Dim k As Long, endofline As Long, encodedbytealign As Long, columns As Long, rows As Long, endofblock As Long, blackis1 As Long
    Dim height As Long
    
    k = CLng(ExtractNextValue("K", 0))
    endofline = CLng(ExtractNextValue("EndofLine", 0))
    encodedbytealign = CLng(ExtractNextValue("EncodedByteAlign", 0))
    columns = CLng(ExtractNextValue("Columns", 1728))
    rows = CLng(ExtractNextValue("Rows", 0))
    endofblock = CLng(ExtractNextValue("EndOfBlock", 1))
    blackis1 = CLng(ExtractNextValue("BlackIs1", 0))
    
    height = CLng(ExtractNextValue("Height", 0)) 'not reliable doesnt seem...works for some fails for others...
    
    If use_MuPdf Then
        HandleFaxDecode = mupdf.muCCITTFaxDecode(buf, columns, rows, k, endofline, encodedbytealign, endofblock, blackis1)
    Else
        csharp.SetFaxDecodeParams columns, rows, k, endofline, encodedbytealign, endofblock, blackis1
        If rows = 0 And height > 0 Then
            'sometimes this is required so we will test now
            If Not csharp.decode(buf, CCITTFaxDecode) Then
                csharp.SetFaxDecodeParams columns, height, k, endofline, encodedbytealign, endofblock, blackis1
            End If
        End If
    End If

End Function

Sub ParsePredictor()
    On Error Resume Next
    Dim es As String
    Err.Clear
    
    predictor = ExtractNextValue("Predictor", 0)
    columns = ExtractNextValue("Columns", 1)
    colors = ExtractNextValue("Colors", 1)
    bitspercomponent = ExtractNextValue("BitsPerComponent", 0)
    If bitspercomponent = 0 Then bitspercomponent = ExtractNextValue("BPC", 8)
    
    'If columns = 0 Then columns = 1
    'If colors = 0 Then colors = 1
    'If bitspercomponent = 0 Then bitspercomponent = 8
    
    csharp.SetPredictorParams predictor, columns, colors, bitspercomponent
    
    DebugMsg "Stream: " & parent.Index & " has decode parameters p=" & predictor & " colu=" & columns & " color=" & colors & " bpc=" & bitspercomponent & " err? " & Err.Description
    
    
End Sub
'<<
' /Length 2901
' /Filter [ /ASCIIHexDecode /LZWDecode /ASCII85Decode /RunLengthDecode /FlateDecode ]
'>>
'    /DecodeParms [
'    <<
'        /Predictor 12 /Colors 1 /BitsPerComponent 8 /Columns 1
'    >>
'Fl is enough to declare it as FlateDecode

Sub DetermineFilters(pStream As CPDFStream, escapedHeader As String)

    Dim tmp() As String
    Dim d As Decoders
    
    On Error Resume Next
    
    Set parent = pStream
    
    Erase filters
    UnsupportedFilter = False
    
    'If InStr(1, escapedHeader, "DecodeParms", vbTextCompare) > 0 Then Stop
    
    tmp() = Split(escapedHeader, "/")
    
    For Each x In tmp
        
        d = -1
        
        x = sanitize(x)
        'Debug.Print x
        
        'If InStr(x, "Flate") > 0 Then Stop
        
        Select Case Trim(LCase(x))
            Case LCase("ASCIIHexDecode"): d = AsciiHexDecode
            Case LCase("AHx"): d = AsciiHexDecode   'sample: 2e8a03fc6ca7e0f6016ce26d1197b5ab
            
            Case LCase("LZWDecode"): d = LzwDecode
            Case LCase("LZW"): d = LzwDecode
            
            Case LCase("ASCII85Decode"): d = ASCII85Decode
            Case LCase("A85"): d = ASCII85Decode
            
            Case LCase("RunLengthDecode"): d = RunLengthDecode
            Case LCase("Rl"): d = RunLengthDecode
            
            Case LCase("FlateDecode"): d = FlateDecode
            Case LCase("Fl"): d = FlateDecode       'sample: 2e8a03fc6ca7e0f6016ce26d1197b5ab
            
            Case LCase("DCTDecode"): d = DCTDecode
            Case LCase("DCT"): d = DCTDecode
            
            Case LCase("CCITTFaxDecode"): d = CCITTFaxDecode
            Case LCase("CCF"): d = CCITTFaxDecode
            
            Case LCase("JBIG2Decode"): d = JBIG2Decode
            Case LCase("JPXDecode"): d = JPXDecode
            
            Case LCase("DecodeParms"): hasDecodeParams = True: 'Stop 'final processor
            Case LCase("DP"): hasDecodeParams = True: 'Stop 'final processor
        End Select
        
        If AnyofTheseInstr(x, unsptFilters) Then
            UnsupportedFilter = True
            parent.UsesUnsupportedFilter = True
        End If
        
        If d <> -1 Then push filters, d
        
    Next
        
    If hasDecodeParams Then push filters, DecodePredictor 'set the final filter to apply as decodepredictor
    
    If GetActiveFiltersCount() > 0 Then parent.isCompressed = True
    
End Sub

Function GetActiveFiltersAsString() As String
    
    If GetActiveFiltersCount() = 0 Then Exit Function
    
    Dim x, r() As String
    Dim d As Decoders
    For Each x In filters
        d = x
        If d = ASCII85Decode Then push r, "ASCII85Decode"
        If d = AsciiHexDecode Then push r, "ASCIIHexDecode"
        If d = FlateDecode Then push r, "FlateDecode"
        If d = LzwDecode Then push r, "LzwDecode"
        If d = RunLengthDecode Then push r, "RunLengthDecode"
        If d = DCTDecode Then push r, "DCTDecode"
        If d = CCITTFaxDecode Then push r, "CCITTFaxDecode"
        If d = JBIG2Decode Then push r, "JBIG2Decode"
        If d = JPXDecode Then push r, "JPXDecode"
        If d = DecodePredictor Then push r, "DecodePredictor"
    Next
    
    GetActiveFiltersAsString = Join(r, ",")

    
End Function

Private Function sanitize(ByVal x)
        
    Dim found As Boolean
    found = True
    Do While found
        found = False
        If right(x, 1) = vbCr Then x = stripLastChar(x, found)
        If right(x, 1) = vbLf Then x = stripLastChar(x, found)
        If right(x, 1) = "]" Then x = stripLastChar(x, found)
        If right(x, 1) = "[" Then x = stripLastChar(x, found)
        If right(x, 1) = " " Then x = stripLastChar(x, found)
        If right(x, 1) = ">" Then x = stripLastChar(x, found)
        If right(x, 1) = "<" Then x = stripLastChar(x, found)
        If right(x, 1) = Chr(0) Then x = stripLastChar(x, found)
        If right(x, 1) = vbTab Then x = stripLastChar(x, found)
    Loop
        
    sanitize = x
        
End Function

Private Function stripLastChar(x, ByRef setBool As Boolean)
    On Error Resume Next
    stripLastChar = Mid(x, 1, Len(x) - 1)
    If Err.Number = 0 Then setBool = True
End Function

Private Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init: ReDim ary(0): ary(0) = value
End Sub

Private Function AnyofTheseInstr(data, match, Optional compare As VbCompareMethod = vbTextCompare) As Boolean
    Dim tmp() As String
    Dim x
    tmp = Split(match, ",")
    For Each x In tmp
        If InStr(1, data, x, compare) > 0 Then
            AnyofTheseInstr = True
            Exit Function
        End If
    Next
End Function

Private Function AryIsEmpty(ary) As Boolean
  On Error GoTo oops
    x = UBound(ary)
    AryIsEmpty = False
  Exit Function
oops: AryIsEmpty = True
End Function
