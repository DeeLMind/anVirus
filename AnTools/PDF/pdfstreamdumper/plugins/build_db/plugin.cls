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


'Function RegisterPlugin(intMenu As Integer,              <-- which menu to add to
'                         strMenuName As String,          <-- menu text
'                         intStartupArgument As Integer)  <--argument to pass back on select


Public frmMain As Object

Sub SetHost(newref As Object)
    Set frmMain = newref
    frmMain.RegisterPlugin 0, "Build && Search Sample Database", 0
    'frmMain.RegisterPlugin 0, "SampleDB: Clear Override Connection String (if hangs)", 1
End Sub

Sub StartUp(intArg As Integer)
    On Error Resume Next
    If intArg = 0 Then
        Set Form1.frmMain = frmMain
        Form1.Show '1
    ElseIf intArg = 1 Then
        SaveSetting "PDFStreamDumper", "config", "override_constr", 0
        SaveSetting "PDFStreamDumper", "config", "connection_string", ""
        MsgBox "Connection String override Cleared!", vbInformation
    Else
        MsgBox "SampleDB: Unknown startup arg: " & intArg
    End If
End Sub

 

