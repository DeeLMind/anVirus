#pragma once

#include "include.h"

/*支持的版本范围:
3.2.0.0
3.2.0.1
3.2.1.0 
3.2.2.0
3.2.4.0
3.2.4.1
3.2.4.2
3.2.4.3
3.2.4.4
3.2.4.5
3.2.4.6
3.2.4.7
3.2.4.8
3.2.4.9
*/

//判断函数
BOOL AUTOIT_EA05_IsEA05(AUTOIT3_DECOMPILER *lpDecHandle);

//计算校验和
DWORD AUTOIT_EA05_CalcCheckSum(BYTE *lpBuffer, DWORD dwSize);

//解密函数
void AUTOIT_EA05_DeCrypt(BYTE *lpBuffer, UINT nSize, UINT nSeed);

//反编译函数
BOOL AUTOIT_EA05_Decompile(AUTOIT3_DECOMPILER *lpDecHandle, DECOMPILE_CALLBACK lpfnDecCallback, DWORD dwContent);

//文件解压缩
BOOL AUTOIT_EA05_FileDecompress(BYTE *lpInputBuf, DWORD *lpdwInputOffset, BYTE **lpOutputBuf, DWORD *lpdwOutputSize, DWORD dwSeed);