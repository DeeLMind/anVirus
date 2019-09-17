// AutoDecDlg.h : 头文件
//

#pragma once
#include "afxcmn.h"


// CAutoDecDlg 对话框
class CAutoDecDlg : public CDialog
{
// 构造
public:
	CAutoDecDlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
	enum { IDD = IDD_AUTODEC_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	void CAutoDecDlg::InitInputFileListCtl();
	void CAutoDecDlg::InitDecompiledFileListCtl();
	afx_msg void OnDropFiles(HDROP hDropInfo);

	DWORD AddFilesByPath(LPCTSTR lpszFileDir, BOOL bIncludeSub, LPCTSTR lpszFileExt);
	DWORD AddFilesByFileName(LPCTSTR lpszFileName);

private:
	enum
	{
		FILEINFOS_INDEX		= 0,	//列表索引
		FILEINFOS_STATUS,			//处理状态
		FILEINFOS_FILEPATH,			//文件路径

		FILEINFOS_FILEFORMAT,		//文件格式(是否编译后的A3X数据)
		FILEINFOS_VERINFO,			//版本信息(不一定有)
		FILEINFOS_PASSWORD,			//加密密码(不一定有)
		FILEINFOS_UNICODE,			//UNICODE标识
		FILEINFOS_X64PLATFORM,		//64位平台
	};

	CListCtrl m_ctlInputFileList;
	CListCtrl m_ctlDecompiledFileList;

	BOOL m_bDetect;

public:
	typedef struct _CALLBACK_CONTENT_INGUI
	{
		CAutoDecDlg *pThis;
		BOOL bPreview;
		LPCTSTR lpszSavePath;
		int nItem;
	}CALLBACK_CONTENT_INGUI, *PCALLBACK_CONTENT_INGUI;

	afx_msg void OnBnClickedBtnDecompile();
	afx_msg void OnBnClickedBtnAddtomenu();
	
	afx_msg void OnBnClickedBtnSelall();
	afx_msg void OnBnClickedBtnSelrev();
	afx_msg void OnBnClickedBtnClean();

	//反编译后保存到界面控件的信息
	typedef struct _DECOMPILED_FILEBUFFER_INFO
	{
		BOOL bScript;	//是否脚本
		BOOL bUnicode;	//为脚本时是否UNICODE编码
		BYTE *lpBuffer;	//缓冲指针
		DWORD dwSize;	//缓冲大小
	}DECOMPILED_FILEBUFFER_INFO, *PDECOMPILED_FILEBUFFER_INFO;

	static BOOL ProcessDecompiledData(AUTOIT3_DECINFORMATIONS *lpDecInfos, DWORD dwContent);
	static void DoPreview(CAutoDecDlg *pThis, BYTE *lpBuffer, DWORD dwSize, BOOL bUnicode);

	typedef void (*PREVIEW_CALLFUN)(CAutoDecDlg *pThis, BYTE *lpBuffer, DWORD dwSize, BOOL bUnicode);
	typedef struct _PREVIEW_CALLCONTENT 
	{
		DWORD dwContent;
		PREVIEW_CALLFUN lpfnCallFun;
	}PREVIEW_CALLCONTENT, *PPREVIEW_CALLCONTENT;

	static int GetFileIconIndex(LPCTSTR lpszPath);

	//这里传递的是保存目录
	BOOL ProcessFile(LPCTSTR lpszSrcFile, LPCTSTR lpszDstPath, BOOL bPreview, int nItem);

	void SetButtonStatus();
	BOOL CheckInterStatus();	//检测集成状态
	CString GetAppFullName();	//获当前实例完整路径

	//卸载WINDOWS菜单集成
	BOOL UnWinIntegrated(CString strRegName);	
	BOOL UnWinIntegrated(CString strRegName, CString strFileExt);

	//WINDOWS菜单集成
	BOOL WinIntegrated(CString strRegName, CString strMenuName, CString strCmdFile);
	BOOL WinIntegrated(CString strRegName, CString strMenuName, CString strCmdFile, CString strFileExt, CString strFileTypeDetail);
	afx_msg void OnNMClickListFileinfos(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMDblclkListFileinfos(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnDestroy();
	void DoDecompilePreview();
	afx_msg void OnBnClickedBtnAbout();
	afx_msg void OnBnClickedBtnDeccurrent();
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedBtnDelselect();
	afx_msg void OnBnClickedBtnDelcurrent();
	afx_msg void OnLvnItemchangedListFileinfos(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLvnItemchangedListFilelist(NMHDR *pNMHDR, LRESULT *pResult);
};
