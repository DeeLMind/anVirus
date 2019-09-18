#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Language:       English
; Description:    Edit Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $ES_LEFT				= 0
Global Const $ES_CENTER				= 1
Global Const $ES_RIGHT				= 2
Global Const $ES_MULTILINE			= 4
Global Const $ES_UPPERCASE			= 8
Global Const $ES_LOWERCASE			= 16
Global Const $ES_PASSWORD			= 32
Global Const $ES_AUTOVSCROLL		= 64
Global Const $ES_AUTOHSCROLL		= 128
Global Const $ES_NOHIDESEL			= 256
Global Const $ES_OEMCONVERT			= 1024
Global Const $ES_READONLY			= 2048
Global Const $ES_WANTRETURN			= 4096
Global Const $ES_NUMBER				= 8192
;Global Const $ES_DISABLENOSCROLL = 8192
;Global Const $ES_SUNKEN = 16384
;Global Const $ES_VERTICAL = 4194304
;Global Const $ES_SELECTIONBAR = 16777216

; Error checking
Global Const $EC_ERR = -1

; Messages to send to edit control
Global Const $ECM_FIRST = 0X1500
Global Const $EM_CANUNDO = 0xC6
Global Const $EM_EMPTYUNDOBUFFER = 0xCD
Global Const $EM_GETFIRSTVISIBLELINE = 0xCE
Global Const $EM_GETLINE = 0xC4
Global Const $EM_GETLINECOUNT = 0xBA
Global Const $EM_GETMODIFY = 0xB8
Global Const $EM_GETRECT = 0xB2
Global Const $EM_GETSEL = 0xB0
Global Const $EM_LINEFROMCHAR = 0xC9
Global Const $EM_LINEINDEX = 0xBB
Global Const $EM_LINELENGTH = 0xC1
Global Const $EM_LINESCROLL = 0xB6
Global Const $EM_REPLACESEL = 0xC2
Global Const $EM_SCROLL = 0xB5
Global Const $EM_SCROLLCARET = 0x00B7
Global Const $EM_SETMODIFY = 0xB9
Global Const $EM_SETSEL = 0xB1
Global Const $EM_UNDO = 0xC7
Global Const $EM_SETREADONLY = 0x00CF
Global Const $EM_SETTABSTOPS = 0x00CB
