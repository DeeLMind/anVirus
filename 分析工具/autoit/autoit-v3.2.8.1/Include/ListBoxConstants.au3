#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    ListBox Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $LBS_NOTIFY			= 0x0001
Global Const $LBS_SORT				= 0x0002
Global Const $LBS_USETABSTOPS		= 0x0080
Global Const $LBS_NOINTEGRALHEIGHT	= 0x0100
Global Const $LBS_DISABLENOSCROLL	= 0x1000
Global Const $LBS_NOSEL				= 0x4000
Global Const $LBS_STANDARD			= 0xA00003

; Errors
Global Const $LB_ERR = -1
Global Const $LB_ERRATTRIBUTE = -3
Global Const $LB_ERRREQUIRED = -4
Global Const $LB_ERRSPACE = -2

; Messages to send to listbox
Global Const $LB_ADDSTRING = 0x180
Global Const $LB_DELETESTRING = 0x182
Global Const $LB_DIR = 0x18D
Global Const $LB_FINDSTRING = 0x18F
Global Const $LB_FINDSTRINGEXACT = 0x1A2
Global Const $LB_GETANCHORINDEX = 0x019D
Global Const $LB_GETCARETINDEX = 0x019F
Global Const $LB_GETCOUNT = 0x18B
Global Const $LB_GETCURSEL = 0x188
Global Const $LB_GETHORIZONTALEXTENT = 0x193
Global Const $LB_GETITEMRECT = 0x198
Global Const $LB_GETLISTBOXINFO = 0x01B2
Global Const $LB_GETLOCALE = 0x1A6
Global Const $LB_GETSEL = 0x0187
Global Const $LB_GETSELCOUNT = 0x0190
Global Const $LB_GETSELITEMS = 0X191
Global Const $LB_GETTEXT = 0x0189
Global Const $LB_GETTEXTLEN = 0x018A
Global Const $LB_GETTOPINDEX = 0x018E
Global Const $LB_INSERTSTRING = 0x181
Global Const $LB_RESETCONTENT = 0x184
Global Const $LB_SELECTSTRING = 0x18C
Global Const $LB_SETITEMHEIGHT = 0x1A0
Global Const $LB_SELITEMRANGE = 0x19B
Global Const $LB_SELITEMRANGEEX = 0x0183
Global Const $LB_SETANCHORINDEX = 0x19C
Global Const $LB_SETCARETINDEX = 0x19E
Global Const $LB_SETCURSEL = 0x186
Global Const $LB_SETHORIZONTALEXTENT = 0x194
Global Const $LB_SETLOCALE = 0x1A5
Global Const $LB_SETSEL = 0x0185
Global Const $LB_SETTOPINDEX = 0x197

Global Const $LBS_MULTIPLESEL = 0x8

; attributes
Global Const $DDL_ARCHIVE = 0x20
Global Const $DDL_DIRECTORY = 0x10
Global Const $DDL_DRIVES = 0x4000
Global Const $DDL_EXCLUSIVE = 0x8000
Global Const $DDL_HIDDEN = 0x2
Global Const $DDL_READONLY = 0x1
Global Const $DDL_READWRITE = 0x0
Global Const $DDL_SYSTEM = 0x4
