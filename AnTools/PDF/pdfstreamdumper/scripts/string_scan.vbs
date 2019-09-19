
dim tmp
dim files()
dim findex 
dim scanFor
dim pth

'const vbTextCompare = 1

set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

function main()
	
	msgbox "scan all the files in a directory for a specific strings in decompressed streams"  & vbcrlf & "Better to use the Database plugin!"

	lst = "1 - rep(count,what)" & vbcrlf & _
		  "2 - urpl(sc)" & vbcrlf & _
	  	  "anything else is considered a user string to scan for"
	  
	scanFor = inputbox( "Scan stream for strings:" & vbcrlf & lst)
	if len(scanFor) = 0 then exit function

	if scanFor = "1" then scanFor = "rep(count,what)"
	if scanFor = "2" then scanFor = "urpl(sc)"
	
	pth = dlg.FolderDialog()
	if len(pth)=0 then exit function
	
	findex = 0
	tmp = "Scanning for string '" & scanFor & "' in pdf streams for folder: " & pth & vbcrlf & vbcrlf 
	if not GetFiles(pth) then 
		MsgBox "no files!"
	else
		LoadNextFile
	end if 
	
end function

'this function is called by the main ui when form1.cmdDecode_Click completes
function Decode_Complete()
	
	for each li in form1.lv.listitems
	   set stream = li.tag
	   data = GetActiveData(li)
	   if instr(1, data, scanFor, vbTextCompare) > 0 then 
	   		tmp = tmp & " stream " & stream.index & " > " & form1.txtPDFPath & vbcrlf
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