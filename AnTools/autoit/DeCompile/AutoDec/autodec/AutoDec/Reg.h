#if !defined(AFX__REG_H__33DFA344_8E6E_4DB8_9EF4_F3698D48D5D205__INCLUDED_)
#define AFX__REG_H__33DFA344_8E6E_4DB8_9EF4_F3698D48D5D205__INCLUDED_

/*=================================================================
* 文件名：    reg.h
* 文件描述：  注册表读写 
=================================================================*/

class CReg : public CObject
{
public:
	CReg(HKEY hRootKey = HKEY_CURRENT_USER); //构造函数带有默认参数
	virtual ~CReg();

public:
	BOOL VerifyKey (LPCTSTR pszPath); 
	BOOL VerifyValue (LPCTSTR pszValue);

	BOOL CreateKey (LPCTSTR pszPath);
	void Close();

	BOOL DeleteValue (LPCTSTR pszValue);
	BOOL DeleteKey (LPCTSTR pszPath);

	BOOL Write (LPCTSTR pszKey, int iVal);
	BOOL Write (LPCTSTR pszKey, DWORD dwVal);
	BOOL Write (LPCTSTR pszKey, LPCTSTR pszVal);

	BOOL Read (LPCTSTR pszKey, int& iVal);
	BOOL Read (LPCTSTR pszKey, DWORD& dwVal);
	BOOL Read (LPCTSTR pszKey, CString& sVal);

	BOOL IsEqual(LPCTSTR pszValue,int nn);
	BOOL IsEqual(LPCTSTR pszValue,DWORD dw);
	BOOL IsEqual(LPCTSTR pszValue,LPCTSTR lpsz);

protected:	
	HKEY 	m_hSubKey;    //保存打开的子路径句柄
	HKEY    m_hRootKey;   //保存打开的根路径句柄
};

#endif // !defined(AFX__REG_H__33DFA344_8E6E_4DB8_9EF4_F3698D48D5D205__INCLUDED_)
