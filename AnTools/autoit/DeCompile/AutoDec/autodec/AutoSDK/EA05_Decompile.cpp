#include "StdAfx.h"
#include "EA05_Decompile.h"
#include "EANEW_UnCompress.h"

typedef struct _AUTOIT_EA05_DECRYPTHANDLE
{
	UINT *next;
	UINT items;
	UINT mt[624];
}AUTOIT_EA05_DECRYPTHANDLE, *PAUTOIT_EA05_DECRYPTHANDLE;

BYTE AUTOIT_EA05_GetNext(AUTOIT_EA05_DECRYPTHANDLE *lpHandle) 
{
	if (!--lpHandle->items) 
	{
		UINT *mt = lpHandle->mt;
		lpHandle->items = 624;
		lpHandle->next = mt;

		int i = 0;
		for (i=0; i<227; i++)
		{
			mt[i] = ((((mt[i] ^ mt[i+1])&0x7ffffffe)^mt[i])>>1)^((0-(mt[i+1]&1))&0x9908b0df)^mt[i+397];
		}

		for (; i<623; i++)
		{
			mt[i] = ((((mt[i] ^ mt[i+1])&0x7ffffffe)^mt[i])>>1)^((0-(mt[i+1]&1))&0x9908b0df)^mt[i-227];
		}

		mt[623] = ((((mt[623] ^ mt[0])&0x7ffffffe)^mt[623])>>1)^((0-(mt[0]&1))&0x9908b0df)^mt[i-227];
	}

	UINT r = *(lpHandle->next++);
	r ^= (r >> 11);
	r ^= ((r & 0xff3a58ad) << 7);
	r ^= ((r & 0xffffdf8c) << 15);
	r ^= (r >> 18);

	return (BYTE)(r >> 1);
}

void AUTOIT_EA05_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed)
{
	AUTOIT_EA05_DECRYPTHANDLE hDecHandle = {0};
	UINT *mt = hDecHandle.mt;

	*mt = nSeed;
	for(int i=1; i<624; i++)
	{
		mt[i] = i + 0x6c078965*((mt[i-1]>>30) ^ mt[i-1]);
	}

	hDecHandle.items = 1;

	while (nSize--)
	{
		*lpBuffer++ ^= AUTOIT_EA05_GetNext(&hDecHandle);
	}
}

//判断函数
BOOL AUTOIT_EA05_IsEA05(AUTOIT3_DECOMPILER *lpDecHandle)
{
	//16字节GUID
	static const BYTE cbAutoGUID[] = 
	{
		0xA3, 0x48, 0x4B, 0xBE, 0x98, 0x6C, 0x4A, 0xA9, 
		0x99, 0x4C, 0x53, 0x0A, 0x86, 0xD6, 0x48, 0x7D
	};

	//数据指针
	BYTE *lpDataPtr = lpDecHandle->lpDataPtr;

	//GUID起始标识比较
	int nRet = memcmp(lpDataPtr, cbAutoGUID, 16);
	if (0 != nRet)
	{
		return FALSE;
	}
	lpDataPtr += 16;

	//压缩版本"AU3!EA05",末尾也有这个标识,但不校验
	static const BYTE cbAutoVersion[] = 
	{
		0x41, 0x55, 0x33, 0x21, 0x45, 0x41, 0x30, 0x35
	};

	//压缩版本比较
	nRet = memcmp(lpDataPtr, cbAutoVersion, sizeof(cbAutoVersion));
	if (0 != nRet)
	{
		return FALSE;
	}

	return TRUE;
}

//计算文件校验和
DWORD AUTOIT_EA05_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize)
{
	DWORD dwChkValue = 0;
	if ( dwSize > 0 )
	{
		DWORD dwValue = 1;
		UINT nTmpValue1 = (WORD)dwValue;
		UINT nTmpValue2 = dwValue >> 16;

		DWORD dwIndex = 0;
		do
		{
			nTmpValue1 = (nTmpValue1 + lpBuffer[dwIndex++]) % 0xFFF1;
			nTmpValue2 = (nTmpValue1 + nTmpValue2) % 0xFFF1;
		}
		while (dwIndex < dwSize);

		dwChkValue = nTmpValue1 + (nTmpValue2 << 16);
	}

	return dwChkValue;
}

BOOL AUTOIT_EA05_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent)
{
	//跳过16字节GUID及8字节版本标识
	BYTE *lpDataBufPtr = lpDecHandle->lpDataPtr + (16 + 8);

	//16字节的密码数据,用于计算加密种子(从该版本开始已经不能用官方工具反编译了)
	DWORD dwPwdSeed = 0;
	for (int i=0; i<16; i++)
	{
		dwPwdSeed += lpDataBufPtr[i];
	}
	lpDataBufPtr += 16;

	//下面循环进行数据解密处理,脚本数据位于最前面
	BOOL bRet = FALSE;
	DWORD dwFileCount = 0;
	do
	{
		//解密文件标识字符串"FILE"
		BYTE *lpFileFlagPtr = lpDataBufPtr;
		AUTOIT_EA05_DeCrypt(lpFileFlagPtr, 4, 0x16FA);
		lpDataBufPtr += 4;

		CHAR *lpFileFlag = "FILE";
		if (0 != memcmp(lpFileFlag, lpFileFlagPtr, 4))
		{
			break;
		}

		//文件序号
		lpDecHandle->decInfos.dwFileIndex = dwFileCount;
		dwFileCount++;

		//脚本标识串长度
		DWORD dwScriptFlagLen = *(DWORD *)lpDataBufPtr;
		dwScriptFlagLen ^= 0x29BC;
		lpDataBufPtr += 4;

		//解密标识字符串
		BYTE *lpFlagPtrScript = lpDataBufPtr;
		AUTOIT_EA05_DeCrypt(lpFlagPtrScript, dwScriptFlagLen, dwScriptFlagLen + 0xA25E);
		lpDataBufPtr += dwScriptFlagLen;

		//路径数据长度
		DWORD dwPathLen = *(DWORD *)lpDataBufPtr;
		dwPathLen ^= 0x29AC;
		lpDataBufPtr += 4;

		//路径数据(ANSI编码)
		CHAR *lpPathPtr = (CHAR *)lpDataBufPtr;
		AUTOIT_EA05_DeCrypt((BYTE *)lpPathPtr, dwPathLen, dwPathLen + 0xF25E);
		lpDataBufPtr += dwPathLen;

		//COPY释放路径
		lpDecHandle->decInfos.bPathUnicode = FALSE;
		ZeroMemory(lpDecHandle->decInfos.szReleasePath, sizeof(lpDecHandle->decInfos.szReleasePath));
		CopyMemory(lpDecHandle->decInfos.szReleasePath, lpPathPtr, dwPathLen);

		//解压缩到目标缓冲
		DWORD dwOffset = 0;
		BYTE *lpOutPtr = NULL;
		DWORD dwOutSize = 0;
		bRet = AUTOIT_EA05_FileDecompress(lpDataBufPtr, &dwOffset, &lpOutPtr, &dwOutSize, dwPwdSeed);
		if (!bRet)
		{
			break;
		}

		if (NULL != lpDecHandle->decInfos.lpResultBuf)
		{
			delete[] lpDecHandle->decInfos.lpResultBuf;
		}
		lpDecHandle->decInfos.lpResultBuf = lpOutPtr;
		lpDecHandle->decInfos.dwResultSize = dwOutSize;

		//解压后的偏移定位
		lpDataBufPtr += dwOffset;

		//判断脚本标识
		CHAR szUnicodeFlag[MAX_PATH + 4] = ">AUTOIT UNICODE SCRIPT<";
		CHAR szAnsiFlag[MAX_PATH + 4] = ">AUTOIT SCRIPT<";
		BOOL bUnicode = (0 == memcmp(lpFlagPtrScript, szUnicodeFlag, dwScriptFlagLen));
		BOOL bAnsi = (0 == memcmp(lpFlagPtrScript, szAnsiFlag, dwScriptFlagLen));
		lpDecHandle->decInfos.bScript = (bUnicode || bAnsi);
		if (lpDecHandle->decInfos.bScript)
		{
			lpDecHandle->decInfos.bScriptUnicode = bUnicode;

			//取编译器版本信息(从解密后的脚本中获取) [字符串"; <AUT2EXE VERSION: "]
			if (lpDecHandle->decInfos.bScriptUnicode)
			{
				WCHAR *lpScript = (WCHAR *)lpDecHandle->decInfos.lpResultBuf + 1 + lstrlenW(L"; <AUT2EXE VERSION: ");
				int nLen = 0;
				do 
				{
					if (lpScript[nLen] == '>')
					{
						break;
					}

					nLen++;
				} while (nLen < 32);

				CHAR szAutoitVer[64] = {0};
				CopyMemory(szAutoitVer, lpScript, nLen*sizeof(WCHAR));

				for (int i=0; i<nLen; i++)
				{
					lpDecHandle->decInfos.szAutoitVer[i] = szAutoitVer[2*i];
				}
			}
			else
			{
				CHAR *lpScript = (CHAR *)lpDecHandle->decInfos.lpResultBuf + lstrlenA("; <AUT2EXE VERSION: ");
				int nLen = 0;
				do 
				{
					if (lpScript[nLen] == '>')
					{
						break;
					}

					nLen++;
				} while (nLen < 32);
				CopyMemory(lpDecHandle->decInfos.szAutoitVer, lpScript, nLen);
			}
		}

		//执行回调
		if (NULL != lpfnDecCallback)
		{
			BOOL bContinue = lpfnDecCallback(&lpDecHandle->decInfos, dwContent);
			if (!bContinue)
			{
				break;
			}
		}

		//判断位置是否已到达末尾,压缩版本"AU3!EA05",末尾也有这个标识,但不校验
		if ((lpDataBufPtr + 8) >= (lpDecHandle->lpFileBuf + lpDecHandle->dwFileSize))
		{
			break;
		}
	} while (TRUE);

	return bRet;
}

//文件解压缩
BOOL AUTOIT_EA05_FileDecompress(BYTE *lpInputBuf, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed)
{
	//输入缓冲
	BYTE *lpDataBuffer = lpInputBuf;

	//压缩标识
	BOOL bCompressFlag = lpDataBuffer[0];
	lpDataBuffer += 1;

	//压缩后大小
	DWORD dwCompressSize = *(DWORD *)lpDataBuffer;
	dwCompressSize ^= 0x45AA;
	lpDataBuffer += 4;

	//压缩前大小
	DWORD dwUncompressSize = *(DWORD *)lpDataBuffer;
	dwUncompressSize ^= 0x45AA;
	lpDataBuffer += 4;

	//解压校验和
	DWORD dwChkSum = *(DWORD *)lpDataBuffer;
	dwChkSum ^= 0xC3D2;
	lpDataBuffer += 4;

	//跳过16字节无用数据
	lpDataBuffer += 16;

	//解密数据,解密后如果是压缩的则是"EA05"开始
	BYTE *lpCompressData = lpDataBuffer;
	AUTOIT_EA05_DeCrypt(lpCompressData, dwCompressSize, dwSeed + 0x22AF);
	lpDataBuffer += dwCompressSize;

	//计算数据校验和
	DWORD dwChkValue = AUTOIT_EA05_CalcCheckSum(lpCompressData, dwCompressSize);
	if (dwChkValue != dwChkSum)
	{
		return FALSE;
	}

	//输出信息
	BYTE *lpResultPtr = NULL;
	DWORD dwResultSize = 0;

	//解压缩处理
	if (!bCompressFlag)
	{
		//未进行压缩的脚本数据
		dwResultSize = dwCompressSize;
		lpResultPtr = new BYTE[dwResultSize + 2];
		ZeroMemory(lpResultPtr, dwResultSize + 2);
		CopyMemory(lpResultPtr, lpCompressData, dwResultSize);
	}
	else
	{
		//比较"EA05",如果不是则退出
		if (0x35304145 != *(DWORD *)lpCompressData)
		{
			return FALSE;
		}

		//申请内存作为输出
		dwResultSize = dwUncompressSize;
		lpResultPtr = new BYTE[dwResultSize + 2];
		ZeroMemory(lpResultPtr, dwResultSize + 2);

		EAOLD_Decompress(lpCompressData, dwCompressSize, lpResultPtr, dwResultSize);
	}

	//输出
	*lpdwInputOffset = lpDataBuffer - lpInputBuf;
	*lpOutputBuf = lpResultPtr;
	*lpdwOutputSize = dwResultSize;

	return TRUE;
}