#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    Windows constants.
;
; ------------------------------------------------------------------------------

; Window Styles
Global Const $WS_TILED				= 0
Global Const $WS_OVERLAPPED 		= 0
Global Const $WS_MAXIMIZEBOX		= 0x00010000
Global Const $WS_MINIMIZEBOX		= 0x00020000
Global Const $WS_TABSTOP			= 0x00010000
Global Const $WS_GROUP				= 0x00020000
Global Const $WS_SIZEBOX			= 0x00040000
Global Const $WS_THICKFRAME			= 0x00040000
Global Const $WS_SYSMENU			= 0x00080000
Global Const $WS_HSCROLL			= 0x00100000
Global Const $WS_VSCROLL			= 0x00200000
Global Const $WS_DLGFRAME 			= 0x00400000
Global Const $WS_BORDER				= 0x00800000
Global Const $WS_CAPTION			= 0x00C00000
Global Const $WS_OVERLAPPEDWINDOW	= 0x00CF0000
Global Const $WS_TILEDWINDOW		= 0x00CF0000
Global Const $WS_MAXIMIZE			= 0x01000000
Global Const $WS_CLIPCHILDREN		= 0x02000000
Global Const $WS_CLIPSIBLINGS		= 0x04000000
Global Const $WS_DISABLED 			= 0x08000000
Global Const $WS_VISIBLE			= 0x10000000
Global Const $WS_MINIMIZE			= 0x20000000
Global Const $WS_CHILD				= 0x40000000
Global Const $WS_POPUP				= 0x80000000
Global Const $WS_POPUPWINDOW		= 0x80880000

; Dialog Styles
Global Const $DS_MODALFRAME 		= 0x80
Global Const $DS_SETFOREGROUND		= 0x00000200
Global Const $DS_CONTEXTHELP		= 0x00002000

; Window Extended Styles
Global Const $WS_EX_ACCEPTFILES			= 0x00000010
Global Const $WS_EX_MDICHILD			= 0x00000040
Global Const $WS_EX_APPWINDOW			= 0x00040000
Global Const $WS_EX_CLIENTEDGE			= 0x00000200
Global Const $WS_EX_CONTEXTHELP			= 0x00000400
Global Const $WS_EX_DLGMODALFRAME 		= 0x00000001
Global Const $WS_EX_LEFTSCROLLBAR 		= 0x00004000
Global Const $WS_EX_OVERLAPPEDWINDOW	= 0x00000300
Global Const $WS_EX_RIGHT				= 0x00001000
Global Const $WS_EX_STATICEDGE			= 0x00020000
Global Const $WS_EX_TOOLWINDOW			= 0x00000080
Global Const $WS_EX_TOPMOST				= 0x00000008
Global Const $WS_EX_TRANSPARENT			= 0x00000020
Global Const $WS_EX_WINDOWEDGE			= 0x00000100
Global Const $WS_EX_LAYERED				= 0x00080000

; Messages
Global Const $WM_SIZE = 0x05
Global Const $WM_SIZING = 0x0214
Global Const $WM_USER = 0X400
Global Const $WM_GETTEXTLENGTH = 0x000E
Global Const $WM_GETTEXT = 0x000D
