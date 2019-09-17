#ifndef __AUTOIT3_H
#define __AUTOIT3_H

///////////////////////////////////////////////////////////////////////////////
//
// AutoItX v3
//
// Copyright (C)1999-2007:
//		- Jonathan Bennett <jon at autoitscript dot com>
//		- See "AUTHORS.txt" for contributors.
//
// This file is part of AutoItX.  Use of this file and the AutoItX DLL is subject
// to the terms of the AutoItX license details of which can be found in the helpfile.
//
// When using the AutoItX3.dll as a standard DLL this file contains the definitions,
// and function declarations required to use the DLL and AutoItX3.lib file.
//
///////////////////////////////////////////////////////////////////////////////


#ifdef __cplusplus
	#define AU3_API extern "C"
#else
	#define AU3_API
#endif


// Definitions
#define AU3_INTDEFAULT			(-2147483647)	// "Default" value for _some_ int parameters (largest negative number)


///////////////////////////////////////////////////////////////////////////////
// Exported functions
///////////////////////////////////////////////////////////////////////////////

AU3_API void WINAPI AU3_Init(void);
AU3_API long AU3_error(void);

AU3_API long WINAPI AU3_AutoItSetOption(const char *szOption, long nValue);

AU3_API void WINAPI AU3_BlockInput(long nFlag);

AU3_API void WINAPI AU3_CDTray(const char *szDrive, const char *szAction);
AU3_API void WINAPI AU3_ClipGet(char *szClip, int nBufSize);
AU3_API void WINAPI AU3_ClipPut(const char *szClip);
AU3_API long WINAPI AU3_ControlClick(const char *szTitle, const char *szText, const char *szControl, const char *szButton, long nNumClicks, /*[in,defaultvalue(AU3_INTDEFAULT)]*/long nX, /*[in,defaultvalue(AU3_INTDEFAULT)]*/long nY);
AU3_API void WINAPI AU3_ControlCommand(const char *szTitle, const char *szText, const char *szControl, const char *szCommand, const char *szExtra, char *szResult, int nBufSize);
AU3_API void WINAPI AU3_ControlListView(const char *szTitle, const char *szText, const char *szControl, const char *szCommand, const char *szExtra1, const char *szExtra2, char *szResult, int nBufSize);
AU3_API long WINAPI AU3_ControlDisable(const char *szTitle, const char *szText, const char *szControl);
AU3_API long WINAPI AU3_ControlEnable(const char *szTitle, const char *szText, const char *szControl);
AU3_API long WINAPI AU3_ControlFocus(const char *szTitle, const char *szText, const char *szControl);
AU3_API void WINAPI AU3_ControlGetFocus(const char *szTitle, const char *szText, char *szControlWithFocus, int nBufSize);
AU3_API void WINAPI AU3_ControlGetHandle(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, const char *szControl, char *szRetText, int nBufSize);
AU3_API long WINAPI AU3_ControlGetPosX(const char *szTitle, const char *szText, const char *szControl);
AU3_API long WINAPI AU3_ControlGetPosY(const char *szTitle, const char *szText, const char *szControl);
AU3_API long WINAPI AU3_ControlGetPosHeight(const char *szTitle, const char *szText, const char *szControl);
AU3_API long WINAPI AU3_ControlGetPosWidth(const char *szTitle, const char *szText, const char *szControl);
AU3_API void WINAPI AU3_ControlGetText(const char *szTitle, const char *szText, const char *szControl, char *szControlText, int nBufSize);
AU3_API long WINAPI AU3_ControlHide(const char *szTitle, const char *szText, const char *szControl);
AU3_API long WINAPI AU3_ControlMove(const char *szTitle, const char *szText, const char *szControl, long nX, long nY, /*[in,defaultvalue(-1)]*/long nWidth, /*[in,defaultvalue(-1)]*/long nHeight);
AU3_API long WINAPI AU3_ControlSend(const char *szTitle, const char *szText, const char *szControl, const char *szSendText, /*[in,defaultvalue(0)]*/long nMode);
AU3_API long WINAPI AU3_ControlSetText(const char *szTitle, const char *szText, const char *szControl, const char *szControlText);
AU3_API long WINAPI AU3_ControlShow(const char *szTitle, const char *szText, const char *szControl);

AU3_API void WINAPI AU3_DriveMapAdd(const char *szDevice, const char *szShare, long nFlags, /*[in,defaultvalue("")]*/const char *szUser, /*[in,defaultvalue("")]*/const char *szPwd, char *szResult, int nBufSize);
AU3_API long WINAPI AU3_DriveMapDel(const char *szDevice);
AU3_API void WINAPI AU3_DriveMapGet(const char *szDevice, char *szMapping, int nBufSize);

AU3_API long WINAPI AU3_IniDelete(const char *szFilename, const char *szSection, const char *szKey);
AU3_API void WINAPI AU3_IniRead(const char *szFilename, const char *szSection, const char *szKey, const char *szDefault, char *szValue, int nBufSize);
AU3_API long WINAPI AU3_IniWrite(const char *szFilename, const char *szSection, const char *szKey, const char *szValue);
AU3_API long WINAPI AU3_IsAdmin(void);

AU3_API long WINAPI AU3_MouseClick(/*[in,defaultvalue("LEFT")]*/const char *szButton, /*[in,defaultvalue(AU3_INTDEFAULT)]*/long nX, /*[in,defaultvalue(AU3_INTDEFAULT)]*/long nY, /*[in,defaultvalue(1)]*/long nClicks, /*[in,defaultvalue(-1)]*/long nSpeed);
AU3_API long WINAPI AU3_MouseClickDrag(const char *szButton, long nX1, long nY1, long nX2, long nY2, /*[in,defaultvalue(-1)]*/long nSpeed);
AU3_API void WINAPI AU3_MouseDown(/*[in,defaultvalue("LEFT")]*/const char *szButton);
AU3_API long WINAPI AU3_MouseGetCursor(void);
AU3_API long WINAPI AU3_MouseGetPosX(void);
AU3_API long WINAPI AU3_MouseGetPosY(void);
AU3_API long WINAPI AU3_MouseMove(long nX, long nY, /*[in,defaultvalue(-1)]*/long nSpeed);
AU3_API void WINAPI AU3_MouseUp(/*[in,defaultvalue("LEFT")]*/const char *szButton);
AU3_API void WINAPI AU3_MouseWheel(const char *szDirection, long nClicks);

AU3_API long WINAPI AU3_Opt(const char *szOption, long nValue);

AU3_API long WINAPI AU3_PixelChecksum(long nLeft, long nTop, long nRight, long nBottom, /*[in,defaultvalue(1)]*/long nStep);
AU3_API long WINAPI AU3_PixelGetColor(long nX, long nY);
AU3_API void WINAPI AU3_PixelSearch(long nLeft, long nTop, long nRight, long nBottom, long nCol, /*default 0*/long nVar, /*default 1*/long nStep, LPPOINT pPointResult);
AU3_API long WINAPI AU3_ProcessClose(const char *szProcess);
AU3_API long WINAPI AU3_ProcessExists(const char *szProcess);
AU3_API long WINAPI AU3_ProcessSetPriority(const char *szProcess, long nPriority);
AU3_API long WINAPI AU3_ProcessWait(const char *szProcess, /*[in,defaultvalue(0)]*/long nTimeout);
AU3_API long WINAPI AU3_ProcessWaitClose(const char *szProcess, /*[in,defaultvalue(0)]*/long nTimeout);
AU3_API long WINAPI AU3_RegDeleteKey(const char *szKeyname);
AU3_API long WINAPI AU3_RegDeleteVal(const char *szKeyname, const char *szValuename);
AU3_API void WINAPI AU3_RegEnumKey(const char *szKeyname, long nInstance, char *szResult, int nBufSize);
AU3_API void WINAPI AU3_RegEnumVal(const char *szKeyname, long nInstance, char *szResult, int nBufSize);
AU3_API void WINAPI AU3_RegRead(const char *szKeyname, const char *szValuename, char *szRetText, int nBufSize);
AU3_API long WINAPI AU3_RegWrite(const char *szKeyname, const char *szValuename, const char *szType, const char *szValue);
AU3_API long WINAPI AU3_Run(const char *szRun, /*[in,defaultvalue("")]*/const char *szDir, /*[in,defaultvalue(1)]*/long nShowFlags);
AU3_API long WINAPI AU3_RunAsSet(const char *szUser, const char *szDomain, const char *szPassword, int nOptions);
AU3_API long WINAPI AU3_RunWait(const char *szRun, /*[in,defaultvalue("")]*/const char *szDir, /*[in,defaultvalue(1)]*/long nShowFlags);

AU3_API void WINAPI AU3_Send(const char *szSendText, /*[in,defaultvalue(0)]*/long nMode);
AU3_API long WINAPI AU3_Shutdown(long nFlags);
AU3_API void WINAPI AU3_Sleep(long nMilliseconds);
AU3_API void WINAPI AU3_StatusbarGetText(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, /*[in,defaultvalue(1)]*/long nPart, char *szStatusText, int nBufSize);

AU3_API void WINAPI AU3_ToolTip(const char *szTip, /*[in,defaultvalue(AU3_INTDEFAULT)]*/long nX, /*[in,defaultvalue(AU3_INTDEFAULT)]*/long nY);

AU3_API void WINAPI AU3_WinActivate(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinActive(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinClose(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinExists(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinGetCaretPosX(void);
AU3_API long WINAPI AU3_WinGetCaretPosY(void);
AU3_API void WINAPI AU3_WinGetClassList(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, char *szRetText, int nBufSize);
AU3_API long WINAPI AU3_WinGetClientSizeHeight(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinGetClientSizeWidth(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API void WINAPI AU3_WinGetHandle(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, char *szRetText, int nBufSize);
AU3_API long WINAPI AU3_WinGetPosX(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinGetPosY(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinGetPosHeight(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinGetPosWidth(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API void WINAPI AU3_WinGetProcess(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, char *szRetText, int nBufSize);
AU3_API long WINAPI AU3_WinGetState(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API void WINAPI AU3_WinGetText(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, char *szRetText, int nBufSize);
AU3_API void WINAPI AU3_WinGetTitle(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, char *szRetText, int nBufSize);
AU3_API long WINAPI AU3_WinKill(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText);
AU3_API long WINAPI AU3_WinMenuSelectItem(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, const char *szItem1, const char *szItem2, const char *szItem3, const char *szItem4, const char *szItem5, const char *szItem6, const char *szItem7, const char *szItem8);
AU3_API void WINAPI AU3_WinMinimizeAll();
AU3_API void WINAPI AU3_WinMinimizeAllUndo();
AU3_API long WINAPI AU3_WinMove(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, long nX, long nY, /*[in,defaultvalue(-1)]*/long nWidth, /*[in,defaultvalue(-1)]*/long nHeight);
AU3_API long WINAPI AU3_WinSetOnTop(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, long nFlag);
AU3_API long WINAPI AU3_WinSetState(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, long nFlags);
AU3_API long WINAPI AU3_WinSetTitle(const char *szTitle,/*[in,defaultvalue("")]*/ const char *szText, const char *szNewTitle);
AU3_API long WINAPI AU3_WinSetTrans(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, long nTrans);

AU3_API long WINAPI AU3_WinWait(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, /*[in,defaultvalue(0)]*/long nTimeout);
AU3_API long WINAPI AU3_WinWaitActive(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, /*[in,defaultvalue(0)]*/long nTimeout);
AU3_API long WINAPI AU3_WinWaitClose(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, /*[in,defaultvalue(0)]*/long nTimeout);
AU3_API long WINAPI AU3_WinWaitNotActive(const char *szTitle, /*[in,defaultvalue("")]*/const char *szText, /*[in,defaultvalue(0)]*/long nTimeout);


///////////////////////////////////////////////////////////////////////////////

#endif
