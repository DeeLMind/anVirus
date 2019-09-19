
dim tmp
dim files()
dim findex 
dim scanFor
dim pth
dim logfile 'as textstream
dim cnt
dim curPathLogged 'as boolean

set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

function main()
	
	msgbox "scan all the files in a directory (recusrive) for what it thinks look like obsfuscated pdf headers"  & vbcrlf & "Better to use the Database plugin!"
	
	pth = dlg.FolderDialog()
	if len(pth)=0 then exit function
	
	findex = 0
	if not RecursiveGetFiles(pth) then 
		exit function
	else
		pth = fso.GetTempName()
		set logfile = fso.CreateTextFile(pth)
		LoadNextFile
	end if 
	
end function

'this function is called by the main ui when form1.cmdDecode_Click completes
function Decode_Complete()
	    
	for each li in form1.lv.listitems 'main listview
	   set stream = li.tag
	   'if stream.Header <> stream.escapedHeader then 'to many have <> hex data in them normally
	   if looksEscaped(stream.Header) then 
	   			if not curPathLogged then 
	   				logfile.WriteLine form1.txtPDFPath
	   				curPathLogged = true
	   			end if 
	   			logfile.WriteLine vbtab & "stream " & stream.index  
	   			cnt = cnt + 1
       end if 
	next
	
	for each li in form1.lv2.listitems 'decompression errors listview
	   set stream = li.tag
	   if looksEscaped(stream.Header) then 
	   			if not curPathLogged then 
	   				logfile.WriteLine form1.txtPDFPath
	   				curPathLogged = true
	   			end if 
	   			logfile.WriteLine vbtab & "stream " & stream.index  
	   			cnt = cnt + 1
       end if 
	next
	
	LoadNextFile
	
end function

function looksEscaped(header) 'as boolean
	
    header = replace(header,"#20"," ") 'to common to include with low threshold
	if GetCount(header,"#") > 2 then looksEscaped = true
	if GetCount(header,"\" & vbcrlf) > 1 then looksEscaped = true	
	if GetCount(header,"\1") > 2 then looksEscaped = true	

end function

function GetCount(str,what) 'as long
	on error resume next
	GetCount = ubound(split(str,what))+1
	if len(GetCount) = 0 then GetCount = 0
end function

function LoadNextFile()
	
	if findex >= ubound(files) then 
		if cnt > 0 then 
			msgbox "Complete! " & cnt & " results found"
		   	wsh.Exec "notepad.exe """ & pth & """"
	    else
	    	msgbox "No results found"
		end if 
		form1.AutomatationRun = false	    	
	else
		if curPathLogged = true then logfile.WriteLine ""	'there was output from last one write spacer
		curPathLogged = false
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