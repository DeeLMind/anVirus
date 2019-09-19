VERSION 5.00
Object = "{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}#1.0#0"; "msscript.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{9A143468-B450-48DD-930D-925078198E4D}#1.1#0"; "hexed.ocx"
Begin VB.Form Form1 
   Caption         =   "PDF Stream Dumper - http://sandsprite.com"
   ClientHeight    =   9480
   ClientLeft      =   165
   ClientTop       =   1020
   ClientWidth     =   14925
   BeginProperty Font 
      Name            =   "Courier New"
      Size            =   9.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   9480
   ScaleWidth      =   14925
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame fraPictViewer 
      Caption         =   "Picture Viewer "
      Height          =   2685
      Left            =   8160
      TabIndex        =   20
      Top             =   2520
      Visible         =   0   'False
      Width           =   3915
      Begin VB.PictureBox Picture1 
         AutoRedraw      =   -1  'True
         AutoSize        =   -1  'True
         Height          =   1875
         Left            =   150
         ScaleHeight     =   1815
         ScaleWidth      =   3585
         TabIndex        =   21
         Top             =   390
         Width           =   3645
      End
      Begin VB.Label lblClosePictViewer 
         Caption         =   "Close"
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   4170
         TabIndex        =   22
         Top             =   60
         Width           =   645
      End
   End
   Begin rhexed.HexEd he 
      Height          =   1575
      Left            =   2130
      TabIndex        =   19
      Top             =   60
      Visible         =   0   'False
      Width           =   10665
      _ExtentX        =   18812
      _ExtentY        =   2778
   End
   Begin PDFStreamDumper.ucAsyncDownload ucAsyncDownload1 
      Height          =   615
      Left            =   12870
      TabIndex        =   18
      Top             =   810
      Visible         =   0   'False
      Width           =   795
      _ExtentX        =   1402
      _ExtentY        =   1085
   End
   Begin RichTextLib.RichTextBox txtDetails 
      Height          =   3435
      Left            =   3600
      TabIndex        =   17
      Top             =   2040
      Visible         =   0   'False
      Width           =   8775
      _ExtentX        =   15478
      _ExtentY        =   6059
      _Version        =   393217
      ScrollBars      =   2
      TextRTF         =   $"Form1.frx":1142
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Frame fraLower 
      BorderStyle     =   0  'None
      Height          =   1860
      Left            =   2115
      TabIndex        =   12
      Top             =   6525
      Width           =   11625
      Begin MSComctlLib.ListView lvDebug 
         Height          =   1455
         Left            =   1200
         TabIndex        =   13
         Top             =   0
         Visible         =   0   'False
         Width           =   8475
         _ExtentX        =   14949
         _ExtentY        =   2566
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         NumItems        =   1
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "Message"
            Object.Width           =   2540
         EndProperty
      End
      Begin MSComctlLib.ListView lvSearch 
         Height          =   1455
         Left            =   360
         TabIndex        =   14
         Top             =   0
         Visible         =   0   'False
         Width           =   9900
         _ExtentX        =   17463
         _ExtentY        =   2566
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         NumItems        =   1
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "Search Results"
            Object.Width           =   2540
         EndProperty
      End
      Begin MSComctlLib.ListView lv2 
         Height          =   1455
         Left            =   0
         TabIndex        =   15
         Top             =   0
         Width           =   11265
         _ExtentX        =   19870
         _ExtentY        =   2566
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         NumItems        =   1
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "Errors"
            Object.Width           =   2540
         EndProperty
      End
      Begin MSComctlLib.TabStrip TabStrip1 
         Height          =   1815
         Left            =   30
         TabIndex        =   16
         Top             =   0
         Width           =   11600
         _ExtentX        =   20452
         _ExtentY        =   3201
         MultiRow        =   -1  'True
         Placement       =   1
         TabStyle        =   1
         _Version        =   393216
         BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
            NumTabs         =   3
            BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               Caption         =   "Errors"
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               Caption         =   "Search"
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               Caption         =   "Debug"
               ImageVarType    =   2
            EndProperty
         EndProperty
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Courier New"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
   End
   Begin VB.Frame fraControls 
      BorderStyle     =   0  'None
      Height          =   465
      Left            =   45
      TabIndex        =   5
      Top             =   8370
      Width           =   13815
      Begin VB.TextBox txtPDFPath 
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   2040
         OLEDropMode     =   1  'Manual
         TabIndex        =   10
         Text            =   "Drag and drop pdf file here"
         Top             =   90
         Width           =   8535
      End
      Begin VB.CommandButton cmdDecode 
         Caption         =   "Load"
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   11250
         TabIndex        =   9
         Top             =   45
         Width           =   1335
      End
      Begin VB.CommandButton cmdBrowse 
         Caption         =   "..."
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   10665
         TabIndex        =   8
         Top             =   45
         Width           =   615
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Shell"
         Enabled         =   0   'False
         Height          =   375
         Left            =   0
         TabIndex        =   7
         Top             =   75
         Width           =   855
      End
      Begin VB.CommandButton cmdAbortProcessing 
         Caption         =   "Abort"
         Height          =   375
         Left            =   12600
         TabIndex        =   6
         Top             =   45
         Width           =   1005
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "PDF Path"
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   840
         TabIndex        =   11
         Top             =   120
         Width           =   1095
      End
   End
   Begin MSComctlLib.ProgressBar pb 
      Height          =   285
      Left            =   5805
      TabIndex        =   4
      Top             =   6165
      Width           =   7710
      _ExtentX        =   13600
      _ExtentY        =   503
      _Version        =   393216
      Appearance      =   1
   End
   Begin MSScriptControlCtl.ScriptControl scAuto 
      Left            =   12240
      Top             =   120
      _ExtentX        =   1005
      _ExtentY        =   1005
      Timeout         =   100000
   End
   Begin MSScriptControlCtl.ScriptControl sc 
      Left            =   12960
      Top             =   120
      _ExtentX        =   1005
      _ExtentY        =   1005
      Language        =   "jscript"
   End
   Begin MSComctlLib.StatusBar StatusBar 
      Align           =   2  'Align Bottom
      Height          =   300
      Left            =   0
      TabIndex        =   3
      Top             =   9180
      Width           =   14925
      _ExtentX        =   26326
      _ExtentY        =   529
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   10
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel5 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel6 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel7 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel8 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel9 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
         BeginProperty Panel10 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin RichTextLib.RichTextBox txtUncompressed 
      Height          =   4095
      Left            =   3120
      TabIndex        =   0
      Top             =   1620
      Width           =   9855
      _ExtentX        =   17383
      _ExtentY        =   7223
      _Version        =   393217
      Enabled         =   -1  'True
      HideSelection   =   0   'False
      ScrollBars      =   2
      TextRTF         =   $"Form1.frx":11C4
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComctlLib.ListView lv 
      Height          =   8295
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   14631
      View            =   3
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      NumItems        =   1
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "Objects"
         Object.Width           =   2540
      EndProperty
   End
   Begin MSComctlLib.TabStrip ts 
      Height          =   6495
      Left            =   2040
      TabIndex        =   2
      Top             =   0
      Width           =   11910
      _ExtentX        =   21008
      _ExtentY        =   11456
      MultiRow        =   -1  'True
      Placement       =   1
      TabStyle        =   1
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   3
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Text"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "HexDump"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Stream Details"
            ImageVarType    =   2
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Menu mnuLoadTop 
      Caption         =   "Load"
      Begin VB.Menu mnuLoadFile 
         Caption         =   "Pdf File"
      End
      Begin VB.Menu muLoadShellcode 
         Caption         =   "Shellcode File"
      End
      Begin VB.Menu mnuLoadJSFile 
         Caption         =   "Javascript File"
      End
      Begin VB.Menu mnuPlugin 
         Caption         =   "Run Plugin"
         Begin VB.Menu mnuPluginList 
            Caption         =   "Automation Script"
            Index           =   0
         End
      End
   End
   Begin VB.Menu mnuExploitScan 
      Caption         =   "Exploits_Scan"
   End
   Begin VB.Menu mnuFormatJS 
      Caption         =   "Format_Javascript"
      Visible         =   0   'False
   End
   Begin VB.Menu mnuJavascriptUI 
      Caption         =   "Javascript_UI"
   End
   Begin VB.Menu mnuUnescape 
      Caption         =   "Unescape_Selection"
   End
   Begin VB.Menu mnuManualEscapes 
      Caption         =   "Manual_Escapes"
      Begin VB.Menu mnuManualEscape 
         Caption         =   "HexString Unescape (Preserve White Space)"
         Index           =   0
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "HexString Unescape (Strip White Space)"
         Index           =   1
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "% Unescape"
         Index           =   2
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "\x Unescape"
         Index           =   3
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "\n Unescape"
         Index           =   4
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "# Unescape"
         Index           =   5
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "Octal UnEscape"
         Index           =   6
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "Escape and Format Headers"
         Index           =   7
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "Strip CRLF and WhiteSpace"
         Index           =   8
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "Extract Valid Hex Chars from Blob"
         Index           =   9
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "Extract Valid Hex from blob + u -> %u"
         Index           =   10
      End
      Begin VB.Menu mnuManualEscape 
         Caption         =   "Add % to HexString"
         Index           =   11
      End
      Begin VB.Menu mnuExtractHexFromParan 
         Caption         =   "Extract Data From () Page Data"
      End
      Begin VB.Menu mnuExtractHexDump 
         Caption         =   "Extract Hex From HexDump"
         Enabled         =   0   'False
         Visible         =   0   'False
      End
   End
   Begin VB.Menu mnuUpdateCurrent 
      Caption         =   "Update_Current_Stream"
   End
   Begin VB.Menu mnuGotoObject 
      Caption         =   "Goto_Object"
   End
   Begin VB.Menu mnuSearchFor 
      Caption         =   "Search_For"
      Begin VB.Menu mnuSearch 
         Caption         =   "Search Strings"
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "Javascript"
         Index           =   0
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "Flash Objects"
         Index           =   1
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "U3D Objects"
         Index           =   2
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "TTF Fonts"
         Index           =   3
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "Action Tags"
         Index           =   4
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "Obsfuscated Headers "
         Index           =   5
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "PRC Files"
         Index           =   6
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "XML Streams"
         Index           =   7
      End
      Begin VB.Menu mnuSearchFilter 
         Caption         =   "Filter Chains"
         Index           =   8
      End
      Begin VB.Menu mnuExtractURI 
         Caption         =   "Extract URLs"
      End
   End
   Begin VB.Menu mnuFindReplace 
      Caption         =   "Find/Replace"
   End
   Begin VB.Menu mnuTools 
      Caption         =   "Tools"
      Begin VB.Menu mnuZlibBrute 
         Caption         =   "Zlib Brute Forcer"
      End
      Begin VB.Menu mnuDecompress 
         Caption         =   "Zlib Decompress_File"
      End
      Begin VB.Menu mnuCompress 
         Caption         =   "Zlib Compress_File"
      End
      Begin VB.Menu mnuSpacer22 
         Caption         =   "-"
      End
      Begin VB.Menu mnuB64Clipboard 
         Caption         =   "Base64 Decode Clipboard"
      End
      Begin VB.Menu mn_b64EncClip 
         Caption         =   "Base64 Encode Clipboard"
      End
      Begin VB.Menu mnub64decode 
         Caption         =   "Base64 Decode File"
      End
      Begin VB.Menu mnub64Encode 
         Caption         =   "Base64 Encode File"
      End
      Begin VB.Menu mnuSpacer44 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDecompileFlashTools 
         Caption         =   "Decompile Flash w/ AS3 Sorcerer"
      End
      Begin VB.Menu mnuDecompressSWC 
         Caption         =   "Decompress Flash  (CWS Header)"
      End
      Begin VB.Menu mnuDecompressZWS 
         Caption         =   "Decompress Flash  (ZWS Header)"
      End
      Begin VB.Menu mnuDecrypt 
         Caption         =   "Decrypt PDF (Force)"
      End
      Begin VB.Menu mnuSpacer77 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSecureDownload 
         Caption         =   "Download URL"
      End
      Begin VB.Menu mnuFilters 
         Caption         =   "Manual_Filters"
      End
      Begin VB.Menu mnuFilterVisualizer 
         Caption         =   "Filter Visualizer"
      End
      Begin VB.Menu mnuHexEditor 
         Caption         =   "View PDF in Hexeditor"
      End
      Begin VB.Menu mnuNewHexEditorWin 
         Caption         =   "New Hexeditor Window"
      End
      Begin VB.Menu mnuSpacer4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewExploitDetections 
         Caption         =   "View Exploit Detections"
      End
      Begin VB.Menu mnuoptions 
         Caption         =   "Options"
         Begin VB.Menu mnuAutoEscapeHeaders 
            Caption         =   "Auto Escape Headers"
         End
         Begin VB.Menu mnuVisualFormatHeaders 
            Caption         =   "Visually Format Headers"
         End
         Begin VB.Menu mnuEnableShellButton 
            Caption         =   "Enable Shell Button"
         End
         Begin VB.Menu mnuHideHeaderStreams 
            Caption         =   "Hide Header Only Objects"
         End
         Begin VB.Menu mnuHideDups 
            Caption         =   "Hide Duplicate Streams"
         End
         Begin VB.Menu mnuAlwaysUseZlib 
            Caption         =   "Always use Zlib for FlateDecode"
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDisableiText 
            Caption         =   "Disable iText Decompressors"
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDisableDecomp 
            Caption         =   "Disable All Decompressors"
         End
         Begin VB.Menu mnuOpenLastAtStart 
            Caption         =   "Open Last PDF on Startup"
            Visible         =   0   'False
         End
         Begin VB.Menu mnuDisableDecryption 
            Caption         =   "Disable Decryption Support"
         End
         Begin VB.Menu mnuEnableJBIG2 
            Caption         =   "Enable JBIG2 Decoding Support"
         End
         Begin VB.Menu mnuUseInternalHexeditor 
            Caption         =   "Use Internal HexEditor"
         End
         Begin VB.Menu mnuAutoSwitchTabs 
            Caption         =   "AutoSwitch Tabs for Binary Data"
         End
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "About"
      End
      Begin VB.Menu mnuAboutLvColors 
         Caption         =   "About Listview Colors"
      End
      Begin VB.Menu mnuDebugBreakAtStream 
         Caption         =   "Debug> Break At Stream"
      End
      Begin VB.Menu mnuBrowseHomeDir 
         Caption         =   "Browse Home Directory"
      End
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Begin VB.Menu mnuShowRawHeader 
         Caption         =   "Show Raw Header"
      End
      Begin VB.Menu mnuSHowRawObject 
         Caption         =   "Show Raw Object"
      End
      Begin VB.Menu mnuDecompileFlash 
         Caption         =   "Decompile Flash w/ AS3 Sorcerer"
      End
      Begin VB.Menu mnuSpacer99 
         Caption         =   "-"
      End
      Begin VB.Menu mnuWipeStream 
         Caption         =   "Wipe Object"
      End
      Begin VB.Menu mnuMarkStream 
         Caption         =   "Mark Stream"
      End
      Begin VB.Menu mnuReplaceStream 
         Caption         =   "Replace Stream"
      End
      Begin VB.Menu mnuHideSelected 
         Caption         =   "Hide Selected Streams"
      End
      Begin VB.Menu mnuHideUnselected 
         Caption         =   "Hide Unselected Streams"
      End
      Begin VB.Menu mnuLoadAsImage2 
         Caption         =   "Load As Image"
      End
      Begin VB.Menu mnuSpacer2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSaveStream 
         Caption         =   "Save Decompressed Stream"
      End
      Begin VB.Menu mnuSaveAllStreams 
         Caption         =   "Save All Decompressed Streams"
      End
      Begin VB.Menu mnuSpacer1 
         Caption         =   "-"
      End
      Begin VB.Menu mnusSaveRawStream 
         Caption         =   "Save Raw Stream"
      End
      Begin VB.Menu mnuSaveAllRaw 
         Caption         =   "Save All Raw Streams"
      End
   End
   Begin VB.Menu mnuPopup2 
      Caption         =   "mnuPopup2"
      Begin VB.Menu mnuErrorSaveRawAll 
         Caption         =   "Save All Raw Streams"
      End
      Begin VB.Menu mnuErrorSaveRaw 
         Caption         =   "Save Raw Stream"
      End
      Begin VB.Menu mnuSHowRawObject2 
         Caption         =   "Show Raw Object"
      End
      Begin VB.Menu mnuLoadAsImage 
         Caption         =   "Load As Image"
      End
   End
   Begin VB.Menu mnuHelpTop 
      Caption         =   "Help_Videos"
      Begin VB.Menu mnuHelp 
         Caption         =   "-"
         Index           =   0
      End
   End
   Begin VB.Menu mnuSearchPopup 
      Caption         =   "mnuSearchPopup"
      Begin VB.Menu mnuCopySearch 
         Caption         =   "Copy"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'you can download some malicous pdfs from here:
'http://jsunpack.jeek.org/dec/go?report=03d8f2450f56a7bc8eb8b2b59ca53f7818126da6

'changelog
' 9-2-10
'   fixed bug with replace in js ui
'   fixed bug in stream parser now handles nested tags <<start <<another>> end of org>>stream blahblah>>data
' 9-8-10 - added the js refactoring code (big pita!!)
'        - added find/find next to replace form
'        - possible new bugs related to changing this forms lv to multiselect
'        - added support for /Filter /ASCIIHexDecode (01 00 04 02 00 01 01) (kind of a hack)
'        - added toolbox.disasm() function utilizing olly.dll to quick check if byte buffers are shellcode
'        - search now searchs headers too not just stream content
'        - added error handling in all CScript functions
' 9-9-10 - added more listview colors and detections for things.
' 12-10-10 - added support for objend (instead of endobj)
'          - added support for Filter Fl abbreviation (instead of full FlateDecode)
'          - made obj,endobj,stream,endstream marker searchs case insensitive.
'          - force all flateDecode through zlib now, iText could crash sometimes on long automated runs
'          - added a little more err handling to cmddecode_click, scripts could not get their DecodeComplete Event sometimes.
' 12-12-10 - added support for plugins and added database plugin
' 12-13-10 - js_ui added this and app objects, so if(app), if(this.app), app.eval() etc all work now.
'          - js_ui added app.doc, app.collab and function collab.geticon , collab.collectemailinfo, app.eval
'          - js_ui, on js error, now it scrolls to and highlights the line with teh error on it
'          - js_ui, txtOut.Text not auto cleared on script start so you can use it to hold a variable if need be.
'          - js_ui  tb.lv now refers to js form listview so you can pull variables from it in your scripts.
' 12-27-10 - big change to how js_ui executes code, now all wrapped in myMain() function to support this. seems stable.
'          - header _CHR(0)_ replaced with empty now (seems only to cause bug) also replaced py in header with empty
'          - added progress bar and doevents me.refresh to keep ui from freezing on big files

Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpszOp As String, ByVal lpszFile As String, ByVal lpszParams As String, ByVal LpszDir As String, ByVal FsShowCmd As Long) As Long
Private Declare Function GetTickCount Lib "kernel32" () As Long

Dim WithEvents parser As CPdfParser
Attribute parser.VB_VarHelpID = -1
Dim plugins() As Object

Option Explicit

Public Enum statss
    stNotLoaded = 0
    stProcessing = 1
    stComplete = 2
End Enum

Public selli As ListItem
Public dlg As New clsCmnDlg
Public AutomatationRun As Boolean
Public Status As statss
Public LoadTime As Long
Public isEncrypted As Boolean

Dim exploits()
Dim flash_exploits()
Dim help_vids()

Dim streamCount As Long
Dim jsCount As Long
Dim EmbeddedFilesCount As Long
Dim pageCount As Long
Dim ttfCount As Long
Dim U3DCount As Long
Dim flashCount As Long
Dim unspFilterCount As Long
Dim ActionCount As Long
Dim PRCCount As Long
Dim surpressHideWarnings As Boolean
Dim startup_complete As Boolean
Dim defaultLCID As Long
Dim DownloadPath As String
'COMMAND LINE OPTIONS:
Dim ExtractToFolder As String 'command line ex: pdfstreamdumper "c:\file.pdf" /extract "c:\folder" (extracts objects only (flash, fonts, prc, u3d))

Sub LoadPlugins()
    
    Dim tmp() As String, i As Integer, progid As String
    Dim wsc() As String
    
    On Error Resume Next
    
    If Not fso.FolderExists(App.path & "\plugins") Then
        lvDebug.ListItems.Add "Plugins folder not found"
        Exit Sub
    End If
    
    tmp() = fso.GetFolderFiles(App.path & "\plugins", "*dll")
    
    If AryIsEmpty(tmp) Then Exit Sub
        
    ReDim plugins(0)
    
    For i = 0 To UBound(tmp)
        ReDim Preserve plugins(i)
        progid = GetBaseName(tmp(i)) & ".plugin"
        Set plugins(i) = CreateObject(progid)
        If Err.Number = 429 Then 'ActiveX component can't create object
            If MsgBox(progid & " not registered yet, register now?", vbYesNo) = vbYes Then
                    Shell "regsvr32 """ & App.path & "\plugins\" & tmp(i) & """", vbNormalFocus
                    Sleep 2000
            End If
        End If
        Set plugins(i) = CreateObject(progid)
        plugins(i).sethost Me
    Next
    
Exit Sub
hell: MsgBox tmp(i) & " - " & Err.Description
      Resume Next
      
End Sub

Function RegisterPlugin(intMenu As Integer, strMenuName As String, intStartupArgument As Integer)
    'here right after sethost in loadplugins sub
    Dim i As Integer
    
    'If intMenu = 0 Then
        i = mnuPluginList.count
        Load mnuPluginList(i)
        mnuPluginList(i).Caption = strMenuName
        mnuPluginList(i).Visible = True
        mnuPluginList(i).tag = UBound(plugins) & "." & intStartupArgument
    'Else
     'same thing to some other menu
     
End Function

Private Sub cmdAbortProcessing_Click()
    On Error Resume Next
    parser.abort = True
    ucAsyncDownload1.AbortDownload
    pb.value = 0
End Sub

Private Sub lblClosePictViewer_Click()
    fraPictViewer.Visible = False
End Sub

Private Sub lvSearch_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuSearchPopup
End Sub

Private Sub mn_b64EncClip_Click()
    
    On Error Resume Next
    Dim x As String
    x = Clipboard.GetText
    x = b64.EncodeString(x)
    Clipboard.Clear
    Clipboard.SetText x
    MsgBox "Clipboard text encoded (not binary safe)", vbInformation
    
End Sub

Private Sub mnuAlwaysUseZlib_Click()
    mnuAlwaysUseZlib.Checked = Not mnuAlwaysUseZlib.Checked
End Sub

Private Sub mnuAutoSwitchTabs_Click()
    mnuAutoSwitchTabs.Checked = Not mnuAutoSwitchTabs.Checked
End Sub

Private Sub mnuB64Clipboard_Click()
    On Error Resume Next
    Dim f As String
    Dim p As String
    Dim b() As Byte
    Dim ff As Long
    Dim h As CHexEditor
    
    f = Clipboard.GetText
    If Len(f) = 0 Then
        MsgBox "Clipboard Empty"
        Exit Sub
    End If
    
    f = b64.b64DecodeString(f)
    If Len(f) = 0 Then
        MsgBox "Decoding failed length=0"
        Exit Sub
    End If
    
    'p = fso.GetFreeFileName(Environ("temp"), ".tmp")
    '
    'b() = StrConv(f, vbFromUnicode, LANG_US)
    'ff = FreeFile
    'Open p For Binary As ff
    'Put ff, , b()
    'Close ff
    '
    Set h = New CHexEditor
    'h.Editor.LoadFile p, False
    
    h.Editor.LoadString f, False
    
    'MsgBox "File saved. Decoded Length: 0x" & Hex(Len(f))
    
End Sub

Private Sub mnub64decode_Click()
    Dim a As String
    Dim b As String
    a = dlg.OpenDialog(AllFiles)
    If Len(a) = 0 Then Exit Sub
    b = fso.GetParentFolder(a) & "\" & fso.GetBaseName(a) & ".unmime"
    b64.UnMimeFileToFile a, b
    If fso.FileExists(b) Then
        MsgBox "Complete 0x" & Hex(FileLen(b)) & " bytes decompressed saved as: " & vbCrLf & vbCrLf & b
    End If
End Sub

Private Sub mnub64Encode_Click()
    Dim a As String
    Dim b As String
    a = dlg.OpenDialog(AllFiles)
    If Len(a) = 0 Then Exit Sub
    b = fso.GetParentFolder(a) & "\" & fso.GetBaseName(a) & ".mime"
    b64.MimeFileToFile a, b
    If fso.FileExists(b) Then
        MsgBox "Complete 0x" & Hex(FileLen(b)) & " bytes decompressed saved as: " & vbCrLf & vbCrLf & b
    End If
End Sub

Private Sub mnuBrowseHomeDir_Click()
    On Error Resume Next
    Shell "explorer.exe """ & App.path & """", vbNormalFocus
End Sub

Private Sub mnuCopySearch_Click()
    Dim t() As String
    Dim li As ListItem
    For Each li In lvSearch.ListItems
        push t, li.Text
    Next
    Clipboard.Clear
    Clipboard.SetText Join(t, vbCrLf)
End Sub

Private Sub mnuDebugBreakAtStream_Click()
    Dim x As Long
    On Error GoTo hell
    Err.Clear
    parser.BreakAtStream = CLng(InputBox("Enter stream index to break at"))
hell:
    If Err.Number <> 0 Then parser.BreakAtStream = 0
End Sub

Private Sub mnuDecompileFlash_Click()
    
    On Error Resume Next
    
    If selli Is Nothing Then
        MsgBox "No stream selected.", vbInformation
        Exit Sub
    End If
    
    Dim exe_path As String
    Dim file As String
    
    If Not isAS3Sorcerer_Installed(exe_path) Then
        file = App.path & "\AS3_webInstall\AS3_webInstall.exe"
        If Not fso.FileExists(file) Then
            MsgBox "Can not locate: " & vbCrLf & file, vbInformation
        Else
            Shell file, vbNormalFocus
        End If
        Exit Sub
    End If
    
    Dim stream As CPDFStream
    Set stream = selli.tag
    
    If stream.ContentType <> Flash Then
        MsgBox "Stream content is not marked as a flash file?", vbInformation
        Exit Sub
    End If
    
    Dim b() As Byte
    If stream.isCompressed Then
        b() = StrConv(stream.DecompressedData, vbFromUnicode, LANG_US)
    Else
        b() = StrConv(stream.OriginalData, vbFromUnicode, LANG_US)
    End If
    
    Dim p As String
    Dim exe As String
    
    Dim f As Long
    p = App.path & "\tmp.bin"
    f = FreeFile
    
    If fso.FileExists(p) Then Kill p
    Open p For Binary As f
    Put f, , b()
    Close f
    
    exe = GetShortName(exe_path)
    p = GetShortName(p)
    
    Shell exe & " " & p, vbNormalFocus
    
End Sub


Function isAS3Sorcerer_Installed(ByRef exe_path As String) As Boolean
    On Error Resume Next
    Dim p As String
    
    p = GetSetting("PDFStreamDumper", "3rdParty", "AS3Sorcerer", "") 'manually specified
    If fso.FileExists(p) Then
        exe_path = p
        isAS3Sorcerer_Installed = True
        Exit Function
    End If
    
    p = Environ("ProgramFiles")
    
    If Len(p) = 0 Then
        'MsgBox "Using default %ProgramFiles% path", vbInformation
        p = "C:\Program Files\"
    End If
    
    If Not fso.FolderExists(p) Then
        MsgBox "Could not locate  %ProgramFiles% Directory?", vbInformation
        Exit Function
    End If
    
    exe_path = p & "\AS3 Sorcerer\as3s.exe"
    
    If fso.FileExists(exe_path) Then
        isAS3Sorcerer_Installed = True
    End If

End Function

Private Sub mnuDecompileFlashTools_Click()
    On Error Resume Next
    
    Dim file As String
    Dim exe_path As String
    
    If Not isAS3Sorcerer_Installed(exe_path) Then
        file = App.path & "\AS3_webInstall\AS3_webInstall.exe"
        If Not fso.FileExists(file) Then
            MsgBox "Can not locate: " & vbCrLf & file, vbInformation
        Else
            Shell file, vbNormalFocus
        End If
        Exit Sub
    End If
    
    If Not selli Is Nothing Then
        Dim stream As CPDFStream
        Set stream = selli.tag
        If stream.ContentType = Flash Then
            mnuDecompileFlash_Click
            Exit Sub
        End If
    End If
     
    Dim p As String
    Dim exe As String
    
    p = dlg.OpenDialog(AllFiles, , "Select Flash file to decompile", Me.hwnd)
    If Len(p) = 0 Or Not fso.FileExists(p) Then Exit Sub
    
    exe = GetShortName(exe_path)
    p = GetShortName(p)
    
    If Not fso.FileExists(exe) Then
        MsgBox "AS3 Sorcerer not found?", vbInformation
        Exit Sub
    End If
    
    Shell exe & " " & p, vbNormalFocus
    
End Sub

Private Sub mnuDecompressSWC_Click()
    
    On Error Resume Next
    Dim f As String
    Dim ff As Long
    Dim outfile As String
    Dim Header() As Byte
    Dim b() As Byte
    Dim bOut() As Byte
    
    f = dlg.OpenDialog(AllFiles, , "Open Compressed Flash File (CWS header)")
    If Not fso.FileExists(f) Then Exit Sub
    
     
    ff = FreeFile
    ReDim Header(0 To 7)
    
    Open f For Binary As ff
    Get ff, , Header()
    
    If Header(0) <> Asc("C") Or Header(1) <> Asc("W") Or Header(2) <> Asc("S") Then
        If MsgBox("FIle does not have the CWS header try anyway?", vbYesNo) = vbNo Then Exit Sub
    End If
    
    ReDim b(LOF(ff) - 9)
    Get ff, , b()
    Close ff
    
    If Not modZLIB.UncompressData(b(), bOut()) Then
        MsgBox "Decompression Failed", vbInformation
        Exit Sub
    End If
    
    Header(0) = Asc("F")
    outfile = f & ".decompressed"
    ff = FreeFile
    
    Open outfile For Binary As ff
    Put ff, , Header()
    Put ff, , bOut()
    Close f
    
    MsgBox "Deompressed Data saved as " & vbCrLf & vbCrLf & outfile
    
    
End Sub

Private Sub mnuDecompressZWS_Click()
    On Error Resume Next
    Dim f As String
    f = dlg.OpenDialog(AllFiles, , "Open Compressed Flash File (ZWS header)")
    If Not fso.FileExists(f) Then Exit Sub
    f = lzma.flash_decompress_zws(f)
    MsgBox f
End Sub

Private Sub mnuDisableDecryption_Click()
    mnuDisableDecryption.Checked = Not mnuDisableDecryption.Checked
End Sub

Private Sub mnuEnableJBIG2_Click()

    If Not startup_complete Then Exit Sub
    
    If Not mnuEnableJBIG2.Checked Then
        If MsgBox("This filter uses a complex native library which I have not audited." & vbCrLf & _
                  "It may contain security vulnerabilities." & vbCrLf & vbCrLf & _
                  "Are you sure you want to enable it?", vbYesNo + vbInformation) = vbNo Then
            Exit Sub
        End If
    End If
    
    mnuEnableJBIG2.Checked = Not mnuEnableJBIG2.Checked
    
End Sub

Private Sub mnuErrorSaveRawAll_Click()
    
    If lv2.ListItems.count = 0 Then
        MsgBox "No Error streams to save?"
        Exit Sub
    End If
    
    Dim b() As Byte
    Dim pth As String
    Dim pf As String
    Dim f As Long
    Dim c As CPDFStream
    Dim li As ListItem
    
    pf = dlg.FolderDialog()
    If Len(pf) = 0 Then Exit Sub
    
    'pf = GetParentFolder(txtPDFPath)
    
    For Each li In lv2.ListItems
    
        GetActiveData li, , c
        
        b() = StrConv(c.OriginalData, vbFromUnicode, LANG_US)
        pth = pf & "\" & "error_stream_0x" & Hex(c.startOffset) & ".dat"
        
        f = FreeFile
        If Dir(pth) <> "" Then Kill pth
        Open pth For Binary As f
        Put f, , b()
        Close f
    
    Next
    
    MsgBox lv2.ListItems.count & " error Streams Saved to Folder: " & pf, vbInformation
    
End Sub

Private Sub mnuExtractURI_Click()
    On Error Resume Next
    Dim r As String
    Dim s As CPDFStream
    Dim li As ListItem
    Dim tmp
    Dim start As Long
    Dim e As Long
    
    For Each li In lv.ListItems
        Set s = li.tag
        start = InStr(1, s.escapedHeader, "URI", vbTextCompare)
        If start > 0 Then
            e = InStr(start, s.escapedHeader, ")")
            start = InStr(start, s.escapedHeader, "(") + 1
            If start > 1 And e > 0 And e > start Then
                r = r & Mid(s.escapedHeader, start, e - start) & vbCrLf
            End If
        End If
    Next
    
    If Len(r) > 0 Then
        txtUncompressed = r
         
    Else
        MsgBox "No results found", vbInformation
    End If
    
    
    'Clipboard.Clear
    'Clipboard.SetText r
    'MsgBox Len(r) & " characters copied to clipboard.", vbInformation
    
End Sub

Private Sub mnuFilterVisualizer_Click()
    frmFilterVisualizer.Show
End Sub

Private Sub mnuHelp_Click(Index As Integer)
    On Error Resume Next
    Dim ie
    ie = mnuHelp(Index).tag
    If Len(ie) = 0 Then Exit Sub
    
    If ie = "[readme]" Then
        Shell "notepad.exe """ & App.path & "\readme.txt""", vbNormalFocus
        Exit Sub
    End If
    If ie = "[video_help]" Then
        Const Help = "Note that these videos were created while PDFStreamDumper was under development\n\n" & _
                     "As support for more Adobe specific API was added, there may be easier ways to " & _
                     "accomplish some of the techniques shown in the videos. At the end of the day " & _
                     "knowing how to process the scripts manually is always a plus, but it may be " & _
                     "easier now than how it was shown in the video."
        MsgBox Replace(Help, "\n", vbCrLf), vbInformation
        Exit Sub
    End If
    ie = Environ("ProgramFiles") & "\Internet Explorer\iexplore.exe"
    If fso.FileExists(ie) Then
        Shell ie & " """ & mnuHelp(Index).tag & """", vbNormalFocus
    Else
        Shell "cmd /c start """ & mnuHelp(Index).tag & """", vbNormalFocus
    End If
End Sub

Private Sub mnuLoadAsImage_Click()

    On Error Resume Next
    Dim s As CPDFStream
    Set s = selli.tag
    Dim d As String, f As Long, b() As Byte
    Dim t As String
    
    Picture1.Picture = LoadPicture("")
    Picture1.Cls
    
    d = s.OriginalData
    f = FreeFile
    t = fso.GetFreeFileName(Environ("temp"), ".jpg")
    b() = StrConv(d, vbFromUnicode, LANG_US)
    Open t For Binary As f
    Put f, , b()
    Close f
    
    Picture1.Picture = LoadPicture(t)
    fraPictViewer.Visible = True
    
    Kill t
    If Err.Number <> 0 Then Picture1.Print "Error: " & Err.Description
    
End Sub

Private Sub mnuLoadAsImage2_Click()
    mnuLoadAsImage_Click
End Sub

Private Sub mnuLoadJSFile_Click()
    On Error Resume Next
    Form2.Show
    Form2.mnuLoadFile_Click
End Sub

Private Sub mnuNewHexEditorWin_Click()
    On Error Resume Next
    Dim f As CHexEditor
    Dim h As String
    
    If mnuUseInternalHexeditor.Checked Then
        Set f = New CHexEditor
        f.Editor.Visible = True
        Exit Sub
    End If
    
    h = GetMySetting("hexeditor")
    If Len(h) = 0 Or Not fso.FileExists(h) Then
        If MsgBox("You have not yet configured which hexeditor to use select it now?", vbYesNo) = vbNo Then Exit Sub
        h = dlg.OpenDialog(exeFiles, , "Select hexeditor to use", Me.hwnd)
        If fso.FileExists(h) Then
            SaveMySetting "hexeditor", h
        Else
            Exit Sub
        End If
    End If
    
    On Error Resume Next
    Shell h & " """ & txtPDFPath.Text & """", vbNormalFocus
    
    If Err.Number <> 0 Then MsgBox Err.Description
    
End Sub

Private Sub mnuOpenLastAtStart_Click()
    mnuOpenLastAtStart.Checked = Not mnuOpenLastAtStart.Checked
End Sub

Private Sub mnuPluginList_Click(Index As Integer)
    
    If Index = 0 Then
        mnuLoadAutomationScript_Click
        Exit Sub
    End If
    
    Dim tmp() As String
    On Error GoTo hell
    tmp = Split(mnuPluginList(Index).tag, ".")
    plugins(CInt(tmp(0))).startup CInt(tmp(1))
    Exit Sub
hell: MsgBox Err.Description
End Sub


Function DoEventsFor(x) 'for scripts
    On Error Resume Next
    Dim i As Integer
    For i = 0 To x
        DoEvents
    Next
    If Err.Number <> 0 Then DoEvents
End Function

Function SleepFor(ms) 'for scripts
    On Error Resume Next
    Sleep CLng(ms)
End Function

'for scripts
Function Shutdown()
    On Error Resume Next
    Dim f
    For Each f In Forms
        Unload f
    Next
    End
End Function

'for scripts
Function AppPath()
    AppPath = App.path
End Function


Function GetExploits()
    GetExploits = exploits
End Function

Private Sub Form_Resize()
    On Error Resume Next
    Dim tw As Integer 'Twips Width
    Dim th As Integer 'Twips Height
    tw = Screen.TwipsPerPixelX
    th = Screen.TwipsPerPixelY
    
    'Me.Caption = Me.Height & " w: " & Me.Width
    If Me.height < 6500 Then Me.height = 6500
    If Me.Width < 13000 Then Me.Width = 13000
    
    fraControls.Top = Me.height - fraControls.height - StatusBar.height - (th * 60)
    fraLower.Top = fraControls.Top - fraLower.height
    lv.height = fraControls.Top - lv.Top
    
    ts.height = fraLower.Top - ts.Top - (th * 20)  '- 100
    he.height = ts.height - 600
    txtDetails.height = he.height
    txtUncompressed.height = he.height
    pb.Top = ts.Top + ts.height - (th * 20) '- 335
    
    'txtUncompressed.Width = Me.Width - txtUncompressed.Left - 400
    'TabStrip1.Width = txtUncompressed.Width + 300
    TabStrip1.Width = Me.Width - lv.Width - (tw * 20) '10 pixels for the right
    txtUncompressed.Width = TabStrip1.Width - (tw * 10) 'Add 10 more pixels for of border for the tab control
    
    ts.Width = TabStrip1.Width
    he.Width = txtUncompressed.Width
    txtDetails.Width = he.Width
    fraLower.Width = he.Width
    
    fraPictViewer.Move he.left, he.Top, he.Width, he.height
    
    fraControls.Width = Me.Width
    cmdAbortProcessing.left = fraControls.Width - fraControls.left - cmdAbortProcessing.Width - (tw * 20)
    cmdDecode.left = cmdAbortProcessing.left - cmdDecode.Width - (tw * 2)
    cmdBrowse.left = cmdDecode.left - cmdBrowse.Width - (tw * 2)
    Command1.Top = cmdAbortProcessing.Top
    txtPDFPath.Width = cmdBrowse.left - txtPDFPath.left - (tw * 2)
    
    lv2.Width = he.Width
    lvSearch.Width = he.Width
    lvDebug.Width = he.Width
    pb.Width = Me.Width - pb.left - (tw * 20)
    
    lv2.ColumnHeaders(1).Width = lv2.Width - (tw * 5)
    lvSearch.ColumnHeaders(1).Width = lv2.ColumnHeaders(1).Width
    lvDebug.ColumnHeaders(1).Width = lv2.ColumnHeaders(1).Width
    
End Sub

Private Sub lv_KeyDown(KeyCode As Integer, Shift As Integer)
    
    'MsgBox KeyCode & " " & Shift
    'Exit Sub
    
    Dim li As ListItem
    Dim i As Long
    
    If KeyCode = 65 And Shift = 2 Then 'ctrl-a - select all
        For Each li In lv.ListItems
            li.Selected = True
        Next
    End If
    
    If KeyCode = 73 And Shift = 2 Then 'ctrl-i - invert selection
        For Each li In lv.ListItems
            li.Selected = Not li.Selected
        Next
    End If
    
    If KeyCode = 68 And Shift = 2 Then 'ctrl-d - delete selected
        For i = lv.ListItems.count To 1 Step -1
            If li.Selected = True Then
                lv.ListItems.Remove i
            End If
        Next
    End If
    
    If KeyCode = 78 And Shift = 2 Then 'ctrl-n -select none
        For Each li In lv.ListItems
            li.Selected = False
        Next
    End If
    
End Sub

Private Sub lv2_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuPopup2
End Sub

Private Sub mnuAboutLvColors_Click()
    
    Const msg = "Red: Headers with Javascript tag\n" & _
                "Blue: Object Streams\n" & _
                "Green: Headers with /Launch or /Action or /OpenAction or /AA\n" & _
                "Purple: Headers with /EmbeddedFiles\n" & _
                "Orange: Unsupported Filters\n" & _
                "Yellow: TTF Fonts\n" & _
                "Pink: XML Data"
                
    MsgBox Replace(msg, "\n", vbCrLf), vbInformation
    
End Sub

Private Sub mnuAutoEscapeHeaders_Click()
    mnuAutoEscapeHeaders.Checked = Not mnuAutoEscapeHeaders.Checked
End Sub

Private Sub mnuDisableDecomp_Click()
    mnuDisableDecomp.Checked = Not mnuDisableDecomp.Checked
End Sub

Private Sub mnuDisableiText_Click()
    mnuDisableiText.Checked = Not mnuDisableiText.Checked
End Sub

Private Sub mnuEnableShellButton_Click()
    mnuEnableShellButton.Checked = Not mnuEnableShellButton.Checked
    Command1.enabled = mnuEnableShellButton.Checked
End Sub

Private Sub mnuErrorSaveRaw_Click()
        
    If lv2.SelectedItem Is Nothing Then
        MsgBox "Select a stream first"
        Exit Sub
    End If
    
    Dim b() As Byte
    Dim pth As String
    Dim pf As String
    Dim f As Long
    Dim c As CPDFStream
    
    pf = GetParentFolder(txtPDFPath)
    GetActiveData lv2.SelectedItem, , c
    
    b() = StrConv(c.OriginalData, vbFromUnicode, LANG_US)
    pth = dlg.SaveDialog(AllFiles, pf, "Save Stream", , Me.hwnd, "error_stream_0x" & Hex(c.startOffset) & ".txt")
    
    If Len(pth) = 0 Then Exit Sub
    
    f = FreeFile
    If Dir(pth) <> "" Then Kill pth
    Open pth For Binary As f
    Put f, , b()
    Close f

    MsgBox "Error Stream Saved to file: " & vbCrLf & vbCrLf & pth, vbInformation
    
    
End Sub

'Private Sub mnuExtractHexDump_Click()
'
'    On Error Resume Next
'    Dim x, tmp, i, first, last
'
'    If Len(he.SelText) > 0 Then
'        x = he.SelText
'    Else
'        x = he.Text
'    End If
'
'    'handles extraction from these cases
'    'a = "000000   3C 3C 0D 0A 09 2F 54 79 70 65 2F 41 63 74 69 6F    <<.../Type/Actio"
'    'b = "3C 3C 0D 0A 09 2F 54 79 70 65 2F 41 63 74 69 6F    <<.../Type/Actio"
'    'c = "3C 3C 0D 0A 09 2F 54 79 70 65 2F 41"
'    'd = "000   3C 3C 0D 0A 09 2F 54 79 70 65 2F 41 63 74 69 6F    <<."
'
'    tmp = Split(x, vbCrLf)
'    For i = 0 To UBound(tmp)
'        tmp(i) = Trim(tmp(i))
'        first = InStr(tmp(i), "   ")
'        last = InStr(tmp(i), "    ")
'
'        If first > 0 And first <> last Then
'            tmp(i) = Mid(tmp(i), first + 1)
'        End If
'
'        last = InStr(tmp(i), "    ")
'        If last > 0 Then
'            tmp(i) = Mid(tmp(i), 1, last)
'        End If
'
'        tmp(i) = Replace(tmp(i), " ", Empty)
'
'    Next
'
'    he.Text = Join(tmp, "")
'
'End Sub

Private Sub mnuExtractHexFromParan_Click()

    txtUncompressed.Text = ExtractFromParanthesisPageEncapsulation(txtUncompressed.Text)
    
End Sub

Private Sub mnuFilters_Click()
    frmManualFilters.Show
End Sub

Private Sub mnuHexEditor_Click()
    Dim h As String
    Dim f As CHexEditor
    
    If Len(txtPDFPath.Text) = 0 Then Exit Sub
    If txtPDFPath.Text = "Drag and drop pdf file here" Then Exit Sub
    
    If Not fso.FileExists(txtPDFPath.Text) Then
        MsgBox "Could not find file: " & txtPDFPath.Text, vbExclamation
        Exit Sub
    End If
    
    If mnuUseInternalHexeditor.Checked Then
        Set f = New CHexEditor
        f.Editor.LoadFile txtPDFPath.Text
        Exit Sub
    End If
    
    h = GetMySetting("hexeditor")
    If Len(h) = 0 Or Not fso.FileExists(h) Then
        If MsgBox("You have not yet configured which hexeditor to use select it now?", vbYesNo) = vbNo Then Exit Sub
        h = dlg.OpenDialog(exeFiles, , "Select hexeditor to use", Me.hwnd)
        If fso.FileExists(h) Then
            SaveMySetting "hexeditor", h
        Else
            Exit Sub
        End If
    End If
    
    On Error Resume Next
    Shell h & " """ & txtPDFPath.Text & """", vbNormalFocus
    
    If Err.Number <> 0 Then MsgBox Err.Description
    
End Sub

Private Sub mnuHideUnselected_Click()
    
    On Error Resume Next
    Dim i As Long
    
    For i = lv.ListItems.count To 1 Step -1
        If lv.ListItems(i).Selected = False Then
            lv.ListItems.Remove i
        End If
    Next
    
End Sub

Private Sub mnuLoadAutomationScript_Click()
    
    Dim f As String
    dlg.SetCustomFilter "VBScripts", "*.vbs"
    f = dlg.OpenDialog(CustomFilter, App.path & "\scripts\", "Load automation script", Me.hwnd)
    If Len(f) = 0 Then Exit Sub
    RunAutomationScript f
    
End Sub

Private Sub mnuManualEscape_Click(Index As Integer)
    
    Dim activeObject As Object
    Dim ss As Long
    Dim hasSelection As Boolean
    
    On Error Resume Next
    
    Select Case ts.SelectedItem.Index
        Case 1: Set activeObject = txtUncompressed
        Case 2: MsgBox "You can not escape stuff on hex editor pane", vbInformation: Exit Sub
        Case 3: Set activeObject = txtDetails
    End Select
    
    Dim t As String
    t = activeObject.SelText
    If Len(t) = 0 Then
        'MsgBox "No text selected", vbInformation
        'Exit Sub
        hasSelection = False
    End If
    
    t = activeObject.Text
    If Len(t) = 0 Then Exit Sub
    
    ss = activeObject.SelStart
    
    Select Case Index
        Case 0: t = HexStringUnescape(t, , True)
        Case 1: t = HexStringUnescape(t, True, True)
        Case 2: t = unescape(t)
        Case 3: t = js_unescape(t)
        Case 4: t = nl_unescape(t)
        Case 5: t = pound_unescape(t)
        Case 6: t = octal_unescape(t)
        Case 7: t = EscapeHeader(t): t = VisualFormatHeader(t)
        
        Case 8: t = Replace(t, vbCr, Empty)
                t = Replace(t, vbLf, Empty)
                t = Replace(t, " ", Empty)
                t = Replace(t, vbTab, Empty)
                
        Case 9: t = ExtractValidHex(t)
        Case 10: t = ExtractValidHex(t, True)
        Case 11: t = AddPercentToHexString(t, True)
            
    End Select
    
    If hasSelection Then
        activeObject.SelText = t
        activeObject.SelStart = ss
        activeObject.SelLength = Len(t)
    Else
        activeObject.Text = t
    End If
    
 
End Sub

Private Sub mnuMarkStream_Click()
    
    If selli Is Nothing Then
        MsgBox "No stream selected"
        Exit Sub
    End If
    
    selli.ForeColor = &H808080
    
End Sub

Private Sub mnuSecureDownload_Click()
    Dim url As String
    Dim f As String
    Dim a As Long
    
    url = InputBox("Enter the URL you wish to download...")
    If Len(url) = 0 Then Exit Sub
    
    f = fso.WebFileNameFromPath(url)
    a = InStr(f, "?")
    If a > 2 Then f = Mid(f, 1, a - 1)
    
    f = dlg.SaveDialog(AllFiles, "", "Save file as...", False, Me.hwnd, f)
    If Len(f) = 0 Then Exit Sub
    
    If fso.FileExists(f) Then
        If MsgBox("This file already exists, Are you sure you want to overwrite it?", vbYesNo) = vbNo Then Exit Sub
        Kill f
    End If
    
    DownloadPath = f
    ucAsyncDownload1.StartDownload url, vbAsyncReadForceUpdate
    
End Sub

Private Sub mnuShowRawHeader_Click()
    
    If selli Is Nothing Then
        MsgBox "No stream selected"
        Exit Sub
    End If
    
    On Error Resume Next
    Dim s As CPDFStream
    Set s = selli.tag
    txtUncompressed.Text = s.Header
    ts.Tabs(1).Selected = True
    
End Sub

Private Sub mnuShowRawObject_Click()

    If selli Is Nothing Then
        MsgBox "No stream selected"
        Exit Sub
    End If
    
    On Error Resume Next
    Dim s As CPDFStream
    Set s = selli.tag
    txtUncompressed.Text = s.RawObject
    ts.Tabs(1).Selected = True
    
End Sub

Private Sub mnuSHowRawObject2_Click()
    mnuShowRawObject_Click
End Sub

Private Sub mnuUseInternalHexeditor_Click()
    mnuUseInternalHexeditor.Checked = Not mnuUseInternalHexeditor.Checked
End Sub

Private Sub mnuVisualFormatHeaders_Click()
    mnuVisualFormatHeaders.Checked = Not mnuVisualFormatHeaders.Checked
End Sub

Private Sub mnuDecrypt_Click()
    Dim newPath As String
    
    If csharp.Decrypt(txtPDFPath, newPath, "Encryption was not autodetected but flag could be obsfuscated want to try to decrypt anyway?") Then
        If MsgBox("Open now?", vbYesNo) = vbYes Then
            txtPDFPath = newPath
            cmdDecode_Click
        End If
    Else
        MsgBox "Error: " & newPath, vbInformation
    End If
    
End Sub

Private Sub mnuFindReplace_Click()
    
    Dim txtObj As Object
    
    Select Case ts.SelectedItem.Index
        Case 1: Set txtObj = txtUncompressed
        Case 3: Set txtObj = txtDetails
        
        Case 2:
                he.ShowFind
                Exit Sub
        
    End Select
    
    frmReplace.LaunchReplaceForm txtObj
    
End Sub

Private Sub mnuGotoObject_Click()
    Dim x
    Dim li As ListItem
    Dim s As CPDFStream
    
    x = InputBox("Enter Object number to jump to")
    If Len(x) = 0 Then Exit Sub
    
    For Each li In lv.ListItems
        Set s = li.tag
        If s.Index = x Then
            li.Selected = True
            li.EnsureVisible
            lv_ItemClick li
            Exit Sub
        End If
    Next
    
End Sub

Private Sub mnuHideDups_Click()
    
    Dim i As Long
    Dim s As CPDFStream
    Dim c As New Collection
    Dim h As Long
    
    'being called from code not from UI
    If Not surpressHideWarnings Then mnuHideDups.Checked = Not mnuHideDups.Checked
   
    If mnuHideDups.Checked = False Then
        cmdDecode_Click
    Else
        For i = lv.ListItems.count To 1 Step -1
            Set s = lv.ListItems(i).tag
            If s.ContainsStream Then
                If keyExists(s.OriginalDataCRC, c) Then
                    lv.ListItems.Remove i
                    h = h + 1
                Else
                    AddKey s.OriginalDataCRC, c
                End If
            Else
                If keyExists(s.HeaderCRC, c) Then
                    lv.ListItems.Remove i
                    h = h + 1
                Else
                    AddKey s.HeaderCRC, c
                End If
            End If
        Next
        If Not surpressHideWarnings Then MsgBox "Hid " & h & " duplicates", vbInformation
    End If
    
    lv.ColumnHeaders(1).Text = lv.ListItems.count & " Objects Shown"
    
End Sub

 
Private Sub mnuHideSelected_Click()
    
    On Error Resume Next
    Dim i As Long
    
    For i = lv.ListItems.count To 1 Step -1
        If lv.ListItems(i).Selected = True Then
            lv.ListItems.Remove i
        End If
    Next

End Sub


Private Sub mnuHideHeaderStreams_Click()
    
    Dim i As Long
    Dim s As CPDFStream
    Dim h As Long
    
    'being called manually not from UI
    If Not surpressHideWarnings Then mnuHideHeaderStreams.Checked = Not mnuHideHeaderStreams.Checked
   
    If mnuHideHeaderStreams.Checked = False Then
        cmdDecode_Click
    Else
        For i = lv.ListItems.count To 1 Step -1
            Set s = lv.ListItems(i).tag
            If s.startOffset = 0 Then ' no stream
                lv.ListItems.Remove i
                h = h + 1
            End If
        Next
        If Not surpressHideWarnings Then MsgBox "Hid " & h & " header only fields"
    End If
    
    lv.ColumnHeaders(1).Text = lv.ListItems.count & " Objects Shown"
                
    
End Sub



Public Sub mnuJavascriptUI_Click()
    Dim t As String
    Dim wasSelection As Boolean
    Dim li As ListItem
    Dim cs As CPDFStream
    
    On Error Resume Next
    
    Dim selCount As Long
    For Each li In lv.ListItems
        If li.Selected Then selCount = selCount + 1
    Next
    
    If selCount > 1 Then
        'multiple streams selected..put them all together for js ui
        For Each li In lv.ListItems
            If li.Selected Then
                t = t & GetActiveData(li, False) & vbCrLf
            End If
        Next
    Else
        If txtUncompressed.SelLength > 0 Then
            t = txtUncompressed.SelText
            wasSelection = True
        Else
            t = txtUncompressed.Text
        End If
    End If
    
    t = Form2.StandardizeLineBreaks(t)
    Form2.Show
    Form2.txtJS.Text = t
    
    'comment this out for codemax
    If wasSelection Then
        Form2.txtJS.SelStart = 0
        Form2.txtJS.SelLength = Len(t)
    End If
    
    Form2.mnuFunctionScan_Click
    
End Sub

Function looksEscaped(Header) 'as boolean
    
    Header = Replace(Header, "#20", " ") 'to common to include with low threshold
    If GetCount(Header, "#") > 2 Then looksEscaped = True
    If GetCount(Header, "\" & vbCrLf) > 1 Then looksEscaped = True
    If GetCount(Header, "\1") > 2 Then looksEscaped = True

End Function

Private Sub mnuSearchFilter_Click(Index As Integer)
    
    On Error Resume Next
    Dim li As ListItem
    Dim sli As ListItem
    Dim s As CPDFStream
    Dim match As Boolean
    
    Dim x
    lvSearch.ListItems.Clear
        
    If lv.ListItems.count = 0 And lv2.ListItems.count = 0 Then
        MsgBox "No streams loaded nothing to search!", vbCritical
        Exit Sub
    End If
    
    For Each li In lv.ListItems
        Set s = li.tag
        match = False
        If li.Selected Then li.Selected = False
        
        Select Case Index
            Case 0:   If AnyofTheseInstr(pound_unescape(s.Header), "/JS,/Javascript") Then match = True
            Case 1:   If s.ContentType = Flash Then match = True
            Case 2:   If s.ContentType = U3d Then match = True
            Case 3:   If s.ContentType = TTFFont Then match = True
            Case 4:   If li.ForeColor = vbGreen Then match = True
            Case 5:   If looksEscaped(s.Header) Then match = True
            Case 6:   If s.ContentType = prc Then match = True
            Case 7:   If s.ContentType = xml Then match = True
            Case 8:   If s.StreamDecompressor.GetActiveFiltersCount > 1 Then match = True
        End Select
                
        If match Then
            Set sli = lvSearch.ListItems.Add(, , li.Text)
            Set sli.tag = li.tag
            sli.Text = sli.Text & "   " & IIf(Index = 5, s.Header, pound_unescape(s.Header))
            li.Selected = True
        End If
        
    Next
    
    For Each li In lv2.ListItems
        Set s = li.tag
        match = False
        
        Select Case Index
            Case 0:   If AnyofTheseInstr(pound_unescape(s.Header), "/JS,/Javascript") Then match = True
            Case 1:   If s.ContentType = Flash Then match = True
            Case 2:   If s.ContentType = U3d Then match = True
            Case 3:   If s.ContentType = TTFFont Then match = True
            Case 4:   If li.ForeColor = vbGreen Then match = True
            Case 5:   If looksEscaped(s.Header) Then match = True
        End Select
                
        If match Then
            Set sli = lvSearch.ListItems.Add(, , li.Text)
            Set sli.tag = li.tag
            sli.Text = sli.Text & "   " & IIf(Index = 5, s.Header, pound_unescape(s.Header))
        End If
    Next
    
    'If lvSearch.ListItems.Count > 0 Then
        TabStrip1.Tabs(2).Selected = True
    'End If
    
    lvSearch.ColumnHeaders(1).Text = lvSearch.ListItems.count & " Search Results"
    
End Sub

 

Private Sub mnuUnescape_Click()
    
    On Error Resume Next
    Dim t As Object
    
    Select Case ts.SelectedItem.Index
        Case 1: Set t = txtUncompressed
        Case 3: Set t = txtDetails
        Case 2: MsgBox "Not valid on hex dump pane": Exit Sub
    End Select
    
    If t.SelLength = 0 Then Exit Sub
    
    If InStr(t.SelText, "%u") > 0 Then
        t.SelText = unescape(t.SelText)
    End If
    
    If InStr(t.SelText, "#") > 0 Then
        t.SelText = pound_unescape(t.SelText)
    End If
    
    If InStr(t.SelText, "\x") > 0 Then
        t.SelText = js_unescape(t.SelText)
    End If
    
    If InStr(t.SelText, "\n") > 0 Then
        t.SelText = nl_unescape(t.SelText)
    End If
        
    sc.Reset
    sc.AddObject "t", t, True
    sc.AddCode "t.SelText = unescape(t.SelText)"
    
    
End Sub

Private Sub mnuUpdateCurrent_Click()

    
    If lv.SelectedItem Is Nothing Then
        MsgBox "Select a stream first"
        Exit Sub
    End If
    
    Dim new_data As String
    Dim new_file As String
    Dim pf As String
    Dim f As Long
    Dim f2 As Long
    Dim stream As CPDFStream
    Dim msg As String
    Dim b() As Byte
    Dim new_bytes() As Byte
    Dim bOut() As Byte
    Dim i As Long
    
    'what if its not a stream and its just a header?
    
    GetActiveData lv.SelectedItem, False, stream
    
    If stream Is Nothing Then
        MsgBox "Could not get active stream?", vbCritical
        Exit Sub
    End If
    
    If Not stream.ContainsStream Then
        MsgBox "Selected item does not contain a stream...I guess i should update the header but I havent been programmed to do that yet."
        Exit Sub
    End If
    
    
    new_data = txtUncompressed.Text
    new_bytes() = StrConv(new_data, vbFromUnicode, LANG_US)
    
    If Not modZLIB.CompressData(new_bytes(), bOut()) Then
        MsgBox "Compression Failed", vbInformation
        Exit Sub
    End If

    new_bytes() = bOut()
    new_file = txtPDFPath & "_upd.pdf"
    
    Dim baseName As String
    Dim baseDir As String
    
    
    baseDir = fso.GetParentFolder(txtPDFPath)
    baseName = fso.GetBaseName(txtPDFPath)
    If VBA.right(baseName, 1) = "_" Then baseName = Mid(baseName, 1, Len(baseName) - 1)
    
    new_file = baseDir & "\" & baseName & ".u" & i
    While fso.FileExists(new_file)
        i = i + 1
        new_file = baseDir & "\" & baseName & ".u" & i
    Wend
    
    If stream.CompressedSize < UBound(new_bytes) Then
        msg = "Original Compressed Stream size was smaller than new data.." & vbCrLf & _
               "Org: " & Hex(stream.CompressedSize) & " New: " & Hex(UBound(new_bytes) + 1) & vbCrLf & vbCrLf & _
               "Are you sure you want to continue?"
    
        If MsgBox(msg, vbYesNo) = vbNo Then Exit Sub
    ElseIf stream.CompressedSize > UBound(new_bytes) Then
        'pad the extra space with new lines (ignored char)
        ReDim Preserve new_bytes(stream.CompressedSize - 1)
        For i = UBound(bOut) To UBound(new_bytes)
            new_bytes(i) = &HA
        Next
    
    End If
    



    f = FreeFile
    Open txtPDFPath For Binary As f
    
    f2 = FreeFile
    Open new_file For Binary As f2
    
    ReDim b(stream.startOffset - 1)
    Get f, , b() 'load the file up to the original stream
    Put f2, , b() 'save it to the new file
    
    Put f2, , new_bytes() 'save our new stream to new file
        
    ReDim b(LOF(f) - stream.EndOffset)
    Get f, stream.EndOffset + 1, b() 'load teh rest of the original file
    Put f2, , b() 'save rest of file to new file
    
    Close f
    Close f2
    
    txtPDFPath = new_file
    cmdDecode_Click
  
End Sub

Private Sub mnuWipeStream_Click()
     
     'currently wipes body ok, but couple bytes of header left to wipe that specify the object index..
     
     If lv.SelectedItem Is Nothing Then
        MsgBox "Select a stream first"
        Exit Sub
    End If
    
    Dim new_data As String
    Dim new_file As String
    Dim pf As String
    Dim f As Long
    Dim f2 As Long
    Dim stream As CPDFStream
    Dim msg As String
    Dim b() As Byte
    Dim new_bytes() As Byte
    Dim prevItem As ListItem
    Dim li As ListItem
    Dim prevStream As CPDFStream
    
    GetActiveData lv.SelectedItem, False, stream
    
    If stream Is Nothing Then
        MsgBox "Could not get active stream?", vbCritical
        Exit Sub
    End If
       
    For Each li In lv.ListItems
        If ObjPtr(li) = ObjPtr(lv.SelectedItem) Then Exit For
        Set prevItem = li
    Next
        
    new_file = txtPDFPath & "_upd.pdf"
    
    Dim baseName As String
    Dim baseDir As String
    Dim i As Long
    
    baseDir = fso.GetParentFolder(txtPDFPath)
    baseName = fso.GetBaseName(txtPDFPath)
    If VBA.right(baseName, 1) = "_" Then baseName = Mid(baseName, 1, Len(baseName) - 1)
    
    new_file = baseDir & "\" & baseName & ".u" & i
    While fso.FileExists(new_file)
        i = i + 1
        new_file = baseDir & "\" & baseName & ".u" & i
    Wend
    
    'new_file = dlg.SaveDialog(AllFiles, pf, "Save New PDF As", Me.hwnd, Me.hwnd, fso.FileNameFromPath(new_file))
    'If Len(new_file) = 0 Then Exit Sub
    
    'If new_file = txtPDFPath Then
    '    MsgBox "Sorry I can not overwrite file we are modifying", vbExclamation
    '    Exit Sub
    'End If
    
    If fso.FileExists(new_file) Then fso.DeleteFile new_file
    
    Dim totalSize As Long
    totalSize = stream.ObjectEndOffset - stream.ObjectStartOffset + 1
    new_data = String(totalSize, Chr(&H20))
    new_bytes() = StrConv(new_data, vbFromUnicode, LANG_US)
        
    f = FreeFile
    Open txtPDFPath For Binary As f
    
    f2 = FreeFile
    Open new_file For Binary As f2
    
    ReDim b(stream.ObjectStartOffset - 1)
    Get f, , b() 'load the file up to the original stream
    Put f2, , b() 'save it to the new file
    
    Put f2, , new_bytes() 'save our new stream to new file
    
    'ReDim b(stream.CompressedSize)
    'Get f, , b() 'advance file pointer size of orginal compressed data
    
    Dim sz As Long
    sz = LOF(f) - stream.ObjectEndOffset - 2
    If sz > 0 Then
        ReDim b(sz)
        Get f, stream.ObjectEndOffset + 2, b() 'load teh rest of the original file
        Put f2, , b() 'save rest of file to new file
    End If
        
    Dim remainder As Long
    If Not prevItem Is Nothing Then
        Set prevStream = prevItem.tag
        remainder = stream.ObjectStartOffset - prevStream.ObjectEndOffset
        If remainder > 0 Then
            b() = StrConv(String(remainder, Chr(&H20)), vbFromUnicode, LANG_US)
            Put f2, prevStream.ObjectEndOffset + 2, b()
        End If
    End If
    
    Close f
    Close f2
                
    If MsgBox("New PDF File Generated, would you like to load it now?", vbYesNo) = vbYes Then
        txtPDFPath = new_file
        cmdDecode_Click
    End If
    
 
End Sub

Private Sub mnuZlibBrute_Click()
    Dim f As New frmBruteZLib
    f.Show 'this way we can compare multiple files..
End Sub

Private Sub muLoadShellcode_Click()
    On Error Resume Next
    Form2.Show
    Form2.mnuLoadShellcode_Click
End Sub

Private Sub parser_Complete()
    On Error Resume Next
    pb.value = 0
End Sub

Private Sub IncProgressBar()
    On Error Resume Next
    pb.value = pb.value + 1
End Sub

Private Sub parser_DebugMessage(msg As String)
    On Error Resume Next
    lvDebug.ListItems.Add , , msg
End Sub

Private Sub parser_NewStream(stream As CPDFStream)
        
         
        DoEvents
        Me.Refresh
        DoEvents
        
        IncProgressBar
        
        Dim li As ListItem
        Dim h As String
        Dim totalSize As Long
        Dim ph_size As Long
        
        
        If Not stream.ContainsStream Then
            ph_size = Len(stream.Header)
            totalSize = stream.ObjectEndOffset - stream.ObjectStartOffset
            If ph_size + 100 < totalSize Then
                parser_DebugMessage "Stream " & stream.Index & " @ offset 0x" & Hex(stream.ObjectStartOffset) & " may be hiding something in its headers (parser bug) right click and use 'Show Raw Object'. Extra: 0x" & Hex(totalSize - ph_size) & " bytes detected"
            End If
        End If
        
        If Len(stream.Message) > 0 Then
            'add it to the error list
            Set li = lv2.ListItems.Add(, , "stream # " & stream.Index & " org sz = (0x" & Hex(Len(stream.RawObject)) & ")")
        ElseIf stream.startOffset > 0 Then
            Set li = lv.ListItems.Add(, , stream.Index & " 0x" & Hex(stream.startOffset) & "-0x" & Hex(stream.EndOffset))
            li.ForeColor = vbBlue
        Else
            If mnuHideHeaderStreams.Checked = False Then
                Set li = lv.ListItems.Add(, , stream.Index & " HLen: 0x" & Hex(Len(stream.Header)))
            End If
        End If
        
        If Not li Is Nothing Then
            Set li.tag = stream
            h = stream.escapedHeader
            
            If AnyofTheseInstr(h, "/Page ,/Page/") Then
                pageCount = pageCount + 1
            End If
            
            If stream.ContentType = Flash Then flashCount = flashCount + 1
            If stream.ContentType = TTFFont Then ttfCount = ttfCount + 1
            If stream.ContentType = U3d Then U3DCount = U3DCount + 1
            If stream.ContentType = prc Then PRCCount = PRCCount + 1
            
            'add some color highlighting in order of importance
            
            If stream.UsesUnsupportedFilter Or stream.StreamDecompressor.DecompressionError = True Then
                li.ForeColor = &H80FF&     'orange
                unspFilterCount = unspFilterCount + 1
                If stream.UsesUnsupportedFilter Then
                    li.ToolTipText = "Unsupported Filter " & stream.StreamDecompressor.GetActiveFiltersAsString()
                Else
                    li.ToolTipText = "Decompression Error: " & stream.StreamDecompressor.GetActiveFiltersAsString()
                End If
            ElseIf AnyofTheseInstr(h, "/JS,/Javascript") Then
                li.ForeColor = vbRed ' &H80&       'red
                jsCount = jsCount + 1
                li.ToolTipText = "Javascript Block"
                
            ElseIf stream.startOffset > 0 Then
                If stream.ContentType = TTFFont Then
                    li.ForeColor = &HFFFF&     'yellow
                    li.ToolTipText = "TTF Font"
                ElseIf stream.ContentType = xml Then
                    li.ForeColor = &HFF80FF
                    li.ToolTipText = "XML Data"
                Else
                    li.ForeColor = vbBlue ' &H400000    'blue
                    li.ToolTipText = "Data Stream"
                End If
                streamCount = streamCount + 1
                
            ElseIf AnyofTheseInstr(h, "/Action,/Launch,/AA,/OpenAction") Then
                li.ForeColor = vbGreen  '<-- this color is hardcoded in mnuSearchFilters too!
                ActionCount = ActionCount + 1
                li.ToolTipText = "Launch Action"
                
            ElseIf AnyofTheseInstr(h, "/EmbeddedFiles") Then
                li.ForeColor = &H800080    'purple
                EmbeddedFilesCount = EmbeddedFilesCount + 1
                li.ToolTipText = "Embedded File"
            End If
            
        End If

End Sub


Private Sub cmdBrowse_Click()
    Dim p As String
    AutomatationRun = False
    p = dlg.OpenDialog(AllFiles, RecommendedPath(), "Load PDF File", Me.hwnd)
    If Len(p) > 0 Then
        txtPDFPath = p
        cmdDecode_Click
    End If
End Sub

Private Function RecommendedPath() As String
    On Error Resume Next
    RecommendedPath = fso.GetParentFolder(Form1.txtPDFPath)
End Function

Private Sub Command1_Click()
        On Error Resume Next
        Call ShellExecute(Me.hwnd, "Open", txtPDFPath, "", "C:\", 1)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim f As Form
    On Error Resume Next
    
    'If defaultLCID <> LANG_US And defaultLCID <> 0 Then SetLocale defaultLCID
    
    parser.abort = True
    If fso.FileExists(txtPDFPath) Then SaveSetting App.EXEName, "Settings", "LastFile", txtPDFPath
    
    SaveMySetting "EscapeHeaders", IIf(mnuAutoEscapeHeaders.Checked, 1, 0)
    SaveMySetting "FormatHeaders", IIf(mnuVisualFormatHeaders.Checked, 1, 0)
    SaveMySetting "HideDups", IIf(mnuHideDups.Checked, 1, 0)
    SaveMySetting "HideHeaderOnlyStreams", IIf(mnuHideHeaderStreams.Checked, 1, 0)
    SaveMySetting "ShellButtonEnabled", IIf(mnuEnableShellButton.Checked, 1, 0)
    SaveMySetting "DisableDecomp", IIf(mnuDisableDecomp.Checked, 1, 0)
    SaveMySetting "DisableiText", IIf(mnuDisableiText.Checked, 1, 0)
    SaveMySetting "AlwaysUseZlib", IIf(mnuAlwaysUseZlib.Checked, 1, 0)
    SaveMySetting "OpenLastAtStart", IIf(mnuOpenLastAtStart.Checked, 1, 0)
    SaveMySetting "EnableJBIG2", IIf(mnuEnableJBIG2.Checked, 1, 0)
    SaveMySetting "UseInternalHexeditor", IIf(mnuUseInternalHexeditor.Checked, 1, 0)
    SaveMySetting "AutoSwitchTabs", IIf(mnuAutoSwitchTabs.Checked, 1, 0)
    
    FormPos Me, True, True
    
    Dim tmp As String
    tmp = App.path & "\tmp.bin"
    If fso.FileExists(tmp) Then Kill tmp
    
    For Each f In Forms
         Unload f
    Next
     
    End
    
End Sub

Private Sub lv_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    
    Dim stream As CPDFStream
    If Button = 2 And Not selli Is Nothing Then
        Set stream = selli.tag
        mnuDecompileFlash.enabled = IIf(stream.ContentType = Flash, True, False)
        PopupMenu mnuPopup
    End If
    
End Sub


Private Sub mnuCompress_Click()
    Dim base_file As String, out_file As String
    Dim tmp As String
    Dim b() As Byte
    Dim bOut() As Byte
    
    base_file = dlg.OpenDialog(AllFiles, , "Select File to compress", Me.hwnd)
    If Len(base_file) = 0 Then Exit Sub
    
    out_file = base_file & ".compressed"
    
    tmp = fso.ReadFile(base_file)
    b() = StrConv(tmp, vbFromUnicode, LANG_US)
    
    If Not modZLIB.CompressData(b(), bOut()) Then
        MsgBox "Compression Failed", vbInformation
        Exit Sub
    End If
    
    Dim f As Long
    f = FreeFile
    Open out_file For Binary As f
    Put f, , bOut()
    Close f
    
    MsgBox "Compressed Data saved as " & vbCrLf & vbCrLf & out_file
    

End Sub

Private Sub mnuDecompress_Click()
    Dim base_file As String, out_file As String
    Dim tmp As String
    Dim b() As Byte
    Dim bOut() As Byte
    
    base_file = dlg.OpenDialog(AllFiles, , "Select File to compress", Me.hwnd)
    If Len(base_file) = 0 Then Exit Sub
    
    out_file = base_file & ".decompressed"
    
    tmp = fso.ReadFile(base_file)
    b() = StrConv(tmp, vbFromUnicode, LANG_US)
    
    If Not modZLIB.UncompressData(b(), bOut()) Then
        MsgBox "Decompression Failed", vbInformation
        Exit Sub
    End If
    
    Dim f As Long
    f = FreeFile
    Open out_file For Binary As f
    Put f, , bOut()
    Close f
    
    MsgBox "Deompressed Data saved as " & vbCrLf & vbCrLf & out_file
    

End Sub


Public Sub cmdDecode_Click()
    
    On Error Resume Next
    Dim li As ListItem
    Dim startTime As Long
    Dim endTime As Long
    
     
    Status = stProcessing
    startTime = GetTickCount()
    
    streamCount = 0
    jsCount = 0
    EmbeddedFilesCount = 0
    pageCount = 0
    ttfCount = 0
    U3DCount = 0
    flashCount = 0
    unspFilterCount = 0
    ActionCount = 0
    PRCCount = 0
    
    Set parser = Nothing
    Set parser = New CPdfParser
    
    txtDetails.Text = Empty
    txtUncompressed.Text = Empty
    he.LoadString "", True
    lv.ListItems.Clear
    lv2.ListItems.Clear
    lvSearch.ListItems.Clear
    lvSearch.ColumnHeaders(1).Text = "Search Results"
    lvDebug.ListItems.Clear
    
    If Not FileExists(txtPDFPath) Then GoTo end_of_func
    
    'If MsgBox("Use new parser?", vbYesNo) = vbYes Then
        parser.ParseFile txtPDFPath 'optimized by a factor of 15x - 800k file was 130sec, now 9..
    'Else
    '    parser.Old_ParseFile txtPDFPath
    'End If
    
    If lv.ListItems.count = 0 And lv2.ListItems.count = 0 Then
       'MsgBox "No stream markers found in this file", vbInformation
       GoTo end_of_func
    End If
    
    lv.ColumnHeaders(1).Text = lv.ListItems.count & " Objects"
    lv2.ColumnHeaders(1).Text = lv2.ListItems.count & " Decompression Errors"
    
    With StatusBar
        .Panels(1).Text = "Streams:" & streamCount
        .Panels(2).Text = "JS: " & jsCount
        .Panels(3).Text = "Embeds: " & EmbeddedFilesCount
        .Panels(4).Text = "Pages: " & pageCount
        .Panels(5).Text = "TTF: " & ttfCount
        .Panels(6).Text = "U3D: " & U3DCount
        .Panels(7).Text = "flash: " & flashCount
        .Panels(8).Text = "UnkFlt: " & unspFilterCount
        .Panels(9).Text = "Action: " & ActionCount
        .Panels(10).Text = "PRC: " & PRCCount
    End With
    
    surpressHideWarnings = True
    If mnuHideDups.Checked = True Then mnuHideDups_Click
    If mnuHideHeaderStreams.Checked Then mnuHideHeaderStreams_Click
    surpressHideWarnings = False
    
    
end_of_func:

    On Error Resume Next
    Dim x As Procedure
    If AutomatationRun Then
    
        Me.Refresh
        DoEvents
        DoEvents
        
        For Each x In scAuto.Procedures
            If LCase(x.name) = "decode_complete" Then
                scAuto.eval "Decode_Complete()"
                Exit For
            End If
        Next
        
        
    End If
    
    Dim fSize As Long
    Dim szName As String
    
    Status = stComplete
    endTime = GetTickCount()
    LoadTime = endTime - startTime
    fSize = FileLen(txtPDFPath)
    
    szName = " bytes"
    If fSize > 1024 Then
        fSize = fSize / 1024
        szName = " Kb"
    End If
    
    If fSize > 1024 Then
        fSize = fSize / 1024
        szName = " Mb"
    End If
    
    Me.Caption = "PDFStreamDumper  - http://sandsprite.com     FileSize: " & fSize & szName & _
                 "    LoadTime: " & LoadTime / 1000 & " seconds"
    
    Dim oBrowser As Object
    Set oBrowser = GetObject("", "obj_Browser.plugin") 'not much of a plugin is it! more of a lib at this point :P
    oBrowser.initasLib Me
    
    If Not csharp.Initilized Then lvDebug.ListItems.Add , , "C# Filters not initilized. See Tools->Manual Filters and click on iText Filters = false link"
    
    TabStrip1.Tabs(3).Caption = "Debug" & IIf(lvDebug.ListItems.count > 0, " (" & lvDebug.ListItems.count & ")", "")
    
    If Len(ExtractToFolder) > 0 Then ExtractTo ExtractToFolder
        
            
        
        
End Sub

Function ExtractTo(folder As String)
    Dim li As ListItem
    Dim s As CPDFStream
    Dim d As String
    Dim pth As String
    
    If Not fso.FolderExists(folder) Then
            If Not fso.buildPath(folder) Then Exit Function
    End If
    
    For Each li In lv.ListItems
        Set s = li.tag
        d = Empty
        If s.ContainsStream And Not s.UsesUnsupportedFilter Then
            'If s.ContentType <> Unknown Then
                If s.isCompressed Then
                    d = s.DecompressedData
                Else
                    d = s.OriginalData
                End If
            'End If
        End If
        If Len(d) > 0 Then
            pth = folder & "\stream_" & Hex(s.Index) & s.FileExtension
            fso.writeFile pth, d
        End If
    Next
            
    On Error Resume Next
    
    For Each li In lv2.ListItems 'all the error streams..(probably images with JPX or DTCDecode)
        Set s = li.tag
        d = Empty
        If s.ContainsStream Then
            d = s.OriginalData
        End If
        If Len(d) > 0 Then
            pth = folder & "\Error_stream_" & Hex(s.Index) & s.FileExtension
            fso.writeFile pth, d
        End If
    Next
    
    End
    
End Function

Function AryIsEmpty(ary) As Boolean
    On Error GoTo hell
    Dim x
    x = UBound(ary)
    AryIsEmpty = False
    Exit Function
hell: AryIsEmpty = True
End Function




Private Sub mnuExploitScan_Click()
    
    Dim li As ListItem
    Dim c As CPDFStream
    Dim data As String
    Dim p() As String
    Dim report() As String
    Dim i As Long
    
    On Error Resume Next
    
    For Each li In lv.ListItems
        data = GetActiveData(li, False, c)
        For i = 0 To UBound(exploits)
            p() = Split(exploits(i), "=")
            If ContainsExploit(data, p(1), , c) Then
                push report, "Exploit " & p(0) & " - " & p(1) & " - found in stream: " & c.Index
            End If
        Next
    Next
    
    For Each li In lv2.ListItems
        data = GetActiveData(li, False, c)
        For i = 0 To UBound(exploits)
            p() = Split(exploits(i), "=")
            If ContainsExploit(data, p(1), , c) Then
                push report, "Exploit " & p(0) & " found in stream " & c.Index
            End If
        Next
    Next
    
    'also scan main textbox
    For i = 0 To UBound(exploits)
            p() = Split(exploits(i), "=")
            If ContainsExploit(txtUncompressed, p(1)) Then
                push report, "Exploit " & p(0) & " - " & p(1) & " - found in main textbox"
            End If
    Next
        
    If InStr(Join(report, ""), "flash") > 0 Then
        push report, vbCrLf & "Possible Flash CVE's: " & vbCrLf & String(50, "-") & vbCrLf & Join(flash_exploits, vbCrLf)
    End If
    
    push report, vbCrLf & "Note other exploits may be hidden with javascript obsfuscation"
    push report, "It is also possible these functions are being used in a non-exploit way."

    
    Dim tmp As String
    tmp = fso.GetFreeFileName(Environ("temp"))
    fso.writeFile tmp, Join(report, vbCrLf)
    Shell "notepad.exe """ & tmp & """", vbNormalFocus
    
    
    
        
    
End Sub

Private Sub mnuFormatJS_Click()
    
    On Error GoTo hell
    Dim js As String
    
    js = fso.ReadFile(App.path & "\beautify.js")
    
    sc.Reset
    sc.AddCode js
    sc.AddObject "txtUncompressed", txtUncompressed, True
    sc.AddCode "txtUncompressed.text = js_beautify(txtUncompressed.text, {indent_size: 1, indent_char: '\t'}).split('\n').join('\r\n');"
    
    
    'DevControl.Text = Replace(DevControl.Text, vbLf, vbCrLf)

Exit Sub
hell:

MsgBox Err.Description

End Sub

'Function RunLZWDecompress() As String
'
'    On Error GoTo hell
'    Dim js As String
'
'    js = fso.ReadFile(App.path & "\lzwjs.js")
'
'    sc.Reset
'    sc.AddCode js
'    sc.AddObject "txtUncompressed", txtUncompressed, True
'
'    txtUncompressed.Text = "THIS IS MY TEST MESSAGE"
'    sc.AddCode "txtUncompressed.text = lzwCompress(txtUncompressed.text);"
'
'    Dim tmp, x, y
'
'
'    MsgBox "Compressed"
'    sc.AddCode "txtUncompressed.text = lzwDecompress(txtUncompressed.text);"
'
'Exit Function
'hell:
'    MsgBox "Error in RunLZWDecompress: " & Err.Description
'End Function

Private Sub mnuLoadFile_Click()
    cmdBrowse_Click
End Sub

Private Sub mnuReplaceStream_Click()
    
    'here is the money shot
    
    If lv.SelectedItem Is Nothing Then
        MsgBox "Select a stream first"
        Exit Sub
    End If
    
    Dim new_data As String
    Dim new_file As String
    Dim pf As String
    Dim f As Long
    Dim f2 As Long
    Dim stream As CPDFStream
    Dim msg As String
    Dim b() As Byte
    Dim new_bytes() As Byte
    
    GetActiveData lv.SelectedItem, False, stream
    
    If stream Is Nothing Then
        MsgBox "Could not get active stream?", vbCritical
        Exit Sub
    End If
    
    If stream.ContainsStream = False Then
        MsgBox "Selected item does not contain a stream...I guess i should update the header but I havent been programmed to do that yet."
        Exit Sub
    End If
    
    
    pf = GetParentFolder(txtPDFPath)
    new_file = dlg.OpenDialog(AllFiles, pf, "Open Compressed Replacement Stream", Me.hwnd)
    If Len(new_file) = 0 Then Exit Sub
    
    new_data = fso.ReadFile(new_file)
    new_bytes() = StrConv(new_data, vbFromUnicode, LANG_US)
    
    If MsgBox("Do i need to compress this file before inserting it?", vbYesNo) = vbYes Then
        Dim tmp_bytes() As Byte
        If Not modZLIB.CompressData(new_bytes(), tmp_bytes()) Then
            MsgBox "Compression failed!", vbExclamation
            Exit Sub
        End If
        new_bytes() = tmp_bytes()
    End If
    
    msg = "Original Compressed Stream size: " & Hex(stream.CompressedSize) & vbCrLf & _
          "New stream file size: " & Hex(UBound(new_bytes)) & vbCrLf & vbCrLf & _
          "Are you sure you want to continue?"
    
    If MsgBox(msg, vbYesNo) = vbNo Then Exit Sub
    
    new_file = dlg.SaveDialog(AllFiles, pf, "Save New PDF As", , Me.hwnd)
    If Len(new_file) = 0 Then Exit Sub
    
    f = FreeFile
    Open txtPDFPath For Binary As f
    
    f2 = FreeFile
    Open new_file For Binary As f2
    
    ReDim b(stream.startOffset - 1)
    Get f, , b() 'load the file up to the original stream
    Put f2, , b() 'save it to the new file
    
    Put f2, , new_bytes() 'save our new stream to new file
    
    'ReDim b(stream.CompressedSize)
    'Get f, , b() 'advance file pointer size of orginal compressed data
    
    ReDim b(LOF(f) - stream.EndOffset)
    Get f, stream.EndOffset + 1, b() 'load teh rest of the original file
    Put f2, , b() 'save rest of file to new file
    
    Close f
    Close f2
    
    MsgBox "You may have to edit the stream sizes in the obj header I didnt do this. Use the data from the details pane to determine offsets and sizes." & vbCrLf & vbCrLf & _
            "This streams header is: " & vbCrLf & vbCrLf & stream.Header, vbInformation
            
    If MsgBox("New PDF File Generated, would you like to load it now?", vbYesNo) = vbYes Then
        txtPDFPath = new_file
        cmdDecode_Click
    End If
    
End Sub

Private Sub mnuSaveAllRaw_Click()
    
    Dim b() As Byte
    Dim li As ListItem
    Dim pf As String
    Dim f As Long
    Dim pth As String
    Dim c As CPDFStream
    
    pf = GetParentFolder(txtPDFPath)
    
    For Each li In lv.ListItems
        GetActiveData li, False, c
        b() = StrConv(c.OriginalData, vbFromUnicode, LANG_US)
        f = FreeFile
        pth = pf & "raw_stream_" & safe(li.Text)
        If Dir(pth) <> "" Then Kill pth
        Open pth For Binary As f
        Put f, , b()
        Close f
    Next
    
    For Each li In lv2.ListItems
        GetActiveData li, False, c
        b() = StrConv(c.OriginalData, vbFromUnicode, LANG_US)
        f = FreeFile
        pth = pf & "raw_error_" & safe(li.Text)
        If Dir(pth) <> "" Then Kill pth
        Open pth For Binary As f
        Put f, , b()
        Close f
    Next
    
    MsgBox lv.ListItems.count & " Streams dumped to " & pf, vbInformation
    
End Sub

Private Sub mnuSaveStream_Click()

    If lv.SelectedItem Is Nothing Then
        MsgBox "Select a stream first"
        Exit Sub
    End If
    
    Dim b() As Byte
    Dim pth As String
    Dim pf As String
    Dim f As Long
    Dim c As CPDFStream
    
    pf = GetParentFolder(txtPDFPath)
        
    b() = StrConv(GetActiveData(lv.SelectedItem, , c), vbFromUnicode, LANG_US)
    
    pth = dlg.SaveDialog(AllFiles, pf, "Save Stream", , Me.hwnd, "decomp_stream_0x" & Hex(c.startOffset) & ".txt")
    
    If Len(pth) = 0 Then Exit Sub
    
    f = FreeFile
    If Dir(pth) <> "" Then Kill pth
    Open pth For Binary As f
    Put f, , b()
    Close f

    MsgBox "Stream Saved to file: " & vbCrLf & vbCrLf & pth, vbInformation

    
End Sub

Private Sub mnusSaveRawStream_Click()

    If lv.SelectedItem Is Nothing Then
        MsgBox "Select a stream first"
        Exit Sub
    End If
    
    Dim b() As Byte
    Dim pth As String
    Dim pf As String
    Dim f As Long
    Dim c As CPDFStream
    
    pf = GetParentFolder(txtPDFPath)
    GetActiveData lv.SelectedItem, False, c
    
    pth = dlg.SaveDialog(AllFiles, pf, "Save Raw Stream", , Me.hwnd, "raw_stream_0x" & Hex(c.startOffset) & ".txt")
    If Len(pth) = 0 Then Exit Sub
  
    b() = StrConv(c.OriginalData, vbFromUnicode, LANG_US)
    
    f = FreeFile
    If Dir(pth) <> "" Then Kill pth
    Open pth For Binary As f
    Put f, , b()
    Close f

    MsgBox "Raw Stream Saved to file: " & vbCrLf & vbCrLf & pth, vbInformation

End Sub


Private Sub mnuSaveAllStreams_Click()
    
    Dim b() As Byte
    Dim li As ListItem
    Dim pf As String
    Dim f As Long
    Dim pth As String
    
    pf = GetParentFolder(txtPDFPath)
    
    For Each li In lv.ListItems
        b() = StrConv(GetActiveData(li), vbFromUnicode, LANG_US)
        f = FreeFile
        pth = pf & "stream_" & safe(li.Text)
        If Dir(pth) <> "" Then Kill pth
        Open pth For Binary As f
        Put f, , b()
        Close f
    Next
    
    For Each li In lv2.ListItems
        b() = StrConv(GetActiveData(li), vbFromUnicode, LANG_US)
        f = FreeFile
        pth = pf & "error_" & safe(li.Text)
        If Dir(pth) <> "" Then Kill pth
        Open pth For Binary As f
        Put f, , b()
        Close f
    Next
    
    MsgBox lv.ListItems.count & " Streams dumped to " & pf, vbInformation
    
End Sub

Function GetActiveData(Item As ListItem, Optional load_ui As Boolean = False, Optional ret_Stream As CPDFStream) As String
    On Error Resume Next
    Dim s As CPDFStream
    Dim d As String
    Dim xx As String
    
    Set s = Item.tag
    Set ret_Stream = s
    
    'use err message to determine if decompress was successful or not (or len s.decomdata huh?)
        
    If Len(s.Message) > 0 Then
        d = s.OriginalData
    ElseIf s.ContainsStream Then
        If mnuDisableDecomp.Checked Then
            d = s.OriginalData
        Else
            If s.isCompressed Then
                d = s.DecompressedData
            Else
                d = s.OriginalData
            End If
        End If
    Else
        d = s.GetHeaderWithViewOptions()
    End If
        
    If load_ui Then

         If Len(d) < &H2000 Then
            txtUncompressed.Text = Replace(d, Chr(0), ".") 'this can cause a hang on large blobs...
         Else
            txtUncompressed.Text = Empty
            If s.isBinary Then
                txtUncompressed.Text = "[Binary data --- see hexdump ---  type: " + s.FileType + " ]"
            Else
                txtUncompressed.Text = d
            End If
         End If
         
         he.LoadString CStr(d), True
         txtDetails.Text = s.GetDetailsReport()
         
         If mnuAutoSwitchTabs.Checked And ts.SelectedItem.Index <> 3 Then 'and not viewing headers pane..
            ts.Tabs(IIf(s.isBinary, 2, 1)).Selected = True
         End If
         
    End If
        
    GetActiveData = d
    
End Function

Function safe(ByVal x) As String
    x = Replace(x, "#", Empty)
    x = Replace(x, " ", "_")
    x = Replace(x, "(", Empty)
    x = Replace(x, ")", Empty)
    x = Replace(x, ":", "_")
    safe = x
End Function

Private Sub mnuAbout_Click()
    On Error Resume Next
    frmAbout.Show 1, Me
End Sub

Private Sub mnuSearch_Click()
    On Error Resume Next
    Dim li As ListItem
    Dim sli As ListItem
    Dim s As CPDFStream
    
    Dim x
    lvSearch.ListItems.Clear
        
    If lv.ListItems.count = 0 And lv2.ListItems.count = 0 Then
        MsgBox "No streams loaded nothing to search!", vbCritical
        Exit Sub
    End If
    
    x = InputBox("Enter text to search for")
    If Len(x) = 0 Then Exit Sub
    For Each li In lv.ListItems
        Set s = li.tag
        If InStr(1, GetActiveData(li), x, vbTextCompare) > 0 Then
            Set sli = lvSearch.ListItems.Add(, , li.Text)
            Set sli.tag = li.tag
        End If
        If InStr(1, s.escapedHeader, x, vbTextCompare) > 0 Then
            Set sli = lvSearch.ListItems.Add(, , li.Text)
            Set sli.tag = li.tag
        End If
    Next
    
    For Each li In lv2.ListItems
        If InStr(1, GetActiveData(li), x, vbTextCompare) > 0 Then
            Set sli = lvSearch.ListItems.Add(, , li.Text)
            Set sli.tag = li.tag
        End If
    Next
    
    If lvSearch.ListItems.count > 0 Then
        TabStrip1.Tabs(2).Selected = True
    Else
        MsgBox "0 Search Results", vbInformation
    End If
    
    lvSearch.ColumnHeaders(1).Text = lvSearch.ListItems.count & " Search Results"
    

End Sub

Private Sub Form_Load()
    On Error Resume Next
    Dim f As String
    Dim x As String
    
    Dim zlib As String
    Dim mupdf As String

    mnuPopup.Visible = False
    mnuPopup2.Visible = False
    mnuSearchPopup.Visible = False
    
    zlib = App.path & "\zlib.dll" 'this way they are always found even when running in IDE..
    mupdf = App.path & "\mupdf.dll"
    
    If fso.FileExists(zlib) Then
        If LoadLibrary(zlib) = 0 Then lvDebug.ListItems.Add "zlib.dll failed to initilize"
    Else
        lvDebug.ListItems.Add "Could not find zlib.dll"
    End If
    
    If fso.FileExists(mupdf) Then
        If LoadLibrary(mupdf) = 0 Then lvDebug.ListItems.Add "mupdf.dll failed to initilize"
    Else
         lvDebug.ListItems.Add "Could not find mupdf.dll"
    End If
    
    Set parser = New CPdfParser
    
    exploits = Array("CVE-2007-5020 Date:10.22.07 v8.1=mailto:%/..", _
                     "CVE-2007-5659 Date:5.6.08 v8.1.1=collectEmailInfo", _
                     "CVE-2008-2992 Date:11.4.08 v8.1.2=util.printf", _
                     "CVE-2009-0927 Date:3.18.09 v9.0=getIcon", _
                     "CVE-2009-1492 Date:5.12.09 v9.1=getAnnots", _
                     "CVE-2009-1493 Date:5.12.09 v9.1=customDictionaryOpen", _
                     "CVE-2009-4324 Date:12.15.09 v9.2=media.newPlayer", _
                     "Contains JBIG2Decode Stream Filter possible CVE-2009-0658 (Date:3.10.09 ver<9.1)=filteris:JBIG2Decode", _
                     "Contains U3D file - possible CVE-2009-4324(v9.1.3) or CVE-2011-2462(Date:12.16.11 v9.4.6) =^U3D", _
                     "Contains flash file=^CWS", _
                     "Contains flash file=^FWS", _
                     "Contains embedded image/tif, - possible CVE-2010-0188 Date:2.32.10 v9.3=image/tif", _
                     "Header contains a Launch Action - possible CVE-2010-1240 Date:6.29.10 v9.3.2=*/Launch*/Action*", _
                     "Header contains a Launch Action - possible CVE-2010-1240 Date:6.29.10 v9.3.2=*/Action*/Launch*", _
                     "CVE-2010-4091 Date:11.4.10 v9.2 or v8.1.7=printSeps", _
                     "CVE-2010-0188 Date:2.32.10 v9.3=rawValue", _
                     "Contains PRC file - possible CVE-2011-4369 (Date:12.16.11 v9.4.6)=^PRC", _
                     "CVE-2012-0775 Date: 4.10.2012 v10.1.2, or CVE-2013-3346 Date: 8.8.13 v10.1.6=addToolButton" _
                     )
                     
                     'is just using the JBIG2 Filter to generic to detect on?


    flash_exploits = Array("CVE-2010-1297 Fixed in ver:10.1.53.64 Desc: newfunction", _
                           "CVE-2010-2884 VulnVer: 10.1.82.76", _
                           "CVE-2010-3654 VulnVer: 10.1.85.3", _
                           "CVE-2011-0609 VulnVer: 10.2.152.32", _
                           "CVE-2011-0611 VulnVer: 10.2.153.1", _
                           "CVE-2011-0627 VulnVer: 10.2.159.1", _
                           "CVE-2011-2110 VulnVer: 10.3.181.14", _
                           "CVE-2012-0779 VulnVer: 11.2.202.233", _
                           "CVE-2012-1535 VulnVer: 11.3.300.270", _
                           "Many other CVEs are possible, this is the common list." _
                     )
                     
    help_vids = Array("Readme file;[readme]", _
                      "Note on help videos;[video_help]", _
                      "Introduction (40min);http://sandsprite.com/CodeStuff/PdfStreamDumper_trainer.wmv", _
                      "Pdf Analysis>", _
                      "    arguments.callee encrypted script 1 (14min); http://www.youtube.com/watch?v=UWeAom4La6g", _
                      "    getAnnots (10min);http://youtu.be/tJDiGYsN0FM", _
                      "    getPageNthWord (10min);http://youtu.be/JLxNdi2G72U", _
                      "    URL Decoder(8min);http://youtu.be/HgXrUPjgdSs", _
                      "    arguments.callee encrypted script 2 (10min); http://sandsprite.com/CodeStuff/Encrypted_Script2.wmv", _
                      "Shellcode> ", _
                      "    scdbg Trainer 1 - General Use; http://www.youtube.com/watch?v=jFkegwFasIw", _
                      "    scdbg Trainer 2 - Asm/Debug Shell; http://www.youtube.com/watch?v=HZE2c_If6hU", _
                      "    sclog gui; http://www.youtube.com/watch?v=XBcmC4jYiRI", _
                      "    shellcode_2_exe; http://www.youtube.com/watch?v=WEMK-Wmlyi0", _
                      "Misc> ", _
                      "    Adobe Api Support(10min);http://sandsprite.com/CodeStuff/Adobe_Api_Support.wmv", _
                      "    Sample Database Search Plugin (11min);http://sandsprite.com/CodeStuff/database_search_plugin.wmv", _
                      "    plugin developers and script writers (17min);http://sandsprite.com/CodeStuff/PDFStreamDumper_automation.wmv" _
                )


    Dim vid, i
    For Each vid In help_vids
        vid = Split(vid, ";")
        i = mnuHelp.count
        Load mnuHelp(i)
        mnuHelp(i).Caption = vid(0)
        mnuHelp(i).tag = Trim(vid(1))
    Next
    
    mnuDebugBreakAtStream.Visible = isIde()
    mnuWipeStream.Visible = isIde()
    
    mnuAutoEscapeHeaders.Checked = IIf(GetMySetting("EscapeHeaders", 1) = 1, True, False)
    mnuVisualFormatHeaders.Checked = IIf(GetMySetting("FormatHeaders", 1) = 1, True, False)
    mnuHideDups.Checked = IIf(GetMySetting("HideDups", 0) = 1, True, False)
    mnuHideHeaderStreams.Checked = IIf(GetMySetting("HideHeaderOnlyStreams", 0) = 1, True, False)
    mnuEnableShellButton.Checked = IIf(GetMySetting("ShellButtonEnabled", 0) = 1, True, False)
    mnuDisableDecomp.Checked = IIf(GetMySetting("DisableDecomp", 0) = 1, True, False)
    mnuDisableiText.Checked = IIf(GetMySetting("DisableiText", 0) = 1, True, False)
    mnuAlwaysUseZlib.Checked = IIf(GetMySetting("AlwaysUseZlib", 0) = 1, True, False)
    mnuOpenLastAtStart.Checked = IIf(GetMySetting("OpenLastAtStart", 0) = 1, True, False)
    mnuEnableJBIG2.Checked = IIf(GetMySetting("EnableJBIG2", 0) = 1, True, False)
    mnuUseInternalHexeditor.Checked = IIf(GetMySetting("UseInternalHexeditor", 1) = 1, True, False)
    mnuAutoSwitchTabs.Checked = IIf(GetMySetting("AutoSwitchTabs", 1) = 1, True, False)
    
    lv2.ColumnHeaders(1).Width = lv2.Width - 100
    lv.ColumnHeaders(1).Width = lv.Width - 100
    lvSearch.ColumnHeaders(1).Width = lvSearch.Width - 100
    lvDebug.ColumnHeaders(1).Width = lvDebug.Width - 100
    lvSearch.Move lv2.left, lv2.Top
    lvDebug.Move lv2.left, lv2.Top
    txtUncompressed.Move he.left, he.Top, he.Width, he.height
    txtDetails.Move he.left, he.Top, he.Width, he.height
    FormPos Me, True
    
    LoadPlugins
    Me.Visible = True
    DoEvents
    Me.Refresh
    startup_complete = True
    
    'we cant set this, machine needs a reboot to apply...but i think this issue is fixed now?
    defaultLCID = GetLocale(UserMode)
    If defaultLCID <> LANG_US And defaultLCID <> 0 Then
        lvDebug.ListItems.Add , , "You may need to set Language Version for non-unicode programs to United States English"
        TabStrip1.Tabs(3).Selected = True
    End If
    
    If Not csharp.Initilized Then
        lvDebug.ListItems.Add , , "C# Filters not initilized. See Tools->Manual Filters and click on iText Enabled = false link"
        TabStrip1.Tabs(3).Selected = True
    End If
    

    If Len(command) > 0 Then 'handle files draged and droped on icon or on command line...
        If InStr(1, command, ".js", vbTextCompare) > 0 Or _
            InStr(1, command, ".as", vbTextCompare) > 0 _
        Then 'js files load in jseditor
            f = Replace(command, """", Empty)
            If fso.FileExists(f) Then
                x = fso.ReadFile(f)
                Form2.Show
                Form2.txtJS.Text = x
                Form2.mnuFunctionScan_Click
            End If
        ElseIf InStr(1, command, ".swf", vbTextCompare) > 0 Then 'its a flash file..
            Dim exe_path As String, exe As String, flashFile As String
            If Not isAS3Sorcerer_Installed(exe_path) Then Exit Sub
            exe = GetShortName(exe_path)
            flashFile = GetShortName(Replace(command, """", Empty))
            Shell exe & " " & flashFile
            End
        ElseIf InStr(1, command, ".vbs", vbTextCompare) > 0 Then 'vbs scripts run as automation scripts
            RunAutomationScript command
        ElseIf InStr(1, command, ".sc", vbTextCompare) > 0 Then  'sc files loaded as shellcode (expects binary input)
            'load a shellcode file for analysis
            f = Replace(command, """", Empty)
            If fso.FileExists(f) Then
                x = fso.ReadFile(f)
                x = HexDump(x, 1)
                x = AddPercentToHexString(x)
                Form2.Show
                Form2.txtJS.Text = x
                Form2.txtJS.SelectAll
            End If
        Else
            'assume its a pdf file for analysis.
            Dim tmp() As String
            If InStr(command, "/extract") Then
                tmp = Split(command, "/extract")
                txtPDFPath = Replace(Trim(tmp(0)), """", Empty)
                ExtractToFolder = Replace(Trim(tmp(1)), """", Empty)
            Else
                txtPDFPath = Replace(command, """", Empty)
            End If
            cmdDecode_Click
        End If
    Else
        'If mnuOpenLastAtStart.Checked Then
            txtPDFPath = GetSetting(App.EXEName, "Settings", "LastFile")
            'If fso.FileExists(txtPDFPath) Then cmdDecode_Click
            If Not fso.FileExists(txtPDFPath) Then txtPDFPath = Empty
        'End If
    End If
    
End Sub

Private Function RunAutomationScript(pth)
    On Error Resume Next
    Dim x As Procedure
    Dim main_found As Boolean
    Dim Decode_Complete_found As Boolean
    
    AutomatationRun = True
    
    scAuto.Reset
    
    'default = vbscript but we also support jscript
    If InStr(1, pth, ".js", vbTextCompare) > 0 Then scAuto.Language = "jscript"
        
     Me.Show
     Me.Visible = True
     Me.Refresh
    
    With scAuto
        .AddObject "Form1", Me, True
        .AddObject "dlg", dlg, True
        .AddCode fso.ReadFile(pth)
        
        For Each x In .Procedures
            If LCase(x.name) = "main" Then
                main_found = True
            ElseIf LCase(x.name) = "decode_complete" Then
                Decode_Complete_found = True
            End If
        Next
        
        'If Not Decode_Complete_found Then
        '    MsgBox "This script is not implemented properly, no Decode_Complete proceedure found", vbInformation
        'End If
        
        'this one is optional i guess
        If main_found Then scAuto.eval "main()"
        
    End With
    
End Function

Public Sub catch_up()
    DoEvents
    Me.Refresh
    DoEvents
End Sub

Public Sub lv_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    If selli Is Item Then Exit Sub
    Call GetActiveData(Item, True)
    Set selli = Item
    If fraPictViewer.Visible = True Then fraPictViewer.Visible = False
End Sub

Public Sub lv2_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    If selli Is Item Then Exit Sub
    Call GetActiveData(Item, True)
    Set selli = Item
    If fraPictViewer.Visible = True Then fraPictViewer.Visible = False
End Sub

Private Sub lvsearch_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    Dim ss As CPDFStream
    Dim s2 As CPDFStream
    Dim li As ListItem
    If selli Is Item Then Exit Sub
    Call GetActiveData(Item, True, ss)
    Set selli = Item
    For Each li In lv.ListItems
        Set s2 = li.tag
        If ObjPtr(s2) = ObjPtr(ss) Then
            li.EnsureVisible
            Exit For
        End If
    Next
    If fraPictViewer.Visible = True Then fraPictViewer.Visible = False
End Sub





Private Sub mnuViewExploitDetections_Click()
    
    Dim tmp As String
    Dim report As String
    
    report = Join(exploits, vbCrLf)
    report = Replace(report, "=", vbTab)
    report = report & vbCrLf & vbCrLf & "Flash CVE's: " & vbCrLf & String(50, "-") & vbCrLf & Join(flash_exploits, vbCrLf)
    report = report & vbCrLf & vbCrLf & flash_as_cveScan("cvelist")
    
    tmp = fso.GetFreeFileName(Environ("temp"))
    fso.writeFile tmp, report
    Shell "notepad.exe """ & tmp & """", vbNormalFocus
 
 
End Sub

Private Sub parser_SetObjectCount(cnt As Long)
    On Error Resume Next
    pb.max = cnt
    pb.value = 0
End Sub


Private Sub sc_Error()
    MsgBox "Script Error: " & sc.error.Description & "  " & sc.error.Text
End Sub

Private Sub scAuto_Error()
     MsgBox "Automation Script Error: " & scAuto.error.Description & vbCrLf & _
            "Line: " & scAuto.error.line & vbCrLf & _
            "Source: " & scAuto.error.Source & vbCrLf & _
            "Text: " & scAuto.error.Text
End Sub

Private Sub TabStrip1_Click()
    If TabStrip1.SelectedItem.Index = 1 Then
        lv2.Visible = True
        lvSearch.Visible = False
        lvDebug.Visible = False
    ElseIf TabStrip1.SelectedItem.Index = 2 Then
        lv2.Visible = False
        lvSearch.Visible = True
        lvDebug.Visible = False
    Else
        lv2.Visible = False
        lvSearch.Visible = False
        lvDebug.Visible = True
    End If
End Sub

Private Sub ts_Click()

    If ts.SelectedItem.Index = 1 Then
        txtUncompressed.Visible = True
        he.Visible = False
        txtDetails.Visible = False
    ElseIf ts.SelectedItem.Index = 2 Then
        txtUncompressed.Visible = False
        he.Visible = True
        txtDetails.Visible = False
    Else
        txtUncompressed.Visible = False
        he.Visible = False
        txtDetails.Visible = True
    End If
    
    fraPictViewer.Visible = False
    mnuExtractHexDump.enabled = he.Visible
    mnuExtractHexFromParan.enabled = Not he.Visible
    
End Sub


Private Sub txtPDFPath_Click()
    On Error Resume Next
    txtPDFPath.SelStart = 0
    txtPDFPath.SelLength = Len(txtPDFPath)
End Sub

Private Sub txtPDFPath_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then cmdDecode_Click
End Sub

Private Sub txtPDFPath_OLEDragDrop(data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single)
    On Error Resume Next
    AutomatationRun = False
    txtPDFPath = data.Files(1)
    cmdDecode_Click
End Sub

Function GetParentFolder(pth)
    Dim x() As String
    x = Split(pth, "\")
    GetParentFolder = Replace(pth, x(UBound(x)), Empty)
End Function





'If Not fso.FileExists(txtPDFPath) Then
'    MsgBox "File not found: " & txtPDFPath, vbInformation
'    Exit Sub
'End If
'
'filenam = txtPDFPath
'ReDim TheBytes(FileLen(filenam$) - 1)
'
'f = FreeFile
'Open filenam$ For Binary Access Read As f
'Get f, , TheBytes()
'Close f
'
''Convert the entire byte array to a string
'sStr = StrConv(TheBytes, vbUnicode)
'
''Search for stream and endstream
'lStart = InStr(1, sStr, "stream")
'Do While lStart > 0
'    lEnd = InStr(lStart, sStr, "endstream")
'    If lEnd > 0 Then
'        'Get the stream without the text Stream
'        sStream = Mid(sStr, lStart + 6, lEnd - lStart - 6)
'
'        Set stream = New CPDFStream
'        stream.StartOffset = lStart + 5
'
'        'check if to remove the crlf after stream
'        If Left(sStream, 2) = vbCrLf Then
'            sStream = Mid(sStream, 3)
'            stream.StartOffset = stream.StartOffset + 2
'        End If
'
'        If Right(sStream, 2) = vbCrLf Then
'            sStream = Mid(sStream, 1, Len(sStream) - 2)
'        End If
'
'        If Right(sStream, 1) = Chr(&HA) Then
'            sStream = Mid(sStream, 1, Len(sStream) - 1)
'        End If
'
'        stream.CompressedSize = Len(sStream) - 1
'        stream.EndOffset = stream.StartOffset + stream.CompressedSize
'
'        If Len(sStream) > 1 Then
'            'Convert this stream to a byte array
'            TheBytes = StrConv(sStream, vbFromUnicode)
'
'            stream.OriginalData = sStream
'            stream.Index = cnt
'
'            'Decode this portion
'            modzlib.UncompressData TheBytes, xbBufferOut
'
'            If aryIsEmpty(xbBufferOut) Then 'decompress error
'                stream.Message = "Decompression Error. Probably Not Compressed"
'                Set li = lv2.ListItems.Add(, , "stream # " & cnt & " org sz = (0x" & Hex(UBound(TheBytes)) & ")")
'                Set li.Tag = stream
'            Else 'everyting was ok
'                stream.Message = Empty
'                stream.DecompressedData = StrConv(xbBufferOut, vbUnicode)
'                stream.DecompressedSize = Len(stream.DecompressedData)
'                Set li = lv.ListItems.Add(, , cnt & " 0x" & Hex(stream.StartOffset) & "-0x" & Hex(stream.EndOffset))
'                Set li.Tag = stream
'            End If
'
'        Else
'            stream.Message = "Stream to small error decoding"
'            Set li = lv2.ListItems.Add(, , "stream #" & cnt & " org sz = (0x" & Hex(Len(sStream)) & ")")
'            Set li.Tag = stream
'        End If
'
'        'Search the next stream where we left off
'        lStart = InStr(lEnd + 8, sStr, "stream")
'    Else
'        lStart = 0
'    End If
'
'    cnt = cnt + 1
'
'Loop
'
Private Sub ucAsyncDownload1_DownloadComplete(fPath As String)
    Dim f As String
    Dim a As Long
    
    On Error GoTo hell
    
    pb.value = 0
    Name fPath As DownloadPath
    If fso.FileExists(fPath) Then Kill fPath
    
    Exit Sub
hell:
    MsgBox "DownloadComplete Error: " & Err.Description
    
End Sub

Private Sub ucAsyncDownload1_Error(code As Long, msg As String)
    Const NotFound = &H80070006
    If code = &H80070006 Then
        MsgBox "The URL specified was not found.", vbInformation
    Else
        MsgBox "Error downloading file! " & vbCrLf & vbCrLf & _
               "Code: " & code & vbCrLf & _
               "Message: " & msg, vbInformation
    End If
End Sub

Private Sub ucAsyncDownload1_Progress(current As Long, total As Long)
    On Error Resume Next 'bug if total > pb.max capability? (single)
    pb.max = total + 1
    pb.value = current
End Sub
'
