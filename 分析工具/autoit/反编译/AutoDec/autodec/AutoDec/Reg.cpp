#include "stdafx.h"
#include "reg.h"

/*================================================================ 
* 函数:		CReg
* 参数:		(HKEY hRootKey) 
* 功能:		构造函数
* 返回:
* 说明:		如果构造函数不带参数，则使用默认的参数，m_hRootKey被初始化
			为HKEY_CURRENT_USER, 如果带有参数则 m_hRootKey为指定的值
================================================================*/ 
CReg::CReg(HKEY hRootKey) 
{
	m_hRootKey = hRootKey; 
}

CReg::~CReg() //在析构函数中关闭打开注册表句柄
{
	Close();
}



/*================================================================ 
* 函数:		VerifyKey
* 参数:		(HKEY hRootKey, LPCTSTR pszPath) 
* 功能:		判断给定的路径是否存在 (兼有打开的功能)
* 返回:		BOOL
* 说明:		如果第一个参数为NULL，则使用默认的根路径。
================================================================*/ 
BOOL CReg::VerifyKey (LPCTSTR pszPath)
{
 	LONG ReturnValue = ::RegOpenKeyEx (m_hRootKey, pszPath, 0L,	KEY_ALL_ACCESS, &m_hSubKey);
	return (ERROR_SUCCESS == ReturnValue);
}



/*================================================================ 
* 函数:		VerifyValue
* 参数:		(LPCTSTR pszValue)
* 功能:		判断给定的键是否存在
* 返回:		BOOL
* 说明:		请先调用VerifyKey，然后在使用该函数
================================================================*/ 
BOOL CReg::VerifyValue (LPCTSTR pszValue)
{
	LONG lReturn = ::RegQueryValueEx(m_hSubKey, pszValue, NULL,	NULL, NULL, NULL);
	return (ERROR_SUCCESS == lReturn);
}



/*================================================================ 
* 函数:		IsEqual
* 参数:		(LPCTSTR pszValue,int nn)
* 功能:		整型键的值是否等于某个值
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::IsEqual(LPCTSTR pszValue,int nn)
{
	int nTemp = 0;
	Read(pszValue,nTemp);

	return (nn == nTemp);
}

/*================================================================ 
* 函数:		IsEqual
* 参数:		(LPCTSTR pszValue,DWORD dw)
* 功能:		判断DWORD键的值是否等于某个值
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::IsEqual(LPCTSTR pszValue,DWORD dw)
{
	DWORD dwTemp = 0;
	Read(pszValue,dwTemp);

	return (dwTemp==dw);
}

/*================================================================ 
* 函数:		IsEqual
* 参数:		(LPCTSTR pszValue,LPCTSTR lpsz)
* 功能:		判断字符串键的值是否等于某个值
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::IsEqual(LPCTSTR pszValue,LPCTSTR lpsz)
{
	CString str;
	Read(pszValue,str);
	
	return (0 == str.CompareNoCase(lpsz));
}



/*================================================================ 
* 函数:		CreateKey
* 参数:		(HKEY hRootKey, LPCTSTR pszPath)
* 功能:		创建路径
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::CreateKey (LPCTSTR pszPath)
{
	DWORD dw = 0;
	LONG ReturnValue = ::RegCreateKeyEx (m_hRootKey, pszPath, 0L, NULL,
							REG_OPTION_VOLATILE, KEY_ALL_ACCESS, NULL, 
							&m_hSubKey, &dw);

	return (ERROR_SUCCESS == ReturnValue);
}



/*================================================================ 
* 函数:		Write
* 参数:		(LPCTSTR lpszKeyName, int iVal)
* 功能:		写入整型值
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::Write (LPCTSTR lpszKeyName, int iVal)
{
	DWORD dwValue = (DWORD)iVal;
	LONG ReturnValue = ::RegSetValueEx (m_hSubKey, lpszKeyName, 0L, REG_DWORD,
		(CONST BYTE*) &dwValue, sizeof(DWORD));

	return (ERROR_SUCCESS == ReturnValue);
}

/*================================================================ 
* 函数:		Write
* 参数:		(LPCTSTR lpszKeyName, DWORD dwVal)
* 功能:		写入DWORD值
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::Write (LPCTSTR lpszKeyName, DWORD dwVal)
{
	return ::RegSetValueEx (m_hSubKey, lpszKeyName, 0L, REG_DWORD,
		(CONST BYTE*) &dwVal, sizeof(DWORD));
}

/*================================================================ 
* 函数:		Write
* 参数:		(LPCTSTR lpszKeyName, LPCTSTR pszData)
* 功能:		写入字符串值
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::Write (LPCTSTR lpszKeyName, LPCTSTR pszData)
{
	LONG ReturnValue = ::RegSetValueEx (m_hSubKey, lpszKeyName, 0L, REG_SZ,
		(BYTE*)pszData, sizeof(TCHAR)*(lstrlen(pszData) + 1));

	return (ERROR_SUCCESS == ReturnValue);
}



/*================================================================ 
* 函数:		Read
* 参数:		(LPCTSTR lpszKeyName, int& iVal) 
* 功能:		读取整数
* 返回:		BOOL
* 说明:		第2个参数通过引用传递，可以在函数中修改实参
================================================================*/ 
BOOL CReg::Read(LPCTSTR lpszKeyName, int& iVal)
{
	DWORD dwType = 0;
	DWORD dwSize = sizeof(DWORD);
	DWORD dwDest = 0;

	LONG lReturn = ::RegQueryValueEx(m_hSubKey, (LPTSTR)lpszKeyName, NULL,
		&dwType, (BYTE *) &dwDest, &dwSize);
	if (ERROR_SUCCESS == lReturn)
	{
		iVal = (int)dwDest;
		return TRUE;
	}

	return FALSE;
}

/*================================================================ 
* 函数:		Read
* 参数:		(LPCTSTR lpszKeyName, DWORD& dwVal) 
* 功能:		读取DWORD值
* 返回:		BOOL
* 说明:		第2个参数通过引用传递，可以在函数中修改实参
================================================================*/ 
BOOL CReg::Read(LPCTSTR lpszKeyName, DWORD& dwVal)
{
	DWORD dwType = 0;
	DWORD dwSize = sizeof (DWORD);
	DWORD dwDest = 0;

	LONG lReturn = ::RegQueryValueEx(m_hSubKey, (LPTSTR)lpszKeyName, NULL, 
		&dwType, (BYTE *) &dwDest, &dwSize);
	if (ERROR_SUCCESS == lReturn)
	{
		dwVal = dwDest;
		return TRUE;
	}

	return FALSE;
}

/*================================================================ 
* 函数:		Read
* 参数:		(LPCTSTR lpszKeyName, CString& sVal) 
* 功能:		读取字符串值
* 返回:		BOOL
* 说明:		第2个参数通过引用传递，可以在函数中修改实参
================================================================*/ 
BOOL CReg::Read(LPCTSTR lpszKeyName, CString& sVal)
{
	DWORD dwType = 0;
	DWORD dwSize = 200;
	TCHAR szString[255] = {0};

	LONG lReturn = ::RegQueryValueEx(m_hSubKey, (LPTSTR) lpszKeyName, NULL,
		&dwType, (BYTE *)szString, &dwSize);
	if (ERROR_SUCCESS == lReturn)
	{
		sVal = szString;
		return TRUE;
	}

	return FALSE;
}



/*================================================================ 
* 函数:		DeleteValue
* 参数:		(LPCTSTR pszValue) 
* 功能:		删除键
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::DeleteValue(LPCTSTR pszValue)
{
	return (ERROR_SUCCESS == ::RegDeleteValue(m_hSubKey, pszValue));	
}



/*================================================================ 
* 函数:		DeleteKey
* 参数:		(HKEY hRootKey, LPCTSTR pszPath) 
* 功能:		删除路径
* 返回:		BOOL
* 说明:
================================================================*/ 
BOOL CReg::DeleteKey(LPCTSTR pszPath)
{
	return (::RegDeleteKey(m_hRootKey, pszPath) == ERROR_SUCCESS);
}



/*================================================================ 
* 函数:		Close
* 参数:	
* 功能:		关闭注册表
* 返回:
* 说明:
================================================================*/ 
 void CReg::Close()
{
	if (m_hSubKey)
	{
		::RegCloseKey (m_hSubKey);
		m_hSubKey = NULL;
	}
}

