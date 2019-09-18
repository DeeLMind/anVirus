#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    Slider Constants
;
; ------------------------------------------------------------------------------

; Styles
Global Const $TBS_AUTOTICKS	= 0x0001
Global Const $TBS_VERT		= 0x0002
Global Const $TBS_HORZ		= 0x0000
Global Const $TBS_TOP		= 0x0004
Global Const $TBS_BOTTOM	= 0x0000
Global Const $TBS_LEFT		= 0x0004
Global Const $TBS_RIGHT		= 0x0000
Global Const $TBS_BOTH		= 0x0008
Global Const $TBS_NOTICKS	= 0x0010
Global Const $TBS_NOTHUMB	= 0x0080

; Messages
Global Const $TWM_USER = 0x400	; WM_USER
Global Const $TBM_CLEARTICS = ($TWM_USER + 9)
Global Const $TBM_GETLINESIZE = ($TWM_USER + 24)
Global Const $TBM_GETPAGESIZE = ($TWM_USER + 22)
Global Const $TBM_GETNUMTICS = ($TWM_USER + 16)
Global Const $TBM_GETPOS = $TWM_USER
Global Const $TBM_GETRANGEMAX = ($TWM_USER + 2)
Global Const $TBM_GETRANGEMIN = ($TWM_USER + 1)
Global Const $TBM_SETLINESIZE = ($TWM_USER + 23)
Global Const $TBM_SETPAGESIZE = ($TWM_USER + 21)
Global Const $TBM_SETPOS = ($TWM_USER + 5)
Global Const $TBM_SETTICFREQ = ($TWM_USER + 20)
