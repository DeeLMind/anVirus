#pragma once

#include <windows.h>

//反编译句柄
typedef struct _AUTOIT3_DECINFORMATIONS
{
	//这里是公共的属性
	CHAR szAutoitVer[64];			//[OUT]AUTOIT版本信息(但只能从脚本中获取)
	CHAR szPassword[MAX_PATH];		//[OUT]密码字符串
	BOOL bA3XFormat;				//[OUT]是否仅编译后的脚本数据
	BOOL bX64;						//[OUT]带PE头时是否是64位PE头

	//下面是每个文件单独的属性
	DWORD dwFileIndex;				//[OUT]文件序号,从0开始
	BOOL bScript;					//[OUT]是否脚本数据,每个文件中只有一个脚本
	BOOL bScriptUnicode;			//[OUT]为脚本数据时,脚本是否为UNICODE编码,UNICODE编码时前两字节是UNICODE文本标识
	BYTE *lpResultBuf;				//[OUT]反编译结果缓冲[有内存申请]
	DWORD dwResultSize;				//[OUT]反编译结果大小

	BOOL bPathUnicode;				//[OUT]释放路径是否UNICODE编码
	BYTE szReleasePath[MAX_PATH*sizeof(WCHAR)];	//[OUT]当前文件释放路径
}AUTOIT3_DECINFORMATIONS, *PAUTOIT3_DECINFORMATIONS;

//反编译回调定义,如果回调返回FALSE则不再进行后续回调了
typedef BOOL (*DECOMPILE_CALLBACK)(AUTOIT3_DECINFORMATIONS *lpDecInfos, DWORD dwContent);

//反编译导出接口
HANDLE __stdcall AUTOIT_Init(BYTE *lpFileBuffer, DWORD dwFileSize);
BOOL __stdcall AUTOIT_DoDecompile(HANDLE hDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent);
void __stdcall AUTOIT_UnInit(HANDLE hDecHandle);