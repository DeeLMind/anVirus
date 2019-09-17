#include "StdAfx.h"
#include "EA04_Decompile.h"
#include "EANEW_UnCompress.h"

typedef struct _AUTOIT_EA04_DECRYPTHANDLE
{
	UINT *next;
	UINT items;
	UINT mt[624];
}AUTOIT_EA04_DECRYPTHANDLE, *PAUTOIT_EA04_DECRYPTHANDLE;

BYTE AUTOIT_EA04_GetNext(AUTOIT_EA04_DECRYPTHANDLE *lpHandle) 
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

void AUTOIT_EA04_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed)
{
	AUTOIT_EA04_DECRYPTHANDLE hDecHandle = {0};
	UINT *mt = hDecHandle.mt;

	*mt = nSeed;
	for(int i=1; i<624; i++)
	{
		mt[i] = i + 0x6c078965*((mt[i-1]>>30) ^ mt[i-1]);
	}

	hDecHandle.items = 1;

	while (nSize--)
	{
		*lpBuffer++ ^= AUTOIT_EA04_GetNext(&hDecHandle);
	}
}

BOOL AUTOIT_EA04_IsEA04(AUTOIT3_DECOMPILER *lpDecHandle)
{
	//不支持仅编译数据的情况
	if (lpDecHandle->decInfos.bA3XFormat)
	{
		return FALSE;
	}

	//加密后的数据偏移信息
	typedef struct _EA04_OFFSETINFO
	{
		DWORD dwEndOffset;		//脚本数据结束偏移,如果没有附加文件数据则位于末尾12字节处
		DWORD dwBeginOffset;	//脚本数据起始偏移(位于PE之后)
		DWORD dwChkSum;			//脚本数据校验和(包含解析器)
	}EA04_OFFSETINFO, *PEA04_OFFSETINFO;
	EA04_OFFSETINFO *lpOffsetObj = (EA04_OFFSETINFO *)(lpDecHandle->lpFileBuf + lpDecHandle->dwFileSize - 12);

	//脚本数据结束偏移
	DWORD dwEndOffset = lpOffsetObj->dwEndOffset ^ 0xAAAAAAAA;
	if (dwEndOffset > lpDecHandle->dwFileSize - 12)
	{
		return FALSE;
	}

	//AUTOIT数据偏移位置(位于PE之后)
	DWORD dwBeginOffset = lpOffsetObj->dwBeginOffset ^ 0xAAAAAAAA;
	if (dwBeginOffset != lpDecHandle->dwPESize)
	{
		return FALSE;
	}

	//数据校验和
	DWORD dwChkSum = lpOffsetObj->dwChkSum ^ 0xAAAAAAAA;
	
	//计算校验和
	DWORD dwChkValue = AUTOIT_EA04_CalcCheckSum(lpDecHandle->lpFileBuf, dwEndOffset);
	
	//比较校验和
	if (dwChkValue != dwChkSum)
	{
		return FALSE;
	}

	//并且在进行类型识别时EA04的PE不会超过300K(特别注意!)
	BYTE *lpBufPtr = lpDecHandle->lpFileBuf + dwBeginOffset;

	//取数据大小
	DWORD dwTmpSize = *(DWORD *)lpBufPtr;
	dwTmpSize ^= 0xADAC;
	lpBufPtr += 4;

	//跳过数据部分
	lpBufPtr += dwTmpSize;

	//取压缩版本标识,必须为4,否则应退出
	BYTE nCompressVer = lpBufPtr[0];
	if (4 != nCompressVer)
	{
		return FALSE;
	}

	return TRUE;
}

//计算文件校验和
DWORD AUTOIT_EA04_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize)
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

BOOL AUTOIT_EA04_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent)
{
	//没有需要跳过的数据
	BYTE *lpDataBufPtr = lpDecHandle->lpDataPtr;

	//取垃圾数据大小
	DWORD dwInvalidDataSize = *(DWORD *)lpDataBufPtr;
	dwInvalidDataSize ^= 0xADAC;
	lpDataBufPtr += 4;

	//跳过垃圾数据部分
	lpDataBufPtr += dwInvalidDataSize;

	//跳过压缩版本标识
	lpDataBufPtr += 1;

	//处理密码字符串
	DWORD dwPwdStrLen = *(DWORD *)lpDataBufPtr;
	dwPwdStrLen ^= 0xFAC1;
	lpDataBufPtr += 4;

	//AUTOIT的密码字符串,后续解密会用到
	DWORD dwPwdSeed = 0;
	if (0 != dwPwdStrLen)
	{
		CHAR szPassword[MAX_PATH] = {0};
		CopyMemory(szPassword, lpDataBufPtr, dwPwdStrLen);
		AUTOIT_EA04_DeCrypt((BYTE *)szPassword, dwPwdStrLen, dwPwdStrLen + 0xC3D2);

		for (DWORD i=0; i<dwPwdStrLen; i++)
		{
			dwPwdSeed += szPassword[i];
		}

		lpDataBufPtr += dwPwdStrLen;

		CopyMemory(lpDecHandle->decInfos.szPassword, szPassword, dwPwdStrLen);
	}

	//下面循环进行数据解密处理,脚本数据位于最前面
	BOOL bRet = FALSE;
	DWORD dwFileCount = 0;
	do 
	{
		//解密文件标识字符串"FILE"
		BYTE *lpFileFlagPtr = lpDataBufPtr;
		AUTOIT_EA04_DeCrypt(lpFileFlagPtr, 4, 0x16FA);
		lpDataBufPtr += 4;

		CHAR *lpFileFlag = "FILE";
		if (0 != memcmp(lpFileFlag, lpFileFlagPtr, 4))
		{
			break;
		}

		//文件序号
		lpDecHandle->decInfos.dwFileIndex = dwFileCount;
		dwFileCount++;

		//脚本长度
		DWORD dwScriptFlagLen = *(DWORD *)lpDataBufPtr;
		dwScriptFlagLen ^= 0x29BC;
		lpDataBufPtr += 4;

		//解密标识字符串
		BYTE *lpFlagPtrScript = lpDataBufPtr;
		AUTOIT_EA04_DeCrypt(lpFlagPtrScript, dwScriptFlagLen, dwScriptFlagLen + 0xA25E);
		lpDataBufPtr += dwScriptFlagLen;

		//路径数据部分长度
		DWORD dwPathLen = *(DWORD *)lpDataBufPtr;
		dwPathLen ^= 0x29AC;
		lpDataBufPtr += 4;

		//路径数据(ANSI编码)
		CHAR *lpPathPtr = (CHAR *)lpDataBufPtr;
		AUTOIT_EA04_DeCrypt((BYTE *)lpPathPtr, dwPathLen, dwPathLen + 0xF25E);
		lpDataBufPtr += dwPathLen;

		//COPY释放路径
		lpDecHandle->decInfos.bPathUnicode = FALSE;
		ZeroMemory(lpDecHandle->decInfos.szReleasePath, sizeof(lpDecHandle->decInfos.szReleasePath));
		CopyMemory(lpDecHandle->decInfos.szReleasePath, lpPathPtr, dwPathLen);

		//解压缩到目标缓冲
		DWORD dwOffset = 0;
		BYTE *lpOutPtr = NULL;
		DWORD dwOutSize = 0;
		bRet = AUTOIT_EA04_FileDecompress(lpDataBufPtr, &dwOffset, &lpOutPtr, &dwOutSize, dwPwdSeed);
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
		CHAR szScriptFlag[MAX_PATH + 4] = ">AUTOIT SCRIPT<";
		lpDecHandle->decInfos.bScript = (0 == memcmp(lpFlagPtrScript, szScriptFlag, dwScriptFlagLen));
		if (lpDecHandle->decInfos.bScript)
		{
			//这个系列的脚本只有ANSI版本
			lpDecHandle->decInfos.bScriptUnicode = FALSE;

			//取编译器版本信息(从解密后的脚本中获取) [字符串"; <AUT2EXE VERSION: "]
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

		//执行回调
		if (NULL != lpfnDecCallback)
		{
			BOOL bContinue = lpfnDecCallback(&lpDecHandle->decInfos, dwContent);
			if (!bContinue)
			{
				break;
			}
		}

		//判断位置是否已到达末尾
		if ((lpDataBufPtr + 12) >= (lpDecHandle->lpFileBuf + lpDecHandle->dwFileSize))
		{
			break;
		}
	} while (TRUE);

	return bRet;
}

//文件解压缩
BOOL AUTOIT_EA04_FileDecompress(BYTE *lpInputBuf, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed)
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

	//跳过16字节无用数据
	lpDataBuffer += 16;

	//解密数据,解密后如果是压缩的则是"EA04"开始
	BYTE *lpCompressData = lpDataBuffer;
	AUTOIT_EA04_DeCrypt(lpCompressData, dwCompressSize, dwSeed + 0x22AF);
	lpDataBuffer += dwCompressSize;

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
		//比较"EA04",如果不是则退出
		if (0x34304145 != *(DWORD *)lpCompressData)
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