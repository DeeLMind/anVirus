#pragma once

#include "Decompile.h"

//反编译句柄
typedef struct _AUTOIT3_DECOMPILER
{
	AUTOIT3_DECINFORMATIONS decInfos;	//反编译信息

	//下面为内部使用
	BOOL bSucess;						//反编译成功标识

	BYTE *lpFileBuf;					//文件缓冲[有内存申请]
	DWORD dwFileSize;					//文件缓冲大小
	BOOL bPacked;						//是否被加壳

	DWORD dwPESize;						//PE大小
	BYTE *lpDataPtr;					//附加数据指针
	DWORD dwDataSize;					//附加数据大小
	LONG nProcPtr;						//反编译函数指针
}AUTOIT3_DECOMPILER, *PAUTOIT3_DECOMPILER;

/*
//AUTOIT3编译文件结构
typedef struct _AUTOIT3_COMPILE_OBJECT
{
	BYTE guidAutoIT[16];	//脚本起始的GUID标识,内容为A3484BBE986C4AA9994C530A86D6487D
	//脚本解析器本身是通过暴力搜索来处理的

	DWORD dwMajorVer;		//AUTO的主版本号, "AU3!"  0x21335541
	DWORD dwCompVer;		//AUTO的压缩引擎版本号, "EA05" "EA06"

	//16字节校验数据,EA05用于计算加密种子(EA06实际中未用到,可理解为垃圾数据)
	BYTE cbChkSum[16];
	
	//下面开始这个数据结构是可重复的(长度变化)
	DWORD dwTypeFlag;		//数据类型标识,解密后为"FILE"
	DWORD dwFileTypeStrLen;	//文件类型字符串长度
	WCHAR szTypeString[dwFileTypeStrLen];	//文件类型字符串
	//目前有两种L">>>AUTOIT NO CMDEXECUTE<<<" 或 L">>>AUTOIT SCRIPT<<<"
	//对于旧版本而言或许还有其它的字符串标识

	DWORD dwFilePathStrLen;	//文件路径字符串长度
	WCHAR szPathString[dwFilePathStrLen];	//文件路径字符串(对反编译脚本没有实际用处)

	BYTE bCompressFlag;		//压缩标识
	DWORD dwDataSize;		//后面数据的大小
	{
		//脚本时才使用这个结构,否则可直接跳过这24字节
		DWORD dwUncompSize;		//数据解压缩后的大小
		DWORD dwChkSum;			//校验和
		BYTE cbUnuseData[16];	//为脚本数据时是从未使用到的数据,直接跳过
	}
	BYTE cbData[dwDataSize];	//数据区内容,EA05只要解密成功就完成了,EA06需要再进行脚本还原
}AUTOIT3_COMPILE_OBJECT, *PAUTOIT3_COMPILE_OBJECT;
*/