#pragma once

#include "include.h"

/*支持的版本:
3.0.102.0
3.1.0.15
3.1.1.0
3.1.1.74~3.1.1.133(版本号连续)
*/

//判断函数
BOOL AUTOIT_EA04_IsEA04(AUTOIT3_DECOMPILER *lpDecHandle);

//计算校验和
DWORD AUTOIT_EA04_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize);

//解密函数
void AUTOIT_EA04_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed);

//反编译函数
BOOL AUTOIT_EA04_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent);

//文件解压缩
BOOL AUTOIT_EA04_FileDecompress(BYTE *lpInputBuf, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed);