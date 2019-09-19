VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Begin VB.Form frmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About PDFStreamDumper"
   ClientHeight    =   6195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11385
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6195
   ScaleWidth      =   11385
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   2235
      Left            =   8820
      Picture         =   "frmAbout.frx":0000
      ScaleHeight     =   2235
      ScaleWidth      =   2115
      TabIndex        =   1
      Top             =   60
      Width           =   2115
   End
   Begin RichTextLib.RichTextBox rtf 
      Height          =   6135
      Left            =   120
      TabIndex        =   0
      Top             =   0
      Width           =   11175
      _ExtentX        =   19711
      _ExtentY        =   10821
      _Version        =   393217
      ReadOnly        =   -1  'True
      ScrollBars      =   2
      TextRTF         =   $"frmAbout.frx":4B1E
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    Me.Icon = Form1.Icon
    Const m1 = "\n\nStream Parser and Decompression code by VBboy136 - 12/9/2008\n" & _
                "http://www.codeproject.com/KB/DLL/PDF2TXTVB.aspx\n\n" & _
                 "JS Beautify by Einar Lielmanis, <einar@jsbeautifier.org>\n" & _
                "conversion to Javascript code by Vital, <vital76@gmail.com>\n" & _
                "http://jsbeautifier.org/\n\n" & _
                "Scintilla by Neil Hodgson [neilh@scintilla.org]\n" & _
                "http://www.scintilla.org/\n\n" & _
                "ScintillaVB by Stu Collier\n" & _
                "http://www.ceditmx.com/software/scintilla-vb/\n\n" & _
                "AS3 Sorcerer Trial provided courtesy of Manitu Group. (Flash ActionScript 3 Decompiler)\n" & _
                "http://www.as3sorcerer.com/\n\n" & _
                "iTextSharp.dll and iText_Filters.dll code by Bruno Lowagie and Paulo Soares\n" & _
                "http://itextpdf.com/terms-of-use/index.php\n\n" & _
                "sclog is a tool i wrote back at iDefense source here:\n" & _
                "http://labs.idefense.com/software/download/?downloadID=8\n" & _
                "Updates: http://github.com/dzzie/sclog\n\n"

    Const m2 = "MuPDF is released under GPL and Copyright 2006-2012 Artifex Software, Inc.\n" & _
                "http://www.mupdf.com/\n\n" & _
                "CCTIFaxDecoder copyright Sun MicroSystems and intarsys consulting GmbH.\n" & _
                "http://java.net/projects/pdf-renderer/\n\n" & _
                "libemu and sctest written by Paul Baecher and Markus Koetter in 2007.\n" & _
                "http://libemu.carnivore.it/about.html\n\n" & _
                "scdbg (libemu/sctest mod) developer dzzie@yahoo.com\n" & _
                "http://github.com/dzzie/VS_LIBEMU\n\n" & _
                "zlib.dll by Jean-loup Gailly and Mark Adler\n" & _
                "http://www.zlib.net/\n\n" & _
                "HexEd hexeditor control codebase by Rang3r\n" & _
                "http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=34729&lngWId=1\n\n" & _
                "Crc32 and Binary Clipboard class Copyright (c) 2002 Steve McMahon\n" & _
                "http://www.vbaccelerator.com\n\n" & _
                "olly.dll GPL code Copyright (C) 2001 Oleh Yuschuk\n" & _
                "http://home.t-online.de/home/Ollydbg/\n\n" & _
                "Interface by dzzie@yahoo.com\nhttp://sandsprite.com\n\n" & _
                "Other thanks to Didier Stevens for the info on his blog on tags and encodings.\n" & _
                "http://blog.didierstevens.com/2008/04/29/pdf-let-me-count-the-ways/\n\n"
                       
    Const m3 = "WinGraphViz - OOD Tsen oodtsen@gmail.com\n" & _
                "http://wingraphviz.sourceforge.net/wingraphviz/index.htm\n\n" & _
                "GraphViz - AT&T Labs\n" & _
                "http://graphviz.org/\n\n" & _
                "Microsoft Script Decoder (c)2000/2001 MrBrownstone\n" & _
                "http://www.virtualconspiracy.com/scrdec.html\n\n"

                 

    Dim Header
    Header = "        PDFStreamDumper v" & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf & vbCrLf
    Header = Header & "Developer: David Zimmer <dzzie@yahoo.com>" & vbCrLf & vbCrLf
    Header = Header & "Homepage:" & vbCrLf & "http://sandsprite.com/blogs/index.php?uid=7&pid=57"
    
    tmp = Split(Header & Replace(m1 & m2 & m3, "\n", vbCrLf), vbCrLf)
     
    On Error GoTo hell
    Dim first As Boolean
    first = True
    
    For Each x In tmp
        If first Then
            rtf.SelFontSize = 22
            first = False
        Else
            rtf.SelFontSize = 11
        End If
        
        If InStr(1, x, "http://", vbTextCompare) > 0 Then
            rtf.SelColor = vbBlue
            rtf.SelBold = False
        Else
            rtf.SelAlignment = vbBlack
            rtf.SelBold = True
        End If
        rtf.SelText = x & vbCrLf
    Next
    
hell:
    
    rtf.SelStart = 0
    rtf.SelLength = 0
    
End Sub

