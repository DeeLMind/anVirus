// stdafx.cpp : 只包括标准包含文件的源文件
// AutoDec.pch 将作为预编译头
// stdafx.obj 将包含预编译类型信息

#include "stdafx.h"


//转换十六进制的缓冲为字符串格式
void WINAPI ConvertHex2String(BYTE *lpInBuffer, int nInSize, LPTSTR lpOutString, BOOL bOneLine)
{
	int nSrcPos = 0;
	int nDstPos = 0; 
	while (nSrcPos < nInSize)
	{
		TCHAR szTmpString[4] = {0};
		::wsprintf(szTmpString, _T("%02X "), *(BYTE *)(lpInBuffer + nSrcPos));
		::RtlCopyMemory(lpOutString + nDstPos, szTmpString, 4*sizeof(TCHAR));
		nDstPos += 3;
		nSrcPos++;

		if (!bOneLine)
		{
			if (0 == nSrcPos % 16)
			{
				lpOutString[nDstPos++] = 0x0D;
				lpOutString[nDstPos++] = 0x0A;
			}
		}
	}

	int nLen = ::lstrlen(lpOutString);
	if (0 == nLen)
	{
		return;
	}

	if ('\n' == lpOutString[nLen-1])
	{
		lpOutString[nLen-1] = 0;

		if (nLen < 2)
		{
			return;
		}

		if (' ' == lpOutString[nLen-2])
		{
			lpOutString[nLen-2] = 0;
		}
	}
	else if (' ' == lpOutString[nLen-1])
	{
		lpOutString[nLen-1] = 0;
	}
}