// AutoDec.cpp : 定义应用程序的类行为。
//

#include "stdafx.h"
#include "AutoDec.h"
#include "AutoDecDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAutoDecApp

BEGIN_MESSAGE_MAP(CAutoDecApp, CWinApp)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()


// CAutoDecApp 构造

CAutoDecApp::CAutoDecApp()
{
	// TODO: 在此处添加构造代码，
	// 将所有重要的初始化放置在 InitInstance 中
}


// 唯一的一个 CAutoDecApp 对象

CAutoDecApp theApp;


// CAutoDecApp 初始化

BOOL CAutoDecApp::InitInstance()
{
	// 如果一个运行在 Windows XP 上的应用程序清单指定要
	// 使用 ComCtl32.dll 版本 6 或更高版本来启用可视化方式，
	//则需要 InitCommonControlsEx()。否则，将无法创建窗口。
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// 将它设置为包括所有要在应用程序中使用的
	// 公共控件类。
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();

	AfxEnableControlContainer();

	// 标准初始化
	// 如果未使用这些功能并希望减小
	// 最终可执行文件的大小，则应移除下列
	// 不需要的特定初始化例程
	// 更改用于存储设置的注册表项
	// TODO: 应适当修改该字符串，
	// 例如修改为公司或组织名
	SetRegistryKey(_T("应用程序向导生成的本地应用程序"));

	//命令行处理,处理完了后要退出
	//取属性
	CString strFullName = m_lpCmdLine;
	
	TCHAR szPath[MAX_PATH] = {0};
	lstrcpy(szPath, strFullName);
	int nLen = lstrlen(szPath);
	if (szPath[0] == '"')
	{
		if (szPath[nLen - 1] == '"')
		{
			szPath[nLen - 1] = 0;
		}

		strFullName = szPath + 1;
	}

	DWORD dwAttrib = ::GetFileAttributes(strFullName);
	if (INVALID_FILE_ATTRIBUTES != dwAttrib)
	{
		if (dwAttrib & FILE_ATTRIBUTE_DIRECTORY)
		{
			//处理一级目录
			strFullName += _T("\\");
			AddFilesByPath(strFullName, FALSE, NULL);
		}
		else
		{
			//处理文件
			BOOL bRet = AddFilesByFileName(strFullName);
			if (!bRet)
			{
				AfxMessageBox(_T("反编译失败!"));
			}
		}

		return FALSE;
	}

	CAutoDecDlg dlg;
	m_pMainWnd = &dlg;
	INT_PTR nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: 在此放置处理何时用
		//  “确定”来关闭对话框的代码
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: 在此放置处理何时用
		//  “取消”来关闭对话框的代码
	}

	// 由于对话框已关闭，所以将返回 FALSE 以便退出应用程序，
	//  而不是启动应用程序的消息泵。
	return FALSE;
}

DWORD CAutoDecApp::AddFilesByPath(LPCTSTR lpszFileDir, BOOL bIncludeSub, LPCTSTR lpszFileExt)
{
	CString strFileNumber;
	CString strFileName;
	CString strExt;
	int nExtLength;
	CTime tFileTime;
	CFileFind finder;

	int nFileCount = 0;
	int nProgress = 0;

	CString strFilter;
	if (NULL == lpszFileExt)
	{
		strFilter.Format(_T("%s\\*.%s"), lpszFileDir, _T("*"));
	}
	else
	{
		strFilter.Format(_T("%s\\*.%s"), lpszFileDir, lpszFileExt);
	}

	BOOL bWorking = finder.FindFile(strFilter);
	while (bWorking)
	{
		nProgress++;

		bWorking = finder.FindNextFile();
		if (finder.IsDots())
		{
			continue;
		}

		//若为子目录
		if (finder.IsDirectory())
		{
			//如果搜索子目录则进行递归
			if (bIncludeSub)
			{
				CString strSubDir = CString(lpszFileDir) + _T("\\") + finder.GetFileName();
				AddFilesByPath(strSubDir, TRUE, lpszFileExt);
			}	
		}
		else
		{
			//若是文件
			nExtLength = finder.GetFileName().GetLength() - finder.GetFileTitle().GetLength() - 1;
			strExt = finder.GetFileName().Right(nExtLength);

			//扩展名过滤
			if (NULL != lpszFileExt)
			{
				if (strExt != lpszFileExt)
				{
					continue;
				}
			}			

			//全路径
			strFileName = finder.GetFilePath();
			nFileCount++;

			AddFilesByFileName(strFileName);
		}
	}

	return nFileCount;
}

BOOL CAutoDecApp::AddFilesByFileName(LPCTSTR lpszFileName)
{
	//文件名分割
	TCHAR szDir[_MAX_DIR] = {0};
	TCHAR szDrive[_MAX_DRIVE] = {0};
	TCHAR szName[_MAX_FNAME] = {0};
	TCHAR szExt[_MAX_EXT] = {0};
	_tsplitpath(lpszFileName, szDrive, szDir, szName, szExt);

	CString strDstPath;
	strDstPath.Format(_T("%s%s%s%s_dec"), szDrive, szDir, szName, szExt);

	CAutoDecDlg dlg;
	BOOL bRet = dlg.ProcessFile(lpszFileName, strDstPath, FALSE, 0);

	return bRet;
}