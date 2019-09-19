VERSION 5.00
Begin VB.UserControl ucAsyncDownload 
   BackColor       =   &H00C00000&
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
End
Attribute VB_Name = "ucAsyncDownload"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'http://support.microsoft.com/kb/200676
'http://msdn.microsoft.com/en-us/library/aa277589(v=vs.60).aspx

Event DownloadComplete(fPath As String)
Event Progress(current As Long, total As Long)
Event Error(code As Long, msg As String)

Public LastURL As String

Sub AbortDownload()
    On Error Resume Next
    UserControl.CancelAsyncRead "temp"
End Sub

Sub StartDownload(url As String, Optional opt As AsyncReadConstants)
    On Error GoTo hell
    LastURL = url
    UserControl.AsyncRead url, vbAsyncTypeFile, "temp", opt
    Exit Sub
hell:
    RaiseEvent Error(Err.Number, Err.Description)
End Sub

Private Sub UserControl_AsyncReadComplete(AsyncProp As AsyncProperty)
    On Error GoTo hell
    DoEvents ' Yield execution to ensure that the temporary file is written.
    RaiseEvent DownloadComplete(AsyncProp.Value)
    Exit Sub
hell:
    RaiseEvent Error(Err.Number, Err.Description)
End Sub

Private Sub UserControl_AsyncReadProgress(AsyncProp As AsyncProperty)
    RaiseEvent Progress(AsyncProp.BytesRead, AsyncProp.BytesMax)
End Sub

