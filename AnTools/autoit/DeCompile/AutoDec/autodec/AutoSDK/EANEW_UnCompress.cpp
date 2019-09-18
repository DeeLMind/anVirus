#include "stdafx.h"
#include "EANEW_UnCompress.h"

typedef struct _AUTOIT_COMPRESS_HANDLE
{
	BYTE *outputbuf;
	BYTE *inputbuf;
	UINT cur_output;
	UINT cur_input;
	UINT usize;
	UINT csize;
	UINT bits_avail;
	union 
	{
		UINT full;
		struct 
		{
			WORD l;
			WORD h;
		} half;
	}bitmap;

	UINT error;
}AUTOIT_COMPRESS_HANDLE, *PAUTOIT_COMPRESS_HANDLE;

UINT AUTOIT_GetBits(AUTOIT_COMPRESS_HANDLE *pHandle, UINT nSize) 
{
	pHandle->bitmap.half.h = 0;
	if (nSize > pHandle->bits_avail && ((nSize - pHandle->bits_avail - 1)/16+1)*2 > pHandle->csize - pHandle->cur_input) 
	{
		pHandle->error = 1;
		return 0;
	}

	for (UINT i=0; i<nSize; i++)
	{
		if (!pHandle->bits_avail) 
		{
			pHandle->bitmap.half.l |= pHandle->inputbuf[pHandle->cur_input++]<<8;
			pHandle->bitmap.half.l |= pHandle->inputbuf[pHandle->cur_input++];
			pHandle->bits_avail = 16;
		}

		pHandle->bitmap.full<<=1;
		pHandle->bits_avail--;
	}

	return (UINT)pHandle->bitmap.half.h;
}

void EAOLD_Decompress(BYTE *lpSrcBuf, DWORD dwSrcSize, BYTE *lpDstBuf, DWORD dwDstSize)
{
	//数据解压句柄
	AUTOIT_COMPRESS_HANDLE compObj = {0};
	compObj.csize = dwSrcSize;
	compObj.usize = dwDstSize;
	compObj.outputbuf = lpDstBuf;
	compObj.inputbuf = lpSrcBuf;
	compObj.cur_output = 0;
	compObj.cur_input = 8;
	compObj.bitmap.full = 0;
	compObj.bits_avail = 0;
	compObj.error = 0;

	while (!compObj.error && compObj.cur_output < compObj.usize) 
	{
		if (AUTOIT_GetBits(&compObj, 1)) 
		{
			UINT bs = 0;
			UINT addme=0;
			UINT bb = AUTOIT_GetBits(&compObj, 15);
			if ((bs = AUTOIT_GetBits(&compObj, 2)) == 3) 
			{
				addme = 3;
				if ((bs = AUTOIT_GetBits(&compObj, 3)) == 7) 
				{
					addme = 10;
					if ((bs = AUTOIT_GetBits(&compObj, 5)) == 31) 
					{
						addme = 41;
						if ((bs = AUTOIT_GetBits(&compObj, 8)) == 255) 
						{
							addme = 296;
							while ((bs = AUTOIT_GetBits(&compObj, 8)) == 255) 
							{
								addme+=255;
							}
						}
					}
				}
			}
			bs += 3+addme;

			while (bs--) 
			{
				compObj.outputbuf[compObj.cur_output] = compObj.outputbuf[compObj.cur_output-bb];
				compObj.cur_output++;
			}
		} 
		else 
		{
			compObj.outputbuf[compObj.cur_output] = (BYTE)AUTOIT_GetBits(&compObj, 8);
			compObj.cur_output++;
		}
	}
}

void EA06_Decompress(BYTE *lpSrcBuf, DWORD dwSrcSize, BYTE *lpDstBuf, DWORD dwDstSize)
{
	//数据解压句柄
	AUTOIT_COMPRESS_HANDLE compObj = {0};
	compObj.csize = dwSrcSize;
	compObj.usize = dwDstSize;
	compObj.outputbuf = lpDstBuf;
	compObj.inputbuf = lpSrcBuf;
	compObj.cur_output = 0;
	compObj.cur_input = 8;
	compObj.bitmap.full = 0;
	compObj.bits_avail = 0;
	compObj.error = 0;

	while (!compObj.error && compObj.cur_output < compObj.usize) 
	{
		if (!AUTOIT_GetBits(&compObj, 1)) 
		{
			UINT bs = 0;
			UINT addme=0;
			UINT bb = AUTOIT_GetBits(&compObj, 15);
			if ((bs = AUTOIT_GetBits(&compObj, 2)) == 3) 
			{
				addme = 3;
				if ((bs = AUTOIT_GetBits(&compObj, 3)) == 7) 
				{
					addme = 10;
					if ((bs = AUTOIT_GetBits(&compObj, 5)) == 31) 
					{
						addme = 41;
						if ((bs = AUTOIT_GetBits(&compObj, 8)) == 255) 
						{
							addme = 296;
							while ((bs = AUTOIT_GetBits(&compObj, 8)) == 255) 
							{
								addme+=255;
							}
						}
					}
				}
			}
			bs += 3+addme;

			while (bs--) 
			{
				compObj.outputbuf[compObj.cur_output] = compObj.outputbuf[compObj.cur_output-bb];
				compObj.cur_output++;
			}
		} 
		else 
		{
			compObj.outputbuf[compObj.cur_output] = (BYTE)AUTOIT_GetBits(&compObj, 8);
			compObj.cur_output++;
		}
	}
}