#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    Tab Constants.
;
; ------------------------------------------------------------------------------
; Styles
Global Const $TCS_SCROLLOPPOSITE	= 0x0001
Global Const $TCS_BOTTOM			= 0x0002
Global Const $TCS_RIGHT				= 0x0002
Global Const $TCS_MULTISELECT		= 0x0004
Global Const $TCS_FLATBUTTONS		= 0x0008
Global Const $TCS_FORCEICONLEFT		= 0x0010
Global Const $TCS_FORCELABELLEFT	= 0x0020
Global Const $TCS_HOTTRACK			= 0x0040
Global Const $TCS_VERTICAL			= 0x0080
Global Const $TCS_TABS				= 0x0000
Global Const $TCS_BUTTONS			= 0x0100
Global Const $TCS_SINGLELINE		= 0x0000
Global Const $TCS_MULTILINE			= 0x0200
Global Const $TCS_RIGHTJUSTIFY		= 0x0000
Global Const $TCS_FIXEDWIDTH		= 0x0400
Global Const $TCS_RAGGEDRIGHT		= 0x0800
Global Const $TCS_FOCUSONBUTTONDOWN = 0x1000
Global Const $TCS_OWNERDRAWFIXED	= 0x2000
Global Const $TCS_TOOLTIPS			= 0x4000
Global Const $TCS_FOCUSNEVER		= 0x8000

; Tab Extended Styles
Global Const $TCS_EX_FLATSEPARATORS 	= 0x1
;Global Const $TCS_EX_REGISTERDROP 		= 0x2

; Error checking
Global Const $TC_ERR = -1

; event(s)
Global Const $TCIS_BUTTONPRESSED = 0x1

; extended styles
;~ Global Const $TCS_EX_FLATSEPARATORS = 0x1
Global Const $TCS_EX_REGISTERDROP = 0x2

; Messages to send to Tab control
Global Const $TCM_FIRST = 0x1300
Global Const $TCM_DELETEALLITEMS = ($TCM_FIRST + 9)
Global Const $TCM_DELETEITEM = ($TCM_FIRST + 8)
Global Const $TCM_DESELECTALL = ($TCM_FIRST + 50)
Global Const $TCM_GETCURFOCUS = ($TCM_FIRST + 47)
Global Const $TCM_GETCURSEL = ($TCM_FIRST + 11)
Global Const $TCM_GETEXTENDEDSTYLE = ($TCM_FIRST + 53)
Global Const $TCM_GETITEMCOUNT = ($TCM_FIRST + 4)
Global Const $TCM_GETITEMRECT = ($TCM_FIRST + 10)
Global Const $TCM_GETROWCOUNT = ($TCM_FIRST + 44)
Global Const $TCM_SETITEMSIZE = $TCM_FIRST + 41

Global Const $TCCM_FIRST = 0X2000
Global Const $TCCM_GETUNICODEFORMAT = ($TCCM_FIRST + 6)
Global Const $TCM_GETUNICODEFORMAT = $TCCM_GETUNICODEFORMAT

Global Const $TCM_HIGHLIGHTITEM = ($TCM_FIRST + 51)
Global Const $TCM_SETCURFOCUS = ($TCM_FIRST + 48)
Global Const $TCM_SETCURSEL = ($TCM_FIRST + 12)
Global Const $TCM_SETMINTABWIDTH = ($TCM_FIRST + 49)
Global Const $TCM_SETPADDING = ($TCM_FIRST + 43)

Global Const $TCCM_SETUNICODEFORMAT = ($TCCM_FIRST + 5)
Global Const $TCM_SETUNICODEFORMAT = $TCCM_SETUNICODEFORMAT

Global Const $TCN_FIRST = -550
Global Const $TCN_SELCHANGE = ($TCN_FIRST - 1)
Global Const $TCN_SELCHANGING = ($TCN_FIRST - 2)
