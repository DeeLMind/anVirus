; *******************************************************
; Example 1 - Open a browser with the basic example page, insert an
;				event script into the head of the document that creates
;				a JavaScript alert when someone clicks on the document
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IEHeadInsertEventScript ($oIE, "document", "onclick", "alert('Someone clicked the document!');")

; *******************************************************
; Example 2 - Open a browser with the basic example page, insert an
;				event script into the head of the document that creates
;				a JavaScript alert when someone tries to right-click on the
;				document and then the event script returns "false" to prevent
;				the right-click context menu from appearing
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IEHeadInsertEventScript ($oIE, "document", "oncontextmenu", "alert('No Context Menu');return false")

; *******************************************************
; Example 3 - Open a browser with the basic example page, insert an
;				event script into the head of the document that creates a
;				JavaScript alert when we are about to navigate away from the 
;				page and presents the option to cancel the operation.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IEHeadInsertEventScript ($oIE, "window", "onbeforeunload", _
	"alert('Example warning follows...');return 'Pending changes may be lost';")
_IENavigate($oIE, "www.autoitscript.com")
