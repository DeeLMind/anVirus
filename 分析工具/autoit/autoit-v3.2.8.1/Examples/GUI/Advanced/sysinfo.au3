#include <GuiConstants.au3>

GuiCreate("Computer Information - By : Para", 469, 639,(@DesktopWidth-469)/2, (@DesktopHeight-639)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$VOL = DriveGetLabel("C:\")
$SERIAL = DriveGetSerial("C:\")
$TOTAL = DriveSpaceTotal("C:\")
$FREE = DriveSpaceFree("C:\")

$ComputerName = GuiCtrlCreateLabel("Computer Name", 10, 10, 150, 20)
$CurrentUserName = GuiCtrlCreateLabel("Current User Name", 10, 40, 150, 20)
$Operatingsystem = GuiCtrlCreateLabel("Operating System", 10, 70, 150, 20)
$ServicePack = GuiCtrlCreateLabel("Service Pack", 10, 100, 150, 20)
$VolumeLabel = GuiCtrlCreateLabel("C: Volume Label", 10, 130, 150, 20)
$SerialNumber = GuiCtrlCreateLabel("C: Serial Number", 10, 160, 150, 20)
$TotalSpace = GuiCtrlCreateLabel("C: Total Space", 10, 190, 150, 20)
$FreeSpace = GuiCtrlCreateLabel("C: Free Space", 10, 220, 150, 20)
$IpAddress = GuiCtrlCreateLabel("Ip Address", 10, 250, 150, 20)
$StartupDirectory = GuiCtrlCreateLabel("Startup Directory", 10, 280, 150, 20)
$WindowsDirectory = GuiCtrlCreateLabel("Windows Directory", 10, 310, 150, 20)
$SystemFolderDirectory = GuiCtrlCreateLabel("System Folder Directory", 10, 340, 150, 20)
$DesktopDirectory = GuiCtrlCreateLabel("Desktop Directory", 10, 370, 150, 20)
$MyDocumentsDirectory = GuiCtrlCreateLabel("My Documents Directory", 10, 400, 150, 20)
$ProgramFileDirectory = GuiCtrlCreateLabel("Program File Directory", 10, 430, 150, 20)
$StartMenuDirectory = GuiCtrlCreateLabel("Start Menu Directory", 10, 460, 150, 20)
$DesktopWidth = GuiCtrlCreateLabel("Desktop Width (Pixels)", 10, 520, 150, 20)
$TemporaryFileDirectory = GuiCtrlCreateLabel("Temporary File Directory", 10, 490, 150, 20)
$DesktopHeight = GuiCtrlCreateLabel("Desktop Height (Pixels)", 10, 550, 150, 20)
$Date = GuiCtrlCreateLabel("Date", 10, 580, 150, 20)
$Time = GuiCtrlCreateLabel("Time", 10, 610, 150, 20)
$Input_ComputerName = GuiCtrlCreateInput("" & @ComputerName, 180, 10, 280, 20)
$Input_CurrentUserName = GuiCtrlCreateInput("" & @UserName, 180, 40, 280, 20)
$Input_OperatingSystem = GuiCtrlCreateInput("" & @OSTYPE, 180, 70, 280, 20)
$Input_ServicePack = GuiCtrlCreateInput("" & @OSServicePack, 180, 100, 280, 20)
$Input_VolumeLabel = GuiCtrlCreateInput("" & $VOL, 180, 130, 280, 20)
$Input_SerialNumber = GuiCtrlCreateInput("" & $SERIAL, 180, 160, 280, 20)
$Input_TotalSpace = GuiCtrlCreateInput("" & $TOTAL, 180, 190, 280, 20)
$Input_FreeSpace = GuiCtrlCreateInput("" & $FREE, 180, 220, 280, 20)
$Input_IpAddress = GuiCtrlCreateInput("" & @IPAddress1, 180, 250, 280, 20)
$Input_StartupDirectory = GuiCtrlCreateInput("" & @StartupDir, 180, 280, 280, 20)
$Input_WindowsDirectory = GuiCtrlCreateInput("" & @WindowsDir, 180, 310, 280, 20)
$Input_SystemFolderDirectory = GuiCtrlCreateInput("" & @SystemDir, 180, 340, 280, 20)
$Input_DesktopDirectory = GuiCtrlCreateInput("" & @DesktopDir, 180, 370, 280, 20)
$Input_MyDocumentsDirectory = GuiCtrlCreateInput("" & @MyDocumentsDir, 180, 400, 280, 20)
$Input_ProgramFilesDirectory = GuiCtrlCreateInput("" & @ProgramFilesDir, 180, 430, 280, 20)
$Input_StartMenuDirectory = GuiCtrlCreateInput("" & @StartMenuDir, 180, 460, 280, 20)
$Input_TemporaryFileDirectory = GuiCtrlCreateInput("" & @TempDir, 180, 490, 280, 20)
$Input_DesktopWidth = GuiCtrlCreateInput("" & @DesktopWidth, 180, 520, 280, 20)
$Input_DesktopHeight = GuiCtrlCreateInput("" & @DesktopHeight, 180, 550, 280, 20)
$Input_Date = GuiCtrlCreateInput("(MONTH)(DAY)(YEAR) " & @MON & "-" & @MDAY & "-" & @YEAR, 180, 580, 280, 20)
$Input_Time = GuiCtrlCreateInput("(HOUR)(MIN)(SEC) " & @HOUR &  ":" & @MIN & ":" & @SEC, 180, 610, 280, 20)

GuiSetState()
While 1
    $msg = GuiGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
    Case Else
    ;;;
    EndSelect
WEnd
Exit