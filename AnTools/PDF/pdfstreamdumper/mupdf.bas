Attribute VB_Name = "mupdf"
'int __stdcall AsciiHexDecode(char* buf, unsigned char** bufOut)
Private Declare Function AsciiHexDecode Lib "mupdf.dll" (ByRef buf As Byte, ByRef bufOut As Long) As Long

'int __stdcall JBIG2Decode(unsigned char* buf, int sz, unsigned char** bufOut){
Private Declare Function JBIG2Decode_Native Lib "mupdf.dll" Alias "JBIG2Decode" (ByRef buf As Byte, ByVal sz As Long, ByRef bufOut As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
    (ByRef dest As Byte, ByVal src As Long, ByVal Length As Long)

Private Declare Sub FreeBuffer Lib "mupdf.dll" (ByRef handle As Long)

'int __stdcall FaxDecode(unsigned char* buf, int sz, unsigned char** bufOut,
'              int cols=1728, int rows=0, int k=0, int end_of_line=0, int encoded_byte_align=0,
'              int end_of_block=1, int black_is_1=0)
Private Declare Function FaxDecode_Native Lib "mupdf.dll" Alias "FaxDecode" _
        (ByRef buf As Byte, ByVal sz As Long, ByRef bufOut As Long, ByVal cols As Long, ByVal rows As Long, _
        ByVal k As Long, ByVal eol As Long, ByVal eba As Long, ByVal eob As Long, ByVal isblk As Long _
        ) As Long

Function muCCITTFaxDecode(data As String, Optional cols As Long = 1728, Optional rows As Long = 0, _
    Optional k As Long = 0, Optional end_of_line As Long = 0, Optional encoded_byte_align As Long = 0, _
    Optional end_of_block As Long = 1, Optional black_is1 As Long = 0)
    
    Dim pBufOut As Long
    Dim outSize As Long
    Dim bin() As Byte
    Dim b() As Byte
       
    pBufOut = &HDEADBEEF
    bin = StrConv(data, vbFromUnicode, LANG_US)
    outSize = FaxDecode_Native(bin(0), UBound(bin) + 1, pBufOut, cols, rows, k, end_of_line, encoded_byte_align, end_of_block, black_is1)
    
    f = "SizeIn: " & Hex(UBound(bin)) & vbCrLf & _
           "OutSize: " & Hex(outSize) & vbCrLf & _
           "*bufOut: " & Hex(pBufOut) & vbCrLf
           
    'MsgBox f
    
    If outSize = 0 Then Exit Function
   
    ReDim b(outSize - 1) 'zero based
    CopyMemory b(0), pBufOut, outSize
    muCCITTFaxDecode = StrConv(b(), vbUnicode, LANG_US)
    FreeBuffer pBufOut
    
End Function

Function muJBIG2Decode(data As String) As String
    
    Dim pBufOut As Long
    Dim outSize As Long
    Dim bin() As Byte
    Dim b() As Byte
       
    pBufOut = &HDEADBEEF
    bin = StrConv(data, vbFromUnicode, LANG_US)
    outSize = JBIG2Decode_Native(bin(0), UBound(bin) + 1, pBufOut)
    
    f = "SizeIn: " & Hex(UBound(bin)) & vbCrLf & _
           "OutSize: " & Hex(outSize) & vbCrLf & _
           "*bufOut: " & Hex(pBufOut) & vbCrLf
           
    'MsgBox f
    If outSize = 0 Then Exit Function
   
    ReDim b(outSize - 1)
    CopyMemory b(0), pBufOut, outSize
    muJBIG2Decode = StrConv(b(), vbUnicode, LANG_US)
    FreeBuffer pBufOut
    
End Function

Function muAsciiHexDecode(data As String) As String
        
    Dim pBufOut As Long
    Dim outSize As Long
    Dim bin() As Byte
    Dim b() As Byte
       
    pBufOut = &HDEADBEEF
    bin = StrConv(data, vbFromUnicode, LANG_US)
    outSize = AsciiHexDecode(bin(0), pBufOut)
    
    f = "SizeIn: " & Hex(UBound(bin)) & vbCrLf & _
           "OutSize: " & Hex(outSize) & vbCrLf & _
           "*bufOut: " & Hex(pBufOut) & vbCrLf
           
    'MsgBox f
    If outSize = 0 Then Exit Function
   
    ReDim b(outSize - 1)
    CopyMemory b(0), pBufOut, outSize
    muAsciiHexDecode = StrConv(b(), vbUnicode, LANG_US)
    FreeBuffer pBufOut
    
End Function
