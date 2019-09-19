Attribute VB_Name = "modLVSort"
Option Explicit

'****************************************************************************************
' 2004 KLEINMA
' CONTACT KLEINMA AT
' http://www.vbforums.com/private.php?s=&action=newmessage&userid=24893
'
' NOTES:
' THIS MODULE WILL SORT A LISTVIEW ON TEXT, NUMBERS, OR DATES
' HOW IT WORKS IS PRETTY SIMPLE. INSTEAD OF USING THE MS EXAMPLE
' http://support.microsoft.com/default.aspx?scid=kb;en-us;170884&Product=vbb
' IT CONVERTS THE DATE OR THE NUMBER INTO A FORMAT THAT CAN BE SORTED LIKE TEXT
' AND THEN CHANGES IT BACK AFTER IT SORTS THE LIST. THIS MEANS THAT THE LISTITEMS
' COLLECTIONS SORTS ALSO, UNLIKE THE MS EXAMPLE THAT USES API
' IT MAKES THE LISTVIEW INVISIBLE WHILE SORTING BECAUSE THIS IS MUCH FASTER
' IF YOU WANTED TO, YOU COULD MAKE A WHITE LABEL (BORDER OF FIXED SINGLE) OF
' THE SAME SIZE AND MAKE THAT VISIBLE WHEN THE LISTVIEW IS INVISIBLE SO THE USER
' DOESNT SEE THE LISTVIEW DISAPPEAR BUT THAT SHOULD ONLY BE A FACTOR IN A VERY LARGE
' LIST OF DATA AND SHOULDN'T MATTER IN MOST CASES
'
' CHANGE THE CONSTANT BELOW DATE_FORMAT TO BE THE FORMAT YOU WANT YOUR DATES IN *AFTER*
' THE SORT IS DONE
'
' FEEL FREE TO USE, ALTER, OR IMPROVE THIS CODE
' IF YOU DO ANY MAJOR IMPROVEMENTS, I WOULD LOVE TO SEE THEM
' CONTACT ME AT ABOVE URL
'****************************************************************************************

Public Enum eSortOrder
    sortAscending = 0
    sortDescending = 1
End Enum
Public Enum eSortType
    sortAlpha = 0
    sortNumeric = 1
    sortDate = 2
End Enum

'CHANGE THIS TO HOW YOU WANT THE DATE TO BE DISPLAYED WHEN SORTING
Public Const DATE_FORMAT = "mm/dd/yyyy"

Private Sub SortList(ByVal LV As MSComctlLib.ListView, SortOrder As eSortOrder, SortKey As Integer)
    If SortOrder = sortAscending Then
        LV.SortOrder = lvwAscending
    ElseIf SortOrder = sortDescending Then
        LV.SortOrder = lvwDescending
    End If
    LV.SortKey = SortKey
    LV.Sorted = True
End Sub

Public Function SortColumn(ByVal LV As MSComctlLib.ListView, ColumnIndex As Integer, SortOrder As eSortOrder, SortType As eSortType) As Boolean
    
On Error GoTo EH:
    
    Dim x       As Integer
    Dim y       As Integer
    Dim strMax  As String
    Dim strNew  As String
    
    Select Case SortType
        Case eSortType.sortAlpha
            'TEXT SORT
            Call SortList(LV, SortOrder, ColumnIndex - 1)
        Case eSortType.sortNumeric
            'NUMERIC SORT
            
            'GET THE LONGEST NUMBER STRING LENGTH
            If ColumnIndex > 1 Then
                For x = 1 To LV.ListItems.Count
                    If Len(LV.ListItems(x).ListSubItems(ColumnIndex - 1)) <> 0 Then 'DONT BOTHER WITH 0 LENGTH STRINGS
                        If Len(CStr(Int(LV.ListItems(x).ListSubItems(ColumnIndex - 1)))) > Len(strMax) Then
                            strMax = CStr(Int(LV.ListItems(x).SubItems(ColumnIndex - 1)))
                        End If
                    End If
                Next
            Else
                For x = 1 To LV.ListItems.Count
                    If Len(LV.ListItems(x)) <> 0 Then
                        If Len(CStr(Int(LV.ListItems(x)))) > Len(strMax) Then
                            strMax = CStr(Int(LV.ListItems(x)))
                        End If
                    End If
                Next
            End If
            
            'MAKE TO CONTROL INVISIBLE TO INCREASE PERFORMANCE
            LV.Visible = False
            
            If ColumnIndex > 1 Then
                For x = 1 To LV.ListItems.Count
                    If Len(LV.ListItems(x).ListSubItems(ColumnIndex - 1)) = 0 Then
                        LV.ListItems(x).ListSubItems(ColumnIndex - 1) = "0" 'IF 0 LENGTH STRING, MAKE IT 0 SO THE SORT WONT FAIL
                    ElseIf Len(CStr(Int(LV.ListItems(x).ListSubItems(ColumnIndex - 1)))) < Len(strMax) Then
                        'PAD NUMBER WITH 0s THIS ALLOWS A ROUND ABOUT NUMERIC SORT
                        'THEN WE CAN REMOVE THE 0s LATER.
                        strNew = LV.ListItems(x).ListSubItems(ColumnIndex - 1)
                        For y = 1 To Len(strMax) - Len(CStr(Int(LV.ListItems(x).ListSubItems(ColumnIndex - 1))))
                            strNew = "0" & strNew
                        Next
                        LV.ListItems(x).ListSubItems(ColumnIndex - 1) = strNew
                    End If
                Next
            Else
                For x = 1 To LV.ListItems.Count
                    If Len(LV.ListItems(x).Text) = 0 Then
                        LV.ListItems(x).Text = "0" 'make 0 length strings = To "0"
                    ElseIf Len(CStr(Int(LV.ListItems(x)))) < Len(strMax) Then
                        'PAD NUMBER WITH 0s THIS ALLOWS A ROUND ABOUT NUMERIC SORT
                        'THEN WE CAN REMOVE THE 0s LATER.
                        strNew = LV.ListItems(x).Text
                        For y = 1 To Len(strMax) - Len(CStr(Int(LV.ListItems(x))))
                            strNew = "0" & strNew
                        Next
                        LV.ListItems(x).Text = strNew
                    End If
                Next
            End If
            
            'SORT THE LIST
            Call SortList(LV, SortOrder, ColumnIndex - 1)
            
            'GET RID OF PADDED 0s
            If ColumnIndex > 1 Then
                For x = 1 To LV.ListItems.Count
                    LV.ListItems(x).ListSubItems(ColumnIndex - 1) = CDbl(LV.ListItems(x).ListSubItems(ColumnIndex - 1))
                    If LV.ListItems(x).ListSubItems(ColumnIndex - 1) = 0 Then LV.ListItems(x).ListSubItems(ColumnIndex - 1) = ""
                Next
            Else
                For x = 1 To LV.ListItems.Count
                    LV.ListItems(x).Text = CDbl(LV.ListItems(x).Text)
                    If LV.ListItems(x).Text = 0 Then LV.ListItems(x).Text = ""
                Next
            End If
            LV.Visible = True
        Case eSortType.sortDate
            'DATE SORT
                'MAKE TO CONTROL INVISIBLE TO INCREASE PERFORMANCE
                LV.Visible = False
                If ColumnIndex > 1 Then
                    'CHANGE DATE TO A FORMAT THAT CAN BE SORTED LIKE TEXT
                    For x = 1 To LV.ListItems.Count
                        LV.ListItems(x).ListSubItems(ColumnIndex - 1) = Format(LV.ListItems(x).ListSubItems(ColumnIndex - 1), "YYYY MM DD hh:mm:ss")
                    Next

                    Call SortList(LV, SortOrder, ColumnIndex - 1)
                    'CONVERT BACK TO FORMAT YOU WANT TO DISPLAY
                        For x = 1 To LV.ListItems.Count
                            LV.ListItems(x).ListSubItems(ColumnIndex - 1) = Format(LV.ListItems(x).ListSubItems(ColumnIndex - 1), DATE_FORMAT)
                        Next
                Else
                    'CHANGE DATE TO A FORMAT THAT CAN BE SORTED LIKE TEXT
                    For x = 1 To LV.ListItems.Count
                        LV.ListItems(x).Text = Format(LV.ListItems(x).Text, "YYYY MM DD hh:mm:ss")
                    Next
                        Call SortList(LV, SortOrder, ColumnIndex - 1)
                        For x = 1 To LV.ListItems.Count
                            LV.ListItems(x).Text = Format(LV.ListItems(x).Text, DATE_FORMAT)
                        Next
                End If
                LV.Visible = True
        End Select
        'RETURN TRUE
        SortColumn = True
        Exit Function
EH:
    'IF ERROR OCCURED RETURN FALSE
    SortColumn = False
    MsgBox "ERROR IN SORT ROUTINE:" & vbCrLf & Err.Number & vbTab & Err.Description
End Function



