#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    ListView Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $LVS_ICON	 			= 0x0000
Global Const $LVS_REPORT 			= 0x0001
Global Const $LVS_SMALLICON			= 0x0002
Global Const $LVS_LIST				= 0x0003
Global Const $LVS_EDITLABELS		= 0x0200
Global Const $LVS_NOCOLUMNHEADER	= 0x4000
Global Const $LVS_NOSORTHEADER		= 0x8000
Global Const $LVS_SINGLESEL			= 0x0004
Global Const $LVS_SHOWSELALWAYS		= 0x0008
Global Const $LVS_SORTASCENDING		= 0X0010
Global Const $LVS_SORTDESCENDING	= 0x0020
Global Const $LVS_NOLABELWRAP		= 0x0080

; listView Extended Styles
Global Const $LVS_EX_FULLROWSELECT		= 0x00000020
Global Const $LVS_EX_GRIDLINES			= 0x00000001
Global Const $LVS_EX_SUBITEMIMAGES		= 0x00000002
Global Const $LVS_EX_CHECKBOXES			= 0x00000004
Global Const $LVS_EX_TRACKSELECT		= 0x00000008
Global Const $LVS_EX_HEADERDRAGDROP		= 0x00000010
Global Const $LVS_EX_FLATSB				= 0x00000100
Global Const $LVS_EX_BORDERSELECT		= 0x00008000
;Global Const $LVS_EX_MULTIWORKAREAS		= 0x00002000
;Global Const $LVS_EX_SNAPTOGRID			= 0x00080000
;Global Const $LVS_EX_DOUBLEBUFFER		= 0x00010000
Global Const $LVS_EX_HIDELABELS = 0x20000
Global Const $LVS_EX_INFOTIP = 0x400
Global Const $LVS_EX_LABELTIP = 0x4000
Global Const $LVS_EX_ONECLICKACTIVATE = 0x40
Global Const $LVS_EX_REGIONAL = 0x200
Global Const $LVS_EX_SINGLEROW = 0x40000
Global Const $LVS_EX_TWOCLICKACTIVATE = 0x80
;~ Global Const $LVS_EX_TRACKSELECT = 0x8
Global Const $LVS_EX_UNDERLINEHOT = 0x800
Global Const $LVS_EX_UNDERLINECOLD = 0x1000

; error
Global Const $LV_ERR = -1


; Messages to send to listview
Global Const $CCM_FIRST = 0x2000
Global Const $CCM_GETUNICODEFORMAT = ($CCM_FIRST + 6)
Global Const $CCM_SETUNICODEFORMAT = ($CCM_FIRST + 5)
Global Const $CLR_NONE = 0xFFFFFFFF
Global Const $LVM_FIRST = 0x1000

Global Const $LV_VIEW_DETAILS = 0x1
Global Const $LV_VIEW_ICON = 0x0
Global Const $LV_VIEW_LIST = 0x3
Global Const $LV_VIEW_SMALLICON = 0x2
Global Const $LV_VIEW_TILE = 0x4

Global Const $LVCF_FMT = 0x1
Global Const $LVCF_WIDTH = 0x2
Global Const $LVCF_TEXT = 0x4
Global Const $LVCFMT_CENTER = 0x2
Global Const $LVCFMT_LEFT = 0x0
Global Const $LVCFMT_RIGHT = 0x1

Global Const $LVA_ALIGNLEFT = 0x1
Global Const $LVA_ALIGNTOP = 0x2
Global Const $LVA_DEFAULT = 0x0
Global Const $LVA_SNAPTOGRID = 0x5

Global Const $LVIF_STATE = 0x8
Global Const $LVIF_TEXT = 0x1

Global Const $LVFI_PARAM = 0x1
Global Const $LVFI_PARTIAL = 0x8
Global Const $LVFI_STRING = 0x2
Global Const $LVFI_WRAP = 0x20

Global Const $VK_LEFT = 0x25
Global Const $VK_RIGHT = 0x27
Global Const $VK_UP = 0x26
Global Const $VK_DOWN = 0x28
Global Const $VK_END = 0x23
Global Const $VK_PRIOR = 0x21
Global Const $VK_NEXT = 0x22

Global Const $LVIR_BOUNDS = 0

Global Const $LVIS_CUT = 0x4
Global Const $LVIS_DROPHILITED = 0x8
Global Const $LVIS_FOCUSED = 0x1
Global Const $LVIS_OVERLAYMASK = 0xF00
Global Const $LVIS_SELECTED = 0x2
Global Const $LVIS_STATEIMAGEMASK = 0xF000

Global Const $LVM_ARRANGE = ($LVM_FIRST + 22)
Global Const $LVM_CANCELEDITLABEL = ($LVM_FIRST + 179)
Global Const $LVM_DELETECOLUMN = 0x101C
Global Const $LVM_DELETEITEM = 0x1008
Global Const $LVM_DELETEALLITEMS = 0x1009
Global Const $LVM_EDITLABELA = ($LVM_FIRST + 23)
Global Const $LVM_EDITLABEL = $LVM_EDITLABELA
Global Const $LVM_ENABLEGROUPVIEW = ($LVM_FIRST + 157)
Global Const $LVM_ENSUREVISIBLE = ($LVM_FIRST + 19)
Global Const $LVM_FINDITEM = ($LVM_FIRST + 13)
Global Const $LVM_GETBKCOLOR = ($LVM_FIRST + 0)
Global Const $LVM_GETCALLBACKMASK = ($LVM_FIRST + 10)
Global Const $LVM_GETCOLUMNORDERARRAY = ($LVM_FIRST + 59)
Global Const $LVM_GETCOLUMNWIDTH = ($LVM_FIRST + 29)
Global Const $LVM_GETCOUNTPERPAGE = ($LVM_FIRST + 40)
Global Const $LVM_GETEDITCONTROL = ($LVM_FIRST + 24)
Global Const $LVM_GETEXTENDEDLISTVIEWSTYLE = ($LVM_FIRST + 55)
Global Const $LVM_GETHEADER = ($LVM_FIRST + 31)
Global Const $LVM_GETHOTCURSOR = ($LVM_FIRST + 63)
Global Const $LVM_GETHOTITEM = ($LVM_FIRST + 61)
Global Const $LVM_GETHOVERTIME = ($LVM_FIRST + 72)
Global Const $LVM_GETIMAGELIST = ($LVM_FIRST + 2)
Global Const $LVM_GETITEMA = ($LVM_FIRST + 5)
Global Const $LVM_GETITEMCOUNT = 0x1004
Global Const $LVM_GETITEMSTATE = ($LVM_FIRST + 44)
Global Const $LVM_GETITEMTEXTA = ($LVM_FIRST + 45);
Global Const $LVM_GETNEXTITEM = 0x100c
Global Const $LVM_GETSELECTEDCOLUMN = ($LVM_FIRST + 174)
Global Const $LVM_GETSELECTEDCOUNT = ($LVM_FIRST + 50)
Global Const $LVM_GETSUBITEMRECT = ($LVM_FIRST + 56);
Global Const $LVM_GETTOPINDEX = ($LVM_FIRST + 39)
Global Const $LVM_GETUNICODEFORMAT = $CCM_GETUNICODEFORMAT
Global Const $LVM_GETVIEW = ($LVM_FIRST + 143)
Global Const $LVM_GETVIEWRECT = ($LVM_FIRST + 34)
Global Const $LVM_INSERTCOLUMNA = ($LVM_FIRST + 27)
Global Const $LVM_INSERTITEMA = ($LVM_FIRST + 7)
Global Const $LVM_REDRAWITEMS = ($LVM_FIRST + 21)
Global Const $LVM_SETUNICODEFORMAT = $CCM_SETUNICODEFORMAT
Global Const $LVM_SCROLL = ($LVM_FIRST + 20)
Global Const $LVM_SETBKCOLOR = 0x1001
Global Const $LVM_SETCALLBACKMASK = ($LVM_FIRST + 11)
Global Const $LVM_SETCOLUMNA = ($LVM_FIRST + 26)
Global Const $LVM_SETCOLUMNORDERARRAY = ($LVM_FIRST + 58)
Global Const $LVM_SETCOLUMNWIDTH = 0x101E
Global Const $LVM_SETEXTENDEDLISTVIEWSTYLE = 0x1036
Global Const $LVM_SETHOTITEM = ($LVM_FIRST + 60)
Global Const $LVM_SETHOVERTIME = ($LVM_FIRST + 71)
Global Const $LVM_SETICONSPACING = ($LVM_FIRST + 53)
Global Const $LVM_SETITEMCOUNT = ($LVM_FIRST + 47)
Global Const $LVM_SETITEMPOSITION = ($LVM_FIRST + 15)
Global Const $LVM_SETITEMSTATE = ($LVM_FIRST + 43)
Global Const $LVM_SETITEMTEXTA = ($LVM_FIRST + 46)
Global Const $LVM_SETSELECTEDCOLUMN = ($LVM_FIRST + 140)
Global Const $LVM_SETTEXTCOLOR = ($LVM_FIRST + 36)
Global Const $LVM_SETTEXTBKCOLOR = ($LVM_FIRST + 38)
Global Const $LVM_SETVIEW = ($LVM_FIRST + 142)
Global Const $LVM_UPDATE = ($LVM_FIRST + 42)

Global Const $LVNI_ABOVE = 0x100
Global Const $LVNI_BELOW = 0x200
Global Const $LVNI_TOLEFT = 0x400
Global Const $LVNI_TORIGHT = 0x800
Global Const $LVNI_ALL = 0x0
Global Const $LVNI_CUT = 0x4
Global Const $LVNI_DROPHILITED = 0x8
Global Const $LVNI_FOCUSED = 0x1
Global Const $LVNI_SELECTED = 0x2

Global Const $LVSCW_AUTOSIZE = -1
Global Const $LVSCW_AUTOSIZE_USEHEADER = -2

Global Const $LVSICF_NOINVALIDATEALL = 0x1
Global Const $LVSICF_NOSCROLL = 0x2

Global Const $LVSIL_NORMAL = 0
Global Const $LVSIL_SMALL = 1
Global Const $LVSIL_STATE = 2
