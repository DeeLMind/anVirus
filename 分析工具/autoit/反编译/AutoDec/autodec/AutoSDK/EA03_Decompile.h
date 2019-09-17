#pragma once

#include "include.h"

/*支持的版本:
3.0.100.0
3.0.101.0
*/

//判断函数
BOOL AUTOIT_EA03_IsEA03(AUTOIT3_DECOMPILER *lpDecHandle);

//计算校验和
DWORD AUTOIT_EA03_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize);

//解密函数
void AUTOIT_EA03_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed);

//反编译函数
BOOL AUTOIT_EA03_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent);

//文件解压缩
BOOL AUTOIT_EA03_FileDecompress(BYTE *lpInputBuf, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed);