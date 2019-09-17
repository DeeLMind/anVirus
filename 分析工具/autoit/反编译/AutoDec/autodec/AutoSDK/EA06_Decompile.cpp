#include "StdAfx.h"
#include "EA06_Decompile.h"
#include "EANEW_UnCompress.h"

typedef struct _AUTOIT_EA06_DECRYPTHANDLE
{
	UINT c0;
	UINT c1;
	UINT ame[17];
}AUTOIT_EA06_DECRYPTHANDLE, *PAUTOIT_EA06_DECRYPTHANDLE;

double AUTOIT_EA06_Fpusht(AUTOIT_EA06_DECRYPTHANDLE *lpHandle);
void AUTOIT_EA06_Srand(AUTOIT_EA06_DECRYPTHANDLE *lpHandle, UINT seed);
BYTE AUTOIT_EA06_GetNext(AUTOIT_EA06_DECRYPTHANDLE *lpHandle);

double AUTOIT_EA06_Fpusht(AUTOIT_EA06_DECRYPTHANDLE *lpHandle) 
{
	union 
	{
		double as_double;
		struct 
		{
			UINT lo;
			UINT hi;
		}as_uint;
	}ret;

#define ROFL(a, b) (( a << (b % (sizeof(a)<<3) ))  |  (a >> (  (sizeof(a)<<3)  -  (b % (sizeof(a)<<3 )) ) ))

	UINT rolled = ROFL(lpHandle->ame[lpHandle->c0],9) +  ROFL(lpHandle->ame[lpHandle->c1],13);

	lpHandle->ame[lpHandle->c0] = rolled;

	if (!lpHandle->c0--) 
	{
		lpHandle->c0 = 16;
	}

	if (!lpHandle->c1--)
	{
		lpHandle->c1 = 16;
	}

	ret.as_uint.lo = rolled << 0x14;
	ret.as_uint.hi = 0x3ff00000 | (rolled >> 0xc);

	return (ret.as_double - 1.0);
}


void AUTOIT_EA06_Srand(AUTOIT_EA06_DECRYPTHANDLE *lpHandle, UINT seed) 
{
	for (int i=0; i<17; i++) 
	{
		seed *= 0x53A9B4FB;
		seed = 1 - seed;
		lpHandle->ame[i] = seed;
	}

	lpHandle->c0 = 0;
	lpHandle->c1 = 10;

	for (int i=0; i<9; i++)
	{
		AUTOIT_EA06_Fpusht(lpHandle);
	}
}

BYTE AUTOIT_EA06_GetNext(AUTOIT_EA06_DECRYPTHANDLE *l)
{
	BYTE ret = 0;
	AUTOIT_EA06_Fpusht(l);
	double x = AUTOIT_EA06_Fpusht(l) * 256.0;
	if ((int)x < 256) 
	{
		ret = (BYTE)x;
	}
	else
	{
		ret = 0xFF;
	}

	return ret;
}

void AUTOIT_EA06_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed)
{
	AUTOIT_EA06_DECRYPTHANDLE hDecHandle = {0};
	AUTOIT_EA06_Srand(&hDecHandle, (UINT)nSeed);

	while (nSize--)
	{
		*lpBuffer++ ^= AUTOIT_EA06_GetNext(&hDecHandle);
	}
}

//判断函数
BOOL AUTOIT_EA06_IsEA06(AUTOIT3_DECOMPILER *lpDecHandle)
{
	BOOL bResult = FALSE;

	//16字节GUID
	static const BYTE cbAutoGUID[] = 
	{
		0xA3, 0x48, 0x4B, 0xBE, 0x98, 0x6C, 0x4A, 0xA9, 
		0x99, 0x4C, 0x53, 0x0A, 0x86, 0xD6, 0x48, 0x7D
	};

	//数据指针
	BYTE *lpDataPtr = lpDecHandle->lpDataPtr;


LoopFind:

	//压缩版本比较
	do 
	{
		//GUID起始标识比较
		int nRet = memcmp(lpDataPtr, cbAutoGUID, 16);
		if (0 != nRet)
		{
			break;
		}
		lpDataPtr += 16;

		//压缩版本"AU3!EA06"
		static const BYTE cbAutoVersion[] = 
		{
			0x41, 0x55, 0x33, 0x21, 0x45, 0x41, 0x30, 0x36
		};

		//AUCN的修改版
		static const BYTE cbAutoVersionMod[] = 
		{
			0x21, 0x2A, 0x55, 0x23, 0x41, 0x55, 0x43, 0x4E
		};

		nRet = memcmp(lpDataPtr, cbAutoVersion, sizeof(cbAutoVersion));
		if (0 != nRet)
		{
			nRet = memcmp(lpDataPtr, cbAutoVersionMod, sizeof(cbAutoVersionMod));
			if (0 != nRet)
			{
				break;
			}
		}

		lpDataPtr += sizeof(cbAutoVersion);

		//后面还有16字节无用数据
		lpDataPtr += 16;

		bResult = TRUE;
	} while (FALSE);

	//没找到标识的时候需要浮动搜索
	if (!bResult)
	{
		BYTE *pTmp = lpDecHandle->lpFileBuf;
		for (DWORD i=0; i<lpDecHandle->dwFileSize; i++)
		{
			int nCmp = memcmp(cbAutoGUID, pTmp, sizeof(cbAutoGUID));
			if (0 == nCmp)
			{
				lpDataPtr = pTmp;

				lpDecHandle->lpDataPtr = pTmp;
				lpDecHandle->dwDataSize = lpDecHandle->lpFileBuf + lpDecHandle->dwFileSize - lpDecHandle->lpDataPtr;
				lpDecHandle->bPacked = TRUE;

				goto LoopFind;
			}

			pTmp++;
		}
	}

	return bResult;
}

//计算文件校验和
DWORD AUTOIT_EA06_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize)
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

//反编译处理开始
typedef struct _AUTOIT_DECOMPILE_STRUCT
{
	BYTE *lpInputPtr;	//输入缓冲
	UINT nInputSize;	//输入缓冲大小
	UINT nInputPos;		//输入缓冲起始偏移

	BYTE *lpOutputPtr;	//输出缓冲
	UINT nOutputSize;	//输出缓冲大小
	UINT nOutputPos;	//输出缓冲起始偏移

	UINT nLineCount;	//反编译后代码行数
	UINT nError;		//错误码
}AUTOIT_EA06_DECOMPILE_STRUCT, *PAUTOIT_DECOMPILE_STRUCT;

BOOL EA06_ConvertOPCode2UnicodeScript(AUTOIT_EA06_DECOMPILE_STRUCT *lpDecObj);


BOOL AUTOIT_EA06_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent)
{
	//跳过16字节GUID及8字节版本标识,以及后面的16字节垃圾数据
	BYTE *lpDataBufPtr = lpDecHandle->lpDataPtr + (16 + 8 + 16);

	//下面循环进行数据解密处理,脚本数据位于最前面
	BOOL bRet = FALSE;
	DWORD dwFileCount = 0;
	do
	{
		//解密文件标识字符串 "FILE"
		BYTE *lpFileFlagPtr = lpDataBufPtr;
		AUTOIT_EA06_DeCrypt(lpFileFlagPtr, 4, 0x18EE);
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
		dwScriptFlagLen ^= 0xADBC;
		lpDataBufPtr += 4;

		//解密脚本标识字符串
		WCHAR *lpFlagPtrScript = (WCHAR *)lpDataBufPtr;
		AUTOIT_EA06_DeCrypt((BYTE *)lpFlagPtrScript, dwScriptFlagLen*sizeof(WCHAR), dwScriptFlagLen + 0xB33F);
		lpDataBufPtr += (dwScriptFlagLen*sizeof(WCHAR));

		//路径数据长度
		DWORD dwPathLen = *(DWORD *)lpDataBufPtr;
		dwPathLen ^= 0xF820;
		lpDataBufPtr += 4;

		//路径数据(UNICODE编码)
		WCHAR *lpPathPtr = (WCHAR *)lpDataBufPtr;
		AUTOIT_EA06_DeCrypt((BYTE *)lpPathPtr, dwPathLen*sizeof(WCHAR), dwPathLen + 0xF479);
		lpDataBufPtr += (dwPathLen*sizeof(WCHAR));

		//COPY释放路径
		lpDecHandle->decInfos.bPathUnicode = TRUE;
		ZeroMemory(lpDecHandle->decInfos.szReleasePath, sizeof(lpDecHandle->decInfos.szReleasePath));
		CopyMemory(lpDecHandle->decInfos.szReleasePath, lpPathPtr, dwPathLen*sizeof(WCHAR));

		//解压缩到目标缓冲,这个版本没有加密种子了
		DWORD dwOffset = 0;
		BYTE *lpOutPtr = NULL;
		DWORD dwOutSize = 0;
		bRet = AUTOIT_EA06_FileDecompress(lpDataBufPtr, (DWORD)(lpDecHandle->dwDataSize - (lpDataBufPtr - lpDecHandle->lpDataPtr)), &dwOffset, &lpOutPtr, &dwOutSize, 0);
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
		WCHAR szEA06_FlagString[MAX_PATH + 4] = L">>>AUTOIT SCRIPT<<<";
		lpDecHandle->decInfos.bScript = (0 == memcmp(lpFlagPtrScript, szEA06_FlagString, dwScriptFlagLen*sizeof(WCHAR)));
		if (lpDecHandle->decInfos.bScript)
		{
			//这个系列的脚本只有UNICODE版本
			lpDecHandle->decInfos.bScriptUnicode = TRUE;

			//脚本数据还需要进行一次还原处理
			//这里申请10倍于原缓冲的大小,肯定足够了
			DWORD dwFinalOutSize = dwOutSize * 10;
			BYTE *lpFinalResult = new BYTE[dwFinalOutSize];
			ZeroMemory(lpFinalResult, dwFinalOutSize);

			//需要自己写UNICODE标识
			lpFinalResult[0] = 0xFF;
			lpFinalResult[1] = 0xFE;

			AUTOIT_EA06_DECOMPILE_STRUCT decObj = {0};
			decObj.lpInputPtr = lpOutPtr + 4;
			decObj.nInputSize = dwOutSize - 4;
			decObj.nInputPos = 0;		//前4字节是最终的代码行数

			decObj.lpOutputPtr = lpFinalResult + 2;
			decObj.nOutputSize = dwFinalOutSize - 2;
			decObj.nOutputPos = 0;		//前2字节是UNICODE标识

			decObj.nLineCount = *(DWORD *)lpOutPtr;
			decObj.nError = 0;

			BOOL bResult = EA06_ConvertOPCode2UnicodeScript(&decObj);
			delete[] lpOutPtr;

			//需要重新赋值脚本果信息
			lpDecHandle->decInfos.lpResultBuf = lpFinalResult;
			lpDecHandle->decInfos.dwResultSize = 2 + (decObj.nOutputPos - 1) * sizeof(WCHAR);
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

		//判断位置是否已到达末尾,压缩版本"AU3!EA06",末尾也有这个标识,但不校验
		if ((lpDataBufPtr + 8) >= (lpDecHandle->lpFileBuf + lpDecHandle->dwFileSize))
		{
			break;
		}
	} while (TRUE);

	return bRet;
}

//文件解压缩
BOOL AUTOIT_EA06_FileDecompress(BYTE *lpInputBuf, DWORD dwInputSize, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed)
{
	//输入缓冲
	BYTE *lpDataBuffer = lpInputBuf;

	//压缩标识
	BOOL bCompressFlag = lpDataBuffer[0];
	lpDataBuffer += 1;

	//压缩后大小
	DWORD dwCompressSize = *(DWORD *)lpDataBuffer;
	dwCompressSize ^= 0x87BC;
	lpDataBuffer += 4;

	//这个校验不太严格
	if (lpDataBuffer + dwCompressSize > lpInputBuf + dwInputSize)
	{
		return FALSE;
	}

	//压缩前大小
	DWORD dwUncompressSize = *(DWORD *)lpDataBuffer;
	dwUncompressSize ^= 0x87BC;
	lpDataBuffer += 4;

	//解压校验和
	DWORD dwChkSum = *(DWORD *)lpDataBuffer;
	dwChkSum ^= 0xA685;
	lpDataBuffer += 4;

	//跳过16字节无用数据
	lpDataBuffer += 16;

	//解密数据,解密后如果是压缩的则是"EA06"开始
	BYTE *lpCompressData = lpDataBuffer;
	AUTOIT_EA06_DeCrypt(lpCompressData, dwCompressSize, dwSeed + 0x2477);
	lpDataBuffer += dwCompressSize;

	//计算数据校验和
	DWORD dwChkValue = AUTOIT_EA06_CalcCheckSum(lpCompressData, dwCompressSize);
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
		lpResultPtr = new BYTE[dwResultSize];
		CopyMemory(lpResultPtr, lpCompressData, dwResultSize);
	}
	else
	{
		//比较"EA06",如果不是则退出
		if (0x36304145 != *(DWORD *)lpCompressData			//EA06
			&& 0x4E435541 != *(DWORD *)lpCompressData)		//AUCN
		{
			return FALSE;
		}

		//申请内存作为输出
		dwResultSize = dwUncompressSize;
		lpResultPtr = new BYTE[dwResultSize];
		ZeroMemory(lpResultPtr, dwResultSize);

		EA06_Decompress(lpCompressData, dwCompressSize, lpResultPtr, dwResultSize);
	}

	//输出
	*lpdwInputOffset = lpDataBuffer - lpInputBuf;
	*lpOutputBuf = lpResultPtr;
	*lpdwOutputSize = dwResultSize;

	return TRUE;
}

//输出格式为UNICODE
BOOL EA06_ConvertOPCode2UnicodeScript(AUTOIT_EA06_DECOMPILE_STRUCT *lpDecObj)
{
	//不会有这么小的脚本,先过滤掉!
	if (lpDecObj->nInputSize < 8)
	{
		return FALSE;
	}

	//行数为0
	if (0 == lpDecObj->nLineCount)
	{
		return FALSE;
	}

	//循环解析
	DWORD dwProcessedLine = 0;
	WCHAR *lpOutText = (WCHAR *)(lpDecObj->lpOutputPtr);
	do
	{
		//取操作码
		BYTE nOpCode = lpDecObj->lpInputPtr[lpDecObj->nInputPos++];
		switch (nOpCode) 
		{
		case 0x05: /* <INT> */
			{
				//防止发生异常,保证4字节的数据长度在有效区域内
				if (lpDecObj->nInputPos >= lpDecObj->nInputSize-4) 
				{
					lpDecObj->nError = 1;
					break;
				}

				//取数值
				DWORD dwNumber = *(DWORD *)(&lpDecObj->lpInputPtr[lpDecObj->nInputPos]);

				//检测数值前面的正负符号以消除空格
				if (lpDecObj->nOutputPos > 4)
				{
					if ((' ' == lpOutText[lpDecObj->nOutputPos-1])
						&& ('-' == lpOutText[lpDecObj->nOutputPos-2])
						&& (' ' == lpOutText[lpDecObj->nOutputPos-3]))
					{
						if (('=' == lpOutText[lpDecObj->nOutputPos-4])
							|| (',' == lpOutText[lpDecObj->nOutputPos-4]))
						{
							lpDecObj->nOutputPos--;
						}						
					}
				}
				
				//统一用十六进制
				WCHAR szIntNumber[32] = {0};
				int nLen = wsprintfW(szIntNumber, L"0x%08X ", dwNumber);
				
				//COPY到输出缓冲
				lstrcpyW(&lpOutText[lpDecObj->nOutputPos], szIntNumber);
				lpDecObj->nOutputPos += nLen;
				lpDecObj->nInputPos += 4;

				break;
			}

		case 0x10: /* <INT64> */
			{
				//防止发生异常,保证8字节的数据长度在有效区域内
				if (lpDecObj->nInputPos >= lpDecObj->nInputSize-8)
				{
					lpDecObj->nError = 1;
					break;
				}

				//统一用十六进制(需要分两段进行处理)
				DWORD dwLow = *(DWORD*)(&lpDecObj->lpInputPtr[lpDecObj->nInputPos]);
				DWORD dwHigh = *(DWORD*)(&lpDecObj->lpInputPtr[lpDecObj->nInputPos+4]);

				UINT64 val = dwHigh;
				val = (val << 32) + dwLow;

				WCHAR szINT64Number[32] = {0};
				int nLen = wsprintfW(szINT64Number, L"%I64d", val);

				//COPY到输出缓冲
				lstrcpyW(&lpOutText[lpDecObj->nOutputPos], szINT64Number);
				lpDecObj->nOutputPos += nLen;
				lpDecObj->nInputPos += 8;
				
				break;
			}

		case 0x20: /* <DOUBLE> */
			{
				//防止发生异常,保证8字节的数据长度在有效区域内
				if (lpDecObj->nInputPos >= lpDecObj->nInputSize-8) 
				{
					lpDecObj->nError = 1;
					break;
				}

				//常规方式
				WCHAR szDoubleNumber[64] = {0};
				double val = *(double *)&lpDecObj->lpInputPtr[lpDecObj->nInputPos];
				int nLen = _snwprintf(szDoubleNumber, 64, L"%g ", val);

				//COPY到输出缓冲
				lstrcpyW(&lpOutText[lpDecObj->nOutputPos], szDoubleNumber);
				lpDecObj->nOutputPos += nLen;
				lpDecObj->nInputPos += 8;

				break;
			}

			//语法结构部分
		case 0x30: /* KEYWORD */	//关键字
		case 0x31: /* COMMAND */	//命令
		case 0x32: /* MACRO */		//宏
		case 0x33: /* VAR */		//变量
		case 0x34: /* FUNC */		//函数
		case 0x35: /* OBJECT */		//对象
		case 0x36: /* STRING */		//字符串
		case 0x37: /* DIRECTIVE */	//预处理命令
			{
				//防止发生异常,保证4字节的字符长度在有效区域内
				if (lpDecObj->nInputPos >= lpDecObj->nInputSize-4) 
				{
					lpDecObj->nError = 1;
					break;
				}

				//取4字节的字符数
				UINT nNumberOfChars = *(DWORD *)(&lpDecObj->lpInputPtr[lpDecObj->nInputPos]);
				UINT nNumberOfBytes = nNumberOfChars*sizeof(WCHAR);
				lpDecObj->nInputPos += 4;

				//校验有效范围
				if ((lpDecObj->nInputSize < nNumberOfBytes) 
					|| (lpDecObj->nInputPos + nNumberOfBytes >= lpDecObj->nInputSize))
				{
					lpDecObj->nError = 1;
					break;
				}

				//添加前缀
				const static BYTE EA06_prefixes[] = {'\0', '\0', '@', '$', '\0', '.', '"', '\0'};
				if (0 != EA06_prefixes[nOpCode-0x30])
				{
					lpOutText[lpDecObj->nOutputPos++] = EA06_prefixes[nOpCode-0x30];
				}				

				//字符处理
				if (nNumberOfChars) 
				{
					for (UINT i=0; i<nNumberOfBytes; i+=2) 
					{
						lpDecObj->lpInputPtr[lpDecObj->nInputPos+i] ^= (BYTE)nNumberOfChars;
						lpDecObj->lpInputPtr[lpDecObj->nInputPos+i+1] ^= (BYTE)(nNumberOfChars>>8);
					}
					CopyMemory(&lpOutText[lpDecObj->nOutputPos], &lpDecObj->lpInputPtr[lpDecObj->nInputPos], nNumberOfBytes);

					//输出位置后移
					lpDecObj->nOutputPos += nNumberOfChars;
					lpDecObj->nInputPos += nNumberOfBytes;
				}

				//添加后缀
				const static BYTE EA06_postfixes[] = {' ', '\0', ' ', ' ', '\0', ' ', '"', ' '};
				if (0 != EA06_postfixes[nOpCode-0x30])
				{
					lpOutText[lpDecObj->nOutputPos++] = EA06_postfixes[nOpCode-0x30];
				}
			}
			break;

			//操作符部分
		case 0x40: /* , */
		case 0x41: /* = */
		case 0x42: /* > */
		case 0x43: /* < */
		case 0x44: /* <> */
		case 0x45: /* >= */
		case 0x46: /* <= */
		case 0x47: /* ( */
		case 0x48: /* ) */
		case 0x49: /* + */
		case 0x4A: /* - */
		case 0x4B: /* / */
		case 0x4C: /* * */
		case 0x4D: /* & */
		case 0x4E: /* [ */
		case 0x4F: /* ] */
		case 0x50: /* == */
		case 0x51: /* ^ */
		case 0x52: /* += */
		case 0x53: /* -= */
		case 0x54: /* /= */
		case 0x55: /* *= */
		case 0x56: /* &= */
			{					
				//操作符定义
				const static WCHAR *EA06_opers[] = 
				{
					L",",	L"=",	L">",	L"<",	L"<>",	L">=",	L"<=",	L"(", 
					L")",	L"+",	L"-",	L"/",	L"*",	L"&",	L"[",	L"]",
					L"==",	L"^",	L"+=",	L"-=",	L"/=",	L"*=",	L"&="
				};

				const static BYTE EA06_opPostfixes[] = 
				{
					' ',	' ',	' ',	' ',	' ',	' ',	' ',	'\0',
					' ',	' ',	' ',	' ',	' ',	' ',	'\0',	'\0',
					' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',
				};

				//消除反括号及逗号前的空格
				if (0x48 == nOpCode || 0x40 == nOpCode)
				{					
					if (lpOutText[lpDecObj->nOutputPos-1] == ' ')
					{
						lpDecObj->nOutputPos--;
					}
				}

				//部分操作符后面需要添加空格
				lpDecObj->nOutputPos += _snwprintf(&lpOutText[lpDecObj->nOutputPos], 4, L"%s", EA06_opers[nOpCode-0x40]);
				if (0 != EA06_opPostfixes[nOpCode-0x40])
				{
					lpOutText[lpDecObj->nOutputPos++] = EA06_opPostfixes[nOpCode-0x40];
				}

				break;
			}

		case 0x7F:	//行结束
			{
				dwProcessedLine++;
				lpDecObj->nLineCount--;
				if (0 != lpDecObj->nLineCount)
				{
					//消除行末多余的空格
					if (lpOutText[lpDecObj->nOutputPos-1] == ' ')
					{
						lpDecObj->nOutputPos--;
					}

					//添加回车换行
					lpOutText[lpDecObj->nOutputPos++] = '\r';
					lpOutText[lpDecObj->nOutputPos++] = '\n';
				}
				else
				{
					//消除文件末尾多余的空格
					if (lpOutText[lpDecObj->nOutputPos-1] == ' ')
					{
						lpOutText[lpDecObj->nOutputPos-1] = 0;
					}
				}

				break;
			}

		default:
			//这里有未知的OP操作码
			lpDecObj->nError = 1;
		}
	} while (!lpDecObj->nError && lpDecObj->nLineCount && lpDecObj->nInputPos < lpDecObj->nInputSize);

	return (0 == lpDecObj->nError);
}