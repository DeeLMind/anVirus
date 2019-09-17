#pragma once


// CAboutRetailDlg 对话框

class CAboutRetailDlg : public CDialog
{
	DECLARE_DYNAMIC(CAboutRetailDlg)

public:
	CAboutRetailDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CAboutRetailDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX_RETAIL };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
};
