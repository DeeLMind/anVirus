
dim tmp
dim files()
dim findex 
dim scanFor
dim pth

set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

function main()
	
	msgbox "scan all the files in a directory (recusrive) for filter decode chains" & vbcrlf & "Better to use the Database plugin!"
	
	pth = dlg.FolderDialog()
	if len(pth)=0 then exit function
	
	findex = 0
	if not RecursiveGetFiles(pth) then 
		exit function
	else
		LoadNextFile
	end if 
	
end function

'this function is called by the main ui when form1.cmdDecode_Click completes
function Decode_Complete()
	
    'fname = fso.GetFileName(form1.txtPDFPath)
    
	for each li in form1.lv.listitems 'main listview
	   set stream = li.tag
	   if stream.ContainsStream then 
	   		if  stream.StreamDecompressor.GetActiveFiltersCount > 1 then 
	   			   filt = stream.StreamDecompressor.GetActiveFiltersAsString()
				   if stream.StreamDecompressor.DecompressionError then 
				   		filt = filt & vbtab & "Error: True"
				   end if 	
	   			   tmp = tmp & form1.txtPDFPath & vbcrlf & vbtab & "stream " & stream.index & " > " & filt & vbcrlf
	   		end if 
	   	end if 
	next
	
	for each li in form1.lv2.listitems 'decompression errors listview
	   set stream = li.tag
	   if stream.ContainsStream then 
	   		if  stream.StreamDecompressor.GetActiveFiltersCount > 1 then 
	   			   filt = stream.StreamDecompressor.GetActiveFiltersAsString()
				   if stream.StreamDecompressor.DecompressionError then 
				   		filt = filt & vbtab & "Error: True"
				   end if 	
	   			   tmp = tmp & form1.txtPDFPath & vbcrlf & vbtab & "stream " & stream.index & " > " & filt & vbcrlf
	   		end if 
	   	end if 
	next
	
	LoadNextFile
	
end function

function LoadNextFile()
	
	if findex >= ubound(files) then 
		msgbox "Complete!"
		pth = fso.GetTempName()
    	fso.CreateTextFile(pth).Write tmp
    	wsh.Exec "notepad.exe """ & pth & """"
    	'fso.DeleteFile(pth)
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

function RecursiveGetFiles(pth)

	dim tmp,ret,cnt
	
	if len(pth)=0 then exit function
	
	output = wsh.exec("cmd /c dir /s/b """ & pth & """").StdOut.ReadAll()
	'msgbox output
	
	tmp = split(output,vbcrlf)
	i=0
	for each x in tmp
		if instr(1,x,".pdf",vbTextCompare) > 0 then 
			redim preserve files(i)
			files(i) = x
			i = i + 1
		end if 
	next
	
	on error resume next	
	cnt = ubound(files) 
	if len(cnt)= 0 then cnt = 0
	
	if cnt = 0 then 
		msgbox "0 files with pdf extension under this parent folder: " & pth
	else
		msgbox "Found " & cnt & " files"
		RecursiveGetFiles = true
	end if 
	
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