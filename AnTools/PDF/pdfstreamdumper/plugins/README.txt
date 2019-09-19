
To understand the plugin framework please see this article

http://sandsprite.com/CodeStuff/Understanding_plugins.html


todo (maybe): Let a plugin hook into the parsing complete event so they can
              scan a file once its done loading and auto detect certain variants or
              auto unpack stuff.


Objects you can access from the plugins (not conclusive see main source or sample for more help)


Public members of the form1 object
-----------------------------------------
form1.lv = main listview, each listitem.tag is the corrosponding CPDFStream class
form1.txtPDFPath = main file path textbox on bottom
form1.cmdDecode_Click = LoadFile button click event, call manually to load pdf file
Form1.StatusBar.Panels(i) = lower statusbar you can access.
form1.txtDetails as rtfbox
form1.txtUncompressed as rtfbox
form1.he as rtfBox (hexedit pane)

Public Enum statss
    stNotLoaded = 0
    stProcessing = 1
    stComplete = 2
End Enum

Public selli As ListItem
Public dlg As New clsCmnDlg
Public AutomatationRun As Boolean
Public Status As statss

Function DoEventsFor(x) 'for scripts
Function SleepFor(ms) 'for scripts
Function Shutdown() 'shuts down whole app
Function AppPath()  'folder exe is running from
Function AryIsEmpty(ary) As Boolean
Public Sub catch_up()


dlg as clsCommonDialog
--------------------------
Function OpenDialog(filt As FilterTypes, Optional initDir As String, Optional title As String, Optional pHwnd As Long = 0) As String
Function FolderDialog(Optional initDir As String, Optional pHwnd As Long = 0) As String
Function SaveDialog(filt As FilterTypes, Optional initDir As String, Optional title As String = "", Optional ConfirmOvewrite As Boolean = True, Optional pHwnd As Long = 0, Optional defaultFileName As String) As String
Public Enum FilterTypes
    textFiles = 0
    htmlFiles = 1
    exeFiles = 2
    zipFiles = 3
    AllFiles = 4
    CustomFilter = 5
End Enum




CPdfStream (accessed from lv.listitems(i).tag see GetActiveData script function for demo use)
------------------
Public Enum ObjType
    Unknown = 0
    Flash = 1
    U3d = 2
    TTFFont = 3
End Enum
    
Public Index As Long
Public Header As String
Public escapedHeader As String

Public RawObject As String
Public ObjectStartOffset As Long
Public ObjectEndOffset As Long

Public ContainsStream As Boolean
Public isCompressed As Boolean
'Public isASCIIHexDecode As Boolean

'theses are related to streams
Public StartOffset As Long
Public EndOffset As Long

Public CompressedSize As Long
Public DecompressedSize As Long

Public OriginalData As String
Public DecompressedData As String

Public OriginalDataCRC As String
Public HeaderCRC As String

Public ContentType As ObjType
Public UsesUnsupportedFilter As Boolean
Public Message As String

Public StreamDecompressor As New CApplyFilters




CApplyFilters 
-------------------

Public UnsupportedFilter As Boolean
Public DecompressionError As Boolean
Public DecompErrorMessage As String

Property Get GetActiveFiltersCount() As Long
Function GetActiveFiltersAsString() As String
