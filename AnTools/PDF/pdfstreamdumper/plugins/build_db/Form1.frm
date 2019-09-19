VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form Form1 
   Caption         =   "Build Sample Database and Search for Data In Multiple Fields"
   ClientHeight    =   8250
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14400
   LinkTopic       =   "Form1"
   ScaleHeight     =   8250
   ScaleWidth      =   14400
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame frmBatchExaminer 
      Caption         =   "Examine Batch "
      Height          =   6945
      Left            =   1080
      TabIndex        =   39
      Top             =   2385
      Visible         =   0   'False
      Width           =   11265
      Begin VB.CommandButton cmdUpdateNotes 
         Caption         =   "Update Notes"
         Height          =   285
         Left            =   9810
         TabIndex        =   48
         Top             =   5040
         Width           =   1140
      End
      Begin VB.TextBox txtBatchNotes 
         Height          =   1545
         Left            =   225
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   47
         Top             =   5355
         Width           =   10815
      End
      Begin MSComctlLib.ListView lvStreams 
         Height          =   1860
         Left            =   180
         TabIndex        =   45
         Top             =   3150
         Width           =   10770
         _ExtentX        =   18997
         _ExtentY        =   3281
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   5
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "Index"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "headerCRC"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   2
            Text            =   "streamCRC"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   3
            Text            =   "StreamLen"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   4
            Text            =   "header"
            Object.Width           =   2540
         EndProperty
      End
      Begin VB.CommandButton cmdLoadBatchFile 
         Caption         =   "Load File"
         Height          =   330
         Left            =   9540
         TabIndex        =   44
         Top             =   315
         Width           =   1455
      End
      Begin VB.TextBox txtBatchFile 
         Height          =   330
         Left            =   3645
         TabIndex        =   43
         Top             =   315
         Width           =   5730
      End
      Begin MSComctlLib.ListView lvBatchFiles 
         Height          =   2355
         Left            =   180
         TabIndex        =   42
         Top             =   720
         Width           =   10815
         _ExtentX        =   19076
         _ExtentY        =   4154
         View            =   3
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         _Version        =   393217
         ColHdrIcons     =   "ImgSorted"
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   3
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "File"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "File Size"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   2
            Text            =   "Streams"
            Object.Width           =   2540
         EndProperty
      End
      Begin MSComctlLib.ImageCombo cbo2 
         Height          =   330
         Left            =   720
         TabIndex        =   40
         Top             =   270
         Width           =   2085
         _ExtentX        =   3678
         _ExtentY        =   582
         _Version        =   393216
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         Locked          =   -1  'True
      End
      Begin VB.Label lblSaveList 
         Caption         =   "Save List"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   240
         Left            =   2835
         TabIndex        =   49
         Top             =   315
         Width           =   690
      End
      Begin VB.Label lblBatchNotes 
         Caption         =   "Batch Notes:"
         Height          =   240
         Left            =   225
         TabIndex        =   46
         Top             =   5085
         Width           =   960
      End
      Begin VB.Label Label2 
         Caption         =   "Batch"
         Height          =   240
         Left            =   180
         TabIndex        =   41
         Top             =   360
         Width           =   870
      End
   End
   Begin VB.Frame frmLoad 
      Caption         =   "Add new Files to Database "
      Height          =   6990
      Left            =   180
      TabIndex        =   1
      Top             =   405
      Width           =   11265
      Begin VB.CheckBox chkMoveEncrypted 
         Caption         =   "Move Encrypted"
         Height          =   255
         Left            =   8940
         TabIndex        =   55
         Top             =   210
         Width           =   1575
      End
      Begin VB.CheckBox Check2 
         Caption         =   "Disable Decryption Support"
         Enabled         =   0   'False
         Height          =   195
         Left            =   6900
         TabIndex        =   54
         Top             =   510
         Value           =   1  'Checked
         Width           =   2235
      End
      Begin VB.CheckBox chkKillDups 
         Caption         =   "Kill Duplicate Files"
         Height          =   195
         Left            =   5700
         TabIndex        =   53
         Top             =   240
         Width           =   1695
      End
      Begin VB.CheckBox chkStatsOnly 
         Caption         =   "File Stats Only"
         Height          =   195
         Left            =   3840
         TabIndex        =   52
         Top             =   240
         Width           =   1515
      End
      Begin VB.CheckBox Check1 
         Caption         =   "OverRide DB Connection String"
         Height          =   255
         Left            =   3840
         TabIndex        =   50
         Top             =   480
         Width           =   2595
      End
      Begin VB.CheckBox chkScanSubFolders 
         Caption         =   "Recursive"
         Height          =   285
         Left            =   7560
         TabIndex        =   26
         Top             =   180
         Width           =   1170
      End
      Begin VB.TextBox txtBatch 
         Height          =   285
         Left            =   1305
         TabIndex        =   17
         Text            =   "default"
         Top             =   450
         Width           =   2355
      End
      Begin VB.CommandButton cmdClearDB 
         Caption         =   "ClearDB"
         Height          =   285
         Left            =   9960
         TabIndex        =   15
         Top             =   480
         Width           =   1095
      End
      Begin VB.ListBox List1 
         Height          =   5130
         Left            =   495
         TabIndex        =   6
         Top             =   1530
         Width           =   10635
      End
      Begin VB.CommandButton cmdScan 
         Caption         =   "Scan"
         Height          =   285
         Left            =   9960
         TabIndex        =   5
         Top             =   810
         Width           =   1095
      End
      Begin VB.CommandButton cmdBrowse 
         Caption         =   "..."
         Height          =   285
         Left            =   9180
         TabIndex        =   4
         Top             =   810
         Width           =   510
      End
      Begin MSComctlLib.ProgressBar pb 
         Height          =   285
         Left            =   495
         TabIndex        =   7
         Top             =   1170
         Width           =   10590
         _ExtentX        =   18680
         _ExtentY        =   503
         _Version        =   393216
         Appearance      =   1
      End
      Begin VB.TextBox txtDir 
         Height          =   330
         Left            =   1305
         TabIndex        =   3
         Top             =   765
         Width           =   7620
      End
      Begin VB.Label Label8 
         Caption         =   "?"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   195
         Left            =   6480
         TabIndex        =   51
         Top             =   480
         Width           =   255
      End
      Begin VB.Label Label3 
         Caption         =   "Batch ID"
         Height          =   285
         Left            =   540
         TabIndex        =   16
         Top             =   495
         Width           =   780
      End
      Begin VB.Label Label1 
         Caption         =   "Directory"
         Height          =   240
         Left            =   540
         TabIndex        =   2
         Top             =   810
         Width           =   690
      End
   End
   Begin VB.Frame frmSearch 
      Caption         =   "Search Database "
      Height          =   6945
      Left            =   3240
      TabIndex        =   8
      Top             =   1260
      Visible         =   0   'False
      Width           =   11175
      Begin VB.Frame frmRawSQL 
         Caption         =   "Raw SQL Interface  - Be careful if you use updates and deletes !"
         Height          =   1455
         Left            =   180
         TabIndex        =   34
         Top             =   3825
         Visible         =   0   'False
         Width           =   10995
         Begin VB.CommandButton cmdRawSQL 
            Caption         =   "Execute"
            Height          =   330
            Left            =   9810
            TabIndex        =   37
            Top             =   990
            Width           =   960
         End
         Begin VB.TextBox txtRawSQL 
            Height          =   1140
            Left            =   675
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   36
            Top             =   225
            Width           =   9015
         End
         Begin VB.Label lblCloseRaw 
            Alignment       =   2  'Center
            BackColor       =   &H00404040&
            Caption         =   "X"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   18
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H00FFFFFF&
            Height          =   420
            Left            =   10350
            TabIndex        =   38
            Top             =   180
            Width           =   465
         End
         Begin VB.Label Label7 
            Caption         =   "SQL: "
            Height          =   195
            Left            =   180
            TabIndex        =   35
            Top             =   225
            Width           =   420
         End
      End
      Begin VB.TextBox txtSampleBatch 
         Height          =   285
         Left            =   8955
         TabIndex        =   33
         Top             =   3060
         Width           =   1950
      End
      Begin VB.TextBox txtSample 
         Height          =   285
         Left            =   3780
         TabIndex        =   31
         Top             =   3060
         Width           =   4380
      End
      Begin VB.TextBox txtPath 
         Height          =   285
         Left            =   2880
         TabIndex        =   29
         Top             =   990
         Width           =   6855
      End
      Begin VB.CheckBox chkPath 
         Caption         =   "and path"
         Height          =   330
         Left            =   945
         TabIndex        =   27
         Top             =   990
         Width           =   960
      End
      Begin VB.CommandButton cmdAbortSearch 
         Caption         =   "Abort"
         Height          =   330
         Left            =   9945
         TabIndex        =   25
         Top             =   585
         Width           =   1050
      End
      Begin VB.TextBox txtSearchFields 
         Height          =   285
         Left            =   945
         TabIndex        =   23
         Top             =   630
         Width           =   8790
      End
      Begin MSComctlLib.ImageCombo cbo 
         Height          =   330
         Left            =   7695
         TabIndex        =   19
         Top             =   225
         Width           =   2085
         _ExtentX        =   3678
         _ExtentY        =   582
         _Version        =   393216
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         Locked          =   -1  'True
      End
      Begin VB.CheckBox chkHexDump 
         Caption         =   "Display as Hexdump"
         Height          =   375
         Left            =   630
         TabIndex        =   14
         Top             =   3015
         Width           =   1815
      End
      Begin VB.TextBox txtData 
         BeginProperty Font 
            Name            =   "Courier"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   3435
         Left            =   585
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   13
         Top             =   3375
         Width           =   10365
      End
      Begin MSComctlLib.ListView lv 
         Height          =   1680
         Left            =   540
         TabIndex        =   12
         Top             =   1350
         Width           =   10410
         _ExtentX        =   18362
         _ExtentY        =   2963
         View            =   3
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         FullRowSelect   =   -1  'True
         GridLines       =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   4
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "File"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "Matched Field"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   2
            Text            =   "Stream Index"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   3
            Text            =   "Matched Data"
            Object.Width           =   2540
         EndProperty
      End
      Begin VB.CommandButton cmdSearch 
         Caption         =   "Search"
         Height          =   330
         Left            =   9945
         TabIndex        =   11
         Top             =   990
         Width           =   1050
      End
      Begin VB.TextBox txtSearch 
         Height          =   285
         Left            =   945
         TabIndex        =   10
         Top             =   270
         Width           =   6135
      End
      Begin VB.Label Label6 
         Caption         =   "Batch:"
         Height          =   240
         Left            =   8280
         TabIndex        =   32
         Top             =   3105
         Width           =   1050
      End
      Begin VB.Label Label5 
         Caption         =   "Sample Path"
         Height          =   240
         Left            =   2745
         TabIndex        =   30
         Top             =   3105
         Width           =   915
      End
      Begin VB.Label lblLike 
         Caption         =   "LIKE"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   240
         Left            =   1980
         TabIndex        =   28
         Top             =   1080
         Width           =   1050
      End
      Begin VB.Label lblOtherSearchs 
         Caption         =   "Other Searchs"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   240
         Left            =   9945
         TabIndex        =   24
         Top             =   270
         Width           =   1140
      End
      Begin VB.Label lblFields 
         Caption         =   "Fields:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   285
         Left            =   270
         TabIndex        =   22
         Top             =   675
         Width           =   645
      End
      Begin VB.Label Label4 
         Caption         =   "Batch"
         Height          =   240
         Left            =   7155
         TabIndex        =   18
         Top             =   315
         Width           =   870
      End
      Begin VB.Label lblSearch 
         Caption         =   "Search"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   285
         Left            =   225
         TabIndex        =   9
         Top             =   315
         Width           =   600
      End
   End
   Begin VB.Frame Frame1 
      BorderStyle     =   0  'None
      Height          =   375
      Left            =   3690
      TabIndex        =   20
      Top             =   -90
      Width           =   8160
      Begin VB.Label lblStats 
         Caption         =   "lblStats"
         ForeColor       =   &H00FF0000&
         Height          =   240
         Left            =   180
         TabIndex        =   21
         Top             =   135
         Width           =   7710
      End
   End
   Begin MSComctlLib.TabStrip TabStrip1 
      Height          =   7755
      Left            =   45
      TabIndex        =   0
      Top             =   0
      Width           =   11850
      _ExtentX        =   20902
      _ExtentY        =   13679
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   3
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Load Files"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Search Data"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Examine Batch"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList ImgSorted 
      Left            =   12030
      Top             =   30
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Form1.frx":0000
            Key             =   "up"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Form1.frx":059A
            Key             =   "down"
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuSelectAll 
         Caption         =   "Select All"
      End
      Begin VB.Menu mnuInvertSelection 
         Caption         =   "Invert Selection"
      End
      Begin VB.Menu mnuCopyItem 
         Caption         =   "Copy List Entry"
      End
      Begin VB.Menu mnuCopyAll 
         Caption         =   "Copy All Entries"
      End
      Begin VB.Menu mnuRemoveSelected 
         Caption         =   "Remove Selected From List"
      End
      Begin VB.Menu mnuChangeBatchID 
         Caption         =   "Change Batch ID For Selected"
      End
      Begin VB.Menu mnuDeleteFromDB 
         Caption         =   "Remove Selected from DB"
      End
      Begin VB.Menu mnuSpacer 
         Caption         =   "-"
      End
      Begin VB.Menu mnuMoveAll 
         Caption         =   "Move All Files to "
      End
      Begin VB.Menu mnuCopyPDF 
         Caption         =   "Copy PDF File to"
      End
      Begin VB.Menu mnuSpacer2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoadFile 
         Caption         =   "Load File in PDFStreamDumper"
      End
      Begin VB.Menu mnuLoadJSStream 
         Caption         =   "Load Stream In JS UI"
      End
   End
   Begin VB.Menu mnuPopup2 
      Caption         =   "mnuPopup2"
      Visible         =   0   'False
      Begin VB.Menu mnuFindObsfuscated 
         Caption         =   "Find Obsfuscated Headers"
      End
      Begin VB.Menu mnuFindFilterChains 
         Caption         =   "Find Filter Chains"
      End
      Begin VB.Menu mnuFindUnsupported 
         Caption         =   "Find Unsupported Filters"
      End
      Begin VB.Menu mnuFindHeadersWJS 
         Caption         =   "Find Headers w/ JS"
      End
      Begin VB.Menu mnuSpacer3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuShowLastSQL 
         Caption         =   "Debug> Show Last Search SQL"
      End
      Begin VB.Menu mnuShowRaw 
         Caption         =   "Debug> Raw SQL Query"
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu mnuPopup3 
      Caption         =   "mnuPopup3"
      Visible         =   0   'False
      Begin VB.Menu mnuFields 
         Caption         =   "All Fields"
         Index           =   0
      End
      Begin VB.Menu mnuFields 
         Caption         =   "stream"
         Index           =   1
      End
      Begin VB.Menu mnuFields 
         Caption         =   "header"
         Index           =   2
      End
      Begin VB.Menu mnuFields 
         Caption         =   "MD5"
         Index           =   3
      End
   End
   Begin VB.Menu mnuPopup4 
      Caption         =   "mnuStreamsPopup4"
      Visible         =   0   'False
      Begin VB.Menu mnuStreamsCopyAll 
         Caption         =   "Copy All entries"
      End
   End
   Begin VB.Menu mnuBatchPopup 
      Caption         =   "mnuBatchPopup"
      Visible         =   0   'False
      Begin VB.Menu mnuChangeBatchIDForSelectedBatch 
         Caption         =   "Change Batch ID for Selected"
      End
      Begin VB.Menu mnuRemoveSelectedFromDBBatch 
         Caption         =   "Remove Selected from DB"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim cn As New Connection
Dim md5 As New MD5Hash
Public frmMain As Object
Dim selLi As ListItem
Dim orgZlibSetting As Boolean
Dim abortSearch As Boolean
Dim lastSQL As String
Dim isLoaded As Boolean
Dim defConstr As String
Dim AbortScan As Boolean


Private Sub cbo2_Click()
    On Error Resume Next
    Dim rs As Recordset
    Dim li As ListItem
    cn.Open
    b = Split(cbo2.Text, " - ")
    txtBatchNotes.Tag = b(0)
    lblBatchNotes.Caption = "Batch Notes for " & b(0)
    Set rs = cn.Execute("Select * from tblFiles where batch='" & b(0) & "'")
    If rs.BOF And rs.EOF Then
        MsgBox b(0)
        Exit Sub
    End If
    lvBatchFiles.ListItems.Clear
    While Not rs.EOF
        Set li = lvBatchFiles.ListItems.Add(, , rs!fname)
        li.Tag = rs!autoid
        li.SubItems(1) = rs!fsize
        li.SubItems(2) = cn.Execute("Select count(autoid) as cnt from tblHeaders where pid=" & rs!autoid)!cnt
        rs.MoveNext
    Wend
    
    Set rs = cn.Execute("Select * from tblBatchNotes where batch='" & txtBatchNotes.Tag & "'")
    If rs.BOF And rs.EOF Then txtBatchNotes.Text = Empty Else txtBatchNotes.Text = rs!notes
    cn.Close
    
End Sub

Private Sub Check1_Click()
    
    On Error Resume Next
    
    If Not isLoaded Then Exit Sub
    
    If Check1.value = 0 Then
        cn.ConnectionString = defConstr
        ShowStats
        Exit Sub
    End If
        
    db = GetSetting("PDFStreamDumper", "config", "connection_string", cn.ConnectionString)
    If Len(db) = 0 Then db = cn.ConnectionString
    db = InputBox("Enter new ODBC Connection string:", , db)
    SaveSetting "PDFStreamDumper", "config", "connection_string", db
    
    If Len(db) = 0 Then
        isLoaded = False
        Check1.value = 0
        isLoaded = True
        cn.ConnectionString = defConstr
        ShowStats
        MsgBox "Reverted to default connection string...", vbInformation
        SaveSetting "PDFStreamDumper", "config", "override_constr", Check1.value
        Exit Sub
    End If
    
    SaveSetting "PDFStreamDumper", "config", "override_constr", Check1.value
    
    cn.Close
    cn.ConnectionString = db
    ShowStats
    MsgBox "Active connection string set and saved for next time."
        
    If Err.Number <> 0 Then MsgBox "Error: " & Err.Description
End Sub

Private Sub chkHexDump_Click()
    On Error Resume Next
    If chkHexDump.value = 1 Then
        txtData = HexDump(txtData.Tag)
    Else
        txtData = txtData.Tag
    End If
End Sub

Private Sub cmdAbortSearch_Click()
    abortSearch = True
End Sub

Private Sub cmdBrowse_Click()
    On Error Resume Next
    'Function FolderDialog(Optional initDir As String, Optional pHwnd As Long = 0) As String
    f = frmMain.dlg.FolderDialog()
    txtDir = f
End Sub

Private Sub cmdClearDB_Click()
    On Error Resume Next
    If MsgBox("Sure you want to delete?", vbYesNo) = vbNo Then Exit Sub
    cn.Open
    cn.Execute "Delete from tblHeaders"
    cn.Execute "Delete from tblFiles"
    cn.Close
    ShowStats
    MsgBox "Done", vbInformation
End Sub

Private Sub cmdLoadBatchFile_Click()
    On Error Resume Next
    frmMain.txtPdfPath = txtBatchFile.Text
    frmMain.cmdDecode_Click
End Sub

Private Sub cmdRawSQL_Click()
    
    On Error Resume Next
    Dim rs As Recordset
    Dim rs2 As Recordset
    
    lv.ListItems.Clear
    cn.Open
    
    Set rs = cn.Execute(txtRawSQL)
    If Err.Number <> 0 Then
        MsgBox Err.Description
        Exit Sub
    End If
    
    While Not rs.EOF
        Set rs2 = cn.Execute("Select fname from tblFiles where autoid=" & rs!pid)
        fname = rs2!fname
        Set li = lv.ListItems.Add(, , fname)
        'li.SubItems(1) = "rawHeader"
        li.SubItems(2) = rs!streamIndex
        'li.SubItems(3) = rh '"Len: " & Len(rs!rawheader) & " - " & Replace(rs!rawheader, Chr(0), Empty)
        li.Tag = rs!autoid
        rs.MoveNext
        Me.Refresh
        DoEvents
    Wend
    
    cn.Close
    Me.Caption = lv.ListItems.Count & " search results"
    
End Sub

Private Sub cmdScan_Click()
    
    On Error GoTo hell
    
    Dim f() As String
    Dim ff
    Dim li As ListItem
    Dim i As Long
    Dim s As Object
    Dim rs As Recordset
    
    
    Me.Visible = True
    Me.Refresh
    DoEvents
    AbortScan = False
    
    If cmdScan.Caption = "Abort" Then
        AbortScan = True
        Exit Sub
    End If
    
    cmdScan.Caption = "Abort"
    
    If Not fso.FolderExists(txtDir) Then
        MsgBox "Directory to scan is not valid", vbInformation
        Exit Sub
    End If
    
    batch = txtBatch
    If Len(batch) = 0 Then batch = "default"
    
    f() = fso.GetFolderFiles2(txtDir, , True, IIf(chkScanSubFolders.value = 1, True, False))
    If AryIsEmpty(f) Then
        MsgBox "No files found", vbInformation
        Exit Sub
    End If
    
    pb.Max = UBound(f) + 1
    pb.value = 0
    List1.AddItem "Found " & UBound(f) & " files"
    cn.Open
     
    'cn.Execute "Delete from tblFiles"
    'cn.Execute "Delete from tblHeaders"
    
    For i = 0 To UBound(f)
        
        If AbortScan Then Exit For
        
        Me.Refresh
        DoEvents
        
        'fpath = txtDir & "\" & f(i)
        fpath = f(i)
        
        If InStr(fpath, "'") > 0 Then
            List1.AddItem "Found single quote in file name, renaming..."
            fn = fso.FileNameFromPath(fpath)
            nfn = Replace(fn, "'", "")
            Rename fpath, nfn
            fpath = fso.GetParentFolder(fpath) & "\" & nfn
        End If
        
        List1.AddItem "Processing " & fpath
        
        hash = md5.HashFile(fpath)
        fname = fso.FileNameFromPath(fpath)
        mfsize = fso.GetFileSize(fpath)
        
1       Set rs = cn.Execute("Select * from tblFiles where md5='" & hash & "'")
2       If rs.BOF And rs.EOF Then
            DoEvents 'not found
        Else
            If chkKillDups.value = 1 Then
                List1.AddItem "Hash: " & hash & " already found deleting."
                fso.DeleteFile fpath
            Else
                List1.AddItem "Hash: " & hash & " already found skipping"
            End If
            
            GoTo nextOne
        End If
        
        'tblFiles: autoid,fpath,fname,fsize,batch,md5
        sql = "Insert into tblFiles(batch,md5,fsize,fpath,fname) values('__%1__','__%2__','__%3__','__%4__','__%5__')"
        sql = Replace(sql, "__%1__", batch)
        sql = Replace(sql, "__%2__", hash)
        sql = Replace(sql, "__%3__", mfsize)
        sql = Replace(sql, "__%4__", fpath)
        sql = Replace(sql, "__%5__", fname)
        
3     cn.Execute sql
        
      If chkStatsOnly.value = 1 Then GoTo nextOne
      
      frmMain.txtPdfPath = fpath
      frmMain.cmdDecode_Click
        
      While frmMain.Status = 1 'processing
            Sleep 20
            DoEvents
      Wend
        
        If frmMain.isEncrypted Then
            If chkMoveEncrypted.value = 1 Then
                newdir = txtDir & "\_encrypted"
                If Not fso.FolderExists(newdir) Then MkDir newdir
                fso.Move fpath, newdir
                List1.AddItem "Moving Encrypted file to " & newdir
            End If
        End If
            
4       pid = cn.Execute("Select autoid from tblFiles where md5='" & hash & "'")!autoid
        
5        cn.Execute "Update tblFiles set LoadTime=" & frmMain.LoadTime & " where autoid=" & pid
        
       For Each li In frmMain.lv.ListItems
            'Function GetActiveData(Item As ListItem, Optional load_ui As Boolean = False, Optional ret_Stream As CPDFStream) As String
6           sStream = frmMain.GetActiveData(li, False, s)
            If Not s Is Nothing Then
                HandleStream pid, s, sStream, fname
            Else
                List1.AddItem "Could not get stream for " & li.Text
            End If
        Next
        
        For Each li In frmMain.lv2.ListItems 'decompression errors listview
            sStream = frmMain.GetActiveData(li, False, s)
            If Not s Is Nothing Then
                HandleStream pid, s, sStream, fname
            Else
                List1.AddItem "Could not get stream for " & li.Text
            End If
        Next
        
nextOne:
        pb.value = pb.value + 1
        
    Next
        
    cmdScan.Caption = "Scan"
    MsgBox "Complete! " & UBound(f) & " files scanned", vbInformation
    
    cn.Close
    ShowStats
    
Exit Sub
hell:
   List1.AddItem "Error in cmdScan file: " & fname & " Err: " & Err.Description & " Line:" & Erl
   Resume Next
      
End Sub

Private Sub HandleStream(pid, s As Object, activeData, fname)
    On Error GoTo hell
    
    'tblHeaders: autoid,header,stream,headerCRC,streamCRC,
                'streamLEN,pid,rawObj,rawHeader,message,filters
                                   
1     header = s.escapedHeader
3    rawobj = s.RawObject
4    rawheader = s.header
5    message = s.message
6    filters = s.StreamDecompressor.GetActiveFiltersAsString()

     If Len(s.headerCRC) > 0 Then
7       headerCRC = Hex(s.headerCRC)
     End If
    
     If Len(s.DecompressedDataCRC) > 0 Then
8       streamCRC = Hex(s.DecompressedDataCRC)
        If Len(streamCRC) = 0 Then
9           streamCRC = s.OriginalDataCRC
        End If
     End If
    
     streamlen = Len(sStream)
    
     Dim rs As New Recordset
10     rs.Open "SELECT * FROM tblHeaders WHERE 1=0", cn, adOpenStatic, adLockOptimistic
11     rs.AddNew
12     rs!header = header
13     rs!Stream = activeData
14     rs!headerCRC = headerCRC
15     rs!streamCRC = streamCRC
16     rs!streamlen = streamlen
17     rs!pid = pid
'18     rs!rawobj = rawobj       'try to save some disk space db are getting pretty big
19     rs!rawheader = rawheader
20     rs!message = message
21     rs!filters = filters
22     rs!streamIndex = s.Index
23     rs.Update
24     rs.Close
     

Exit Sub
hell:
   List1.AddItem "Error in Handle Stream for file " & fname & " " & Err.Description & " line: " & Erl
   Resume Next
   
End Sub


Private Sub cmdSearch_Click()
    
    Dim rs As Recordset
    Dim header
    Dim unique As New Collection
    
    On Error Resume Next
    
    If Len(txtSearch) = 0 Then
        MsgBox "You must enter a search criteria", vbInformation
        Exit Sub
    End If
    
    If Len(txtSearchFields) = 0 Then
        MsgBox "Invalid search fields specified, click on the label to get default"
        Exit Sub
    End If
    
    tblHeaders = Split(txtSearchFields, ",")
    txtData = Empty
    Set selLi = Nothing
    abortSearch = False
    lv.ListItems.Clear
    'cmdAbortSearch.Enabled = True
    
    cn.Open
    
    For Each header In tblHeaders
        If Len(header) > 0 Then
            If abortSearch Then Exit For
            ShowResults header, unique
        End If
    Next
    
    'cmdAbortSearch.Enabled = False
    Me.Caption = lv.ListItems.Count & " results found"
    cn.Close
    
End Sub

Sub ShowResults(field, uc As Collection)
    On Error Resume Next
    'lv subitems file,matched field, data
        
    Dim rs As Recordset
    Dim rs2 As Recordset
    
    Dim li As ListItem
    Dim data As String
    
    'sql = "Select * from tblHeaders where " & field & " like '%" & Replace(txtSearch, "'", "\\'") & "%'"
    
    sql = "SELECT *,tblHeaders.autoid as th_autoid FROM tblHeaders INNER JOIN tblFiles ON tblHeaders.pid = tblFiles.autoid " & _
             "where " & field & " like '%" & Replace(txtSearch, "'", "''") & "%'"
             
    If Len(cbo.Text) > 0 And cbo.Text <> "All" Then
        sql = sql & " and batch='" & cbo.Text & "'"
    End If
    
    If chkPath.value = 1 And Len(txtPath) > 0 Then
        sql = sql & " and fpath " & lblLike.Caption & " '%" & txtPath.Text & "%'"
    End If
    
    lastSQL = sql
    
    'MsgBox sql
    
    Set rs = cn.Execute(sql)
    
    If Err.Number <> 0 Then
        MsgBox Err.Description
        Exit Sub
    End If
    
    If rs.BOF And rs.EOF Then Exit Sub
    
    Do While Not rs.EOF
    
        'Set rs2 = cn.Execute("Select fname from tblFiles where autoid=" & rs!pid)
        fname = rs!fname
        
        If abortSearch Then Exit Do
    
        'If Not keyExists(rs!pid, uc) Then
            Set li = lv.ListItems.Add(, , fname)
            li.SubItems(1) = field
            data = rs(field)
            If Len(data) > 50 Then data = Mid(data, 1, 50)
            li.SubItems(2) = rs!streamIndex
            li.SubItems(3) = data
            li.Tag = rs!th_autoid
        '    AddKey rs!pid, uc, li
        'Else
        '    Set li = GetObjFromKey(rs!pid, uc)
        '    If Not li Is Nothing Then
        '        li.SubItems(2) = li.SubItems(2) & "," & rs!StreamIndex
        '        li.SubItems(1) = li.SubItems(1) & "," & field
        '    End If
        'End If
            
        rs.MoveNext
        Me.Refresh
        DoEvents
            
    Loop
    
End Sub


Private Sub cmdUpdateNotes_Click()
    On Error Resume Next
    Dim rs As Recordset
    
    cn.Open
    s = Replace(txtBatchNotes, "'", Empty)
    c = cn.Execute("Select count(autoid) as cnt from tblBatchNotes where batch='" & txtBatchNotes.Tag & "'")!cnt
    If c = 0 Then
        cn.Execute "Insert into tblBatchNotes(batch,notes) values('" & txtBatchNotes.Tag & "','" & s & "')"
    Else
        cn.Execute "Update tblBatchNotes set notes='" & s & "' where batch='" & txtBatchNotes.Tag & "'"
    End If
    
End Sub

Private Sub Form_Load()

    On Error Resume Next
    
    mnuFields_Click 0
    orgZlibSetting = frmMain.mnuAlwaysUseZlib.Checked
    frmMain.mnuAlwaysUseZlib.Checked = True
    frmMain.mnuDisableDecryption.Checked = True
    
    db = App.path & "\build_db.mdb"
    If Not fso.FileExists(db) Then
        db = App.path & "\..\build_db.mdb"
        If Not fso.FileExists(db) Then
            db = App.path & "\blank_build_db.mdb"
            If Not fso.FileExists(db) Then
                db = App.path & "\..\blank_build_db.mdb"
                If Not fso.FileExists(db) Then
                    MsgBox "Database not found", vbInformation
                    cmdScan.Enabled = True
                    Exit Sub
                End If
            End If
        End If
    End If
    
    If GetMySetting("formLoaded", 1) = 0 And GetSetting("PDFStreamDumper", "config", "override_constr", 0) = 1 Then
        MsgBox "Form failed to load last time, clearing connection string override", vbInformation
        SaveSetting "PDFStreamDumper", "config", "override_constr", 0
        SaveMySetting "formLoaded", 1
    Else
        isLoaded = False
        dbConstr = ""
        Check1.value = GetSetting("PDFStreamDumper", "config", "override_constr", 0)
        If Check1.value = 1 Then
            dbConstr = GetSetting("PDFStreamDumper", "config", "connection_string", "")
            If Len(dbConstr) = 0 Then
                Check1.value = 0
                dbConstr = Empty
            End If
        End If
        isLoaded = True
    End If
    
    SaveMySetting "formLoaded", 0
    defConstr = "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" & db & ";"
    
    If Len(dbConstr) > 0 Then
        'MsgBox "Using constr: " & dbConstr
        cn.ConnectionString = dbConstr
    Else
        cn.ConnectionString = defConstr
    End If
    
    Me.Width = TabStrip1.Width + 200
    Me.Height = TabStrip1.Height + 200
    frmSearch.Move frmLoad.Left, frmLoad.Top
    lv.ColumnHeaders(4).Width = lv.Width - lv.ColumnHeaders(4).Left - 50
    frmRawSQL.Move 0, 0
    frmBatchExaminer.Move frmLoad.Left, frmLoad.Top
    lvBatchFiles.ColumnHeaders(1).Width = lvBatchFiles.Width - lvBatchFiles.ColumnHeaders(2).Width - lvBatchFiles.ColumnHeaders(3).Width - 50
    ShowStats
    
    txtSearchFields = GetMySetting("SearchFields", txtSearchFields.Text)
    If Len(txtSearchFields) = 0 Then mnuFields_Click 0
    
    TabStrip1.Tabs(2).Selected = True
    SaveMySetting "formLoaded", 1
    
    'txtDir = "C:\Documents and Settings\david\Desktop\demo"
    'cmdScan_Click

End Sub

Function ShowStats()
    On Error Resume Next
    Dim rs As Recordset
    cn.Open
    fcnt = cn.Execute("Select count(autoid) as cnt from tblFiles")!cnt
    scnt = cn.Execute("Select count(autoid) as cnt from tblHeaders")!cnt
    lblStats.Caption = "Database contains " & fcnt & " files and " & scnt & " headers"
    cn.Close
End Function



Private Sub Form_Unload(Cancel As Integer)
    On Error Resume Next
    frmMain.mnuAlwaysUseZlib.Checked = orgZlibSetting
    SaveMySetting "SearchFields", txtSearchFields.Text
    frmMain.mnuDisableDecryption.Checked = False
End Sub

Private Sub Label8_Click()
    MsgBox "Allows you to override the default ODBC connection string used to specify database. " & _
    "With this you can switch to a different backend database. " & _
    "You will be prompted for the connection string and it will be saved between runs. " & _
    "If you get this wrong, this form may hang on startup until connection timesout. " & _
    "You can edit string in registry as well under" & _
    vbCrLf & vbCrLf & "HKCU\Software\VB and VBA Program Settings\PDFStreamDumper\config", vbInformation
End Sub

Private Sub lblCloseRaw_Click()
    frmRawSQL.Visible = False
End Sub

Private Sub lblFields_Click()
    PopupMenu mnuPopup3
End Sub

Private Sub lblLike_Click()
    If lblLike.Caption = "LIKE" Then
        lblLike.Caption = "NOT LIKE"
    Else
        lblLike.Caption = "LIKE"
    End If
End Sub

Private Sub lblOtherSearchs_Click()
    PopupMenu mnuPopup2
End Sub

Private Sub lblSaveList_Click()
    On Error Resume Next
    Dim ci As ComboItem
    For Each ci In cbo2.ComboItems
        tmp = tmp & ci.Text & vbCrLf
    Next
    Clipboard.Clear
    Clipboard.SetText Replace(tmp, " - ", vbTab)
    MsgBox Len(tmp) & " characters copied to the clipboard", vbInformation
End Sub

Private Sub lblSearch_Click()
    MsgBox "ADO Wildcard characters: " & vbcrf & vbCrLf & "Multiple Character Wildcard is %" & vbCrLf & "Single character Wildcard is _", vbInformation
End Sub

Private Sub lv_ItemClick(ByVal Item As MSComctlLib.ListItem)
    
    Set selLi = Item
    autoid = Item.Tag
    
    On Error Resume Next
    Dim rs As Recordset
    cn.Open
    'MsgBox Item.Tag
    
    Set rs = cn.Execute("Select * from tblHeaders where autoid=" & Item.Tag)
    data = rs(Item.SubItems(1))
    
    If Item.SubItems(1) = "rawHeader" Then
        data = data & vbCrLf & vbCrLf & "Escaped: " & vbCrLf & String(30, "-") & vbCrLf & rs!header
    End If
    
    Set rs = cn.Execute("Select * from tblFiles where autoid=" & rs!pid)
    txtSample = rs!fpath
    txtSampleBatch = rs!batch
    
    txtData.Tag = data
    If chkHexDump.value = 1 Then
        txtData = HexDump(data)
    Else
        txtData = data
    End If
    
End Sub

Private Sub lv_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuPopup
End Sub

Private Sub lvBatchFiles_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    'file,size,streams
    Call ClearHeaderIcons(lvBatchFiles, ColumnHeader.Index)
    Select Case ColumnHeader.Index
        Case 1 'file path, no sort specified...
        Case 2, 3
            Select Case ColumnHeader.Icon
                Case "down"
                    ColumnHeader.Icon = "up"
                    Call SortColumn(lvBatchFiles, ColumnHeader.Index, sortDescending, sortNumeric)
                Case "up"
                    ColumnHeader.Icon = "down"
                    Call SortColumn(lvBatchFiles, ColumnHeader.Index, sortAscending, sortNumeric)
                Case Else
                    ColumnHeader.Icon = "down"
                    Call SortColumn(lvBatchFiles, ColumnHeader.Index, sortAscending, sortNumeric)
            End Select
    End Select
End Sub

Private Sub ClearHeaderIcons(lv As ListView, CurrentHeader As Integer)
    Dim i As Integer
    For i = 1 To lv.ColumnHeaders.Count
        If lv.ColumnHeaders(i).Index <> CurrentHeader Then
            lv.ColumnHeaders(i).Icon = Empty
        End If
    Next
End Sub

Private Sub lvBatchFiles_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    Dim rs As Recordset
    Dim li As ListItem
    cn.Open
    lvStreams.ListItems.Clear
    'msgbox "batchFile ItemClick"
    Set rs = cn.Execute("Select * from tblHeaders where pid=" & Item.Tag)
    txtBatchFile = cn.Execute("Select * from tblFiles where autoid=" & Item.Tag)!fpath
    While Not rs.EOF
        Set li = lvStreams.ListItems.Add(, , rs!streamIndex)
        li.SubItems(1) = rs!headerCRC
        li.SubItems(2) = rs!streamCRC
        li.SubItems(3) = rs!streamlen
        li.SubItems(4) = rs!header
        rs.MoveNext
    Wend
    cn.Close
End Sub

Private Sub lvBatchFiles_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuBatchPopup
End Sub

Private Sub lvStreams_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 2 Then PopupMenu mnuPopup4
End Sub

Private Sub mnuChangeBatchIDForSelectedBatch_Click()
    On Error Resume Next
      
    Dim li As ListItem
    Dim rs As Recordset
    
    bid = InputBox("Enter the new batchid for these samples")
    bid = Replace(bid, "'", Empty)
    If Len(bid) = 0 Then Exit Sub
    
    cn.Open
        
    For Each li In lvBatchFiles.ListItems
        If li.Selected Then
            pid = cn.Execute("Select pid from tblHeaders where autoid=" & li.Tag)!pid
            cn.Execute "Update tblFiles set batch='" & bid & "' where autoid=" & pid
        End If
    Next
    
    cn.Close
    TabStrip1_Click 'reload batch id cbo
    
End Sub

Private Sub mnuChangeBatchID_Click()
    
    On Error Resume Next
      
    Dim li As ListItem
    Dim rs As Recordset
    
    bid = InputBox("Enter the new batchid for these samples")
    bid = Replace(bid, "'", Empty)
    If Len(bid) = 0 Then Exit Sub
    
    cn.Open
        
    For Each li In lv.ListItems
        If li.Selected Then
            pid = cn.Execute("Select pid from tblHeaders where autoid=" & li.Tag)!pid
            cn.Execute "Update tblFiles set batch='" & bid & "' where autoid=" & pid
        End If
    Next
    
    cn.Close
    TabStrip1_Click 'reload batch id cbo
    
    
End Sub

Private Sub mnuCopyAll_Click()
    
    On Error Resume Next
    Dim li As ListItem
    
    If lv.ListItems.Count < 1 Then Exit Sub
    
    For Each li In lv.ListItems
        tmp = tmp & lv.ColumnHeaders(i).Text & ": " & li.Text & vbCrLf
        For i = 1 To lv.ColumnHeaders.Count
            tmp = tmp & lv.ColumnHeaders(i).Text & ": " & li.SubItems(i) & vbCrLf
        Next
        tmp = tmp & vbCrLf & String(30, "-") & vbCrLf & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText tmp
    MsgBox Len(tmp) & " characters copied to clipboard", vbInformation
    
End Sub

Private Sub mnuCopyItem_Click()
    On Error Resume Next
    If Not selLi Is Nothing Then
        tmp = tmp & lv.ColumnHeaders(i).Text & ": " & selLi.Text & vbCrLf
        For i = 1 To lv.ColumnHeaders.Count
           tmp = tmp & lv.ColumnHeaders(i).Text & ": " & selLi.SubItems(i) & vbCrLf
        Next
    End If
    Clipboard.Clear
    Clipboard.SetText tmp
    MsgBox Len(tmp) & " characters copied to clipboard", vbInformation
End Sub

Private Sub mnuCopyPDF_Click()
    
    On Error Resume Next
    Dim rs As Recordset
    
    'Function FolderDialog(Optional initDir As String, Optional pHwnd As Long = 0) As String
    f = frmMain.dlg.FolderDialog()
    If Len(f) = 0 Then Exit Sub
    f = f & "\"
    
    If Not selLi Is Nothing Then
        cn.Open
        Set rs = cn.Execute("Select * from tblHeaders where autoid=" & selLi.Tag)
        fpath = cn.Execute("Select * from tblFiles where autoid=" & rs!pid)!fpath
        If fso.FileExists(fpath) Then
            f = f & fso.GetFileName(fpath)
            If fso.FileExists(f) Then
                MsgBox "This file already exists in the target directory", vbInformation
            Else
                FileCopy fpath, f
                If Err.Number <> 0 Then
                    MsgBox Err.Description & vbCrLf & "Source: " & fpath & vbCrLf & "Dest: " & f, vbExclamation
                Else
                    MsgBox "Copy Complete", vbInformation
                End If
            End If
        Else
            MsgBox "File has moved since it was added to db: " & fpath
        End If
    End If
    
End Sub

Private Sub mnuRemoveSelectedFromDBBatch_Click()
    On Error Resume Next
    If MsgBox("Are you sure you want to remove these entries from the database?", vbYesNo) = vbNo Then Exit Sub
    
    Dim li As ListItem
    Dim rs As Recordset
    
    cn.Open
        
    For Each li In lvBatchFiles.ListItems
        If li.Selected Then
            cn.Execute "Delete from tblFiles where autoid=" & li.Tag
            cn.Execute "Delete from tblHeaders where pid=" & li.Tag
        End If
    Next
        
    For i = lvBatchFiles.ListItems.Count To 1 Step -1
        If lvBatchFiles.ListItems(i).Selected = True Then lvBatchFiles.ListItems.Remove i
    Next
    
    cn.Close
    ShowStats
    
End Sub

Private Sub mnuDeleteFromDB_Click()

    On Error Resume Next
    If MsgBox("Are you sure you want to remove these entries from the database?", vbYesNo) = vbNo Then Exit Sub
    
    Dim li As ListItem
    Dim rs As Recordset
    
    cn.Open
        
    For Each li In lv.ListItems
        If li.Selected Then
            pid = cn.Execute("Select pid from tblHeaders where autoid=" & li.Tag)!pid
            cn.Execute "Delete from tblFiles where autoid=" & pid
            cn.Execute "Delete from tblHeaders where pid=" & pid
        End If
    Next
        
    For i = lv.ListItems.Count To 1 Step -1
        If lv.ListItems(i).Selected = True Then lv.ListItems.Remove i
    Next
    
    cn.Close
    ShowStats
    
End Sub

Private Sub mnuFields_Click(Index As Integer)
    
    Select Case Index
        Case 0: txtSearchFields = "header,stream,headerCRC,streamCRC,streamLEN,rawObj,rawHeader,message,filters,md5"
        Case 2: txtSearchFields = "header"
        Case 1: txtSearchFields = "stream"
        Case 3: txtSearchFields = "md5"
    End Select
        
End Sub

Private Sub mnuFindHeadersWJS_Click()
    On Error Resume Next
    Dim c As New Collection
    lv.ListItems.Clear
    txtSearch = "/Javascript%("
    cn.Open
    ShowResults "header", c
    cn.Close
End Sub

Private Sub mnuFindUnsupported_Click()
    On Error Resume Next
    Dim c As New Collection
    lv.ListItems.Clear
    txtSearch = "% %"
    cn.Open
    ShowResults "message", c
    cn.Close
End Sub

Private Sub mnuFindFilterChains_Click()
    On Error Resume Next
    Dim c As New Collection
    lv.ListItems.Clear
    txtSearch = ","
    cn.Open
    ShowResults "filters", c
    cn.Close
End Sub

Private Sub mnuFindObsfuscated_Click()
    On Error Resume Next
    Dim rs As Recordset
    Dim rs2 As Recordset
    
    lv.ListItems.Clear
    cn.Open
    
    Set rs = cn.Execute("Select * from tblHeaders where rawHeader like '%#%' or rawHeader like '%\\1%'")
    Do While Not rs.EOF
        If abortSearch Then Exit Do
        rh = rs!rawheader
        If looksEscaped(rh) Then
            Set rs2 = cn.Execute("Select fname from tblFiles where autoid=" & rs!pid)
            fname = rs2!fname
            Set li = lv.ListItems.Add(, , fname)
            li.SubItems(1) = "rawHeader"
            li.SubItems(2) = rs!streamIndex
            li.SubItems(3) = rh '"Len: " & Len(rs!rawheader) & " - " & Replace(rs!rawheader, Chr(0), Empty)
            li.Tag = rs!autoid
        End If
        rs.MoveNext
        DoEvents
        Me.Refresh
        DoEvents
    Loop
    
    cn.Close
    Me.Caption = lv.ListItems.Count & " search results"
    
End Sub

Function looksEscaped(ByVal header) 'as boolean
    
    header = Replace(header, "#20", " ") 'to common to include with low threshold
    If GetCount(header, "#") > 2 Then looksEscaped = True
    If GetCount(header, "\" & vbCrLf) > 1 Then looksEscaped = True
    If GetCount(header, "\1") > 2 Then looksEscaped = True

End Function

Function GetCount(str, what) 'as long
    On Error Resume Next
    GetCount = UBound(Split(str, what)) + 1
    If Len(GetCount) = 0 Then GetCount = 0
End Function



Private Sub mnuInvertSelection_Click()
    On Error Resume Next
    Dim li As ListItem
    For Each li In lv.ListItems
        If li.Selected = True Then li.Selected = False Else li.Selected = True
    Next
End Sub

Private Sub mnuLoadFile_Click()
    On Error Resume Next
    Dim rs As Recordset
    
    If Not selLi Is Nothing Then
        cn.Open
        Set rs = cn.Execute("Select * from tblHeaders where autoid=" & selLi.Tag)
        fpath = cn.Execute("Select * from tblFiles where autoid=" & rs!pid)!fpath
        If fso.FileExists(fpath) Then
            frmMain.txtPdfPath = fpath
            frmMain.cmdDecode_Click
        Else
            MsgBox "File has moved since it was added to db: " & fpath
        End If
    End If
End Sub

Private Sub mnuLoadJSStream_Click()
    On Error Resume Next
    
    Dim li As ListItem
    Dim s As Object
    
    If Not selLi Is Nothing Then
        cn.Open
        Set rs = cn.Execute("Select * from tblHeaders where autoid=" & selLi.Tag)
        fpath = cn.Execute("Select * from tblFiles where autoid=" & rs!pid)!fpath
        If fso.FileExists(fpath) Then
            frmMain.txtPdfPath = fpath
            frmMain.cmdDecode_Click
            While frmMain.Status = 1
                DoEvents
                Sleep 20
            Wend
            For Each li In frmMain.lv.ListItems
               'Function GetActiveData(Item As ListItem, Optional load_ui As Boolean = False, Optional ret_Stream As CPDFStream) As String
                Call frmMain.GetActiveData(li, False, s)
                If s.Index = selLi.SubItems(2) Then
                    li.Selected = True
                    Call frmMain.GetActiveData(li, True)
                    frmMain.mnuJavascriptUI_Click
                    Exit For
                End If
            Next
        Else
            MsgBox "File has moved since it was added to db: " & fpath
        End If
    End If
End Sub

Private Sub mnuMoveAll_Click()

    On Error Resume Next
    Dim rs As Recordset
    Dim li As ListItem
    Dim e As String
    Dim unique As New Collection
    
    If lv.ListItems.Count < 1 Then Exit Sub
    
    'Function FolderDialog(Optional initDir As String, Optional pHwnd As Long = 0) As String
    f = frmMain.dlg.FolderDialog()
    If Len(f) = 0 Then Exit Sub
    f = f & "\"
    
    cn.Open
    
    For Each li In lv.ListItems
        Set rs = cn.Execute("Select * from tblHeaders where autoid=" & li.Tag)
        
        If Not keyExists(rs!pid, unique) Then
            fpath = cn.Execute("Select * from tblFiles where autoid=" & rs!pid)!fpath
            If fso.FileExists(fpath) Then
                FileCopy fpath, f & fso.GetFileName(fpath)
                If Err.Number <> 0 Then
                    MsgBox Err.Description & vbCrLf & "fpath=" & fpath & vbCrLf & "todir=" & f, vbExclamation
                Else
                    newpath = f & fso.GetFileName(fpath)
                    If fso.FileExists(newpath) Then
                        Kill fpath
                        cn.Execute "Update tblFiles set fpath='" & newpath & "' where autoid=" & rs!pid
                    End If
                End If
            Else
                e = e & "File has moved since added to db: " & fpath & vbCrLf
            End If
            AddKey rs!pid, unique, Me
            Err.Clear
        End If
        
    Next
    
    Set unique = Nothing
    
    If Len(e) > 0 Then
        MsgBox e, vbInformation
    Else
        MsgBox "Complete"
    End If
    
End Sub

Private Sub mnuRemoveSelected_Click()
    On Error Resume Next
    For i = lv.ListItems.Count To 1 Step -1
        If lv.ListItems(i).Selected = True Then lv.ListItems.Remove i
    Next
End Sub

Private Sub mnuSelectAll_Click()
    Dim li As ListItem
    For Each li In lv.ListItems
        li.Selected = True
    Next
End Sub

Private Sub mnuShowLastSQL_Click()
    txtData.Text = lastSQL
End Sub

Private Sub mnuShowRaw_Click()
    frmRawSQL.Visible = True
End Sub

Private Sub mnuStreamsCopyAll_Click()
    On Error Resume Next
    Dim li As ListItem
    
    If lvStreams.ListItems.Count < 1 Then Exit Sub
    
    tmp = "File: " & txtBatchFile & vbCrLf & vbCrLf
    
    For i = 1 To lvStreams.ColumnHeaders.Count
        tmp = tmp & lvStreams.ColumnHeaders(i).Text & vbTab
    Next
    
    tmp = tmp & vbCrLf
    
    For Each li In lvStreams.ListItems
        tmp = tmp & li.Text & vbTab
        For i = 1 To lvStreams.ColumnHeaders.Count
            tmp = tmp & li.SubItems(i) & vbTab
        Next
        tmp = tmp & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText tmp
    MsgBox Len(tmp) & " characters copied to clipboard", vbInformation
End Sub

Private Sub TabStrip1_Click()
    If TabStrip1.SelectedItem.Index = 1 Then
        frmLoad.Visible = True
        frmSearch.Visible = False
        frmBatchExaminer.Visible = False
    ElseIf TabStrip1.SelectedItem.Index = 3 Then
        frmLoad.Visible = False
        frmSearch.Visible = False
        frmBatchExaminer.Visible = True
    Else
        frmLoad.Visible = False
        frmSearch.Visible = True
        frmBatchExaminer.Visible = False
        
        curcombo = cbo.Text
        
        cbo.ComboItems.Clear
        cbo2.ComboItems.Clear
        
        On Error Resume Next
        Dim rs As Recordset
        
        cbo.ComboItems.Add , , "All"
        cn.Open
        Set rs = cn.Execute("Select distinct batch from tblFiles")
        While Not rs.EOF
            batch = rs!batch
            cnt = cn.Execute("Select count(autoid) as cnt from tblFiles where batch='" & batch & "'")!cnt
            cbo.ComboItems.Add , , batch
            cbo2.ComboItems.Add , , batch & " - " & cnt
            rs.MoveNext
        Wend
        cn.Close
        
        Dim ci As ComboItem
        Dim i As Long
        If Len(curcombo) > 0 Then 'why doesnt any of this work?
            i = 1
            For Each ci In cbo.ComboItems
                If ci.Text = curcombo Then
                    cbo.SelectedItem = i
                    ci.Selected = True
                    cbo.Text = curcombo
                    Exit For
                End If
                i = i + 1
            Next
        End If
        
    End If
End Sub
