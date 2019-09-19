Attribute VB_Name = "b64"
'base for this was taken from PSC
'http://www.pscode.com/xq/ASP/txtCodeId.3600/lngWId.1/qx/vb/scripts/ShowCode.htm
'and encode routine from
'http://pscode.com/xq/ASP/txtCodeId.4174/lngWId.1/qx/vb/scripts/ShowCode.htm
'which in turn was based on fx from Sebastian...true power of open source :)
'
'the only thing mine in here is the span function and the macros at
'the bottom to wrap up all the lose ends and just give you a wrapper
'
'if you forget to call InitAlpha in your form_load dont worry i built
'in a fool proof so it will do it automatically when you try to encode
'or b64Decode...because i am quite often a fool :Þ

Private Base64Tab(63) As Byte
Private b64DecodeTable(233) As Byte
Private Initalized As Boolean

Public Sub InitAlpha()
    'Base64 Alphabet
    '1-25 --> A-Z, 26-51 --> a-z, 52-61 --> 0-9,
    '62 = "+", '63 = "/" , '64 = "=" 'since orig val mod 3 must =0 these are the pads
    Dim tb64DecodeTable As Variant
    tb64DecodeTable = Array("255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "62", "255", "255", "255", "63", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "255", "255", "255", "64", "255", "255", "255", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", _
        "18", "19", "20", "21", "22", "23", "24", "25", "255", "255", "255", "255", "255", "255", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255" _
        , "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255", "255")
    For i = LBound(tb64DecodeTable) To UBound(tb64DecodeTable)
        b64DecodeTable(i) = tb64DecodeTable(i)
    Next
    For i = 65 To 90
        Base64Tab(i - 65) = i
    Next
    For i = 97 To 122
        Base64Tab(i - 71) = i
    Next
    For i = 0 To 9
        Base64Tab(i + 52) = 48 + i
    Next
    Base64Tab(62) = 43
    Base64Tab(63) = 47
    Initalized = True
End Sub

Public Sub Encode(ByRef DataIn() As Byte, ByRef DataOut() As Byte)

  Dim DataTemp(2) As Byte
  Dim iTemp As Long
  Dim iLoop As Long
  Dim BytesDataIn As Long
  Dim BytesDataOut As Long
  Dim ExtraBytes As Integer
  
  If Not Initalized Then Call InitAlpha
  
  BytesDataIn = UBound(DataIn) + 1 'length of the string
  ExtraBytes = (BytesDataIn Mod 3)
  If ExtraBytes = 0 Then
      BytesDataOut = ((BytesDataIn / 3) * 4)  ' how many bytes will the encoded string have
  Else
      BytesDataOut = (((BytesDataIn \ 3) + 1) * 4) ' how many bytes will the encoded string have
  End If
  
  ReDim DataOut(BytesDataOut - 1)
  
  For iLoop = 0 To BytesDataIn - ExtraBytes - 1 Step 3
      DataOut(iTemp) = Base64Tab((DataIn(iLoop) \ 4) And &H3F)
      DataOut(iTemp + 1) = Base64Tab((DataIn(iLoop) And &H3) * 16 Or (DataIn(iLoop + 1) \ 16) And &HF)
      DataOut(iTemp + 2) = Base64Tab((DataIn(iLoop + 1) And &HF) * 4 Or (DataIn(iLoop + 2) \ 64) And &H3)
      DataOut(iTemp + 3) = Base64Tab(DataIn(iLoop + 2) And &H3F)
      iTemp = iTemp + 4
  Next
  If ExtraBytes = 1 Then ' if there is 1 byte remaining
      'read 1 byte, the second in 0
      DataTemp(0) = DataIn(UBound(DataIn))
      DataTemp(1) = 0
      DataTemp(2) = 0
      DataOut(UBound(DataOut) - 3) = Base64Tab((DataTemp(0) \ 4) And &H3F)
      DataOut(UBound(DataOut) - 2) = Base64Tab((DataTemp(0) And &H3) * 16 Or (DataTemp(1) \ 16) And &HF)
      DataOut(UBound(DataOut) - 1) = 61
      DataOut(UBound(DataOut)) = 61
  ElseIf ExtraBytes = 2 Then 'if there are 2 bytes remaining
      'read 2 bytes, the third is 0
      DataTemp(0) = DataIn(UBound(DataIn) - 1)
      DataTemp(1) = DataIn(UBound(DataIn))
      DataTemp(2) = 0
      DataOut(UBound(DataOut) - 3) = Base64Tab((DataTemp(0) \ 4) And &H3F)
      DataOut(UBound(DataOut) - 2) = Base64Tab((DataTemp(0) And &H3) * 16 Or (DataTemp(1) \ 16) And &HF)
      DataOut(UBound(DataOut) - 1) = Base64Tab((DataTemp(1) And &HF) * 4 Or (DataTemp(2) \ 64) And &H3)
      DataOut(UBound(DataOut)) = 61
  End If

End Sub


Public Sub b64Decode(ByRef FileIn() As Byte, ByRef out() As Byte)
    Dim inp(3) As Byte
    
    If Not Initalized Then Call InitAlpha
    
    While (UBound(FileIn) + 1) Mod 4 <> 0 'some clients don't ad = pads!!
        ReDim Preserve FileIn(UBound(FileIn) + 1)
        FileIn(UBound(FileIn)) = CByte(Asc("="))
        MsgBox "pad forced up"
        'this loop may occur a maxium of twice
    Wend
        
    If FileIn(UBound(FileIn) - 1) = Asc("=") Then
        pad = 2
    ElseIf FileIn(UBound(FileIn)) = Asc("=") Then
        pad = 1
    Else
        pad = 0
    End If

    'MsgBox pad
    
    Lenght = UBound(FileIn) ' + 1    'lenght of the string
    BytesOut = ((Lenght / 4) * 3) - pad ' how many bytes will the b64Decoded string have
    ReDim out(BytesOut)

    For i = 0 To Lenght Step 4
        inp(0) = b64DecodeTable(FileIn(i))
        inp(1) = b64DecodeTable(FileIn(i + 1))
        inp(2) = b64DecodeTable(FileIn(i + 2))
        inp(3) = b64DecodeTable(FileIn(i + 3))
        If inp(3) = 64 Or inp(2) = 64 Then
            If inp(3) = 64 And Not (inp(2) = 64) Then
                inp(0) = b64DecodeTable(FileIn(i))
                inp(1) = b64DecodeTable(FileIn(i + 1))
                inp(2) = b64DecodeTable(FileIn(i + 2))
                '2 bytes out
                out(iTemp) = (inp(0) * 4) Or ((inp(1) \ 16) And &H3)
                out(iTemp + 1) = ((inp(1) And &HF) * 16) Or ((inp(2) \ 4) And &HF)
                Exit Sub
            ElseIf inp(2) = 64 Then
                inp(0) = b64DecodeTable(FileIn(i))
                inp(1) = b64DecodeTable(FileIn(i + 1))
                '1 byte out
                out(iTemp) = (inp(0) * 4) Or ((inp(1) \ 16) And &H3)
                Exit Sub
            End If
        End If
        '3 bytes out
        out(iTemp) = (inp(0) * 4) Or ((inp(1) \ 16) And &H3)
        out(iTemp + 1) = ((inp(1) And &HF) * 16) Or ((inp(2) \ 4) And &HF)
        out(iTemp + 2) = ((inp(2) And &H3) * 64) Or inp(3)
        iTemp = iTemp + 3
    Next
    
End Sub

Public Function Span(inAry() As Byte, Optional CharsPerLine = 72) As Byte()
        
    If UBound(inAry) > CharsPerLine Then
        Dim ret() As Byte: x = 0: cpl = 0
        While x <= UBound(inAry)
            If cpl < CharsPerLine Then
                If x = 0 Then ReDim ret(0) _
                Else ReDim Preserve ret(UBound(ret) + 1)
                ret(UBound(ret)) = inAry(x)
                cpl = cpl + 1
                x = x + 1
            ElseIf cpl = CharsPerLine Then
                ReDim Preserve ret(UBound(ret) + 2)
                ret(UBound(ret) - 1) = CByte(13)
                ret(UBound(ret)) = CByte(10)
                cpl = 0
            End If
        Wend
        
        Span = ret()
    Else
        Span = inAry()
    End If
        
End Function

Public Function Unspan(it As String) As String
    Unspan = Replace(it, vbCrLf, "")
End Function

Public Sub Str2ByteArray(StringIn As String, ByteArray() As Byte)
    ByteArray = StrConv(StringIn, vbFromUnicode)
End Sub

Function ByteArrayToString(ByRef pbArrayInput() As Byte) As String
   ByteArrayToString = StrConv(pbArrayInput, vbUnicode)
End Function

Function String2StrAry(it) As String()
    Dim s() As String, bAry() As Byte
    b64.Str2ByteArray CStr(it), bAry()
    ReDim s(UBound(bAry))
    For i = 0 To UBound(bAry)
        s(i) = Chr(bAry(i))
    Next
    String2StrAry = s()
End Function

Public Sub LoadFile(fpath, ByRef out() As Byte)
  
   fSize = FileLen(fpath) - 1
   f = FreeFile
   ReDim out(fSize)
   
   Open fpath For Binary As f
   Get f, , out()
   Close f

End Sub

Private Sub writeFile(fpath, bAry() As Byte)
    f = FreeFile
    Open fpath For Binary As f
    Put f, , bAry()
    Close f
End Sub

Function b64DecodeString(mimedata) As String
   Dim b() As Byte, b2() As Byte, tmp As String
   mimedata = Replace(mimedata, vbCr, "")
   mimedata = Replace(mimedata, vbLf, "")
   b64.Str2ByteArray CStr(mimedata), b()
   b64.b64Decode b(), b2()
   b64DecodeString = b64.ByteArrayToString(b2())
End Function

Function EncodeString(it As String) As String
   Dim b() As Byte, b1() As Byte
   b64.Str2ByteArray it, b()
   b64.Encode b(), b1()
   EncodeString = ByteArrayToString(Span(b1))
End Function
   
Function MimeFileToString(fpath) As String
   Dim b() As Byte, b2() As Byte
   b64.LoadFile CStr(fpath), b()
   b64.Encode b(), b2()
   MimeFileToString = ByteArrayToString(Span(b2))
End Function

Sub MimeFileToFile(fpath, saveAsPath)
   Dim b() As Byte, b2() As Byte
   b64.LoadFile CStr(fpath), b()
   b64.Encode b(), b2()
   writeFile saveAsPath, Span(b2)
End Sub

Sub UnMimeStringToFile(fpath, mimedata)
    Dim b() As Byte, b2() As Byte
    mimedata = Replace(mimedata, vbCr, "")
    mimedata = Replace(mimedata, vbLf, "")
    b64.Str2ByteArray CStr(mimedata), b()
    b64.b64Decode b(), b2()
    b64.writeFile CStr(fpath), b2()
End Sub

Sub UnMimeFileToFile(infile, outfile)
    Dim b() As Byte, b2() As Byte, tmp As String
    b64.LoadFile infile, b()
    tmp = b64.ByteArrayToString(b)
    tmp = b64.Unspan(tmp)
    b64.Str2ByteArray tmp, b()
    b64.b64Decode b(), b2()
    b64.writeFile outfile, b2()
End Sub



Function CountOccurances(it, find) As Integer
    Dim tmp() As String
    If InStr(1, it, find, vbTextCompare) < 1 Then CountOccurances = 0: Exit Function
    tmp = Split(it, find, , vbTextCompare)
    CountOccurances = UBound(tmp)
End Function
