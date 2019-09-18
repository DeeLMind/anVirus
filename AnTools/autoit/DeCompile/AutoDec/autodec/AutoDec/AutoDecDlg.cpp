// AutoDecDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "AutoDec.h"
#include "AutoDecDlg.h"
#include "AboutlDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAutoDecDlg 对话框

CAutoDecDlg::CAutoDecDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CAutoDecDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_bDetect = FALSE;
}

void CAutoDecDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST_FILEINFOS, m_ctlInputFileList);
	DDX_Control(pDX, IDC_LIST_FILELIST, m_ctlDecompiledFileList);
}

BEGIN_MESSAGE_MAP(CAutoDecDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_WM_DROPFILES()
	ON_BN_CLICKED(IDC_BTN_DECOMPILE, &CAutoDecDlg::OnBnClickedBtnDecompile)
	ON_BN_CLICKED(IDC_BTN_ADDTOMENU, &CAutoDecDlg::OnBnClickedBtnAddtomenu)
	ON_BN_CLICKED(IDC_BTN_SELALL, &CAutoDecDlg::OnBnClickedBtnSelall)
	ON_BN_CLICKED(IDC_BTN_SELREV, &CAutoDecDlg::OnBnClickedBtnSelrev)
	ON_BN_CLICKED(IDC_BTN_CLEAN, &CAutoDecDlg::OnBnClickedBtnClean)
	ON_NOTIFY(NM_CLICK, IDC_LIST_FILEINFOS, &CAutoDecDlg::OnNMClickListFileinfos)
	ON_NOTIFY(NM_DBLCLK, IDC_LIST_FILEINFOS, &CAutoDecDlg::OnNMDblclkListFileinfos)
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_BTN_ABOUT, &CAutoDecDlg::OnBnClickedBtnAbout)
	ON_BN_CLICKED(IDC_BTN_DECCURRENT, &CAutoDecDlg::OnBnClickedBtnDeccurrent)
	ON_BN_CLICKED(IDOK, &CAutoDecDlg::OnBnClickedOk)
	ON_BN_CLICKED(IDC_BTN_DELSELECT, &CAutoDecDlg::OnBnClickedBtnDelselect)
	ON_BN_CLICKED(IDC_BTN_DELCURRENT, &CAutoDecDlg::OnBnClickedBtnDelcurrent)
	ON_NOTIFY(LVN_ITEMCHANGED, IDC_LIST_FILEINFOS, &CAutoDecDlg::OnLvnItemchangedListFileinfos)
	ON_NOTIFY(LVN_ITEMCHANGED, IDC_LIST_FILELIST, &CAutoDecDlg::OnLvnItemchangedListFilelist)
END_MESSAGE_MAP()


// CAutoDecDlg 消息处理程序

BOOL CAutoDecDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码
	SetWindowText(_T("Autoit3 Decompiler V1.9 fix【Author:HexBoy  QQ:8724271】"));

	InitInputFileListCtl();
	InitDecompiledFileListCtl();

	if (!CheckInterStatus())
	{
		GetDlgItem(IDC_BTN_ADDTOMENU)->SetWindowText(_T("右键关联"));
	}
	else
	{
		GetDlgItem(IDC_BTN_ADDTOMENU)->SetWindowText(_T("取消右键"));
	}

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CAutoDecDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutRetailDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CAutoDecDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CAutoDecDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CAutoDecDlg::OnDropFiles(HDROP hDropInfo)
{
	// TODO: 在此添加消息处理程序代码和/或调用默认值
	int nCharactersLen = ::DragQueryFile(hDropInfo, 0, NULL, 0);

	TCHAR szFilePath[MAX_PATH] = {0};
	int nFileNum = ::DragQueryFile(hDropInfo, 0xFFFFFFFF, NULL, 0);
	for (int i=0; i<nFileNum; i++)
	{
		::DragQueryFile(hDropInfo, i, szFilePath, MAX_PATH);
		int nLen = lstrlen(szFilePath);
		if (0 == nLen)
		{
			//路径错误
			continue;
		}

		//取属性
		DWORD dwAttrib = ::GetFileAttributes(szFilePath);
		if (INVALID_FILE_ATTRIBUTES == dwAttrib)
		{
			continue;
		}

		if (dwAttrib & FILE_ATTRIBUTE_DIRECTORY)
		{
			szFilePath[nLen] = '\\';
		}

		//目录文件分别处理
		if (dwAttrib & FILE_ATTRIBUTE_DIRECTORY)
		{
			//处理一级目录
			AddFilesByPath(szFilePath, FALSE, NULL);
		}
		else
		{
			//处理文件
			AddFilesByFileName(szFilePath);
		}
	}

	SetButtonStatus();

// 	if (1 == nFileNum)
// 	{
// 		int nItem = m_ctlInputFileList.GetItemCount() - 1;
// 		m_ctlInputFileList.SetFocus();
// 		m_ctlInputFileList.SetItemState(nItem, LVIS_SELECTED|LVIS_FOCUSED, LVIS_SELECTED | LVIS_FOCUSED);
// 	}

	CDialog::OnDropFiles(hDropInfo);
}

void CAutoDecDlg::InitInputFileListCtl()
{
	m_ctlInputFileList.SetExtendedStyle(LVS_EX_CHECKBOXES | LVS_EX_FULLROWSELECT | LVS_EX_FLATSB | LVS_EX_GRIDLINES | LVS_EX_ONECLICKACTIVATE);
	m_ctlInputFileList.InsertColumn(FILEINFOS_INDEX, _T("#"), LVCFMT_LEFT, 40);
	m_ctlInputFileList.InsertColumn(FILEINFOS_STATUS, _T("状态"), LVCFMT_LEFT, 40);
	m_ctlInputFileList.InsertColumn(FILEINFOS_FILEPATH, _T("文件路径"), LVCFMT_LEFT, 370);
	m_ctlInputFileList.InsertColumn(FILEINFOS_FILEFORMAT, _T("格式"), LVCFMT_LEFT, 40);
	m_ctlInputFileList.InsertColumn(FILEINFOS_VERINFO, _T("Autoit版本"), LVCFMT_LEFT, 80);
	m_ctlInputFileList.InsertColumn(FILEINFOS_PASSWORD, _T("密码"), LVCFMT_LEFT, 100);
	m_ctlInputFileList.InsertColumn(FILEINFOS_UNICODE, _T("编码"), LVCFMT_LEFT, 60);	
	m_ctlInputFileList.InsertColumn(FILEINFOS_X64PLATFORM, _T("平台"), LVCFMT_LEFT, 40);
}

void CAutoDecDlg::InitDecompiledFileListCtl()
{
	m_ctlDecompiledFileList.SetExtendedStyle(LVS_EX_FULLROWSELECT | LVS_EX_FLATSB | LVS_EX_GRIDLINES | LVS_EX_ONECLICKACTIVATE);
#if 1
	m_ctlDecompiledFileList.InsertColumn(0, _T("释放路径"), LVCFMT_LEFT, 650);
	m_ctlDecompiledFileList.InsertColumn(1, _T("序号"), LVCFMT_LEFT, 40);
	m_ctlDecompiledFileList.InsertColumn(2, _T("大小(BYTE)"), LVCFMT_LEFT, 80);
#else
	m_ctlDecompiledFileList.InsertColumn(0, _T("释放路径"), LVCFMT_LEFT, 650);
#endif

	SHFILEINFO sfi = {0};

	TCHAR szSystemDir[MAX_PATH] = {0};
	GetWindowsDirectory(szSystemDir, MAX_PATH);

	HIMAGELIST himlSmall = (HIMAGELIST)SHGetFileInfo ((LPCTSTR)szSystemDir, 
		0, 
		&sfi, 
		sizeof(SHFILEINFO), 
		SHGFI_SYSICONINDEX | SHGFI_SMALLICON );

	HIMAGELIST himlLarge = (HIMAGELIST)SHGetFileInfo((LPCTSTR)szSystemDir, 
		0, 
		&sfi, 
		sizeof(SHFILEINFO), 
		SHGFI_SYSICONINDEX | SHGFI_LARGEICON);

	if (himlSmall && himlLarge)
	{
		::SendMessage(m_ctlDecompiledFileList.m_hWnd, LVM_SETIMAGELIST,
			(WPARAM)LVSIL_SMALL, (LPARAM)himlSmall);
		::SendMessage(m_ctlDecompiledFileList.m_hWnd, LVM_SETIMAGELIST,
			(WPARAM)LVSIL_NORMAL, (LPARAM)himlLarge);
	}
}

DWORD CAutoDecDlg::AddFilesByPath(LPCTSTR lpszFileDir, BOOL bIncludeSub, LPCTSTR lpszFileExt)
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

DWORD CAutoDecDlg::AddFilesByFileName(LPCTSTR lpszFileName)
{
	DWORD dwFileCount = m_ctlInputFileList.GetItemCount();
	m_ctlInputFileList.InsertItem(dwFileCount, NULL);

	CString strInfos;
	strInfos.Format(_T("%d"), dwFileCount+1);
	m_ctlInputFileList.SetItemText(dwFileCount, FILEINFOS_INDEX, strInfos);

	strInfos.Format(_T("%s"), lpszFileName);
	m_ctlInputFileList.SetItemText(dwFileCount, FILEINFOS_FILEPATH, strInfos);

	//执行御览
	m_bDetect = TRUE;
	BOOL bRet = ProcessFile(lpszFileName, NULL, TRUE, dwFileCount);
	m_bDetect = FALSE;

	m_ctlInputFileList.SetCheck(dwFileCount, bRet);

	return 0;
}

void CAutoDecDlg::OnBnClickedBtnDecompile()
{
	// TODO: 在此添加控件通知处理程序代码
	int nItemCount = m_ctlInputFileList.GetItemCount();
	if (0 == nItemCount)
	{
		return;
	}

	for (int nItem=0; nItem<nItemCount; nItem++)
	{
		BOOL bCheckStat = m_ctlInputFileList.GetCheck(nItem);
		if (bCheckStat)
		{
			//m_ctlFileList.SetItemState(nItem, LVIS_SELECTED, LVNI_SELECTED);
			CString strSrcFile = m_ctlInputFileList.GetItemText(nItem, FILEINFOS_FILEPATH);

			//文件名分割
			TCHAR szDir[_MAX_DIR] = {0};
			TCHAR szDrive[_MAX_DRIVE] = {0};
			TCHAR szName[_MAX_FNAME] = {0};
			TCHAR szExt[_MAX_EXT] = {0};
			_tsplitpath(strSrcFile, szDrive, szDir, szName, szExt);

			CString strDstPath;
			strDstPath.Format(_T("%s%s%s%s_dec"), szDrive, szDir, szName, szExt);

			BOOL bRet = ProcessFile(strSrcFile, strDstPath, FALSE, nItem);
			if (!bRet)
			{
				//设置列表控件
				CString strTextInfo;
				strTextInfo.Format(_T("%s"), _T("失败"));
				m_ctlInputFileList.SetItemText(nItem, FILEINFOS_STATUS, strTextInfo);
			}
		}
	}
}

/*===================================================================
* 函数:		WinIntegrated
* 参数:		strRegName 菜单在注册表中的目录名字，只要不与已有的冲突即可
			strShowName 在右键菜单中显示的名字,
			strCmdFile 菜单执行时所调用程序的绝对文件名
* 功能:		集成菜单到目录鼠标右键
* 说明:		执行成功返回TRUE，否则返回FALSE
* 时间:		2007/2/25
* 作者:		罗燕华
====================================================================*/
BOOL CAutoDecDlg::WinIntegrated(CString strRegName, CString strMenuName, CString strCmdFile)
{
	CReg regInfo(HKEY_CLASSES_ROOT);

	if (!regInfo.VerifyKey(_T("Folder\\shell\\") + strRegName))
	{
		if (!regInfo.CreateKey(_T("Folder\\shell\\") + strRegName))
		{
			return FALSE;
		}
	}

	if (!regInfo.Write(_T(""), strMenuName))
	{
		return FALSE;
	}

	if (!regInfo.VerifyKey(_T("Folder\\shell\\") + strRegName + _T("\\command")))
	{
		if (!regInfo.CreateKey(_T("Folder\\shell\\") + strRegName + _T("\\command")))
		{
			return FALSE;
		}
	}
	
	CString strRegCommand = _T("\"") + strCmdFile + _T("\"") + _T(" \"") + _T("%1") + _T("\"");
	if (!regInfo.Write(_T(""), strRegCommand))
	{
		return FALSE;
	}
	
	return TRUE;
}

/*===================================================================
* 函数:		WinIntegrated
* 参数:		strRegName 菜单在注册表中的目录名字，只要不与已有的冲突即可
			strMenuName 在右键菜单中显示的名字,
			strCmdFile 菜单执行时所调用程序的绝对文件名
			strFileExt 要集成菜单的文件扩展名(不带点号)
			strFileTypeDetail 如果文件没有程序与之关联时，集成后在注册表中的文件类型描述
* 功能:		集成菜单到文件鼠标右键
* 说明:		执行成功返回TRUE，否则返回FALSE
* 时间:		2007/2/25
* 作者:		罗燕华
====================================================================*/
BOOL CAutoDecDlg::WinIntegrated(CString strRegName, CString strMenuName, CString strCmdFile, CString strFileExt, CString strFileTypeDetail)
{
	CReg regInfo(HKEY_CLASSES_ROOT);
	CString strRegKey(_T(""));
	
	if (!regInfo.VerifyKey(_T(".") + strFileExt))
	{
		if (!regInfo.CreateKey(_T(".") + strFileExt))
		{
			return FALSE;
		}
		
		if (!regInfo.Write(_T(""), strFileTypeDetail))
		{
			return FALSE;
		}

		strRegKey = strFileTypeDetail;
	}
	else
	{
		if (!regInfo.Read(_T(""), strRegKey))
		{
			return FALSE;
		}
	}
	
	if (!regInfo.VerifyKey(strRegKey + _T("\\Shell\\") + strRegName))
	{
		if (!regInfo.CreateKey(strRegKey + _T("\\Shell\\") + strRegName))
		{
			return FALSE;
		}
	}
	
	if (!regInfo.Write(_T(""), strMenuName))
	{
		return FALSE;
	}

	if (!regInfo.VerifyKey(strRegKey + _T("\\Shell\\") + strRegName + _T("\\command")))
	{
		if (!regInfo.CreateKey(strRegKey + _T("\\Shell\\") + strRegName + _T("\\command")))
		{
			return FALSE;
		}
	}

	CString strRegCommand = _T("\"") + strCmdFile + _T("\"") + _T(" \"") + _T("%1") + _T("\"");
	if (!regInfo.Write(_T(""), strRegCommand))
	{
		return FALSE;
	}

	return TRUE;
}

/*===================================================================
* 函数:		GetAppFullName
* 参数:
* 功能:		获取程序名(包括完整路径)
* 说明:		返回值即为程序名
* 时间:		2007/2/25
* 作者:		罗燕华
====================================================================*/
CString CAutoDecDlg::GetAppFullName()
{
	HMODULE module = GetModuleHandle(NULL);
	
	TCHAR buf[MAX_PATH] = {0};
	GetModuleFileName(module, buf, sizeof(buf));
	CString strAppName = CString(buf);
	
	return strAppName;
}

/*===================================================================
* 函数:		UnWinIntegrated
* 参数:		strRegName 菜单在注册表中的目录名字
* 功能:		卸载鼠标右键集成菜单
* 说明:		执行成功返回TRUE，否则返回FALSE
* 时间:		2007/2/25
* 作者:		罗燕华
====================================================================*/
BOOL CAutoDecDlg::UnWinIntegrated(CString strRegName)
{
	if (SHDeleteKey(HKEY_CLASSES_ROOT, _T("Folder\\Shell\\") + strRegName) != ERROR_SUCCESS)
	{
		return FALSE;
	}

	return TRUE;
}

/*===================================================================
* 函数:		UnWinIntegrated
* 参数:		strRegName 菜单在注册表中的目录名字
			strFileExt 要卸载集成菜单的文件扩展名(不带点号)
* 功能:		卸载鼠标右键集成菜单
* 说明:		执行成功返回TRUE，否则返回FALSE
* 时间:		2007/2/25
* 作者:		罗燕华
====================================================================*/
BOOL CAutoDecDlg::UnWinIntegrated(CString strRegName, CString strFileExt)
{
	CString strRegKey;
	CReg regInfo(HKEY_CLASSES_ROOT);

	if (!regInfo.VerifyKey(_T(".") + strFileExt))
	{
		return FALSE;
	}
	
	if (!regInfo.Read(_T(""), strRegKey))
	{
		return FALSE;
	}
	
	if (SHDeleteKey(HKEY_CLASSES_ROOT, strRegKey + _T("\\Shell\\") + strRegName) != ERROR_SUCCESS)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CAutoDecDlg::CheckInterStatus()
{
	// TODO: 在此添加控件通知处理程序代码
	CString m_strAutoDecA3X = _T("Autoit3 A3X Decompiler");
	CString m_strAutoDecEXE = _T("Autoit3 EXE Decompiler");
	CString m_strAutoDecPath = _T("Autoit3 PATH Decompiler");

	BOOL bFolderIntegrated = FALSE;
	BOOL bExeIntegrated = FALSE;
	BOOL bA3XIntegrated = FALSE;

	CString strRegKey(_T(""));
	CReg regInfo(HKEY_CLASSES_ROOT);

	//检测是否集成到目录右键菜单
	bFolderIntegrated = regInfo.VerifyKey(_T("Folder\\Shell\\") + m_strAutoDecPath + _T("\\command"));

	//检测是否集成到*.exe文件右键菜单
	if (regInfo.VerifyKey(_T(".exe")))
	{
		regInfo.Read(_T(""), strRegKey);
		bExeIntegrated = regInfo.VerifyKey(strRegKey + _T("\\Shell\\") + m_strAutoDecEXE + _T("\\command"));
		strRegKey.Empty();
	}

	//检测是否集成到*.a3x文件右键菜单
	if (regInfo.VerifyKey(_T(".a3x")))
	{
		regInfo.Read(_T(""), strRegKey);
		bA3XIntegrated = regInfo.VerifyKey(strRegKey + _T("\\Shell\\") + m_strAutoDecA3X + _T("\\command"));
		strRegKey.Empty();
	}

	return (bExeIntegrated && bA3XIntegrated && bFolderIntegrated);
}

void CAutoDecDlg::OnBnClickedBtnAddtomenu()
{
	// TODO: 在此添加控件通知处理程序代码
	CString m_strAutoDecA3X = _T("Autoit3 A3X Decompiler");
	CString m_strAutoDecEXE = _T("Autoit3 EXE Decompiler");
	CString m_strAutoDecPath = _T("Autoit3 PATH Decompiler");

	if (CheckInterStatus())
	{
		UnWinIntegrated(m_strAutoDecPath);
		UnWinIntegrated(m_strAutoDecEXE, _T("exe"));
		UnWinIntegrated(m_strAutoDecA3X, _T("a3x"));
	}
	else
	{
		BOOL bPath = WinIntegrated(m_strAutoDecPath, _T("Autoit3 Decompile"), GetAppFullName());
		BOOL bExe = WinIntegrated(m_strAutoDecEXE, _T("Autoit3 Decompile"), GetAppFullName(), _T("exe"), _T("应用程序"));
		BOOL bA3X = WinIntegrated(m_strAutoDecA3X, _T("Autoit3 Decompile"), GetAppFullName(), _T("a3x"), _T("Autoit3编译数据"));
		if (!bPath || !bExe || !bA3X)
		{
			AfxMessageBox(_T("菜单集成失败，请检查是否具有相关权限！"), MB_OK | MB_ICONSTOP);
		}
	}

	if (!CheckInterStatus())
	{
		GetDlgItem(IDC_BTN_ADDTOMENU)->SetWindowText(_T("右键关联"));
	}
	else
	{
		GetDlgItem(IDC_BTN_ADDTOMENU)->SetWindowText(_T("取消右键"));
	}
}

void CAutoDecDlg::DoPreview(CAutoDecDlg *pThis, BYTE *lpBuffer, DWORD dwSize, BOOL bUnicode)
{
	//跳过UNICODE的两字节标识
	BYTE *lpNewPtr = new BYTE[dwSize + 2];
	ZeroMemory(lpNewPtr, dwSize + 2);
	CopyMemory(lpNewPtr, lpBuffer, dwSize);

	BYTE *lpTextBuf = lpNewPtr;
	if (bUnicode)
	{
		lpTextBuf += 2;
		::SetDlgItemTextW(pThis->m_hWnd, IDC_EDIT_PREVIEW, (WCHAR *)lpTextBuf);
	}
	else
	{
		::SetDlgItemTextA(pThis->m_hWnd, IDC_EDIT_PREVIEW, (CHAR *)lpTextBuf);
	}

	delete[] lpNewPtr;
}

BOOL CAutoDecDlg::ProcessFile(LPCTSTR lpszSrcFile, LPCTSTR lpszDstPath, BOOL bPreview, int nItem)
{
	HANDLE hFileAuto = CreateFile(lpszSrcFile, 
		GENERIC_READ, 
		FILE_SHARE_READ, 
		NULL, 
		OPEN_EXISTING, 
		FILE_ATTRIBUTE_NORMAL, 
		NULL);
	if (INVALID_HANDLE_VALUE == hFileAuto)
	{
		return FALSE;
	}

	DWORD dwFileTotalSize = GetFileSize(hFileAuto, NULL);
	BYTE *lpFileBuf = new BYTE[dwFileTotalSize];

	DWORD dwRead = 0;
	BOOL bRet = ReadFile(hFileAuto, lpFileBuf, dwFileTotalSize, &dwRead, NULL);
	CloseHandle(hFileAuto);
	if (!bRet || dwFileTotalSize != dwRead)
	{
		delete[] lpFileBuf;
		return FALSE;
	}

	bRet = FALSE;
	HANDLE hAutoHandle = AUTOIT_Init(lpFileBuf, dwFileTotalSize);
	if (NULL != hAutoHandle)
	{
		CALLBACK_CONTENT_INGUI content = {0};
		content.bPreview = bPreview;
		content.pThis = this;
		content.lpszSavePath = lpszDstPath;
		content.nItem = nItem;
		bRet = AUTOIT_DoDecompile(hAutoHandle, &CAutoDecDlg::ProcessDecompiledData, (DWORD)&content);
		AUTOIT_UnInit(hAutoHandle);
	}

	delete[] lpFileBuf;

	return bRet;
}

void CAutoDecDlg::OnBnClickedBtnSelall()
{
	// TODO: 在此添加控件通知处理程序代码
	int nItemCount = m_ctlInputFileList.GetItemCount();
	if (0 == nItemCount)
	{
		return;
	}

	for (int nItem=0; nItem<nItemCount; nItem++)
	{
		m_ctlInputFileList.SetCheck(nItem, TRUE);
	}
}

void CAutoDecDlg::OnBnClickedBtnSelrev()
{
	// TODO: 在此添加控件通知处理程序代码
	BOOL bCheckStat = FALSE;
	int nItemCount = m_ctlInputFileList.GetItemCount();
	if (0 == nItemCount)
	{
		return;
	}

	for (int nItem=0; nItem<nItemCount; nItem++)
	{
		bCheckStat = !m_ctlInputFileList.GetCheck(nItem);
		m_ctlInputFileList.SetCheck(nItem, bCheckStat);
	}
}

void CAutoDecDlg::OnBnClickedBtnClean()
{
	// TODO: 在此添加控件通知处理程序代码
	BOOL bCheckStat = FALSE;
	int nItemCount = m_ctlInputFileList.GetItemCount();
	if (0 == nItemCount)
	{
		return;
	}

	for (int nItem=0; nItem<nItemCount; nItem++)
	{
		AUTOIT3_DECINFORMATIONS *lpInfoPtr = (AUTOIT3_DECINFORMATIONS *)m_ctlInputFileList.GetItemData(nItem);
		if (NULL != lpInfoPtr)
		{
			delete lpInfoPtr;
			m_ctlInputFileList.SetItemData(nItem, NULL);
		}
	}

	m_ctlInputFileList.DeleteAllItems();

	nItemCount = m_ctlDecompiledFileList.GetItemCount();
	for (int nItem=0; nItem<nItemCount; nItem++)
	{
		DECOMPILED_FILEBUFFER_INFO *lpInfo = (DECOMPILED_FILEBUFFER_INFO *)m_ctlDecompiledFileList.GetItemData(nItem);
		if (NULL != lpInfo)
		{
			if (NULL != lpInfo->lpBuffer)
			{
				delete[] lpInfo->lpBuffer;
			}

			delete lpInfo;
			m_ctlDecompiledFileList.SetItemData(nItem, NULL);
		}
	}

	m_ctlDecompiledFileList.DeleteAllItems();

	SetButtonStatus();
}

void CAutoDecDlg::OnNMClickListFileinfos(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMITEMACTIVATE pNMItemActivate = reinterpret_cast<LPNMITEMACTIVATE>(pNMHDR);
	// TODO: 在此添加控件通知处理程序代码
	*pResult = 0;

	//OnBnClickedBtnPreview();
}

void CAutoDecDlg::OnNMDblclkListFileinfos(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMITEMACTIVATE pNMItemActivate = reinterpret_cast<LPNMITEMACTIVATE>(pNMHDR);
	*pResult = 0;
	
	//双击预览
	/*双击时不用处理了
	// TODO: 在此添加控件通知处理程序代码
	POSITION pos = m_ctlInputFileList.GetFirstSelectedItemPosition();
	int nItem = m_ctlInputFileList.GetNextSelectedItem(pos);
	if (0xFFFFFFFF == nItem)
	{
		return;
	}

	CString strFilePath = m_ctlInputFileList.GetItemText(nItem, FILEINFOS_FILEPATH);
	if (strFilePath.IsEmpty())
	{
		return;
	}

	CString strCmd;
	strCmd.Format(_T("explorer /n, /select, %s"), strFilePath);

	TCHAR szCommand[MAX_PATH + 20] = {0};
	lstrcpy(szCommand, strCmd);

	STARTUPINFO si = {0};
	PROCESS_INFORMATION pi = {0};
	BOOL bRet = CreateProcess(NULL, szCommand, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
	if (bRet)
	{
		CloseHandle(pi.hProcess);
		CloseHandle(pi.hThread);
	}
	*/
}

void CAutoDecDlg::OnDestroy()
{
	CDialog::OnDestroy();

	// TODO: 在此处添加消息处理程序代码
	OnBnClickedBtnClean();
}

void CAutoDecDlg::DoDecompilePreview()
{
	// TODO: 在此添加控件通知处理程序代码
	SetDlgItemText(IDC_EDIT_PREVIEW, _T(""));

	POSITION pos = m_ctlInputFileList.GetFirstSelectedItemPosition();
	int nItem = m_ctlInputFileList.GetNextSelectedItem(pos);
	if (0xFFFFFFFF == nItem)
	{
		return;
	}

	CString strFilePath = m_ctlInputFileList.GetItemText(nItem, FILEINFOS_FILEPATH);
	if (strFilePath.IsEmpty())
	{
		return;
	}

	BOOL bRet = ProcessFile(strFilePath, NULL, TRUE, nItem);
	if (!bRet)
	{
		SetDlgItemText(IDC_EDIT_PREVIEW, _T("反编译失败,无法预览!"));
	}
}

int CAutoDecDlg::GetFileIconIndex(LPCTSTR lpszPath)
{
	DWORD dwValue = FILE_ATTRIBUTE_NORMAL;

	DWORD dwAttrib = ::GetFileAttributes(lpszPath);
	if (INVALID_FILE_ATTRIBUTES != dwAttrib)
	{
		if (dwAttrib & FILE_ATTRIBUTE_DIRECTORY)
		{
			dwValue = FILE_ATTRIBUTE_DIRECTORY;
		}
	}

	SHFILEINFO sfi = {0};
	SHGetFileInfo(lpszPath, 
		dwValue, 
		&sfi, 
		sizeof(sfi), 
		SHGFI_LARGEICON | SHGFI_SYSICONINDEX |
		SHGFI_USEFILEATTRIBUTES | SHGFI_OPENICON);

	return sfi.iIcon;
}

//处理编译后的数据,DEMO版过滤了只创建脚本文件
BOOL CAutoDecDlg::ProcessDecompiledData(AUTOIT3_DECINFORMATIONS *lpDecInfos, DWORD dwContent)
{
	//回调上下文
	CALLBACK_CONTENT_INGUI *lpContent = (CALLBACK_CONTENT_INGUI *)dwContent;

	//界面控件的文件识别信息处理
	if (NULL != lpContent->pThis->m_hWnd)
	{
		UINT nItem = lpContent->nItem;
		CListCtrl *lpctlFileList = &(lpContent->pThis->m_ctlInputFileList);

		CString strTextInfo;

		//反编译模式才处理
		if (!lpContent->bPreview)
		{
			//成功状态
			strTextInfo.Format(_T("%s"), _T("成功"));
			lpctlFileList->SetItemText(nItem, FILEINFOS_STATUS, strTextInfo);
		}

		//文件格式
		strTextInfo.Format(_T("%s"), lpDecInfos->bA3XFormat ? _T("A3X") : _T("EXE"));
		lpctlFileList->SetItemText(nItem, FILEINFOS_FILEFORMAT, strTextInfo);

		//编译器版本
		USES_CONVERSION;
		CString strVer = A2W(lpDecInfos->szAutoitVer); 
		strTextInfo.Format(_T("%s"), strVer);
		lpctlFileList->SetItemText(nItem, FILEINFOS_VERINFO, strTextInfo);

		CString strPwd = A2W(lpDecInfos->szPassword); 
		strTextInfo.Format(_T("%s"), strPwd);
		lpctlFileList->SetItemText(nItem, FILEINFOS_PASSWORD, strTextInfo);

		strTextInfo.Format(_T("%s"), lpDecInfos->bScriptUnicode ? _T("UNICODE") : _T("ANSI"));
		lpctlFileList->SetItemText(nItem, FILEINFOS_UNICODE, strTextInfo);

		strTextInfo.Format(_T("%s"), lpDecInfos->bX64 ? _T("X64") : _T("X86"));
		lpctlFileList->SetItemText(nItem, FILEINFOS_X64PLATFORM, strTextInfo);
	}

	if (lpContent->pThis->m_bDetect)
	{
		return TRUE;
	}

	//模式判断
	if (lpContent->bPreview)
	{
		USES_CONVERSION;
		CString strReleasePath;
		if (lpDecInfos->bPathUnicode)
		{
			strReleasePath = (WCHAR *)lpDecInfos->szReleasePath;	
		}
		else
		{
			strReleasePath = A2W((CHAR *)lpDecInfos->szReleasePath); 
		}

		//预览模式,处理界面文件列表显示信息
		CListCtrl *lpctlDecompiledFileList = &(lpContent->pThis->m_ctlDecompiledFileList);
		if (NULL != lpctlDecompiledFileList->m_hWnd)
		{
			int nIcon = GetFileIconIndex(strReleasePath);
			if (lpDecInfos->bScript)
			{
				nIcon = GetFileIconIndex(_T("script.au3"));
			}

			lpctlDecompiledFileList->InsertItem(lpDecInfos->dwFileIndex, NULL, nIcon);

			CString strIndex;
#if 1
			lpctlDecompiledFileList->SetItemText(lpDecInfos->dwFileIndex, 0, strReleasePath);

			strIndex.Format(_T("%04d"), lpDecInfos->dwFileIndex);
			lpctlDecompiledFileList->SetItemText(lpDecInfos->dwFileIndex, 1, strIndex);

			CString strSizeInfo;
			strSizeInfo.Format(_T("%d"), lpDecInfos->dwResultSize);
			lpctlDecompiledFileList->SetItemText(lpDecInfos->dwFileIndex, 2, strSizeInfo);
#else
			//设置反编译后的文件路径信息
			lpctlDecompiledFileList->SetItemText(lpDecInfos->dwFileIndex, 0, strReleasePath);
#endif
			//将内容COPY出来进行保存
			DECOMPILED_FILEBUFFER_INFO *lpInfo = new DECOMPILED_FILEBUFFER_INFO;
			ZeroMemory(lpInfo, sizeof(DECOMPILED_FILEBUFFER_INFO));
			lpInfo->bUnicode = lpDecInfos->bScriptUnicode;
			lpInfo->bScript = lpDecInfos->bScript;
			lpInfo->dwSize = lpDecInfos->dwResultSize;
			lpInfo->lpBuffer = NULL;

			lpInfo->lpBuffer = new BYTE[lpInfo->dwSize + 2];
			ZeroMemory(lpInfo->lpBuffer, lpInfo->dwSize + 2);
			CopyMemory(lpInfo->lpBuffer, lpDecInfos->lpResultBuf, lpInfo->dwSize);
			lpctlDecompiledFileList->SetItemData(lpDecInfos->dwFileIndex, (DWORD)lpInfo);
		}
	}
	else
	{
		//检测目录是否存在
		if (!PathFileExists(lpContent->lpszSavePath))
		{
			//创建存储目录
			int nResult = SHCreateDirectoryEx(NULL, lpContent->lpszSavePath, NULL);
			if (ERROR_SUCCESS != nResult)
			{
				return FALSE;
			}
		}

		//脚本的处理
		if (lpDecInfos->bScript)
		{
			//写入的文件名
			CString strFileName;
			strFileName.Format(_T("%s\\%04d.au3"), lpContent->lpszSavePath, lpDecInfos->dwFileIndex);

			//将内容输出到文件
			HANDLE hFileOut = CreateFile(strFileName, 
				GENERIC_WRITE, 
				FILE_SHARE_WRITE, 
				NULL, 
				CREATE_ALWAYS,
				FILE_ATTRIBUTE_NORMAL, 
				NULL);
			if (INVALID_HANDLE_VALUE != hFileOut)
			{
				DWORD dwWrite = 0;
				BOOL bRet = WriteFile(hFileOut, lpDecInfos->lpResultBuf, lpDecInfos->dwResultSize, &dwWrite, NULL);
				if (!bRet || lpDecInfos->dwResultSize != dwWrite)
				{
					DeleteFile(strFileName);
				}

				CloseHandle(hFileOut);
			}
		}
		else
		{
			//非脚本的二进制处理
			//写入的文件名
			CString strFileName;
			strFileName.Format(_T("%s\\%04d.bin"), lpContent->lpszSavePath, lpDecInfos->dwFileIndex);

			//输出到文件
			HANDLE hFileOut = CreateFile(strFileName, 
				GENERIC_WRITE, 
				FILE_SHARE_WRITE, 
				NULL, 
				CREATE_ALWAYS,
				FILE_ATTRIBUTE_NORMAL, 
				NULL);
			if (INVALID_HANDLE_VALUE != hFileOut)
			{
				DWORD dwWrite = 0;
				BOOL bRet = WriteFile(hFileOut, lpDecInfos->lpResultBuf, lpDecInfos->dwResultSize, &dwWrite, NULL);
				if (!bRet || lpDecInfos->dwResultSize != dwWrite)
				{
					DeleteFile(lpContent->lpszSavePath);
				}

				CloseHandle(hFileOut);
			}
		}

		//反编译信息文件的处理
		CString strInfoFile;
		strInfoFile.Format(_T("%s\\%04d_decinfo.txt"), lpContent->lpszSavePath, lpDecInfos->dwFileIndex);
		HANDLE hInfoFile = CreateFile(strInfoFile, 
			GENERIC_WRITE, 
			FILE_SHARE_WRITE, 
			NULL, 
			CREATE_ALWAYS,
			FILE_ATTRIBUTE_NORMAL, 
			NULL);
		if (INVALID_HANDLE_VALUE != hInfoFile)
		{
			DWORD dwWrite = 0;
			DWORD dwPathByteSize = 0;
			if (lpDecInfos->bPathUnicode)
			{
				BYTE cbHeader[2] = {0xFF, 0xFE};
				WriteFile(hInfoFile, cbHeader, 2, &dwWrite, NULL);

				WCHAR *lpInfoBeginW = L"Release path in autoit3:\r\n";
				WriteFile(hInfoFile, lpInfoBeginW, lstrlenW(lpInfoBeginW)*sizeof(WCHAR), &dwWrite, NULL);

				WCHAR *lpPathW = (WCHAR *)lpDecInfos->szReleasePath;
				dwPathByteSize = lstrlenW(lpPathW) * sizeof(WCHAR);
			}
			else
			{
				CHAR *lpInfoBeginA = "Release path in autoit3:\r\n";
				WriteFile(hInfoFile, lpInfoBeginA, lstrlenA(lpInfoBeginA)*sizeof(CHAR), &dwWrite, NULL);

				CHAR *lpPathA = (CHAR *)lpDecInfos->szReleasePath;
				dwPathByteSize = lstrlenA((lpPathA)) * sizeof(CHAR);
			}

			BOOL bRet = WriteFile(hInfoFile, lpDecInfos->szReleasePath, dwPathByteSize, &dwWrite, NULL);
			if (!bRet || dwPathByteSize != dwWrite)
			{
				DeleteFile(strInfoFile);
			}

			CloseHandle(hInfoFile);
		}
	}

	return TRUE;
}

void CAutoDecDlg::OnBnClickedBtnAbout()
{
	// TODO: 在此添加控件通知处理程序代码
	CAboutRetailDlg dlg;
	dlg.DoModal();
}

void CAutoDecDlg::OnBnClickedBtnDeccurrent()
{
	// TODO: 在此添加控件通知处理程序代码
	POSITION pos = m_ctlInputFileList.GetFirstSelectedItemPosition();
	int nItem = m_ctlInputFileList.GetNextSelectedItem(pos);
	if (0xFFFFFFFF == nItem)
	{
		return;
	}

	CString strSrcFile = m_ctlInputFileList.GetItemText(nItem, FILEINFOS_FILEPATH);
	if (strSrcFile.IsEmpty())
	{
		return;
	}

	//文件名分割
	TCHAR szDir[_MAX_DIR] = {0};
	TCHAR szDrive[_MAX_DRIVE] = {0};
	TCHAR szName[_MAX_FNAME] = {0};
	TCHAR szExt[_MAX_EXT] = {0};
	_tsplitpath(strSrcFile, szDrive, szDir, szName, szExt);

	CString strDstPath;
	strDstPath.Format(_T("%s%s%s%s_dec"), szDrive, szDir, szName, szExt);

	BOOL bRet = ProcessFile(strSrcFile, strDstPath, FALSE, nItem);
	if (!bRet)
	{
		//设置列表控件
		CString strTextInfo;
		strTextInfo.Format(_T("%s"), _T("失败"));
		m_ctlInputFileList.SetItemText(nItem, FILEINFOS_STATUS, strTextInfo);
	}
}

void CAutoDecDlg::OnBnClickedOk()
{
	// TODO: 在此添加控件通知处理程序代码
	OnOK();
}

void CAutoDecDlg::OnBnClickedBtnDelselect()
{
	// TODO: 在此添加控件通知处理程序代码
	int nLastItem = 0;
	do 
	{
		int nItemCount = m_ctlInputFileList.GetItemCount();
		if (0 == nItemCount)
		{
			break;
		}

		BOOL bCheckStat = FALSE;
		for (int nItem=0; nItem<nItemCount; nItem++)
		{
			bCheckStat = m_ctlInputFileList.GetCheck(nItem);
			if (bCheckStat)
			{
				m_ctlInputFileList.DeleteItem(nItem);
				if (nItem != 0)
				{
					nLastItem = nItem - 1;
				}

				break;
			}
		}

		if (!bCheckStat)
		{
			break;
		}
	} while (TRUE);

	m_ctlInputFileList.SetItemState(nLastItem, LVIS_SELECTED|LVIS_FOCUSED, LVIS_SELECTED | LVIS_FOCUSED);
	SetButtonStatus();
}

void CAutoDecDlg::SetButtonStatus()
{
	BOOL bStatus =  (0 != m_ctlInputFileList.GetItemCount());
	GetDlgItem(IDC_BTN_DECOMPILE)->EnableWindow(bStatus);
	//GetDlgItem(IDC_BTN_DECCURRENT)->EnableWindow(bStatus);
	GetDlgItem(IDC_BTN_SELALL)->EnableWindow(bStatus);
	GetDlgItem(IDC_BTN_SELREV)->EnableWindow(bStatus);
	//GetDlgItem(IDC_BTN_DELSELECT)->EnableWindow(bStatus);
	GetDlgItem(IDC_BTN_CLEAN)->EnableWindow(bStatus);
	GetDlgItem(IDC_BTN_DELCURRENT)->EnableWindow(bStatus);
}

void CAutoDecDlg::OnBnClickedBtnDelcurrent()
{
	// TODO: 在此添加控件通知处理程序代码
	POSITION pos = m_ctlInputFileList.GetFirstSelectedItemPosition();
	int nItem = m_ctlInputFileList.GetNextSelectedItem(pos);
	if (0xFFFFFFFF == nItem)
	{
		return;
	}

	AUTOIT3_DECINFORMATIONS *lpInfoPtr = (AUTOIT3_DECINFORMATIONS *)m_ctlInputFileList.GetItemData(nItem);
	if (NULL != lpInfoPtr)
	{
		delete lpInfoPtr;
		m_ctlInputFileList.SetItemData(nItem, NULL);
	}

	m_ctlInputFileList.DeleteItem(nItem);
	if (nItem != 0)
	{
		nItem = nItem - 1;
	}
	m_ctlInputFileList.SetItemState(nItem, LVIS_SELECTED|LVIS_FOCUSED, LVIS_SELECTED | LVIS_FOCUSED);
	SetButtonStatus();
}

void CAutoDecDlg::OnLvnItemchangedListFileinfos(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	// TODO: 在此添加控件通知处理程序代码
	*pResult = 0;
	SetDlgItemText(IDC_EDIT_PREVIEW, _T(""));

	if ((pNMLV->uOldState & LVIS_SELECTED) && !(pNMLV->uNewState & LVIS_SELECTED))
	{
		//失去焦点
		int nItemCount = m_ctlDecompiledFileList.GetItemCount();
		for (int nItem=0; nItem<nItemCount; nItem++)
		{
			DECOMPILED_FILEBUFFER_INFO *lpInfo = (DECOMPILED_FILEBUFFER_INFO *)m_ctlDecompiledFileList.GetItemData(nItem);
			if (NULL != lpInfo)
			{
				if (NULL != lpInfo->lpBuffer)
				{
					delete[] lpInfo->lpBuffer;
				}

				delete lpInfo;
				m_ctlDecompiledFileList.SetItemData(nItem, NULL);
			}
		}

		m_ctlDecompiledFileList.DeleteAllItems();
		GetDlgItem(IDC_BTN_DECCURRENT)->EnableWindow(FALSE);
		GetDlgItem(IDC_BTN_DELSELECT)->EnableWindow(FALSE);
	}
	else if (!(pNMLV->uOldState & LVIS_SELECTED) && (pNMLV->uNewState & LVIS_SELECTED))
	{
		//获得焦点
		GetDlgItem(IDC_BTN_DECCURRENT)->EnableWindow(TRUE);
		GetDlgItem(IDC_BTN_DELSELECT)->EnableWindow(TRUE);

		int nItem = pNMLV->iItem;
		CString strFilePath = m_ctlInputFileList.GetItemText(nItem, FILEINFOS_FILEPATH);
		if (strFilePath.IsEmpty())
		{
			return;
		}

		BOOL bRet = ProcessFile(strFilePath, NULL, TRUE, nItem);
		if (!bRet)
		{
			SetDlgItemText(IDC_EDIT_PREVIEW, _T("反编译失败,无法预览!"));
		}
	}
}

void CAutoDecDlg::OnLvnItemchangedListFilelist(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	// TODO: 在此添加控件通知处理程序代码
	*pResult = 0;
	SetDlgItemText(IDC_EDIT_PREVIEW, _T(""));
	
	int nItem = pNMLV->iItem;
	if (!(pNMLV->uOldState & LVIS_SELECTED) && (pNMLV->uNewState & LVIS_SELECTED))
	{
		//获得焦点
		DECOMPILED_FILEBUFFER_INFO *lpInfo = (DECOMPILED_FILEBUFFER_INFO *)m_ctlDecompiledFileList.GetItemData(nItem);
		if (NULL != lpInfo)
		{
			if (lpInfo->bScript)
			{
				//脚本预览处理
				BYTE *lpTextBuf = lpInfo->lpBuffer;
				if (NULL != lpTextBuf)
				{
					if (lpInfo->bUnicode)
					{
						//跳过UNICODE的两字节标识
						lpTextBuf += 2;
						::SetDlgItemTextW(m_hWnd, IDC_EDIT_PREVIEW, (WCHAR *)lpTextBuf);
					}
					else
					{
						::SetDlgItemTextA(m_hWnd, IDC_EDIT_PREVIEW, (CHAR *)lpTextBuf);
					}
				}
			}
			else
			{
				//文件预览处理
				//HEX显示文件内容
				if (NULL != lpInfo->lpBuffer)
				{
					TCHAR *lpBufFileText = new TCHAR[lpInfo->dwSize * 8];
					ZeroMemory(lpBufFileText, lpInfo->dwSize * 8);
					ConvertHex2String(lpInfo->lpBuffer, lpInfo->dwSize, lpBufFileText, FALSE);
					SetDlgItemText(IDC_EDIT_PREVIEW, lpBufFileText);
					delete[] lpBufFileText;
				}
			}
		}
	}
}