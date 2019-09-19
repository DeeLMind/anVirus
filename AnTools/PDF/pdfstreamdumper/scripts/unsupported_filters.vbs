
dim tmp
dim files()
dim findex 
dim scanFor
dim pth

set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

function main()
	
	msgbox "scan all the files in a directory for unsupported filters"  & vbcrlf & "Better to use the Database plugin!"
	
	pth = dlg.FolderDialog()
	if len(pth)=0 then exit function
	
	findex = 0
	if not GetFiles(pth) then 
		MsgBox "no files!"
	else
		LoadNextFile
	end if 
	
end function

'this function is called by the main ui when form1.cmdDecode_Click completes
function Decode_Complete()
	
	for each li in form1.lv2.listitems 'decompression errors listview
	   set stream = li.tag
	   filt = stream.StreamDecompressor.GetActiveFiltersAsString()
	   if stream.StreamDecompressor.DecompressionError then 
	   		filt = "Decomp Error: " & filt & vbtab & " Data Len: 0x" & hex(len(stream.OriginalData))
	   end if 	
	   tmp = tmp & form1.txtPDFPath & " stream " & stream.index & " > " & filt & vbcrlf
	next
	
	LoadNextFile
	
end function

function LoadNextFile()
	
	if findex >= ubound(files) then 
		msgbox "Complete!"
		pth = fso.GetTempName()
    	fso.CreateTextFile(pth).Write tmp
    	wsh.Exec "notepad.exe """ & pth & """"
    	form1.AutomatationRun = false
	else
		form1.txtPDFPath = files(findex)
		findex = findex + 1
		form1.cmdDecode_Click
	end if 
	
end function


function GetFiles(pth) 'as boolean

	Set f = fso.GetFolder(pth)
    
    If f.Files.Count = 0 Then
        GetFiles = false
    Else
        ReDim files(f.Files.Count)
        i = 0
        For Each ff In f.Files
            files(i) = ff.Path
            i = i + 1
        Next
        GetFiles=true
    End If
    
end function


function GetActiveData(ListItem) 'As String
    On Error Resume Next
    Dim s 'As CPDFStream
    Dim d 'As String
    
    Set s = ListItem.Tag
    
    If Len(s.Message) > 0 Then
        d = s.OriginalData
    ElseIf s.ContainsStream Then
        If s.isCompressed Then
            d = s.DecompressedData
        Else
            d = s.OriginalData
        End If
    Else
        d = s.GetHeaderWithViewOptions()
    End If
    
    GetActiveData = d
    
end function