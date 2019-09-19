VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "plugin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

'Function RegisterPlugin(intMenu As Integer,              <-- which menu to add to
'                         strMenuName As String,          <-- menu text
'                         intStartupArgument As Integer)  <--argument to pass back on select


Public frmMain As Object

Sub SetHost(newref As Object)
    Set frmMain = newref
    frmMain.RegisterPlugin 0, "Object Browser", 0
    frmMain.RegisterPlugin 0, "FreeMyPDF Decrypter", 1
    frmMain.RegisterPlugin 0, "CrackMyPDF Decrypter", 2
End Sub

Private Function LaunchBrowser(ByVal url As String)
    Call ShellExecute(0&, "open", url, vbNullString, vbNullString, vbNormalFocus)
End Function

Sub StartUp(intArg As Integer)
    On Error Resume Next
    Select Case intArg
        Case 0:
                Set Form1.frmMain = frmMain
                Form1.Show '1
        Case 1:
                LaunchBrowser "http://freemypdf.com"
        Case 2:
                LaunchBrowser "http://crackmypdf.com"
    End Select
End Sub

 
 'below here are so we can use this plugin like a standard activex library too
 Public Function NewFileLoaded()
    On Error Resume Next
    Set Form1.frmMain = frmMain
    Form1.Visible = False
    Form1.Form_Load
 End Function
 
 Public Function InitAsLib(newref As Object)
    Set frmMain = newref
    Set Form1.frmMain = frmMain
    Form1.Visible = False
    Form1.Form_Load
 End Function
 
 Public Function GetNumPages() As Long
    On Error Resume Next
    GetNumPages = Form1.pages.Count
 End Function
 
 Public Function GetInfoFields() As String
    On Error Resume Next
    Dim ret As String
    Dim o As CNamedObject
    For Each o In Form1.objects
        If o.DataType = dtInfo Then
            ret = ret & o.Name & ","
        End If
    Next
    If Right(ret, 1) = "," Then ret = Mid(ret, 1, Len(ret) - 1)
    GetInfoFields = ret
 End Function
 
 Public Function GetInfoField(Name)
    On Error Resume Next
    Dim ret As String
    Dim o As CNamedObject
    For Each o In Form1.objects
        If o.DataType = dtInfo Then
            If LCase(o.Name) = LCase(Name) Then 'should this be case insensitive?
                GetInfoField = o.Data
                Exit Function
            End If
        End If
    Next
 End Function

Public Function GetAnnotCountForPage(page)
    On Error Resume Next
    Dim o As CNamedObject
    Dim oo As CNamedObject
    Dim cnt As Long
    
    Set o = Form1.pages(page + 1)
    
    For Each oo In o.SubItems
        If oo.DataType = dtAnnot Then cnt = cnt + 1
    Next
        
    GetAnnotCountForPage = cnt
End Function

Public Function GetAnnot(page, index)
    On Error Resume Next
    Dim o As CNamedObject
    Dim oo As CNamedObject
    Dim cnt As Long
    
    Set o = Form1.pages(page + 1)
    cnt = -1
    
    For Each oo In o.SubItems
        If oo.DataType = dtAnnot Then
            cnt = cnt + 1
            If index = cnt Then
                GetAnnot = oo.Data
                Exit Function
            End If
        End If
    Next

End Function

Public Function GetPageData(page)
    On Error Resume Next
    Dim o As CNamedObject
    Dim oo As CNamedObject
    
    Set o = Form1.pages(page + 1) 'collection is 1 based, adobe is 0
    
    For Each oo In o.SubItems
        If oo.DataType = dtContents Then
            GetPageData = oo.Data
            Exit Function
        End If
    Next
    
End Function

Public Function GetPageNumWords(page) As Long
    On Error Resume Next
    cnt = UBound(Split(GetPageData(page), " "))
    GetPageNumWords = cnt + 1 'one based
End Function

Public Function GetPageNthWord(page, word) As String
    On Error Resume Next
    Dim tmp
    tmp = Split(GetPageData(page), " ")
    GetPageNthWord = tmp(word)
End Function
