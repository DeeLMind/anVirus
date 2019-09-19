
dim tmp
dim files()
dim findex 
dim scanFor
dim pth

set wsh = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

dl = "http://sourceforge.net/projects/pdfbox/files/PDFBox/PDFBox-0.7.3/PDFBox-0.7.3.zip/download"
ie = "C:\Program Files\Internet Explorer\iexplore.exe"

base = "D:\PDFBox-0.7.3\PDFBox-0.7.3\bin\"
img  = base & "extractImages.exe"
txt  = base & "extractText.exe"

function main()
	
	msgbox "Uses Pdfbox to extract images and text from current file"
	
	pth = form1.txtPDFPath
	if len(pth)=0 then exit function
	if not fso.FileExists(pth) then exit function
	if not doFileChecks() then exit function
	
	bat = """" & txt & """ """ & pth & """" & vbcrlf & _
		  """" & img & """ """ & pth & """"

    batpth = fso.GetParentFolderName(pth) & "\extract.bat"
	fso.CreateTextFile(batpth).Write(bat) 
	
	wsh.CurrentDirectory = fso.GetParentFolderName(pth)
	output = wsh.exec( "cmd /c """ & batpth & """").StdOut.ReadAll()
	fso.DeleteFile(batPth)
	wsh.exec "explorer.exe """ & fso.GetParentFolderName(pth)  & """"
	form1.AutomatationRun = false
	
	'pth = fso.GetParentFolderName(pth) & "\cmd_output.txt"
	'fso.CreateTextFile(pth).Write(output)
	
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
	
	if not fso.FileExists(img) then 
		msgbox "Could not locate extractImages.exe"
		exit function
	end if 
	
	if not fso.FileExists(txt) then 
		msgbox "Could not locate extractText.exe"
		exit function
	end if 
	
	doFileChecks = true
end function

function Decode_Complete()	
	'has to be here as placeholder to keep from msgbox even though unused in this case
end function

