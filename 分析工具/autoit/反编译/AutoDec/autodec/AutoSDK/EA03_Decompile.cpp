#include "StdAfx.h"
#include "EA03_Decompile.h"
#include "EA03_UnCompress.h"

typedef struct _AUTOIT_EA03_DECRYPTHANDLE
{
	UINT *next;
	UINT items;
	UINT mt[624];
}AUTOIT_EA03_DECRYPTHANDLE, *PAUTOIT_EA03_DECRYPTHANDLE;

BYTE AUTOIT_EA03_GetNext(AUTOIT_EA03_DECRYPTHANDLE *lpHandle) 
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

void AUTOIT_EA03_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed)
{
	AUTOIT_EA03_DECRYPTHANDLE hDecHandle = {0};
	UINT *mt = hDecHandle.mt;

	*mt = nSeed;
	for(int i=1; i<624; i++)
	{
		mt[i] = i + 0x6c078965*((mt[i-1]>>30) ^ mt[i-1]);
	}

	hDecHandle.items = 1;

	while (nSize--)
	{
		*lpBuffer++ ^= AUTOIT_EA03_GetNext(&hDecHandle);
	}
}

//判断函数
BOOL AUTOIT_EA03_IsEA03(AUTOIT3_DECOMPILER *lpDecHandle)
{
	//不支持仅编译数据的情况
	if (lpDecHandle->decInfos.bA3XFormat)
	{
		return FALSE;
	}

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

	//EA03的版本在16字节之后是3
	if (3 != lpDataPtr[0])
	{
		return FALSE;
	}

	//数据大小
	typedef struct _EA03_OFFSETINFO
	{
		DWORD dwBeginOffset;	//脚本数据起始偏移(位于PE之后)
		DWORD dwChkSum;			//文件校验和
	}EA03_OFFSETINFO, *PEA03_OFFSETINFO;

	//脚本数据起始偏移
	EA03_OFFSETINFO *lpOffsetObj = (EA03_OFFSETINFO *)(lpDecHandle->lpDataPtr + lpDecHandle->dwDataSize - 8);
	if (lpOffsetObj->dwBeginOffset != lpDecHandle->dwPESize)
	{
		return FALSE;
	}

	//PE部分的数据校验和
	DWORD dwCheckValue = lpOffsetObj->dwChkSum ^ 0xAAAAAAAA;

	//计算文件校验和
	DWORD dwCRCValue = AUTOIT_EA03_CalcCheckSum(lpDecHandle->lpFileBuf, lpDecHandle->dwFileSize-4);

	//对比CRC校验和
	if (dwCheckValue != dwCRCValue)
	{
		return FALSE;
	}

	return TRUE;
}

DWORD AUTOIT_EA03_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize)
{
	//创建CRC表
	DWORD dwCRCTable[256] = {0};
	int nIndex = 0;
	do
	{
		int nTableValue = nIndex << 24;
		int nIndexSub = 8;
		do
		{
			if (nTableValue & 0x80000000)
			{
				nTableValue = 2 * nTableValue ^ 0x4C11DB7;
			}
			else
			{
				nTableValue *= 2;
			}

			nIndexSub--;
		}
		while (nIndexSub);

		dwCRCTable[nIndex++] = nTableValue;
	}
	while (nIndex < 256);

	//计算CRC校验和
	DWORD dwCRCValue = 0xFFFFFFFF;
	for (DWORD i=0; i<dwSize; i++)
	{
		dwCRCValue = (dwCRCValue << 8) ^ dwCRCTable[lpBuffer[i] ^ (dwCRCValue >> 24)];
	}

	return dwCRCValue;
}

BOOL AUTOIT_EA03_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent)
{
	//跳过16字节GUID及1字节版本标识
	BYTE *lpDataBufPtr = lpDecHandle->lpDataPtr + (16 + 1);

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
		AUTOIT_EA03_DeCrypt((BYTE *)szPassword, dwPwdStrLen, dwPwdStrLen + 0xC3D2);

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
		AUTOIT_EA03_DeCrypt(lpFileFlagPtr, 4, 0x16FA);
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
		AUTOIT_EA03_DeCrypt(lpFlagPtrScript, dwScriptFlagLen, dwScriptFlagLen + 0xA25E);
		lpDataBufPtr += dwScriptFlagLen;

		//路径数据长度
		DWORD dwPathLen = *(DWORD *)lpDataBufPtr;
		dwPathLen ^= 0x29AC;
		lpDataBufPtr += 4;

		//路径数据
		CHAR *lpPathPtr = (CHAR *)lpDataBufPtr;
		AUTOIT_EA03_DeCrypt((BYTE *)lpPathPtr, dwPathLen, dwPathLen + 0xF25E);
		lpDataBufPtr += dwPathLen;

		//COPY释放路径
		lpDecHandle->decInfos.bPathUnicode = FALSE;
		ZeroMemory(lpDecHandle->decInfos.szReleasePath, sizeof(lpDecHandle->decInfos.szReleasePath));
		CopyMemory(lpDecHandle->decInfos.szReleasePath, lpPathPtr, dwPathLen);

		//解压缩到目标缓冲
		DWORD dwOffset = 0;
		BYTE *lpOutPtr = NULL;
		DWORD dwOutSize = 0;
		bRet = AUTOIT_EA03_FileDecompress(lpDataBufPtr, &dwOffset, &lpOutPtr, &dwOutSize, dwPwdSeed);
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
		CHAR szAutoitScriptFlag[MAX_PATH + 4] = ">AUTOIT SCRIPT<";
		lpDecHandle->decInfos.bScript = (0 == memcmp(lpFlagPtrScript, szAutoitScriptFlag, dwScriptFlagLen));
		if (lpDecHandle->decInfos.bScript)
		{
			//这个系列的脚本只有ANSI版本
			lpDecHandle->decInfos.bScriptUnicode = FALSE;

			//取编译器版本信息(从解密后的脚本中获取) [字符串"; <COMPILER: v3.0.100.0>"]
			CHAR *lpScript = (CHAR *)lpDecHandle->decInfos.lpResultBuf + lstrlenA("; <COMPILER: ");
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

		//判断是否旧版本autohotkey脚本(新版本的直接把明文数据放到资源里了)
		CHAR szAutoHotkeyScriptFlag[MAX_PATH + 4] = ">AUTOHOTKEY SCRIPT<";
		if (!lpDecHandle->decInfos.bScript)
		{
			lpDecHandle->decInfos.bScript = (0 == memcmp(lpFlagPtrScript, szAutoHotkeyScriptFlag, dwScriptFlagLen));
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
		if ((lpDataBufPtr + 8) >= (lpDecHandle->lpFileBuf + lpDecHandle->dwFileSize))
		{
			break;
		}
	} while (TRUE);

	return bRet;
}

//文件解压缩
BOOL AUTOIT_EA03_FileDecompress(BYTE *lpInputBuf, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed)
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

	//解密数据,解密后如果是压缩的则是"JB01"开始
	BYTE *lpCompressData = lpDataBuffer;
	AUTOIT_EA03_DeCrypt(lpCompressData, dwCompressSize, dwSeed + 0x22AF);
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
		//比较"JB01",如果不是则退出
		if (0x3130424A != *(DWORD *)lpCompressData)
		{
			return FALSE;
		}

		//申请内存作为输出
		dwResultSize = dwUncompressSize;
		lpResultPtr = new BYTE[dwResultSize + 2];
		ZeroMemory(lpResultPtr, dwResultSize + 2);

		//EA03解压缩
		EA03_Decompress obj_EA03;
		obj_EA03.SetDefaults();
		obj_EA03.SetInputBuffer(lpCompressData);
		obj_EA03.SetOutputBuffer(lpResultPtr);
		obj_EA03.SetAlgID("JB01");
		obj_EA03.Decompress();
	}

	//输出
	*lpdwInputOffset = lpDataBuffer - lpInputBuf;
	*lpOutputBuf = lpResultPtr;
	*lpdwOutputSize = dwResultSize;

	return TRUE;
}