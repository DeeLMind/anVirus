
'you are pretty much going to have to read the source to figure out how to write these
'scripts and see what kinds of objects are available and how to work with them.
'there is no simple way to document it all other than show you a couple examples.
'if you make some cool scripts you want to share feel free to mail them to me for
'inclusion with the main package.

'globals execute as soon as script is loaded
'Function SaveDialog(filt As FilterTypes, Optional initDir As String, Optional title As String = "", Optional ConfirmOvewrite As Boolean = True, Optional pHwnd As Long = 0, Optional defaultFileName As String) As String

dim tmp
dim files()
dim findex 
dim saveAs
dim pth

set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

dim orgZlibSetting

findex = 0
tmp = "Path,Streams,JS,Embeds,Pages,TTF,U3D,Flash,UnkFlt,Action" & vbcrlf

'function main is called right after loading (put in function so you can use exit function to bail
'and dont have to nest a bunch of if else..otherwise no other way to stop execution. 
'main is optional but nice to use  
function main()

	msgbox "I will scan a directory and build csv of lower status bar info" & vbcrlf & vbcrlf & "if UI hangs, hit the load button again at bottom." & vbcrlf & vbcrlf & "if it crashs..disable iText decompressors"
	
	orgZlibSetting = form1.mnuAlwaysUseZlib.Checked
	form1.mnuAlwaysUseZlib.Checked = true
	
	pth = dlg.FolderDialog()
	if len(pth)=0 then exit function
	
	xxx = split(pth,"\\")
	f = xxx(ubound(xxx))
	
	saveAs = dlg.SaveDialog(4,,"Save report as",,, f & "_overview_report.csv")
	if len(saveAs)=0 then exit function
	if fso.fileexists(saveAs) then fso.deletefile saveAs
	
	if not GetFiles(pth) then 
		MsgBox "no files!"
		exit function
	end if 
	
	LoadNextFile
	
end function

'this function is called by the main ui when form1.cmdDecode_Click completes
function Decode_Complete()
	'had some weird hangs, trying a different method now for 
	'this script with polling while form1.status = 1
	'turns out it was a bug in the main code fixed, this is safe to use..
end function


'these are support functions below here...
function LoadNextFile()
	
	if findex >= ubound(files) then 
	
		
    	fso.OpenTextFile(saveAs,8,True).Write tmp  'for append
    	
    	'if msgbox( "Open " & pth & " in excel to view results" & vbcrlf & vbcrlf & "Click YES to see them now i notepad",4) = 6 then 
    	'		wsh.Exec "notepad.exe """ & pth & """"
    	'end if 
    	
    	msgbox "Complete Report saved as: " & saveAs
    	form1.AutomatationRun = false
    	form1.mnuAlwaysUseZlib.Checked = orgZlibSetting
    	
	else
    	
	    
	    if fso.fileexists(saveAs) then 
    		fso.OpenTextFile(saveAs,8).Write tmp  
    	else
    		fso.CreateTextFile(saveAs).Write tmp  
    	end if 
    	
    	tmp = ""
    	
		form1.txtPDFPath = files(findex)
		findex = findex + 1
		form1.cmdDecode_Click
		
		while form1.status = 1 'processing
			form1.DoEventsFor 2
		wend
		
		tmp = tmp & fso.GetFileName(form1.txtPDFPath) & ","
		for i=1 to 9
			x = Form1.StatusBar.Panels(i).Text
			if instr(x,":")>0 then x = trim(mid(x,instr(x,":")+1))
	        tmp = tmp & x & ","
		next
		tmp = tmp & vbcrlf 
		
		form1.sleepfor 100
		LoadNextFile
		
	end if 
	
end function


function GetFiles(pth) 'as boolean loads global array 

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


function GetActiveData(ListItem) 'As String - ripped from form1 source for use here..
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