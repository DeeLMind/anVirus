#include "stdafx.h"
#include "Decompile.h"
#include "EA03_Decompile.h"
#include "EA04_Decompile.h"
#include "EA05_Decompile.h"
#include "EA06_Decompile.h"

//初始化,如果文件格式不对则初始化会失败
HANDLE __stdcall AUTOIT_Init(BYTE *lpFileBuffer, DWORD dwFileSize)
{
	if (NULL == lpFileBuffer || 0 == dwFileSize)
	{
		return NULL;
	}

	//反编译对象
	AUTOIT3_DECOMPILER decObj = {0};
	decObj.bSucess = FALSE;
	decObj.bPacked = FALSE;

	//判断带PE头的情况
	BOOL bAX3Format = TRUE;
	do 
	{
		IMAGE_DOS_HEADER *lpDosHeader = (IMAGE_DOS_HEADER *)lpFileBuffer;
		if (0x5A4D != lpDosHeader->e_magic)
		{
			break;
		}

		if (lpDosHeader->e_lfanew + sizeof(IMAGE_NT_HEADERS32) > dwFileSize)
		{
			break;
		}

		IMAGE_NT_HEADERS32 *lpNTHeader = (IMAGE_NT_HEADERS32 *)(lpFileBuffer + lpDosHeader->e_lfanew);
		if (0x00004550 != lpNTHeader->Signature)
		{
			break;
		}

		//平台判断
		BOOL bHDR32 = (lpNTHeader->OptionalHeader.Magic == IMAGE_NT_OPTIONAL_HDR32_MAGIC);
		BOOL bMach32 = (lpNTHeader->FileHeader.Machine == IMAGE_FILE_MACHINE_I386);
		BOOL bHDR64 = (lpNTHeader->OptionalHeader.Magic == IMAGE_NT_OPTIONAL_HDR64_MAGIC);			
		BOOL bMach64 = (lpNTHeader->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64);
		if (!(bHDR32 && bMach32) && !(bHDR64 && bMach64))
		{
			break;
		}

		//PE校验失败时进行纯数据处理
		bAX3Format = FALSE;

		//大小限制,合理范围在40K-10M
		if ((dwFileSize <= 1024 * 40)
			|| (dwFileSize >= 1024 * 1024 * 100))
		{
			return NULL;
		}

		//这里是取得Overlay数据地址(PE结束后),实际中需要判断边界值,否则可能会引起崩溃
		DWORD dwSecCount = lpNTHeader->FileHeader.NumberOfSections;
		IMAGE_SECTION_HEADER *lpSectionPtr = IMAGE_FIRST_SECTION(lpNTHeader);
		DWORD dwPESize = lpSectionPtr[dwSecCount-1].PointerToRawData + lpSectionPtr[dwSecCount-1].SizeOfRawData;
		if (dwPESize < 1024*40 || dwPESize > 1024*1024*5)
		{
			//被加壳了
			decObj.bPacked = TRUE;
		}

		//附加数据太大太小,都肯定不是AUTOIT文件
		DWORD dwOverlaySize = dwFileSize - dwPESize;
		if (dwOverlaySize <= 64 || dwOverlaySize >= 1024*1024*100)
		{
			//被加壳了
			decObj.bPacked = TRUE;
		}

		//是否64位解析器
		decObj.decInfos.bX64 = (bHDR64 && bMach64);
		decObj.decInfos.bA3XFormat = FALSE;

		//带解析器
		decObj.lpFileBuf = new BYTE[dwFileSize];
		CopyMemory(decObj.lpFileBuf, lpFileBuffer, dwFileSize);

		decObj.dwFileSize = dwFileSize;
		decObj.dwPESize = dwPESize;
		decObj.lpDataPtr = decObj.lpFileBuf + dwPESize;
		decObj.dwDataSize = dwFileSize - dwPESize;	
	} while (FALSE);

	//不是PE的情况
	if (bAX3Format)
	{
		//与平台无关64位解析器
		decObj.decInfos.bX64 = FALSE;
		decObj.decInfos.bA3XFormat = TRUE;

		//不带解析器
		decObj.lpFileBuf = new BYTE[dwFileSize];
		CopyMemory(decObj.lpFileBuf, lpFileBuffer, dwFileSize);

		decObj.dwFileSize = dwFileSize;
		decObj.dwPESize = 0;
		decObj.lpDataPtr = decObj.lpFileBuf;
		decObj.dwDataSize = dwFileSize;	
	}
	
	//执行版本判断及反编译调度
	typedef BOOL (*VERSION_TYPEFUNC)(AUTOIT3_DECOMPILER *lpDecHandle);
	struct AUTOIT3_DECFUNC 
	{
		VERSION_TYPEFUNC pfnVerFun;	//版本判断函数
		LONG nDecProcPtr;			//反编译函数指针
	};

	//这里将来可以添加新版本的处理
	AUTOIT3_DECFUNC verFunc[] =
	{
		//DEMO版本处理,不支持旧版本
		{AUTOIT_EA03_IsEA03, (LONG)AUTOIT_EA03_Decompile},
		{AUTOIT_EA04_IsEA04, (LONG)AUTOIT_EA04_Decompile},
		{AUTOIT_EA05_IsEA05, (LONG)AUTOIT_EA05_Decompile},
		{AUTOIT_EA06_IsEA06, (LONG)AUTOIT_EA06_Decompile},
	};

	BOOL bRet = FALSE;
	for (int i=0; i<sizeof(verFunc)/sizeof(verFunc[0]); i++)
	{
		if (verFunc[i].pfnVerFun(&decObj))
		{
			decObj.nProcPtr = verFunc[i].nDecProcPtr;
			bRet = TRUE;

			break;
		}
	}

	//失败时销毁资源
	if (!bRet)
	{
		delete[] decObj.lpFileBuf;
		return NULL;
	}

	AUTOIT3_DECOMPILER *lpDecHandle = new AUTOIT3_DECOMPILER;
	CopyMemory(lpDecHandle, &decObj, sizeof(AUTOIT3_DECOMPILER));

	return lpDecHandle;
}

BOOL __stdcall AUTOIT_DoDecompile(HANDLE hDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent)
{
	AUTOIT3_DECOMPILER *lpDecHandle = (AUTOIT3_DECOMPILER *)hDecHandle;
	if (NULL == lpDecHandle)
	{
		return FALSE;
	}

	if (0 == lpDecHandle->nProcPtr)
	{
		return FALSE;
	}

	if (NULL == lpDecHandle->lpFileBuf || NULL == lpDecHandle->lpDataPtr)
	{
		return FALSE;
	}

	if (0 == lpDecHandle->dwDataSize)
	{
		return FALSE;
	}

	//处理A3X的情况
	if (!lpDecHandle->decInfos.bA3XFormat)
	{
		if (0 == lpDecHandle->dwPESize)
		{
			return FALSE;
		}
	}

	typedef BOOL (*AUTOIT_DECOMPILE)(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent);
	AUTOIT_DECOMPILE pfnAutoit_Decompile = (AUTOIT_DECOMPILE)lpDecHandle->nProcPtr;
	lpDecHandle->bSucess = pfnAutoit_Decompile(lpDecHandle, lpfnDecCallback, dwContent);
	
	return lpDecHandle->bSucess;
}

void __stdcall AUTOIT_UnInit(HANDLE hDecHandle)
{
	AUTOIT3_DECOMPILER *lpDecHandle = (AUTOIT3_DECOMPILER *)hDecHandle;
	if (NULL != lpDecHandle)
	{
		if (NULL != lpDecHandle->decInfos.lpResultBuf)
		{
			delete[] lpDecHandle->decInfos.lpResultBuf;
			lpDecHandle->decInfos.lpResultBuf = NULL;
		}

		if (NULL != lpDecHandle->lpFileBuf)
		{
			delete[] lpDecHandle->lpFileBuf;
			lpDecHandle->lpFileBuf = NULL;
		}

		delete lpDecHandle;
	}
}