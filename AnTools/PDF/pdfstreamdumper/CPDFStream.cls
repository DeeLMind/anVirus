VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CPDFStream"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Author:   dzzie@yahoo.com
'Site:    http://sandsprite.com

Option Explicit

Public Enum ObjType
    Unknown = 0
    Flash = 1
    U3d = 2
    TTFFont = 3
    prc = 4
    xml = 5
End Enum
    
Public Index As Long
Public Header As String
Public escapedHeader As String
Public isBinary As Boolean

Public ObjectStartOffset As Long
Public ObjectEndOffset As Long

Public ContainsStream As Boolean
Public isCompressed As Boolean
'Public isASCIIHexDecode As Boolean

'theses are related to streams
Public startOffset As Long
Public EndOffset As Long

Public CompressedSize As Long
Public DecompressedSize As Long

'these next three can be large memory hogs...malware is usually small though - should we cache to disk if size > xx?
Public RawObject As String        'set in CPdfParser
Public OriginalData As String     'set internally, and/or in CPdfParser
Public DecompressedData As String 'set in CApplyFilters

Public OriginalDataCRC As String
Public DecompressedDataCRC As String
Public HeaderCRC As String

Public ContentType As ObjType
Public UsesUnsupportedFilter As Boolean
Public Message As String
Public FileExtension As String
Public FileType As String

Public StreamDecompressor As New CApplyFilters

'Private Const unsptFilters = "ASCII85Decode,LZWDecode,RunLengthDecode,DCTDecode,CCITTFaxDecode,JBIG2Decode,JPXDecode"

Private Function FindHeaderEnd(ByVal hstart) As Long

    On Error Resume Next
    Dim hend As Long
    Dim tmp As String
    Dim nested As Long
    Dim level As Long
    Dim c As Long
    
    'If Index = 112 Then Stop
    
    'this is some ugly ass logic...just retooled it some 1.3.12
    'but its still really bad...seems to work though
    
    hstart = hstart + 2
    
    Do While 1
    
tryAgain:
        hend = InStr(hstart, RawObject, ">>")
        
        If hend < 1 Then Exit Do
         
        If hend - hstart = 0 Then 'there was a >>>>
            hstart = hend + 2
            If nested = 0 Then
                Exit Do
            Else
                nested = nested - 1
            End If
            GoTo tryAgain
        End If
        
        tmp = Mid(RawObject, hstart, hend - hstart)
        
        If Len(tmp) = 0 Then Exit Do
        If Err.Number <> 0 Then Exit Do
        
        If InStr(1, tmp, "<<") > 1 Then 'a nested tag was found
            c = GetCount(tmp, "<<")  'maybe multiple...
            If c > 2 Then nested = nested + c - 2
            hstart = hend + 2
        Else
            If nested = 0 Then
                Exit Do  'no more nested tags found were at end
            Else
                nested = nested - 1
                hstart = hend + 2
            End If
        End If
        
    Loop
    
    FindHeaderEnd = hend
    
End Function

Function ParseSelf()
    
    'works off of the rawobject
    '6 0 obj
        '<</Filter /FlateDecode /Length 314>>stream____endstream
    'endobj
    
    'Filters can also support multiple encodings sequentially
    '/Filter [ /ASCIIHexDecode /LZWDecode /ASCII85Decode /RunLengthDecode /FlateDecode ]
    'apparently filters also support abbreviations...Fl is known to work as FlateDecode...
    
    Dim hstart As Long
    Dim hend As Long
    Dim sStart As Long
    Dim sEnd As Long
    Dim tmp As String
    Dim activeData As String
    Dim a, b
    
    hstart = InStr(RawObject, "<<") 'do we need to count the nesting? they can be...
    'hend = InStrRev(RawObject, ">>") '<--problem if embedded data contains >> (does happen)...
    'sStart = InStr(1, RawObject, "stream", vbTextCompare)
    'sEnd = InStr(1, RawObject, "endstream", vbTextCompare)
    
    'possible failure octet-stream>>stream

    'if there is a header an a stream, make sure stream start marker is after
        
    'If sStart > 0 Then 'it has a stream we may need to adjust our default hend
    '    If hstart > 0 And hend > sStart Then 'why yes we do
    '        tmp = Mid(RawObject, 1, sStart)
    '        hend = InStrRev(tmp, ">>")  'dirty fix but should be good enough?
    '        DebugMsg "Stream: " & Index & " Adjusting hend to " & hend
    '    End If
    'End If
    
    If hstart > 0 Then hend = FindHeaderEnd(hstart)
    sStart = InStr(IIf(hend > 0, hend, 1), RawObject, "stream", vbTextCompare)
    sEnd = InStr(IIf(sStart > 0, sStart, 1), RawObject, "endstream", vbTextCompare)
    
    
    
    If hstart > 0 And hend > hstart Then
        Header = Mid(RawObject, hstart, hend - hstart + Len(">>"))
        'Header = Replace(Header, Chr(0), "_Chr(0)_")
        Header = Replace(Header, Chr(0), Empty)
        Header = Replace(Header, "þÿ", Empty)
        HeaderCRC = CRC32(Header)
        
        escapedHeader = EscapeHeader(Header)
        StreamDecompressor.DetermineFilters Me, escapedHeader
    Else
    
        'need to handle stuff like: obj[/ICCBased 119 0 R]
        If Len(RawObject) > 4 Then
            If sStart > 0 Then hend = sStart Else hend = Len(RawObject)
            If hend > 0 Then
                Header = Mid(RawObject, 4, hend)
                Header = Replace(Header, Chr(0), Empty)
                Header = Replace(Header, "þÿ", Empty)
                HeaderCRC = CRC32(Header)
                escapedHeader = EscapeHeader(Header)
            End If
        End If
    
    End If
    
    If sStart > 0 And sEnd > sStart Then
        ContainsStream = True
        sStart = sStart + Len("stream")
        
        startOffset = ObjectStartOffset + sStart - 1
        EndOffset = ObjectStartOffset + sEnd - 1
        
        OriginalData = MyTrim(Mid(RawObject, sStart, sEnd - sStart))
        CompressedSize = Len(OriginalData)
        OriginalDataCRC = CRC32(OriginalData)
        
        If isCompressed Then StreamDecompressor.ApplyFilters
                
        'If InStr(1, RawObject, "DCTDecode", vbTextCompare) Then Stop
        
        If isCompressed And StreamDecompressor.UnsupportedFilter = False _
            And StreamDecompressor.DecompressionError = False And DecompressedSize > 0 Then
                activeData = DecompressedData
                DecompressedDataCRC = CRC32(DecompressedData)
        Else
            activeData = OriginalData
        End If
        
        If StreamDecompressor.DecompressionError = True Then
            Me.Message = StreamDecompressor.DecompErrorMessage
        ElseIf StreamDecompressor.UnsupportedFilter Then
            Me.Message = "Uses unsupported filter " & StreamDecompressor.GetActiveFiltersAsString
        End If
        
        SetContentType activeData
    
    End If
    
    Dim xx As String
    xx = Mid(activeData, 1, 20)
    If InStr(1, xx, Chr(0)) > 0 Then isBinary = True
            
End Function

Private Sub SetContentType(ad)
    
    If VBA.left(ad, 3) = "CWS" Then
        ContentType = Flash
        FileExtension = ".swf"
        FileType = "Flash File"
    ElseIf VBA.left(ad, 3) = "FWS" Then
        ContentType = Flash
        FileExtension = ".swf"
        FileType = "Flash File"
    ElseIf VBA.left(ad, 3) = "U3D" Then
        ContentType = U3d
        FileExtension = ".u3d"
        FileType = "U3d File"
    ElseIf VBA.left(ad, 3) = "PRC" Then
        ContentType = prc
        FileExtension = ".prc"
        FileType = "PRC File"
    ElseIf InStr(1, ad, "maxp", vbTextCompare) > 0 Then
        ContentType = TTFFont
        FileExtension = ".ttf"
        FileType = "Font File"
    ElseIf InStr(1, ad, "glyf", vbTextCompare) > 0 Then
        ContentType = TTFFont
        FileExtension = ".ttf"
        FileType = "Font File"
    ElseIf InStr(1, ad, "xmlns:", vbTextCompare) > 0 Then
        ContentType = xml
        FileExtension = ".xml"
        FileType = "Xml Data"
    End If
    
End Sub



Private Function MyTrim(strin As String)
        
        On Error Resume Next
        Dim s As String
        
        s = strin
        
        While right(s, 1) = Chr(&HD) Or right(s, 1) = Chr(&HA)
            s = Mid(s, 1, Len(s) - 1)
            EndOffset = EndOffset - 1
        Wend
        
        While VBA.left(s, 1) = Chr(&HD) Or left(s, 1) = Chr(&HA)
            s = Mid(s, 2)
            startOffset = startOffset + 1
        Wend
        
        MyTrim = s
        
End Function

Private Function lpad(s, minLen) As String
    Dim l As Long
    l = InStr(s, ":")
    If l < minLen Then
        lpad = Space(minLen - l) & s
    Else
        lpad = s
    End If
End Function

Function GetHeaderWithViewOptions() As String
    
    If Form1.mnuAutoEscapeHeaders.Checked Then
        If Form1.mnuVisualFormatHeaders.Checked Then
            GetHeaderWithViewOptions = VisualFormatHeader(escapedHeader)
        Else
            GetHeaderWithViewOptions = escapedHeader
        End If
    ElseIf Form1.mnuVisualFormatHeaders.Checked Then
        GetHeaderWithViewOptions = VisualFormatHeader(Me.Header)
    Else
        GetHeaderWithViewOptions = Me.Header
    End If
    
End Function

Function GetDetailsReport()
    Dim r() As String
    Const sz = 22
    
    On Error Resume Next
    
    push r, lpad("Object Index: ", sz) & Index
    push r, lpad("Object Start Offset: 0x", sz) & Hex(ObjectStartOffset) & "  (" & ObjectStartOffset & ")"
    push r, lpad("Object End Offset: 0x", sz) & Hex(ObjectEndOffset) & "  (" & ObjectEndOffset & ")"

    If Me.ContainsStream Then
        
        push r, lpad("Stream Start Offset: 0x", sz) & Hex(startOffset) & "  (" & startOffset & ")"
        push r, lpad("Stream End Offset: 0x", sz) & Hex(EndOffset) & "  (" & EndOffset & ")"
        
        If Me.isCompressed Then
                push r, lpad("Compressed Size: 0x", sz) & Hex(CompressedSize) & " (" & CompressedSize & ")"
                push r, lpad("Compressed CRC: 0x", sz) & Hex(CRC32(Me.OriginalData))
                push r, lpad("DecompFilters: ", sz) & StreamDecompressor.GetActiveFiltersAsString()
                push r, lpad("Unsupported Filters?: ", sz) & StreamDecompressor.UnsupportedFilter
                'push r, lpad("iText Decompressors?: ", sz) & csharp.Initilized
                
                If StreamDecompressor.DecompressionError = True Then
                    push r, lpad("Decompress Error: ", sz) & StreamDecompressor.DecompErrorMessage
                Else
                    If Not StreamDecompressor.UnsupportedFilter Then
                        push r, lpad("DeCompressed Size: 0x", sz) & Hex(DecompressedSize) & " (" & DecompressedSize & ")"
                    End If
                    push r, lpad("DeCompressed CRC: 0x", sz) & Hex(CRC32(Me.DecompressedData))
                    push r, lpad("Expansion Ratio: ", sz) & Round((DecompressedSize / CompressedSize), 2) & "x  (" & DecompressedSize - CompressedSize & " bytes)"
                End If
        Else
            push r, lpad("Raw Data Size: 0x", sz) & Hex(Me.CompressedSize)
            push r, lpad("CRC32: 0x", sz) & Hex(CRC32(Me.OriginalData))
        End If
    
    End If
    
    push r, lpad("Detected Type:", sz) & FileExtension
    
    If Len(Message) > 0 Then push r, lpad("Message: ", sz) & Message
     
    push r, lpad("HeaderCRC: ", sz) & Hex(Me.HeaderCRC)
    push r, lpad("Header: ", sz) & vbCrLf & vbCrLf & GetHeaderWithViewOptions()
    
    GetDetailsReport = Join(r, vbCrLf)
    
End Function

Private Sub Class_Initialize()
    FileExtension = ".unk"
    FileType = "Unknown"
End Sub
