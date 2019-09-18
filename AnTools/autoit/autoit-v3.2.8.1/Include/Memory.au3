#include-once
; ====================================================================================================
; AutoIt Version : 3.2.+++
; Author ........: Paul Campbell
; Modified.......: Gary Frost
; Description ...: Memory management routines
; Notes .........:
; ====================================================================================================

; ====================================================================================================
; MEMMAP Definition
; ====================================================================================================

Global Const $MEM_MAP = "uint;uint;ptr"

; ====================================================================================================
; MemMap Position Constants
; ====================================================================================================

Global Const $MEM_MAP_HPROC = 1
Global Const $MEM_MAP_ISIZE = 2
Global Const $MEM_MAP_PMEM = 3

; ====================================================================================================
; VirtualAlloc Allocation Type Constants
; ====================================================================================================

;Global Const $MEM_COMMIT = 0x00001000
;Global Const $MEM_RESERVE = 0x00002000
;Global Const $MEM_TOP_DOWN = 0x00100000
;Global Const $MEM_SHARED = 0x08000000

; ====================================================================================================
; VirtualFree FreeType Constants
; ====================================================================================================

;Global Const $MEM_DECOMMIT = 0x00004000
;Global Const $MEM_RELEASE = 0x00008000

; ====================================================================================================
; VirtualAlloc Protection Constants
; ====================================================================================================

;Global Const $PAGE_NOACCESS = 0x00000001
;Global Const $PAGE_READONLY = 0x00000002
;Global Const $PAGE_READWRITE = 0x00000004
;Global Const $PAGE_EXECUTE = 0x00000010
;Global Const $PAGE_EXECUTE_READ = 0x00000020
;Global Const $PAGE_EXECUTE_READWRITE = 0x00000040
;Global Const $PAGE_GUARD = 0x00000100
;Global Const $PAGE_NOCACHE = 0x00000200

; ====================================================================================================
; OpenProcess Access Constants
; ====================================================================================================

;Global Const $PROCESS_TERMINATE = 0x00000001
;Global Const $PROCESS_CREATE_THREAD = 0x00000002
;Global Const $PROCESS_VM_OPERATION = 0x00000008
;Global Const $PROCESS_VM_READ = 0x00000010
;Global Const $PROCESS_VM_WRITE = 0x00000020
;Global Const $PROCESS_DUP_HANDLE = 0x00000040
;Global Const $PROCESS_CREATE_PROCESS = 0x00000080
;Global Const $PROCESS_SET_INFORMATION = 0x00000200
;Global Const $PROCESS_QUERY_INFORMATION = 0x00000400
;Global Const $SYNCHRONIZE = 0x00100000
;Global Const $PROCESS_ALL_ACCESS = 0x001F0FFF

; ====================================================================================================
; Description ..: Releases a memory map structure
; Parameters ...: $rMemMap      - The MEM_MAP structure to release
; Return values : True  - Success
;                 False - Function failed
; Notes ........: $rMemMap must have first been initialized with a call to _MemInit
; ====================================================================================================
Func _MemFree(ByRef $rMemMap)
	Local $hProcess
	Local $pMemory
	Local $bResult
	Local $MEM_RELEASE = 0x00008000

	$hProcess = DllStructGetData($rMemMap, $MEM_MAP_HPROC)
	$pMemory = DllStructGetData($rMemMap, $MEM_MAP_PMEM)
	Switch @OSVersion
		Case "WIN_ME", "WIN_98", "WIN_95"
			$bResult = _VirtualFree($pMemory, 0, $MEM_RELEASE)
		Case Else
			$bResult = _VirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
	EndSwitch
	_CloseHandle($hProcess)
	$rMemMap = 0
	Return $bResult
EndFunc   ;==>_MemFree

; ====================================================================================================
; Description ..: Closes an open object handle
; Parameters ...: $hObject      - Handle of object to close
; Return values : Success - True
;                 Failure - False
; ====================================================================================================
Func _CloseHandle($hObject)
	Local $aResult = DllCall("Kernel32.dll", "int", "CloseHandle", "int", $hObject)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>_CloseHandle

; ====================================================================================================
; Description ..: Reserves or commits a region of pages in the virtual address space  of  the  calling
;                 process. Memory allocated by this function is automatically initialized to zero.
; Parameters ...: $pAddress     - Specifies the desired starting address of the  region  to  allocate.
;                   If the memory is being reserved, the specified address is rounded down to the next
;                   64-kilobyte boundary. If the memory is already reserved and  is  being  committed,
;                   the address is rounded down to the next page boundary. To determine the size of a
;                   page on the host computer, use the GetSystemInfo function.   If this parameter is
;                   0, the system determines where to allocate the region.
;                 $iSize        - Specifies the size, in bytes, of  the  region.    If  the  $pAddress
;                   parameter is 0, this value is rounded up to the next page boundary. Otherwise, the
;                   allocated pages include all pages containing one or more bytes in the  range  from
;                   $pAddress to ($pAddress + $iSize).   This means that a 2-byte range  straddling  a
;                   page boundary causes both pages to be included in the allocated region.
;                 $iAllocation  - Specifies the type of allocation:
;                   MEM_COMMIT   - Allocates physical storage in memory or in the paging file on  disk
;                     for the specified region of pages.  An attempt to commit  an  already  committed
;                     page will not cause the function to fail.  This means that a range of  committed
;                     or decommitted pages can be committed without having to worry about a failure.
;                   MEM_RESERVE  - Reserves a range of the process's  virtual  address  space  without
;                     allocating any physical storage.  The reserved range cannot be used by any other
;                     allocation operations until it is released.   Reserved pages can be committed in
;                     subsequent calls to VirtualAlloc.
;                   MEM_TOP_DOWN - Allocates memory at the highest possible address.
;                 $iProtect     - Type of access protection:
;                   PAGE_READONLY          - Enables read access to the committed region of pages.  An
;                     attempt to write to the committed region results in an access violation.
;                   PAGE_READWRITE         - Enables read and write access to the committed region
;                   PAGE_EXECUTE           - Enables execute access to the committed region
;                   PAGE_EXECUTE_READ      - Enables execute and read access to the committed region
;                   PAGE_EXECUTE_READWRITE - Enables execute, read, and write access to the  committed
;                     region of pages.
;                   PAGE_GUARD             - Pages in the region become guard pages.   Any attempt  to
;                     read from or write to a guard page  causes  the  operating  system  to  raise  a
;                     STATUS_GUARD_PAGE exception and turn off the guard page status.
;                   PAGE_NOACCESS          - Disables all access to the committed region of pages
;                   PAGE_NOCACHE           - Allows no caching of the committed regions of pages.  The
;                     hardware attributes for the physical memory should be specified as "no cache."
; Return values : Memory address pointer
; ====================================================================================================
Func _VirtualAlloc($pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("Kernel32.dll", "ptr", "VirtualAlloc", "ptr", $pAddress, "int", $iSize, "int", $iAllocation, "int", $iProtect)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>_VirtualAlloc

; ====================================================================================================
; Description ..: Reserves a region of memory within the virtual address space of a specified process
; Parameters ...: $hProcess     - Handle to a process.   The function allocates memory in the  virtual
;                   address space of this process.   You must have PROCESS_VM_OPERATION access to  the
;                   process. If you do not, the function fails.
;                 $pAddress     - Same as VirtualAlloc
;                 $iSize        - Same as VirtualAlloc
;                 $iAllocation  - Same as VirtualAlloc
;                 $iProtect     - Same as VirtualAlloc
; Return values : Memory address pointer
; ====================================================================================================
Func _VirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("Kernel32.dll", "ptr", "VirtualAllocEx", "int", $hProcess, "ptr", $pAddress, "int", $iSize, "int", $iAllocation, "int", $iProtect)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>_VirtualAllocEx

; ====================================================================================================
; Description ..: Releases a region of pages within the virtual address space of a process
; Parameters ...: $pAddress     - Points to the base address of the region of pages to be  freed.   If
;                   the $iFreeType parameter includes MEM_RELEASE this  parameter  must  be  the  base
;                   address returned by VirtualAlloc when the region of pages was reserved.
;                 $iSize        - Specifies the size, in bytes, of the region to  be  freed.   If  the
;                   $iFreeType parameter includes the MEM_RELEASE flag, this parameter must  be  zero.
;                   Otherwise, the region of affected pages includes all pages containing one or  more
;                   bytes in the range from the  $pAddress  parameter  to  ($pAddress + $iSize).  This
;                   means that a 2-byte range straddling a page boundary causes both pages to be freed.
;                 $iFreeType    - Specifies the type of free operation:
;                   MEM_DECOMMIT - Decommits the specified region of committed pages.   An attempt  to
;                     decommit an uncommitted page will not cause the function  to  fail.  This  means
;                     that a range of committed  or  uncommitted  pages  can  be  decommitted  without
;                     having to worry about a failure.
;                   MEM_RELEASE  - Releases the specified region of reserved pages.   If this flag  is
;                     specified, the $iSize parameter must be zero or the function fails.
; Return values : Success - True
;                 Failure - False
; ====================================================================================================
Func _VirtualFree($pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("Kernel32.dll", "ptr", "VirtualFree", "ptr", $pAddress, "int", $iSize, "int", $iFreeType)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>_VirtualFree

; ====================================================================================================
; Description ..: Releases a region of pages within the virtual address space of a process
; Parameters ...: $hProcess     - Handle to a process.   The function frees memory within the  virtual
;                   address space of this process.   You must have PROCESS_VM_OPERATION access to this
;                   process. If you do not, the function fails.
;                 $pAddress     - See _VirtualFree
;                 $iSize        - See _VirtualFree
;                 $iFreeType    - See _VirtualFree
; Return values : Success - True
;                 Failure - False
; ====================================================================================================
Func _VirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("Kernel32.dll", "ptr", "VirtualFreeEx", "hwnd", $hProcess, "ptr", $pAddress, "int", $iSize, "int", $iFreeType)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>_VirtualFreeEx

; ====================================================================================================
; Description ..: Retrieves the identifier of the thread that created the  specified  window  and  the
;                 identifier of the process that created the window.
; Parameters ...: $hWnd         - Window handle
;                 $iProcessID   - Process ID of the specified window.  If this parameter is not 0, the
;                                 function copies the identifier of the process otherwise it does not.
; Return values : Thread ID of the specified window
; ====================================================================================================
Func _GetWindowThreadProcessId($hWnd, ByRef $iProcessID)
	Local $rProcessID, $aResult
	$rProcessID = DllStructCreate("int")
	$aResult = DllCall("User32.dll", "int", "GetWindowThreadProcessId", "hwnd", $hWnd, "ptr", DllStructGetPtr($rProcessID))
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	$iProcessID = DllStructGetData($rProcessID, 1)
	Return $aResult[0]
EndFunc   ;==>_GetWindowThreadProcessId

; ====================================================================================================
; Description ..: Returns a handle of an existing process object
; Parameters ...: $iAccess      - Specifies the access to the process object
;                 $bInherit     - Specifies whether the returned handle can be inherited
;                 $iProcessID   - Specifies the process identifier of the process to open
; Return values : Open process handle to the object
; ====================================================================================================
Func _OpenProcess($iAccess, $bInherit, $iProcessID)
	Local $aResult = DllCall("Kernel32.Dll", "int", "OpenProcess", "int", $iAccess, "int", $bInherit, "int", $iProcessID)
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	Return $aResult[0]
EndFunc   ;==>_OpenProcess

; ====================================================================================================
; Description ..: Read memory in a specified process
; Parameters ...: $hProcess     - Identifies an open handle of a process whose memory  is  read.   The
;                   handle must have PROCESS_VM_READ access to the process.
;                 $pBaseAddress - Points to the base address in the  specified  process  to  be  read.
;                   Before any data transfer occurs, the system verifies that all  data  in  the  base
;                   address and memory of the specified size is accessible for read access. If this is
;                   the case the function proceeds otherwise the function fails.
;                 $pBuffer      - Points to a buffer that receives the contents from the address space
;                   of the specified process.
;                 $iSize        - Specifies the requested number of bytes to read from  the  specified
;                   process.
;                 $iBytesRead   - The actual number of bytes transferred into the specified buffer. If
;                   $iBytesRead is 0, the parameter is ignored.
; Return values : Success - True
;                 Failure - False
; ====================================================================================================
Func _ReadProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iBytesRead)
	Local $rBytesRead = DllStructCreate("int")
	Local $aResult = DllCall("Kernel32.dll", "int", "ReadProcessMemory", "int", $hProcess, "int", $pBaseAddress, _
			"ptr", $pBuffer, "int", $iSize, "ptr", DllStructGetPtr($rBytesRead))
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	$iBytesRead = DllStructGetData($rBytesRead, 1)
	$rBytesRead = 0
	Return $aResult[0]
EndFunc   ;==>_ReadProcessMemory

; ====================================================================================================
; Description ..: Writes memory in a specified process
; Parameters ...: $hProcess     - Identifies an open handle to a process whose memory is to be written
;                   to.   The handle must have PROCESS_VM_WRITE and PROCESS_VM_OPERATION access to the
;                   process.
;                 $pBaseAddress - Points to the base address in the specified process to be written to
;                   Before any data transfer occurs, the system verifies that all  data  in  the  base
;                   address and memory of the specified size is accessible for write access. If so the
;                   function proceeds otherwise the function fails.
;                 $pBuffer      - Points to the buffer that supplies  data  to  be  written  into  the
;                   address space of the specified process.
;                 $iSize        - Specifies the number of bytes to write into the specified process
;                 $iBytesWritten- The actual number of bytes transferred into the  specified  process.
;                   This parameter is optional. If $iBytesWritten is 0, the parameter is ignored.
; Return values : Success - True
;                 Failure - False
; ====================================================================================================
Func _WriteProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iBytesWritten)
	Local $rBytesWritten = DllStructCreate("int")
	Local $aResult = DllCall("Kernel32.dll", "int", "WriteProcessMemory", "int", $hProcess, "int", $pBaseAddress, _
			"ptr", $pBuffer, "int", $iSize, "int", DllStructGetPtr($rBytesWritten))
	If @error Or Not IsArray($aResult) Then Return SetError(-1, -1, 0)
	$iBytesWritten = DllStructGetData($rBytesWritten, 1)
	$rBytesWritten = 0
	Return $aResult[0]
EndFunc   ;==>_WriteProcessMemory


; ====================================================================================================
; Description ..: Initializes a memory map structure based on a windows handle
; Parameters ...: $hWnd         - Window handle of the process where memory will be mapped
;                 $iSize        - Size in bytes of memory space
;                 $rMemMap      - MEM_MAP structure
;                 $pAddress     - Pointer that specifies a desired starting address for the region  of
;                   pages that you want to allocate.  If you are reserving memory, the function rounds
;                   this address down to the nearest 64K  boundary.  If you are committing memory that
;                   is already reserved, the function rounds this address down  to  the  nearest  page
;                   boundary. To determine the size of a page, use  the  GetSystemInfo  function.   If
;                   $pAddress is 0, the function will determine where to allocate the region.
; Return values : Pointer to reserved memory
; ====================================================================================================
Func _MemInit($hWnd, $iSize, ByRef $rMemMap, $pAddress = 0)
	Local $iAccess, $iAllocation
	Local $pMemory, $hProcess
	Local $iProcessID
	Local $PROCESS_VM_OPERATION = 0x00000008
	Local $PROCESS_VM_READ = 0x00000010
	Local $PROCESS_VM_WRITE = 0x00000020
	Local $MEM_RESERVE = 0x00002000
	Local $MEM_COMMIT = 0x00001000
	Local $MEM_SHARED = 0x08000000
	Local $PAGE_READWRITE = 0x00000004
;~ 	, $iThreadID

;~ 	$iThreadID = _GetWindowThreadProcessId($hWnd, $iProcessID)
	_GetWindowThreadProcessId($hWnd, $iProcessID)
	$iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
	$hProcess = _OpenProcess($iAccess, False, $iProcessID)
	Switch @OSVersion
		Case "WIN_ME", "WIN_98", "WIN_95"
			$iAllocation = BitOR($MEM_RESERVE, $MEM_COMMIT, $MEM_SHARED)
			$pMemory = _VirtualAlloc($pAddress, $iSize, $iAllocation, $PAGE_READWRITE)
		Case Else
			$iAllocation = BitOR($MEM_RESERVE, $MEM_COMMIT)
			$pMemory = _VirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $PAGE_READWRITE)
	EndSwitch
	If @error Then Return SetError(-1, -1, 0)
	$rMemMap = DllStructCreate($MEM_MAP)
	DllStructSetData($rMemMap, $MEM_MAP_HPROC, $hProcess)
	DllStructSetData($rMemMap, $MEM_MAP_ISIZE, $iSize)
	DllStructSetData($rMemMap, $MEM_MAP_PMEM, $pMemory)
	Return $pMemory
EndFunc   ;==>_MemInit

; ====================================================================================================
; Description ..: Transfer memory from external address space to internal address space
; Parameters ...: $rMemMap      - MEM_MAP structure
;                 $pSrce        - Pointer to external memory
;                 $pDest        - Pointer to internal memory
;                 $iSize        - Size in bytes of memory to read
; Return values : True  - Success
;                 False - Failure
; ====================================================================================================
Func _MemRead($rMemMap, $pSrce, $pDest, $iSize)
	Local $hProcess
	Local $iWritten

	$hProcess = DllStructGetData($rMemMap, $MEM_MAP_HPROC)
	Return _ReadProcessMemory($hProcess, $pSrce, $pDest, $iSize, $iWritten)
EndFunc   ;==>_MemRead

; ====================================================================================================
; Description ..: Transfer memory to external address space from internal address space
; Parameters ...: $rMemMap      - MEM_MAP structure
;                 $pSrce        - Pointer to internal memory
;                 $pDest        - Pointer to external memory.    If this value is 0, then  the  memory
;                   pointer from $rMemMap will be used.
;                 $iSize        - Size in bytes of memory to write.  If this value is 0, then the size
;                   value from $rMemMap will be used.
; Return values : True  - Success
;                 False - Failure
; ====================================================================================================
Func _MemWrite($rMemMap, $pSrce, $pDest = 0, $iSize = 0)
	Local $hProcess
	Local $iWritten

	If $pDest = 0 Then
		$pDest = DllStructGetData($rMemMap, $MEM_MAP_PMEM)
	EndIf
	If $iSize = 0 Then
		$iSize = DllStructGetData($rMemMap, $MEM_MAP_ISIZE)
	EndIf
	$hProcess = DllStructGetData($rMemMap, $MEM_MAP_HPROC)
	Return _WriteProcessMemory($hProcess, $pDest, $pSrce, $iSize, $iWritten)
EndFunc   ;==>_MemWrite

; ====================================================================================================
; Description ..: Maps a character string to a wide-character (Unicode) string
; Parameters ...: $sText        - Text to be converted
;                 $iCodePage    - Specifies the code page to be used to perform the conversion:
;                   CP_ACP   - ANSI code page
;                   CP_MACCP - Macintosh code page
;                   CP_OEMCP - OEM code page
;                 $iFlags       - A set of bit flags that indicate whether to translate to precomposed
;                   or composite wide characters:
;                   MB_PRECOMPOSED   - Always use precomposed characters
;                   MB_COMPOSITE     - Always use composite characters
;                   MB_USEGLYPHCHARS - Use glyph characters instead of control characters
; Return values : Structure that contains the Unicode character string
; ====================================================================================================
Func _MultiByteToWideChar($s_Text, $i_CodePage = 0, $i_Flags = 1)
	Local $iBuffLen = StringLen($s_Text)
	Local $rUnicode = DllStructCreate("byte[" & ($iBuffLen * 2) & "]")
	Local $pUnicode = DllStructGetPtr($rUnicode)
	DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $i_CodePage, "int", $i_Flags, _
			"str", $s_Text, "int", $iBuffLen, "ptr", $pUnicode, "int", $iBuffLen * 2)
	If @error Then Return SetError(-1, -1, 0)
	Return DllStructGetData($rUnicode, 1)
EndFunc   ;==>_MultiByteToWideChar