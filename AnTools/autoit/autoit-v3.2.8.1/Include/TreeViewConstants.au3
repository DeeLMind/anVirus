#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    TreeView Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $TVS_HASBUTTONS     	= 0x0001
Global Const $TVS_HASLINES       	= 0x0002
Global Const $TVS_LINESATROOT    	= 0x0004
;Global Const $TVS_EDITLABELS      = 0x0008
Global Const $TVS_DISABLEDRAGDROP	= 0x0010
Global Const $TVS_SHOWSELALWAYS		= 0x0020
;Global Const $TVS_RTLREADING     = 0x0040
Global Const $TVS_NOTOOLTIPS		= 0x0080
Global Const $TVS_CHECKBOXES		= 0x0100
Global Const $TVS_TRACKSELECT		= 0x0200
Global Const $TVS_SINGLEEXPAND		= 0x0400
;Global Const $TVS_INFOTIP        = 0x0800
Global Const $TVS_FULLROWSELECT		= 0x1000
Global Const $TVS_NOSCROLL			= 0x2000
Global Const $TVS_NONEVENHEIGHT		= 0x4000

Global Const $TVE_COLLAPSE			= 0x0001
Global Const $TVE_EXPAND			= 0x0002
Global Const $TVE_TOGGLE			= 0x0003
Global Const $TVE_EXPANDPARTIAL		= 0x4000
Global Const $TVE_COLLAPSERESET = 0x8000

Global Const $TVGN_ROOT				= 0x0000
Global Const $TVGN_NEXT				= 0x0001
Global Const $TVGN_PARENT			= 0x0003
Global Const $TVGN_CHILD			= 0x0004
Global Const $TVGN_CARET			= 0x0009

Global Const $TVI_ROOT				= 0xFFFF0000
Global Const $TVI_FIRST				= 0xFFFF0001
Global Const $TVI_LAST				= 0xFFFF0002
Global Const $TVI_SORT				= 0xFFFF0003

Global Const $TVIF_TEXT = 0x0001
Global Const $TVIF_IMAGE			= 0x0002
Global Const $TVIF_PARAM			= 0x0004
Global Const $TVIF_STATE			= 0x0008
Global Const $TVIF_HANDLE			= 0x0010
Global Const $TVIF_SELECTEDIMAGE	= 0x0020
Global Const $TVIF_CHILDREN			= 0x0040

Global Const $TVIS_SELECTED			= 0x0002
Global Const $TVIS_CUT				= 0x0004
Global Const $TVIS_DROPHILITED		= 0x0008
Global Const $TVIS_BOLD				= 0x0010
Global Const $TVIS_EXPANDED			= 0x0020
Global Const $TVIS_EXPANDEDONCE		= 0x0040
Global Const $TVIS_EXPANDPARTIAL	= 0x0080
Global Const $TVIS_OVERLAYMASK		= 0x0F00
Global Const $TVIS_STATEIMAGEMASK = 0xF000

; Messages to send to TreeView
Global Const $TV_FIRST				= 0x1100
Global Const $TVM_INSERTITEM		= $TV_FIRST + 0
Global Const $TVM_DELETEITEM		= $TV_FIRST + 1
Global Const $TVM_EXPAND			= $TV_FIRST + 2
Global Const $TVM_GETCOUNT			= $TV_FIRST + 5
Global Const $TVM_GETINDENT			= $TV_FIRST + 6
Global Const $TVM_SETINDENT			= $TV_FIRST + 7
Global Const $TVM_GETIMAGELIST		= $TV_FIRST + 8
Global Const $TVM_SETIMAGELIST		= $TV_FIRST + 9
Global Const $TVM_GETNEXTITEM		= $TV_FIRST + 10
Global Const $TVM_SELECTITEM		= $TV_FIRST + 11
Global Const $TVM_GETITEM			= $TV_FIRST + 12
Global Const $TVM_SETITEM			= $TV_FIRST + 13
Global Const $TVM_SORTCHILDREN		= $TV_FIRST + 19
Global Const $TVM_ENSUREVISIBLE		= $TV_FIRST + 20
Global Const $TVM_SETBKCOLOR		= $TV_FIRST + 29
Global Const $TVM_SETTEXTCOLOR		= $TV_FIRST + 30
Global Const $TVM_GETBKCOLOR		= $TV_FIRST + 31
Global Const $TVM_GETTEXTCOLOR		= $TV_FIRST + 32
Global Const $TVM_SETLINECOLOR		= $TV_FIRST + 40
Global Const $TVM_GETLINECOLOR		= $TV_FIRST + 41
