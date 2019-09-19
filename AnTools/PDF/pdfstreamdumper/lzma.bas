Attribute VB_Name = "lzma"
'The LZMA header format Flash authoring uses does not match the header
'7z format uses. You can convert the SWF file in the LZMA format into
'the 7z LZMA format by updating the header.
'
'SWF file LZMA header
'
'bytes
'0-3: ZWS+version bytes
'4-7: Uncompressed length (includes ZWS+version (4 bytes) and uncompressed length (4 bytes))
'8-11: Compressed length bytes
'12-16: LZMAproperties bytes
'17-n: Compressed data
'
'7z LZMA header
'
'bytes
'0-4: LZMA properties bytes
'5-12: Uncompressed length (take the swf lzma length - 8 (don't include ZWS+version + uncompressed length)) bytes
'13-n: Compressed data



'https://github.com/claus/as3swf/pull/23#issuecomment-7203861
'For the record:
'
'The uncompressed part of a compressed SWF is always (first 8 bytes):
'bytes 0-3: CWS/ZWS + version
'bytes 4 - 7: Uncompressed Size
'
'What follows is compressed data until end of file.
'
'A LZMA compressed SWF looks like this (example):
'
'0000 5A 57 53 0F   // ZWS + Version 15
'0004 DF 52 00 00   // Uncompressed size: 21215
'// ZWS-specific:
'0008 94 3B 00 00   // Compressed size: 15252
'000C 5D 00 00 00 01   // LZMA Properties
'0011 00 3B FF FC A6 14 16 5A ...   // LZMA Compressed Data (until EOF)
'
'To convert the compressed data into something that can be uncompressed by ByteArray.uncompress (7z), the compressed size has to be thrown away, and the uncompressed size (padded to 64 bits) has to be injected
'after the LZMA properties.
'
'As the uncompressed size in SWF refers to the size of the entire SWF (including the uncompressed header of 8
'bytes), but uncompressed size in the LZMA header refers to only the LZMA data, we need to subtract 8.
'
'0000 5D 00 00 00 01   // LZMA Properties
'0005 D7 52 00 00 00 00 00 00   // Uncompressed size: 21207 (64 bit)
'000D 00 3B FF FC A6 14 16 5A ...   // LZMA Compressed Data (until EOF)
'

'5A57530FDF520000943B00005D00000001003BFFFCA614165A

'http://support.microsoft.com/default.aspx?kbid=129796
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hWnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Const SW_HIDE = 0
Private Const SW_SHOWNORMAL = 1

Private Type swf_header
    magic(1 To 4) As Byte
    ulen As Long
    clen As Long
    lzmaProps(1 To 5) As Byte
End Type

Private Type lzma_header
    lzmaProps(1 To 5) As Byte
    ulen_lo As Long  '64bit
    ulen_hi As Long
End Type

Private Type STARTUPINFO
      cb As Long
      lpReserved As String
      lpDesktop As String
      lpTitle As String
      dwX As Long
      dwY As Long
      dwXSize As Long
      dwYSize As Long
      dwXCountChars As Long
      dwYCountChars As Long
      dwFillAttribute As Long
      dwFlags As Long
      wShowWindow As Integer
      cbReserved2 As Integer
      lpReserved2 As Long
      hStdInput As Long
      hStdOutput As Long
      hStdError As Long
   End Type

   Private Type PROCESS_INFORMATION
      hProcess As Long
      hThread As Long
      dwProcessID As Long
      dwThreadID As Long
   End Type

   Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal _
      hHandle As Long, ByVal dwMilliseconds As Long) As Long

   Private Declare Function CreateProcessA Lib "kernel32" (ByVal _
      lpApplicationName As String, ByVal lpCommandLine As String, ByVal _
      lpProcessAttributes As Long, ByVal lpThreadAttributes As Long, _
      ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, _
      ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As String, _
      lpStartupInfo As STARTUPINFO, lpProcessInformation As _
      PROCESS_INFORMATION) As Long
      
Private Declare Function CloseHandle Lib "kernel32" _
      (ByVal hObject As Long) As Long

   Private Declare Function GetExitCodeProcess Lib "kernel32" _
      (ByVal hProcess As Long, lpExitCode As Long) As Long

   Private Const NORMAL_PRIORITY_CLASS = &H20&
   Private Const INFINITE = -1&

   Public Function ShellnWait(cmdline$)
      Dim proc As PROCESS_INFORMATION
      Dim start As STARTUPINFO

      ' Initialize the STARTUPINFO structure:
      start.cb = Len(start)

      ' Start the shelled application:
      ret& = CreateProcessA(vbNullString, cmdline$, 0&, 0&, 1&, _
         NORMAL_PRIORITY_CLASS, 0&, vbNullString, start, proc)

      ' Wait for the shelled application to finish:
         ret& = WaitForSingleObject(proc.hProcess, INFINITE)
         Call GetExitCodeProcess(proc.hProcess, ret&)
         Call CloseHandle(proc.hThread)
         Call CloseHandle(proc.hProcess)
         ShellnWait = ret&
         
   End Function

Function flash_decompress_zws(infile As String, Optional outfile As String, Optional savetmp As Boolean = False) As String
    
    Dim swf As swf_header
    Dim lzma As lzma_header
    Dim data() As Byte
    Dim f As Long
    Dim pf As String
    Dim raw As String
    Dim dec As String
    Dim done As String
    Dim decomp As String
    Dim r() As String
    Dim result As Long
    
    decomp = App.path & "\lzma.exe"
    
    If Not fso.FileExists(decomp) Then
        flash_decompress_zws = "lzma.exe not found in app.path"
        Exit Function
    End If
    
    decomp = GetShortName(decomp)
    
    If Not fso.FileExists(infile) Then
        flash_decompress_zws = "input file not found"
        Exit Function
    End If
    
    pf = fso.GetParentFolder(infile) & "\"
    pf = GetShortName(pf)
    f = FreeFile
     
    Open infile For Binary As f
    Get f, , swf
    ReDim data(1 To swf.clen)
    Get f, , data()
    Close f
    
    If swf.magic(1) <> Asc("Z") Then
        flash_decompress_zws = "Does not look like a ZWS file..."
        Exit Function
    End If
    
    push r, "swf ulen: " & Hex(swf.ulen)
    push r, "swf clen: " & Hex(swf.clen)
    
    For i = 1 To UBound(lzma.lzmaProps)
        lzma.lzmaProps(i) = swf.lzmaProps(i)
    Next
    
    lzma.ulen_lo = swf.ulen - 8
    lzma.ulen_hi = 0
    push r, "lzma.ulen: " & Hex(lzma.ulen_lo)
    
    If savetmp Then push r, "Saving output files to " & pf
    
    raw = pf & "\lzma.dat"
    dec = pf & "\rawdec.dat"
    final = IIf(Len(outfile) = 0, infile & ".decomp", outfile)
    
    On Error Resume Next
    Kill raw
    Kill dec
    Kill final
    
    f = FreeFile
    Open raw For Binary As f
    Put f, , lzma
    Put f, , data()
    Close f
    
    'Dim c As New CCmdOutput
    'output = c.GetCommandOutput(decomp & " d " & raw & " " & dec, True, True)
    'push r, output
    'If InStr(1, output, "error", vbTextCompare) > 0 Then Exit Sub

    'result = ShellExecute(Form1.hWnd, "open", decomp, " d " & raw & " " & dec, App.path, SW_HIDE)
'    If result <= 32 Then
'        flash_decompress_zws = "Failed to run lzma.exe"
'        Exit Function
'    End If
'    needs delay until pid ends..
    
    result = ShellnWait(decomp & " d " & raw & " " & dec)

    If FileLen(dec) = 0 Then
        flash_decompress_zws = "Decompression failed.."
        Kill dec
        Exit Function
    End If
    
    f = FreeFile
    Open dec For Binary As f
    ReDim data(LOF(f) - 1)
    Get f, , data()
    Close f
    
    push r, "Actual ulen: " & Hex(UBound(data) + 1)
    
    f = FreeFile
    Open final For Binary As f
    Put f, , "FWS"
    Put f, , swf.magic(4) 'version
    Put f, , CLng(UBound(data))
    Put f, , data()
    Close f

    If Not savetmp Then
        Kill raw
        Kill dec
    End If
    
    push r, vbCrLf & "Saved as: " & final
    flash_decompress_zws = Join(r, vbCrLf)
 
End Function





 


