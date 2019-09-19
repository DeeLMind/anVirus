
dim pth
dim no_data 
dim cnt 
	
set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

dl = "http://sourceforge.net/projects/pdfbox/files/PDFBox/PDFBox-0.7.3/PDFBox-0.7.3.zip/download"
ie = "C:\Program Files\Internet Explorer\iexplore.exe"

base = "D:\PDFBox-0.7.3\PDFBox-0.7.3\bin\"
if right(base,1) <> "\" then base = base & "\"
txt  = base & "extractText.exe"

function main()
	
	msgbox "Uses Pdfbox to extract text per page from current file"
	
	pth = form1.txtPDFPath
	if len(pth)=0 then exit function
	if not fso.FileExists(pth) then exit function
	if not doFileChecks() then exit function
	
	pdir = fso.GetParentFolderName(pth) 
	wsh.CurrentDirectory = pdir
	
	'there is no output as to how many pages there are..so we assume a 
	'max of 99 the we bail after 6 empty in a row, empty files will be 
	'deleted automatically
	
	for i = 0 to 99
	   'example extractText.exe -startPage 99 -endPage 99 c:\test\The_Case_of__TDL3.pdf c:\test\page1.txt
	   outfile = pdir & "\page" & i & ".txt"
	   cmd = "$exe -startPage $i -endPage $i ""$pdf"" ""$outfile"""
	   cmd = replace(cmd, "$exe", txt )
	   cmd = replace(cmd, "$pdf", pth )
	   cmd = replace(cmd, "$i", i )
	   cmd = replace(cmd, "$outfile", outfile )
	   'msgbox cmd
	   form1.catch_up
	   output = wsh.exec(cmd).StdOut.ReadAll()
	   if fso.GetFile(outfile).Size = 0 then 
	   		no_data = no_data + 1
	   		fso.deletefile outfile
	   else
	   		no_data = 0
	   		cnt = cnt + 1
	   end if 
	   if no_data > 6 then exit for
	next	
	   
	msgbox cnt & " Pages with data extracted"
	
	if cnt > 0 then 
		wsh.exec "explorer.exe """ & fso.GetParentFolderName(pth)  & """"
	end if 
		
	form1.AutomatationRun = false
	
end function

function doFileChecks() 'as boolean

	if not fso.FolderExists(base) then 
		msg = "Could not locate PDFBox base install dir you must edit this script" & vbcrlf & vbcrlf & "Default: " & base
		ie_exists = fso.FileExists(ie)
		
		if ie_exists then
			 msg = msg & " would you like to download the installer? (22mb)"
		  	 if msgbox(msg,vbYesNo) = vbYes then 
					wsh.exec ie & " " & dl
			 end if   	 
		else
			msgbox msg
		end if 
			
		exit function
	end if 
	
	if not fso.FileExists(txt) then 
		msgbox "Could not locate extractText.exe"
		exit function
	end if 
	
	doFileChecks = true
end function


