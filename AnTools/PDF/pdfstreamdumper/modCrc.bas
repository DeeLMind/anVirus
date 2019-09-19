Attribute VB_Name = "modCrc"
'author: Steve McMahon
'site:   vbaccelerator.com
'link:   http://www.vbaccelerator.com/home/vb/code/libraries/CRC32/article.asp

Private crc32Table() As Long

Private Sub init()

    ' This is the official polynomial used by CRC32 in PKZip.
    ' Often the polynomial is shown reversed (04C11DB7).
    Dim dwPolynomial As Long
    dwPolynomial = &HEDB88320
    Dim i As Integer, j As Integer

    ReDim crc32Table(256)
    Dim dwCrc As Long

    For i = 0 To 255
        dwCrc = i
        For j = 8 To 1 Step -1
            If (dwCrc And 1) Then
                dwCrc = ((dwCrc And &HFFFFFFFE) \ 2&) And &H7FFFFFFF
                dwCrc = dwCrc Xor dwPolynomial
            Else
                dwCrc = ((dwCrc And &HFFFFFFFE) \ 2&) And &H7FFFFFFF
            End If
        Next j
        crc32Table(i) = dwCrc
    Next i

End Sub

Public Function CRC32(s As String)

    Dim crc32Result As Long
    crc32Result = &HFFFFFFFF
          
    Dim i As Long
    Dim iLookup As Integer
    
    Call init
    
    Dim b() As Byte
    b() = StrConv(s, vbFromUnicode, LANG_US)
    
    For i = 0 To UBound(b)
    
          iLookup = (crc32Result And &HFF) Xor b(i)
          crc32Result = ((crc32Result And &HFFFFFF00) \ &H100) _
              And 16777215 ' nasty shr 8 with vb :/
          crc32Result = crc32Result Xor crc32Table(iLookup)
    
    Next
    
    CRC32 = Not (crc32Result)

End Function




