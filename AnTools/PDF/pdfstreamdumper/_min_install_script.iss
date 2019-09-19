[Setup]
AppName=PDFStreamDumper
AppVerName=PDFStreamDumper 0.9.5xx
DefaultDirName=c:\PDFStreamDumper
DefaultGroupName=PDFStreamDumper
UninstallDisplayIcon={app}\unins000.exe
OutputDir=./
OutputBaseFilename=PDFStreamDumper_Setup


[Dirs]
Name: {app}\iTextFilters
Name: {app}\scripts
Name: {app}\libemu
Name: {app}\plugins
Name: {app}\xor_bruteforcer
Name: {app}\sc_samples
Name: {app}\AS3_WebInstall
Name: {app}\mupdf
Name: {app}\mupdf\jbig2dec

[Files]
Source: java.hilighter; DestDir: {app}
Source: iTextSharp.dll; DestDir: {app}
Source: beautify.js; DestDir: {app}
Source: PDFStreamDumper.exe; DestDir: {app}
Source: Readme.txt; DestDir: {app}
Source: zlib.dll; DestDir: {app}
Source: userLib.js; DestDir: {app}
Source: myMain.js; DestDir: {app}
Source: JS_UI_Readme.txt; DestDir: {app}
Source: js_api.txt; DestDir: {app}
Source: dependancies\MSCOMCTL.OCX; DestDir: {win}; Flags: regserver uninsneveruninstall
Source: dependancies\msscript.ocx; DestDir: {win}; Flags: regserver uninsneveruninstall
Source: dependancies\richtx32.ocx; DestDir: {win}; Flags: regserver uninsneveruninstall
Source: dependancies\scivb2.ocx; DestDir: {app}; Flags: regserver ignoreversion
Source: dependancies\SciLexer.dll; DestDir: {app}
Source: dependancies\hexed.ocx; DestDir: {app}; Flags: regserver ignoreversion
Source: dependancies\WinGraphviz.dll; DestDir: {app}; Flags: regserver
Source: iTextFilters.dll; DestDir: {app}; Flags: ignoreversion
Source: iTextFilters.tlb; DestDir: {app}; Flags: regtypelib
Source: iTextFilters\iText_Filters.reg; DestDir: {app}\iTextFilters\
Source: iTextFilters\readme.txt; DestDir: {app}\iTextFilters\
Source: scripts\string_scan.vbs; DestDir: {app}\scripts\
Source: scripts\csv_stats.vbs; DestDir: {app}\scripts\
Source: scripts\unsupported_filters.vbs; DestDir: {app}\scripts\
Source: scripts\pdfbox_extract.vbs; DestDir: {app}\scripts\
Source: scripts\filter_chains.vbs; DestDir: {app}\scripts\
Source: scripts\obsfuscated_headers.vbs; DestDir: {app}\scripts\
Source: scripts\README.txt; DestDir: {app}\scripts\
Source: scripts\pdfbox_extract_text_page_by_page.vbs; DestDir: {app}\scripts\
Source: plugins\blank_build_db.mdb; DestDir: {app}\plugins\
Source: plugins\README.txt; DestDir: {app}\plugins\
Source: plugins\build_db.dll; DestDir: {app}\plugins\; Flags: regserver
Source: plugins\obj_browser.dll; DestDir: {app}\plugins\; Flags: regserver
Source: libemu\credits.txt; DestDir: {app}\libemu\
Source: libemu\encoders.txt; DestDir: {app}\libemu\
Source: libemu\scSigs.exe; DestDir: {app}\libemu\
Source: libemu\scdbg.exe; DestDir: {app}\libemu\
Source: libemu\shellcode_hashs.txt; DestDir: {app}\libemu\
Source: libemu\string_matches.txt; DestDir: {app}\libemu\
Source: xor_bruteforcer\xorbrute.exe; DestDir: {app}\xor_bruteforcer\
Source: AS3_WebInstall\AS3_webInstall.exe; DestDir: {app}\AS3_WebInstall\
;Source: VS_LIBEMU.url; DestDir: {app}\
Source: plugins\virustotal.dll; DestDir: {app}\plugins\; Flags: regserver
Source: mupdf.dll; DestDir: {app}
Source: mupdf\jbig2dec\LICENSE; DestDir: {app}\mupdf\jbig2dec
Source: mupdf\jbig2dec\README; DestDir: {app}\mupdf\jbig2dec
Source: mupdf\CONTRIBUTORS; DestDir: {app}\mupdf\
Source: mupdf\COPYING; DestDir: {app}\mupdf\
Source: mupdf\README; DestDir: {app}\mupdf\
Source: lzma.exe; DestDir: {app}
Source: scrdec12.exe; DestDir: {app}


[Icons]
Name: {group}\PdfStreamDumper.exe; Filename: {app}\PDFStreamDumper.exe
Name: {group}\Readme.txt; Filename: {app}\Readme.txt
Name: {group}\Uninstall; Filename: {app}\unins000.exe
Name: {userdesktop}\PdfStreamDumper.exe; Filename: {app}\PDFStreamDumper.exe; IconIndex: 0

[Run]
Filename: {app}\Readme.txt; Description: View ReadMe; Flags: postinstall shellexec runmaximized
Filename: regedit.exe; Flags: nowait; Parameters: /s {app}\iTextFilters\iText_Filters.reg
Filename: {app}\AS3_WebInstall\AS3_webInstall.exe; Description: Install AS3 Flash Decompiler; Flags: postinstall
