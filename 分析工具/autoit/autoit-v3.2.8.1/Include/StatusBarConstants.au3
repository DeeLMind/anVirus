#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Language:       English
; Description:    StatusBar Constants.
;
; ------------------------------------------------------------------------------

Global Const $CCS_TOP = 0x1
Global Const $CCS_NOMOVEY = 0x2
Global Const $CCS_BOTTOM = 0x3
Global Const $CCS_NORESIZE = 0x4
Global Const $CCS_NOPARENTALIGN = 0x8
Global Const $CCS_NOHILITE = 0x10
Global Const $CCS_ADJUSTABLE = 0x20
Global Const $CCS_NODIVIDER = 0x40
;=== Status Bar Styles
Global Const $SBARS_SIZEGRIP = 0x100
Global Const $SBT_TOOLTIPS = 0x800
;=== uFlags
Global Const $SBT_SUNKEN = 0x0;Default
Global Const $SBT_NOBORDERS = 0x100;The text is drawn without borders.
Global Const $SBT_POPOUT = 0x200; The text is drawn with a border to appear higher than the plane of the window.
Global Const $SBT_RTLREADING = 0x400;SB_SETTEXT, SB_SETTEXT, SB_GETTEXTLENGTH flags only: Displays text using right-to-left reading order on Hebrew or Arabic systems.
Global Const $SBT_OWNERDRAW = 0x1000;The text is drawn by the parent window.
;=== Messages to send to Statusbar
Global Const $SB_GETPARTS = 0x406
Global Const $SB_GETBORDERS = (0x400 + 7)
Global Const $SB_GETICON = (0x400 + 20)
Global Const $SB_GETRECT = (0x400 + 10)
Global Const $SB_GETTEXT = 0x402
Global Const $SB_GETTEXTLENGTH = 0x403
Global Const $SB_GETTIPTEXT = (0x400 + 18)

Global Const $SB_GETUNICODEFORMAT = (0x2000 + 6)

Global Const $SB_SETBKCOLOR = (0x2000 + 1)
Global Const $SB_SETICON = (0x400 + 15)
Global Const $SB_SETMINHEIGHT = 0x408
Global Const $SB_SETPARTS = 0x404
Global Const $SB_SETTEXT = 0x401
Global Const $SB_SETTIPTEXT = (0x400 + 16)
Global Const $SB_SETUNICODEFORMAT = (0x2000 + 5)

Global Const $SB_SIMPLE = 0x409
Global Const $SB_SIMPLEID = 0xff
Global Const $SB_ISSIMPLE = 0x40E

; scroll constants
Global Const $SB_LINEDOWN = 1
Global Const $SB_LINEUP = 0
Global Const $SB_PAGEDOWN = 3
Global Const $SB_PAGEUP = 2
Global Const $SB_SCROLLCARET = 4
