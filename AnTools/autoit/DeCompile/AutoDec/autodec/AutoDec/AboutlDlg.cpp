// AboutlDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "AutoDec.h"
#include "AboutlDlg.h"


// CAboutRetailDlg 对话框

IMPLEMENT_DYNAMIC(CAboutRetailDlg, CDialog)

CAboutRetailDlg::CAboutRetailDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CAboutRetailDlg::IDD, pParent)
{

}

CAboutRetailDlg::~CAboutRetailDlg()
{
}

void CAboutRetailDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CAboutRetailDlg, CDialog)
END_MESSAGE_MAP()


// CAboutRetailDlg 消息处理程序

BOOL CAboutRetailDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// TODO:  在此添加额外的初始化
	CString strVersion;
	strVersion = CString(_T("Build:")) + CString(__TIMESTAMP__);
	SetDlgItemText(IDC_STATIC_VERSION, strVersion);

	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常: OCX 属性页应返回 FALSE
}
