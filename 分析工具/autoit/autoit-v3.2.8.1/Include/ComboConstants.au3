#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    ComboBox constants.
;
; ------------------------------------------------------------------------------
; Combo
Global Const $CBS_SIMPLE			= 0x0001
Global Const $CBS_DROPDOWN			= 0x0002
Global Const $CBS_DROPDOWNLIST		= 0x0003
Global Const $CBS_AUTOHSCROLL		= 0x0040
Global Const $CBS_OEMCONVERT		= 0x0080
Global Const $CBS_SORT				= 0x0100
Global Const $CBS_NOINTEGRALHEIGHT	= 0x0400
Global Const $CBS_DISABLENOSCROLL	= 0x0800
Global Const $CBS_UPPERCASE			= 0x2000
Global Const $CBS_LOWERCASE			= 0x4000

; Error checking
Global Const $CB_ERR = -1
Global Const $CB_ERRATTRIBUTE = -3
Global Const $CB_ERRREQUIRED = -4
Global Const $CB_ERRSPACE = -2
Global Const $CB_OKAY = 0

; Messages to send to combobox
Global Const $CB_ADDSTRING = 0x143
Global Const $CB_DELETESTRING = 0x144
Global Const $CB_DIR = 0x145
Global Const $CB_FINDSTRING = 0x14C
Global Const $CB_FINDSTRINGEXACT = 0x158
Global Const $CB_GETCOUNT = 0x146
Global Const $CB_GETCURSEL = 0x147
Global Const $CB_GETDROPPEDCONTROLRECT = 0x152
Global Const $CB_GETDROPPEDSTATE = 0x157
Global Const $CB_GETDROPPEDWIDTH = 0X15f
Global Const $CB_GETEDITSEL = 0x140
Global Const $CB_GETEXTENDEDUI = 0x156
Global Const $CB_GETHORIZONTALEXTENT = 0x15d
Global Const $CB_GETITEMDATA = 0x150
Global Const $CB_GETITEMHEIGHT = 0x154
Global Const $CB_GETLBTEXT = 0x148
Global Const $CB_GETLBTEXTLEN = 0x149
Global Const $CB_GETLOCALE = 0x15A
Global Const $CB_GETMINVISIBLE = 0x1702
Global Const $CB_GETTOPINDEX = 0x15b
Global Const $CB_INITSTORAGE = 0x161
Global Const $CB_LIMITTEXT = 0x141
Global Const $CB_RESETCONTENT = 0x14B
Global Const $CB_INSERTSTRING = 0x14A
Global Const $CB_SELECTSTRING = 0x14D
Global Const $CB_SETCURSEL = 0x14E
Global Const $CB_SETDROPPEDWIDTH = 0x160
Global Const $CB_SETEDITSEL = 0x142
Global Const $CB_SETEXTENDEDUI = 0x155
Global Const $CB_SETHORIZONTALEXTENT = 0x15e
Global Const $CB_SETITEMDATA = 0x151
Global Const $CB_SETITEMHEIGHT = 0x153
Global Const $CB_SETLOCALE = 0x15
Global Const $CB_SETMINVISIBLE = 0x1701
Global Const $CB_SETTOPINDEX = 0x15c
Global Const $CB_SHOWDROPDOWN = 0x14F

; attributes
Global Const $CB_DDL_ARCHIVE = 0x20
Global Const $CB_DDL_DIRECTORY = 0x10
Global Const $CB_DDL_DRIVES = 0x4000
Global Const $CB_DDL_EXCLUSIVE = 0x8000
Global Const $CB_DDL_HIDDEN = 0x2
Global Const $CB_DDL_READONLY = 0x1
Global Const $CB_DDL_READWRITE = 0x0
Global Const $CB_DDL_SYSTEM = 0x4
