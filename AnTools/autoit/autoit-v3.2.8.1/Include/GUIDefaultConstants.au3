#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Language:       English
; Description:    AutoIt-GUI default control styles.
;
; ------------------------------------------------------------------------------

#include <WindowsConstants.au3>
#include <AVIConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ListBoxConstants.au3>
#include <ListViewConstants.au3>
#include <SliderConstants.au3>
#include <TreeViewConstants.au3>
#include <UpDownConstants.au3>

; Control default styles
Global Const $GUI_SS_DEFAULT_AVI		= $ACS_TRANSPARENT
Global Const $GUI_SS_DEFAULT_BUTTON		= 0
Global Const $GUI_SS_DEFAULT_CHECKBOX	= 0
Global Const $GUI_SS_DEFAULT_COMBO		= BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $WS_VSCROLL)
Global Const $GUI_SS_DEFAULT_DATE		= $DTS_LONGDATEFORMAT
Global Const $GUI_SS_DEFAULT_EDIT		= BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL)
Global Const $GUI_SS_DEFAULT_GRAPHIC	= 0
Global Const $GUI_SS_DEFAULT_GROUP		= 0
Global Const $GUI_SS_DEFAULT_ICON		= $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_INPUT		= BitOR($ES_LEFT, $ES_AUTOHSCROLL)
Global Const $GUI_SS_DEFAULT_LABEL		= 0
Global Const $GUI_SS_DEFAULT_LIST		= BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY)
Global Const $GUI_SS_DEFAULT_LISTVIEW	= BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL)
Global Const $GUI_SS_DEFAULT_MONTHCAL	= 0
Global Const $GUI_SS_DEFAULT_PIC		= $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_PROGRESS	= 0
Global Const $GUI_SS_DEFAULT_RADIO		= 0
Global Const $GUI_SS_DEFAULT_SLIDER		= $TBS_AUTOTICKS
Global Const $GUI_SS_DEFAULT_TAB		= 0
Global Const $GUI_SS_DEFAULT_TREEVIEW	= BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS)
Global Const $GUI_SS_DEFAULT_UPDOWN		= $UDS_ALIGNRIGHT
Global Const $GUI_SS_DEFAULT_GUI		= BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
